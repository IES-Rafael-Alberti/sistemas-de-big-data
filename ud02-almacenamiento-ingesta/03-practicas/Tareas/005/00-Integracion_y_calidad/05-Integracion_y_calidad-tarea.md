---
title: "Práctica: Integración y Calidad Incremental de Datos"
subtitle: "UD2 — Sistemas de Big Data"
author: "José Manuel Sánchez Álvarez"
institute: "IES Rafael Alberti"
course: "Curso 2026–2027"
lang: "es"
fontsize: 11pt
papersize: a4
geometry: margin=2.5cm
toc: true
toc-depth: 3
numbersections: true
colorlinks: true
header-includes:
  - \usepackage{helvet}
  - \renewcommand{\familydefault}{\sfdefault}
  - \usepackage{float}
---

------------------------------------------------------------------------

# 📝 **UD2 – Práctica de Integración y Calidad Incremental de Datos**

### *Versión unificada para alumnado*

### *Rutas A (dlt) y B (Python + DuckDB)*

------------------------------------------------------------------------

## 1. Introducción

En esta práctica realizaremos un proceso completo de **ingesta, integración y control de calidad de datos**, incorporando la noción de **incrementalidad**, es decir, cómo añadir nuevos datos sin repetir información, sin duplicar registros y garantizando consistencia.

La práctica ofrece **dos rutas** que comparten los mismos objetivos y entregables:

-   **Ruta A (dlt):** usando la librería Python **dlt** para definir pipelines ELT de forma programática. `pip install dlt` y listo.
-   **Ruta B (Python + DuckDB):** usando scripts Python directos y DuckDB para la integración. Sin librerías externas más allá de pandas y DuckDB.

Ambas rutas conducen al mismo objetivo y aplican las mismas ideas fundamentales.

------------------------------------------------------------------------

## 2. Objetivos de la práctica

Al finalizar esta práctica, el alumnado será capaz de:

1.  Integrar dos fuentes heterogéneas (ventas y turismo).
2.  Aplicar **reglas de calidad básicas** para validar los datos antes de su carga.
3.  Realizar **carga incremental** sobre un destino (Parquet o Postgres).
4.  Ejecutar un **upsert idempotente** para evitar duplicados.
5.  Documentar el flujo mediante un diagrama de linaje.
6.  Redactar un informe técnico breve de integración y calidad.

------------------------------------------------------------------------

## 3. Datos de trabajo

Trabajaremos con los datasets de turismo generados en la práctica Medallion de UD2:

```text
datos/practica_medallion/raw/
├── ventas.csv           # Ventas diarias por comercio
├── reservas.jsonl       # Reservas de clientes
├── meteo.csv            # Datos meteorológicos
└── zonas.csv            # Catálogo de zonas turísticas
```

Si no los tienes, ejecuta desde la raíz del repositorio:

```bash
python ud02-almacenamiento-ingesta/05-recursos/practica-local-medallion/generar_datos_turismo.py
```

Estructura de trabajo sugerida:

```text
data_lake/
  raw/                   # CSV/JSONL originales
  bronze/                # Capa bronze en DuckDB (carga con dlt)
  curated/               # Tabla integrada final
```

------------------------------------------------------------------------

## 4. Arquitectura conceptual (pipeline)

``` mermaid
flowchart LR

A[Ventas RAW] --> B((Integración))
C[Turismo RAW] --> B

B --> D[Calidad del dato]

D --> E[Curated Layer (tabla final)]
E --> F[(Destino incremental\nPostgres o Parquet)]
```

------------------------------------------------------------------------

# 5. RUTA A – Integración incremental con dlt

*Requisito: `pip install dlt duckdb`*

dlt es una librería Python open-source que permite definir pipelines ELT de
forma declarativa. El pipeline se escribe en Python, se ejecuta localmente y
puede cargar datos desde CSV, JSON, APIs, bases de datos, etc.

------------------------------------------------------------------------

### 5.1 Pipeline de ingesta

Crea un archivo `pipeline_ingesta.py`. Este pipeline lee los datos de turismo,
los normaliza y los carga en DuckDB como capa **bronze**:

```python
import dlt
import csv
import json
import pathlib


@dlt.resource(name="ventas", primary_key="venta_id")
def ventas_csv(file_path="datos/practica_medallion/raw/ventas.csv"):
    path = pathlib.Path(file_path)
    with path.open("r", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            yield {
                "venta_id": row["venta_id"],
                "fecha": row["fecha"],
                "comercio_id": row["comercio_id"],
                "comercio": row["comercio"],
                "zona_id": row["zona_id"],
                "unidades": int(row["unidades"]),
                "importe": float(row["importe"]),
            }


@dlt.resource(name="reservas", primary_key="reserva_id")
def reservas_jsonl(file_path="datos/practica_medallion/raw/reservas.jsonl"):
    path = pathlib.Path(file_path)
    with path.open("r", encoding="utf-8") as f:
        for line in f:
            if not line.strip():
                continue
            obj = json.loads(line)
            obj["personas"] = int(obj["personas"])
            obj["importe"] = float(obj["importe"])
            yield obj


@dlt.resource(name="meteo")
def meteo_csv(file_path="datos/practica_medallion/raw/meteo.csv"):
    path = pathlib.Path(file_path)
    with path.open("r", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            yield row


@dlt.resource(name="zonas")
def zonas_csv(file_path="datos/practica_medallion/raw/zonas.csv"):
    path = pathlib.Path(file_path)
    with path.open("r", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            yield row


pipeline = dlt.pipeline(
    pipeline_name="ingesta_medallion",
    destination="duckdb",
    dataset_name="bronze",
)

info = pipeline.run([ventas_csv(), reservas_jsonl(), meteo_csv(), zonas_csv()])
print(info)
```

Ejecuta:

```bash
python pipeline_ingesta.py
```

Verifica que se cargaron los datos:

```bash
duckdb ingesta_medallion.duckdb \
  -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'bronze';"
```

------------------------------------------------------------------------

### 5.2 Carga incremental

dlt soporta carga incremental de forma nativa. Modifica el recurso `ventas_csv`
para que solo cargue filas nuevas según la columna `fecha`:

```python
@dlt.resource(name="ventas", primary_key="venta_id")
def ventas_csv(
    file_path="datos/practica_medallion/raw/ventas.csv",
    last_date=dlt.sources.incremental("fecha", initial_value="2000-01-01"),
):
    path = pathlib.Path(file_path)
    with path.open("r", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            if row["fecha"] >= last_date.last_value:
                yield {
                    "venta_id": row["venta_id"],
                    "fecha": row["fecha"],
                    "comercio_id": row["comercio_id"],
                    "comercio": row["comercio"],
                    "zona_id": row["zona_id"],
                    "unidades": int(row["unidades"]),
                    "importe": float(row["importe"]),
                }
```

Vuelve a ejecutar el pipeline. dlt detectará que ya hay datos cargados y solo
insertará los registros nuevos (en este caso ninguno, porque los datos no han cambiado).

Para probar la incrementalidad real, añade un nuevo fichero `ventas_extra.csv`
con fechas posteriores y modifica el recurso para que lea varios archivos.

------------------------------------------------------------------------

### 5.3 Integración (join) en DuckDB

Con los datos ya en DuckDB, haz la integración desde la propia base de datos:

```sql
CREATE OR REPLACE TABLE bronze.curated AS
SELECT
    v.venta_id,
    v.fecha::DATE           AS fecha,
    v.comercio_id,
    v.comercio,
    v.zona_id,
    v.unidades,
    v.importe,
    r.personas,
    r.cliente,
    m.temperatura_media,
    m.lluvia_mm
FROM bronze.ventas v
LEFT JOIN bronze.reservas r ON v.fecha = r.fecha AND v.comercio_id = r.comercio_id
LEFT JOIN bronze.meteo m ON v.fecha = m.fecha;
```

------------------------------------------------------------------------

### 5.4 Reglas de calidad

```sql
SELECT
    COUNT(*) AS total_filas,
    AVG(CASE WHEN unidades BETWEEN 0 AND 500 THEN 1 ELSE 0 END)
        AS pct_rango_unidades,
    AVG(CASE WHEN importe > 0 THEN 1 ELSE 0 END)
        AS pct_importe_positivo,
    AVG(CASE WHEN cliente IS NOT NULL THEN 1 ELSE 0 END)
        AS pct_cliente_conocido
FROM bronze.curated;
```

Interpreta:

-   Qué porcentaje de filas pasa cada regla.
-   Qué implicaciones tiene para la calidad del pipeline.
-   Qué filas se deberían corregir o excluir.

------------------------------------------------------------------------

### 5.5 Idempotencia

Vuelve a ejecutar el pipeline. Si usas `primary_key` e `incremental`, dlt
evitará duplicados automáticamente.

Verifica que no hay duplicados:

```sql
SELECT venta_id, COUNT(*)
FROM bronze.ventas
GROUP BY venta_id
HAVING COUNT(*) > 1;
```

------------------------------------------------------------------------

### 5.6 Ampliación opcional

Prueba a cargar los mismos datos cambiando el destino a `postgres` en lugar de
`duckdb` (requiere PostgreSQL corriendo). Solo cambia:

```python
pipeline = dlt.pipeline(
    pipeline_name="ingesta_medallion",
    destination="postgres",  # en lugar de duckdb
    dataset_name="bronze",
)
```

