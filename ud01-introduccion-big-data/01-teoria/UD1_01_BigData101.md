# UD1 · Big Data 101 (Conceptos esenciales)  
**Fecha:** 2025-10-01

> **Problema de partida (realista):**  
Una cadena minorista sufre **roturas de stock** y discrepancias en ventas porque recibe datos diarios desde tiendas en **CSV** y de e‑commerce en **JSON**. Hay **retrasos** (datos llegan con 48–72 h), **inconsistencias** en códigos SKU y **duplicados** cuando se reenvían ficheros. Dirección pide **indicadores fiables** y **tiempos de respuesta menores**.

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
