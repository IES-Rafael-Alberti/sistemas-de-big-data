# 🧪 Actividad 5 — Mage + Spark + MLlib (versión alumnado)

## 🧠 Objetivo

Construir un pipeline que:

* procese datos con **Spark**
* entrene un modelo con **MLlib**
* genere predicciones
* y analice los resultados

---

## 🧩 Pipeline objetivo

```text
Data Loader → Transform → Features → Train → Predict → Evaluate → Export
```

---

## ⚙️ Requisitos

* Usar **PySpark**
* Usar **MLlib (LinearRegression)**
* Pipeline funcional en Mage

---

# 🔧 Paso 1 — Crear pipeline

```text
Nombre: spark_mllib_pipeline
Tipo: Standard (batch)
```

---

# 📥 Paso 2 — Data Loader (Spark)

```python
from pyspark.sql import SparkSession

def load_data(*args, **kwargs):
    spark = SparkSession.builder \
        .appName("MageSparkMLlib") \
        .getOrCreate()

    df = spark.read.csv(
        "data/supermarket_sales.csv",
        header=True,
        inferSchema=True
    )

    return df
```

---

# 🔍 Paso 3 — Explora los datos

Añade temporalmente:

```python
df.show(5)
df.printSchema()
```

👉 Responde:

* ¿Qué columnas ves?
* ¿Qué tipo tiene `Total`?

---

# 🔄 Paso 4 — Preparar datos

```python
from pyspark.sql.functions import col

def transform(df, *args, **kwargs):
    df = df.select("Quantity", "Unit price", "Total")

    df = df.withColumn("Quantity", col("Quantity").cast("double"))
    df = df.withColumn("Unit price", col("Unit price").cast("double"))
    df = df.withColumn("Total", col("Total").cast("double"))

    df = df.dropna()

    return df
```

---

# 🧮 Paso 5 — Crear features

```python
from pyspark.ml.feature import VectorAssembler

def build_features(df, *args, **kwargs):
    assembler = VectorAssembler(
        inputCols=["Quantity", "Unit price"],
        outputCol="features"
    )

    df = assembler.transform(df)
    return df.select("features", "Total")
```

---

# ✂️ Paso 6 — Split train/test

```python
def split_data(df, *args, **kwargs):
    train, test = df.randomSplit([0.8, 0.2], seed=42)
    return {"train": train, "test": test}
```

---

# 🤖 Paso 7 — Entrenar modelo

```python
from pyspark.ml.regression import LinearRegression

def train_model(data, *args, **kwargs):
    lr = LinearRegression(
        featuresCol="features",
        labelCol="Total",
        predictionCol="prediction"
    )

    model = lr.fit(data["train"])
    return {"model": model, "test": data["test"]}
```

---

# 🔮 Paso 8 — Predicciones

```python
def predict(data, *args, **kwargs):
    model = data["model"]
    test = data["test"]

    predictions = model.transform(test)
    return predictions
```

---

# 📊 Paso 9 — Evaluación

```python
from pyspark.ml.evaluation import RegressionEvaluator

def evaluate(df, *args, **kwargs):
    evaluator = RegressionEvaluator(
        labelCol="Total",
        predictionCol="prediction",
        metricName="rmse"
    )

    rmse = evaluator.evaluate(df)
    print("RMSE:", rmse)

    return df
```

---

# 💾 Paso 10 — Exportar

```python
def export(df, *args, **kwargs):
    df.toPandas().to_csv("output/mllib_results.csv", index=False)
```

---

# 🧠 Comprueba que todo funciona

Antes de seguir:

✔ El pipeline ejecuta
✔ Aparece la columna `prediction`
✔ Se genera el CSV

---

# 🧠 Reflexión (OBLIGATORIA)

Responde en tu documento:

---

## 1. Datos

* ¿Qué variables has usado?
* ¿Son suficientes?

---

## 2. Modelo

* ¿Qué aprende la regresión lineal?
* ¿Tiene sentido en este dataset?

---

## 3. Evaluación

* ¿Qué significa RMSE?
* ¿Es bueno o malo tu resultado?

---

## 4. Arquitectura

* ¿Qué hace Mage?
* ¿Qué hace Spark?
* ¿Qué hace MLlib?

---

## 5. Escalabilidad

* ¿Por qué usar Spark en lugar de pandas?
* ¿Qué pasaría con millones de filas?

---

# 🚀 Mejora (opcional)

Intenta:

* añadir otra variable
* cambiar el modelo
* mejorar resultados

---

# 🎯 Idea clave

```text
No estás haciendo un script
Estás construyendo un sistema de datos
```

---

# 🧠 Pista importante

Si el modelo te da resultados “demasiado buenos”:

👉 piensa por qué (hay trampa en los datos 😉)


