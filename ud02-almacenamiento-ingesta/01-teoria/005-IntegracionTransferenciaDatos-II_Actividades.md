# Herramientas modernas de integración y transferencia de datos: Airbyte, Debezium y Kafka

------------------------------------------------------------------------

# Ampliación teórica \*\*

# 📘 **1. Introudcción a MinIO**

**MinIO** es una alternativa *open-source* y ligera al servicio Amazon S3.

Implementa la API oficial de S3, por lo que herramientas como Airbyte, Spark, Kafka Connect o Python pueden trabajar con MinIO exactamente igual que si fuera AWS S3.

### ¿Para qué lo usamos en Big Data?

-   Para simular un **data lake** (zona RAW / STAGED / CURATED).
-   Para almacenar **ficheros Parquet**, **CSV**, **JSON**, logs…
-   Para probar pipelines sin necesidad de usar AWS.

### ¿Por qué lo usamos en clase?

-   No requiere cuenta cloud.
-   Es muy ligero (solo un contenedor Docker).
-   Compatible con los conectores modernos.

------------------------------------------------------------------------

# 📘 **2. Introducción de Zookeeper**

Tradicionalmente, Kafka dependía de un sistema externo llamado **Zookeeper**, cuyo cometido es:

-   Mantener información de estado de los brokers Kafka
-   Coordinar controladores en el cluster
-   Elegir líderes para particiones
-   Almacenar metadatos de configuración

**HOY:** Kafka moderno incluye un modo llamado *KIP-500* que elimina Zookeeper, pero muchas distribuciones de Debezium y Kafka Connect **todavía usan la arquitectura clásica**.

### ¿Por qué aparece en nuestra práctica?

Porque Debezium + Kafka Connect dependen de la arquitectura tradicional de Kafka, donde Zookeeper es obligatorio. Es importante conocerlo al menos a nivel conceptual.

------------------------------------------------------------------------

# 📘 **3. PRÁCTICA A (LOCAL CON DOCKER) — COMPLETA**

Perfecta para equipos con CPU/RAM suficientes.

## 🎯 Objetivo de la práctica

Crear un entorno Big Data moderno con:

-   **PostgreSQL** → base de datos origen
-   **Airbyte** → ingesta batch/incremental hacia MinIO
-   **MinIO** → data lake (simulación S3)
-   **Kafka + Zookeeper** → plataforma de streaming
-   **Debezium** → CDC desde PostgreSQL hacia Kafka
-   **Python script** → consumer Kafka para ver los cambios de la BD en tiempo real

------------------------------------------------------------------------

# 🟦 **PARTE A — Práctica completa (versión larga): Ingesta, Integración y Transporte de Datos con Airbyte OSS, abctl y Servicios Big Data Locales**

## 🎯 **Objetivo general**

En esta práctica el alumnado construye, paso a paso, un entorno completo de ingesta, integración y transporte de datos moderno, empleando:

1. **Airbyte OSS local desplegado con `abctl` (K3s automático)**
2. **Servicios auxiliares en Docker compose:**

   * PostgreSQL (origen de datos)
   * MinIO (almacenamiento tipo S3)
   * Kafka + Zookeeper
   * Debezium (captura de cambios CDC hacia Kafka)
3. **Consumidor de eventos en Python**

Esta práctica permite al alumnado observar **los dos flujos fundamentales** de un sistema de integración de datos:

* **ELT batch/incremental** → mediante Airbyte OSS
* **CDC (Change Data Capture)** → mediante Debezium + Kafka
* **Streaming** → mediante Python (consumer)

---

# ✨ **Estructura de la práctica**

La práctica se divide en cuatro grandes bloques:

1. **Instalación y despliegue de Airbyte OSS con abctl**
2. **Levantar ecosistema Big Data local con Docker Compose**
3. **Ingesta batch/incremental con Airbyte OSS → MinIO**
4. **CDC + Kafka + Python: transporte y consumo de eventos en tiempo real**

Cada bloque incluye:

* Explicación teórica
* Pasos detallados
* Comandos
* Verificaciones
* Resultados esperados
* Actividad final entregable

---

# 🟦 **1. INSTALACIÓN DE AIRBYTE OSS CON `abctl`**

> **Airbyte OSS ya no se desplega correctamente con Docker Compose**.
> A partir de 2024, la forma recomendada es **`abctl`, que instala K3s y monta todos los servicios internos automáticamente**.

