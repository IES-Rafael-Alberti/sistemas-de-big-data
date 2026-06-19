---
title: "UD2 — Ingesta e Integración de Datos en Sistemas de Big Data"
author: "José Manuel Sánchez Álvarez"
institute: "IES Rafael Alberti"
course: "Curso 2025–2026"
lang: "es"
toc: true
number-sections: true
fontsize: 11pt
geometry: "margin=2.5cm"
---

# 1. Introducción

El volumen, la variedad y la velocidad de los datos que se generan en la actualidad han transformado la forma en que las organizaciones gestionan la información. Esta unidad didáctica se centra en los procesos de **ingesta e integración de datos**, una fase esencial dentro de los **Sistemas de Big Data**, donde la calidad y la coherencia de los datos determinan el éxito de las etapas posteriores de análisis y modelado.

En este contexto, se explorarán distintas fuentes y formatos de datos, las herramientas utilizadas para su integración —como *Airbyte*, *Apache Spark*, y *Python*—, así como las buenas prácticas de gobernanza, seguridad y cumplimiento normativo.

**Resultados de Aprendizaje vinculados:**
- RA1: Caracteriza los sistemas Big Data y sus componentes.  
- RA3: Integra y procesa datos utilizando herramientas Big Data.  
- RA4: Evalúa la calidad y seguridad de los datos.  

# 2. Objetivos didácticos

- Comprender las arquitecturas de ingesta y flujo de datos en entornos Big Data.  
- Distinguir entre procesos *batch*, *streaming* y *near real-time*.  
- Conocer las principales herramientas de integración (Airbyte, Spark, Python).  
- Implementar un pipeline de ingesta, transformación y carga de datos.  
- Aplicar medidas de seguridad y cumplimiento (RGPD, anonimización).  

# 3. Fundamentos teóricos

## 3.1 Almacenamiento y sistemas distribuidos

Los sistemas de almacenamiento en Big Data deben garantizar escalabilidad, tolerancia a fallos y acceso eficiente. Entre los más utilizados se encuentran:

- **HDFS (Hadoop Distributed File System)**: Sistema de archivos distribuido que permite el almacenamiento masivo y replicado.  
- **Sistemas NoSQL** (MongoDB, Cassandra): diseñados para manejar datos semiestructurados o no estructurados.  
- **Bases de datos en la nube**: servicios gestionados (Amazon S3, Google BigQuery, Azure Blob Storage).  

> Ejemplo: En un entorno Hadoop, los datos se fragmentan en bloques de 128 MB distribuidos entre nodos, con una replicación por defecto de 3 copias para garantizar disponibilidad.

## 3.2 Integración de datos y ETL

El proceso de **ingesta e integración** se articula generalmente mediante pipelines ETL (Extract, Transform, Load) o ELT (Extract, Load, Transform).  
Estas arquitecturas permiten extraer datos de diversas fuentes, transformarlos y cargarlos en sistemas destino, como un *data lake* o un *data warehouse*.

```mermaid
flowchart LR
A[Fuente de datos] --> B[Extracción]
B --> C[Transformación]
C --> D[Carga en sistema Big Data]
```

# 4. Ingesta de datos

## 4.1 Ingesta mediante scripts en Python

Los scripts en Python permiten automatizar la extracción de datos desde ficheros o APIs.  
Ejemplo básico de lectura de múltiples CSV y carga incremental:

```python
import pandas as pd
from datetime import datetime

# Carga inicial
df = pd.read_csv("data_2024_10.csv")

# Nueva carga (delta)
df_new = pd.read_csv("data_2024_11.csv")

# Unificación e identificación de nuevos registros
df_combined = pd.concat([df, df_new]).drop_duplicates()
df_combined["fecha_carga"] = datetime.now()

df_combined.to_csv("data_unificado.csv", index=False)
```

## 4.2 Ingesta con Airbyte

