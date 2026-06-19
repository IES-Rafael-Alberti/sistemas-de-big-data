#!/usr/bin/env python3
"""Genera un dataset sintético para comparar pandas, DuckDB y Spark.

Uso:
    python generar_dataset_benchmark.py --rows 200000
"""

from __future__ import annotations

import argparse
import csv
import random
from datetime import date, timedelta
from pathlib import Path

try:
    import pandas as pd
except ImportError as exc:
    raise SystemExit('Instala pandas y pyarrow: pip install pandas pyarrow') from exc


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument('--rows', type=int, default=200_000, help='Número de eventos a generar')
    parser.add_argument('--out', default='datos/benchmark_motores', help='Directorio de salida')
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    random.seed(42)
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    zonas = [
        ('Z01', 'Centro', 'comercial'),
        ('Z02', 'Playa Norte', 'turistica'),
        ('Z03', 'Playa Sur', 'turistica'),
        ('Z04', 'Puerto', 'ocio'),
        ('Z05', 'Casco Historico', 'cultural'),
        ('Z06', 'Sierra', 'naturaleza'),
    ]
    comercios = [f'C{i:04d}' for i in range(1, 151)]
    canales = ['web', 'tienda', 'marketplace', 'telefono']
    inicio = date(2026, 1, 1)

    zonas_csv = out / 'zonas.csv'
    with zonas_csv.open('w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['zona_id', 'zona', 'tipo_zona'])
        writer.writerows(zonas)

    eventos_csv = out / 'eventos.csv'
    with eventos_csv.open('w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['evento_id', 'fecha', 'mes', 'zona_id', 'comercio_id', 'canal', 'unidades', 'importe', 'lluvia_mm'])
        for i in range(1, args.rows + 1):
            d = inicio + timedelta(days=random.randint(0, 364))
            zona_id = random.choice(zonas)[0]
            unidades = random.randint(1, 12)
            importe = round(unidades * random.uniform(3.5, 80.0), 2)
            lluvia = round(max(0.0, random.gauss(1.5, 4.0)), 1)
            writer.writerow([
                f'E{i:08d}',
                d.isoformat(),
                d.strftime('%Y-%m'),
                zona_id,
                random.choice(comercios),
                random.choice(canales),
                unidades,
                importe,
                lluvia,
            ])

    eventos = pd.read_csv(eventos_csv)
    zonas_df = pd.read_csv(zonas_csv)
    eventos.to_parquet(out / 'eventos.parquet', index=False)
    zonas_df.to_parquet(out / 'zonas.parquet', index=False)

    print(f'Dataset generado en {out.resolve()}')
    print(f'Filas eventos: {len(eventos):,}')
    print('Archivos: eventos.csv, eventos.parquet, zonas.csv, zonas.parquet')


if __name__ == '__main__':
    main()
