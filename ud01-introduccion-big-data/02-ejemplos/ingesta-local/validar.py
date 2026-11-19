"""Contar valores ausentes sin modificar la captura raw."""

import csv
from pathlib import Path

ruta = Path(__file__).resolve().parent / "raw" / "lecturas_servicio.csv"
if not ruta.exists():
    raise SystemExit("Falta la captura raw. Ejecuta primero ingestar.py.")

with ruta.open(encoding="utf-8", newline="") as archivo:
    filas = list(csv.DictReader(archivo))

ausentes = sum(not fila["duracion_ms"].strip() for fila in filas)
print(f"Filas leídas: {len(filas)}")
print(f"Duraciones ausentes: {ausentes}")
print(f"Duraciones presentes: {len(filas) - ausentes}")
