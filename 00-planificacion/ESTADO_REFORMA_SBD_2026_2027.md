# Estado de la reforma — Sistemas de Big Data 2026/2027

Documento de traspaso para continuar la reorganización del módulo en otro equipo.

## Ruta de trabajo

La copia editable del curso nuevo está en:

```text
/home/jmsa/IESRafaelAlberti/RafaelAlberti25_26/Modulos/SBD/SBD_2026_2027_reorganizado
```

No se debe trabajar sobre el curso actual en `unidades/`. La filosofía de esta fase ha sido **copiar, reorganizar y mejorar sin tocar lo de este año**.

## Criterio curricular acordado

### Sistemas de Big Data

SBD debe centrarse en:

- arquitectura de sistemas de datos;
- ingesta e integración;
- almacenamiento y formatos;
- calidad y trazabilidad;
- procesamiento distribuido;
- selección razonada de herramientas;
- coste, viabilidad y limitaciones técnicas;
- visualización técnica mínima.

### Big Data Aplicado

Big Data Aplicado debe absorber mejor:

- explotación aplicada de resultados;
- BI orientada a negocio;
- dashboards de solución final;
- monitorización/observabilidad profunda;
- cloud aplicado extremo a extremo;
- producto, cliente, decisión y caso de uso completo.

### IA

No se debe meter IA como contenido propio de SBD.

La IA pertenece a otros módulos:

- Programación de la IA;
- Sistemas de Aprendizaje Automático;
- Modelos de la IA.

En SBD sólo puede aparecer como integración posterior en un proyecto Big Data: preparación de datasets, pipelines, almacenamiento, calidad y trazabilidad para que otro módulo consuma esos datos.

## Trabajo ya realizado

### 1. Inventario y reorganización base

Se hizo inventario del material y se creó una copia reorganizada para 2026/2027.

Archivos relevantes:

- `README.md`
- `PLAN_REORGANIZACION.md`
- `INFORME_COPIA.md`
- `00-planificacion/INFORME_REORGANIZACION_FINA.md`
- `00-planificacion/inventario_material_sbd.md` si existe en la copia o en la carpeta original de unidades.

También se movieron RA/CE a:

- `00-planificacion/SistemasDeBIG_DATA-RAs_CE.md`
- `00-planificacion/BigDataAplicado-RAs_CE.md`

### 2. Herramientas y alineación curricular

Se creó inventario de herramientas usadas y matriz de alineación SBD/BDA.

Archivos relevantes:

- `00-planificacion/herramientas_usadas_curso.md`
- `00-planificacion/matriz_alineacion_curricular_sbd_bigdata_aplicado.md`
- `00-planificacion/propuesta_mejora_contenidos_sbd.md`

Decisión importante: no borrar ni mover contenidos automáticamente; primero marcar qué encaja mejor en SBD y qué parece más propio de Big Data Aplicado.

### 3. Base matemática aplicada en UD1

Se creó una base matemática más útil para SBD, priorizando estadística aplicada sobre matemática discreta extensa.

Archivos creados:

- `ud01-introduccion-big-data/01-teoria/UD1-Parte0-BaseMatematica/UD1_P0_Estadistica_para_BigData.md`
- `ud01-introduccion-big-data/01-teoria/UD1-Parte0-BaseMatematica/UD1_P0_Capsula_Matematica_Normativa.md`
- `ud01-introduccion-big-data/04-evaluacion/UD1-Parte0-BaseMatematica/UD1_P0_Cuestionario_Estadistica_y_Capsula_Normativa.md`

Criterio: estadística para limpieza de datos, gráficos, correlación, colinealidad, outliers y calidad; cápsula mínima para cubrir la parte normativa de matemática discreta/lógica/complejidad.

### 4. Reforma de arquitectura Big Data en UD1

La parte de arquitectura se considera lista en versión 1, salvo revisión posterior.

Archivos modificados/creados:

- `ud01-introduccion-big-data/01-teoria/UD1-Parte3/UD1-SGBD-Intro-P3.md`
- `ud01-introduccion-big-data/04-evaluacion/UD1-Parte3/UD1_P3_Actividad_Diseno_Arquitectura_Medallion.md`
- `ud01-introduccion-big-data/90-archivo/reforma-arquitecturas-2026/UD1-SGBD-Intro-P3_original_2026-06-17.md`
- `00-planificacion/INFORME_REFORMA_ARQUITECTURAS.md`

Contenido incorporado:

- arquitectura Big Data moderna;
- batch y streaming;
- Lambda y Kappa;
- arquitectura por capas;
- lakehouse;
- Medallion: Bronze, Silver, Gold;
- calidad y trazabilidad;
- Parquet, Spark y DuckDB;
- coste y viabilidad en aula.

Referencias externas usadas como contraste:

- https://aitor-medrano.github.io/iabd/
- https://aitor-medrano.github.io/iabd/de/arq.html
- https://docs.databricks.com/en/lakehouse/medallion.html
- https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion

### 5. Cápsula Hadoop histórico vs Spark actual

Se cubrió el hueco de explicar Hadoop como fundamento histórico y Spark como práctica actual.

Archivos creados/modificados:

- `ud03-procesamiento-distribuido/01-teoria/UD3_Capsula_Hadoop_historico_vs_Spark_actual.md`
- `ud03-procesamiento-distribuido/README.md`
- `00-planificacion/INFORME_HUECO_HADOOP_SPARK.md`

Criterio docente:

- Hadoop/HDFS/MapReduce/YARN como base histórica y conceptual.
- Spark/PySpark como herramienta práctica principal.
- Evitar que Hadoop clásico desplace prácticas actuales.
- Evitar usar Spark sin entender qué problema resolvió.

### 6. Práctica local Medallion en UD2

Se creó una práctica local para aterrizar arquitectura sin depender de cloud.

Archivos creados/modificados:

- `ud02-almacenamiento-ingesta/03-practicas/UD2_Practica_Local_Medallion_Parquet_DuckDB_Spark.md`
- `ud02-almacenamiento-ingesta/05-recursos/practica-local-medallion/generar_datos_turismo.py`
- `ud02-almacenamiento-ingesta/05-recursos/practica-local-medallion/README.md`
- `ud02-almacenamiento-ingesta/README.md`
- `00-planificacion/INFORME_PRACTICA_LOCAL_MEDALLION.md`

Pipeline trabajado:

```text
CSV/JSONL raw → Bronze Parquet → Silver limpio → Gold consultable → DuckDB
```

Spark/PySpark queda como ampliación/comparativa.

Verificación realizada:

- el generador compila;
- se ejecutó en `/tmp`;
- genera `ventas.csv`, `reservas.jsonl`, `meteo.csv`, `zonas.csv`.

### 7. Benchmark pandas vs DuckDB vs Spark en UD3

Se creó un laboratorio para comparar herramientas y justificar selección técnica.

Archivos creados/modificados:

- `ud03-procesamiento-distribuido/03-practicas/Spark_Labs/UD3_Lab_Benchmark_Pandas_DuckDB_Spark.md`
- `ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/generar_dataset_benchmark.py`
- `ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py`
- `ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/README.md`
- `ud03-procesamiento-distribuido/README.md`
- `00-planificacion/INFORME_BENCHMARK_PANDAS_DUCKDB_SPARK.md`

Objetivo:

- pandas para análisis local en memoria;
- DuckDB para SQL analítico local sobre Parquet;
- Spark/PySpark cuando escala, distribución o ecosistema justifiquen el coste.

Verificación realizada:

- scripts compilan;
- generador produce CSV y Parquet;
- rama pandas del benchmark ejecuta correctamente;
- DuckDB y Spark quedan preparados, sujetos a instalación de dependencias.

### 8. Matriz coste-calidad-viabilidad (plantilla transversal + actividad UD2)

Se creó la plantilla transversal y una actividad evaluable para UD2 que cubre RA1.g.

