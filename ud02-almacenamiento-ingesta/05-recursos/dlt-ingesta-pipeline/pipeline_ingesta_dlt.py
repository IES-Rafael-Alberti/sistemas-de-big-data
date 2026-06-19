#!/usr/bin/env python3
"""
Pipeline de ingesta con dlt — Práctica de Integración UD2

Uso:
    pip install dlt duckdb
    python pipeline_ingesta_dlt.py

Carga datos CSV/JSONL de turismo en DuckDB usando dlt,
con soporte de carga incremental.
"""

from __future__ import annotations

import csv
import json
import pathlib

import dlt
from dlt.common import incremental


# ---------------------------------------------------------------------------
# 1. FUENTES (sources) — definimos cómo extraer los datos
# ---------------------------------------------------------------------------

@dlt.resource(name="ventas", primary_key="venta_id")
def ventas_from_csv(
    file_path: str = "datos/practica_medallion/raw/ventas.csv",
    last_date: dlt.sources.incremental[str] = dlt.sources.incremental(
        "fecha", initial_value="2000-01-01"
    ),
):
    """Lee ventas.csv y filtra por incremental (solo filas nuevas)."""
    path = pathlib.Path(file_path)
    if not path.exists():
        print(f"  [SKIP] {path} no existe. Ejecuta primero generar_datos_turismo.py")
        return

    with path.open("r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if row["fecha"] >= last_date.last_value:
                yield {
                    "venta_id": row["venta_id"],
                    "fecha": row["fecha"],
                    "comercio_id": row["comercio_id"],
                    "comercio": row["comercio"],
                    "zona_id": row["zona_id"],
                    "unidades": int(row["unidades"]),
                    "importe": float(row["importe"]),
                }


@dlt.resource(name="reservas", primary_key="reserva_id")
def reservas_from_jsonl(
    file_path: str = "datos/practica_medallion/raw/reservas.jsonl",
    last_date: dlt.sources.incremental[str] = dlt.sources.incremental(
        "fecha", initial_value="2000-01-01"
    ),
):
    """Lee reservas.jsonl y filtra por incremental."""
    path = pathlib.Path(file_path)
    if not path.exists():
        print(f"  [SKIP] {path} no existe.")
        return

    with path.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            obj = json.loads(line)
            if obj["fecha"] >= last_date.last_value:
                obj["personas"] = int(obj["personas"])
                obj["importe"] = float(obj["importe"])
                yield obj


@dlt.resource(name="meteo")
def meteo_from_csv(
    file_path: str = "datos/practica_medallion/raw/meteo.csv",
):
    """Lee meteo.csv (carga completa, no incremental)."""
    path = pathlib.Path(file_path)
    if not path.exists():
        return
    with path.open("r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield {
                "fecha": row["fecha"],
                "temperatura_media": float(row["temperatura_media"]),
                "lluvia_mm": float(row["lluvia_mm"]),
                "viento_kmh": float(row["viento_kmh"]),
            }


@dlt.resource(name="zonas")
def zonas_from_csv(
    file_path: str = "datos/practica_medallion/raw/zonas.csv",
):
    """Lee zonas.csv (carga completa, dataset de referencia)."""
    path = pathlib.Path(file_path)
    if not path.exists():
        return
    with path.open("r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            yield row


# ---------------------------------------------------------------------------
# 2. PIPELINE — configuramos el destino y ejecutamos
# ---------------------------------------------------------------------------

def run_pipeline(dataset_name: str = "bronze") -> dlt.LoadInfo:
    """Ejecuta el pipeline de ingesta.

    Args:
        dataset_name: nombre del dataset en DuckDB (bronze, silver, etc.)

    Returns:
        Info de la carga
    """
    pipeline = dlt.pipeline(
        pipeline_name="ingesta_medallion",
        destination="duckdb",
        dataset_name=dataset_name,
        progress="log",
    )

    # Cargar todas las fuentes
    info = pipeline.run(
        [
            ventas_from_csv(),
            reservas_from_jsonl(),
            meteo_from_csv(),
            zonas_from_csv(),
        ]
    )

    return info


# ---------------------------------------------------------------------------
# 3. CONSULTAS DE VERIFICACIÓN
# ---------------------------------------------------------------------------

def verify_load():
    """Ejecuta consultas de verificación sobre DuckDB."""
    import duckdb

    con = duckdb.connect("ingesta_medallion.duckdb")

    print("\n=== Tablas cargadas ===")
    tables = con.execute(
        "SELECT table_name, table_type FROM information_schema.tables "
        "WHERE table_schema = 'bronze'"
    ).fetchall()
    for tbl in tables:
        count = con.execute(f"SELECT COUNT(*) FROM bronze.{tbl[0]}").fetchone()[0]
        print(f"  {tbl[0]}: {count} registros")

    print("\n=== Muestra de ventas ===")
    print(con.execute("SELECT * FROM bronze.ventas LIMIT 3").df())

    print("\n=== Muestra de reservas ===")
    print(con.execute("SELECT * FROM bronze.reservas LIMIT 3").df())

    con.close()


# ---------------------------------------------------------------------------
# 4. MAIN
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    print("=" * 50)
    print("Pipeline de ingesta con dlt")
    print("=" * 50)

    info = run_pipeline()
    print(f"\n✅ Carga completada: {info}")

    # Mostrar paquetes cargados
    if hasattr(info, "load_packages"):
        for pkg in info.load_packages:
            print(f"  Paquete {pkg.package_id}: {pkg.state}")

    verify_load()

    print("\n" + "=" * 50)
    print("Para ejecutar de nuevo (carga incremental):")
    print("  python pipeline_ingesta_dlt.py")
    print("\nPara ver los datos en DuckDB:")
    print("  duckdb ingesta_medallion.duckdb")
    print("  > SELECT * FROM bronze.ventas;")
    print("=" * 50)
