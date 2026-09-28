# Guía de instalación de DuckDB (CLI y API de Python)

Este documento explica cómo instalar **DuckDB** para ejecutar el laboratorio **P2 — Modelado documental vs analítico** en **Linux**, **Windows 10/11** y **macOS**. Incluye dos vías:
- **CLI** (cliente de línea de comandos): para ejecutar `.read p2_duckdb.sql` tal cual.
- **API de Python**: por si alguien no puede instalar el CLI o prefiere usar Python.

> **Requisito del lab P2:** cualquiera de las dos (CLI **o** API Python) sirve.

---

## 0) Comprobación rápida (valida tu instalación)

- **CLI:**
  ```bash
  duckdb -c "SELECT 42;"
  ```
  Debe imprimir `42` sin errores.

- **Python:**
  ```bash
  python -c "import duckdb; print(duckdb.__version__)"
  ```

---

## 1) Linux (docente)

### Opción A — Script oficial (CLI)
```bash
curl https://install.duckdb.org | sh
# Añade DuckDB a tu PATH (bash/zsh):
echo 'export PATH="$HOME/.duckdb:$PATH"' >> ~/.bashrc
source ~/.bashrc
duckdb --version
```

### Opción B — Homebrew en Linux (CLI)
```bash
brew install duckdb
duckdb --version
```

### Opción C — Solo Python (API)
```bash
python3 -m pip install duckdb pandas pyarrow
python3 -c "import duckdb, pandas as pd; print(duckdb.__version__)"
```

**Probar el lab (CLI):**
```bash
duckdb -c ".read p2_duckdb.sql"
```

---

## 2) Windows 10/11 (alumnado)

### Opción A — winget (CLI)
En **PowerShell**:
```powershell
winget install DuckDB.cli
duckdb --version
```

### Opción B — Portable (CLI, sin admin)
1. Descarga el binario `duckdb.exe` para Windows (CLI).
2. Copia `duckdb.exe` en la carpeta del proyecto (donde está `p2_duckdb.sql`).
3. En **PowerShell**, dentro de esa carpeta:
   ```powershell
   .\duckdb.exe -c '.read p2_duckdb.sql'
   ```

### Opción C — Solo Python (API)
```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install duckdb pandas pyarrow
python -c "import duckdb; print(duckdb.__version__)"
```
Para ejecutar el SQL **sin CLI**:
```powershell
python - << 'PY'
import duckdb
sql = open('p2_duckdb.sql','r',encoding='utf-8').read()
con = duckdb.connect()
con.execute(sql)
print("Consultas ejecutadas.")
PY
```

**Notas rápidas Windows**
- Si `duckdb` “no se reconoce”, usa el **.exe local** (`.\duckdb.exe ...`) o añade su carpeta al **PATH**.
- En **PowerShell**, usa **comillas simples** en `-c '.read p2_duckdb.sql'` para evitar problemas de escape.

---

## 3) macOS (un alumno)

### Opción A — Homebrew (CLI)
```bash
brew install duckdb
duckdb --version
```

### Opción B — Solo Python (API)
```bash
python3 -m pip install duckdb pandas pyarrow
python3 -c "import duckdb; print(duckdb.__version__)"
```

**Probar el lab (CLI):**
```bash
duckdb -c ".read p2_duckdb.sql"
```

---

## 4) Alternativas y “Plan B”

### Conda (CLI y/o Python)
- **API Python:**
  ```bash
  conda install -c conda-forge python-duckdb
  ```
- **CLI:**
  ```bash
  conda install -c conda-forge duckdb-cli
  ```

### Docker (CLI sin instalar nada en el host)
```bash
docker run --rm -it -v "$(pwd):/workspace" -w /workspace duckdb/duckdb -c ".read p2_duckdb.sql"
```

---

## 5) Uso con el laboratorio P2

**Con CLI:**
```bash
duckdb -c ".read p2_duckdb.sql"
```

**Con Python (si no hay CLI):**
```bash
pip install duckdb pandas pyarrow
python - << 'PY'
import duckdb
sql = open('p2_duckdb.sql','r',encoding='utf-8').read()
con = duckdb.connect()
con.execute(sql)
print("Consultas ejecutadas.")
PY
```

---

## 6) Solución de problemas (FAQ)

- **“duckdb: command not found” / “no se reconoce como un comando”**  
  • Verifica que el binario esté en el PATH. En Windows, usa `.\duckdb.exe` si está en la carpeta del proyecto.  
  • En Linux con script oficial, asegúrate de haber añadido `~/.duckdb` al PATH y reiniciado terminal.

- **Errores al ejecutar `.read p2_duckdb.sql`**  
  • Asegúrate de estar en la carpeta donde está el archivo.  
  • Prueba comillas simples en PowerShell: `-c '.read p2_duckdb.sql'`.

- **Faltan librerías Python**  
  • Instala: `pip install duckdb pandas pyarrow` (activa el venv si lo usas).

- **Permisos en PowerShell (Windows)**  
  • Si la política restringe scripts, ejecuta como admin:  
    `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`  
    (Despué́s, cierra y abre PowerShell).

---

## 7) Desinstalación rápida

- **CLI instalado con script (Linux):** borra `~/.duckdb/duckdb` (y la línea del PATH en tu `~/.bashrc`).  
- **Homebrew (Linux/macOS):** `brew uninstall duckdb`.  
- **winget (Windows):** `winget uninstall DuckDB.cli`.  
- **Conda:** `conda remove duckdb-cli python-duckdb`.

---

Con esto, cada estudiante (Windows/macOS) y tú (Linux) podéis ejecutar el lab sin fricción. Si alguien se atasca, la **API de Python** es el *plan B* universal.
