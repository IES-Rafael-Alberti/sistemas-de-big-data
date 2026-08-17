# 🧪 Actividad 6 — Pipeline completo con Mage + API/CSV + Spark + ML + exportación final

## 🧠 Objetivo

Construir un pipeline completo en Mage que:

1. obtenga datos desde una fuente externa o desde un CSV,
2. los procese con Spark,
3. prepare variables,
4. entrene un modelo sencillo o genere una predicción/regla,
5. exporte un resultado final listo para análisis.

---

# 🧩 Idea general del pipeline

```text
Ingesta → Limpieza → Transformación → Features → Modelo → Predicción → Exportación
```

---

# 🎯 Escenario propuesto

Vamos a trabajar con un pipeline de ventas basado en `supermarket_sales.csv`.

## Pregunta de negocio

Queremos identificar o predecir ventas para responder a una cuestión útil, por ejemplo:

* predecir el `Total`,
* clasificar ventas como **alta/media/baja**,
* generar un ranking por línea de producto,
* o producir un dataset final listo para un dashboard.

Para mantenerlo accesible, te propongo dos variantes:

### Variante A — Regresión

Predecir `Total`.

### Variante B — Clasificación sencilla

Clasificar una venta como **alta** o **baja** según un umbral.

Para alumnado con poca base, la **Variante A** suele ser más directa.
La **Variante B** es muy buena si luego quieres conectar con BI o cuadros de mando.

Aquí te dejo la actividad base con la **Variante A**, y al final añado cómo convertirla a clasificación.

---

# ⚙️ Arquitectura de la actividad

## Herramientas

* **Mage**: orquesta el flujo
* **Spark**: procesa y transforma
* **MLlib**: entrena el modelo
* **CSV final**: salida lista para análisis

---

# 🧪 Actividad 6 — versión alumnado paso a paso

## Paso 1 — Crear el pipeline

Crea un pipeline nuevo en Mage:

```text
Nombre: pipeline_completo_ventas
Tipo: Standard (batch)
```

---

## Paso 2 — Bloque de ingesta

### Opción recomendada para clase

Usar el CSV local `supermarket_sales.csv`.

```python
from pyspark.sql import SparkSession

def load_data(*args, **kwargs):
    spark = SparkSession.builder \
        .appName("MagePipelineCompleto") \
        .getOrCreate()

    df = spark.read.csv(
        "data/supermarket_sales.csv",
        header=True,
        inferSchema=True
    )

    return df
```

---

## Paso 3 — Exploración inicial

Añade temporalmente:

```python
df.show(5)
df.printSchema()
```

### Responde

* ¿Qué columnas parecen útiles?
* ¿Cuáles sobran para el primer modelo?
* ¿Hay columnas categóricas?

---

## Paso 4 — Limpieza básica

Crea un bloque de transformación inicial:

```python
from pyspark.sql.functions import col

def clean_data(df, *args, **kwargs):
    df = df.dropna()

    df = df.withColumn("Quantity", col("Quantity").cast("double"))
    df = df.withColumn("Unit price", col("Unit price").cast("double"))
    df = df.withColumn("Total", col("Total").cast("double"))
    df = df.withColumn("gross income", col("gross income").cast("double"))
    df = df.withColumn("Rating", col("Rating").cast("double"))

    return df
```

---

## Paso 5 — Selección de variables

Vamos a preparar un conjunto sencillo de variables numéricas.

```python
def select_features(df, *args, **kwargs):
    return df.select(
        "Quantity",
        "Unit price",
        "gross income",
        "Rating",
        "Total",
        "Product line",
        "City",
        "Payment"
    )
```

---

## Paso 6 — Construcción de features

Primero haremos una versión básica solo con numéricas.
Más adelante, como mejora opcional, se pueden incluir categóricas.

```python
from pyspark.ml.feature import VectorAssembler

def build_features(df, *args, **kwargs):
    assembler = VectorAssembler(
        inputCols=["Quantity", "Unit price", "gross income", "Rating"],
        outputCol="features"
    )

    df = assembler.transform(df)
    return df.select("features", "Total", "Product line", "City", "Payment")
```

---

## Paso 7 — División train/test

```python
def split_data(df, *args, **kwargs):
    train_df, test_df = df.randomSplit([0.8, 0.2], seed=42)
    return {
        "train": train_df,
        "test": test_df,
    }
```

---

## Paso 8 — Entrenar el modelo

Usaremos una **regresión lineal**.

```python
from pyspark.ml.regression import LinearRegression

def train_model(data, *args, **kwargs):
    lr = LinearRegression(
        featuresCol="features",
        labelCol="Total",
        predictionCol="prediction"
    )

    model = lr.fit(data["train"])

    return {
        "model": model,
        "test": data["test"],
    }
```

---

## Paso 9 — Generar predicciones

```python
def predict(data, *args, **kwargs):
    predictions = data["model"].transform(data["test"])
    return predictions
```

Puedes comprobar los resultados con:

```python
predictions.select("Total", "prediction", "Product line", "City").show(10, truncate=False)
```

---

## Paso 10 — Evaluación

```python
from pyspark.ml.evaluation import RegressionEvaluator

def evaluate(predictions, *args, **kwargs):
    rmse_evaluator = RegressionEvaluator(
        labelCol="Total",
        predictionCol="prediction",
        metricName="rmse"
    )

    r2_evaluator = RegressionEvaluator(
        labelCol="Total",
        predictionCol="prediction",
        metricName="r2"
    )

    rmse = rmse_evaluator.evaluate(predictions)
    r2 = r2_evaluator.evaluate(predictions)

    print(f"RMSE: {rmse}")
    print(f"R2: {r2}")

    return predictions
```

