# 🤖 Actividad 5 — Mage AI + Spark + MLlib

## Objetivo

Construir un pipeline en Mage que:

1. cargue un dataset con Spark,
2. prepare las variables,
3. entrene un modelo sencillo con **Spark MLlib**,
4. genere predicciones,
5. exporte resultados,
6. y termine con una reflexión sobre el uso de ML distribuido.

---

# Contexto

Hasta ahora el alumnado ha trabajado con:

* pipelines en Mage,
* transformación distribuida con PySpark,
* y modelos simples con `scikit-learn`.

Ahora damos el siguiente paso: usar **MLlib**, la librería de machine learning de Spark, pensada para trabajar con datos distribuidos.

---

# Escenario propuesto

Vamos a usar el dataset `supermarket_sales.csv`.

No es un dataset ideal de machine learning avanzado, pero sí sirve muy bien para un **primer ejemplo didáctico**.

## Problema a resolver

Predecir el valor de **`Total`** a partir de algunas variables sencillas, por ejemplo:

* `Quantity`
* `Unit price`

Opcionalmente, más adelante se pueden añadir variables categóricas como:

* `Payment`
* `Branch`
* `City`
* `Product line`

Para esta actividad base, conviene empezar por algo controlado y comprensible.

---

# Estructura del pipeline

```text
Data Loader (Spark)
        ↓
Transformer / Feature Prep
        ↓
Model Trainer (MLlib)
        ↓
Prediction / Evaluation
        ↓
Exporter
```

---

# Paso 0 — Preparación

Asegúrate de tener disponible PySpark en el entorno de Mage.

Por ejemplo, dentro del contenedor o entorno:

```bash
pip install pyspark
```

---

# Paso 1 — Crear el pipeline

Crea un pipeline nuevo en Mage:

```text
Nombre: spark_mllib_pipeline
Tipo: Standard (batch)
```

---

# Paso 2 — Data Loader con Spark

Crea un bloque de carga de datos.

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

# Paso 3 — Exploración inicial

Antes de transformar, inspecciona los datos.

Añade temporalmente estas líneas para observar el dataset:

```python
df.show(5)
df.printSchema()
```

## Responde

1. ¿Qué columnas parecen útiles para predecir `Total`?
2. ¿Qué tipos de datos ha detectado Spark?
3. ¿Hay columnas que sobran para este primer modelo?

---

# Paso 4 — Preparación de variables

Ahora vamos a preparar los datos para MLlib.

En Spark MLlib, normalmente necesitamos una columna de entrada llamada **`features`** y una columna objetivo, en este caso **`Total`**.

Crea un bloque de transformación:

```python
from pyspark.sql.functions import col

def transform(df, *args, **kwargs):
    # Nos quedamos con unas pocas columnas numéricas
    df = df.select("Quantity", "Unit price", "Total")

    # Aseguramos tipos numéricos
    df = df.withColumn("Quantity", col("Quantity").cast("double"))
    df = df.withColumn("Unit price", col("Unit price").cast("double"))
    df = df.withColumn("Total", col("Total").cast("double"))

    # Eliminamos nulos por seguridad
    df = df.dropna()

    return df
```

---

# Paso 5 — Crear vector de características

Spark MLlib no trabaja directamente con columnas sueltas como `scikit-learn`.
Necesita un vector unificado de características.

Crea un bloque nuevo:

```python
from pyspark.ml.feature import VectorAssembler

def build_features(df, *args, **kwargs):
    assembler = VectorAssembler(
        inputCols=["Quantity", "Unit price"],
        outputCol="features"
    )

    featured_df = assembler.transform(df)
    return featured_df.select("features", "Total")
```

---

# Paso 6 — División en entrenamiento y prueba

Ahora dividimos el dataset en dos partes:

* entrenamiento,
* prueba.

```python
def split_data(df, *args, **kwargs):
    train_df, test_df = df.randomSplit([0.8, 0.2], seed=42)
    return {
        "train": train_df,
        "test": test_df,
    }
```

## Idea importante para explicar en clase

Aquí el alumnado debe ver que en machine learning no basta con entrenar:
hay que **evaluar con datos no vistos**.

---

# Paso 7 — Entrenamiento del modelo con MLlib

Vamos a usar una **regresión lineal**.

```python
from pyspark.ml.regression import LinearRegression

def train_model(data, *args, **kwargs):
    train_df = data["train"]

    lr = LinearRegression(
        featuresCol="features",
        labelCol="Total",
        predictionCol="prediction"
    )

    model = lr.fit(train_df)
    return {
        "model": model,
        "test": data["test"],
    }
```

---

# Paso 8 — Generar predicciones

```python
def predict(data, *args, **kwargs):
    model = data["model"]
    test_df = data["test"]

    predictions = model.transform(test_df)
    return predictions
```

Para visualizar resultados:

```python
predictions.select("features", "Total", "prediction").show(10, truncate=False)
```

---

# Paso 9 — Evaluación del modelo

Ahora vamos a medir cómo de bien funciona.

```python
from pyspark.ml.evaluation import RegressionEvaluator

def evaluate(predictions, *args, **kwargs):
    evaluator_rmse = RegressionEvaluator(
        labelCol="Total",
        predictionCol="prediction",
        metricName="rmse"
    )

    evaluator_r2 = RegressionEvaluator(
        labelCol="Total",
        predictionCol="prediction",
        metricName="r2"
    )

    rmse = evaluator_rmse.evaluate(predictions)
    r2 = evaluator_r2.evaluate(predictions)

    print(f"RMSE: {rmse}")
    print(f"R2: {r2}")

    return predictions
```