Archivos creados:

- `00-planificacion/plantillas/plantilla_matriz_coste_calidad_viabilidad.md`
- `ud02-almacenamiento-ingesta/04-evaluacion/UD2_Actividad_Matriz_Coste_Calidad_Viabilidad.md`

Contenido:

- 7 criterios con definiciones y pesos por defecto.
- Tabla de comparación con valoración 1-5 + justificación.
- Ejemplo resuelto: pandas vs DuckDB vs Spark.
- 6 preguntas de reflexión crítica.
- Rúbrica de evaluación para el docente.

### 9. Dashboard técnico mínimo en UD4

Se creó un laboratorio de dashboard técnico/operativo que monitoriza el pipeline Medallion, diferenciándose explícitamente del BI de negocio (que pasa a BDA).

Archivos creados:

- `ud04-bi-orquestacion/03-practicas/Lab6_Dashboard_Tecnico/UD4_Lab6_Dashboard_Tecnico_Pipeline_Medallion.md`
- `ud04-bi-orquestacion/05-recursos/dashboard-tecnico-medallion/load_pipeline_data.py`

Contenido:

- 6 preguntas de Metabase sobre pipeline_metadata y calidad_log.
- Dashboard organizado con filtro por fecha.
- 6 preguntas de reflexión crítica.
- Ampliación opcional con Superset.
- Script de carga que genera datos sintéticos de pipeline (5 días de histórico).

Diferencia clave con el material existente de UD4: este lab es técnico/operativo (SBD), no BI de negocio (BDA).

### 10. Revisión Power BI — Archivado + demo conceptual

Se revisó el material de Power BI en UD4. Decisión:

- **Demo conceptual**: se mantiene `UD4_13_BI_Comparativa_Metabase_Superset_PowerBI.md` en la ruta principal.
- **Material práctico archivado**: guías Desktop/V1/V2/Web, práctica Lab5 y evaluación movidos a `90-archivo/power-bi-para-BDA/`.
- **Disponible para BDA**: el directorio incluye un README explicativo para el profesor de Big Data Aplicado.

Archivos movidos:

- `01-teoria/Parte-I_BI/UD4_06_PowerBI_Desktop.md` → archivo
- `01-teoria/Parte-I_BI/UD4_06_PowerBI_V1.md` → archivo
- `01-teoria/Parte-I_BI/UD4_06_PowerBI_V2.md` → archivo
- `01-teoria/Parte-I_BI/UD4_06_PowerBI_Web.md` → archivo
- `03-practicas/Lab5_Sesion_PowerBI/` → archivo
- `04-evaluacion/Lab5_Sesion_PowerBI/` → archivo

### 11. Revisión MLOps/cloud packs — Archivados para BDA

Se revisaron los tres packs MLOps/cloud. Decisión: todos pasan a disposición de Big Data Aplicado.

- `UD_AWS_ML_PIPELINE.zip` → archivado (esqueleto muy ligero).
- `lab-mlops-aula.zip` → archivado (incompleto).
- `lab-mlops-monitoring-pro.zip` → archivado para BDA (el más completo: Docker, CI/CD, ECS, monitorización con data drift).

Los tres están en `ud04-bi-orquestacion/90-archivo/mlops-cloud-para-BDA/` con README descriptivo. Se eliminó el directorio original en `00-recursos-comunes/pendiente_revision/mlops_cloud/`.

### 12. Guía scikit-learn vs Spark MLlib

Se creó una guía de decisión para aclarar cuándo el Machine Learning es Big Data y cuándo no.

Archivos creados:

- `ud05-spark-mllib/01-teoria/UD5_Guia_ScikitLearn_vs_SparkMLlib.md`

Contenido:

- Árbol de decisión visual.
- Comparativa directa en 10 dimensiones.
- Cuándo usar cada uno con ejemplos de código.
- Coste y viabilidad de cada opción.
- Estrategia recomendada para SBD (prototipo → migrar → proyecto).

