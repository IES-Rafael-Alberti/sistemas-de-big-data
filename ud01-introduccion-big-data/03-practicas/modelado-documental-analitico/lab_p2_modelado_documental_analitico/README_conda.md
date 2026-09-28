# Entorno Conda sbd-lab para el lab P2

Este entorno **sbd-lab** es común para todos los labs del módulo. Aquí lo usamos con **DuckDB** (API y CLI), **pandas** y **pyarrow**.

## 1) Crear/actualizar el entorno
```bash
conda env create -f environment.yml
# o, si ya existe:
conda env update -f environment.yml --prune
```

## 2) Activar
```bash
conda activate sbd-lab
```

## 3) Probar instalación
```bash
python -c "import duckdb, pandas, pyarrow, numpy; print('OK:', duckdb.__version__)"
```

## 4) Ejecutar el lab P2
```bash
# Generar datos (si procede)
python genera_datos_p2.py

# Ejecutar SQL con el CLI de DuckDB (incluido en este entorno)
duckdb -c ".read p2_duckdb.sql"
```

## 5) Añadir paquetes para otros labs (futuro)
Rápido (instalación puntual):
```bash
conda install -n sbd-lab polars pyspark -c conda-forge
```
Declarativo (deja constancia en `environment.yml` y actualiza):
```bash
# editar environment.yml y luego:
conda env update -f environment.yml --prune
```

## 6) Registrar kernel en Jupyter (opcional)
```bash
python -m ipykernel install --user --name sbd-lab --display-name "Python (sbd-lab)"
```

## 7) Desactivar / eliminar
```bash
conda deactivate
conda remove -n sbd-lab --all
```
