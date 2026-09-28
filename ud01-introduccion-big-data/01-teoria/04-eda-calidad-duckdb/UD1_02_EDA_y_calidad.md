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