[Airbyte](https://airbyte.com) es una plataforma *open-source* de integración que automatiza la extracción y sincronización de datos entre orígenes y destinos.

Ejemplo de conexión:  
- Fuente: API REST (Salesforce, Google Analytics, GitHub)  
- Destino: PostgreSQL o S3  

**Pasos básicos:**
1. Crear *source connector* → configurar API o base de datos.  
2. Crear *destination connector* → definir destino (S3, BigQuery, etc.).  
3. Definir sincronización (*manual*, *cron*, *streaming*).  
4. Supervisar ejecución desde la interfaz o vía CLI.  

```bash
airbytectl connections create   --source github-source   --destination s3-destination   --sync-mode incremental
```

# 5. Integración y transformación de datos

## 5.1 Procesos batch y near-real-time

- **Batch:** procesamiento en bloques o lotes (por ejemplo, cada noche).  
- **Near real-time:** actualización periódica (minutos).  
- **Streaming:** flujo continuo de datos (IoT, logs, redes sociales).  

## 5.2 Ejemplo con Apache Spark

Spark permite integrar y transformar datos a gran escala mediante *DataFrames*.

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("IntegracionDatos").getOrCreate()

# Lectura desde CSV
df = spark.read.csv("data_unificado.csv", header=True, inferSchema=True)

# Limpieza básica
df_clean = df.dropna().dropDuplicates()

# Agregación
resumen = df_clean.groupBy("region").count()

resumen.show()
```

## 5.3 Control de calidad y validación

```python
from pyspark.sql.functions import col

# Reglas de validación
valid = df_clean.filter(col("edad") > 0).filter(col("ingresos") >= 0)

invalid = df_clean.subtract(valid)
print(f"Registros no válidos: {invalid.count()}")
```

# 6. Seguridad y cumplimiento (RGPD)

En un entorno Big Data, la gestión responsable de los datos es prioritaria.  
Los sistemas deben garantizar confidencialidad, integridad y disponibilidad.  

**Medidas recomendadas:**
- Cifrado en tránsito y en reposo (TLS, AES‑256).  
- Enmascaramiento y anonimización de datos personales.  
- Auditoría y trazabilidad de accesos.  

Ejemplo de anonimización con Python:

```python
import hashlib

def anonimizar(valor):
    return hashlib.sha256(valor.encode()).hexdigest()

df["dni_hash"] = df["dni"].apply(anonimizar)
```

# 7. Actividad final

**Título:** Creación de un pipeline de ingesta e integración de datos

**Descripción:**  
Diseña un flujo de trabajo completo para la ingesta de datos de una fuente pública (CSV, JSON o API), su integración con Spark y la validación de calidad antes de almacenarlos en un sistema destino (p. ej. S3 simulado o carpeta local).

**Entregables:**
- Script o notebook en Python con comentarios.  
- Capturas de pantalla del proceso de integración (Airbyte o Spark).  
- Breve memoria técnica en Markdown o PDF.  

# 8. Rúbrica de evaluación

| Criterio | Descripción | Peso |
|-----------|--------------|------|
| Diseño del pipeline | Claridad y coherencia del flujo ETL | 25% |
| Implementación técnica | Correcta automatización en Python/Airbyte/Spark | 25% |
| Calidad de datos | Validaciones, limpieza y transformación | 20% |
| Seguridad y cumplimiento | Aplicación de medidas básicas RGPD | 15% |
| Documentación | Claridad, formato y conclusiones | 15% |

# 9. Bibliografía y recursos complementarios

- White, T. (2023). *Hadoop: The Definitive Guide*. O’Reilly.  
- Chambers, B., Zaharia, M. (2022). *Spark: The Definitive Guide*. O’Reilly.  
- Artasanchez, A., Joshi, P. (2023). *Artificial Intelligence with Python*. Packt.  
- Airbyte Docs: [https://docs.airbyte.com](https://docs.airbyte.com)  
- Apache Spark Docs: [https://spark.apache.org/docs/latest/](https://spark.apache.org/docs/latest/)  
- AWS Big Data Blog: [https://aws.amazon.com/blogs/big-data/](https://aws.amazon.com/blogs/big-data/)
