# 🟦 **Actividad modificada: Pipeline Moderno (Airbyte Cloud + Redpanda Cloud + Python)**

## ✔️ Objetivo general

Construir un pipeline real completo utilizando:

* **PostgreSQL Cloud** (Neon)
* **Airbyte Cloud** (ingesta batch/incremental)
* **Redpanda Cloud** (Kafka-compatible sin tarjeta)
* **Python en Google Colab** (consumer streaming)

El alumnado experimenta:

* **Ingesta ELT batch/incremental → Airbyte**
* **CDC / streaming Kafka-like → Redpanda**
* **Consumo en tiempo real → Python**

Sin necesidad de instalaciones locales.

---

# 🧩 **1. Crear la base de datos en Neon (PostgreSQL Cloud)**

1. Entrar en [https://neon.tech](https://neon.tech)

2. Crear proyecto nuevo

3. Guardar credenciales:

   * HOST
   * USER
   * PASSWORD
   * DATABASE
   * PORT

4. Crear tabla:

```sql
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100),
  actualizado TIMESTAMP DEFAULT NOW()
);
```

5. Insertar datos de prueba:

```sql
INSERT INTO clientes(nombre,email)
VALUES 
 ('Ana','ana@example.com'),
 ('Luis','luis@example.com');
```

---

# 🟥 **2. Crear el cluster Kafka en Redpanda Cloud (Free Tier)**

1. Entrar en:
   [https://cloud.redpanda.com/](https://cloud.redpanda.com/)

2. Crear cuenta gratis (sin tarjeta)

3. Crear un clúster "Developer" (gratuito)

4. Ir a **Topics → Create Topic**

   Nombre del topic:

   ```
   clientes_cdc
   ```

5. Obtener los valores de conexión (todos necesarios para Python):
https://cloud.redpanda.com/clusters/d4k49nkor3ae7l6jds0g/overview?ct=s 
   * **Bootstrap servers**
   * **SASL username**
   * **SASL password**
   * **Security protocol:** SASL_SSL
   * **SASL mechanism:** SCRAM-SHA-256

Redpanda es totalmente compatible con Kafka, así que los consumidores funcionan igual que con Confluent.

---

# 🟩 **3. Ingesta batch/incremental con Airbyte Cloud**

1. Entrar en:
   [https://cloud.airbyte.com](https://cloud.airbyte.com)

2. Crear cuenta gratuita

3. Crear **Source → PostgreSQL**

   Parámetros = datos de Neon

4. Crear **Destination → File (JSON o Parquet)**

   * Carpeta: `airbyte_output/`

5. Crear **Connection**:

   * Sync mode: **Incremental**
   * Cursor: `actualizado`
   * Primary key: `id`

6. Ejecutar la sincronización y comprobar salida.

---

# 🟦 **4. Crear el flujo CDC hacia Redpanda (con Airbyte Cloud)**

Redpanda no tiene Debezium Cloud, pero **Airbyte Cloud sí tiene un conector CDC de PostgreSQL** que funciona con Neon → topic Kafka.

Pasos:

1. En Airbyte Cloud → **New Source**

2. Elegir: **PostgreSQL (CDC Enabled)**

   Configurar:

   * Host: Neon
   * Port: 5432
   * DB: empresa
   * User/pass: credenciales de Neon
   * *Habilitar CDC (slot + replication)*

3. Crear **Destination → Kafka**
   (Redpanda es compatible con Kafka API)

   Completar con los datos:

   | Campo             | Valor             |
   | ----------------- | ----------------- |
   | Bootstrap servers | valor de Redpanda |
   | Security protocol | SASL_SSL          |
   | Mechanism         | SCRAM-SHA-256     |
   | Username          | SASL username     |
   | Password          | SASL password     |
   | Topic             | clientes_cdc      |

4. Crear **Connection (CDC)**

5. Ejecutar sincronización

Con esto, cualquier cambio en `clientes` se enviará al topic `clientes_cdc` en Redpanda Cloud.

---

# 🐍 **5. Consumidor Python en Google Colab**

1. Abrir Colab
2. Instalar cliente Kafka:

```python
!pip install kafka-python
```

3. Consumidor compatible con Redpanda:

```python
from kafka import KafkaConsumer
import json

bootstrap = "PON_AQUÍ_bootstrap"     # ej: sasl.redpanda.cloud:9092
username = "PON_AQUÍ_username"
password = "PON_AQUÍ_password"

consumer = KafkaConsumer(
    "clientes_cdc",
    bootstrap_servers=bootstrap,
    security_protocol="SASL_SSL",
    sasl_mechanism="SCRAM-SHA-256",
    sasl_plain_username=username,
    sasl_plain_password=password,
    auto_offset_reset="earliest",
    value_deserializer=lambda v: json.loads(v.decode('utf-8'))
)

print("Esperando eventos CDC...\n")

for msg in consumer:
    print(json.dumps(msg.value, indent=2))
```

4. Ejecutar el notebook

5. En Neon, modificar datos:

```sql
UPDATE clientes
SET nombre='Ana Gómez'
WHERE id=1;
```

El evento CDC aparece en Colab en tiempo real.

---

# 📄 **6. Documentación a entregar**

El alumnado debe entregar:

* Diagrama del pipeline (Airbyte → File + CDC → Redpanda → Python)

* Capturas de:

  * Source en Airbyte
  * Destination
  * Connection batch
  * Connection CDC → Kafka
  * Topic en Redpanda
  * Notebook mostrando mensajes

* Un informe técnico (1–2 páginas)

---

# 🎯 **7. Resultado esperado**

El pipeline resultante permite:

* **Ingesta batch/incremental** con Airbyte → File system
* **CDC streaming** Neon → Airbyte → Redpanda
* **Consumo en vivo** desde Python



# 🟦 **Práctica B — Pipeline Cloud Completo con Airbyte Cloud, Neon, S3 y Redpanda (Kafka-compatible)**

## 1. Introducción

En esta práctica construiremos un pipeline moderno de datos utilizando **únicamente servicios cloud gratuitos**, sin instalaciones locales y sin necesidad de tarjeta de crédito.

El pipeline incluirá:

* **Neon** → Base de datos PostgreSQL serverless (origen de datos).
* **Airbyte Cloud** → Herramienta de ingesta ELT (batch e incremental).
* **Amazon S3 (AWS Academy)** → Data Lake en formato Parquet (destino batch).
* **Redpanda Cloud** → Sistema de mensajería Kafka-compatible (destino CDC/streaming).
* **Python (Google Colab)** → Consumidor de eventos en tiempo real.

Este flujo reproduce un **Data Ingestion Layer** real de sistemas Big Data y Lakehouse modernos, permitiendo que el alumnado experimente tanto ingesta batch como streaming CDC, todo desde la nube.

---

# 2. Objetivos de la práctica

Al finalizar la actividad, el alumnado será capaz de:

1. Desplegar un origen PostgreSQL serverless en Neon.
2. Configurar Jobs de ingesta en Airbyte Cloud.
3. Sincronizar tablas hacia un **data lake en S3** en formato Parquet.
4. Activar captura de datos en cambio (CDC) mediante Airbyte → Redpanda (Kafka).
5. Consumir eventos Kafka desde Python en tiempo real.
6. Analizar ficheros Parquet almacenados en S3 desde Pandas o PySpark.

---

# 3. Arquitectura del pipeline

```
       ┌──────────────┐       Batch/Incremental       ┌─────────────┐
       │     Neon      │ ───────────────────────────► │     S3       │
       │ (PostgreSQL)  │                              │  Data Lake   │
       └──────────────┘                              └─────────────┘
                 │                                            │
                 │ CDC (changes)                              │
                 ▼                                            ▼
          ┌──────────────┐      Streaming (CDC)        ┌──────────────┐
          │  Airbyte      │ ─────────────────────────► │  Redpanda     │
          │    Cloud      │                             │ (Kafka Cloud)│
          └──────────────┘                             └──────────────┘
                                                              │
                                                              ▼
                                                     ┌────────────────┐
                                                     │  Python Colab  │
                                                     │ (KafkaConsumer)│
                                                     └────────────────┘
```

---

# 4. PASO 1 — Crear el origen en Neon (PostgreSQL serverless)

1. Ir a:
   [https://neon.tech](https://neon.tech)
2. Crear proyecto.
3. Guardar las credenciales (host, user, password, dbname, port).
4. Crear la tabla de práctica:

```sql
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    actualizado TIMESTAMP DEFAULT NOW()
);
```

5. Insertar datos:

```sql
INSERT INTO clientes (nombre, email)
VALUES
 ('Ana','ana@example.com'),
 ('Luis','luis@example.com');
```

6. Activar **Public Access** en:
   Neon → Settings → IP Allowlist → `0.0.0.0/0`
   (luego podrás restringirlo)

---

# 5. PASO 2 — Crear el destino en Amazon S3 (Data Lake)

## 5.1 Crear el bucket S3 (AWS Academy)

1. Entrar en AWS Academy Learner Lab.
2. Abrir S3 → Create Bucket.
3. Configurar:

| Campo               | Valor recomendado       |
| ------------------- | ----------------------- |
| Bucket name         | `sbd-airbyte-lake-2025` |
| Region              | `eu-west-1`             |
| Block public access | ENABLED                 |
| Versioning          | Optional                |

---

## 5.2 Crear un usuario IAM con acceso programático

1. IAM → Users → Create user
2. Nombre: `airbyte-s3-writer`
3. Habilitar **Programmatic Access**
4. Adjuntar política **AmazonS3FullAccess**
5. Guardar:

* Access Key
* Secret Key

---

## 5.3 Configurar destino Amazon S3 en Airbyte Cloud

En Airbyte Cloud:

1. Destinations → New Destination
2. Elegir **Amazon S3**
3. Parámetros:

| Campo          | Valor                   |
| -------------- | ----------------------- |
| S3 Bucket Name | `sbd-airbyte-lake-2025` |
| Region         | `eu-west-1`             |
| Bucket Path    | `raw/`                  |
| Access Key     | (tu clave)              |
| Secret Key     | (tu secreto)            |
| Output format  | **Parquet**             |

Guardar.

---

# 6. PASO 3 — Configurar ingesta batch/incremental (Neon → S3)

1. Connections → New Connection
2. Source: **PostgreSQL (Neon)**
3. Destination: **Amazon S3**

### Parámetros recomendados:

| Configuración    | Valor                |
| ---------------- | -------------------- |
| Sync mode        | Incremental + Append |
| Cursor field     | `actualizado`        |
| Primary key      | `id`                 |
| Destination path | `raw/clientes/`      |

4. Ejecutar `Sync now`.

### Resultado esperado

En S3:

```
raw/
  clientes/
    2025-11-28_00-01-22/
       part-0.parquet
       _SUCCESS
```

---

# 7. PASO 4 — Crear el destino streaming (Redpanda Cloud)

## 7.1 Crear la cuenta y el clúster

1. [https://cloud.redpanda.com](https://cloud.redpanda.com)
2. Crear cuenta sin tarjeta.
3. Crear clúster Free Tier.
4. En **Topics** → Create Topic:

   ```
   clientes_cdc
   ```

## 7.2 Obtener credenciales

En Redpanda:

```
Clusters → <tu cluster> → Connect → Client Config
```

Copiar:

* Bootstrap servers
* SASL username
* SASL password
* Security protocol = SASL_SSL
* Mechanism = SCRAM-SHA-256

---

# 8. PASO 5 — Configurar CDC con Airbyte Cloud → Redpanda

1. Airbyte Cloud → Sources → New Source

2. Elegir: **PostgreSQL (CDC)**

3. Completar datos de Neon (importante: usar endpoint directo, no pooler).

4. Airbyte creará automáticamente un **publication** y un **slot** si Neon lo permite para el plan actual.

5. Crear Destination → **Kafka**
   (Redpanda es Kafka-compatible)

6. Completar:

| Campo             | Valor             |
| ----------------- | ----------------- |
| Bootstrap Servers | valor de Redpanda |
| SASL Username     | valor de Redpanda |
| SASL Password     | valor de Redpanda |
| Security Protocol | SASL_SSL          |
| SASL Mechanism    | SCRAM-SHA-256     |
| Topic             | `clientes_cdc`    |

7. Crear connection
8. Ejecutar sincronización

---

# 9. PASO 6 — Consumir eventos CDC desde Python (Google Colab)

En Colab:

```python
!pip install kafka-python
```

Consumidor:

```python
from kafka import KafkaConsumer
import json

bootstrap_servers = "TU_BOOTSTRAP_SERVER"
sasl_username = "TU_USUARIO"
sasl_password = "TU_PASSWORD"

consumer = KafkaConsumer(
    "clientes_cdc",
    bootstrap_servers=bootstrap_servers,
    security_protocol="SASL_SSL",
    sasl_mechanism="SCRAM-SHA-256",
    sasl_plain_username=sasl_username,
    sasl_plain_password=sasl_password,
    auto_offset_reset="earliest",
    value_deserializer=lambda v: json.loads(v.decode('utf-8'))
)

print("Esperando eventos CDC...")

for msg in consumer:
    print(json.dumps(msg.value, indent=2))
```

---

# 10. Lectura de los ficheros Parquet desde S3 (Pandas)

```python
!pip install s3fs pyarrow pandas

import pandas as pd

df = pd.read_parquet(
    's3://sbd-airbyte-lake-2025/raw/clientes/',
    storage_options={
        "key": "<ACCESS_KEY>",
        "secret": "<SECRET_KEY>"
    }
)

df.head()
```

---

# 11. Entregables del alumnado

1. Esquema del pipeline completo.
2. Capturas de:

   * Source Neon
   * Destination S3
   * Connection batch
   * Redpanda topic
   * Connection CDC
3. Captura del consumo en tiempo real en Colab.
4. Lectura de Parquet desde S3 con Pandas.
5. Informe técnico breve (1–2 páginas).

---



