# Recursos — Benchmark pandas vs DuckDB vs Spark

Scripts de apoyo para el laboratorio UD3.

## Generar datos

```bash
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/generar_dataset_benchmark.py --rows 200000
```

## Ejecutar benchmark

```bash
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py --engine all
```

Si Spark no está instalado:

```bash
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py --engine pandas
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py --engine duckdb
```
