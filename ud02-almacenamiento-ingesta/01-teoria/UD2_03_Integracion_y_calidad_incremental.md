# UD2 · Integración y calidad incremental (joins + upsert)

> Objetivo: consolidar turismo (CSV→Parquet) y ventas (API→Parquet) en un **curado** común, con **calidad** y **upsert** hacia Postgres o Parquet particionado.

## 1) Integración rápida con DuckDB (sobre Parquet)
```sql
-- integrate/merge_curate.sql
CREATE OR REPLACE TABLE curated AS
SELECT
  s.fecha::DATE AS fecha,
  s.tienda_id,
  s.sku,
  s.unidades,
  s.importe,
  t.visitantes_municipio,
  t.visitantes_total
FROM 'data_lake/raw/ventas_parquet/*.parquet' s
LEFT JOIN 'data_lake/raw/turismo_parquet/*.parquet' t
ON s.fecha = t.fecha AND s.municipio_id = t.municipio_id;
```

## 2) Reglas de calidad (mínimo viable)
- **Dominio:** `canal ∈ {'tienda','web','app'}`  
- **Rango:** `0 ≤ unidades ≤ 500`  
- **Consistencia:** `importe ≈ unidades*precio` (±2%)  
- **Puntualidad:** registros del **último mes** presentes.

| Regla | Umbral mínimo | Acción si falla | Evidencia esperada |
| ----- | ------------- | --------------- | ------------------ |
| Completitud de claves (`fecha`, `tienda_id`, `sku`) | 100% no nulo | Rechazar o aislar registros inválidos | Consulta con porcentaje de no nulos. |
| Dominio de `canal` | ≥ 99% válido | Corregir valores conocidos o etiquetar como `desconocido` | Lista de valores fuera de dominio. |
| Rango de `unidades` | ≥ 99% entre 0 y 500 | Revisar outliers antes de eliminarlos | Conteo de registros fuera de rango. |
| Consistencia `importe ≈ unidades*precio` | ≥ 98% dentro de tolerancia | Recalcular si hay precio unitario fiable o marcar incidencia | Porcentaje de registros consistentes. |
| Puntualidad | Datos del último mes presentes | Registrar retraso y no publicar Gold como definitivo | Fecha máxima disponible por fuente. |

```sql
SELECT
  AVG(canal IN ('tienda','web','app')) AS dom_ok,
  AVG(unidades BETWEEN 0 AND 500) AS rango_ok,
  AVG(ABS(importe - unidades*precio) <= GREATEST(0.01, 0.02*(unidades*precio))) AS cons_ok
FROM curated;
```

La regla no termina en el cálculo. Cada métrica debe tener una decisión: aceptar, corregir, aislar, pedir revisión o bloquear publicación.

## 3) Upsert (idempotencia)
**Hacia Postgres (pseudo-SQL):**
```sql
INSERT INTO fact_ventas AS f (fecha, tienda_id, sku, unidades, importe)
SELECT fecha, tienda_id, sku, unidades, importe FROM staging_fact
ON CONFLICT (fecha, tienda_id, sku) DO UPDATE
SET unidades = EXCLUDED.unidades,
    importe = EXCLUDED.importe;
```

**Hacia Parquet (estrategia simple):**
- Reescribir particiones afectadas (`anio/mes`) tras merge en DuckDB.
- Mantener `manifest` de particiones tocadas (archivo `.txt`).

## 4) Linaje (mermaid)
```mermaid
flowchart TD
  A[raw/ventas_parquet] --> M[merge_curate.sql]
  B[raw/turismo_parquet] --> M
  M --> C[curated/parquet]
  C --> P[(Postgres fact/dim)]
  C --> BI[BI]
```
