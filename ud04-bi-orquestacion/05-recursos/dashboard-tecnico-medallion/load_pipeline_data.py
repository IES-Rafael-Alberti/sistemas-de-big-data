#!/usr/bin/env python3
"""Carga los datos Medallion (generados en UD2) en PostgreSQL y añade metadatos
de pipeline para el dashboard técnico de UD4.

Uso:
    python load_pipeline_data.py [--pg-host localhost] [--pg-port 5433]

Requiere: psycopg2-binary, pandas, pyarrow
    pip install psycopg2-binary pandas pyarrow
"""

from __future__ import annotations

import argparse
import csv
import json
import subprocess
import sys
from pathlib import Path

try:
    import psycopg2
except ImportError:
    print("ERROR: Necesitas psycopg2-binary. Ejecuta: pip install psycopg2-binary")
    sys.exit(1)


DATA_RAW = Path("datos/practica_medallion/raw")

TABLES = {
    "bronze_ventas": {
        "sql": """
            CREATE TABLE IF NOT EXISTS bronze_ventas (
                venta_id TEXT, fecha TEXT, comercio_id TEXT, comercio TEXT,
                zona_id TEXT, unidades INTEGER, importe REAL,
                _cargado_en TIMESTAMP DEFAULT NOW()
            );
        """,
        "file": "ventas.csv",
    },
    "bronze_reservas": {
        "sql": """
            CREATE TABLE IF NOT EXISTS bronze_reservas (
                reserva_id TEXT, fecha TEXT, comercio_id TEXT, cliente TEXT,
                personas INTEGER, importe REAL,
                _cargado_en TIMESTAMP DEFAULT NOW()
            );
        """,
        "file": "reservas.jsonl",
    },
    "bronze_meteo": {
        "sql": """
            CREATE TABLE IF NOT EXISTS bronze_meteo (
                fecha TEXT, temperatura_media REAL, lluvia_mm REAL, viento_kmh REAL,
                _cargado_en TIMESTAMP DEFAULT NOW()
            );
        """,
        "file": "meteo.csv",
    },
    "bronze_zonas": {
        "sql": """
            CREATE TABLE IF NOT EXISTS bronze_zonas (
                zona_id TEXT, zona TEXT, tipo_zona TEXT,
                _cargado_en TIMESTAMP DEFAULT NOW()
            );
        """,
        "file": "zonas.csv",
    },
}


def create_pipeline_metadata(conn) -> None:
    """Crea tabla de metadatos del pipeline."""
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS pipeline_metadata (
            capa TEXT,
            tabla TEXT,
            registros INTEGER,
            calidad_valida BOOLEAN,
            fecha_carga DATE,
            duracion_seg REAL
        );
    """)

    registros_totales = 0
    for tbl, info in TABLES.items():
        try:
            cur.execute(f"SELECT COUNT(*) FROM {tbl}")
            registros_totales += cur.fetchone()[0]
        except Exception:
            pass

    # Simular pipeline runs
    import random
    from datetime import date, timedelta

    random.seed(42)
    hoy = date.today()

    for i in range(5):
        dia = hoy - timedelta(days=i)
        for capa, factor in [("bronze", 1.0), ("silver", 0.92), ("gold", 0.85)]:
            reg = int(registros_totales * factor * random.uniform(0.95, 1.0))
            cur.execute(
                """INSERT INTO pipeline_metadata (capa, tabla, registros, calidad_valida, fecha_carga, duracion_seg)
                   VALUES (%s, 'todos', %s, %s, %s, %s)""",
                (capa, reg, reg > 0, dia, round(random.uniform(2.0, 15.0), 1)),
            )

    conn.commit()
    cur.close()


def create_quality_log(conn) -> None:
    """Crea tabla de log de calidad de datos."""
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS calidad_log (
            check_id SERIAL PRIMARY KEY,
            tabla TEXT,
            check_name TEXT,
            resultado TEXT,
            valor INTEGER,
            umbral INTEGER,
            fecha_check TIMESTAMP DEFAULT NOW()
        );
    """)

    import random
    random.seed(42)

    checks = []
    for tbl in TABLES:
        cur.execute(f"SELECT COUNT(*) FROM {tbl}")
        total = cur.fetchone()[0]
        nulos = int(total * random.uniform(0, 0.03))
        checks.append((tbl, "nulos detectados", "WARNING" if nulos > 0 else "PASS", nulos, 0))
        checks.append((tbl, "duplicados", "PASS", 0, 0))
        checks.append((tbl, "registros totales", "PASS", total, 0))

    for chk in checks:
        cur.execute(
            """INSERT INTO calidad_log (tabla, check_name, resultado, valor, umbral)
               VALUES (%s, %s, %s, %s, %s)""",
            chk,
        )

    conn.commit()
    cur.close()


