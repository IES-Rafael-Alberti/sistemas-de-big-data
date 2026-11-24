#!/usr/bin/env python3
"""
Simulador didáctico de distribución de bloques con réplicas.

Modelo simplificado (NO es HDFS real):
- Un archivo se parte en 4 bloques con los tamaños indicados.
- Cada bloque tiene 3 réplicas repartidas rotativamente entre 4 nodos.
- Se simula la caída de nodos pasándolos como argumentos.
- Se muestra, bloque a bloque, qué réplicas siguen vivas y si el archivo
  completo sigue siendo reconstruible (cada bloque debe tener >=1 réplica viva).

Uso:
    python3 simular_replicas.py              # estado sano, todos los nodos vivos
    python3 simular_replicas.py N1           # caída del nodo N1
    python3 simular_replicas.py N1 N2 N3     # caída de N1, N2 y N3
"""

import sys


NODOS = ["N1", "N2", "N3", "N4"]

# Bloques del archivo: identificador, tamaño en MiB y nodos donde residen sus réplicas.
BLOQUES = [
    ("B1", 128, ["N1", "N2", "N3"]),
    ("B2", 128, ["N2", "N3", "N4"]),
    ("B3", 128, ["N3", "N4", "N1"]),
    ("B4",  16, ["N4", "N1", "N2"]),
]


def main():
    caidos = set(sys.argv[1:])
    vivos = set(NODOS) - caidos

    if caidos:
        print(f"Nodos caídos: {sorted(caidos)}")
        print(f"Nodos vivos:  {sorted(vivos)}")
    else:
        print("Estado sano: todos los nodos están vivos.")
    print()

    archivo_reconstruible = True
    for nombre, tamaño, replicas in BLOQUES:
        vivas = [n for n in replicas if n in vivos]
        reconstruible = len(vivas) > 0
        if not reconstruible:
            archivo_reconstruible = False

        estado_bloque = "OK" if reconstruible else "PERDIDO"
        print(
            f"{nombre} ({tamaño} MiB)  réplicas={replicas}  "
            f"vivas={vivas}  -> {estado_bloque}"
        )

    print()
    if archivo_reconstruible:
        print("Resultado: archivo reconstruible (cada bloque tiene al menos una réplica viva).")
    else:
        print("Resultado: archivo NO reconstruible (algún bloque no tiene réplicas vivas).")


if __name__ == "__main__":
    main()