---

## Paso 11 — Crear una salida útil para negocio

Ahora transformamos el resultado en algo más “presentable”.

Por ejemplo, nos quedamos con:

* valor real,
* predicción,
* error absoluto,
* ciudad,
* línea de producto,
* método de pago.

```python
from pyspark.sql.functions import abs, col

def build_business_output(df, *args, **kwargs):
    result = df.withColumn(
        "abs_error",
        abs(col("Total") - col("prediction"))
    )

    return result.select(
        "Product line",
        "City",
        "Payment",
        "Total",
        "prediction",
        "abs_error"
    )
```

---

## Paso 12 — Exportar resultado

```python
def export(df, *args, **kwargs):
    df.toPandas().to_csv("output/pipeline_completo_resultados.csv", index=False)
```

---

# ✅ Resultado esperado

Al final debes tener un pipeline parecido a este:

```text
Load Data
   ↓
Clean Data
   ↓
Select Features
   ↓
Build Features
   ↓
Split Data
   ↓
Train Model
   ↓
Predict
   ↓
Evaluate
   ↓
Business Output
   ↓
Export
```

---

# 🧠 Preguntas guiadas durante la actividad

## Parte 1 — Datos

1. ¿Qué variables has usado para predecir `Total`?
2. ¿Qué variables has dejado fuera?
3. ¿Crees que faltan variables importantes?

## Parte 2 — Modelo

4. ¿Qué aprende la regresión lineal en este caso?
5. ¿Qué significa que el modelo haga una predicción?
6. ¿Te parece un problema de regresión adecuado?

## Parte 3 — Evaluación

7. ¿Qué indican RMSE y R²?
8. ¿Qué significaría un error alto?
9. ¿Qué registros parece que se predicen peor?

## Parte 4 — Negocio

10. ¿Qué utilidad real podría tener este CSV final?
11. ¿Qué equipo de una empresa podría usarlo?
12. ¿Cómo lo conectarías con un dashboard o un sistema BI?

---

# 📝 Reflexión final obligatoria

En la entrega deben responder algo de este estilo.

## 1. Arquitectura completa

Explica con tus palabras qué papel juega cada parte:

* Mage
* Spark
* MLlib

## 2. Flujo de datos

Describe cómo viajan los datos desde la ingesta hasta la exportación final.

## 3. Valor del pipeline

¿Qué aporta este pipeline frente a tener scripts sueltos en Python?

## 4. Escalabilidad

¿Qué parte del sistema tendría más sentido escalar si el volumen de datos creciera mucho?

## 5. Mejoras posibles

Indica al menos 3 mejoras realistas para este pipeline.

---

# 🔥 Mejoras opcionales

## Mejora 1 — Añadir variables categóricas

Se puede ampliar el pipeline usando:

* `StringIndexer`
* `OneHotEncoder`
* `VectorAssembler`

para incluir columnas como:

* `City`
* `Payment`
* `Product line`

---

## Mejora 2 — Ranking de peores predicciones

Añadir un bloque que ordene por error absoluto descendente:

```python
from pyspark.sql.functions import col

def worst_predictions(df, *args, **kwargs):
    return df.orderBy(col("abs_error").desc())
```

---

## Mejora 3 — Agregado final por ciudad o línea de producto

Por ejemplo:

```python
from pyspark.sql.functions import avg

def summary_by_city(df, *args, **kwargs):
    return df.groupBy("City").agg(
        avg("abs_error").alias("avg_abs_error")
    )
```

Esto ya conecta muy bien con BI.

---

# 🔁 Variante B — convertir la actividad a clasificación

Si quieres que no sea una regresión sino una clasificación, se puede hacer así:

## Idea

Crear una variable binaria:

* `1` si `Total >= 300`
* `0` si `Total < 300`

## Ejemplo de transformación

```python
from pyspark.sql.functions import when, col

def create_label(df, *args, **kwargs):
    df = df.withColumn(
        "label",
        when(col("Total") >= 300, 1).otherwise(0)
    )
    return df
```

Luego usar, por ejemplo:

* `LogisticRegression`
* `DecisionTreeClassifier`

Eso puede estar muy bien como ampliación o como práctica de subida de nivel.

---

# 🎯 Idea clave que deben quedarse

```text
Un pipeline de datos real no termina al entrenar un modelo
Termina cuando produce una salida útil
```

Y también:

```text
Mage organiza
Spark procesa
MLlib aprende
La exportación conecta con negocio
```

---

# 💡 Enfoque didáctico

Esta actividad es muy buena para cerrar bloque porque hace visibles todas las capas:

* capa de orquestación,
* capa de procesamiento,
* capa de modelado,
* capa de salida.

Ya no es “hacer un modelo” ni “hacer un script”:
es **montar un sistema de datos completo**.

---

# 🚀 Siguiente paso lógico

Después de esta actividad, los siguientes caminos naturales serían:

* **Actividad 7: pipeline completo con variables categóricas y Pipeline de MLlib**
* **Actividad 8: comparación completa Spark MLlib vs scikit-learn**
* **Actividad 9: exportación a dashboard / BI**
* **Actividad 10: despliegue del pipeline en entorno más realista**

Si te parece, el siguiente paso útil sería que te prepare ahora el **documento de entrega específico de la Actividad 6** y su **rúbrica compacta**, para que quede cerrada como las demás.