### 12. Rúbrica común SBD por RA/CE

Se creó una rúbrica transversal que unifica criterios de evaluación para todos los RA/CE del módulo.

Archivos creados:

- `00-planificacion/plantillas/rubrica_comun_SBD_por_RA_CE.md`

Contenido:

- RA1: 7 CE con criterios Excelente→Insuficiente.
- RA2: 5 CE.
- RA3: 5 CE.
- RA4: 6 CE.
- Ejemplo de ponderación para actividad concreta.

### 13. Plantilla de planificación técnica (RA1.e)

Se creó una plantilla para que el alumno planifique objetivos, prioridades, tareas y riesgos antes de empezar un proyecto.

Archivos creados:

- `00-planificacion/plantillas/plantilla_planificacion_tecnica.md`

Contenido:

- Objetivo general y específicos priorizados.
- Secuenciación de tareas con dependencias.
- Recursos necesarios.
- Riesgos y mitigación.
- Gantt simplificado.
- Criterios de evaluación de la planificación.

### 14. Revisión Airbyte — sustituido por dlt

Airbyte 0.50.50 (versión usada en el curso actual) está deprecado y es cada vez
más inestable. Airbyte 1.0+ requiere Kubernetes. Se ha sustituido por **dlt**
como herramienta de ingesta ELT programática.

Decisiones:

- **Ruta A de integración**: se ha reemplazado Airbyte por dlt (`pip install dlt`)
  en la práctica `00-Integracion_y_calidad/`.
- **Script de ejemplo**: se creó `ud02-almacenamiento-ingesta/05-recursos/dlt-ingesta-pipeline/pipeline_ingesta_dlt.py`
  con 4 recursos (ventas CSV, reservas JSONL, meteo CSV, zonas CSV), incremental
  loading y destino DuckDB.
- **Material Airbyte antiguo archivado**: las versiones II (Cloud), III (Redpanda)
  y IV (EC2) de la actividad, junto con el histórico del profesor, se movieron a
  `ud02-almacenamiento-ingesta/90-archivo/airbyte-antiguo/` con README.
- **Operativa Airbyte conservada**: el manual `_profesor/operativa/airbyte_docker_compose.md`
  y las notas de EC2 se mantienen en la ruta de la práctica como referencia
  contextual.
- **Redpanda**: los scripts de Redpanda (todavía funcionales) se conservan en
  `_profesor/redpanda-python/` por si son útiles para streaming.

Archivos creados/modificados:

| Archivo | Acción |
|---------|--------|
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/005/00-Integracion_y_calidad/05-Integracion_y_calidad-tarea.md` | Modificado: Ruta A de Airbyte → dlt |
| `ud02-almacenamiento-ingesta/05-recursos/dlt-ingesta-pipeline/pipeline_ingesta_dlt.py` | Creado: pipeline dlt de ejemplo |
| `ud02-almacenamiento-ingesta/90-archivo/airbyte-antiguo/README.md` | Creado: README del archivo |
| Varios → `90-archivo/airbyte-antiguo/` | Archivados: II, III, IV + histórico |

### 15. Referencia Meltano creada

Meltano no se usa como ruta principal en SBD (dlt es más didáctico: Python puro).
Se ha creado una referencia para el profesorado por si se quiere explorar como
alternativa declarativa ELT, especialmente desde BDA.

Archivo creado:

- `00-planificacion/plantillas/referencia_meltano.md`

### 16. Práctica "Herramientas reales": Airbyte + AWS

Se crearon materiales optativos de contraste para que los alumnos comparen dlt
con herramientas del mundo real. Estos materiales **no son evaluables** y se
ejecutan solo si el docente tiene la infraestructura preparada.

Archivos creados:

| Archivo | Contenido |
|---------|-----------|
| `ud02-almacenamiento-ingesta/05-recursos/practica-herramientas-reales/README.md` | Visión general + notas de montaje para el docente (Proxmox, Docker, Airbyte 1.x, AWS Academy) |
| `ud02-almacenamiento-ingesta/05-recursos/practica-herramientas-reales/airbyte-comparativa.md` | Práctica: configurar source CSV + destino DuckDB desde GUI Airbyte. Tabla comparativa dlt vs Airbyte. |
| `ud02-almacenamiento-ingesta/05-recursos/practica-herramientas-reales/aws-ingesta-serverless.md` | Práctica: subir CSVs a S3, catalogar con Glue Crawler, consultar con Athena. Contraste pipeline vs serverless. |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/005/00-Integracion_y_calidad/05-Integracion_y_calidad-tarea.md` | Modificado: añadida nota al final con referencia a herramientas reales. |

