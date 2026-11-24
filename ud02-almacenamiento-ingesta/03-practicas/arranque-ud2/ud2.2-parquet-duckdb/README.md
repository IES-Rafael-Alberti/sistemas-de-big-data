# UD2.2 — CSV a Parquet con DuckDB CLI

## Qué hay en esta carpeta

- `README.md` → este fichero.
- `02_latencias.sql` → script SQL para DuckDB.
- `latencias_web.csv` → 1000 peticiones web simuladas (procede de la UD1).

## Objetivo

Convertir un CSV en formato Parquet y comprobar que el número de filas se conserva, usando la interfaz de línea de comandos de DuckDB.

## Preparación

1. Abre una terminal en esta carpeta.
2. Comprueba que ves los tres ficheros (`README.md`, `02_latencias.sql`, `latencias_web.csv`).

## Si no tienes el comando `duckdb`

Si usas Conda y el profesor te ha autorizado a instalar, puedes crear un entorno solo con DuckDB CLI:

```bash
conda create -n sbd-parquet --override-channels -c conda-forge duckdb-cli
conda activate sbd-parquet
```

Si ya lo tienes instalado por otro medio, salta al paso de ejecución.

## Ejecución

```bash
duckdb -batch -bail < 02_latencias.sql
```

## Qué debes observar

- El script crea una tabla a partir del CSV.
- Escribe un fichero `latencias_ud2.parquet` en esta misma carpeta.
- Muestra el recuento de filas en CSV y en Parquet: **ambos deben dar 1000**.
- Muestra cuántas latencias son **menores o iguales a 500 ms**: debe salir **900 de 1000**.

## Ejercicio autónomo (no resuelto en el script)

El script propone cambiar el umbral de 500 ms a **300 ms**.

1. Abre `duckdb` desde esta carpeta y copia solo la consulta del bloque 4.
2. Cambia el umbral de `500` a `300` y ejecuta la consulta. No vuelvas a ejecutar el `COPY`: ya tienes el Parquet.
3. Anota el nuevo recuento y razona por qué cambia (o no) respecto al resultado anterior.

## Pregunta de reflexión

¿Cuál es un sistema de ficheros distribuido y cuál un formato de archivo: HDFS o Parquet? ¿Podrías guardar el mismo `.parquet` en local y en HDFS? Justifica tu respuesta. No hay entrega evaluable.
