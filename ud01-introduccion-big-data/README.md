# UD1 — Introducción Big Data

## Estructura

| Sección | Uso | Nº archivos |
| ------- | --- | ----------: |
| `01-teoria/` | Fuentes editables y apuntes principales. | 33 |
| `02-ejemplos/` | Notebooks, scripts y ejemplos no evaluables. | 0 |
| `03-practicas/` | Guiones de laboratorio y prácticas de aula. | 37 |
| `04-evaluacion/` | Enunciados evaluables, rúbricas y documentos de entrega. | 3 |
| `05-recursos/` | Datasets, imágenes, plantillas, ZIPs docentes y dependencias. | 10 |
| `90-archivo/` | Derivados publicados, histórico y material no canónico. | 15 |
| `99-profesor/` | Notas internas, guías docentes y corrección reutilizable. | 1 |

## RA/CE cubiertos

| RA/CE | Material | Tipo |
|-------|----------|------|
| **RA1.a** | Cápsula Matemática Normativa + Cuestionario | Evaluable |
| **RA1.b** | Práctica EDA + Calidad (`UD1_03_Tarea_y_rubrica.md`) | Evaluable |
| **RA1.c-d** | Actividad Diseño Arquitectura Medallion | Evaluable |
| **RA1.f-g** | Actividad Diseño Arquitectura Medallion (justificación) | Evaluable |
| **RA3.a-d** | Actividad Diseño Arquitectura Medallion (gestión datos) | Evaluable |
| **RA4.a** | Lab MongoDB (datos no estructurados) | Práctica |
| **RA4.c** | Teoría arquitecturas (HDFS, lakehouse, clúster) | Teoría |
| **RA4.d** | Teoría arquitecturas (comparativa sistemas) | Teoría |

Ver `00-planificacion/matriz_ra_ce_materiales.md` para el detalle completo.

## Material nuevo — Base matemática aplicada

- `01-teoria/UD1-Parte0-BaseMatematica/UD1_P0_Estadistica_para_BigData.md` — base de estadística aplicada para limpieza, calidad, gráficos, correlación y colinealidad.
- `01-teoria/UD1-Parte0-BaseMatematica/UD1_P0_Capsula_Matematica_Normativa.md` — cobertura mínima aplicada de matemática discreta, lógica algorítmica y complejidad computacional según RA1/CE1.a.
- `04-evaluacion/UD1-Parte0-BaseMatematica/UD1_P0_Cuestionario_Estadistica_y_Capsula_Normativa.md` — cuestionario evaluable para esta base matemática.

## Material reformado — Arquitecturas Big Data modernas

- `01-teoria/UD1-Parte3/UD1-SGBD-Intro-P3.md` — teoría ampliada de arquitecturas Big Data: principios, batch/streaming, Lambda, Kappa, capas, lakehouse, Medallion, calidad, trazabilidad, Parquet, Spark y DuckDB.
- `04-evaluacion/UD1-Parte3/UD1_P3_Actividad_Diseno_Arquitectura_Medallion.md` — actividad evaluable de diseño de arquitectura para un caso turístico, con rúbrica y justificación de tecnologías viables en aula.
- `90-archivo/reforma-arquitecturas-2026/UD1-SGBD-Intro-P3_original_2026-06-17.md` — copia de seguridad del material original antes de la reforma.

La reforma usa referencias externas como contraste, no como copia: materiales IABD de Aitor Medrano para organización y conceptos de arquitectura, y documentación oficial de Databricks/Microsoft para Medallion. La parte de IA/HuggingFace queda fuera del núcleo de SBD arquitectura, salvo como posible conexión posterior con datasets, pipelines o proyectos integrados.
