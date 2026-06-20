# Planificación semanal — Sistemas de Big Data (90 h, 3 h/semana = 30 semanas)

> Calendario orientativo para el curso 2026/2027. Ajustable durante el curso según
> necesidades del grupo, festivos o imprevistos técnicos.

---

## Leyenda

| Columna | Significado |
|---------|-------------|
| **Semana** | Nº de semana lectiva (1‑30) |
| **Unidad** | Módulo temático (UD1‑UD6) |
| **Actividad principal** | Contenido que se imparte esa semana |
| **Tipo** | T = Teoría, L = Laboratorio/práctica, Q = Cuestionario/quiz, E = Evaluación, P = Proyecto |
| **Horas** | Horas lectivas dedicadas |
| **Trabajo en grupo** | Individual, Parejas, Equipo (2‑4), Grupo (4‑5) |
| **RA/CE** | Resultados de Aprendizaje / Criterios de Evaluación cubiertos |
| **Entregable / Quiz** | Archivo de evaluación asociado |

---

## Calendario

| Sem | Unidad | Actividad principal | Tipo | Horas | Agrupamiento | RA/CE | Entregable / Quiz |
|-----|--------|---------------------|------|------:|--------------|-------|-------------------|
| 1 | **UD1** | Introducción Big Data: concepto 4V, características | T | 2 | Individual | RA1.a | — |
| 2 | **UD1** | Base matemática + cápsula normativa | T | 2 | Individual | RA1.a | `quiz-ud1.gift` (q1‑2) |
| 3 | **UD1** | EDA y calidad de datos con DuckDB | L | 3 | Individual | RA1.b, RA3.b | `UD1_03_Tarea_y_rubrica.md` |
| 4 | **UD1** | Modelado documental con MongoDB | L | 3 | Parejas | RA4.a | Lab MongoDB |
| 5 | **UD1** | Arquitecturas Big Data (Lambda, Kappa, Medallion) | T | 2 | Individual | RA1.c‑d, RA3.a‑d | `quiz-ud1.gift` (q3‑5) |
| 6 | **UD1** | Actividad diseño arquitectura Medallion | E | 2 | Parejas | RA1.f‑g, RA3.a‑d | `UD1_P3_Actividad_Diseno_Arquitectura_Medallion.md` |
| 7 | **UD2** | Almacenamiento: HDFS, Parquet, sistemas de ficheros distribuidos | T | 2 | Individual | RA3.a, RA4.c | `quiz-ud2.gift` (q1‑2) |
| 8 | **UD2** | Tarea HDFS: Parquet en HDFS con EMR y PySpark | L | 3 | **Parejas** | RA3.a, RA4.c | Entrega TareaHDFS |
| 9 | **UD2** | Bases de datos NoSQL: MongoDB, Cassandra | T | 2 | Individual | RA4.a | `quiz-ud2.gift` (q3‑4) |
| 10 | **UD2** | Tarea NoSQL (AWS DynamoDB) | L | 3 | **Parejas** | RA4.a | Entrega DynamoDB |
| 11 | **UD2** | Pipeline de datos: integración con dlt | L | 3 | **Parejas** | RA1.c, RA3.a | `05-Integracion_y_calidad-tarea.md` |
| 12 | **UD2** | Calidad de datos, idempotencia y RGPD/anonimización | L | 3 | **Parejas** | RA1.b, RA3.d | Tarea RGPD + `quiz-ud2.gift` (q5‑6) |
| 13 | **UD2** | Matriz coste‑calidad‑viabilidad | E | 2 | Parejas | RA1.f‑g | `UD2_Actividad_Matriz_Coste_Calidad_Viabilidad.md` |
| 14 | **UD2** | Práctica Medallion local (Parquet + DuckDB + Spark) | L | 3 | **Parejas** | RA1.d, RA3.b, RA4.a | `UD2_Practica_Local_Medallion_Parquet_DuckDB_Spark.md` |
| 15 | **UD2** | Cierre UD2 + cuestionario | Q | 1 | Individual | — | `quiz-ud2.gift` (q7‑8) |
| 16 | **UD3** | Hadoop histórico vs Spark actual (cápsula teórica) | T | 1 | Individual | RA3.c | `quiz-ud3.gift` (q1‑2) |
| 17 | **UD3** | SparkLab1: primer contacto con Spark (DataFrames) | L | 3 | **Parejas** | RA4.e | Entrega SparkLab1 |
| 18 | **UD3** | SparkLab2: Spark en clúster Master/Worker | L | 3 | **Parejas** | RA4.c, RA4.e | Entrega SparkLab2 |
| 19 | **UD3** | SparkLab3: transformaciones y agregaciones avanzadas | L | 3 | **Parejas** | RA4.e | Entrega SparkLab3 |
| 20 | **UD3** | SparkLab4: Zeppelin notebooks interactivos | L | 3 | **Parejas** | RA4.e | Entrega SparkLab4 |
| 21 | **UD3** | Benchmark pandas vs DuckDB vs Spark | L | 3 | **Equipo (3)** | RA1.f‑g, RA3.b, RA4.d | Entrega benchmark |
| 22 | **UD3** | SparkLab5: Streaming con Redpanda + Spark Structured Streaming | L | 3 | **Parejas** | RA3.c, RA4.e | Ejercicios streaming |
| 23 | **UD3** | Kibana Labs: visualización y dashboards | L | 3 | **Parejas** | RA4.f | Entregas KibanaLab |
| 24 | **UD3** | Grafana + Prometheus: monitorización | L | 3 | **Parejas** | RA2.c, RA4.f | Entrega Grafana |
| 25 | **UD3** | Cierre UD3 + cuestionario | Q | 1 | Individual | — | `quiz-ud3.gift` (q3‑10) |
| 26 | **UD4** | BI tools: Metabase vs Superset vs PowerBI | T+L | 3 | Individual | RA2.a | `quiz-ud4.gift` (q1‑2) |
| 27 | **UD4** | Lab Metabase: dashboard básico | L | 3 | **Parejas** | RA2.b‑c, RA4.b, RA4.f | Entrega Metabase |
| 28 | **UD4** | Lab Superset: visualización avanzada | L | 3 | **Parejas** | RA2.b, RA4.b, RA4.f | Entrega Superset |
| 29 | **UD4** | Mini‑proyecto BI: cuadro de mando integrado | E | 3 | **Equipo (3)** | RA2.b‑c‑e, RA4.b‑f | `UD4_MiniProyecto_Entrega.md` |
| 30 | **UD4** | Dashboard técnico Medallion + orquestación (Airflow) | L | 3 | **Parejas** | RA4.e‑f, RA2.c‑d | `UD4_Lab6_Dashboard_Tecnico_Pipeline_Medallion.md` |
| 31 | **UD4** | Cierre UD4 + cuestionario | Q | 1 | Individual | — | `quiz-ud4.gift` (q3‑6) |
| 32 | **UD5** | Spark MLlib: pipelines de ML distribuido | T+L | 3 | Individual | RA1.f‑g, RA4.d‑e | `quiz-ud5.gift` (q1‑3) |
| 33 | **UD5** | Lab1: regresión distribuida con Spark MLlib | L | 3 | **Parejas** | RA4.e | Entrega LAB1 |
| 34 | **UD5** | Lab2: regresión con dataset real | L | 3 | **Parejas** | RA4.e | Entrega LAB2 |
| 35 | **UD5** | Cierre UD5 + guía scikit‑learn vs Spark MLlib | Q | 1 | Individual | RA1.f‑g | `quiz-ud5.gift` (q4‑6) |
| 36 | **UD6** | Presentación del proyecto integrador (SBD + BDA + PIA) | T | 2 | **Grupo (4‑5)** | RA1‑RA4 | `guion_proyecto.md` |
| 37‑38 | **UD6** | Fase 1: definición del proyecto, fuentes, arquitectura | P | 6 | **Grupo (4‑5)** | RA1.c‑d‑f‑g | Propuesta inicial |
| 39‑40 | **UD6** | Fase 2: ingesta, almacenamiento, calidad | P | 6 | **Grupo (4‑5)** | RA3.a‑b‑d, RA4.a | Pipeline Medallion |
| 41‑42 | **UD6** | Fase 3: procesamiento distribuido | P | 6 | **Grupo (4‑5)** | RA4.c‑d‑e | Código PySpark |
| 43‑44 | **UD6** | Fase 4: dashboard técnico y visualización | P | 6 | **Grupo (4‑5)** | RA2.b‑c, RA4.f | Dashboard |
| 45‑46 | **UD6** | Fase 5: memoria, defensa y cierre | P | 4 | **Grupo (4‑5)** | RA2.e | Memoria + `quiz-ud6.gift` |
| 47 | — | **Cuestionario final global** | Q | 2 | Individual | RA1‑RA4 | Repaso general |

