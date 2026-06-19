# UD2 · Ingesta con scripts (pandas) y con Airbyte OSS

## A) Ingesta con scripts (pandas)
**CSV (turismo) → Parquet (raw)**
```python
# ingest/tourism_csv_ingest.py
import pandas as pd, os, sys, pyarrow as pa, pyarrow.parquet as pq
from pathlib import Path

SRC = Path("data_sources/turismo_csv")  # carpeta con CSVs
OUT = Path("data_lake/raw/turismo_parquet")
OUT.mkdir(parents=True, exist_ok=True)

for csv in sorted(SRC.glob("*.csv")):
    df = pd.read_csv(csv)
    table = pa.Table.from_pandas(df, preserve_index=False)
    pq.write_table(table, OUT / (csv.stem + ".parquet"), compression="snappy")
```

**API REST (ventas) → Parquet (raw)**
```python
# ingest/sales_api_ingest.py
import requests, pandas as pd, pyarrow as pa, pyarrow.parquet as pq
from datetime import date
from pathlib import Path

BASE = "https://api.example.com/sales"  # simulado
OUT = Path("data_lake/raw/ventas_parquet"); OUT.mkdir(parents=True, exist_ok=True)

d = date.today()
params = {"date": d.isoformat()}
resp = requests.get(BASE, params=params, timeout=30)
resp.raise_for_status()
data = resp.json()
df = pd.json_normalize(data)
pq.write_table(pa.Table.from_pandas(df, preserve_index=False),
               OUT / f"sales_{d.isoformat()}.parquet", compression="snappy")
```

> **Buenas prácticas:** nombres deterministas, validación mínima (columnas esperadas), logs, *exit codes*.

## B) Ingesta con Airbyte OSS (GUI + conectores FT)
**Pasos express:**
1) Desplegar Airbyte (Docker o local).  
2) Crear **Source** (HTTP API / File) y **Destination** (S3/MinIO o Postgres).  
3) Definir **catalog** (streams, *primary key*, *incremental append* o *dedupe*).  
4) Configurar **frecuencia** (manual/cron).  
5) Ejecutar y verificar registros/errores.

**Ejemplo de `config.json` (source HTTP):**
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

**Ejemplo de destino S3/MinIO (pseudo):**
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

> **Tip:** si no usas Airbyte, conserva la **misma convención de carpetas** y *naming* para poder mezclar métodos sin fricción.
