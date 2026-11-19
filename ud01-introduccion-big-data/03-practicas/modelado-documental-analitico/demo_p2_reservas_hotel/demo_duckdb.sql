CREATE OR REPLACE TABLE reservation_elements AS SELECT * FROM read_csv_auto('data/reservas_elementos.csv', header=true);
COPY (SELECT *, EXTRACT(MONTH FROM check_in::DATE) AS stay_month FROM reservation_elements) TO 'data/reservas_elementos.parquet' (FORMAT PARQUET);
SELECT COUNT(DISTINCT reservation_id) AS reservas FROM reservation_elements;
SELECT status, COUNT(DISTINCT reservation_id) AS reservas FROM reservation_elements GROUP BY status ORDER BY status;
SELECT channel, ROUND(SUM(reservation_total), 2) AS ingresos FROM (SELECT DISTINCT reservation_id, channel, reservation_total FROM reservation_elements) GROUP BY channel ORDER BY ingresos DESC;
SELECT hotel_city, ROUND(AVG(nights), 2) AS estancia_media, COUNT(DISTINCT reservation_id) AS reservas FROM reservation_elements WHERE status <> 'cancelled' GROUP BY hotel_city ORDER BY reservas DESC;
