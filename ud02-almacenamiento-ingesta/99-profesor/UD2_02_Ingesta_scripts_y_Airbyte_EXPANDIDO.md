# UD2 · Ingesta con scripts y con Airbyte OSS

## 1. Introducción: ¿Qué es la ingesta de datos?

En un sistema Big Data, la **ingesta de datos** es el proceso mediante el cual se **capturan y trasladan datos desde sus fuentes de origen** (ficheros, APIs, bases de datos, sensores, etc.) **hasta su almacenamiento en bruto (raw zone)** dentro del *data lake* o del sistema de procesamiento.

La ingesta puede realizarse de forma:
- **Batch** → por lotes, en horarios programados.  
- **Streaming** → datos continuos (logs, IoT, redes sociales).  

El objetivo es **recoger datos de manera fiable, reproducible y automatizable**.

## 2. Ingesta con scripts (Python + pandas)

Los scripts permiten una ingesta **personalizada**, ideal para fuentes simples o prácticas educativas.

### Ventajas
- Control total sobre el código.  
- Sin dependencias externas.  

### Inconvenientes
- Escalabilidad limitada.  
- Mantenimiento manual.  

---

## 2.1 Ejemplo · CSV → Parquet

```python
import pandas as pd, pyarrow as pa, pyarrow.parquet as pq
from pathlib import Path

SRC = Path("data_sources/turismo_csv")
OUT = Path("data_lake/raw/turismo_parquet")
OUT.mkdir(parents=True, exist_ok=True)

for csv in sorted(SRC.glob("*.csv")):
    df = pd.read_csv(csv)
    table = pa.Table.from_pandas(df, preserve_index=False)
    pq.write_table(table, OUT / (csv.stem + ".parquet"), compression="snappy")
```

---

## 2.2 Ejemplo · API REST → Parquet

```python
import requests, pandas as pd, pyarrow as pa, pyarrow.parquet as pq
from datetime import date
from pathlib import Path

BASE = "https://api.example.com/sales"
OUT = Path("data_lake/raw/ventas_parquet"); OUT.mkdir(parents=True, exist_ok=True)

d = date.today()
resp = requests.get(BASE, params={"date": d.isoformat()}, timeout=30)
resp.raise_for_status()

df = pd.json_normalize(resp.json())
pq.write_table(pa.Table.from_pandas(df), OUT / f"sales_{d.isoformat()}.parquet")
```

---

## 3. Ingesta con Airbyte OSS

### 3.1 ¿Qué es Airbyte?

**Airbyte OSS** es una plataforma *open source* para la **integración automatizada** de datos entre orígenes y destinos mediante *conectores*.  
Permite sincronizaciones incrementales y monitorización desde una interfaz gráfica.

### 3.2 Componentes principales

| Componente | Función |
|-----------|---------|
| **Source** | Fuente de datos (API, MySQL, CSV). |
| **Destination** | Destino donde se guardan los datos (S3, MinIO, Postgres). |
| **Connector** | Lógica de extracción y carga. |
| **Catalog** | Streams/tablas y sus campos. |
| **Scheduler** | Programador de sincronizaciones. |

---

## 3.3 Flujo básico de configuración

1. Desplegar Airbyte (Docker o local).  
2. Crear *Source* (HTTP, File, DB).  
3. Crear *Destination* (S3, MinIO, Postgres…).  
4. Elegir modo: *full refresh*, *incremental append*, *dedupe*.  
5. Ejecutar y verificar registros.

### Ejemplo de source HTTP

```json
{
  "base_url": "https://api.example.com",
  "auth_type": "api_key",
  "api_key": "${API_KEY}",
  "streams": [
    {
      "name": "sales",
      "path": "/sales",
      "params": {"date": "{{ today }}"},
      "primary_key": ["id"],
      "incremental": true,
      "cursor_field": "updated_at"
    }
  ]
}
```

### Ejemplo de destino MinIO/S3

```json
{
  "endpoint": "http://localhost:9000",
  "bucket_name": "datalake",
  "access_key_id": "${MINIO_ACCESS_KEY}",
  "secret_access_key": "${MINIO_SECRET_KEY}",
  "path_prefix": "raw/airbyte/",
  "format": "parquet"
}
```

---

## 4. Scripts vs Airbyte · Comparativa didáctica

| Aspecto | Scripts Python | Airbyte OSS |
|---------|----------------|-------------|
| Control | Total | Parcial |
| Monitorización | Manual | Integrada |
| Mantenimiento | Alto | Bajo |
| Escalabilidad | Limitada | Alta |
| Ideal para | Aprendizaje | Producción |

---

## 5. Actividad guiada para el aula

**Objetivo:**  
Construir dos pipelines:
1. Script Python → CSV → Parquet.  
2. Airbyte → API pública → MinIO.

**Tareas:**
- Implementa el script en `ingest/`.  
- Configura una conexión en Airbyte.  
- Guarda capturas de la interfaz.  
- Documenta pasos y problemas encontrados.

**Entrega:**  
Un documento o notebook con:  
- Código explicado.  
- Capturas del proceso.  
- Carpeta `data_lake/raw/` generada.  
