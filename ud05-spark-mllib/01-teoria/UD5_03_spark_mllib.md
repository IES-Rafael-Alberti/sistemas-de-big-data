# UD5 - Spark MLlib: arquitectura de Machine Learning distribuido

## Introducción

Apache Spark incluye una librería de Machine Learning llamada **MLlib**.

Esta librería permite entrenar modelos de aprendizaje automático utilizando datasets grandes que pueden estar distribuidos en multiples nodos.

MLlib incluye algoritmos para:

- regresión
- clasificación
- clustering
- recomendación
- reducción de dimensionalidad

Sin embargo, lo más importante de MLlib no son los algoritmos, sino **su arquitectura basada en pipelines**.

---

# Un problema habitual en Machine Learning

Cuando se construyen modelos de Machine Learning normalmente no se aplica directamente un algoritmo sobre los datos.

Antes es necesario realizar varias transformaciones.

Ejemplo típico:

```

datos originales
→ limpieza
→ transformación de variables
→ creacion de features
→ entrenamiento del modelo

```

Estas etapas forman lo que se llama **pipeline de Machine Learning**.

---

# Ejemplo sencillo de la vida real

Imaginemos que queremos predecir el precio de una vivienda.

Datos disponibles:

```

superficie
número de habitaciones
ciudad
antigüedad

```

Antes de entrenar un modelo necesitamos:

1 convertir variables categoricas
2 normalizar valores
3 construir un vector de features

Después podemos entrenar el modelo.

---

# Arquitectura de MLlib

Spark organiza el Machine Learning mediante tres conceptos principales:

- Transformer
- Estimator
- Pipeline

Estos conceptos permiten construir flujos de trabajo completos.

---

# Transformer

Un **Transformer** es un componente que transforma un dataset en otro dataset.

Recibe datos y devuelve datos transformados.

Ejemplos:

- convertir texto en números
- normalizar valores
- generar nuevas columnas

Ejemplo conceptual:

```

dataset original
↓
transformer
↓
dataset transformado

```

---

# Ejemplo de Transformer

Supongamos que tenemos un dataset con una columna llamada `ciudad`.

```

## id | ciudad

1  | Madrid
2  | Sevilla
3  | Madrid

```

Muchos algoritmos no pueden trabajar con texto.

Por tanto, necesitamos convertir esa variable en números.

Resultado:

```

## id | ciudad_index

1  | 0
2  | 1
3  | 0

```

Ese proceso lo realiza un **transformer**.

---

# Estimator

Un **Estimator** es un componente que **aprende a partir de los datos**.

Es decir, es el algoritmo de Machine Learning.

Ejemplos:

- regresión lineal
- regresión logística
- árboles de decisión
- random forest

Un estimator recibe un dataset y produce un **modelo entrenado**.

```

dataset
↓
estimator
↓
modelo entrenado

```

---

# Modelo entrenado

El modelo entrenado es también un **Transformer**.

Esto puede parecer extraño al principio, pero tiene sentido.

Una vez entrenado, el modelo se utiliza para **transformar datos en predicciones**.

```

datos nuevos
↓
modelo
↓
predicciones

````

Por eso el modelo actúa como un transformer.

---

# Comparacion con scikit-learn

En scikit-learn los pasos son muy similares.

Ejemplo en Python:

```python
model = LinearRegression()

model.fit(X_train, y_train)

predictions = model.predict(X_test)
````

En Spark ocurre algo parecido, pero usando DataFrames distribuidos.

Ejemplo conceptual:

```
dataset
→ entrenamiento
→ modelo
→ predicciones
```

La diferencia es que el procesamiento se realiza de forma distribuida.

---

# Pipelines en Spark

Un **pipeline** permite encadenar varios pasos de Machine Learning.

Ejemplo:

```
dataset
→ indexar variables categoricas
→ crear vector de features
→ entrenar modelo
→ generar predicciones
```

Esto se representa mediante un pipeline.

---

# Ejemplo conceptual de pipeline

```
datos
↓
StringIndexer
↓
VectorAssembler
↓
Modelo de regresión
↓
Predicciones
```

Cada etapa transforma el dataset.

---

# Ejemplo de la vida real

Supongamos que queremos predecir si un cliente cancelará su suscripción.

Datos disponibles:

```
edad
ciudad
numero_de_compras
antigüedad_cliente
```

Pipeline posible:

```
ciudad → convertir a indice
features → construir vector
modelo → clasificador
```

Resultado final:

```
probabilidad_de_cancelacion
```

Este pipeline puede entrenarse automáticamente sobre grandes datasets.

---

# Ventajas del enfoque de Spark

El uso de pipelines en Spark ofrece varias ventajas:

* facilita la reproducibilidad
* permite escalar a datasets grandes
* integra transformaciones y modelos
* simplifica el flujo de trabajo

---

# Relacion con el pipeline de datos

Recordemos el pipeline general de datos:

```
datos
→ procesamiento Spark
→ dataset analitico
→ modelo ML
→ predicciones
```

MLlib se encarga de la parte de **entrenamiento y predicción** dentro de este sistema.

---

# Conclusiones

Spark MLlib permite entrenar modelos de Machine Learning sobre grandes datasets.

Sus conceptos principales son:

* transformers
* estimators
* pipelines

Estos componentes permiten construir flujos completos de aprendizaje automático dentro de sistemas Big Data.

En el siguiente documento veremos **cómo preparar datos para ML en Spark**, incluyendo la construcción de features.

```

---

## Ejemplo rápido (pizarra)


```

scikit-learn

X -> modelo -> predicción

```

y luego:

```

Spark

dataset
-> transformaciones
-> features
-> modelo
-> predicciones

```

a recalcar:

> Spark no cambia el ML…
> **cambia la escala del sistema**.