---

## Resumen de horas por unidad

| Unidad | Horas | % | Teoría | Laboratorio | Evaluación | Proyecto |
|--------|------:|--:|------:|------------:|-----------:|---------:|
| **UD1** — Introducción Big Data | 14 | 15.6% | 6 | 6 | 2 | 0 |
| **UD2** — Almacenamiento e ingesta | 19 | 21.1% | 4 | 12 | 3 | 0 |
| **UD3** — Procesamiento distribuido | 25 | 27.8% | 1 | 22 | 2 | 0 |
| **UD4** — BI y orquestación | 16 | 17.8% | 3 | 9 | 4 | 0 |
| **UD5** — Spark MLlib | 10 | 11.1% | 4 | 6 | 0 | 0 |
| **UD6** — Proyecto integrador | 30 | 33.3% | 2 | 0 | 0 | 28 |
| **Total** | **114**† | — | 20 | 55 | 11 | 28 |

† **Nota**: El total supera 90 h porque incluye horas de proyecto (UD6) que se
solapan con otros módulos (BDA, PIA). Ajustar según la coordinación docente.

---

## Distribución semanal (3 h → 90 h en 30 semanas)

| Bloque | Semanas | Horas |
|--------|--------:|------:|
| UD1 | 1‑6 | 14 |
| UD2 | 7‑15 | 19 |
| UD3 | 16‑25 | 25 |
| UD4 | 26‑31 | 16 |
| UD5 | 32‑35 | 10 |
| UD6 | 36‑47 | 30 |
| **Totales** | **47** | **114** |