Pendiente (docente):

- Instalar Airbyte 1.x en servidor Proxmox y verificar conectividad.
- Validar que AWS Academy permita S3, Glue Crawler y Athena en los laboratorios.
- Decidir si se mantiene DuckDB como destino Airbyte o se cambia a Postgres.

Estos materiales se crearon ahora (junio 2026) para que el docente pueda
preparar la infraestructura durante el verano sin prisas.

Meltano no se usa como ruta principal en SBD (dlt es más didáctico: Python puro).
Se ha creado una referencia para el profesorado por si se quiere explorar como
alternativa declarativa ELT, especialmente desde BDA.

Archivo creado:

- `00-planificacion/plantillas/referencia_meltano.md`

## Backlog pendiente

Backlog de prioridad alta que quedaba en `00-planificacion/propuesta_mejora_contenidos_sbd.md`:

| Estado | Tarea | Unidad | Comentario |
| ------ | ----- | ------ | ---------- |
| ✅ Hecho | Crear cápsula “Hadoop histórico vs Spark actual” | UD1/UD3 | Cubierto en UD3. |
| ✅ Hecho | Crear práctica local ingesta → Parquet → DuckDB/Spark | UD2 | Cubierto con práctica Medallion local. |
| ✅ Hecho | Crear benchmark pandas vs DuckDB vs Spark | UD3 | Cubierto con laboratorio reproducible. |
| ✅ Hecho | Crear matriz coste-calidad-viabilidad | UD2/UD6 | Plantilla transversal + actividad UD2, con rúbrica y ejemplo resuelto. |
| ✅ Hecho | Crear dashboard técnico mínimo | UD4 | Lab6 con Metabase, datos Medallion UD2, métricas de pipeline. |
| ✅ Hecho | Crear guía scikit-learn vs Spark MLlib | UD5 | Guía de decisión con árbol, tabla comparativa y criterios coste/calidad. |
| ✅ Hecho | Crear rúbrica común SBD por RA/CE | Todas | Rúbrica transversal con todos los CE, pesos y ejemplo de cálculo. |
| ✅ Hecho | Crear plantilla de planificación técnica | Todas | Plantilla RA1.e con objetivos, prioridades, cronograma y riesgos. |
| ✅ Hecho | Revisar FireDuck | UD1 | Archivado. El paquete `fireduck` ya no existe en PyPI. Ver sección 17. |
| ✅ Hecho | Revisar MLOps/cloud packs | General | Archivados en 90-archivo/mlops-cloud-para-BDA/ con README. Pasan a disposición de BDA. |
| ✅ Hecho | Revisar Airbyte/Redpanda viabilidad | UD2 | Airbyte reemplazado por dlt. Ver sección 14. |
| ✅ Hecho | Revisar Power BI/licencias | UD4 | Archivado en 90-archivo/power-bi-para-BDA/. Queda demo conceptual (comparativa). Disponible para que BDA lo recoja. |

### 17. Revisión FireDuck — archivado

FireDuck era un tutorial de una librería Python con API estilo pandas sobre DuckDB.
Se ha archivado por las siguientes razones:

- **El paquete `fireduck` ya no está disponible en PyPI**. `pip install fireduck`
  devuelve error. Un tutorial que no se puede ejecutar no tiene valor docente.
