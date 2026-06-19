# LAB3 - Clasificación con Spark MLlib (Titanic)

## Objetivo del laboratorio

En este laboratorio se entrenará un modelo de **clasificación** utilizando Spark MLlib.

Se utilizará el dataset del Titanic para predecir si un pasajero sobrevivió o no.

Durante el laboratorio se realizarán los siguientes pasos:

1. cargar el dataset
2. explorar los datos
3. transformar variables categóricas
4. preparar las features
5. dividir el dataset
6. entrenar un modelo de clasificación
7. generar predicciones
8. evaluar el modelo

---

# Dataset

Se utilizará el archivo:

```
titanic.csv
```

Columnas relevantes:

| columna | descripción |
|--------|-------------|
| pclass | clase del pasajero |
| sex | sexo |
| age | edad |
| fare | precio del billete |
| embarked | puerto de embarque |
| survived | variable objetivo (0 = no, 1 = sí) |

La variable objetivo será:

```
survived
```

---

# Paso 1 — Crear sesión de Spark

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("titanic_classification_lab") \
    .getOrCreate()
```

---

# Paso 2 — Cargar dataset

```python
dataset = spark.read.csv(
    "titanic.csv",
    header=True,
    inferSchema=True
)

dataset.show(5)
dataset.printSchema()
```

---

# Paso 3 — Selección de columnas

Nos quedamos solo con las columnas relevantes:

```python
dataset = dataset.select(
    "pclass",
    "sex",
    "age",
    "fare",
    "embarked",
    "survived"
)
```

---

# Paso 4 — Limpieza básica

Eliminamos filas con valores nulos:

```python
dataset = dataset.dropna()
```

---

# Paso 5 — Transformación de variables categóricas

Las variables categóricas deben convertirse a números.

Utilizamos `StringIndexer`.

```python
from pyspark.ml.feature import StringIndexer

indexer_sex = StringIndexer(
    inputCol="sex",
    outputCol="sex_index"
)

indexer_embarked = StringIndexer(
    inputCol="embarked",
    outputCol="embarked_index"
)

dataset = indexer_sex.fit(dataset).transform(dataset)
dataset = indexer_embarked.fit(dataset).transform(dataset)
```

---

# Paso 6 — Preparación de features

Creamos la columna `features`.

```python
from pyspark.ml.feature import VectorAssembler

assembler = VectorAssembler(
    inputCols=["pclass", "sex_index", "age", "fare", "embarked_index"],
    outputCol="features"
)

dataset_features = assembler.transform(dataset)

dataset_features.select("features", "survived").show(5)
```

---

# Paso 7 — División del dataset

```python
train_data, test_data = dataset_features.randomSplit([0.8, 0.2], seed=42)
```

---

# Paso 8 — Entrenamiento del modelo

Utilizamos regresión logística.

```python
from pyspark.ml.classification import LogisticRegression

lr = LogisticRegression(
    featuresCol="features",
    labelCol="survived"
)

model = lr.fit(train_data)
```

---

# Paso 9 — Predicciones

```python
predictions = model.transform(test_data)

predictions.select(
    "features",
    "survived",
    "prediction",
    "probability"
).show(10)
```

---

# Paso 10 — Evaluación del modelo

## AUC (Area Under ROC)

```python
from pyspark.ml.evaluation import BinaryClassificationEvaluator

evaluator = BinaryClassificationEvaluator(
    labelCol="survived",
    rawPredictionCol="prediction",
    metricName="areaUnderROC"
)

auc = evaluator.evaluate(predictions)

print("AUC:", auc)
```

## Accuracy (opcional)

```python
from pyspark.sql.functions import col

accuracy = predictions.filter(
    col("survived") == col("prediction")
).count() / predictions.count()

print("Accuracy:", accuracy)
```

---

# Comparación con scikit-learn

Flujo en scikit-learn:

```
datos
→ encoding
→ train_test_split
→ LogisticRegression
→ predict
→ accuracy / roc_auc
```

Flujo en Spark:

```
dataset
→ StringIndexer
→ VectorAssembler
→ LogisticRegression
→ transform
→ evaluación
```

La lógica es la misma.

---

# Ejercicio

Responde a las siguientes preguntas:

1. ¿Qué variables se han utilizado como features?
2. ¿Cuál es la variable objetivo?
3. ¿Por qué es necesario usar `StringIndexer`?
4. ¿Qué diferencia hay entre `fit()` y `transform()`?
5. ¿Qué indica la métrica AUC?
6. ¿Qué significa una predicción de valor 1?

---

# Conclusión

En este laboratorio se ha entrenado un modelo de clasificación utilizando Spark MLlib.

Se han aplicado los pasos habituales del Machine Learning:

```
datos
→ transformación
→ features
→ entrenamiento
→ predicción
→ evaluación
```

Este proceso es equivalente al utilizado en scikit-learn, pero adaptado a entornos Big Data.





