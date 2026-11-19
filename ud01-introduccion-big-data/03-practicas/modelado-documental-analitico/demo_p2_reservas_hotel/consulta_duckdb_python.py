import duckdb

# Conectar a DuckDB (en memoria o con archivo persistente)
con = duckdb.connect()

# 1. Crear la tabla desde CSV
con.execute("""
    CREATE OR REPLACE TABLE reservation_elements AS
    SELECT * FROM read_csv_auto('data/reservas_elementos.csv', header=true)
""")

# 2. Exportar a Parquet con la columna stay_month
con.execute("""
    COPY (
        SELECT *, EXTRACT(MONTH FROM check_in::DATE) AS stay_month
        FROM reservation_elements
    ) TO 'data/reservas_elementos.parquet' (FORMAT PARQUET)
""")

# 3. Total de reservas distintas
res = con.execute("""
    SELECT COUNT(DISTINCT reservation_id) AS reservas
    FROM reservation_elements
""").fetchone()
print(f"Total reservas: {res[0]}")

# 4. Reservas por estado
res = con.execute("""
    SELECT status, COUNT(DISTINCT reservation_id) AS reservas
    FROM reservation_elements
    GROUP BY status
    ORDER BY status
""").fetchdf()
print(res)
# 5. Ingresos por canal
res = con.execute("""
    SELECT channel, ROUND(SUM(reservation_total), 2) AS ingresos
    FROM (
        SELECT DISTINCT reservation_id, channel, reservation_total
        FROM reservation_elements
    )
    GROUP BY channel
    ORDER BY ingresos DESC
""").fetchdf()
print(res)

# 6. Estancia media por ciudad (excluyendo canceladas)
res = con.execute("""
    SELECT hotel_city,
           ROUND(AVG(nights), 2) AS estancia_media,
           COUNT(DISTINCT reservation_id) AS reservas
    FROM reservation_elements
    WHERE status <> 'cancelled'
    GROUP BY hotel_city
    ORDER BY reservas DESC
""").fetchdf()
print(res)
