# Matriz RA/CE → Materiales SBD 2026/2027

> Documento maestro que mapea cada Criterio de Evaluación (CE) con los
> materiales que lo cubren. Útil para programación de aula, auditoría
> curricular y detección de huecos.

---

## RA1 — Aplica técnicas de análisis de datos

| CE | Enunciado | Materiales SBD | UD |
|----|-----------|----------------|----|
| **a** | Matemática discreta, lógica algorítmica, complejidad computacional | Cápsula Matemática Normativa (`UD1_P0_Capsula_Matematica_Normativa.md`) | UD1 |
| | | Cuestionario Estadística y Normativa (`UD1_P0_Cuestionario_Estadistica_y_Capsula_Normativa.md`) | UD1 |
| **b** | Extraer información de grandes volúmenes | Práctica EDA + Calidad (`UD1_03_Tarea_y_rubrica.md`) | UD1 |
| | | Práctica Medallion (`UD2_Practica_Local_Medallion_Parquet_DuckDB_Spark.md`) | UD2 |
| | | Práctica integración dlt (Ruta A) | UD2 |
| **c** | Combinar fuentes y tipos de datos | Actividad Diseño Arquitectura Medallion (`UD1_P3_Actividad_Diseno_Arquitectura_Medallion.md`) | UD1 |
| | | Práctica Medallion (Bronze: CSV+JSONL → Parquet) | UD2 |
| | | Práctica integración dlt (join ventas+reservas+meteo+zonas) | UD2 |
| **d** | Construir datasets complejos y relacionarlos | Actividad Diseño Arquitectura Medallion | UD1 |
| | | Práctica Medallion (Silver → Gold) | UD2 |
| **e** | Objetivos, prioridades, secuenciación, organización del tiempo | Plantilla planificación técnica (`plantilla_planificacion_tecnica.md` — RA1.e) | Transversal |
| **f** | Seleccionar e integrar sistemas | Actividad Diseño Arquitectura Medallion (justificación herramientas) | UD1 |
| | | Matriz coste-calidad-viabilidad (`UD2_Actividad_Matriz_Coste_Calidad_Viabilidad.md`) | UD2 |
| | | Práctica herramientas reales: Airbyte GUI + AWS Academy (optativa) | UD2 |
| | | Benchmark pandas vs DuckDB vs Spark (`UD3_Lab_Benchmark_Pandas_DuckDB_Spark.md`) | UD3 |
| | | Guía scikit-learn vs Spark MLlib (`UD5_Guia_ScikitLearn_vs_SparkMLlib.md`) | UD5 |
| **g** | Criterios de coste y calidad | Matriz coste-calidad-viabilidad (plantilla + actividad UD2) | UD2 |
| | | Tarea UD2 (`UD2_05_Tarea_y_rubrica.md` — apartado calidad) | UD2 |
| | | Práctica herramientas reales: comparación dlt vs Airbyte vs AWS Academy | UD2 |
| | | Benchmark pandas vs DuckDB vs Spark (coste/rendimiento) | UD3 |
| | | Guía scikit-learn vs Spark MLlib (coste/viabilidad) | UD5 |
| | | Proyecto UD6 — memoria con análisis coste/viabilidad | UD6 |

---

## RA2 — Configura cuadros de mando

| CE | Enunciado | Materiales SBD | UD |
|----|-----------|----------------|----|
| **a** | Clasificar librerías de representación | Comparativa Metabase vs Superset vs PowerBI (`UD4_13_BI_Comparativa_Metabase_Superset_PowerBI.md`) | UD4 |
| **b** | Cruzar información objetivo vs naturaleza datos | Lab1 Metabase (crear preguntas desde datos) | UD4 |
| | | Lab2 Superset (dashboard analítico) | UD4 |
| | | Lab3 miniProyecto BI | UD4 |
| **c** | Cuadro de mando con técnicas sencillas | Lab1 Metabase (dashboard básico) | UD4 |
| | | Lab6 Dashboard Técnico Medallion (monitorización pipeline) | UD4 |
| **d** | Técnicas predictivas complejas | Lab6 Dashboard Técnico — sección 10 (predicción con media móvil + conexión a regresión Spark MLlib) | UD4 |
| | | LAB1-RegresionDistribuidaConSparkMLlib (Spark MLlib) | UD5 |
| **e** | Evaluar impacto del análisis | Lab3 miniProyecto BI (interpretación + conclusiones) | UD4 |
| | | Lab6 Dashboard Técnico (preguntas de reflexión) | UD4 |
| | | Cualquier práctica con sección de reflexión crítica | todas |

---

## RA3 — Gestiona y almacena datos

