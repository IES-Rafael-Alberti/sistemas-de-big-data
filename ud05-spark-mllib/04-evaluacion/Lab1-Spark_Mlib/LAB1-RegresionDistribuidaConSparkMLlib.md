# LAB1 - Regresión con Spark MLlib

## Objetivo del laboratorio

El objetivo de este laboratorio es entrenar un modelo de regresión utilizando **Spark MLlib**.

Durante el laboratorio se realizarán los siguientes pasos:

1. cargar un dataset
2. preparar las features
3. dividir los datos en entrenamiento y prueba
4. entrenar un modelo de regresión
5. generar predicciones
6. evaluar el modelo

Este flujo es muy similar al que ya conocemos en **scikit-learn**, pero utilizando **Spark**.

---

# Dataset

En este laboratorio se utilizará un dataset sencillo de viviendas con las siguientes variables:

| variable | descripción |
|------|------|
| size | superficie de la vivienda |
| bedrooms | número de habitaciones |
| age | antigüedad |
| price | precio de la vivienda |

La variable objetivo será:

```

price

````

---

# Paso 1 — Crear sesión de Spark

Primero se inicia una sesión de Spark.

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("spark_ml_regression_lab") \
    .getOrCreate()
````

---

# Paso 2 — Crear dataset de ejemplo

Para simplificar el laboratorio se creará un dataset pequeño.

```python
data = [
    (50, 1, 10, 120000),
    (70, 2, 5, 180000),
    (90, 3, 8, 220000),
    (120, 4, 15, 250000),
    (60, 2, 20, 150000),
    (80, 3, 7, 200000),
    (100, 3, 3, 260000),
    (110, 4, 10, 280000)
]

columns = ["size", "bedrooms", "age", "price"]

dataset = spark.createDataFrame(data, columns)

dataset.show()
```

Resultado esperado:

```
size bedrooms age price
50   1        10  120000
70   2        5   180000
...
```

---

# Paso 3 — Crear vector de features

Spark necesita que las variables de entrada estén en una columna llamada **features**.

Para ello se utiliza **VectorAssembler**.

```python
from pyspark.ml.feature import VectorAssembler

assembler = VectorAssembler(
    inputCols=["size", "bedrooms", "age"],
    outputCol="features"
)

dataset_features = assembler.transform(dataset)

dataset_features.select("features", "price").show()
```

Ejemplo de resultado:

```
features            price
[50,1,10]           120000
[70,2,5]            180000
```

---

# Paso 4 — Dividir dataset en entrenamiento y prueba

Se divide el dataset en dos partes.

```python
train_data, test_data = dataset_features.randomSplit([0.8, 0.2])
```

---

# Paso 5 — Entrenar modelo de regresión

Se utilizará **LinearRegression** de Spark MLlib.

```python
from pyspark.ml.regression import LinearRegression

lr = LinearRegression(
    featuresCol="features",
    labelCol="price"
)

model = lr.fit(train_data)
```

Ahora el modelo está entrenado.

---

# Paso 6 — Generar predicciones

El modelo se aplica al conjunto de prueba.

```python
predictions = model.transform(test_data)

predictions.select("features", "price", "prediction").show()
```

Resultado esperado:

```
features       price   prediction
[90,3,8]       220000  215000
[60,2,20]      150000  160000
```

---

# Paso 7 — Evaluar el modelo

Para evaluar el modelo se utilizará la métrica **RMSE**.

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

Un valor menor de RMSE indica mejor ajuste.

---

# Comparación con scikit-learn

En scikit-learn el flujo sería:

```
X
→ train_test_split
→ LinearRegression
→ predict
→ mean_squared_error
```

En Spark el flujo es:

```
dataset
→ VectorAssembler
→ LinearRegression
→ transform
→ RegressionEvaluator
```

La lógica es la misma.

La diferencia es que Spark puede entrenar modelos sobre datasets mucho más grandes.

---

# Ejercicio

Responde a las siguientes preguntas:

1. ¿Qué variables se utilizan como features?
2. ¿Cuál es la variable objetivo del modelo?
3. ¿Qué hace VectorAssembler?
4. ¿Para qué sirve dividir el dataset en entrenamiento y prueba?
5. ¿Qué indica la métrica RMSE?

---

# Conclusión

En este laboratorio se ha entrenado un modelo de regresión utilizando Spark MLlib.

Se ha seguido el flujo típico de Machine Learning:

```
datos
→ preparación de features
→ entrenamiento
→ predicción
→ evaluación
```

Este flujo es el mismo que en scikit-learn, pero aplicado a datasets distribuidos.

```

---

## Recomendación docente (muy importante)

Antes de empezar el laboratorio, escribe esto en la pizarra:

```

scikit-learn
X → fit → predict

```

y luego:

```

Spark
dataset → fit → transform

```



> “Es exactamente lo mismo que ya sabéis.”

---
