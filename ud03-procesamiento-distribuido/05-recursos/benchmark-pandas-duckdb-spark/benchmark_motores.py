#!/usr/bin/env python3
"""Benchmark didáctico pandas vs DuckDB vs Spark.

No pretende ser un benchmark científico. Sirve para comparar ergonomía,
tiempos aproximados y fricción operativa con las mismas consultas.
"""

from __future__ import annotations

import argparse
import sys
import time
from pathlib import Path
from typing import Callable

DATA = Path('datos/benchmark_motores')


def timed(label: str, fn: Callable[[], object]) -> float:
    start = time.perf_counter()
    result = fn()
    elapsed = time.perf_counter() - start
    print(f'{label}: {elapsed:.4f}s')
    try:
        print(result.head(5))
    except AttributeError:
        print(result)
    print('-' * 60)
    return elapsed


def ensure_data() -> None:
    if not (DATA / 'eventos.parquet').exists():
        raise SystemExit('No existe datos/benchmark_motores/eventos.parquet. Ejecuta primero generar_dataset_benchmark.py')


def run_pandas() -> None:
    import pandas as pd

    print('\n## pandas')
    eventos = pd.read_parquet(DATA / 'eventos.parquet')
    zonas = pd.read_parquet(DATA / 'zonas.parquet')

    timed('Q1 conteo filas', lambda: len(eventos))
    timed('Q2 ventas por zona', lambda: eventos.groupby('zona_id', as_index=False)['importe'].sum().sort_values('importe', ascending=False))
    timed('Q3 ventas por zona y mes', lambda: eventos.groupby(['zona_id', 'mes'], as_index=False)['importe'].sum())
    timed('Q4 top comercios', lambda: eventos.groupby('comercio_id', as_index=False)['importe'].sum().sort_values('importe', ascending=False).head(10))
    timed('Q5 join y tipo zona', lambda: eventos.merge(zonas, on='zona_id').groupby('tipo_zona', as_index=False)['importe'].sum().sort_values('importe', ascending=False))
    timed('Q6 importe alto y lluvia', lambda: eventos[(eventos['importe'] > 500) & (eventos['lluvia_mm'] > 5)].groupby('zona_id', as_index=False)['evento_id'].count())


def run_duckdb() -> None:
    try:
        import duckdb
    except ImportError as exc:
        raise SystemExit('DuckDB no está instalado. Ejecuta: pip install duckdb') from exc

    print('\n## DuckDB')
    con = duckdb.connect()
    eventos = str(DATA / 'eventos.parquet')
    zonas = str(DATA / 'zonas.parquet')

    timed('Q1 conteo filas', lambda: con.sql(f"SELECT COUNT(*) AS filas FROM '{eventos}'").df())
    timed('Q2 ventas por zona', lambda: con.sql(f"SELECT zona_id, SUM(importe) AS importe FROM '{eventos}' GROUP BY zona_id ORDER BY importe DESC").df())
    timed('Q3 ventas por zona y mes', lambda: con.sql(f"SELECT zona_id, mes, SUM(importe) AS importe FROM '{eventos}' GROUP BY zona_id, mes").df())
    timed('Q4 top comercios', lambda: con.sql(f"SELECT comercio_id, SUM(importe) AS importe FROM '{eventos}' GROUP BY comercio_id ORDER BY importe DESC LIMIT 10").df())
    timed('Q5 join y tipo zona', lambda: con.sql(f"SELECT z.tipo_zona, SUM(e.importe) AS importe FROM '{eventos}' e JOIN '{zonas}' z USING (zona_id) GROUP BY z.tipo_zona ORDER BY importe DESC").df())
    timed('Q6 importe alto y lluvia', lambda: con.sql(f"SELECT zona_id, COUNT(*) AS eventos FROM '{eventos}' WHERE importe > 500 AND lluvia_mm > 5 GROUP BY zona_id").df())


def run_spark() -> None:
    try:
        from pyspark.sql import SparkSession
        from pyspark.sql import functions as F
    except ImportError as exc:
        raise SystemExit('PySpark no está instalado. Ejecuta: pip install pyspark') from exc

    print('\n## Spark')
    spark = SparkSession.builder.appName('benchmark-pandas-duckdb-spark').master('local[*]').getOrCreate()
    spark.sparkContext.setLogLevel('ERROR')
    eventos = spark.read.parquet(str(DATA / 'eventos.parquet'))
    zonas = spark.read.parquet(str(DATA / 'zonas.parquet'))

    def show(df):
        rows = df.limit(5).toPandas()
        return rows

    timed('Q1 conteo filas', lambda: eventos.count())
    timed('Q2 ventas por zona', lambda: show(eventos.groupBy('zona_id').agg(F.sum('importe').alias('importe')).orderBy(F.desc('importe'))))
    timed('Q3 ventas por zona y mes', lambda: show(eventos.groupBy('zona_id', 'mes').agg(F.sum('importe').alias('importe'))))
    timed('Q4 top comercios', lambda: show(eventos.groupBy('comercio_id').agg(F.sum('importe').alias('importe')).orderBy(F.desc('importe')).limit(10)))
    timed('Q5 join y tipo zona', lambda: show(eventos.join(zonas, 'zona_id').groupBy('tipo_zona').agg(F.sum('importe').alias('importe')).orderBy(F.desc('importe'))))
    timed('Q6 importe alto y lluvia', lambda: show(eventos.filter((F.col('importe') > 500) & (F.col('lluvia_mm') > 5)).groupBy('zona_id').agg(F.count('*').alias('eventos'))))
    spark.stop()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument('--engine', choices=['all', 'pandas', 'duckdb', 'spark'], default='all')
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    ensure_data()
    engines = ['pandas', 'duckdb', 'spark'] if args.engine == 'all' else [args.engine]
    for engine in engines:
        try:
            if engine == 'pandas':
                run_pandas()
            elif engine == 'duckdb':
                run_duckdb()
            elif engine == 'spark':
                run_spark()
        except Exception as exc:
            print(f'ERROR en {engine}: {exc}', file=sys.stderr)
            if engine != 'spark':
                raise


if __name__ == '__main__':
    main()
