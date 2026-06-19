"""
Plantilla base - Ingesta mínima (P5)
------------------------------------
Objetivo: cargar un CSV o API pública, validar datos y exportar en formato Parquet particionado.
Completa las secciones marcadas con # TODO
"""

import pandas as pd
import pyarrow.parquet as pq
import pyarrow as pa
from pathlib import Path

# === CONFIGURACIÓN ===
DATASET = "ventas"           # TODO: cambia por el nombre del dataset
SOURCE = Path("data/raw")    # Carpeta de origen
TARGET = Path("data_lake/curated") / DATASET
TARGET.mkdir(parents=True, exist_ok=True)

# === 1. LECTURA ===
print("Leyendo datos...")
df = pd.read_csv(SOURCE / "dataset.csv")  # TODO: ajusta el nombre y separador
print(f"Filas leídas: {len(df)}")

# === 2. VALIDACIONES ===
# TODO: aplicar tus reglas de calidad (nulos, rangos, tipos…)
# Ejemplo:
# df = df.dropna(subset=["id"])
# df = df[df["precio"] > 0]

# === 3. PARTICIONADO Y EXPORTACIÓN ===
df["ts"] = pd.to_datetime(df["ts"], errors="coerce")
df["anio"] = df["ts"].dt.year
df["mes"] = df["ts"].dt.month

for (y, m), part in df.groupby(["anio", "mes"]):
    path = TARGET / f"anio={y}/mes={m}"
    path.mkdir(parents=True, exist_ok=True)
    pq.write_table(pa.Table.from_pandas(part, preserve_index=False),
                   path / f"{DATASET}.parquet")
print("Exportación completada.")

# === 4. RESUMEN ===
print("Resumen final:")
print(df.describe(include='all'))
print("OK: Ingesta completada correctamente.")