- **No aporta valor curricular único** en SBD. DuckDB + SQL directo y pandas cubren
  el mismo espacio con herramientas estándar.
- **No se usa en industria**: proyecto abandonado.

Acción:

- `ud01-introduccion-big-data/01-teoria/UD1-Parte4/docs/02-tutorial-fireduck.md`
  → movido a `ud01-introduccion-big-data/90-archivo/fireduck/` con README
  explicativo.
- El resto del material de UD1-Parte4 (tutorial DuckDB, plantillas de calidad,
  documento principal de EDA) se queda intacto.

Archivos afectados:

| Archivo | Acción |
|---------|--------|
| `ud01-introduccion-big-data/01-teoria/UD1-Parte4/docs/02-tutorial-fireduck.md` | Movido a archivo |
| `ud01-introduccion-big-data/90-archivo/fireduck/README.md` | Creado |
| `00-planificacion/ESTADO_REFORMA_SBD_2026_2027.md` | Actualizado |

Aclaración: el tutorial original confundía **FireDuck** (wrapper DuckDB, inventado)
con **FireDucks** (NEC, reemplazo JIT de pandas, `pip install fireducks`). Son
proyectos distintos. FireDuck no existía como tal.

Decisión sobre FireDucks (NEC): no se incorpora como contenido principal en SBD.
Podría aparecer como **ampliación opcional en el benchmark de UD3** (pandas vs
DuckDB vs Spark + FireDucks) si el profesor lo considera útil y el entorno lo
soporta. El tutorial para Programación de IA (PIA) lo hará el docente aparte.

### 18. Matriz RA/CE → materiales y actualización de READMEs

Se creó la matriz maestra que mapea cada Criterio de Evaluación con los materiales
que lo cubren. Se actualizaron los READMEs de cada UD y los enunciados de las
actividades principales.

Archivos creados/modificados:

| Archivo | Acción |
|---------|--------|
| `00-planificacion/matriz_ra_ce_materiales.md` | Creado: matriz completa RA/CE → materiales |
| `ud01-introduccion-big-data/README.md` | Actualizado: tabla RA/CE |
| `ud02-almacenamiento-ingesta/README.md` | Actualizado: tabla RA/CE |
| `ud03-procesamiento-distribuido/README.md` | Actualizado: tabla RA/CE |
| `ud04-bi-orquestacion/README.md` | Actualizado: tabla RA/CE |
| `ud05-spark-mllib/README.md` | Actualizado: tabla RA/CE |
| `ud01-introduccion-big-data/04-evaluacion/UD1_03_Tarea_y_rubrica.md` | Actualizado: header RA/CE |
| `ud02-almacenamiento-ingesta/04-evaluacion/UD2_05_Tarea_y_rubrica.md` | Actualizado: header RA/CE |
| `ud03-procesamiento-distribuido/04-evaluacion/Spark_Labs/SparkLab1/03-SparkLab1-Entrega.md` | Actualizado: header RA/CE |
| `ud04-bi-orquestacion/03-practicas/Lab1_Metabase/UD4_06_Primer_Laboratorio_BI_Metabase.md` | Actualizado: header RA/CE |
| `ud04-bi-orquestacion/03-practicas/Lab2_Superset/UD4_11_Laboratorio_2_Superset.md` | Actualizado: header RA/CE |
| `ud04-bi-orquestacion/03-practicas/Lab3_miniProy/UD4_12_MiniProyecto_CuadroDeMando.md` | Actualizado: header RA/CE |
| `ud04-bi-orquestacion/03-practicas/Lab4_Airflow/UD4_08_Laboratorio_Airflow_Basico.md` | Actualizado: header RA/CE |

**RA2.d cubierto**: se añadió una sección de predicción (media móvil + conexión
a regresión Spark MLlib) en el Lab6 de UD4. El LAB1 de UD5 ya cubría regresión
con Spark MLlib; ahora está conectado explícitamente al dashboard técnico.

### 19. Mini-práctica logs JSON (RA4.a)

