#!/usr/bin/env python3
"""Genera datos sintéticos para la práctica local Medallion de UD2.

No requiere dependencias externas. Crea CSV y JSONL en:

datos/practica_medallion/raw/
"""

from __future__ import annotations

import csv
import json
import random
from datetime import date, timedelta
from pathlib import Path

random.seed(42)

BASE = Path('datos/practica_medallion/raw')
BASE.mkdir(parents=True, exist_ok=True)

zonas = [
    {'zona_id': 'Z01', 'zona': 'Centro', 'tipo_zona': 'comercial'},
    {'zona_id': 'Z02', 'zona': 'Playa Norte', 'tipo_zona': 'turistica'},
    {'zona_id': 'Z03', 'zona': 'Playa Sur', 'tipo_zona': 'turistica'},
    {'zona_id': 'Z04', 'zona': 'Puerto', 'tipo_zona': 'ocio'},
    {'zona_id': 'Z05', 'zona': 'Casco Historico', 'tipo_zona': 'cultural'},
]

comercios = [
    ('C001', 'Restaurante Brisa', 'Z02'),
    ('C002', 'Hotel Mirador', 'Z05'),
    ('C003', 'Tienda Centro', 'Z01'),
    ('C004', 'Heladeria Norte', 'Z02'),
    ('C005', 'Bar Puerto', 'Z04'),
    ('C006', 'Souvenirs Sur', 'Z03'),
]

inicio = date(2026, 3, 1)
dias = [inicio + timedelta(days=i) for i in range(45)]

with (BASE / 'zonas.csv').open('w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['zona_id', 'zona', 'tipo_zona'])
    writer.writeheader()
    writer.writerows(zonas)

with (BASE / 'meteo.csv').open('w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['fecha', 'temperatura_media', 'lluvia_mm', 'viento_kmh'])
    writer.writeheader()
    for d in dias:
        lluvia = round(max(0, random.gauss(1.2, 3.5)), 1)
        writer.writerow({
            'fecha': d.isoformat(),
            'temperatura_media': round(random.uniform(13, 28), 1),
            'lluvia_mm': lluvia,
            'viento_kmh': round(random.uniform(4, 35), 1),
        })

with (BASE / 'ventas.csv').open('w', newline='', encoding='utf-8') as f:
    writer = csv.DictWriter(f, fieldnames=['venta_id', 'fecha', 'comercio_id', 'comercio', 'zona_id', 'unidades', 'importe'])
    writer.writeheader()
    venta_id = 1
    for d in dias:
        for comercio_id, comercio, zona_id in comercios:
            if random.random() < 0.82:
                unidades = random.randint(1, 35)
                importe = round(unidades * random.uniform(4.5, 38.0), 2)
                if random.random() < 0.025:
                    importe = -importe  # incidencia intencionada
                writer.writerow({
                    'venta_id': f'V{venta_id:05d}',
                    'fecha': d.isoformat(),
                    'comercio_id': comercio_id,
                    'comercio': comercio,
                    'zona_id': zona_id,
                    'unidades': unidades,
                    'importe': importe,
                })
                venta_id += 1

with (BASE / 'reservas.jsonl').open('w', encoding='utf-8') as f:
    reserva_id = 1
    alojamientos = ['Hotel Mirador', 'Apartamentos Norte', 'Hostal Puerto', 'Camping Sur']
    for d in dias:
        for _ in range(random.randint(4, 12)):
            zona = random.choice(zonas)
            if random.random() < 0.03:
                zona_id = 'Z99'  # zona desconocida intencionada
            else:
                zona_id = zona['zona_id']
            row = {
                'reserva_id': f'R{reserva_id:05d}',
                'fecha': d.isoformat(),
                'alojamiento': random.choice(alojamientos),
                'zona_id': zona_id,
                'personas': random.randint(1, 5),
                'ocupacion_pct': round(random.uniform(35, 98), 2),
                'canal': random.choice(['web', 'agencia', 'telefono', 'marketplace']),
            }
            f.write(json.dumps(row, ensure_ascii=False) + '\n')
            reserva_id += 1

print(f'Datos generados en {BASE.resolve()}')
print('Archivos: ventas.csv, reservas.jsonl, meteo.csv, zonas.csv')
