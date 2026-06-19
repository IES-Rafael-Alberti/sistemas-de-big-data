# UD1 · Tarea guiada: EDA + Calidad + Export a Parquet

> **RA/CE**: RA1.b (extraer información), RA1.g (criterios de calidad),
> RA3.b (tecnologías eficientes), RA4.f (visualizar resultados).

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
