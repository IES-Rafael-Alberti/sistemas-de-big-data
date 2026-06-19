 LAB2 - Regresión con dataset real usando Spark MLlib

## Objetivo del laboratorio

En este laboratorio se entrenará un modelo de regresión utilizando **un dataset real cargado desde fichero**.

Se realizarán los siguientes pasos:

1. cargar el dataset
2. explorar los datos
3. preparar las features
4. dividir el dataset
5. entrenar un modelo de regresión
6. evaluar el modelo

Este flujo es el mismo que en scikit-learn, pero utilizando **Spark y procesamiento distribuido**.

---

# Dataset

Se utilizará el archivo:

```

housing_spark.csv

```

Columnas del dataset:

| columna | descripción |
|-------|-------------|
| size | superficie de la vivienda |
| bedrooms | número de habitaciones |
| age | antigüedad de la vivienda |
| price | precio |

La variable objetivo será:

```

price

````

---

# Paso 1 — Crear sesión de Spark

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("housing_regression_lab") \
    .getOrCreate()
````

---

# Paso 2 — Cargar dataset

```python
dataset = spark.read.csv(
    "housing_spark.csv",
    header=True,
    inferSchema=True
)

dataset.show()
```

Verificar estructura:

```python
dataset.printSchema()
```

---

# Paso 3 — Preparar features

Los algoritmos de MLlib necesitan una columna llamada **features**.

Para ello se utiliza `VectorAssembler`.

```python
from pyspark.ml.feature import VectorAssembler

assembler = VectorAssembler(
    inputCols=["size", "bedrooms", "age"],
    outputCol="features"
)

dataset_features = assembler.transform(dataset)

dataset_features.select("features", "price").show()
```

---

# Paso 4 — División del dataset

Separar datos de entrenamiento y prueba.

```python
train_data, test_data = dataset_features.randomSplit([0.8, 0.2])
```

---

# Paso 5 — Entrenar modelo

```python
from pyspark.ml.regression import LinearRegression

lr = LinearRegression(
    featuresCol="features",
    labelCol="price"
)

model = lr.fit(train_data)
```

---

# Paso 6 — Generar predicciones

```python
predictions = model.transform(test_data)

predictions.select("features", "price", "prediction").show()
```

Ejemplo de salida:

```
features       price    prediction
[70,2,10]      180000   175000
[90,3,8]       220000   215000
```

---

# Paso 7 — Evaluar modelo

Utilizaremos la métrica **RMSE**.

```python
from pyspark.ml.evaluation import RegressionEvaluator

evaluator = RegressionEvaluator(
    labelCol="price",
    predictionCol="prediction",
    metricName="rmse"
)

rmse = evaluator.evaluate(predictions)

print("RMSE:", rmse)
```

Un RMSE menor indica mejor ajuste del modelo.

---

# Comparación con scikit-learn

Flujo en scikit-learn:

```
X
→ train_test_split
→ LinearRegression
→ predict
→ mean_squared_error
```

Flujo en Spark:

```
dataset
→ VectorAssembler
→ LinearRegression
→ transform
→ RegressionEvaluator
```

La lógica es la misma.

---

# Ejercicio

Responde a las siguientes preguntas:

1. ¿Qué variables se utilizan como features?
2. ¿Cuál es la variable objetivo del modelo?
3. ¿Para qué sirve `VectorAssembler`?
4. ¿Por qué se divide el dataset en entrenamiento y prueba?
5. ¿Qué indica la métrica RMSE?

---

# Conclusión

En este laboratorio se ha entrenado un modelo de regresión utilizando Spark MLlib con un dataset real.

El flujo seguido ha sido:

```
dataset
→ preparación de features
→ entrenamiento
→ predicción
→ evaluación
```

Este flujo es equivalente al utilizado en scikit-learn, pero adaptado a entornos Big Data.
