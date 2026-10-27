---
title: "UD1 — EDA y calidad de datos"
author: "José Manuel Sánchez Álvarez"
institution: "IES Rafael Alberti"
course: "Sistemas de Big Data · 2025–2026"
revealjs-theme: simple
revealjs-transition: slide
---

## UD1 — EDA y calidad de datos

### Del fichero crudo al dato confiable

`pandas` · `Parquet` · `DuckDB`

---

## El problema de partida

Tenemos ventas con:

```text
fecha · sku · canal · unidades · precio · importe · tienda_id
```

- `precio` contiene nulos.
- `importe` no siempre coincide con unidades × precio.
- Un mismo SKU aparece con formatos diferentes.

> Antes de hacer BI, necesitamos saber si podemos confiar.

---

## EDA: conversar con el dataset

**Exploratory Data Analysis** responde tres preguntas:

1. ¿Qué contiene el dataset?
2. ¿Qué problemas y patrones aparecen?
3. ¿Qué decisiones de limpieza son razonables?

```text
radiografía → distribuciones → relaciones → decisiones
```

EDA no es una galería de gráficos: termina con preguntas más claras.

---

## Primera radiografía: perfilado

```python
df.info()
df.describe(numeric_only=True)
df.isna().mean().sort_values(ascending=False)
df.duplicated().mean()
```

Comprobamos:

- tamaño, tipos y rango temporal;
- nulos, duplicados y cardinalidad;
- valores frecuentes y valores sospechosos.

---

## Visualizar para decidir

| Pregunta | Vista útil |
|---|---|
| ¿Cómo se distribuye un número? | Histograma + boxplot |
| ¿Qué categorías dominan? | Barras ordenadas (top-k) |
| ¿Hay huecos o estacionalidad? | Serie temporal |
| ¿Cambian las ventas por canal? | Boxplot por categoría |

Evita gráficos ornamentales: cada vista debe apoyar una decisión.

---

## Calidad: cinco dimensiones medibles

| Dimensión | Pregunta |
|---|---|
| **Completitud** | ¿Faltan valores? |
| **Unicidad** | ¿La clave identifica una fila? |
| **Validez** | ¿Respeta dominio, rango o formato? |
| **Consistencia** | ¿Encajan varias columnas entre sí? |
| **Puntualidad** | ¿Llega cuando se necesita? |

Cada regla necesita métrica y umbral acordado.

---

## De la sospecha a la métrica

```python
completitud = 1 - df["precio"].isna().mean()
dominio = df["canal"].isin(["tienda", "web", "app"]).mean()
rango = df["unidades"].between(0, 500).mean()
```

```text
calidad = regla explícita + porcentaje de cumplimiento + objetivo
```

No basta con decir «hay nulos»: hay que medir cuántos y dónde.

---

## Reglas entre columnas

Una fila puede ser válida por separado y contradictoria en conjunto.

```python
ok = np.isclose(
    df["importe"], df["unidades"] * df["precio"],
    rtol=0.02, atol=0.01
)
consistencia = ok.mean()
```

Otros controles: fechas compatibles, categorías coherentes e integridad referencial.

---

## Outliers: detectar no es decidir

- **IQR:** `Q1 − 1.5·IQR` y `Q3 + 1.5·IQR`.
- **Z-score:** distancia respecto a la media.
- **MAD:** alternativa robusta ante colas pesadas.

Después preguntamos: ¿es error, caso real o señal de negocio?

**Corregir · capar · etiquetar**. Eliminar a ciegas introduce sesgo.

---

## Faltantes: una decisión con coste

| Estrategia | Cuándo tiene sentido |
|---|---|
| Eliminar | Pocos casos y no rompe claves |
| Imputar | Patrón razonable: mediana, moda o serie temporal |
| Etiquetar | No podemos asegurar el valor |

```python
df["precio_imputado"] = df["precio"].isna().astype(int)
df["precio"] = df["precio"].fillna(
    df.groupby("sku")["precio"].transform("median")
)
```

Documenta porcentaje afectado e impacto esperado.

---

## Limpiar, eliminar o etiquetar

```text
¿Error inequívoco y poco frecuente?  → eliminar
¿Patrón sistemático corregible?      → limpiar
¿Duda razonable o caso informativo?  → etiquetar
```

```python
df["sku"] = df["sku"].str.strip().str.upper()
df["flag_ajuste_importe"] = ~ok
```

Conservar una marca convierte una corrección en una decisión auditable.

---

## Un pipeline reproducible

```text
raw inmutable
     ↓ tipar y normalizar
     ↓ medir reglas
     ↓ limpiar / imputar / etiquetar
     ↓ medir de nuevo
curated versionado
```

- El script o cuaderno se puede ejecutar otra vez.
- El reporte registra qué cambió, cuánto y por qué.
- Nunca sobrescribimos el origen.

---

## Parquet: preparar para consultar

```python
df["anio"] = df["fecha"].dt.year
df["mes"] = df["fecha"].dt.month
```

```text
curated/parquet/anio=2025/mes=10/part.parquet
```

Parquet guarda por columnas, comprime y permite leer solo lo necesario.

Particionar ayuda cuando filtramos mucho por esas columnas; demasiadas carpetas pequeñas perjudican.

---

## DuckDB: SQL directo sobre Parquet

```sql
SELECT canal, SUM(importe) AS ventas
FROM 'curated/parquet/**/*.parquet'
GROUP BY canal
ORDER BY ventas DESC;
```

```sql
SELECT anio, mes, COUNT(*) AS filas
FROM 'curated/parquet/**/*.parquet'
GROUP BY anio, mes;
```

Sin servidor y sin copiar de nuevo los datos a CSV.

---

## Trazabilidad: publicar con evidencia

Junto al dataset guardamos:

- tabla **antes → después** de métricas;
- reglas, umbrales y decisiones;
- diccionario de datos;
- `quality_report.json`;
- ruta versionada: `curated/v=2025_10_06/`;
- benchmark de tamaño y tiempo de lectura.

> Un dato curado no solo funciona: se puede explicar y rehacer.

---

## Actividad final · de raw a decisión

Entrega un pequeño pipeline que:

1. Lea y declare el esquema.
2. Perfile el dataset y muestre dos visualizaciones.
3. Aplique 8–12 reglas de calidad priorizadas.
4. Decida qué eliminar, limpiar o etiquetar.
5. Exporte Parquet particionado y consulte con DuckDB.
6. Compare métricas antes/después y justifique los compromisos.

### Pregunta de cierre

**¿Qué decisión de negocio sería arriesgada si no pudiéramos demostrar la calidad?**
