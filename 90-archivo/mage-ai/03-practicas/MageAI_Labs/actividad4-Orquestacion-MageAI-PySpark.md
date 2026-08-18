# ⚡ Actividad 4 — Mage AI + PySpark (procesamiento distribuido)

## 🧠 Objetivo

Construir un pipeline en Mage que:

* Procese datos con **PySpark**
* Realice transformaciones distribuidas
* Genere resultados agregados

---

## 🧩 Escenario

Trabajaremos con un dataset de ventas (puede ser el mismo `supermarket_sales.csv`).

👉 La idea clave:

```text
Pandas → local
Spark → distribuido
```

---

## ⚠️ Importante (contexto técnico)

Mage no ejecuta Spark “nativamente” como cluster, pero:

👉 Podemos usar PySpark dentro de bloques
👉 O conectarlo a un Spark local/cluster

En esta práctica:

✔ Usaremos **Spark local (modo standalone)**
✔ Integrado dentro del contenedor

---

## 🔧 Paso 0 — Requisito (si usas Docker)

👉 Añadir soporte PySpark (si no está):

Opción rápida dentro del contenedor:

```bash
pip install pyspark
```

---

## 🔧 Paso 1 — Crear pipeline

```text
Nombre: spark_pipeline
```

---

## 📥 Paso 2 — Data Loader (Spark)

```python
from pyspark.sql import SparkSession

def load_data(*args, **kwargs):
    spark = SparkSession.builder \
        .appName("MageSpark") \
        .getOrCreate()
    
    df = spark.read.csv(
        "data/supermarket_sales.csv",
        header=True,
        inferSchema=True
    )
    
    return df
```

---

## 🔍 Paso 3 — Explorar datos

Añade temporalmente:

```python
df.show(5)
df.printSchema()
```

👉 Preguntas:

* ¿Qué tipos detecta Spark?
* ¿Hay diferencias con pandas?

---

## 🔄 Paso 4 — Transformer (Spark)

```python
def transform(df, *args, **kwargs):
    from pyspark.sql.functions import col, sum, avg
    
    # Convertimos columnas necesarias
    df = df.withColumn("Total", col("Total").cast("double"))
    
    # Agregación distribuida
    result = df.groupBy("Product line").agg(
        sum("Total").alias("total_sales"),
        avg("Total").alias("avg_sales")
    )
    
    return result
```

---

## 📊 Paso 5 — Acción (muy importante en Spark)

👉 Spark es lazy → hay que forzar ejecución:

```python
result.show()
```

---

## 💾 Paso 6 — Exporter

```python
def export(df, *args, **kwargs):
    df.toPandas().to_csv("output/spark_result.csv", index=False)
```

👉 Nota didáctica clave:

* Spark → distribuido
* Export → normalmente requiere conversión

---

## 🧠 Paso 7 — Comparación con pandas

Responde:

* ¿Qué cambia respecto a pandas?
* ¿Cuándo usarías Spark?
* ¿Qué ventaja aporta en Big Data?

---

---

# 🔬 Extensión (recomendada para subir nivel)

## 🔥 Añadir filtro

```python
df = df.filter(col("Total") > 100)
```

---

## 🔥 Ordenar resultados

```python
result = result.orderBy(col("total_sales").desc())
```

---

## 🔥 Top N

```python
result.limit(5)
```

---

---

# 🧠 Reflexión final (OBLIGATORIA)

Responde:

### 1. Diferencia clave

> ¿Qué problema resuelve Spark que pandas no puede?

---

### 2. Limitaciones

> ¿Qué problemas has encontrado al usar Spark dentro de Mage?

---

### 3. Arquitectura

> ¿Cómo sería este pipeline en producción?

---

### 4. Escalabilidad

> ¿Qué cambiaría si tuvieras 1TB de datos?

---

---

# 🎯 Mensaje clave

```text
Mage → orquesta
Spark → procesa
```

---

# 🧠 Lo que debhay que entender (muy importante)

* Mage NO sustituye a Spark
* Spark NO sustituye a Mage

👉 Son capas distintas del sistema

---

# 📊 Resultado esperado

Pipeline:

```text
Data Loader (Spark)
        ↓
Transformer (Spark)
        ↓
Exporter
```


