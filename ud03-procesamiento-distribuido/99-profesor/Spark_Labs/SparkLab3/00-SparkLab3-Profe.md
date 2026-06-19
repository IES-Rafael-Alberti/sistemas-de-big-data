Perfecto. Vamos con el **Laboratorio 3**, que es **clave** en UD3 porque es donde Spark deja de ser “solo pandas distribuido” y aparece **Big Data de verdad**: formatos columnares, particionado y rendimiento.

Te dejo el **documento en versión alumnado**, muy guiado, sin sustos, y encajado directamente después del Lab 2.

---

```markdown
# Laboratorio 3 — Spark, Parquet y particionado
## UD3 · Procesamiento eficiente de datos

En este laboratorio vamos a dar el salto de **CSV → Parquet**, y a entender por qué en Big Data **el formato y la organización de los datos importan tanto como el motor de procesamiento**.

---

## 1. Objetivos del laboratorio

Al finalizar este laboratorio deberías ser capaz de:

- Comprender por qué CSV no es adecuado para Big Data.
- Trabajar con **Parquet**, un formato columnar.
- Aplicar **particionado** de datos con Spark.
- Comparar rendimiento entre:
  - CSV sin particionar
  - Parquet particionado
- Preparar datos para su consumo por herramientas de análisis y visualización.

---

## 2. Punto de partida

Partimos del trabajo realizado en el Laboratorio 2:

- Dataset inflado (`ventas_clientes_anon_big.csv`)
- Procesamiento con Spark
- Resultados agregados por ciudad

Estructura esperada:

```

ud3-spark/
apps/
lab1_job.py
data/
ventas_clientes_anon_big.csv
output/

```

---

## 3. Problema: CSV en Big Data

Antes de hacer nada, reflexiona:

- CSV:
  - No tiene tipos explícitos
  - No está comprimido eficientemente
  - Obliga a leer todo el fichero
- En Big Data:
  - Se leen **columnas concretas**
  - Se filtran **particiones**
  - Se accede a **fragmentos del dataset**

👉 Aquí es donde entra **Parquet**.

---

## 4. Escritura en formato Parquet

### 4.1 Crear un nuevo job Spark

Copia `lab1_job.py` y crea:

```

apps/lab3_parquet_job.py

````

---

### 4.2 Código base del job

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import col

DATA_PATH = "/opt/spark-data/ventas_clientes_anon_big.csv"
OUTPUT_PATH = "/opt/spark-data/parquet/ventas"

spark = SparkSession.builder.appName("UD3-Lab3-Parquet").getOrCreate()

df = spark.read.csv(DATA_PATH, header=True, inferSchema=True)

# Escritura en Parquet
df.write.mode("overwrite").parquet(OUTPUT_PATH)

spark.stop()
````

---

### 4.3 Ejecutar el job

Desde el Master:

```bash
docker exec -it spark-master spark-submit \
  --master spark://IP_DEL_MASTER:7077 \
  /opt/spark-apps/lab3_parquet_job.py
```

Comprueba que se ha creado:

```
data/parquet/ventas/
```

Con múltiples ficheros `.parquet`.

---

## 5. Lectura desde Parquet

### 5.1 Modificar el job para leer Parquet

Edita el mismo fichero:

```python
df = spark.read.parquet(OUTPUT_PATH)
```

Y añade una operación simple:

```python
df.filter(col("importe") > 100).groupBy("ciudad").count().show()
```

Ejecuta de nuevo el job.

---

## 6. Particionado de datos

### 6.1 ¿Qué es particionar?

Particionar significa **organizar los datos en carpetas según una columna**.

Ejemplo:

```
ciudad=Cadiz/
ciudad=Jerez/
ciudad=Algeciras/
```

Esto permite:

* leer solo una parte del dataset
* acelerar consultas
* reducir E/S

---

### 6.2 Escritura en Parquet particionado

Modifica la escritura:

```python
df.write \
  .mode("overwrite") \
  .partitionBy("ciudad") \
  .parquet(OUTPUT_PATH)
```

Ejecuta el job de nuevo.

---

### 6.3 Inspeccionar la estructura

Explora la carpeta:

```
data/parquet/ventas/
```

Observa:

* subcarpetas por ciudad
* ficheros `.parquet` dentro

---

## 7. Comparación de rendimiento (conceptual)

No hace falta medir milisegundos exactos.

Reflexiona sobre:

* CSV:

  * lee todo el fichero
* Parquet:

  * lee solo columnas necesarias
* Parquet particionado:

  * lee solo las carpetas relevantes

Ejemplo mental:

> “Quiero solo ventas de Cádiz”

* CSV → leer todo
* Parquet → leer columnas
* Parquet + partición → leer solo Cádiz

---

## 8. Preparación para análisis y visualización

El resultado en Parquet:

* es estable
* es eficiente
* está listo para:

  * Kibana
  * Zeppelin
  * procesos periódicos
  * pipelines automáticos

👉 Esto es **lo que se hace en sistemas reales**.

---

## 9. Preguntas de reflexión (para la entrega)

Responde en el documento de entrega:

1. ¿Por qué CSV no es adecuado para Big Data?
2. ¿Qué ventaja principal aporta Parquet?
3. ¿Qué problema resuelve el particionado?
4. ¿Cuándo NO tendría sentido particionar?
5. ¿Qué formato usarías para un datalake?

---

## 10. Qué deberías tener claro al terminar

Al finalizar este laboratorio deberías entender que:

* Spark no solo procesa datos, **organiza datos**.
* El formato de almacenamiento es clave.
* Parquet + particiones es un estándar de facto.
* Esto conecta directamente con:

  * datalakes
  * BI
  * ML
  * pipelines de datos

---

## 11. Lo que viene después

A partir de aquí:

* Visualización (Kibana)
* Análisis interactivo (Zeppelin)
* Automatización (Airflow)

👉 **Este laboratorio es el puente** entre procesamiento y explotación.

```

---

## 🧭 Encaje perfecto en la UD3

Con Lab 3 ya has cubierto:

- Spark como motor
- Escalabilidad
- Formatos Big Data
- Organización de datos
- Preparación para explotación

Es **el laboratorio que justifica toda la UD3**.

---

### Siguiente paso (cuando quieras)
- Documento de **entrega del Lab 3**
- **Laboratorio Kibana** adaptado a Parquet
- **Mapa RA/CE definitivo de la UD3**

Tú mandas.
```