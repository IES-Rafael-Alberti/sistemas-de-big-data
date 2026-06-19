# UD1 · Parte 5 — Ingesta de datos (fundamentos prácticos antes de UD2)

## 1. ¿Qué es “ingesta” y por qué importa?

La **ingesta de datos** es el proceso de **capturar, trasladar y aterrizar** datos desde sus **fuentes** (APIs, ficheros, BBDD, eventos) hasta un **destino analítico** (data lake, warehouse o base documental). Es crítica porque:

* Determina la **calidad y frescura** de la información disponible para análisis/ML.
* Condiciona **costes** (transferencia, almacenamiento, cómputo) y **latencia** (batch vs streaming).
* Es la base del **linaje** y la **gobernanza** (saber de dónde viene cada dato y con qué reglas llegó).

En UD1 nos quedamos con los **fundamentos**, para que en **UD2** podamos construir pipelines reproducibles (Airbyte, scripts, MinIO/Postgres) con garantías.

---

## 2. Modos de ingesta: cuándo usar cada uno

| Modo            | Descripción breve                    | Ventajas                       | Limitaciones           | Usos típicos                        |
| --------------- | ------------------------------------ | ------------------------------ | ---------------------- | ----------------------------------- |
| **Batch**       | Cargas periódicas (horaria/diaria/…) | Simple, barato, estable        | Latencia               | Reportes, cierre diario, históricos |
| **Micro-batch** | Lotes pequeños y frecuentes          | Buen compromiso latencia/coste | Complejidad intermedia | Dashboards casi en tiempo real      |
| **Streaming**   | Flujo continuo de eventos            | Frescura, detección rápida     | Coste + complejidad    | Logs, sensores, clickstream         |

> En SBD priorizaremos **batch/micro-batch** (parquet) y dejaremos **streaming** como comparativa conceptual (entra más a fondo en BD Aplicado).

---

## 3. ETL vs ELT y dónde encaja la ingesta

* **ETL**: *Extract → Transform → Load*. Transformas **antes** de cargar. Útil cuando el destino es un **DW tradicional** o cuando transformar reduce mucho el volumen a almacenar.
* **ELT**: *Extract → Load → Transform*. Cargas **rápido** al **data lake** (Parquet/Delta) y transformas **después** (con Spark/DuckDB). Favorece **trazabilidad** y **reprocesos**.

En la práctica, **ELT + Parquet** suele ser lo más flexible para FP y proyectos educativos: primero ingestas “lo que hay” (sin perderlo) y luego mejoras.

---

## 4. Fuentes, formatos y destinos (decisiones mínimas)

| Tipo de fuente | Ejemplos       | Formato origen  | Destino recomendado           | Notas                                             |
| -------------- | -------------- | --------------- | ----------------------------- | ------------------------------------------------- |
| **Ficheros**   | CSV/JSON/Excel | CSV, JSON, XLSX | **Parquet** (S3-like/MinIO)   | Convertir a columnares baja costes/latencia       |
| **APIs**       | REST/GraphQL   | JSON            | Parquet + *raw JSON* opcional | Gestionar paginación, rate limits                 |
| **BBDD**       | Postgres/MySQL | Tablas          | Parquet o réplica tabular     | Cargas completas o **incrementales**              |
| **Eventos**    | Logs, IoT      | NDJSON, Avro    | Parquet (batch) o Kafka→lake  | Para streaming, log a Kafka y volcados periódicos |

> **Regla de oro**: llegada en **raw** + **curated** (limpio/normalizado) y, si aplica, **particionado** (ej. `anio=YYYY/mes=MM/`).

---

## 5. Reglas esenciales en la ingesta (mini-checklist)

1. **Esquema y contratos**: define tipos, claves, fechas. Si el origen es JSON flexible, **documenta** qué campos esperas.
2. **Calidad mínima**: valida **nulos prohibidos**, dominios (listas válidas), regex básicas (emails, códigos), **rangos** (fechas no futuras si no procede).
3. **Incremental**: preferir **cargas incrementales** (por `last_updated`/watermark); si no hay, hacer **full** con **deduplicación**.
4. **Idempotencia**: reejecutar sin duplicar. Estrategias: **upsert** por clave natural/compuesta; sobrescribir partición del día.
5. **Particionado**: por **fecha** (día/mes/año) o clave de negocio (cliente/país) si justifica consultas.
6. **Seguridad**: **.env** sin secretos en repo; tokens/credenciales en variables de entorno.
7. **Observabilidad**: registra **cuántas filas** entran/salen, tiempos, errores/avisos.
8. **RGPD**: minimiza campos personales, **seudonimiza/anonimiza** si no son necesarios para el objetivo docente.

---

## 6. Patrones de carga incremental (rápido)

* **High-watermark**: “tráeme todo con `updated_at > último_marcador`”.
* **CDC ligero**: si el origen da **soft deletes** o **versionado**, consérvalos (útil para auditoría).
* **Reprocesos (backfill)**: reingestar un rango de fechas si hubo errores; por eso conviene **particionar por fecha**.

---

## 7. Ejemplos mínimos (prácticos y reproducibles)

### 7.1. API REST → Parquet (paginación)

