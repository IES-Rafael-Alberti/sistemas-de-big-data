# Arranque de UD2 — Almacenamiento e ingesta

Esta carpeta contiene dos mini-prácticas de arranque para introducir conceptos de almacenamiento distribuido y formatos columnares. Están pensadas para ejecutarse en local, sin clúster ni servicios en la nube.

## Prácticas

| Sesión | Carpeta | Contenido | Qué se practica |
| ------ | ------- | --------- | --------------- |
| UD2.1 | [`ud2.1-hdfs-replicas/`](./ud2.1-hdfs-replicas/README.md) | `simular_replicas.py` | Cómo HDFS reparte bloques y réplicas; qué pasa si caen nodos. |
| UD2.2 | [`ud2.2-parquet-duckdb/`](./ud2.2-parquet-duckdb/README.md) | `latencias_web.csv` + `02_latencias.sql` | Convertir CSV a Parquet con DuckDB CLI y consultar el resultado. |

## Antes de empezar

1. Abre una terminal en la carpeta de la práctica correspondiente.
2. Lee primero el `README.md` de esa carpeta.
3. Ejecuta los comandos tal como aparecen; si algo falla, revisa que estés en la carpeta correcta.

## Nota

Este material es de trabajo para el alumnado. No incluye guiones docentes, claves, datos personales ni tests GIFT.
