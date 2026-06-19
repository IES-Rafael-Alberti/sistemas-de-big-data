# UD5 - Preparacion de features para Machine Learning en Spark

## Introducción

En Machine Learning los algoritmos no trabajan directamente con los datos originales.

Antes de entrenar un modelo es necesario **preparar los datos** y convertirlos en un formato adecuado.

Este proceso se conoce como **feature engineering** o preparación de variables.

En muchos proyectos de analítica de datos esta fase representa **la mayor parte del trabajo**.

---

# Qué es una feature

Una **feature** es una variable que se utiliza como entrada para un modelo de Machine Learning.

Ejemplo sencillo:

Supongamos que queremos predecir el precio de una vivienda.

Datos disponibles:

```

superficie
numero_habitaciones
ciudad
antigüedad

```

Estas variables se utilizan como **features** del modelo.

---

# Problema habitual en datos reales

Los datos originales suelen presentar varios problemas:

- valores categóricos
- datos faltantes
- escalas diferentes
- variables no numericas

Ejemplo:

```

## id | ciudad | ingresos | compras

1  | Madrid | 2000     | 5
2  | Sevilla| 1800     | 3
3  | Madrid | 2400     | 8

```

Muchos algoritmos de Machine Learning **sólo aceptan datos numéricos**.

Por tanto es necesario transformar los datos.

---

# Flujo típico de preparación de features

Un pipeline habitual de preparación de datos es:

```

dataset original
→ conversión de variables categóricas
→ construcción de vector de features
→ normalización
→ dataset final para entrenamiento

```

En Spark estas operaciones se realizan mediante **transformers**.

---

# Variables categóricas

Las variables categóricas contienen texto o categorías.

Ejemplo:

```

ciudad
genero
categoria_producto

```

Muchos algoritmos no pueden trabajar directamente con texto.

Por tanto debemos convertir las categorías en números.

---

# StringIndexer

Spark proporciona un transformer llamado **StringIndexer**.

Este transformer convierte texto en índices numéricos.

Ejemplo:

Dataset original:

```

## ciudad

Madrid
Sevilla
Madrid
Barcelona

```

Después de aplicar StringIndexer:

```

## ciudad | ciudad_index

Madrid | 0
Sevilla| 1
Madrid | 0
Barcelona | 2

````

Esto permite que el modelo utilice esa variable.

---

# Ejemplo conceptual en Spark

En PySpark se utiliza de la siguiente forma:

```python
from pyspark.ml.feature import StringIndexer

indexer = StringIndexer(
    inputCol="ciudad",
    outputCol="ciudad_index"
)

dataset_indexado = indexer.fit(dataset).transform(dataset)
````

Este proceso aprende las categorías y crea una nueva columna numérica.

---

# Construccion del vector de features

En Spark los algoritmos de Machine Learning no reciben columnas separadas.

En lugar de eso utilizan un **vector de features**.

Esto significa que todas las variables se combinan en una sola columna.

Ejemplo:

```

edad | ingresos | compras
-------------------------
30   | 2000     | 5
45   | 3200     | 7

```

Se convierte en:

```

features
----------------
[30, 2000, 5]
[45, 3200, 7]

```

---

# VectorAssembler

Spark proporciona un transformer llamado **VectorAssembler** para crear este vector.

Ejemplo:

```python
from pyspark.ml.feature import VectorAssembler

assembler = VectorAssembler(
    inputCols=["edad", "ingresos", "compras"],
    outputCol="features"
)

dataset_features = assembler.transform(dataset)
```

El resultado es una columna llamada **features**.

Esta columna es la que utilizan los algoritmos de Machine Learning.

---

# Normalizacion de variables

En algunos casos las variables tienen escalas muy diferentes.

Ejemplo:

```

edad → valores entre 18 y 80
ingresos → valores entre 1000 y 5000

```

Estas diferencias pueden afectar al entrenamiento del modelo.

Por ello se suele aplicar **normalización o escalado**.

---

# StandardScaler

Spark incluye el transformer **StandardScaler**.

Este transformer ajusta las variables para que tengan:

* media cercana a 0
* desviacion estandar cercana a 1

Ejemplo conceptual:

```

features originales
→ normalización
→ features escaladas

```

Ejemplo en PySpark:

```python
from pyspark.ml.feature import StandardScaler

scaler = StandardScaler(
    inputCol="features",
    outputCol="scaled_features"
)

modelo_scaler = scaler.fit(dataset_features)

dataset_scaled = modelo_scaler.transform(dataset_features)
```

---

# Train-test split

Una vez preparados los datos se divide el dataset en dos partes:

* conjunto de entrenamiento
* conjunto de prueba

Esto permite evaluar el modelo.

Ejemplo:

```

dataset completo
→ train (80%)
→ test (20%)

```

Ejemplo en Spark:

```python
train_data, test_data = dataset.randomSplit([0.8, 0.2])
```

---

# Pipeline completo de preparación

Un flujo típico de preparación de datos puede ser:

```

dataset
↓
StringIndexer
↓
VectorAssembler
↓
StandardScaler
↓
dataset listo para ML

```

Este dataset se utiliza posteriormente para entrenar el modelo.

---

# Ejemplo real de pipeline

Supongamos que queremos predecir si un cliente cancelará su suscripción.

Datos disponibles:

```

edad
ciudad
numero_compras
antigüedad_cliente

```

Pipeline posible:

```

ciudad → StringIndexer
features → VectorAssembler
normalización → StandardScaler
modelo → clasificador

```

Este pipeline transforma los datos en un formato adecuado para el modelo.

---

# Conclusiones

Antes de entrenar un modelo de Machine Learning es necesario preparar los datos.

En Spark este proceso se realiza mediante transformers como:

* StringIndexer
* VectorAssembler
* StandardScaler

Estas herramientas permiten transformar datasets grandes de forma distribuida.

En el siguiente documento se estudiará **cómo entrenar y evaluar modelos en Spark MLlib**.

```

---

## Recomendación para tu clase (muy útil)

Haz **este ejemplo en pizarra** porque les aclara todo:

### Dataset original

```

edad | ciudad | compras

```

### Paso 1

```

StringIndexer

```
```

edad | ciudad_index | compras

```

### Paso 2

```

VectorAssembler

```
```

features = [edad, ciudad_index, compras]

```

### Paso 3

```

modelo

```