```python
import os, time, requests, pandas as pd
from pyarrow import Table
import pyarrow.parquet as pq
from datetime import datetime

API = "https://api.ejemplo.com/items"
TOKEN = os.environ.get("API_TOKEN")  # export API_TOKEN=...
headers = {"Authorization": f"Bearer {TOKEN}"}
params = {"page": 1, "per_page": 200}

rows = []
while True:
    r = requests.get(API, headers=headers, params=params, timeout=30)
    r.raise_for_status()
    chunk = r.json()
    if not chunk:
        break
    rows.extend(chunk)
    params["page"] += 1
    time.sleep(0.2)  # respetar rate limit

df = pd.json_normalize(rows)
# Validaciones mínimas
assert df["id"].is_unique
df = df[df["status"].isin(["ok","pending","error"])]
# Parquet particionado por mes
df["fecha"] = pd.to_datetime(df["updated_at"]).dt.date
df["anio"] = pd.to_datetime(df["fecha"]).dt.year
df["mes"]  = pd.to_datetime(df["fecha"]).dt.month
for (y,m), part in df.groupby(["anio","mes"]):
    path = f"data_lake/curated/anio={y}/mes={m}/items.parquet"
    table = Table.from_pandas(part, preserve_index=False)
    pq.write_table(table, path)  # compresión por defecto (snappy)
print("OK API→Parquet")
```

### 7.2. CSV “crudo” → Parquet con tipos y partición

```python
import pandas as pd, pyarrow.parquet as pq, pyarrow as pa

df = pd.read_csv("data/raw/sales.csv")
df["ts"] = pd.to_datetime(df["ts"], errors="coerce")
df = df.dropna(subset=["order_id","ts"])           # calidad mínima
df["anio"] = df["ts"].dt.year
df["mes"]  = df["ts"].dt.month
for (y,m), g in df.groupby(["anio","mes"]):
    pq.write_table(pa.Table.from_pandas(g, preserve_index=False),
                   f"data_lake/curated/sales/anio={y}/mes={m}/sales.parquet")
```

### 7.3. (Opcional) Postgres → Parquet (incremental por `updated_at`)

> En UD2 veremos conectores; aquí un patrón simple con `pandas`:

```python
import os, pandas as pd, sqlalchemy as sa
from datetime import datetime

engine = sa.create_engine(os.environ["PG_URL"])  # ej: postgresql+psycopg://user:pass@host/db
last_mark = "2024-12-01T00:00:00"
sql = f"""
SELECT * FROM public.customers
WHERE updated_at > '{last_mark}'::timestamp
ORDER BY updated_at ASC
"""
df = pd.read_sql(sql, engine)
# …validaciones/particionado…
```

---

## 8. Observabilidad y linaje “mínimos”

* **Log de ejecución**: inicio/fin, filas leídas/escritas, duración, errores (fichero `logs/ingest_YYYYMMDD.log`).
* **Manifiesto**: un `README_ingesta.md` con origen, campos, contratos, reglas, **diagramita** de flujo (mermaid es perfecto).
* **Linaje**: “origen → raw → curated → BI/ML” con fechas y versiones.
  Ejemplo *mermaid*:

  ```mermaid
  flowchart LR
    A[API Items] --> B[raw/items_2025-10-30.json]
    B --> C[curated/items.parquet (anio/mes)]
    C --> D[Superset/Metabase]
  ```

---

## 9. Errores típicos (y cómo evitarlos)

* **Duplicados**: define **clave** y **estrategia de dedup** (por `id` y timestamp).
* **Fechas**: zonas horarias y formatos; normaliza a UTC o zona del proyecto.
* **Tipos**: números con coma, booleanos “sí/no”, nulos “NA” como strings.
* **Rutas**: cuidado con **rutas relativas** al ejecutar notebooks/CLI.
* **Secretos**: nunca en el repo; usa variables de entorno o `.env` que no subes.

---

## 10. Mini-práctica “P5-Ingesta mínima” (30–40 min)

**Objetivo**: bajar un CSV público, validar lo básico y publicarlo en Parquet particionado para usar en UD2.

1. **Descarga** un CSV público (ej. meteorología, retail o cualquier dataset sencillo).
2. **Valida**: `id` no nulo, tipos, rangos (fechas), dominio (1 campo).
3. **Publica**: `data_lake/curated/<dataset>/anio=YYYY/mes=MM/part.parquet`.
4. **Entrega**:

   * `ingesta_<dataset>.py` (o `.ipynb`)
   * 1 captura o tabla con **filas leídas vs escritas**
   * `README_ingesta.md` (origen, reglas, campos, decisiones)

**Rúbrica rápida (/10)**

* (4) Script reproducible (sin secretos)
* (3) Validaciones básicas aplicadas
* (2) Parquet particionado válido
* (1) Mini README claro

> Nota: en **UD2** reusaremos este dataset para montar **Airbyte/scripts** y **MinIO/Postgres**, así que **guarda la estructura**.

---

## 11. Qué nos llevamos a UD2

* Vocabulario y **decisiones mínimas**: formatos, partición, idempotencia, incremental.
* **Plantilla de validación** y **publicación** a Parquet.
* **Hábitos** de logs/linaje/RGPD para pipelines que crecerán.

En UD2: conectores (Airbyte o scripts), destinos (MinIO/Postgres), *linaje* con diagrama, y **pipeline E2E** replicable.

---
