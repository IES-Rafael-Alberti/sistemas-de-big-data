
---

# UD1 — Materiales teórico-prácticos

## 1) ¿Qué es EDA (Exploratory Data Analysis) y por qué?

* **Propósito:** entender la estructura, detectar problemas de **calidad** (nulos, duplicados, outliers), validar supuestos y generar hipótesis.
* **Salida mínima:**

  1. Perfilado (filas/columnas, tipos, memoria),
  2. Calidad (métricas abajo),
  3. 3–5 gráficos **simples** con hallazgos,
  4. Decisiones documentadas (qué se limpia y por qué),
  5. Export a **Parquet** y mini-benchmark CSV vs Parquet.

---

## 2) Métricas de calidad (definición + cálculo)

> Notación: N = nº total de filas; `col` = columna analizada.

* **Completitud** = 1 − (nulos(`col`) / N)
  *pandas:* `completitud = 1 - df['col'].isna().mean()`
  *DuckDB:* `SELECT 1 - AVG(col IS NULL)::DOUBLE AS completitud FROM t;`

* **Unicidad** = valores\_únicos(`col`) / N
  *pandas:* `unicidad = df['col'].nunique() / len(df)`
  *DuckDB:* `SELECT COUNT(DISTINCT col)::DOUBLE/COUNT(*) AS unicidad FROM t;`

* **Validez (dominio/rango)**

  * **Dominio (conjunto permitido):** p.ej. `estado ∈ {'ok','ko','hold'}`
    *pandas:* `validez = df['estado'].isin(['ok','ko','hold']).mean()`
  * **Rango (numérico/fecha):** p.ej. `0 ≤ precio ≤ 1000`
    *pandas:* `((df['precio']>=0)&(df['precio']<=1000)).mean()`

* **Consistencia entre columnas** (reglas inter-campo)
  Ej.: `provincia` compatible con `cp` (código postal), o `fecha_inicio ≤ fecha_fin`.
  *pandas:* `cons = (df['fecha_inicio'] <= df['fecha_fin']).mean()`

* **Conformidad (regex / formato)**
  Ej.: email, matrícula, patrón de SKU.
  *pandas:* `conformidad = df['email'].str.fullmatch(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').fillna(False).mean()`

* **Puntualidad** (si hay timestamp)
  % de filas con `now - ts ≤ umbral`.
  *pandas:* `punt = (pd.Timestamp.now(tz='UTC') - df['ts'] <= pd.Timedelta('2D')).mean()`

> **Tip:** reportar métricas como **proporciones** (0–1) y/o **%** con 2 decimales.

---

## 3) Tratamientos: eliminar, limpiar, etiquetar (y cuándo)

* **Eliminar**

  * Filas claramente corruptas (fechas imposibles, ids vacíos cuando son clave).
  * Duplicados exactos o claves duplicadas cuando debe haber unicidad.
  * *Registro en README:* motivo, nº de filas afectadas, impacto en métricas.

* **Limpiar**

  * **Imputar** nulos: media/mediana/moda, *forward/backward fill*, o reglas de negocio.
  * **Corregir tipos** (casting seguro), normalizar categorías (`"Si"→"sí"`).
  * **Recortar outliers**: por IQR (p95/p99) **solo si** justificas impacto.
  * **Regex** para sanitizar campos (quitar espacios, símbolos, validar formato).

* **Etiquetar**

  * Marcar casos dudosos (`flag_anomalia=1`) para no perder información.
  * Guardar una **lista de reglas** aplicadas con su justificación.

> **Criterio:** empieza por **etiquetar**, si el caso no es claro. Eliminar es última opción salvo corrupción evidente.

---

## 4) Dominios, rangos, regex y consistencias (catálogo rápido)

* **Dominio** (categórico):
  `color ∈ {'rojo','verde','azul'}` → `df['ok']=df['color'].isin({...})`
* **Rango** (numérico/fechas):
  `0≤edad≤120`, `fecha≤hoy`
* **Regex útiles**

  * Email (simple): `^[^@\s]+@[^@\s]+\.[^@\s]+$`
  * Teléfono ES (simple): `^\+?34?\s?\d{9}$`
  * CP ES: `^(0[1-9]|[1-4]\d|5[0-2])\d{3}$`
  * SKU alfanumérico 3–12: `^[A-Za-z0-9\-]{3,12}$`
* **Consistencias típicas**

  * `cp` ↔ `provincia` (tabla de referencia)
  * `fecha_inicio ≤ fecha_fin`
  * `cantidad > 0` si `estado='vendido'`
  * `precio_total ≈ precio_unitario * cantidad` (tolerancia del 1–2%)

---

## 5) Visualizaciones rápidas (qué y por qué)

* **Numérica (una variable):** histograma + boxplot → forma, outliers.
* **Categórica (una):** barras ordenadas por frecuencia → dominancias y rarezas.
* **Numérica vs categórica:** boxplot por categoría → diferencias de distribución.
* **Numérica vs numérica:** scatter + línea de tendencia (si aplica) → relación.
* **Temporal:** línea/área con *resample* (día/semana) → estacionalidad, picos.

> **Principio:** gráficas **simples**, etiquetas claras, títulos que expliquen **insight**, no el “qué”:
> “Ventas ↑ en fines de semana (+18%)” mejor que “Ventas por día”.

---

## 6) Mini-recetario (pandas / DuckDB / polars)

