-- Checks sobre dataset Parquet particionado
INSTALL parquet; LOAD parquet;
CREATE OR REPLACE VIEW sales_curated AS
SELECT * FROM read_parquet('/home/jmsa/IESRafaelAlberti/RafaelAlberti25_26/Modulos/SBD/UD1/UD1-Parte4/lab_p3_eda_calidad_duckdb/data/curated/anio=*/mes=*/*.parquet');

-- duckdb_checks_template.sql — Verificaciones de calidad (reemplaza sales_curated)
-- Uso: duckdb -c ".read duckdb_checks_template.sql"

-- 0) Contexto
-- .mode table
-- .timer on

-- 1) Completitud por columna (ejemplo: precio)
SELECT
  'precio_not_null' AS rule_id,
  ROUND(100.0 * SUM(CASE WHEN precio IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_ok
FROM sales_curated;

-- 2) Unicidad de clave (fecha, tienda, sku)
WITH dup AS (
  SELECT fecha, tienda_id, sku, COUNT(*) AS c
  FROM sales_curated
  GROUP BY 1,2,3
)
SELECT
  'uniq_fecha_tienda_sku' AS rule_id,
  ROUND(100.0 * SUM(CASE WHEN c=1 THEN 1 ELSE 0 END) / (SELECT COUNT(*) FROM sales_curated), 2) AS pct_unique
FROM dup;

-- 3) Validez de dominio (canal ∈ {tienda,web,app})
SELECT
  'canal_in_set' AS rule_id,
  ROUND(100.0 * SUM(CASE WHEN lower(canal) IN ('tienda','web','app') THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_ok
FROM sales_curated;

-- 4) Consistencia importe ≈ unidades*precio (±2%)
SELECT
  'importe_consistency' AS rule_id,
  ROUND(100.0 * SUM(
    CASE WHEN ABS(importe - (unidades*precio)) <= 0.02 * (unidades*precio + 1e-9) THEN 1 ELSE 0 END
  ) / COUNT(*), 2) AS pct_ok
FROM sales_curated;

-- 5) Puntualidad (recencia de la fecha)
SELECT
  'timeliness_max_date' AS rule_id,
  MAX(fecha) AS max_fecha
FROM sales_curated;