def load_csv_to_table(conn, filepath: Path, table: str) -> int:
    """Carga CSV a PostgreSQL."""
    cur = conn.cursor()
    with filepath.open("r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames or []
        cols = [c for c in fieldnames if c]  # skip empty
        placeholders = ", ".join(["%s"] * len(cols))
        columns = ", ".join(cols)
        rows = []
        for row in reader:
            rows.append(tuple(row.get(c, "") for c in cols))

        for row in rows:
            cur.execute(
                f"INSERT INTO {table} ({columns}) VALUES ({placeholders})",
                row,
            )

    conn.commit()
    count = len(rows)
    cur.close()
    return count


def load_jsonl_to_table(conn, filepath: Path, table: str) -> int:
    """Carga JSONL a PostgreSQL."""
    cur = conn.cursor()
    rows: list[tuple[str, ...]] = []

    with filepath.open("r", encoding="utf-8") as f:
        first = True
        cols: list[str] = []
        placeholders = ""
        columns = ""
        for line in f:
            line = line.strip()
            if not line:
                continue
            obj = json.loads(line)
            if first:
                cols = list(obj.keys())
                placeholders = ", ".join(["%s"] * len(cols))
                columns = ", ".join(cols)
                first = False
            rows.append(tuple(str(obj.get(c, "")) for c in cols))

    for row in rows:
        cur.execute(
            f"INSERT INTO {table} ({columns}) VALUES ({placeholders})",
            row,
        )

    conn.commit()
    count = len(rows)
    cur.close()
    return count


def main():
    parser = argparse.ArgumentParser(description="Carga datos Medallion a PostgreSQL")
    parser.add_argument("--pg-host", default="localhost")
    parser.add_argument("--pg-port", default="5433")
    parser.add_argument("--pg-user", default="bi_user")
    parser.add_argument("--pg-password", default="bi_pass")
    parser.add_argument("--pg-database", default="bi_db")
    args = parser.parse_args()

    print("Conectando a PostgreSQL...")
    conn = psycopg2.connect(
        host=args.pg_host,
        port=args.pg_port,
        user=args.pg_user,
        password=args.pg_password,
        dbname=args.pg_database,
    )

    total = 0
    for table_name, info in TABLES.items():
        filepath = DATA_RAW / info["file"]
        if not filepath.exists():
            print(f"  [SKIP] {filepath} no existe. Ejecuta primero generar_datos_turismo.py")
            continue

        cur = conn.cursor()
        cur.execute(f"DROP TABLE IF EXISTS {table_name}")
        cur.execute(info["sql"])
        conn.commit()
        cur.close()

        ext = filepath.suffix.lower()
        if ext == ".csv":
            count = load_csv_to_table(conn, filepath, table_name)
        elif ext == ".jsonl":
            count = load_jsonl_to_table(conn, filepath, table_name)
        else:
            print(f"  [SKIP] Formato no soportado: {ext}")
            continue

        print(f"  {table_name}: {count} registros cargados")
        total += count

    print(f"\nTotal: {total} registros en bronze")

    print("\nCreando pipeline_metadata...")
    create_pipeline_metadata(conn)

    print("Creando calidad_log...")
    create_quality_log(conn)

    # Crear vista gold para el dashboard técnico
    cur = conn.cursor()
    cur.execute("""
        CREATE OR REPLACE VIEW gold_resumen_pipeline AS
        SELECT
            pm.capa,
            pm.fecha_carga,
            pm.registros,
            pm.calidad_valida,
            pm.duracion_seg,
            COALESCE(cl.nulos, 0) AS nulos_detectados
        FROM pipeline_metadata pm
        LEFT JOIN (
            SELECT tabla, fecha_check::date AS f, SUM(valor) AS nulos
            FROM calidad_log
            WHERE check_name = 'nulos detectados'
            GROUP BY tabla, fecha_check::date
        ) cl ON cl.f = pm.fecha_carga
        ORDER BY pm.fecha_carga DESC, pm.capa;
    """)
    conn.commit()
    cur.close()

    conn.close()
    print("\n✅ Listo. Conecta Metabase a PostgreSQL en localhost:5433, db=bi_db")
    print("   Crea dashboards técnicos sobre pipeline_metadata y calidad_log.")


if __name__ == "__main__":
    main()