## 1.1. Requisitos previos

* Sistema Linux
  (Ubuntu recomendado. Funciona en WSL2 si Docker Desktop y K8s están correctamente habilitados.)
* Docker funcionando (`docker ps`)
* curl instalado
* 4–6 GB libres de RAM

## 1.2. Instalar `abctl`

Ejecutar:

```bash
curl -sSL https://get.airbyte.com/abctl.sh | bash
```

Esto descarga e instala:

* abctl
* kubectl (si falta)
* helm (si falta)
* configuración de K3s

Comprobar instalación:

```bash
abctl version
```

## 1.3. Inicializar Airbyte OSS

```bash
abctl init
```

Este comando:

* Instala un cluster K3s local
* Despliega Temporal
* Despliega PostgreSQL interno
* Crea el servidor Airbyte
* Configura el worker pool
* Habilita la UI

## 1.4. Iniciar Airbyte OSS

```bash
abctl start
```

Tarda entre **1 y 3 minutos** la primera vez.

## 1.5. Obtener la URL de acceso

```bash
abctl url
```

Ejemplo:

```
Airbyte is available at: http://localhost:8000
```

Entrar en navegador. Debería cargar:

👉 La UI moderna de Airbyte OSS

## 1.6. Detener Airbyte

```bash
abctl stop
```

## 1.7. Resetear o borrar Airbyte

```bash
abctl destroy
```

---

# 🟪 **2. DESPLIEGUE DE SERVICIOS BIG DATA AUXILIARES (DOCKER COMPOSE)**

Mientras Airbyte corre dentro de un cluster K3s interno, todas las demás piezas se pueden ejecutar perfectamente en Docker.

Los servicios serán:

* Postgres → origen de datos
* MinIO → destino tipo S3
* Kafka + Zookeeper → transporte de eventos
* Debezium → captura de cambios en tiempo real

## 2.1. Archivo `docker-compose-bigdata.yaml`

Crear archivo:

```yaml
version: "3.9"

services:
  postgres:
    image: postgres:14
    environment:
      POSTGRES_USER: airbyte
      POSTGRES_PASSWORD: airbyte
      POSTGRES_DB: empresa
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

  zookeeper:
    image: confluentinc/cp-zookeeper:7.5.0
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
    ports:
      - "2181:2181"

  kafka:
    image: confluentinc/cp-kafka:7.5.0
    environment:
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"

  debezium:
    image: debezium/connect:2.3
    environment:
      BOOTSTRAP_SERVERS: kafka:9092
      GROUP_ID: 1
      CONFIG_STORAGE_TOPIC: debezium_config
      OFFSET_STORAGE_TOPIC: debezium_offsets
      STATUS_STORAGE_TOPIC: debezium_status
    ports:
      - "8083:8083"
    depends_on:
      - kafka
      - postgres

  minio:
    image: minio/minio
    command: server /data
    environment:
      MINIO_ROOT_USER: minio
      MINIO_ROOT_PASSWORD: minio123
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio_data:/data

volumes:
  pgdata:
  minio_data:
```

---

## 2.2. Levantar servicios

```bash
docker compose -f docker-compose-bigdata.yaml up -d
```

Verificar:

```bash
docker compose ps
```

---

## 2.3. Crear base de datos de ejemplo (Postgres)

Conectar:

```bash
psql -h localhost -U airbyte -d empresa
```

Crear tabla:

```sql
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(150),
  actualizado TIMESTAMP DEFAULT NOW()
);
```

Insertar datos:

```sql
INSERT INTO clientes(nombre,email)
VALUES ('Ana','ana@example.com'),
       ('Luis','luis@example.com');
```

---

# 🟦 **3. INGESTA BATCH / INCREMENTAL CON AIRBYTE OSS → MINIO**

En este bloque el alumnado:

* Conecta Airbyte con Postgres (source)
* Conecta Airbyte con MinIO (destination tipo S3)
* Configura el conector incremental
* Ejecuta sincronización
* Comprueba los ficheros generados (JSON o Parquet)

---

## 3.1. Crear bucket en MinIO

