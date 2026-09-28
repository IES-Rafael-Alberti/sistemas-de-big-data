# UD1 · Dossier completo
**Fecha:** 2025-10-01

---
# UD1 · Big Data 101 (Conceptos esenciales)  
**Fecha:** 2025-10-01

> **Problema de partida (realista):**  
Una cadena retail sufre **roturas de stock** y discrepancias en ventas porque recibe datos diarios desde tiendas en **CSV** y de e‑commerce en **JSON**. Hay **retrasos** (datos llegan con 48–72 h), **inconsistencias** en códigos SKU y **duplicados** cuando se reenvían ficheros. Dirección pide **indicadores fiables** y **tiempos de respuesta menores**.

## 1. Qué es Big Data y las 5V
- **Volumen, Velocidad, Variedad, Veracidad, Valor** (y **Variabilidad**).
- Riesgos típicos: *garbage in → garbage out*, sesgos, datos retrasados.

**Aplicado al problema:**  
- Volumen moderado (pero creciente).  
- Velocidad irregular (lotes diarios con picos).  
- Variedad (CSV y JSON).  
- Veracidad baja (duplicados, dominios incorrectos).  
- Valor depende de tiempos y calidad.

## 2. Procesos de datos: ETL, ELT y compañía
- **ETL**: extraer → transformar → cargar (útil cuando el destino es DW con reglas estrictas).
- **ELT**: extraer → cargar → transformar *in‑place* (útil con *lakes* y compute barato).  
- **Wrangling/Cleansing**: normalización, tipado, imputación, deduplicación.  
- **Enrichment**: añadir dimensiones (catálogo maestro SKU, calendario, divisas).  
- **Batch vs micro‑batch vs streaming** (en UD3 veremos micro‑batch con Spark).

**Decisión para el caso:**  
- Empezar con **ELT ligero en *data lake*** (Parquet particionado) + **curado** con reglas de calidad.  
- Catálogo maestro como **fuente de verdad** para códigos SKU.

## 3. Almacenamiento y formatos
- **Data Lake** (S3/HDFS/MinIO) vs **Warehouse** (OLAP) vs **Lakehouse** (tablas ACID sobre lake: Delta/Iceberg/Hudi).
- Formatos: **CSV** (simple), **JSON** (flexible), **Parquet** (columna, compresión, *predicate pushdown*).

**Decisión práctica:**  
- Aterrizar *raw* en el lake y **curar** a **Parquet** particionado por **fecha** y **canal**.  
- Consultar con **DuckDB** directamente sobre Parquet para exploración.

## 4. Coste ↔ Calidad ↔ Tiempo
- Compresión (snappy/zstd), particionado correcto, y tipado **reducen coste** y **mejoran tiempo**.
- **Métricas de calidad** (ver doc UD1_02) guían decisiones objetivas.

## 5. Checklist conceptual rápido (para usar en el resto del curso)
- [ ] ¿Cuál es el **objetivo de valor** del dato?  
- [ ] ¿Qué **V**s dominan este caso?  
- [ ] ¿ETL o ELT? ¿Dónde se transformará?  
- [ ] ¿Lake, Warehouse o Lakehouse? ¿Por qué?  
- [ ] ¿Formato y **particionado**?  
- [ ] ¿Qué **métricas de calidad** se seguirán?

---

## Actividad A (20’) — “Big Data en una página”
- Entrega un A4/MD con: 5V del caso retail, opción ETL/ELT, diagrama simple de lake → curado, y elección **Parquet vs CSV** con 2 razones.


---
# UD1 · EDA y Calidad de Datos (guía práctica)

> **Problema de partida:**  
El dataset retail contiene `fecha, sku, canal, unidades, precio, importe, tienda_id`. Hay **nulos en `precio`**, **`importe` incoherente** y **SKU** con formatos distintos. Se requiere un **dataset curado** en **Parquet** que soporte BI.

## 1. EDA (Exploratory Data Analysis)
1) **Perfilado**: tamaños, tipos, memoria, nulos, duplicados.  
2) **Distribuciones**: histogramas y boxplots (outliers).  
3) **Cruces**: dos relaciones relevantes (p. ej., `canal` × `unidades`).

```python
import pandas as pd
df = pd.read_csv("data.csv")
df.info()
df.describe(numeric_only=True)
nulos = df.isna().mean().sort_values(ascending=False)
dups_ratio = df.duplicated().mean()
```

## 2. Métricas de calidad (definición y cálculo rápido)
- **Completitud:** `1 - nulos(col)/N`
- **Unicidad (clave):** `nunique(id)/N`
- **Validez (dominio):** `mean(col.isin(conjunto))`
- **Validez (rango):** `mean(min <= col <= max)`
- **Conformidad (regex):** `mean(fullmatch(regex))`
- **Consistencia (entre columnas):** reglas lógicas (`fecha_inicio <= fecha_fin`, `importe ≈ unidades*precio`)
- **Puntualidad:** `mean(now - ts <= umbral)`

```python
import numpy as np, re

completitud = 1 - df['precio'].isna().mean()
unicidad = df['sku'].nunique() / len(df)
dom_ok = df['canal'].isin(['tienda','web','app']).mean()
rng_ok = ((df['unidades']>=0)&(df['unidades']<=500)).mean()
regex_ok = df['sku'].astype(str).str.fullmatch(r"[A-Z0-9\-]{3,16}").fillna(False).mean()
cons_ok = (np.isclose(df['importe'], df['unidades']*df['precio'], rtol=0.02, atol=0.01)).mean()
```

## 3. Tratamientos (eliminar, limpiar, etiquetar)
- **Eliminar**: duplicados exactos, registros corruptos evidentes.
- **Limpiar**: tipado, imputación (media/mediana/moda/ffill), normalización categorías.
- **Etiquetar**: `flag_anomalia=1` cuando haya duda razonable.

