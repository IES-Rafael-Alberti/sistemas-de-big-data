# Laboratorio 5 — Streaming con Redpanda + Spark Structured Streaming

---

## 0. Objetivo del laboratorio

En este laboratorio vamos a trabajar con **datos en tiempo real** para entender tres ideas clave:

- distinguir procesamiento **batch** de procesamiento **streaming**
- publicar y consumir mensajes con **Redpanda** (compatible con Kafka)
- procesar un flujo continuo de datos con **Spark Structured Streaming**

La idea no es montar una arquitectura compleja, sino entender el flujo completo:

**fuente de datos → productor → tópico → consumidor → agregaciones**

---

## 1. Introducción al streaming

En **batch**, los datos se procesan por lotes: el archivo llega, se carga, se transforma y se guarda.

En **streaming**, los datos llegan de forma continua y la aplicación los procesa casi en tiempo real.

Conceptos básicos:

- **topic**: canal lógico donde se publican los mensajes
- **producer**: aplicación que envía mensajes al tópico
- **consumer**: aplicación que lee mensajes del tópico
- **broker**: servidor que almacena y distribuye los mensajes

Kafka y Redpanda usan este modelo. Redpanda es compatible con Kafka, así que para empezar nos sirve igual y suele ser más simple de levantar en local.

---

## 2. Arranque del entorno con Docker

Vamos a usar Docker para levantar Redpanda y dejar preparado Spark para pruebas.

### 2.1 `docker-compose.yml`

```yaml
version: '3.8'
services:
  redpanda:
    image: docker.redpanda.com/vectorized/redpanda:latest
    command:
      - redpanda start
      - --smp 1
      - --memory 1G
      - --reserve-memory 0
      - --overprovisioned
      - --node-id 0
      - --kafka-addr PLAINTEXT://0.0.0.0:29092,OUTSIDE://0.0.0.0:9092
      - --advertise-kafka-addr PLAINTEXT://redpanda:29092,OUTSIDE://localhost:9092
    ports:
      - "9092:9092"
      - "29092:29092"
    volumes:
      - redpanda-data:/var/lib/redpanda/data

  spark:
    image: bitnami/spark:latest
    command: ["sleep", "infinity"]
    depends_on:
      - redpanda

volumes:
  redpanda-data:
```

### 2.2 Arrancar los servicios

```bash
docker compose up -d
```

Comprobar que Redpanda está activo:

```bash
docker ps
```

---

## 3. Crear el tópico

Usamos `rpk`, la CLI de Redpanda, dentro del contenedor:

```bash
docker exec -it streaming-redpanda-1 rpk topic create ventas-stream --partitions 3
```

Si el nombre del contenedor cambia, revisalo con `docker ps`.

---

## 4. Productor de datos en Python

Vamos a crear un productor que lea un CSV y vaya enviando una fila por segundo al tópico `ventas-stream`.

### 4.1 Script `streaming_producer.py`

