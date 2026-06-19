# Documento de entrega - LAB3
Clasificación con Spark MLlib (Titanic)

## Información del estudiante

Nombre y apellidos:

Grupo:

Fecha de entrega:

---

# Objetivo del laboratorio

El objetivo de este laboratorio es entrenar un modelo de **clasificación** utilizando Spark MLlib sobre un dataset real (Titanic).

Se trabajará con:

- carga de datos desde fichero
- tratamiento de variables categóricas
- preparación de features
- entrenamiento de un modelo de clasificación
- generación de predicciones
- evaluación del modelo

---

# Archivos a entregar

Se deberán entregar los siguientes archivos:

```

lab3_spark_titanic.ipynb
titanic.csv

```

El notebook debe ejecutarse completamente sin errores.

---

# Contenido mínimo del notebook

El notebook debe incluir las siguientes secciones.

---

## 1. Carga del dataset

Cargar el archivo:

```

titanic.csv

```

utilizando:

```

spark.read.csv

```

Mostrar:

```

dataset.show()
dataset.printSchema()

```

---

## 2. Selección y limpieza de datos

Seleccionar las columnas:

```

pclass
sex
age
fare
embarked
survived

```

Eliminar valores nulos utilizando:

```

dropna()

```

---

## 3. Transformación de variables categóricas

Aplicar `StringIndexer` a las columnas:

```

sex
embarked

```

Generar nuevas columnas numéricas.

---

## 4. Preparación de features

Crear la columna `features` utilizando:

```

VectorAssembler

```

Variables utilizadas:

```

pclass
sex_index
age
fare
embarked_index

```

Variable objetivo:

```

survived

```

---

## 5. División del dataset

Dividir el dataset en entrenamiento y prueba utilizando:

```

randomSplit

```

---

## 6. Entrenamiento del modelo

Entrenar un modelo utilizando:

```

LogisticRegression

```

---

## 7. Predicciones

Aplicar el modelo sobre el conjunto de prueba utilizando:

```

transform()

```

Mostrar las columnas:

```

features
survived
prediction
probability

```

---

## 8. Evaluación del modelo

Calcular al menos:

- AUC (obligatorio)
- Accuracy (opcional pero recomendable)

Utilizar:

```

BinaryClassificationEvaluator

```

Mostrar los resultados.

---

# Preguntas de reflexión

Responder brevemente:

1. ¿Qué variables se utilizan como features?
2. ¿Cuál es la variable objetivo?
3. ¿Por qué es necesario usar `StringIndexer`?
4. ¿Qué diferencia hay entre `fit()` y `transform()`?
5. ¿Qué indica la métrica AUC?
6. ¿Qué significa que una predicción sea 1?

---

# Criterios de evaluación

| Criterio | Puntos |
|--------|-------|
| Carga y limpieza del dataset | 2 |
| Transformación de variables categóricas | 2 |
| Preparación de features | 2 |
| Entrenamiento y predicciones | 2 |
| Evaluación e interpretación | 2 |

Puntuación total: 10 puntos

---

# Consideraciones importantes

- El notebook debe ejecutarse completo sin errores.
- Se deben mostrar resultados intermedios.
- Las respuestas deben ser claras y concisas.

Penalización:

```

Notebook que no ejecuta completamente: -2 puntos

```
