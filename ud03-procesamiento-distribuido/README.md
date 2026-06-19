# UD3 — Procesamiento distribuido

## Estructura

| Sección | Uso | Nº archivos |
| ------- | --- | ----------: |
| `01-teoria/` | Fuentes editables y apuntes principales. | 7 |
| `02-ejemplos/` | Notebooks, scripts y ejemplos no evaluables. | 0 |
| `03-practicas/` | Guiones de laboratorio y prácticas de aula. | 45 |
| `04-evaluacion/` | Enunciados evaluables, rúbricas y documentos de entrega. | 12 |
| `05-recursos/` | Datasets, imágenes, plantillas, ZIPs docentes y dependencias. | 4 |
| `90-archivo/` | Derivados publicados, histórico y material no canónico. | 14 |
| `99-profesor/` | Notas internas, guías docentes y corrección reutilizable. | 23 |

## RA/CE cubiertos

| RA/CE | Material | Tipo |
|-------|----------|------|
| **RA1.f** | Benchmark pandas vs DuckDB vs Spark (selección herramientas) | Evaluable |
| **RA1.g** | Benchmark (coste/rendimiento/viabilidad) | Evaluable |
| **RA3.b** | Benchmark (tecnologías eficientes según volumen) | Evaluable |
| **RA3.c** | Cápsula Hadoop histórico vs Spark (grandes volúmenes) | Teoría |
| **RA3.c** | Spark Labs 1-4 (procesamiento distribuido práctico) | Evaluable |
| **RA4.c** | Spark Labs (clúster Master/Worker, HDFS) | Evaluable |
| **RA4.d** | Benchmark (comparativa pandas/DuckDB/Spark) | Evaluable |
| **RA4.e** | Spark Labs (scripts PySpark, RDDs, DataFrames) | Evaluable |
| **RA4.f** | Lab Grafana (monitorización visual) | Evaluable |
| **RA4.f** | Lab Kibana (exploración y dashboards) | Evaluable |
| **RA2.c** | Lab Grafana (dashboard monitorización) | Evaluable |
| **RA2.e** | Lab Grafana (reflexión sobre métricas) | Evaluable |

> Los labs de Grafana y Kibana son material heredado. Cubren RA2 y RA4 pero su
> ubicación en UD3 es debatible (son visualización/monitorización, no procesamiento
> distribuido). Pendiente de revisión para próximos cursos.

Ver `00-planificacion/matriz_ra_ce_materiales.md` para el detalle completo.

## Material nuevo — Hadoop histórico vs Spark actual

- `01-teoria/UD3_Capsula_Hadoop_historico_vs_Spark_actual.md` — cápsula breve para explicar Hadoop como fundamento histórico/conceptual y Spark/PySpark como herramienta práctica principal de procesamiento distribuido moderno. Incluye mini-actividad y criterio de evaluación rápido.

## Material nuevo — Benchmark pandas vs DuckDB vs Spark

- `03-practicas/Spark_Labs/UD3_Lab_Benchmark_Pandas_DuckDB_Spark.md` — laboratorio para comparar pandas, DuckDB y Spark/PySpark con el mismo dataset y justificar selección de herramienta.
- `05-recursos/benchmark-pandas-duckdb-spark/` — generador de dataset y script de benchmark reproducible.
