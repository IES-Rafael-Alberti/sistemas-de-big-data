"""Copiar un lote local a raw sin sobrescribir una captura anterior."""

from pathlib import Path

BASE = Path(__file__).resolve().parent
origen = BASE / "lecturas_servicio.csv"
destino = BASE / "raw" / "lecturas_servicio.csv"
destino.parent.mkdir(exist_ok=True)

try:
    with destino.open("xb") as salida:
        salida.write(origen.read_bytes())
except FileExistsError:
    print("La captura ya existe: no se ha sobrescrito.")
else:
    print(f"Origen: {origen.name}")
    print("Destino: raw/lecturas_servicio.csv")
    print(f"Contenido igual al origen: {origen.read_bytes() == destino.read_bytes()}")