Para cuadrar 90 h efectivas, la UD6 (proyecto integrador) computa al 50% (≈15 h
en SBD + 15 h en BDA + PIA), o se recortan actividades optativas de UD2/UD3.

---

## Tareas susceptibles de trabajo en pareja o grupo

| Tarea/Lab | Unidad | Agrupamiento | Justificación |
|-----------|--------|-------------|---------------|
| Lab MongoDB | UD1 | Parejas | Configurar MongoDB + insertar datos requiere división de roles |
| Actividad Medallion | UD1 | Parejas | Discutir y justificar decisiones de arquitectura |
| Tarea HDFS | UD2 | **Parejas** | Configurar EMR + script PySpark |
| Tarea NoSQL DynamoDB | UD2 | **Parejas** | AWS cuenta + código de acceso |
| Tarea dlt | UD2 | **Parejas** | Comparar 4 fuentes entre dos personas |
| Práctica Medallion local | UD2 | **Parejas** | Generar datos + pipeline bronze‑silver‑gold |
| Tarea RGPD | UD2 | **Parejas** | Anonimizar + redactar informe |
| SparkLab1‑4 | UD3 | **Parejas** | Cada persona un notebook, luego comparten |
| Benchmark | UD3 | **Equipo (3)** | Tres motores, tres personas |
| SparkLab5 Streaming | UD3 | **Parejas** | Productor + consumidor, dos roles |
| Kibana Labs | UD3 | **Parejas** | Diseñar dashboards complementarios |
| Grafana | UD3 | **Parejas** | Configurar Prometheus + dashboard |
| Lab Metabase | UD4 | **Parejas** | Modelar datos + crear dashboard |
| Lab Superset | UD4 | **Parejas** | Conexión a fuente + visualizaciones |
| Mini‑proyecto BI | UD4 | **Equipo (3)** | Cada miembro un dashboard distinto |
| Dashboard técnico | UD4 | **Parejas** | Pipeline + metadatos + dashboard |
| Lab MLlib | UD5 | **Parejas** | Pipeline: preparación + modelo + evaluación |
| **Proyecto integrador** | **UD6** | **Grupo (4‑5)** | Todo el grupo: arquitectura, ingesta, procesado, BI |
| Cuestionarios (quiz) | UD1‑UD6 | Individual | Evaluación individual de conceptos |
