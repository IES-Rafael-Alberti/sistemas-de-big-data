# UD2 · Problema y arquitectura de ingesta e integración
**Fecha:** 2025-10-01

> **Problema realista:**  
Un ayuntamiento publica **datos abiertos** de afluencia turística (CSV/mes en un portal) y un e-commerce local expone una **API REST** con ventas diarias (JSON). Dirección quiere **unificar** ambos para explicar la relación entre turismo y ventas, con **cargas diarias** y un primer **data mart** en Postgres para BI. Actualmente: descargas manuales, ficheros con **nombres inconsistentes**, y **retrasos** de varios días.

## 1. Objetivo de valor
- Unificar **turismo (CSV)** + **ventas (API JSON)** → **curado Parquet** y **schema BI** en Postgres.
- Disponibilidad **D+1** con trazabilidad y calidad básica.

## 2. Decisiones de diseño (teoría → práctica pequeña escala)
- **ELT en data lake** (MinIO/S3-like) con **Parquet particionado** (`anio/mes/dataset`).
- **Transformación** y **integración** con **pandas + DuckDB** (rápido, reproducible).
- **Exposición**: Postgres (tablas **dim** y **fact** mínimas) o BI directo a Parquet.
- **Idempotencia**: cargas repetibles sin duplicar (nombres deterministas y *upsert*).
- **RGPD**: sin PII en ejemplo; plantilla para evaluar riesgos si hubiera.

## 2.1. Mini-ejemplo antes del pipeline completo

Antes de montar toda la arquitectura, el primer objetivo es comprobar el patrón mínimo:

```text
fuente pequeña → fichero Parquet → consulta verificable
```

Ejemplo de datos de partida:

| fecha | municipio_id | visitantes_total |
| ----- | ------------ | ----------------: |
| 2026-01-01 | CADIZ | 1250 |
| 2026-01-02 | CADIZ | 1390 |

Si este caso pequeño no se puede leer, convertir y consultar de forma reproducible, el pipeline grande tampoco está bien diseñado. Primero se valida el camino corto; después se añaden más fuentes, particiones, reglas de calidad y automatización.

## 3. Arquitectura mínima (UD2)
```mermaid
flowchart LR
  A[CSV Turismo (portal)] -->|ingesta| L[(Data Lake: MinIO/Parquet)]
  B[API Ventas (JSON)] -->|ingesta| L
  L -->|integración (DuckDB/pandas)| C[(Curated Parquet)]
  C -->|carga| D[(Postgres: dim_*, fact_ventas)]
  C -->|lectura directa| BI[BI (Superset/Metabase)]
```

## 4. Estructura de carpetas (sugerida)
```
repo/
  ingest/
    tourism_csv_ingest.py
    sales_api_ingest.py
  integrate/
    merge_curate.py
  data_lake/
    raw/
    curated/parquet/
  bi/
  docs/
  .env.example
  README.md
```