---

# Paso 10 — Exportar resultados

Para exportar, convertimos a pandas una parte razonable del resultado.

```python
def export(predictions, *args, **kwargs):
    output_df = predictions.select("Total", "prediction").toPandas()
    output_df.to_csv("output/spark_mllib_predictions.csv", index=False)
```

---

# Qué deben observar

Durante la ejecución, el alumnado debe fijarse en:

* cómo Spark representa las variables de entrada en `features`,
* cómo se separa el entrenamiento de la evaluación,
* cómo aparece la columna `prediction`,
* y cómo cambian los resultados según las variables elegidas.

---

# Preguntas guiadas durante la práctica

## Parte 1 — Datos

1. ¿Qué variables has usado como entrada?
2. ¿Por qué has elegido esas y no otras?
3. ¿Crees que con esas variables basta para predecir bien `Total`?

## Parte 2 — Modelo

4. ¿Qué tipo de modelo has entrenado?
5. ¿Qué intenta aprender exactamente la regresión lineal?
6. ¿Qué relación esperas entre `Quantity`, `Unit price` y `Total`?

## Parte 3 — Evaluación

7. ¿Qué significa RMSE?
8. ¿Qué significa R²?
9. ¿Qué valor de R² considerarías bueno en este contexto?

---

# Extensión 1 — Añadir más variables

Cuando el pipeline básico funcione, se puede ampliar con variables categóricas.

Por ejemplo:

* `Branch`
* `City`
* `Payment`
* `Product line`

Eso obliga a introducir dos conceptos nuevos:

* codificación de variables categóricas,
* pipelines de MLlib.

---

# Extensión 2 — Pipeline más profesional con MLlib

Versión algo más avanzada:

```python
from pyspark.ml.feature import StringIndexer, OneHotEncoder, VectorAssembler
from pyspark.ml import Pipeline
from pyspark.ml.regression import LinearRegression

def advanced_train(df, *args, **kwargs):
    indexer = StringIndexer(inputCol="Payment", outputCol="PaymentIndex")
    encoder = OneHotEncoder(inputCols=["PaymentIndex"], outputCols=["PaymentVec"])

    assembler = VectorAssembler(
        inputCols=["Quantity", "Unit price", "PaymentVec"],
        outputCol="features"
    )

    lr = LinearRegression(
        featuresCol="features",
        labelCol="Total",
        predictionCol="prediction"
    )

    pipeline = Pipeline(stages=[indexer, encoder, assembler, lr])

    train_df, test_df = df.randomSplit([0.8, 0.2], seed=42)
    model = pipeline.fit(train_df)
    predictions = model.transform(test_df)

    return predictions
```

Esto ya es muy útil para mostrar cómo Spark ML maneja transformaciones y modelo en un mismo flujo.

---

# Reflexión final obligatoria

En la entrega, el alumnado debe responder al menos a estas cuestiones.

## 1. Diferencia entre scikit-learn y MLlib

¿En qué se diferencia entrenar este modelo con MLlib frente a entrenarlo con `scikit-learn`?

## 2. Papel de cada herramienta

¿Qué hace Mage, qué hace Spark y qué hace MLlib en este pipeline?

## 3. Escalabilidad

¿Por qué podría interesar usar MLlib en lugar de `scikit-learn` cuando el volumen de datos crece mucho?

## 4. Limitaciones

¿Qué limitaciones tiene este ejemplo?
¿Qué mejorarías para construir un pipeline más realista?

## 5. Interpretación del modelo

¿Crees que el modelo realmente “aprende” algo útil o solo una relación muy obvia entre variables?

---

# Mensaje pedagógico clave

Esto conviene remarcarlo mucho en clase:

```text
scikit-learn aprende muy bien en local
MLlib permite aprender cuando los datos ya viven en Spark
```

Y también:

```text
Mage no entrena el modelo
Mage organiza el sistema que lo entrena
```

---

# Posibles mejoras para una segunda versión

Después de esta práctica, el siguiente salto lógico sería uno de estos:

## Opción A — Clasificación con MLlib

En lugar de predecir `Total`, clasificar registros en categorías, por ejemplo:

* venta alta / media / baja.

## Opción B — Pipeline con preprocesado categórico completo

Añadir `StringIndexer`, `OneHotEncoder`, `VectorAssembler` y un pipeline más serio.

## Opción C — Comparativa MLlib vs scikit-learn

Mismo problema, dos implementaciones:

* una en pandas + `scikit-learn`,
* otra en Spark + MLlib.

Esto suele funcionar muy bien en clase porque el alumnado ve claramente cuándo compensa una herramienta u otra.

---

# Resumen de la actividad

## Lo que aprende el alumno

* a orquestar un flujo con Mage,
* a cargar y transformar datos con Spark,
* a preparar variables para MLlib,
* a entrenar un modelo distribuido básico,
* a evaluar predicciones,
* y a razonar sobre escalabilidad.

## Idea final

Esta actividad ya se parece bastante a un pipeline real de datos:

**ingesta → preparación → entrenamiento → predicción → exportación**.

---

Si quieres, el siguiente paso natural es que te prepare también el **documento de actividad completo estilo alumnado**, igual que las anteriores, con formato más compacto y más “de seguir paso a paso en clase”.

