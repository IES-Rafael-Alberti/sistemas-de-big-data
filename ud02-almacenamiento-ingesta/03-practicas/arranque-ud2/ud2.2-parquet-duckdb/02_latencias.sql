-- Práctica guiada: CSV -> Parquet y comparación de filas.
-- Requiere 'latencias_web.csv' en la carpeta desde la que se ejecuta.
-- Ejecutar con:
--     duckdb -batch -bail < 02_latencias.sql

-- ============================================================
-- BLOQUE 1: Cargar el CSV
-- ============================================================
CREATE OR REPLACE TABLE latencias AS
SELECT *
FROM read_csv_auto('latencias_web.csv');

-- ============================================================
-- BLOQUE 2: Convertir a Parquet
-- ============================================================
COPY latencias TO 'latencias_ud2.parquet' (FORMAT PARQUET);

-- ============================================================
-- BLOQUE 3: Contar filas en ambos formatos (deben coincidir)
-- ============================================================
SELECT 'CSV'     AS origen, COUNT(*) AS filas FROM read_csv_auto('latencias_web.csv')
UNION ALL
SELECT 'Parquet' AS origen, COUNT(*) AS filas FROM read_parquet('latencias_ud2.parquet');

-- ============================================================
-- BLOQUE 4: Consulta guiada: latencias <= 500 ms
-- ============================================================
SELECT COUNT(*) AS latencias_le_500
FROM read_parquet('latencias_ud2.parquet')
WHERE duracion_ms <= 500;

-- ============================================================
-- BLOQUE 5: Ejercicio autónomo (NO resuelto aquí)
-- Copia solo la consulta del bloque 4, cambia el umbral a 300 ms
-- y ejecútala sin repetir la conversión.
-- ============================================================