**pandas (ejemplos breves)**

```python
# Perfilado base
df.info(); df.describe()

# Duplicados
dups = df.duplicated().mean()

# Outliers por IQR
q1, q3 = df['x'].quantile([0.25, 0.75])
iqr = q3 - q1
mask_out = (df['x'] < q1 - 1.5*iqr) | (df['x'] > q3 + 1.5*iqr)

# Métricas
completitud = 1 - df['col'].isna().mean()
unicidad = df['id'].nunique() / len(df)

# Regex
email_ok = df['email'].str.fullmatch(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').fillna(False).mean()

# Export a Parquet (particionado por año/mes)
df['fecha'] = pd.to_datetime(df['fecha'])
df['anio'], df['mes'] = df['fecha'].dt.year, df['fecha'].dt.month
import pyarrow as pa, pyarrow.parquet as pq
import os
for (a,m), sub in df.groupby(['anio','mes']):
    path = f"data_curated/parquet/anio={a}/mes={m}"
    os.makedirs(path, exist_ok=True)
    pq.write_table(pa.Table.from_pandas(sub), f"{path}/part.parquet", compression="snappy")
```

**DuckDB (directo sobre Parquet)**

```sql
-- Consultas sin “importar” datos
SELECT anio, mes, COUNT(*) FROM 'data_curated/parquet' GROUP BY 1,2 ORDER BY 1,2;
SELECT categoria, AVG(precio) FROM 'data_curated/parquet' GROUP BY 1;
```

**polars (alternativa rápida)**

```python
import polars as pl
df = pl.read_csv("data.csv")
comp = 1 - df["col"].is_null().mean()
uni = df["id"].n_unique() / df.height
```

**Benchmark simple tiempo/tamaño**

```python
import time, os, pandas as pd, pyarrow.parquet as pq
t0=time.time(); df=pd.read_csv("data.csv"); t_csv=time.time()-t0
t0=time.time(); df2=pd.read_parquet("data.parquet"); t_parq=time.time()-t0
size_csv=os.path.getsize("data.csv"); size_parq=os.path.getsize("data.parquet")
print({"t_csv":t_csv,"t_parquet":t_parq,"size_csv":size_csv,"size_parquet":size_parq})
```

---

## 7) Plantilla de tarea (alumnado)

**Título:** EDA + Calidad + Export eficiente (Parquet)
**Objetivo:** realizar un EDA riguroso, medir y mejorar la **calidad** del dataset, documentar decisiones y exportar un *dataset curado* en **Parquet** (particionado).

**Datos:** uno a elegir (Titánico / AEMET / Retail u otro aprobado).

**Entregables:**

* `EDA_<dataset>.ipynb` o `.py` (con celdas/etapas limpias y títulos).
* Carpeta `/data_curated/parquet/` **particionada** (p.ej. `anio=/mes=`).
* `duckdb_queries.sql` (2–3 consultas sobre Parquet).
* `README.md` con:

  * **Métricas** (tabla): completitud, unicidad, validez, consistencia, conformidad.
  * **Decisiones** (eliminar/limpiar/etiquetar) y su **impacto** en métricas.
  * **Benchmark** CSV vs Parquet (tiempo y tamaño).
* Mini-informe (1–2 páginas) con hallazgos e implicaciones **coste↔calidad**.

**Pasos orientativos:**

1. **Perfilado** (tipos, nulos, duplicados, memoria).
2. **Métricas** iniciales (tabla).
3. **Tratamientos** (limpiar/etiquetar; eliminar solo si justificado).
4. **Métricas** tras limpieza (comparativa antes/después).
5. **Visualizaciones** (3–5) con títulos que expliquen hallazgos.
6. **Export** a Parquet **particionado** (justifica particiones y compresión).
7. **DuckDB**: 2–3 consultas de validación.
8. **Benchmark** tiempos/tamaños.

**Rúbrica rápida (/10):**

* (3) EDA completo y claro.
* (2) Limpieza y tipos **bien justificados**.
* (2) Parquet particionado + compresión correcta + benchmark.
* (2) Consultas DuckDB válidas y reproducibles.
* (1) Informe claro (impacto en **calidad y coste**).

**Checklist de entrega (auto-revisión):**

* [ ] Tabla de **métricas antes/después**.
* [ ] Reglas de **dominio/rango/regex** aplicadas.
* [ ] Decisiones **marcadas** (eliminar/limpiar/etiquetar) y cuantificadas.
* [ ] Parquet legible desde **DuckDB** sin convertir a CSV.
* [ ] Benchmark con **cifras** y breve interpretación.

---

## 8) Cápsula RA1.a (S2) — lógica aplicada a joins (10–15 min)

* Predicados: `IN`, `NOT IN`, `AND/OR`, implicación.
* **Actividad relámpago:** diseñar 2 reglas de **dominio** y 1 de **consistencia** para el dataset elegido (en parejas); medir su **validez** (% true).
* Discusión: ¿eliminamos, limpiamos o etiquetamos?

---

## 9) Bibliografía / ampliación

* Tidy Data (Hadley Wickham) — principios de organización de datos.
* Great Expectations (concepto de *expectations* para calidad).
* DuckDB docs (consultas sobre Parquet).
* Artículos sobre **data quality dimensions** (incluyen completitud, unicidad, validez, consistencia, puntualidad).

---

