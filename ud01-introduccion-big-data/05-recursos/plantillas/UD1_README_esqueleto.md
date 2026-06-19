# README — UD1 EDA + Calidad + Parquet (Plantilla)

> **Dataset:** _título, versión, fuente, licencia_  
> **Autor/a:** _Nombre del alumno/a_ · **Fecha:** 2025-10-01

## 1. Descripción del dataset
- Origen y contexto (1–2 párrafos).
- Campos clave (tipos, unidades, valores esperados).
- Objetivo analítico (qué preguntas de negocio/tecnología aborda).

## 2. Perfilado inicial
- Filas/columnas, tipos, memoria.
- Nulos, duplicados, outliers (resumen).
- **Gráficos iniciales (3–5)**: histograma/boxplot/barras, con 1–2 frases por gráfico.

## 3. Métricas de calidad
- Inserta aquí la **tabla “Matriz de métricas” (antes/después)** o enlázala.
- Breve análisis: ¿qué dimensión está peor y por qué?

## 4. Reglas y tratamientos aplicados
- **Dominio:** valores permitidos.
- **Rango:** límites y unidades.
- **Regex/conformidad:** patrones.
- **Consistencias inter-campo:** reglas #1 y #2.
- **Decisiones:** _eliminar / limpiar / etiquetar_ (justifica cada una).

## 5. Resultados tras limpieza
- Tabla de métricas **después** y **Δ** (p.p.).
- Gráficos actualizados si cambian conclusiones.

## 6. Exportación eficiente a Parquet
- Esquema final (tipos), **particionado** elegido (ej. `anio/mes`), **compresión** (snappy/zstd) y por qué.
- Estructura de carpetas de salida (`/data_curated/parquet/...`).

## 7. DuckDB — consultas de validación
- Archivo: `duckdb_queries.sql` (2–3 consultas) **directo sobre Parquet**.
- Pega resultados clave (salida/screenshot) y comenta en 2–3 líneas.

## 8. Benchmark CSV vs Parquet
- **Tiempo de lectura** (s) y **tamaño** (MB) con script reproducible.
- Tabla breve y explicación (1–2 párrafos) del impacto **coste ↔ calidad**.

## 9. Reproducibilidad
- Versión de Python y librerías.
- Pasos para reproducir (comandos, rutas).

## 10. Consideraciones de seguridad/RGPD
- ¿Hay datos personales? ¿Se aplicó anonimización/seudonimización?
- Normas de buen uso y custodia del dataset.

## 11. Limitaciones y trabajo futuro
- Riesgos, sesgos, datos ausentes; mejoras posibles.

---

### Anexos (opcionales)
- Diccionario de datos.
- Capturas de dashboards/queries.
- Notebooks adicionales.
