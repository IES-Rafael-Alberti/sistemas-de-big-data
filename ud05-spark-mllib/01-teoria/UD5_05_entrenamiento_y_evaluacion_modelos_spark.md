# UD5 - Entrenamiento y evaluación de modelos en Spark MLlib

## Introducción

Una vez que los datos han sido preparados y convertidos en un conjunto de **features**, el siguiente paso es entrenar un modelo de Machine Learning.

En Spark MLlib el proceso es muy similar al que ya conocemos en scikit-learn:

1. preparar los datos
2. dividir en entrenamiento y prueba
3. entrenar el modelo
4. generar predicciones
5. evaluar el modelo

La diferencia principal es que Spark trabaja con **datasets distribuidos** y utiliza **DataFrames de Spark** en lugar de arrays o DataFrames de pandas.

---

# Comparación general con scikit-learn

En scikit-learn el flujo típico es:

```

datos
→ train_test_split
→ model.fit()
→ model.predict()
→ evaluación

````

Ejemplo en Python:

```python
from sklearn.linear_model import LinearRegression

model = LinearRegression()

model.fit(X_train, y_train)

predictions = model.predict(X_test)
````

En Spark el flujo es conceptualmente igual:

```
dataset
→ train/test split
→ entrenamiento del modelo
→ predicciones
→ evaluación
```

La diferencia es que los datos se procesan de forma distribuida.

---

# División del dataset

Antes de entrenar un modelo se separa el dataset en dos partes:

* conjunto de entrenamiento
* conjunto de prueba

Esto permite comprobar si el modelo generaliza correctamente.

En Spark:

```python
train_data, test_data = dataset.randomSplit([0.8, 0.2])
```

Esto significa:

* 80 % de los datos para entrenar
* 20 % para evaluar

---

# Entrenamiento de un modelo

Un modelo en Spark se entrena utilizando un **Estimator**.

Ejemplo: regresión lineal.

```python
from pyspark.ml.regression import LinearRegression

lr = LinearRegression(
    featuresCol="features",
    labelCol="price"
)

model = lr.fit(train_data)
```

Aquí ocurren varias cosas:

1. se crea el algoritmo de regresión
2. se entrena usando los datos de entrenamiento
3. se obtiene un modelo entrenado

Este modelo se puede utilizar posteriormente para generar predicciones.

---

# Generación de predicciones

Una vez entrenado el modelo, se puede aplicar sobre datos nuevos.

En Spark esto se realiza utilizando el método `transform`.

```python
predictions = model.transform(test_data)
```

El resultado es un nuevo DataFrame que incluye:

* las columnas originales
* la predicción generada por el modelo

Ejemplo simplificado:

```
features | price | prediction
--------------------------------
[...]    | 210000 | 205000
[...]    | 150000 | 148000
```

---

# Evaluación del modelo

Una vez obtenidas las predicciones, es necesario evaluar la calidad del modelo.

Esto se realiza comparando:

```
valor real
vs
valor predicho
```

Spark incluye herramientas específicas para evaluar modelos.

---

# Evaluación de regresión

Para modelos de regresión se utilizan métricas como:

* RMSE (error cuadrático medio)
* MAE (error absoluto medio)
* R2

Ejemplo en Spark:

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

Un RMSE más bajo indica un modelo más preciso.

---

# Comparación con scikit-learn

En scikit-learn el cálculo es muy parecido.

Ejemplo:

```python
from sklearn.metrics import mean_squared_error

rmse = mean_squared_error(y_test, predictions, squared=False)
```

La lógica es exactamente la misma.

La diferencia es que Spark evalúa modelos sobre datasets distribuidos.

---

# Evaluación de clasificación

En problemas de clasificación se utilizan otras métricas.

Ejemplos:

* accuracy
* precisión
* recall
* AUC

En Spark se utiliza `BinaryClassificationEvaluator`.

Ejemplo:

```python
from pyspark.ml.evaluation import BinaryClassificationEvaluator

evaluator = BinaryClassificationEvaluator(
    labelCol="label",
    rawPredictionCol="prediction",
    metricName="areaUnderROC"
)

auc = evaluator.evaluate(predictions)
```

Un AUC cercano a 1 indica un buen modelo.

---

# Ejemplo completo de flujo de entrenamiento

El flujo completo en Spark suele ser:

```
dataset
↓
train/test split
↓
entrenamiento del modelo
↓
predicciones
↓
evaluación
```

Esto es equivalente a lo que ya conocemos en scikit-learn.

---

# Ejemplo real: predicción de precios de vivienda

Supongamos que queremos predecir el precio de una vivienda utilizando estas variables:

```
superficie
habitaciones
antigüedad
ciudad
```

Pipeline simplificado:

```
datos
↓
StringIndexer (ciudad)
↓
VectorAssembler
↓
regresión lineal
↓
predicción de precios
```

Este flujo puede entrenarse sobre millones de registros utilizando Spark.

---

# Relación con el pipeline de datos

Recordemos el pipeline completo:

```
fuentes de datos
→ procesamiento con Spark
→ dataset analítico
→ modelo ML
→ predicciones
→ visualización o decisiones
```

En esta unidad estamos trabajando en la fase de **entrenamiento del modelo**.

---

# Conclusión

El entrenamiento de modelos en Spark sigue los mismos principios que en scikit-learn:

* dividir los datos
* entrenar el modelo
* generar predicciones
* evaluar resultados

La diferencia principal es que Spark permite realizar estos procesos sobre datasets muy grandes utilizando procesamiento distribuido.

En el siguiente laboratorio aplicaremos estos conceptos para entrenar un modelo utilizando Spark MLlib.

```

---

## En definitiva

### Lo que ya sabéis

```

scikit-learn

X_train
↓
fit()
↓
modelo
↓
predict()

```

### Spark

```

dataset
↓
fit()
↓
modelo
↓
transform()

```



> **Spark no cambia el Machine Learning.
> Cambia cómo se procesan los datos.**
