# Informe — Benchmark pandas vs DuckDB vs Spark

## Resumen

Se ha cubierto el hueco de prioridad alta de UD3: crear un laboratorio para evidenciar eficiencia y selección razonada de herramientas.

El laboratorio compara pandas, DuckDB y Spark/PySpark con el mismo dataset y las mismas consultas.

## Archivos creados

| Archivo | Acción |
| ------- | ------ |
| `ud03-procesamiento-distribuido/03-practicas/Spark_Labs/UD3_Lab_Benchmark_Pandas_DuckDB_Spark.md` | Guion del laboratorio. |
| `ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/generar_dataset_benchmark.py` | Generador de dataset sintético CSV/Parquet. |
| `ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py` | Script didáctico de benchmark. |
| `ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/README.md` | Instrucciones de uso. |

## Decisión docente

El laboratorio no busca demostrar que Spark siempre es mejor. Busca que el alumnado justifique cuándo pandas basta, cuándo DuckDB es una opción excelente para analítica local sobre Parquet y cuándo Spark compensa su coste operativo.

## Pendiente siguiente recomendado

El siguiente hueco de prioridad alta del backlog es crear una matriz coste-calidad-viabilidad para cubrir RA1.g de forma explícita.