```python
import argparse
import csv
import hashlib
import json
import logging
import random
import time
from datetime import datetime

from kafka import KafkaProducer


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)


def build_id_hash(fecha, ciudad, canal, importe, unidades):
    raw = f"{fecha}|{ciudad}|{canal}|{importe}|{unidades}"
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()


def parse_args():
    parser = argparse.ArgumentParser(description="Streaming producer for Redpanda/Kafka")
    parser.add_argument("--csv", help="Path to the CSV file to stream", default=None)
    parser.add_argument("--bootstrap-server", default="localhost:9092")
    parser.add_argument("--topic", default="ventas-stream")
    parser.add_argument("--delay", type=float, default=1.0)
    return parser.parse_args()


def random_row():
    fecha = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
    ciudad = random.choice(["Madrid", "Barcelona", "Valencia", "Sevilla", "Bilbao"])
    canal = random.choice(["tienda", "web", "telefono"])
    importe = round(random.uniform(10, 500), 2)
    unidades = random.randint(1, 10)
    return {
        "fecha": fecha,
        "ciudad": ciudad,
        "canal": canal,
        "importe": importe,
        "unidades": unidades,
        "id_hash": build_id_hash(fecha, ciudad, canal, importe, unidades),
    }


def csv_rows(csv_path):
    with open(csv_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield {
                "fecha": row.get("fecha", datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")),
                "ciudad": row.get("ciudad", "desconocida"),
                "canal": row.get("canal", "desconocido"),
                "importe": float(row.get("importe", 0) or 0),
                "unidades": int(float(row.get("unidades", 0) or 0)),
            }


def main():
    args = parse_args()

    producer = KafkaProducer(
        bootstrap_servers=args.bootstrap_server,
        value_serializer=lambda v: json.dumps(v).encode("utf-8"),
        key_serializer=lambda v: v.encode("utf-8") if v else None,
        retries=5,
        linger_ms=10,
    )

    logging.info("Connected to %s", args.bootstrap_server)

    try:
        rows = csv_rows(args.csv) if args.csv else None
        while True:
            if rows is None:
                payload = random_row()
            else:
                try:
                    payload = next(rows)
                    payload["id_hash"] = build_id_hash(
                        payload["fecha"], payload["ciudad"], payload["canal"],
                        payload["importe"], payload["unidades"]
                    )
                except StopIteration:
                    logging.info("CSV finished, restarting from beginning")
                    rows = csv_rows(args.csv)
                    continue

            key = payload["ciudad"]
            future = producer.send(args.topic, key=key, value=payload)
            metadata = future.get(timeout=10)
            logging.info("Sent message to %s partition=%s offset=%s", metadata.topic, metadata.partition, metadata.offset)
            time.sleep(args.delay)
    except KeyboardInterrupt:
        logging.info("Producer interrupted by user")
    except Exception as exc:
        logging.exception("Producer failed: %s", exc)
    finally:
        producer.flush()
        producer.close()


if __name__ == "__main__":
    main()
```

### 4.2 Explicación

- Si pasas `--csv`, lee el archivo fila a fila.
- Si no pasas CSV, genera datos aleatorios.
- Cada mensaje se serializa a JSON.
- `id_hash` sirve como identificador anónimo del registro.
- El envío se hace cada segundo para simular un flujo real.

---

## 5. Consumidor con Spark Structured Streaming

Ahora vamos a leer el tópico con Spark y hacer agregaciones en tiempo real.

### 5.1 Script `streaming_consumer.py`

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json, sum as _sum, avg as _avg, count
from pyspark.sql.types import DoubleType, IntegerType, StringType, StructField, StructType


schema = StructType([
    StructField("fecha", StringType(), True),
    StructField("ciudad", StringType(), True),
    StructField("canal", StringType(), True),
    StructField("importe", DoubleType(), True),
    StructField("unidades", IntegerType(), True),
    StructField("id_hash", StringType(), True),
])


spark = SparkSession.builder \
    .appName("SparkLab5-Streaming") \
    .getOrCreate()

spark.sparkContext.setLogLevel("WARN")

raw_stream = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "ventas-stream") \
    .option("startingOffsets", "latest") \
    .load()

parsed_stream = raw_stream.select(
    from_json(col("value").cast("string"), schema).alias("data")
).select("data.*")

aggregated = parsed_stream.groupBy("ciudad").agg(
    count("*").alias("num_ventas"),
    _sum("importe").alias("importe_total"),
    _avg("importe").alias("importe_medio"),
    _sum("unidades").alias("unidades_totales")
)

query = aggregated.writeStream \
    .outputMode("complete") \
    .format("console") \
    .option("truncate", "false") \
    .start()

query.awaitTermination()
```

### 5.2 Batch vs streaming DataFrames

- Un **DataFrame batch** representa un conjunto de datos cerrado.
- Un **DataFrame streaming** representa un flujo continuo que sigue creciendo.

En Spark, ambos se parecen mucho en la API, pero cambian la fuente y la forma de ejecución.

---

## 6. Ejercicios propuestos

1. Modificar el productor para que genere datos aleatorios en tiempo real, sin usar CSV.
2. Añadir una ventana temporal (**tumbling window**) a la agregación.
3. Cambiar el output a un archivo Parquet en lugar de consola.
4. ¿Qué pasa si detenemos el productor? ¿Y si lo reiniciamos?

---

## 7. Pregunta final

> ¿Cuándo usarías streaming en lugar de batch? Pon un ejemplo real.
