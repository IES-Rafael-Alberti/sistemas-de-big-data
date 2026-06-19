# UD5 - Arquitectura del pipeline de datos en Big Data

## Introducción

En los sistemas modernos de analítica de datos, el Machine Learning no es un proceso aislado.
Forma parte de una arquitectura de datos más amplia en la que los datos se ingieren, se procesan, se almacenan y finalmente se utilizan para generar conocimiento o predicciones.

Antes de estudiar Spark MLlib, es importante entender **dónde se sitúa el Machine Learning dentro del pipeline de datos**.

---

# Pipeline típico de datos en Big Data

Un pipeline de datos completo suele seguir la siguiente estructura:

```

Fuentes de datos
→ Ingesta de datos
→ Procesamiento distribuido (Spark)
→ Almacenamiento analitico
→ Analitica avanzada

```

La analítica avanzada puede incluir:

- Business Intelligence (dashboards)
- Machine Learning
- Sistemas de recomendacion
- Analitica predictiva

---

# Vision general del sistema

Una arquitectura simplificada puede representarse así:

```

Fuentes de datos
|
v
Ingesta
|
v
Procesamiento (Spark)
|
v
Datos analiticos
|
|
v   v
Machine Learning   Business Intelligence

```

Cada bloque del sistema cumple una función concreta.

---

# Fuentes de datos

Las fuentes de datos son el origen de la información que se analiza.

Ejemplos habituales:

- APIs externas
- sensores
- logs de aplicaciones
- bases de datos transaccionales
- archivos CSV o Parquet

Ejemplo real:

```

ventas.csv
clientes.parquet
api_pedidos

```

Estos datos suelen llegar en distintos formatos y con diferentes niveles de calidad.

---

# Ingesta de datos

La ingesta consiste en **recoger los datos y llevarlos al sistema de procesamiento**.

Esta fase puede implicar:

- descarga de archivos
- consultas a bases de datos
- consumo de APIs
- lectura de streams de datos

Herramientas habituales:

- Python
- Spark
- Kafka
- sistemas ETL

---

# Procesamiento distribuido

Una vez que los datos han sido ingeridos, se procesan para prepararlos para el análisis.

En esta fase se realizan tareas como:

- limpieza de datos
- filtrado
- transformaciones
- agregaciones
- cálculo de metricas

En entornos Big Data este procesamiento suele realizarse con **Apache Spark**, ya que permite trabajar con grandes volúmenes de datos de forma distribuida.

Ejemplo:

```

datos brutos
→ limpieza
→ transformación
→ dataset analitico

```

---

# Almacenamiento analitico

Los datos procesados se almacenan en sistemas optimizados para análisis.

Ejemplos comunes:

- archivos Parquet
- data warehouses
- bases de datos analíticas

Ejemplo de tablas analíticas:

```

ventas_agregadas
clientes_segmentados
metricas_diarias

```

Estas tablas suelen ser las que utilizan los sistemas de analítica.

---

# Machine Learning en el pipeline

El Machine Learning utiliza los datos preparados para entrenar modelos predictivos.

Ejemplos de problemas:

- predecir ventas
- detectar fraude
- clasificar clientes
- estimar demanda futura

En esta unidad se utilizará **Spark MLlib** para entrenar modelos sobre datasets distribuidos.

El flujo típico es:

```

dataset preparado
→ generación de features
→ entrenamiento del modelo
→ evaluación
→ uso del modelo

```

---

# Business Intelligence

Otra forma de explotar los datos es mediante herramientas de Business Intelligence.

Estas herramientas permiten crear:

- dashboards
- gráficos
- informes interactivos

En esta asignatura se han utilizado herramientas como:

- Metabase
- Superset

Estas herramientas permiten explorar los datos y tomar decisiones basadas en información.

---

# Orquestacion de pipelines

En sistemas reales el pipeline completo suele automatizarse.

Herramientas como **Airflow** permiten definir flujos de trabajo que ejecutan tareas como:

```

1 descarga de datos
2 procesamiento con Spark
 3 actualización de datasets
 4 entrenamiento de modelos
 5 actualización de dashboards

```

Este tipo de sistemas se denominan **pipelines de datos**.

---

# Relacion con las unidades del modulo

Este pipeline conecta con las distintas unidades del curso.

| Unidad | Contenido |
|------|------|
| UD2 | limpieza y preparación de datos |
| UD3 | procesamiento distribuido con Spark |
| UD4 | analítica y dashboards |
| UD5 | Machine Learning distribuido |
| UD6 | proyecto integrador |

Cada unidad representa una parte del sistema completo.

---

# Conclusión

El Machine Learning no debe entenderse como un proceso aislado.

Forma parte de una arquitectura de datos que incluye:

- ingesta
- procesamiento
- almacenamiento
- analítica

Comprender esta arquitectura es fundamental para trabajar en sistemas Big Data reales.

En los siguientes documentos de la unidad se estudiará cómo utilizar **Spark MLlib** para entrenar modelos predictivos dentro de este pipeline.
