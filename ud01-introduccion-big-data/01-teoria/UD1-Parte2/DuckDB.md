# Instalar y usar DuckDB

¡Fácil! Tienes dos “sabores”: **API de Python** (para usar DuckDB desde tus notebooks/scripts) y el **CLI** (cliente de línea de comandos). Te dejo las opciones más comunes:

## 1) API de Python (recomendado para los labs)

```bash
# Requiere Python ≥ 3.9
pip install duckdb
# (alternativa con conda)
conda install -c conda-forge python-duckdb
```

Esto instala el módulo `duckdb` para usarlo desde Python. Docs oficiales: instalación con `pip/conda`. ([DuckDB][1])

## 2) CLI (cliente de línea de comandos)

El CLI es un binario único (sin dependencias). Instálalo así según tu SO:

* **macOS / Linux (Homebrew):**

  ```bash
  brew install duckdb
  ```

  Fórmula oficial de Homebrew. ([Homebrew Formulae][2])

* **Windows (winget):**

  ```powershell
  winget install DuckDB.cli
  ```

  Instalación recomendada por el proyecto. ([DuckDB][3])

* **Descarga directa (cualquier SO):**

  * Binarios precompilados o script:

    ```bash
    curl https://install.duckdb.org | sh
    ```

    (también hay ZIPs por plataforma en la página de instalación). ([DuckDB][3])

* **Conda (CLI):**

  ```bash
  conda install -c conda-forge duckdb-cli
  ```

  Paquete del cliente en conda-forge. ([anaconda.org][4])

* **Docker (sin instalar nada en el host):**

  ```bash
  docker run --rm -it -v "$(pwd):/workspace" -w /workspace duckdb/duckdb
  ```

  Imagen oficial del CLI. ([DuckDB][3])

## 3) Comprobación rápida

* **CLI:**

  ```bash
  duckdb -c "SELECT 42;"
  ```
* **Python:**

  ```bash
  python -c "import duckdb; import pandas as pd; print(duckdb.__version__)"
  ```

## 4) Cómo usarlo con tu lab P2

Dentro de la carpeta del lab:

```bash
duckdb -c ".read p2_duckdb.sql"
```



[1]: https://duckdb.org/docs/stable/clients/python/overview.html?utm_source=chatgpt.com "Python API"
[2]: https://formulae.brew.sh/formula/duckdb?utm_source=chatgpt.com "duckdb"
[3]: https://duckdb.org/install/?utm_source=chatgpt.com "DuckDB Installation"
[4]: https://anaconda.org/conda-forge/duckdb-cli?utm_source=chatgpt.com "Duckdb Cli - conda-forge"