Ir a:
👉 [http://localhost:9001](http://localhost:9001)
Usuario: `minio`
Contraseña: `minio123`

Crear bucket:

```
datalake
```

---

## 3.2. Configurar SOURCE en Airbyte

1. Entrar a Airbyte OSS
2. Añadir nuevo Source: **PostgreSQL**
3. Rellenar con:

| Campo    | Valor                                        |
| -------- | -------------------------------------------- |
| Host     | `postgres` o `host.docker.internal` si falla |
| Port     | 5432                                         |
| Database | empresa                                      |
| Username | airbyte                                      |
| Password | airbyte                                      |

> Nota: si K3s no puede resolver `postgres`, usar:
> **`host.docker.internal`**
> (Airbyte corre en su propia red, necesita gateway)

---

## 3.3. Configurar DESTINATION en Airbyte

Destination → **S3-compatible Storage**

Parámetros:

| Parámetro   | Valor                                                           |
| ----------- | --------------------------------------------------------------- |
| S3 Endpoint | `http://minio:9000` *(si falla usar host.docker.internal:9000)* |
| Access Key  | minio                                                           |
| Secret Key  | minio123                                                        |
| Bucket      | datalake                                                        |
| Path Prefix | raw/clientes                                                    |

Formato:

* Parquet o JSON

---

## 3.4. Crear CONNECTION (ingesta)

Configurar:

* **Sync mode** → Incremental
* **Cursor** → `actualizado`
* **Primary key** → `id`
* **Normalization** → Off (si quieres simplificar)
* **Schedule** → Manual

Ejecutar sincronización.

Comprobar ficheros en MinIO:

```
datalake/raw/clientes/
```

---

# 🟧 **4. TRANSPORTE Y CDC CON DEBEZIUM → KAFKA**

## 4.1. Registrar conector Debezium

Enviar esta petición a Debezium:

```bash
curl -X POST http://localhost:8083/connectors \
     -H "Content-Type: application/json" \
     -d '{
           "name": "clientes-cdc",
           "config": {
             "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
             "database.hostname": "postgres",
             "database.port": "5432",
             "database.user": "airbyte",
             "database.password": "airbyte",
             "database.dbname": "empresa",
             "topic.prefix": "cdc",
             "slot.name": "airbyte_slot",
             "plugin.name": "pgoutput"
            }
         }'
```

---

## 4.2. Ver topic CDC en Kafka

Listar topics:

```bash
docker exec -it kafka kafka-topics --bootstrap-server localhost:9092 --list
```

Debe aparecer:

```
cdc.public.clientes
```

---

# 🟫 **5. CONSUMIDOR PYTHON (streaming)**

## 5.1. Instalar librería

Crear entorno:

```bash
pip install kafka-python
```

## 5.2. Script consumidor

Guardar como `consumer.py`:

```python
from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(
    'cdc.public.clientes',
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda v: json.loads(v.decode('utf-8')),
    auto_offset_reset='earliest'
)

print("Esperando eventos CDC...\n")

for msg in consumer:
    print(json.dumps(msg.value, indent=2))
```

---

## 5.3. Probar CDC

En Postgres:

```sql
UPDATE clientes SET nombre='Ana María' WHERE id=1;
```

En Python aparecerá:

```json
{
  "op": "u",
  "before": {"id": 1, "nombre": "Ana"},
  "after": {"id": 1, "nombre": "Ana María"}
}
```

---

# 🟩 **6. ENTREGABLES DE LA PRÁCTICA A**

Los alumnos deben entregar:

1. Capturas de:

   * Airbyte OSS Source
   * Airbyte OSS Destination
   * Airbyte Connection
   * MinIO con ficheros generados
   * Kafka topic CDC
   * Python consumer recibiendo eventos
2. Diagrama del pipeline
3. Explicación del flujo de ingesta (Airbyte → MinIO)
4. Explicación del flujo CDC (Debezium → Kafka → Python)
5. Reflexión final sobre integración y transporte

---

------------------------------------------------------------------------

# 🌐 **FASE 2 — Práctica en la nube (sin instalaciones locales)**

*Airbyte Cloud + Kafka gestionado + PostgreSQL Cloud + script desde Colab*

------------------------------------------------------------------------

# 🧩 **1. Arquitectura Cloud propuesta**

```         
┌────────────────────────┐
│  Airbyte Cloud          │
│  (Source: PostgreSQL    │
│   Destination: S3-like) │
└──────────────▲─────────┘
               │ ELT batch/incremental
               │
┌──────────────┴─────────┐
│ PostgreSQL Cloud (Neon)│
│ (Base de datos origen) │
└──────────────▲─────────┘
               │ CDC events
               │
┌──────────────┴────────────┐
│ Confluent Cloud (Kafka)    │
│ (Topic: clientes_cdc)      │
└──────────────▲────────────┘
               │ Consumer
               │
┌──────────────┴────────────┐
│ Google Colab / Python      │
│ (Consumer en tiempo real)  │
└────────────────────────────┘
```

------------------------------------------------------------------------

# ⭐ **2. Servicios gratuitos que usaremos**

### 🟦 **PostgreSQL Cloud (Neon Tech)**

-   100% gratis, sin tarjeta
-   Alta disponibilidad
-   Permite activar el *logical replication* sin complicaciones
-   Web UI muy clara para los alumnos

👉 <https://neon.tech>

------------------------------------------------------------------------

### 🟧 **Kafka gestionado (Confluent Cloud)**

-   1 cluster gratuito (Kafka + Schema Registry)
-   Perfecto para Debezium y prácticas de streaming
-   Panel gráfico excelente para mostrar temas y mensajes

👉 <https://confluent.cloud>

------------------------------------------------------------------------

### 🟨 **Airbyte Cloud Free Tier**

-   No requiere instalación
-   Permite crear Sources y Destinations desde navegador

👉 <https://cloud.airbyte.com>

------------------------------------------------------------------------

### 🟩 **Google Colab**

-   Ejecuta Python desde navegador
-   Los alumnos pueden hacer el consumer Kafka sin instalar nada

👉 <https://colab.research.google.com>

------------------------------------------------------------------------

# 🔎 **3. Paso a paso detallado para los alumnos**

------------------------------------------------------------------------

# ☁️ **3.1. Crear PostgreSQL en Neon**

1.  Entrar en <https://neon.tech>

2.  Crear cuenta (Google o GitHub).

3.  Crear proyecto nuevo:

    -   Database: `empresa`
    -   Usuario: `neon_user`
    -   Password: generada automáticamente

4.  Anotar los datos de conexión:

    -   HOST
    -   PORT (normalmente 5432)
    -   USER
    -   PASSWORD
    -   DATABASE NAME

5.  Entrar en **SQL Editor** y crear tabla:

``` sql
CREATE TABLE clientes (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(120),
  actualizado TIMESTAMP DEFAULT NOW()
);
```

6.  Insertar datos iniciales:

``` sql
INSERT INTO clientes(nombre, email)
VALUES ('Ana', 'ana@example.com'),
       ('Luis', 'luis@example.com');
```

------------------------------------------------------------------------

# 🔄 **3.2. Configurar Debezium (sin instalar Debezium)**

Como los alumnos no pueden instalar Debezium en cloud, lo sustituimos por:

### ⭐ **Confluent Cloud Connectors → Source PostgreSQL CDC**

Esto es ideal porque:

-   Hace *exactamente* lo que hace Debezium
-   Es totalmente gestionado
-   No consume recursos locales
-   es didácticamente perfecto para RA3

### ✔️ Pasos

1.  Entrar en: <https://confluent.cloud>

2.  Crear cuenta (no necesita tarjeta).

3.  Crear cluster “Basic” (gratuito).

4.  En la barra lateral → **Connectors**.

5.  Elegir: **PostgreSQL CDC Source**.

6.  Introducir credenciales de Neon.

7.  Seleccionar tabla `clientes`.

8.  Elegir topic destino:

    ```         
    clientes_cdc
    ```

### Resultado:

Cualquier INSERT/UPDATE/DELETE en Neon → aparece como mensaje CDC en Kafka.

------------------------------------------------------------------------

# ✨ **3.3. Configurar Airbyte Cloud — PostgreSQL → S3 compatible**

Para simular un Data Lake sin usar MinIO local, usaremos:

### ⭐ **“File Destination” de Airbyte Cloud**

que no requiere credenciales S3.

Pasos:

1.  Entrar en <https://cloud.airbyte.com>

2.  Crear cuenta gratuita

3.  Crear **Source**

    -   Tipo: PostgreSQL
    -   Host: el de Neon
    -   Database: empresa
    -   User/password

4.  Crear **Destination**

    -   Tipo: *Local JSON / Parquet Output* (sin S3)

5.  Crear Connection:

    -   Modo: Incremental
    -   Cursor: `actualizado`
    -   Primary key: `id`

Ejecutar sincronización y ver los archivos generados.

------------------------------------------------------------------------

# 🐍 **3.4. Consumer en Google Colab — Los alumnos ven los eventos en tiempo real**

Abren un cuaderno en Colab y pegan:

``` python
!pip install confluent-kafka
```

``` python
from confluent_kafka import Consumer
import json

# Configurar consumer con las credenciales de Confluent Cloud
conf = {
    'bootstrap.servers': 'CLUSTER_BOOTSTRAP_URL',
    'security.protocol': 'SASL_SSL',
    'sasl.mechanisms': 'PLAIN',
    'sasl.username': 'API_KEY',
    'sasl.password': 'API_SECRET',
    'group.id': 'grupo1',
    'auto.offset.reset': 'earliest'
}

consumer = Consumer(conf)
consumer.subscribe(["clientes_cdc"])

print("Esperando cambios CDC...\n")

while True:
    msg = consumer.poll(1.0)
    if msg is None:
        continue
    if msg.error():
        print("Error:", msg.error())
        continue

    evento = json.loads(msg.value().decode("utf-8"))
    print(json.dumps(evento, indent=2))
```

------------------------------------------------------------------------

# 🔔 **3.5. Probar el pipeline completo**

En Neon → ejecutar:

``` sql
UPDATE clientes SET nombre='Ana Gómez' WHERE id=1;
```

En Colab aparecerá:

``` json
{
  "before": {"id": 1, "nombre": "Ana", "email": "ana@example.com"},
  "after": {"id": 1, "nombre": "Ana Gómez", "email": "ana@example.com"},
  "op": "u"
}
```

¡Magia! Y **sin instalar nada local**.

------------------------------------------------------------------------

# 📝4 **RÚBRICA — Actividad: Pipeline moderno de ingesta e integración de datos (Airbyte + CDC + Kafka)**

| Criterio | Indicadores observables | Nivel Excelente (10–9) | Nivel Notable (8–7) | Nivel Adecuado (6–5) | Nivel Insuficiente (\<5) | Peso |
|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
| **1. Diseño del pipeline** | Diagrama, descripción del flujo, identificación de los componentes | El pipeline está completamente definido, con diagrama claro, etapas explicadas y excelente coherencia técnica | Pipeline definido pero con menor detalle en las interacciones | Pipeline incompleto con varios huecos o explicación justa | No se entiende el flujo o faltan partes esenciales | **20%** |
| **2. Configuración del Source y Destination (Airbyte)** | Source PostgreSQL, destino S3/Parquet, configuración incremental | Configurado correctamente, con capturas, sync incremental funcionando | Configuración correcta pero falta alguna captura o explicación | Configuración solo parcial o poco explicada | No funciona o no se ha configurado | **20%** |
| **3. Configuración CDC (Debezium/Confluent)** | Conector PostgreSQL CDC → Kafka, topic creado | Configuración completa y operativa. Topic CDC leyendo cambios correctamente | Funciona, pero con menos documentación o alguna captura ausente | Configuración incompleta o cambios no llegan a Kafka | No se ha realizado o no funciona | **20%** |
| **4. Script del consumidor Kafka (Python/Colab)** | Lectura de eventos + explicación del código | Script 100% funcional, bien explicado y comentado, eventos leídos y mostrados correctamente | Script funcional con pocos comentarios | Script funcional pero sin comentarios o sin usar correctamente los eventos | Script no funciona | **15%** |
| **5. Calidad del informe técnico** | Claridad, estructura, explicación de problemas y soluciones | Informe claro, organizado y profesional. Se explican problemas y soluciones | Informe claro aunque menos detallado | Informe adecuado pero superficial | Informe incompleto o desordenado | **15%** |
| **6. Reflexión final y valoración de herramientas** | Ventajas/inconvenientes de Airbyte, CDC, Kafka | Excelente reflexión madura y crítica | Buena reflexión pero menos profunda | Reflexión superficial | No hay reflexión | **10%** |

------------------------------------------------------------------------

# 🔢 **Recuento final automático**

Puedes sugerir al alumno calcular:

```         
Nota final = Σ (criterio_nota × peso)
```
