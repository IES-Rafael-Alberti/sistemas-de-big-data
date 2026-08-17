# UD5 — Spark y MLlib

## Estructura

| Sección | Uso | Nº archivos |
| ------- | --- | ----------: |
| `01-teoria/` | Fuentes editables y apuntes principales. | 8 |
| `02-ejemplos/` | Notebooks, scripts y ejemplos no evaluables. | 8 |
| `03-practicas/` | Guiones de laboratorio y prácticas de aula. | 4 |
| `04-evaluacion/` | Enunciados evaluables, rúbricas y documentos de entrega. | 11 |
| `05-recursos/` | Datasets, imágenes, plantillas, ZIPs docentes y dependencias. | 1 |
| `90-archivo/` | Derivados publicados, histórico y material no canónico. | 10 |
| `99-profesor/` | Notas internas, guías docentes y corrección reutilizable. | 6 |

## Material nuevo — Guía scikit-learn vs Spark MLlib

- `01-teoria/UD5_Guia_ScikitLearn_vs_SparkMLlib.md` — guía de decisión con árbol, tabla comparativa (10 dimensiones), cuándo usar cada uno, análisis de coste/viabilidad y estrategia recomendada para SBD.

Cubre **RA1.f** y **RA1.g** en el contexto de ML.

## Secuencia didáctica recomendada

| Fase | Material | Evidencia esperada |
| ---- | -------- | ------------------ |
| 1. Problema y encaje | `01-teoria/UD5_01_intro_ml_bigdata.md` | Explicar por qué usar ML distribuido y cuándo no usarlo. |
| 2. Pipeline MLlib | `01-teoria/UD5_03_spark_mllib.md` | Identificar Transformer, Estimator y Pipeline en un flujo real. |
| 3. Features | `01-teoria/UD5_04_preparacion_features_spark.md` | Justificación de columnas, codificación y vector de features. |
| 4. Evaluación | `01-teoria/UD5_05_entrenamiento_y_evaluacion_modelos_spark.md` | Métrica elegida, baseline y lectura de errores. |
| 5. Ejemplos guiados | `02-ejemplos/01-EjemploRegresionPySpark.ipynb`, `02-ejemplos/02-EjemploClasificacionBinariaPySpark.ipynb` | Ejecución guiada antes de la práctica evaluable. |
| 6. Prácticas | `03-practicas/LAB1-*`, `LAB2-*`, `LAB3-*` | Informe con criterio, no solo código ejecutado. |

La ruta principal de SBD debe insistir en el criterio técnico: escalabilidad, preparación de variables, evaluación y coste. La interpretación de negocio puede quedar como conexión con Big Data Aplicado.

## RA/CE cubiertos

| RA/CE | Material | Tipo |
|-------|----------|------|
| **RA1.f** | Guía scikit-learn vs Spark MLlib (selección herramientas) | Teoría |
| **RA1.g** | Guía scikit-learn vs Spark MLlib (coste/viabilidad) | Teoría |
| **RA4.d** | Guía scikit-learn vs Spark MLlib (diferencias procesamiento) | Teoría |
| **RA4.e** | Lab1 Spark MLlib Pipeline + Lab2 (programación automática) | Evaluable |

> RA2.d cubierto por LAB1 (regresión con Spark MLlib) conectado al Lab6
> de UD4 (predicción en dashboard técnico). Ver `matriz_ra_ce_materiales.md`.

## Cuestionarios semanales (formato Moodle GIFT)

- `04-evaluacion/quiz-ud5.gift` — 6 preguntas en formato GIFT sobre Spark MLlib, pipelines, scikit-learn vs Spark y regresión distribuida.

Ver `00-planificacion/matriz_ra_ce_materiales.md` para el detalle completo.
