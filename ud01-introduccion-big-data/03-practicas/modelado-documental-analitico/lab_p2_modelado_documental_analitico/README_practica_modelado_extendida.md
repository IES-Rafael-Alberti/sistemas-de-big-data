# Mini-práctica P2 — Modelado documental vs analítico (JSON ↔ Parquet + DuckDB)

📘 **Unidad:** UD1 · Parte 2 — *Almacenamiento y NoSQL*\
🕒 **Duración estimada:** 45–60 min (+20–30 min si haces la opción MongoDB)\
🎯 **Objetivo:** Resolver **las mismas preguntas de negocio** con dos enfoques: 1) **Analítico**: CSV → Parquet y consultas con **DuckDB**.\
2) **(Opcional)** **Documental**: documentos JSON (estilo MongoDB) y *pipelines* de agregación.

> La vía **obligatoria** es la **analítica con DuckDB**. **MongoDB** es **opcional** para comparar mentalidad **documental**.

------------------------------------------------------------------------

## 🧰 0) Preparación del entorno

Usaremos el entorno conda **sbd-lab** (común a los labs):

``` bash
conda env create -f environment.yml         # o conda env update -f environment.yml --prune
conda activate sbd-lab
python -c "import duckdb,pandas,pyarrow; print('OK', duckdb.__version__)"
```

> Si no usas conda: `pip install -r requirements.txt`

------------------------------------------------------------------------

## 📊 1) Generar datos (documental + aplanado)

Crea dos ficheros: **orders.ndjson** (documental, 1 doc por pedido con `items`) y **orders_flat.csv** (aplanado, 1 fila por línea de pedido).

``` bash
python genera_datos_p2.py
# Salida:
# data/orders.ndjson      # documental (NDJSON: una línea por documento)
# data/orders_flat.csv    # analítico (aplanado)
```

------------------------------------------------------------------------

## 🧠 2) Enfoque analítico (OBLIGATORIO): Parquet + DuckDB

### 2.1 Importar CSV, enriquecer y exportar a Parquet

Ejecútalo con CLI o desde Python:

**CLI (recomendado):**

``` bash
duckdb -c ".read p2_duckdb.sql"
```

**Python (si no tienes CLI):**

``` bash
python - << 'PY'
import duckdb, pathlib
sql = pathlib.Path('p2_duckdb.sql').read_text(encoding='utf-8')
con = duckdb.connect()
con.execute(sql)
print("SQL ejecutado (CSV→Parquet + consultas).")
PY
```

`p2_duckdb.sql` hace:

-   Importa `data/orders_flat.csv` → calcula `importe = qty*price` y `margen_u = price - cost`.

-   Exporta a **Parquet**: `data/orders_flat.parquet`.

-   Lanza **3 consultas de negocio**:

    -   **A)** Ventas por **canal** y **mes**.

    -   **B)** **Top‑5 SKUs** por **margen agregado**.

    -   **C)** Clientes con **\>5 pedidos** en el último mes.

### 2.2 Mini‑benchmark coste/tiempo

-   Compara **tamaño** `orders_flat.csv` vs `orders_flat.parquet`.\
-   Ejecuta la consulta **A)** dos veces y comenta si notas diferencia (caché/IO).\
-   Anota 2–3 conclusiones en el informe.

------------------------------------------------------------------------

## 🧾 3) Informe breve (OBLIGATORIO)

Crea `README_p2.md` (½–1 página) con:

1.  **Decisiones de modelado analítico** (campos calculados, por qué Parquet).\
2.  **Resultados consultas A–C** (copiar top de resultados o resumen).\
3.  **Benchmark tamaño/tiempo** (CSV vs Parquet) y conclusiones.\
4.  **Qué harías en producción** (por ejemplo: Parquet particionado por fecha y un motor BI).

Plantilla mínima:

```         
# P2 — Conclusiones
## Decisiones de modelado
...
## Consultas A–C (resumen)
...
## Tamaños y tiempos
CSV: __ MB | Parquet: __ MB | Observaciones: ...
## Conclusión
En producción usaría ... por ...
```

------------------------------------------------------------------------

## 🧩 4) Enfoque documental (OPCIONAL): MongoDB

> **Opcional** (para comparar mentalidad **documental**). No puntúa si no lo haces.

1.  **Importar NDJSON**

``` bash
docker run -d --name mongo -p 27017:27017 mongo:6
docker exec -i mongo mongoimport --db sbd --collection orders --type json --file /dev/stdin < data/orders.ndjson
docker exec -it mongo mongosh
```

2.  **Índices sugeridos**\
    `{customer_id:1, ts:1}`, `{canal:1, ts:1}`, `{items.sku:1}`

3.  **Agregaciones equivalentes (pseudocódigo MQL)**\

-   

    A)  `[$group por canal y mes(ts) sum(items.qty*items.price)]`\

-   

    B)  `$unwind items` → `$group por sku sum((price-cost)*qty)` → `$sort desc` → `$limit 5`\

-   

    C)  `[$match ts >= fecha_corte]` → `$group por customer_id count` → `>5`

4.  **Comparativa (2–3 frases)**\
    ¿Cuándo te parece mejor documental vs Parquet + DuckDB? ¿Qué tal la latencia y el esfuerzo?

------------------------------------------------------------------------

## 📦 5) Entregables

-   **OBLIGATORIOS**:
    -   `data/orders_flat.parquet` (generado por `p2_duckdb.sql`)\
    -   `README_p2.md` con conclusiones y benchmark\
    -   (Opcional) Capturas/outputs de las consultas
-   **OPCIONAL (MongoDB)**:
    -   Comandos ejecutados y resultados (pocas líneas)\
    -   2–3 frases de comparación

------------------------------------------------------------------------

## 🧮 6) Rúbrica rápida (/10)

| Criterio      | Descripción                           | Puntos |
|---------------|---------------------------------------|--------|
| **Analítico** | CSV→Parquet correcto + consultas A–C  | 4      |
| **Informe**   | Decisiones y conclusiones (benchmark) | 3      |
| **Claridad**  | Orden, reproducibilidad, comentarios  | 2      |
| **Opcional**  | Comparativa documental (si la haces)  | (+1)   |

------------------------------------------------------------------------

## 🧠 7) Mensaje didáctico

-   **Documental**: ideal para **recuperar entidades completas** rápido (p. ej., un pedido).\
-   **Analítico/columna**: ideal para **agregaciones masivas** y **BI** (barato y rápido con Parquet+DuckDB).\
-   En sistemas reales se **combinan**: documental para servir, Parquet para analítica batch/BI.