Se creó un laboratorio corto para trabajar datos semiestructurados (JSONL)
simulando logs de servidor web. Incluye generador de datos, consultas Python,
DuckDB, detección de anomalías y visualización.

Archivos creados:

| Archivo | Acción |
|---------|--------|
| `ud01-introduccion-big-data/03-practicas/UD1-Parte4/lab_logs_json/UD1_Lab_Logs_JSON.md` | Creado |
| `ud01-introduccion-big-data/03-practicas/UD1-Parte4/lab_logs_json/generar_logs_server.py` | Creado |

### 20. Checklist calidad/RGPD/seguridad (RA3.d)

Se creó una plantilla transversal con checklist de calidad (antes/durante/después),
RGPD y seguridad. Aplicable a cualquier práctica o proyecto.

Decisión docente añadida: desde UD2, cualquier procesamiento de datos debe
aplicar un proceso de anonimización. Primero se buscan datos personales e
identificadores directos o indirectos. Si no hay, se documenta que la
anonimización queda completada por ausencia de identificadores. Si los hay o
puede haber riesgo de reidentificación, se exige anonimizar, seudonimizar,
agregar, generalizar o eliminar hasta que el dataset quede listo para publicar o
explotar sin identificar personas. El objetivo es que el alumnado interiorice que
las filtraciones de datos personales pueden tener sanciones graves y que la
gestión de privacidad es parte del trabajo profesional con datos.

Archivo creado:

| Archivo | Acción |
|---------|--------|
| `00-planificacion/plantillas/plantilla_checklist_calidad_rgpd.md` | Creado y actualizado con regla transversal de privacidad/anonimización |
| `ud02-almacenamiento-ingesta/README.md` | Actualizado: regla transversal desde UD2 |
| `ud02-almacenamiento-ingesta/04-evaluacion/UD2_05_Tarea_y_rubrica.md` | Actualizado: RGPD exige justificar privacidad e identificadores indirectos |
| `ud06-proyecto/guion_proyecto.md` | Actualizado: justificación de privacidad obligatoria en proyecto |

### 21. Guión proyecto integrador UD6

Se creó el guión del proyecto de cierre del módulo.

| Archivo | Acción |
|---------|--------|
| `ud06-proyecto/README.md` | Creado |
| `ud06-proyecto/guion_proyecto.md` | Creado |
| `ud06-proyecto/05-recursos/ideas_proyecto.md` | Creado: ideas orientativas rescatadas de la UD6 antigua |
| `ud06-proyecto/90-archivo/proyecto-integrador-antiguo/` | Archivado: antigua `ud06-proyecto-integrador/` |

Estructura del proyecto:
- **Fase 0** (semana 1): formar grupos, elegir tema, buscar fuentes
- **Fase 1** (semana 2): ingesta y arquitectura (Bronze)
- **Fase 2** (semana 3): calidad y procesamiento (Silver → Gold)
- **Fase 3** (semana 4): dashboard técnico + predicción
- **Fase 4** (semana 5): cierre y presentación

El proyecto está diseñado como **un único proyecto final compartido** entre
**SBD**, **Big Data Aplicado** y **Programación de la IA**. No se plantean tres
proyectos separados: el alumnado trabaja sobre el mismo sistema de datos y cada
módulo evalúa su perspectiva. SBD evalúa arquitectura, ingesta, almacenamiento,
calidad, procesamiento, trazabilidad, coste/viabilidad y dashboard técnico; BDA
puede evaluar dashboard de negocio y toma de decisiones; PIA puede evaluar
modelos ML o integración de IA.

La carpeta antigua `ud06-proyecto-integrador/` no queda como unidad canónica: se
archivó por ser una versión anterior y duplicada. La idea de proyecto común
multi-módulo se mantiene en la UD6 vigente: `ud06-proyecto/`.

### 22. Declaración de uso de IA

Se añadió un criterio transversal para documentar el uso de IA generativa en
tareas y proyectos. La idea no es prohibir la IA, sino hacer su uso transparente,
verificable y defendible oralmente.

