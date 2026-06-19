# Preparación del Laboratorio 1 de Spark
[]: # 2. Procesamiento distribuido con Spark (UD3)
[]: # 
[]: # En este laboratorio prepararemos un clúster Spark básico usando Docker Compose, y ejecutaremos un job PySpark sencillo para familiarizarnos con el entorno distribuido.
[]: # 
---

Sí, es **posible** y, de hecho, es una dinámica muy buena en aula: **un alumno hace de “Master”** y 2–3 compañeros se conectan como **Workers** desde sus portátiles. La clave es montar un **Spark Standalone “multi-máquina”** con Docker, cuidando **dos detalles**:

1. El **Master debe anunciar una IP alcanzable** por el resto (la IP LAN del portátil del “Master”).
2. Los **datos deben estar accesibles por todos los Workers** en la **misma ruta** (lo resolvemos copiando el CSV a cada máquina o tirando de Git).

Abajo tienes un “pack” A listo: **dos docker-compose** (Master/Worker), estructura de carpetas, pasos y un **job PySpark** “sin sustos”.

---

# A) Spark Standalone multi-máquina (1 Master + N Workers) con Docker Compose

## 0) Prerrequisitos (tú decides el nivel)

* Docker + Docker Compose en todas las máquinas.
* Todos en la **misma red LAN** (WiFi del centro o hotspot del profe).
* Conocer la IP del alumno que será Master (ej.: `192.168.1.50`).

> Nota rápida: si la red del centro bloquea tráfico LAN entre alumnos, esta variante no funcionará. En ese caso, mantienes el mismo enfoque pero en **una sola máquina** (un portátil potente) y los demás trabajan como “clientes”.

---

## 1) Estructura de proyecto (igual para todos)

Crea una carpeta y repártela por Git (o copia por ZIP):

```
ud3-spark-lab1/
  docker-compose.master.yml
  docker-compose.worker.yml
  apps/
    lab1_job.py
  data/
    ventas_clientes_anon.csv   (o el dataset que uséis)
```

**Importante**: el fichero `data/ventas_clientes_anon.csv` debe existir en **todas** las máquinas (Master y Workers), en esa ruta.

---

## 2) docker-compose del Master

Guarda como `docker-compose.master.yml` (en la raíz del proyecto):

```yaml
services:
  spark-master:
    image: bitnami/spark:3.5.1
    container_name: spark-master
    environment:
      - SPARK_MODE=master
      # IP LAN del portátil que actúa como master (se pone en el .env o se exporta antes)
      - SPARK_MASTER_HOST=${MASTER_IP}
      - SPARK_MASTER_PORT=7077
      - SPARK_MASTER_WEBUI_PORT=8080
    ports:
      - "7077:7077"   # RPC master
      - "8080:8080"   # Web UI master
    volumes:
      - ./apps:/opt/spark-apps
      - ./data:/opt/spark-data
```

### Cómo lanzar el Master (en el portátil “Master”)

En la carpeta `ud3-spark-lab1/`:

```bash
export MASTER_IP=192.168.1.50   # <-- cambia por la IP real del master
docker compose -f docker-compose.master.yml up -d
docker logs -f spark-master
```

Comprueba la UI en el navegador del Master:

* `http://localhost:8080`

Y desde otro portátil (Worker) en la misma red:

* `http://192.168.1.50:8080`

---

## 3) docker-compose del Worker (para cada alumno Worker)

Guarda como `docker-compose.worker.yml`:

```yaml
services:
  spark-worker:
    image: bitnami/spark:3.5.1
    container_name: spark-worker
    environment:
      - SPARK_MODE=worker
      - SPARK_MASTER_URL=spark://${MASTER_IP}:7077
      # Web UI del worker en su propia máquina
      - SPARK_WORKER_WEBUI_PORT=8081
      # Opcional: limitar recursos por alumno
      - SPARK_WORKER_CORES=2
      - SPARK_WORKER_MEMORY=2G
    ports:
      - "8081:8081"   # Web UI worker (en cada portátil)
    volumes:
      - ./apps:/opt/spark-apps
      - ./data:/opt/spark-data
```

### Cómo lanzar un Worker (en cada portátil Worker)

En su carpeta `ud3-spark-lab1/`:

```bash
export MASTER_IP=192.168.1.50   # IP del portátil master
docker compose -f docker-compose.worker.yml up -d
docker logs -f spark-worker
```

En la UI del Master (`http://MASTER_IP:8080`) deberían aparecer los Workers conectados.

---

## 4) Primer job PySpark (muy sencillo, didáctico, cero tuning)

Guarda como `apps/lab1_job.py`:

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum as _sum, avg as _avg, count as _count

DATA_PATH = "/opt/spark-data/ventas_clientes_anon.csv"

def main():
    spark = (
        SparkSession.builder
        .appName("UD3-Lab1-GroupBy")
        .getOrCreate()
    )

    # 1) Leer CSV
    df = spark.read.csv(DATA_PATH, header=True, inferSchema=True)

    # 2) Inspección rápida
    print("=== Schema ===")
    df.printSchema()
    print("=== Sample ===")
    df.show(5, truncate=False)

    # 3) Filtrado (p. ej. importe > 100)
    df_f = df.filter(col("importe") > 100)

    # 4) Agregación por ciudad
    res = (
        df_f.groupBy("ciudad")
        .agg(
            _count("*").alias("num_ventas"),
            _sum("importe").alias("importe_total"),
            _avg("importe").alias("importe_medio"),
        )
        .orderBy(col("importe_total").desc())
    )

    print("=== Result (top 20) ===")
    res.show(20, truncate=False)

    # 5) Guardar salida (ojo: Spark crea carpeta con partes)
    out_path = "/opt/spark-data/output/ventas_por_ciudad"
    res.coalesce(1).write.mode("overwrite").option("header", True).csv(out_path)

    print(f"Salida escrita en: {out_path}")
    spark.stop()

if __name__ == "__main__":
    main()
```

### Ejecutar el job (desde el Master)

En el portátil Master:

```bash
docker exec -it spark-master spark-submit \
  --master spark://192.168.1.50:7077 \
  /opt/spark-apps/lab1_job.py
```

> Sustituye `192.168.1.50` por la IP real del master.

### ¿Dónde queda la salida?

En el Master (carpeta local):

* `data/output/ventas_por_ciudad/`

He puesto `coalesce(1)` para que genere **un único “part-*.csv”** (más cómodo para alumnos). En Big Data real normalmente **no** se hace, pero aquí ayuda a clase.

---

## 5) Orden de arranque recomendado (para evitar “misterios”)

1. **Master**: `docker compose -f docker-compose.master.yml up -d`
2. Ver UI Master: `http://MASTER_IP:8080`
3. **Workers**: cada uno lanza su `docker-compose.worker.yml`
4. Confirmar en UI del Master que hay Workers
5. **Ejecutar job** con `spark-submit` desde el Master

---

## 6) Checklist de troubleshooting (rápido)

### A) Los Workers no aparecen en el Master

* ¿Están en la misma WiFi/red?
* ¿`MASTER_IP` es correcto?
* ¿El Master anuncia bien su host?

  * Debe ser la IP LAN real (no `localhost`).
* ¿Puertos bloqueados en la red?

  * Necesarios: **7077** (Spark master) y opcionalmente **8080** (UI).

### B) El job falla leyendo el CSV

Esto pasa si **alguna máquina no tiene el fichero** en `./data/ventas_clientes_anon.csv`.

* Asegura que **todos** tienen el CSV en `data/` antes de arrancar.
* Mantén la ruta fija `/opt/spark-data/ventas_clientes_anon.csv` en todos.

---

# Variante “más didáctica” para el aula (roles rotatorios)

* Grupo de 3:

  * Día 1: A es Master, B y C Workers.
  * Día 2: B es Master, A y C Workers.
  * Día 3: C es Master, A y B Workers.

Esto refuerza la idea de “clúster” sin entrar en cloud.

---

## Siguiente paso inmediato (cuando lo tengas arrancado)

En el **Laboratorio 2**, ya podemos introducir:

* Parquet como formato de salida.
* Particionado por fecha/ciudad.
* Comparación de tiempos vs pandas (con un dataset “inflado” por duplicación controlada).

Si quieres, en el próximo mensaje te preparo un **“kit de aula”** (un ZIP conceptual con estos ficheros y un mini‐guion de ejecución) y un **script para “inflar” el dataset x50/x100** sin cambiar la semántica, para que Spark “se note” frente a pandas.