dlt soporta PostgreSQL, BigQuery, Snowflake, Databricks y más.
**El mismo código, distinto destino.**

------------------------------------------------------------------------

# 6. RUTA B – Integración incremental SIN Airbyte

*(Para quien no haya conseguido instalarlo o ejecutarlo)*

Esta ruta reproduce toda la lógica utilizando únicamente ficheros locales y DuckDB.

------------------------------------------------------------------------

## 6.1 Simular ingesta incremental

Crear ficheros diarios:

```         
data_lake/raw/ventas/ventas_2025-11-01.csv
data_lake/raw/ventas/ventas_2025-11-02.csv
...
```

Lo mismo para turismo.

------------------------------------------------------------------------

## 6.2 Convertir CSV → Parquet (opcional)

``` python
import pandas as pd
import pathlib

src = pathlib.Path("data_lake/raw/ventas")
dst = pathlib.Path("data_lake/raw/ventas_parquet")
dst.mkdir(parents=True, exist_ok=True)

for csv in src.glob("*.csv"):
    df = pd.read_csv(csv)
    df.to_parquet(dst / (csv.stem + ".parquet"))
```

------------------------------------------------------------------------

## 6.3 Integración con DuckDB

Mismo SQL que la Ruta A:

``` sql
CREATE OR REPLACE TABLE curated AS
SELECT
    s.fecha::DATE           AS fecha,
    s.tienda_id,
    s.sku,
    s.unidades,
    s.importe,
    t.visitantes_municipio,
    t.visitantes_total
FROM 'data_lake/raw/ventas_parquet/*.parquet' s
LEFT JOIN 'data_lake/raw/turismo_parquet/*.parquet' t
ON  s.fecha = t.fecha
AND s.municipio_id = t.municipio_id;
```

------------------------------------------------------------------------

## 6.4 Reglas de calidad[^1]

[^1]: Calidad y métricas de calidad en unidad 1 parte 4

Mismo SQL que Ruta A.

El alumnado debe:

-   calcular porcentajes,
-   identificar filas incorrectas,
-   plantear estrategias de limpieza.

------------------------------------------------------------------------

## 6.5 Upsert incremental (local)

En Parquet:

-   Detectar particiones afectadas (por fecha).
-   Reescribir solo los ficheros que correspondan.
-   Documentar la estrategia.

En Postgres local, usar ON CONFLICT como en Ruta A.

------------------------------------------------------------------------

# 7. Entregables

Todos los alumnos, independientemente de ruta A/B, deben entregar:

### 1. **Diagrama del flujo (linaje)**

Puede ser Mermaid o dibujo propio.

### 2. **SQL de integración (join)**

El SQL que crea la tabla curated.

### 3. **Informe de calidad**

Incluyendo:

-   qué reglas se han aplicado,
-   qué porcentaje de registros pasa cada regla,
-   qué anomalías se detectan,
-   posibles acciones de limpieza.

### 4. **Estrategia incremental**

Explicar:

-   cómo añades nuevos datos,
-   cómo evitas duplicados,
-   cómo garantizar idempotencia.

### 5. **Upsert final**

-   SQL o explicación del proceso.

### 6. **Reflexión final (5–10 líneas)**

Qué ha funcionado, qué ha sido difícil, qué mejorarías.

------------------------------------------------------------------------

# 8. Rúbrica de evaluación (20 puntos)

| Criterio                  | Descripción                           | Puntuación |
|-----------------------|----------------------------------|----------------|
| **Integración de datos**  | Join correcto entre ventas y turismo  | 4 pts      |
| **Calidad del dato**      | Reglas aplicadas, métricas calculadas | 4 pts      |
| **Incrementalidad**       | Estrategia explicada y aplicada       | 4 pts      |
| **Upsert / Idempotencia** | Correcto en SQL o Parquet             | 4 pts      |
| **Informe y entregables** | Claridad, completitud, reflexión      | 4 pts      |

**Total: 20 puntos**

------------------------------------------------------------------------

# 9. Cierre

Esta práctica reproduce un escenario realista en Big Data:

-   ingesta,
-   integración,
-   control de calidad,
-   incrementalidad,
-   procesos idempotentes,
-   documentación del linaje.

---

### *Ampliación opcional: herramientas del mundo real*

Si querés ver cómo se hace esto mismo con herramientas que se usan en empresa,
consultá los materiales en `05-recursos/practica-herramientas-reales/`:

- **Airbyte**: los mismos datos, desde la interfaz gráfica. Sin instalar nada.
- **AWS serverless (S3 + Glue + Athena)**: los datos se quedan en un data lake
  y se consultan donde están. Sin pipeline que gestionar.

Ambos son **optativos, no evaluables**, y están pensados para que compares
enfoques después de tener clara la base con dlt.