| CE | Enunciado | Materiales SBD | UD |
|----|-----------|----------------|----|
| **a** | Extraer y almacenar de diversas fuentes | Práctica integración dlt (CSV, JSONL) | UD2 |
| | | Práctica Medallion (raw CSV/JSONL → Bronze Parquet) | UD2 |
| | | Tarea UD2 (ingesta 2 fuentes + raw Parquet) | UD2 |
| | | Práctica herramientas reales Airbyte (optativa) | UD2 |
| | | Práctica AWS Academy serverless: S3 + Glue Crawler + Athena (optativa) | UD2 |
| **b** | Tecnologías eficientes para extraer valor | Práctica Medallion (Parquet + DuckDB) | UD2 |
| | | Práctica AWS Academy serverless (consultar datos en S3 con Athena) | UD2 |
| | | Benchmark pandas vs DuckDB vs Spark (eficiencia) | UD3 |
| | | Tutorial DuckDB | UD1 |
| **c** | Revolución digital: almacenar/procesar grandes cantidades | Cápsula Hadoop histórico vs Spark actual (`UD3_Capsula_Hadoop_historico_vs_Spark_actual.md`) | UD3 |
| | | Spark Labs (Lab1-4: procesamiento distribuido) | UD3 |
| | | Fundamentos teóricos arquitectura Lambda/Kappa/Medallion | UD1 |
| **d** | Sistemas eficientes, seguros, normativa | Práctica Medallion (Parquet particionado, idempotencia) | UD2 |
| | | Tarea UD2 (RGPD: `README_RGPD.md`) | UD2 |
| | | Práctica integración dlt (idempotencia, incremental) | UD2 |
| | | Checklist calidad/RGPD/seguridad (`plantilla_checklist_calidad_rgpd.md`) | Transversal |
| **e** | Habilidades científicas multidisciplinares | Implícito en todas las prácticas (método científico: hipótesis → experimento → conclusión) | todas |

---

## RA4 — Aplica herramientas de visualización

| CE | Enunciado | Materiales SBD | UD |
|----|-----------|----------------|----|
| **a** | Escenarios y tipologías de datos no estructurados | Laboratorio MongoDB (`lab_p2_modelado_documental_analitico`) | UD1 |
| | | Lab Logs JSON (`lab_logs_json/UD1_Lab_Logs_JSON.md`) | UD1 |
| | | Práctica Medallion (JSONL — datos semiestructurados) | UD2 |
| | | Teoría UD1-Parte2 (NoSQL, MongoDB, Cassandra) | UD1 |
| **b** | Implantar BI | Lab1 Metabase (primer contacto BI) | UD4 |
| | | Lab2 Superset (dashboard analítico) | UD4 |
| | | Lab3 miniProyecto BI (proyecto completo) | UD4 |
| | | Nota: BI de negocio profundo → BDA. SBD cubre el concepto. | |
| **c** | Almacenamiento distribuido y redundante | Teoría arquitecturas (HDFS, clúster, lakehouse) | UD1 |
| | | Cápsula Hadoop (HDFS, YARN, MapReduce) | UD3 |
| | | Spark Labs (Master/Worker, clúster) | UD3 |
| **d** | Diferencias entre aplicaciones de procesamiento | Benchmark pandas vs DuckDB vs Spark (comparativa motores) | UD3 |
| | | Guía scikit-learn vs Spark MLlib (dimensión técnica) | UD5 |
| | | Cápsula Hadoop vs Spark (evolución histórica) | UD3 |
| **e** | Programar y procesar automáticamente | Spark Labs (SparkLab1-4: scripts PySpark) | UD3 |
| | | Práctica Medallion con Spark (ampliación PySpark) | UD2 |
| | | Lab4 Airflow (orquestación programada) | UD4 |
| **f** | Visualizar datos para análisis y presentación | Lab1 Metabase (dashboard) | UD4 |
| | | Lab2 Superset (dashboard) | UD4 |
| | | Lab3 miniProyecto BI (presentación resultados) | UD4 |
| | | Lab6 Dashboard Técnico (visualización pipeline) | UD4 |
| | | Lab Grafana (monitorización) | UD3 |
| | | Lab Kibana (exploración visual) | UD3 |

---

## Resumen de cobertura

| RA | CEs totales | CEs cubiertos | Huecos |
|----|-------------|---------------|--------|
| RA1 | 7 (a-g) | 7 | ✅ Completo |
| RA2 | 5 (a-e) | 5 | ✅ Completo |
| RA3 | 5 (a-e) | 5 | ✅ Completo (CE3.e implícito) |
| RA4 | 6 (a-f) | 6 | ✅ Completo |

No quedan huecos curriculares detectados. RA2.d queda cubierto por el Lab6 de UD4
(predicción en dashboard técnico) y por LAB1 de UD5 (regresión con Spark MLlib).

---

## Notas

- **El proyecto UD6** es integrador y cubre prácticamente todos los RA/CE de
  forma aplicada: RA1.a-g, RA2.c-d-e, RA3.a-d, RA4.d-f. No se lista en cada
  fila individual para no duplicar; su cobertura está detallada en el guión
  del proyecto (`ud06-proyecto/guion_proyecto.md`).
- Los materiales marcados como "optativos" (Airbyte GUI, AWS serverless, FireDucks
  benchmark) no se incluyen en la matriz principal pero cubren los mismos RA/CE
  que sus equivalentes principales.
- Los labs de Grafana y Kibana en UD3 son material heredado. Cubren RA2 y RA4
  pero su ubicación en UD3 es cuestionable (son visualización, no procesamiento
  distribuido). Pendiente de revisión para 2027/2028.
- CE3.e (habilidades científicas) no tiene un material específico porque se trabaja
  de forma transversal en todas las prácticas.

---

## Histórico

| Fecha | Cambio |
|-------|--------|
| 2026-06-18 | Creación de la matriz maestra RA/CE → materiales. |