```python
# Tipos y coherencias
df['fecha'] = pd.to_datetime(df['fecha'], errors='coerce')
df['unidades'] = pd.to_numeric(df['unidades'], errors='coerce').astype('Int64')
df['precio'] = pd.to_numeric(df['precio'], errors='coerce')

# Imputación simple (ejemplo)
df['precio'] = df['precio'].fillna(df.groupby('sku')['precio'].transform('median'))

# Normalizar SKU
df['sku'] = df['sku'].str.strip().str.upper()

# Consistencia importe
df['importe_calc'] = df['unidades']*df['precio']
df['flag_ajuste_importe'] = ~np.isclose(df['importe'], df['importe_calc'], rtol=0.02, atol=0.01)
df.loc[df['flag_ajuste_importe'], 'importe'] = df.loc[df['flag_ajuste_importe'], 'importe_calc']
```

## 4. Exportación eficiente y consultas con DuckDB
**Parquet particionado** (por `anio/mes` y, si aplica, `canal`).

```python
import pyarrow as pa, pyarrow.parquet as pq, os

df['anio'] = df['fecha'].dt.year
df['mes'] = df['fecha'].dt.month

for (a,m), sub in df.groupby(['anio','mes']):
    path = f"data_curated/parquet/anio={a}/mes={m}"
    os.makedirs(path, exist_ok=True)
    pq.write_table(pa.Table.from_pandas(sub, preserve_index=False),
                   f"{path}/part.parquet", compression="snappy")
```

**DuckDB** sobre Parquet (sin copiar a CSV):

```sql
-- ejemplo consultas: guardar en duckdb_queries.sql
SELECT canal, SUM(importe) AS venta
FROM 'data_curated/parquet'
GROUP BY 1 ORDER BY 2 DESC;

SELECT anio, mes, COUNT(*) AS filas
FROM 'data_curated/parquet'
GROUP BY 1,2 ORDER BY 1,2;
```

## 5. Visualizaciones rápidas (por qué estas y no otras)
- **Histograma + boxplot** para ver forma y outliers (univariado numérico).  
- **Barras ordenadas** para categorías (frecuencias, “larguísima cola”).  
- **Boxplot por categoría** (`unidades` por `canal`) para comparar distribuciones.  
- **Serie temporal** (`importe` por día/semana) para estacionalidad.

## 6. Documentación de decisiones
- Tabla **antes/después** de métricas (usa la plantilla CSV/MD).  
- Razones para **particionado** y **compresión**.  
- Impacto en **tiempo de lectura** y **tamaño** (benchmark simple).

---

### Checklist de entrega (alumnado)
- [ ] Tabla de **métricas antes/después**.  
- [ ] Reglas de **dominio/rango/regex** aplicadas.  
- [ ] **Decisiones** marcadas (eliminar/limpiar/etiquetar).  
- [ ] Parquet legible desde **DuckDB**.  
- [ ] Benchmark con cifras + comentario breve.


---
# UD1 · Tarea guiada: EDA + Calidad + Export a Parquet

> **Problema:** Dirección necesita un dataset **fiable y eficiente** para BI semanal. Los datos actuales provocan **decisiones erróneas** y tiempos de consulta **lentos**.

## Objetivo
Entregar un **dataset curado** con **métricas de calidad** mejoradas, **Parquet particionado** y **consultas DuckDB** reproducibles.

## Pasos (orientativos)
1) **Perfilado inicial** y **métricas (ANTES)**.  
2) **Tratamientos** (limpiar/etiquetar; eliminar solo si procede).  
3) **Métricas (DESPUÉS)** + **Δ p.p.**  
4) **Visualizaciones** (3–5) con insight textual.  
5) **Export** a Parquet particionado (justifica particiones/compresión).  
6) **DuckDB**: 2–3 consultas de validación.  
7) **Benchmark** CSV vs Parquet (tiempo y tamaño).  
8) **Mini‑informe** (1–2 págs) con decisiones **calidad ↔ coste**.

## Entregables
- `EDA_<dataset>.ipynb`/`.py`  
- `/data_curated/parquet/` (particionado)  
- `duckdb_queries.sql`  
- `README.md` + **Matriz de métricas (CSV/MD)** + **Mini‑informe**

## Rúbrica (/10)
- (3) EDA completo y claro  
- (2) Limpieza/tipos bien justificados  
- (2) Parquet + particionado + compresión adecuados + benchmark  
- (2) Consultas DuckDB válidas y reproducibles  
- (1) Informe claro (impacto **calidad ↔ coste**)

## Nota sobre ética/RGPD
Si el dataset contiene **datos personales**, aplica **seudonimización** y evita publicar PII. Entrega `.env.example` si usas credenciales.


---
# UD1 · Recursos y referencias

## Libros (recomendados)
- **Designing Data-Intensive Applications** — Martin Kleppmann.  
- **Fundamentals of Data Engineering** — Joe Reis, Matt Housley.  
- **Agile Data Science 2.0** — Russell Jurney.

## Artículos y guías
- **Tidy Data** — Hadley Wickham.  
- **Great Expectations** (ideas de *data quality expectations*).

## Documentación oficial / herramientas
- **DuckDB** — consultas sobre Parquet sin ETL previo.  
- **Apache Parquet** — formato columna y compresión.  
- **Pandas / Polars** — manipulación tabular.  
- **PyArrow** — puente a Parquet/Arrow.

> Consejo: Prioriza fuentes **primarias** (docs oficiales) para sintaxis y límites, y fuentes **libros** para conceptos/arquitectura.


---
