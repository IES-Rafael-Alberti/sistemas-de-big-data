# Tutorial FireDuck — Archivado

**FireDuck** era una librería Python que ofrecía una API estilo pandas sobre
DuckDB. El tutorial se ha archivado porque:

- **El paquete ya no está disponible en PyPI**: `pip install fireduck` falla.
- **No aporta valor curricular único**: DuckDB + SQL directo y pandas cubren
  el mismo espacio conceptual con herramientas estándar y mantenidas.
- **No se usa en industria**: proyecto abandonado/desaparecido.

## Alternativas actuales

| Necesidad | Herramienta actual en SBD |
|-----------|---------------------------|
| SQL analítico rápido sobre ficheros | DuckDB + SQL directo (tutorial `01-tutorial-duckdb.md`) |
| DataFrames Python | pandas (conocido de DAM/DAW) |
| Pipelines ELT programáticos | dlt (`pip install dlt`) |

## Nota sobre FireDucks (con 's')

Existe un proyecto **no relacionado** llamado [FireDucks](https://fireducks-dev.github.io/)
(de NEC), que es un **reemplazo de pandas con compilación JIT** (`pip install fireducks`,
`import fireducks.pandas as pd`). No es un wrapper de DuckDB. Está activo pero
solo funciona en Linux x86_64 y Mac ARM. No se usa en SBD; si interesa para
**Programación de IA**, valorar su disponibilidad en los entornos del alumnado.

## Histórico

| Fecha       | Cambio |
|-------------|--------|
| 2026-06-18 | Archivado por desaparición del paquete PyPI. |