Se matizó expresamente que SBD **no aplica la escala completa 0-5** del módulo
de Programación de 1º. En SBD la exigencia es más ligera: si se usa IA, el grupo
debe poder explicar el proceso seguido, qué cambió en su solución, qué verificó
y qué aprendió.

Archivos creados/modificados:

| Archivo | Acción |
|---------|--------|
| `00-planificacion/plantillas/plantilla_declaracion_uso_ia.md` | Creado: plantilla transversal de declaración de uso de IA |
| `00-planificacion/plantillas/plantilla_checklist_calidad_rgpd.md` | Actualizado: añadido bloque de uso de IA |
| `00-planificacion/plantillas/rubrica_comun_SBD_por_RA_CE.md` | Actualizado: criterio transversal de uso de IA |
| `ud06-proyecto/guion_proyecto.md` | Actualizado: declaración IA obligatoria si se usa IA + defensa oral |
| `ud06-proyecto/README.md` | Actualizado: nota visible sobre uso de IA |

Criterio acordado:

- En tareas evaluables: recomendable exigir declaración si se ha usado IA.
- En proyectos: imprescindible si se ha usado IA.
- Se deben indicar herramientas/modelos, prompts relevantes, partes afectadas,
  proceso seguido, verificaciones realizadas y decisiones propias del grupo.
- El docente puede preguntar en defensa oral para comprobar aprendizaje real.
- Usar IA no penaliza; ocultarla, no verificarla o no entender lo entregado sí.

## Siguiente paso recomendado

**La reforma del módulo SBD 2026/2027 está completa en su totalidad.**
No quedan pendientes de contenido nuevo, revisiones de materiales, ni huecos
curriculares.

Las únicas tareas restantes son **preparación de infraestructura** (docente):

1. Instalar Airbyte 1.x en servidor Proxmox y probar conectividad.
2. Validar servicios AWS Academy (S3, Glue, Athena) para la práctica optativa.
3. Decidir destino DuckDB vs Postgres para la práctica Airbyte.

Ninguna de ellas bloquea el curso — las prácticas principales funcionan con dlt
y DuckDB, que son 100% locales y no requieren servidor.

Con el nuevo pipeline dlt:

```bash
pip install dlt duckdb
cd ud02-almacenamiento-ingesta/05-recursos/dlt-ingesta-pipeline
python pipeline_ingesta_dlt.py
```

```bash
duckdb ingesta_medallion.duckdb \
  -c "SELECT table_name, row_count FROM bronze._dlt_loads"
```

## Comandos útiles de verificación

Desde la raíz de `SBD_2026_2027_reorganizado`:

```bash
python ud02-almacenamiento-ingesta/05-recursos/practica-local-medallion/generar_datos_turismo.py
```

```bash
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/generar_dataset_benchmark.py --rows 200000
```

```bash
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py --engine pandas
```

Con dependencias instaladas:

```bash
pip install pandas pyarrow duckdb pyspark
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py --engine all
```

## Dependencias recomendadas para continuar

```bash
python -m venv .venv
source .venv/bin/activate
pip install pandas pyarrow duckdb pyspark
```

Spark puede requerir Java correctamente instalado. Si Spark falla, no pasa nada: se documenta la fricción operativa, porque eso también forma parte de la decisión técnica.

## Nota de continuidad

El enfoque correcto es seguir sustituyendo huecos con materiales pequeños, verificables y conectados entre sí. No añadir contenido por añadir.

Secuencia que se está construyendo:

```text
UD1 arquitectura → UD2 pipeline Medallion + dlt + matriz coste/calidad/viabilidad → UD3 benchmark motores → UD4 dashboard técnico pipeline
```

Esa secuencia es coherente, práctica y defendible curricularmente. dlt conecta
directamente con el pipeline Medallion (mismos datos de entrada) y permite
comparar enfoques: script Python manual (Ruta B) vs pipeline ELT declarativo
(Ruta A, dlt).
