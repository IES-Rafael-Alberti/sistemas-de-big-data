# UD1 — Introducción Big Data

## Estructura

| Sección | Uso | Nº archivos |
| ------- | --- | ----------: |
| `01-teoria/` | Fuentes editables organizadas por tema. | — |
| `02-ejemplos/` | Notebooks, scripts y ejemplos no evaluables. | 2 |
| `03-practicas/` | Guiones de laboratorio y prácticas de aula. | — |
| `04-evaluacion/` | Enunciados evaluables, rúbricas y documentos de entrega. | — |
| `05-recursos/` | Datasets, imágenes, plantillas, ZIPs docentes y dependencias. | 13 |
| `90-archivo/` | Derivados publicados, histórico y material no canónico. | 15 |
| `99-profesor/` | Notas internas, guías docentes y corrección reutilizable. | 2 |

## RA/CE cubiertos

| RA/CE | Material | Tipo |
|-------|----------|------|
| **RA1.a** | Cápsula Matemática Normativa + Cuestionario | Evaluable |
| **RA1.b** | Práctica EDA + Calidad (`UD1_03_Tarea_y_rubrica.md`) | Evaluable |
| **RA1.c-d** | Actividad Diseño Arquitectura Medallion | Evaluable |
| **RA1.f-g** | Actividad Diseño Arquitectura Medallion (justificación) | Evaluable |
| **RA3.a-d** | Actividad Diseño Arquitectura Medallion (gestión datos) | Evaluable |
| **RA4.a** | Tarea de modelado documental y analítico (JSON frente a Parquet/DuckDB) | Evaluable; MongoDB es ampliación opcional |
| **RA4.c** | Teoría arquitecturas (HDFS, lakehouse, clúster) | Teoría |
| **RA4.d** | Teoría arquitecturas (comparativa sistemas) | Teoría |

## Mapa de teoría

| Carpeta | Contenido |
|---|---|
| `01-teoria/00-estadistica-y-base-matematica/` | Estadística aplicada y cápsula matemática normativa. |
| `01-teoria/01-fundamentos-big-data/` | Guía breve Big Data 101 y capítulo ampliado. |
| `01-teoria/02-almacenamiento-y-nosql/` | Modelos de almacenamiento, NoSQL, MongoDB y DuckDB. |
| `01-teoria/03-arquitecturas-big-data/` | Batch, streaming, Lambda, Kappa, lakehouse y Medallion. |
| `01-teoria/04-eda-calidad-duckdb/` | Guía práctica y capítulo ampliado de EDA/calidad, DuckDB y plantillas. |
| `01-teoria/05-ingesta-de-datos/` | Fundamentos de ingesta como puente hacia UD2. |

`90-archivo/compilaciones-obsoletas/UD1_Dossier_Completo_2025-10-01.md` es una
compilación fechada en 2025 que repetía Big Data 101, EDA/calidad, una actividad
y recursos. Se conserva como histórico; las fuentes vigentes son los documentos
temáticos anteriores.

Ver `00-planificacion/matriz_ra_ce_materiales.md` para el detalle completo.

## Material nuevo — Base matemática aplicada

- `01-teoria/00-estadistica-y-base-matematica/UD1_P0_Estadistica_para_BigData.md` — base de estadística aplicada para limpieza, calidad, gráficos, correlación y colinealidad.
- `01-teoria/00-estadistica-y-base-matematica/UD1_P0_Capsula_Matematica_Normativa.md` — cobertura mínima aplicada de matemática discreta, lógica algorítmica y complejidad computacional según RA1/CE1.a.
- `04-evaluacion/base-matematica/UD1_P0_Cuestionario_Estadistica_y_Capsula_Normativa.md` — cuestionario evaluable para esta base matemática.

## Material reformado — Arquitecturas Big Data modernas

- `01-teoria/03-arquitecturas-big-data/UD1_Arquitecturas_Big_Data.md` — teoría ampliada de arquitecturas Big Data: principios, batch/streaming, arquitectura orientada a eventos, Lambda, Kappa, capas, lakehouse, Medallion, data products/Data Mesh como modelo organizativo, calidad, trazabilidad, Parquet, Spark y DuckDB.
- `04-evaluacion/arquitectura-medallion/UD1_P3_Actividad_Diseno_Arquitectura_Medallion.md` — actividad evaluable de diseño de arquitectura para un caso turístico, con rúbrica y justificación de tecnologías viables en aula.
- `90-archivo/reforma-arquitecturas-2026/UD1-SGBD-Intro-P3_original_2026-06-17.md` — copia de seguridad del material original antes de la reforma.

La reforma usa referencias externas como contraste, no como copia: materiales IABD de Aitor Medrano para organización y conceptos de arquitectura, y documentación oficial de Databricks/Microsoft para Medallion. La parte de IA/HuggingFace queda fuera del núcleo de SBD arquitectura, salvo como posible conexión posterior con datasets, pipelines o proyectos integrados.

## Cuestionarios semanales (formato Moodle GIFT)

- `04-evaluacion/quiz-ud1.gift` — 8 preguntas en formato GIFT sobre Big Data, EDA, DuckDB, arquitecturas, MongoDB, batch/streaming y coste/calidad/viabilidad.
