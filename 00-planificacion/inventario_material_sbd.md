# Inventario del módulo: Sistemas de Big Data

## 1. Resumen ejecutivo

El módulo tiene una base amplia de materiales docentes organizada principalmente por unidades (`ud01` a `ud06`). Predominan los apuntes en Markdown/HTML/PDF, prácticas guiadas, laboratorios, rúbricas, notebooks, scripts de apoyo, datasets y paquetes comprimidos de recursos.

Las partes mejor cubiertas son:

- **UD1 — Introducción Big Data**: conceptos, NoSQL inicial, DuckDB, EDA, calidad de datos e ingesta básica.
- **UD2 — Almacenamiento e ingesta**: almacenamiento distribuido, HDFS, NoSQL, cloud, pipelines, integración, calidad incremental, RGPD y seguridad.
- **UD3 — Procesamiento distribuido**: Spark, Kibana, Grafana, Prometheus, Zeppelin y laboratorios asociados.
- **UD4 — BI y orquestación**: Metabase, Superset, Power BI, Airflow, Mage AI, pipelines y dashboards.
- **UD5 — Spark MLlib**: teoría, notebooks, scripts, datasets y laboratorios de regresión, clasificación y clustering.
- **UD6 — Proyecto integrador**: cierre del módulo con Big Data, BI y ML.

Hay bastante material duplicado o en formatos derivados: Markdown + HTML + PDF, versiones ampliadas, carpetas `99-profesor`, ZIPs de packs y copias de laboratorios. Esto no es malo por sí mismo, pero AHORA MISMO complica la reorganización: hay que distinguir fuente editable, versión publicada, paquete de aula, evaluación y archivo histórico.

Conviene revisar antes del próximo curso:

- Qué ficheros son fuente principal y cuáles son derivados generados.
- Qué ZIPs son packs docentes reutilizables y cuáles son entregas o exportaciones de Moodle.
- Qué materiales de `04-evaluacion` son enunciados/rúbricas reutilizables y cuáles son artefactos de corrección.
- La vigencia de herramientas como Hadoop/HDFS, Kibana, Zeppelin, Airflow, Mage AI, Superset, Metabase y Power BI dentro del currículo real.
- La coherencia entre UD4/UD5/UD6 para que BI, MLlib y proyecto integrador no se solapen sin intención.

## 2. Catálogo de materiales docentes

| Ruta | Elemento | Tipo | Bloque/Unidad | Descripción | Herramientas | Estado aparente | Observaciones |
| ---- | -------- | ---- | ------------- | ----------- | ------------ | --------------- | ------------- |
| `Curriculum Resource Guide v2.pdf` | Curriculum Resource Guide v2.pdf | Referencia curricular | General | Guía curricular o recurso normativo de apoyo. | Currículo | Pendiente de revisión | Revisar relación exacta con RA/CE del módulo. |
| `prompt_inventario_material_modulo.md` | prompt_inventario_material_modulo.md | Prompt docente | General | Prompt base para inventariar materiales docentes de módulos. | IA generativa | Vigente | Útil para repetir el proceso en otros módulos. |
| `prompt_inventario_p1_barrido_gpt54mini.md` | prompt_inventario_p1_barrido_gpt54mini.md | Prompt docente | General | Prompt de primera pasada rápida del inventario. | IA generativa | Vigente | Forma parte del flujo de inventario en dos fases. |
| `prompt_inventario_p2_consolidacion_gpt55.md` | prompt_inventario_p2_consolidacion_gpt55.md | Prompt docente | General | Prompt de consolidación final del inventario. | IA generativa | Vigente | Se usa para generar este catálogo final. |
| `UD_AWS_ML_PIPELINE.zip` | UD_AWS_ML_PIPELINE.zip | Pack comprimido | General / cloud / ML | Posible unidad o pack práctico sobre pipelines ML en AWS. | AWS, ML pipelines | Pendiente de revisión | Verificar si es material docente o archivo histórico. |
| `lab-mlops-aula.zip` | lab-mlops-aula.zip | Pack comprimido | General / MLOps | Pack de laboratorio MLOps para aula. | MLOps | Pendiente de revisión | Si es reutilizable, debería extraerse a estructura docente clara o archivarse como pack. |
| `lab-mlops-monitoring-pro.zip` | lab-mlops-monitoring-pro.zip | Pack comprimido | General / MLOps | Pack de monitorización MLOps. | MLOps, monitoring | Pendiente de revisión | Puede encajar con UD5/UD6, pero requiere revisión curricular. |
| `lab_MLMLDD.ipynb` | lab_MLMLDD.ipynb | Notebook | General / ML | Notebook suelto de laboratorio o apoyo ML. | Python, notebooks | Pendiente de revisión | Falta contexto de unidad; revisar ubicación. |
| `stepfunctions_graph.svg` | stepfunctions_graph.svg | Recurso gráfico | General / orquestación | Diagrama relacionado con Step Functions. | AWS Step Functions | Vigente / revisar | Probable apoyo visual para orquestación cloud. |
| `skill_builder/Skill Builder Meetings.html` | Skill Builder Meetings.html | Documento | General | Documento HTML externo o de herramienta. | Skill Builder | Dudoso | Revisar si realmente pertenece al módulo. |
| `ud01-introduccion-big-data/README.md` | README.md | Índice de unidad | UD1 | Entrada general de la unidad de introducción. | Big Data | Vigente | Debe actuar como índice canónico de UD1. |
| `ud01-introduccion-big-data/01-teoria/UD1_01_BigData101.md` | UD1_01_BigData101.md | Teoría | UD1 | Conceptos esenciales de Big Data. | Big Data | Vigente | Fuente principal candidata. |
| `ud01-introduccion-big-data/01-teoria/UD1_02_EDA_y_calidad.md` | UD1_02_EDA_y_calidad.md | Teoría | UD1 | EDA y calidad de datos. | EDA, calidad de datos | Vigente | Conecta con prácticas de calidad y Parquet. |
| `ud01-introduccion-big-data/01-teoria/UD1_Dossier_Completo.md` | UD1_Dossier_Completo.md | Dossier | UD1 | Dossier completo de la unidad. | Big Data, EDA | Vigente / revisar | Puede duplicar documentos parciales; decidir si es fuente o compilación. |
| `ud01-introduccion-big-data/01-teoria/UD1-Parte1/` | UD1 Parte 1 | Teoría | UD1 | Big Data 101 en Markdown/PDF. | Big Data | Vigente | Mantener fuente editable y tratar PDF como derivado. |
| `ud01-introduccion-big-data/01-teoria/UD1-Parte2/` | UD1 Parte 2 | Teoría / guía | UD1 | Almacenamiento de datos, NoSQL, DuckDB y MongoDB. | DuckDB, MongoDB, PyMongo | Vigente | Buen bloque de fundamentos; revisar duplicidad Markdown/HTML/PDF. |
| `ud01-introduccion-big-data/01-teoria/UD1-Parte3/` | UD1 Parte 3 | Teoría / recursos gráficos | UD1 | Arquitecturas batch, streaming, Lambda, Kappa y capas. | Arquitecturas Big Data | Vigente | Incluye imágenes útiles para explicación conceptual. |
| `ud01-introduccion-big-data/01-teoria/UD1-Parte4/` | UD1 Parte 4 | Teoría / plantillas | UD1 | EDA, calidad de datos, plantillas y tutorial DuckDB. FireDuck archivado (paquete no disponible). | DuckDB, CSV | Vigente | Tutorial FireDuck movido a `90-archivo/fireduck/`. |
| `ud01-introduccion-big-data/01-teoria/UD1-Parte5/` | UD1 Parte 5 | Teoría / práctica | UD1 | Ingesta de datos y mini-práctica asociada. | Python, ingesta | Vigente | Encaja como puente hacia UD2. |
| `ud01-introduccion-big-data/03-practicas/UD1-Parte2/lab_p2_modelado_documental_analitico/` | lab_p2_modelado_documental_analitico | Práctica | UD1 | Modelado documental vs analítico con JSON, Parquet y DuckDB. | DuckDB, JSON, Parquet, Python | Vigente / revisar | Hay duplicados `README.md`, `README (1).md`, `READMEbis.md`; consolidar. |
| `ud01-introduccion-big-data/03-practicas/UD1-Parte4/lab_p3_eda_calidad_duckdb/` | lab_p3_eda_calidad_duckdb | Práctica | UD1 | EDA y calidad con DuckDB, notebooks, scripts y datasets. | DuckDB, Python, Parquet, CSV | Vigente / revisar | Hay ZIPs y posible duplicado `lab_p3...zip`/`lab_p3...1.zip`. |
| `ud01-introduccion-big-data/04-evaluacion/UD1_03_Tarea_y_rubrica.md` | UD1_03_Tarea_y_rubrica.md | Evaluación / rúbrica | UD1 | Tarea guiada de EDA, calidad y exportación a Parquet. | EDA, Parquet | Vigente | Material evaluativo reutilizable. |
| `ud01-introduccion-big-data/05-recursos/` | Recursos UD1 | Recursos / plantillas | UD1 | Pack UD1, notebooks, referencias y plantillas. | DuckDB, métricas, CSV | Vigente / revisar | Separar recursos fuente, plantillas y ZIP de distribución. |
| `ud01-introduccion-big-data/99-profesor/UD1-Resumen-Material.md` | UD1-Resumen-Material.md | Guía docente | UD1 | Resumen interno de materiales teórico-prácticos. | Big Data | Vigente / revisar | Útil para profesor; no debería mezclarse con material de alumnado. |
| `ud02-almacenamiento-ingesta/README.md` | README.md | Índice de unidad | UD2 | Entrada general de almacenamiento e ingesta. | Big Data | Vigente | Debe actuar como índice canónico de UD2. |
| `ud02-almacenamiento-ingesta/01-teoria/001-AlmacenamientoDeDatos.md` | 001-AlmacenamientoDeDatos.md | Teoría | UD2 | Introducción al almacenamiento en Big Data. | Almacenamiento | Vigente | Mantener como fuente editable. |
| `ud02-almacenamiento-ingesta/01-teoria/002-AlmacenamientoDistribuido*.md` | Almacenamiento distribuido / HDFS | Teoría | UD2 | Sistemas de almacenamiento distribuido e introducción a HDFS. | HDFS, Hadoop | Vigente / revisar | HDFS sigue siendo útil curricularmente aunque conviene contextualizarlo como tecnología clásica. |
| `ud02-almacenamiento-ingesta/01-teoria/003-BBDD_EnBigData.md` | 003-BBDD_EnBigData.md | Teoría | UD2 | Bases de datos SQL/NoSQL en Big Data. | SQL, NoSQL | Vigente | Buena base conceptual. |
| `ud02-almacenamiento-ingesta/01-teoria/004-NoSQL_MongoDB-Cassandra.md` | 004-NoSQL_MongoDB-Cassandra.md | Teoría | UD2 | Profundización en MongoDB y Cassandra. | MongoDB, Cassandra | Vigente / revisar | Cassandra puede requerir actualización de casos de uso. |
| `ud02-almacenamiento-ingesta/01-teoria/005-IntegracionTransferenciaDatos*.md` | Integración y transferencia de datos | Teoría / actividades | UD2 | Airbyte, Debezium y transferencia moderna de datos. | Airbyte, Debezium | Vigente / revisar | Revisar disponibilidad gratuita/cloud educativa. |
| `ud02-almacenamiento-ingesta/01-teoria/006-GestGranVolumenHADOOp_SPARK.md` | Hadoop y Spark | Teoría | UD2 | Gestión de grandes volúmenes con Hadoop y Spark. | Hadoop, Spark | Vigente / revisar | Vigente curricularmente; actualizar enfoque hacia Spark moderno. |
| `ud02-almacenamiento-ingesta/01-teoria/007-SistAlmacenamientoNube-AWSGCAZ.md` | Cloud storage | Teoría | UD2 | Sistemas de almacenamiento en AWS, Google Cloud y Azure. | AWS, GCP, Azure | Vigente / revisar | Revisar costes y alternativas educativas. |
| `ud02-almacenamiento-ingesta/01-teoria/008-AlmacenNubeBuenasPract_Compres-REplica.md` | Buenas prácticas cloud | Teoría | UD2 | Compresión, replicación y optimización de almacenamiento. | Cloud storage | Vigente | Muy útil transversalmente. |
| `ud02-almacenamiento-ingesta/01-teoria/010-PIpelineDeDatos.md` | Pipeline de datos | Teoría | UD2 | Conceptos de pipeline de datos. | Pipelines | Vigente | Conecta con UD4/UD6. |
| `ud02-almacenamiento-ingesta/01-teoria/011-RGPDyBIGData*.md` | RGPD y Big Data | Teoría / resumen | UD2 | RGPD, seguridad y tratamiento de datos. | RGPD | Vigente | Bloque normativo importante. |
| `ud02-almacenamiento-ingesta/01-teoria/Presentaciones/` | Presentaciones UD2 | Presentaciones | UD2 | Versiones Beamer/Reveal de contenidos UD2. | Beamer, Reveal | Vigente / revisar | Tratar como derivados de los `.md` salvo que sean fuente real. |
| `ud02-almacenamiento-ingesta/01-teoria/UD2_01_Problema_y_arquitectura.md` | UD2_01_Problema_y_arquitectura.md | Teoría | UD2 | Problema y arquitectura de ingesta e integración. | Arquitectura de datos | Vigente | Fuente moderna de unidad. |
| `ud02-almacenamiento-ingesta/01-teoria/UD2_02_Ingesta_scripts_y_Airbyte.md` | UD2_02_Ingesta_scripts_y_Airbyte.md | Teoría / práctica | UD2 | Ingesta con scripts pandas y Airbyte OSS. | Python, pandas, Airbyte | Vigente / revisar | Comprobar estado actual de Airbyte OSS/Cloud. |
| `ud02-almacenamiento-ingesta/01-teoria/UD2_03_Integracion_y_calidad_incremental.md` | UD2_03_Integracion_y_calidad_incremental.md | Teoría / práctica | UD2 | Joins, upsert, integración y calidad incremental. | ETL, calidad de datos | Vigente | Muy alineado con resultados de integración. |
| `ud02-almacenamiento-ingesta/01-teoria/UD2_04_RGPD_y_seguridad.md` | UD2_04_RGPD_y_seguridad.md | Teoría | UD2 | Plantilla rápida de RGPD y seguridad. | RGPD, seguridad | Vigente | Mantener como material transversal. |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/002/TareaHDFS.md` | TareaHDFS.md | Práctica | UD2 | Trabajo con Parquet en HDFS. | HDFS, Parquet | Vigente / revisar | HDFS puede ser clásico, pero sirve para RA de almacenamiento distribuido. |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/003/` | Tareas AWS SQL/NoSQL | Prácticas | UD2 | Actividades con DynamoDB, RDS, cluster Spark/Hadoop EC2 y script de base de datos. | AWS, DynamoDB, RDS, Spark, Hadoop | Pendiente de revisión | Revisar costes y viabilidad en aula. |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/004/ActividadCassandraMongoDB.md` | ActividadCassandraMongoDB.md | Práctica | UD2 | Comparativa Cassandra/MongoDB. | Cassandra, MongoDB | Vigente / revisar | Buena para criterio comparativo, aunque requiere actualización de contexto. |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/005/` | Prácticas de integración y calidad | Prácticas | UD2 | Integración incremental, Airbyte/Redpanda/Python, datasets y guiones. | Airbyte, Redpanda, Python, CSV | Vigente / revisar | Hay ZIPs de recursos que conviene separar de entregas. |
| `ud02-almacenamiento-ingesta/04-evaluacion/UD2_05_Tarea_y_rubrica.md` | UD2_05_Tarea_y_rubrica.md | Evaluación / rúbrica | UD2 | Tarea evaluable y rúbrica UD2. | Ingesta, calidad, integración | Vigente | Material evaluativo principal. |
| `ud02-almacenamiento-ingesta/05-recursos/` | Recursos UD2 | Recursos / datasets | UD2 | Dataset airline, repo de ejemplo y referencias. | Parquet, datasets | Vigente / revisar | `repo_ud2_miniexample.zip` debe clasificarse como plantilla o archivo. |
| `ud02-almacenamiento-ingesta/99-profesor/` | Material profesor UD2 | Guía docente / versiones ampliadas | UD2 | Versiones unificadas/ampliadas y material docente interno. | Airbyte, integración, calidad | Vigente / revisar | Separar claramente de material publicable. |
| `ud03-procesamiento-distribuido/README.md` | README.md | Índice de unidad | UD3 | Entrada general de procesamiento distribuido. | Spark, Kibana, Grafana | Vigente | Debe actuar como índice canónico de UD3. |
| `ud03-procesamiento-distribuido/01-teoria/` | Teoría UD3 | Teoría | UD3 | Procesamiento distribuido, analítica escalable, Spark, Kibana/Grafana y Zeppelin. | Spark, Kibana, Grafana, Zeppelin | Vigente / revisar | Zeppelin y Kibana/Grafana requieren actualización de enfoque y objetivos. |
| `ud03-procesamiento-distribuido/03-practicas/Kibana_Labs/` | Kibana Labs | Prácticas | UD3 | Laboratorios de visualización, dashboards, interpretación y observabilidad. | Kibana | Vigente / revisar | Útil si se mantiene Elastic/Kibana; revisar coste/stack disponible. |
| `ud03-procesamiento-distribuido/03-practicas/Prometheus_grafana_lab/` | Prometheus/Grafana Lab | Práctica | UD3 | Laboratorio de monitorización y observabilidad. | Prometheus, Grafana | Vigente | Muy aprovechable para observabilidad de sistemas Big Data. |
| `ud03-procesamiento-distribuido/03-practicas/Spark_Labs/` | Spark Labs | Prácticas | UD3 | Kit de aula y laboratorios Spark. | Spark, PySpark | Vigente | Bloque central para procesamiento distribuido. |
| `ud03-procesamiento-distribuido/04-evaluacion/Spark_Labs/` | Evaluación Spark Labs | Evaluación / rúbricas | UD3 | Rúbricas y documentos de evaluación de laboratorios Spark. | Spark | Vigente / revisar | Incluir sólo enunciados/rúbricas, no entregas ni resultados. |
| `ud03-procesamiento-distribuido/99-profesor/` | Material profesor UD3 | Guía docente | UD3 | Versiones profesor de Kibana/Spark, alternativas y presentaciones. | Spark, Kibana, Zeppelin | Vigente / revisar | Muy útil para docencia, pero debe quedar separado de alumnado. |
| `ud04-bi-orquestacion/README.md` | README.md | Índice de unidad | UD4 | Entrada general de BI y orquestación. | BI, orquestación | Vigente | Debe actuar como índice canónico de UD4. |
| `ud04-bi-orquestacion/01-teoria/Parte-I_BI/` | Parte I BI | Teoría | UD4 | Fundamentos BI, modelado, preparación de datos, Metabase, Superset, Power BI, diseño de dashboards y analítica predictiva. | Metabase, Superset, Power BI | Vigente / revisar | Mucho material en Markdown/HTML/PDF; decidir fuente principal. |
| `ud04-bi-orquestacion/01-teoria/ParteII-Orquestacion/` | Parte II Orquestación | Teoría / práctica | UD4 | Airflow, Mage AI, pipelines y orquestación de datos. | Airflow, Mage AI, Spark, MLlib | Vigente / revisar | Mage AI requiere confirmar continuidad y fricción de instalación. |
| `ud04-bi-orquestacion/01-teoria/ParteII-Orquestacion/practica/mage_ai_pack/` | mage_ai_pack | Proyecto base / pack aula | UD4 | Pack con Docker/requirements, scripts, pipeline Mage AI, notebooks y datos. | Mage AI, Docker, Python | Vigente / revisar | Buen candidato a plantilla de aula; separar fuentes de outputs. |
| `ud04-bi-orquestacion/01-teoria/UD4_13_BI_Comparativa_Metabase_Superset_PowerBI.md` | Comparativa BI | Teoría | UD4 | Comparativa entre Metabase, Superset y Power BI. | Metabase, Superset, Power BI | Vigente | Muy útil para selección de herramientas y criterio técnico. |
| `ud04-bi-orquestacion/03-practicas/Lab1_Metabase/` | Lab1 Metabase | Práctica | UD4 | Primer laboratorio BI con Metabase. | Metabase | Vigente | Enunciado reutilizable; mantener separado de correcciones. |
| `ud04-bi-orquestacion/03-practicas/Lab2_Superset/` | Lab2 Superset | Práctica | UD4 | Laboratorio BI con Superset. | Superset | Vigente / revisar | Revisar viabilidad de instalación/uso en aula. |
| `ud04-bi-orquestacion/03-practicas/Lab3_miniProy/` | Lab3 Mini Proyecto | Práctica / proyecto | UD4 | Mini-proyecto de cuadro de mando. | BI, dashboards | Vigente | Buen puente hacia UD6. |
| `ud04-bi-orquestacion/03-practicas/Lab4_Airflow/` | Lab4 Airflow | Práctica | UD4 | Airflow básico, DAGs, scripts y ejemplo paso a paso. | Airflow, Python | Vigente / revisar | Revisar si Airflow es viable frente a alternativas más ligeras. |
| `ud04-bi-orquestacion/03-practicas/Lab5_Sesion_PowerBI/` | Lab5 Power BI | Práctica / demo | UD4 | Sesión demo de Power BI con dataset. | Power BI, CSV | Vigente / revisar | Vigilar licencias, cuentas y disponibilidad en aula. |
| `ud04-bi-orquestacion/04-evaluacion/*/UD4_*.md` | Enunciados evaluación UD4 | Evaluación | UD4 | Copias evaluables de laboratorios Metabase, Superset, MiniProyecto y Power BI. | BI, Airflow, Power BI | Vigente / revisar | Conservar sólo enunciados/rúbricas; excluir notas, feedback y ZIPs de entregas. |
| `ud05-spark-mllib/README.md` | README.md | Índice de unidad | UD5 | Entrada general de Spark y MLlib. | Spark, MLlib | Vigente | Debe actuar como índice canónico de UD5. |
| `ud05-spark-mllib/01-teoria/` | Teoría UD5 | Teoría | UD5 | Analítica predictiva, pipeline Big Data + ML + BI, Spark MLlib, preparación de features y evaluación de modelos. | Spark, MLlib, ML | Vigente | Bloque bien cubierto. |
| `ud05-spark-mllib/02-ejemplos/` | Ejemplos UD5 | Notebooks / scripts / datasets | UD5 | Regresión, clasificación, clustering y dataset US Crime. | PySpark, Spark MLlib, Colab | Vigente / revisar | `US_Crime_Rates1980.zip` puede ser recurso histórico o dataset empaquetado. |
| `ud05-spark-mllib/03-practicas/` | Laboratorios Spark MLlib | Prácticas / rúbrica | UD5 | LAB1 regresión, LAB2 dataset real, LAB3 clasificación Titanic y rúbrica general. | Spark, MLlib, PySpark | Vigente | Material central de evaluación práctica. |
| `ud05-spark-mllib/04-evaluacion/*/LAB*.md` | Enunciados evaluación UD5 | Evaluación | UD5 | Copias de laboratorios evaluables. | Spark, MLlib | Vigente / revisar | Mantener enunciados/rúbricas; excluir calificaciones, informes privados y entregas. |
| `ud05-spark-mllib/04-evaluacion/*/rubrica_operativa.md` | Rúbricas operativas UD5 | Rúbrica | UD5 | Rúbricas de Lab1 y Lab2 Spark MLlib. | Spark, MLlib | Vigente | Material reutilizable para evaluación. |
| `ud05-spark-mllib/05-recursos/datasets/housing_spark.csv` | housing_spark.csv | Dataset | UD5 | Dataset de apoyo para Spark/ML. | Spark, CSV | Vigente | Recurso reutilizable. |
| `ud06-proyecto-integrador/README.md` | README.md | Índice de unidad | UD6 | Entrada general del proyecto integrador. | Big Data, BI, ML | Vigente | Debe actuar como índice canónico de UD6. |
| `ud06-proyecto-integrador/01-teoria/UD6_Proyecto_Integrador_BigData_BI_ML.md` | Proyecto integrador | Teoría / proyecto | UD6 | Proyecto integrador Big Data + BI + ML. | Big Data, BI, ML | Vigente | Cierre natural del módulo. |
| `ud06-proyecto-integrador/01-teoria/UD6_Proyectos_Modelo_Propuestos.md` | Proyectos modelo propuestos | Propuestas de proyecto | UD6 | Ideas de proyectos, como predicción de demanda o ventas. | BI, ML | Vigente | Útil para orientar propuestas de alumnado. |
| `ud06-proyecto-integrador/99-profesor/git-worktrees-conversacion.md` | git-worktrees-conversacion.md | Nota docente / técnica | UD6 | Notas sobre Git, submódulos, worktrees y ramas. | Git | Pendiente de revisión | Puede ser material interno de gestión, no necesariamente de alumnado. |

## 3. Materiales de corrección detectados

Estos materiales se consideran reutilizables para orientar correcciones o evaluaciones. No se incluyen entregas, ZIPs de alumnado, repositorios de alumnado, notas ni feedback individual.

| Ruta | Elemento | Uso probable | Unidad/Bloque | Observaciones |
| ---- | -------- | ------------ | ------------- | ------------- |
| `ud03-procesamiento-distribuido/04-evaluacion/Spark_Labs/Rubrica-3-labs.md` | Rubrica-3-labs.md | Rúbrica reutilizable | UD3 | Evaluación de laboratorios Spark. |
| `ud03-procesamiento-distribuido/04-evaluacion/Spark_Labs/RubricaCheckBoxes.md` | RubricaCheckBoxes.md | Rúbrica/checklist | UD3 | Posible guía operativa de corrección. |
| `ud03-procesamiento-distribuido/04-evaluacion/Spark_Labs/RubricaCheckBoxesMoodle.md` | RubricaCheckBoxesMoodle.md | Rúbrica Moodle | UD3 | Útil para exportar/importar criterio a Moodle. |
| `ud04-bi-orquestacion/04-evaluacion/plantilla-ejecucion-correccion.md` | plantilla-ejecucion-correccion.md | Plantilla de corrección | UD4 | Reutilizable como protocolo de corrección. |
| `ud04-bi-orquestacion/04-evaluacion/README_CORRECCIONES_SBD.md` | README_CORRECCIONES_SBD.md | Guía de corrección | UD4 | Documento operativo para proceso de correcciones. |
| `ud04-bi-orquestacion/04-evaluacion/prompt-orquestador-correccion.md` | prompt-orquestador-correccion.md | Prompt de corrección | UD4 | Reutilizable, pero separado del material docente principal. |
| `ud04-bi-orquestacion/04-evaluacion/Lab1_Metabase/rubrica_operativa.md` | rubrica_operativa.md | Rúbrica operativa | UD4 | Rúbrica de Lab1 Metabase. |
| `ud04-bi-orquestacion/04-evaluacion/Lab3_miniProy/UD4_MiniProyecto_Rubrica.md` | UD4_MiniProyecto_Rubrica.md | Rúbrica | UD4 | Rúbrica del mini-proyecto BI. |
| `ud05-spark-mllib/03-practicas/LABS-RubricaGeneral.md` | LABS-RubricaGeneral.md | Rúbrica general | UD5 | Rúbrica general de laboratorios Spark MLlib. |
| `ud05-spark-mllib/04-evaluacion/plantilla-ejecucion-correccion.md` | plantilla-ejecucion-correccion.md | Plantilla de corrección | UD5 | Reutilizable como protocolo de corrección. |
| `ud05-spark-mllib/04-evaluacion/README_CORRECCIONES_SPARK.md` | README_CORRECCIONES_SPARK.md | Guía de corrección | UD5 | Documento operativo para correcciones Spark. |
| `ud05-spark-mllib/04-evaluacion/prompt-orquestador-correccion.md` | prompt-orquestador-correccion.md | Prompt de corrección | UD5 | Reutilizable, pero separado del catálogo docente principal. |
| `ud05-spark-mllib/04-evaluacion/Lab1-Spark_Mlib/rubrica_operativa.md` | rubrica_operativa.md | Rúbrica operativa | UD5 | Rúbrica de Lab1 Spark MLlib. |
| `ud05-spark-mllib/04-evaluacion/Lab2_Spark_Mlib/rubrica_operativa.md` | rubrica_operativa.md | Rúbrica operativa | UD5 | Rúbrica de Lab2 Spark MLlib. |

## 4. Elementos excluidos deliberadamente

Se han detectado categorías que NO deben formar parte del catálogo docente principal:

- **ZIPs de entregas o exportaciones Moodle**: por ejemplo, ZIPs con nombres de laboratorio y códigos de actividad dentro de `04-evaluacion`. Deben archivarse, no mezclarse con materiales docentes.
- **Repositorios o entregas de alumnado**: cualquier carpeta o archivo asociado a entregas extraídas, nombres de estudiantes, `assignsubmission_file` o repos de alumnado debe quedar fuera del inventario docente.
- **Descompresiones de tareas**: carpetas como `entregas_extraidas` o resultados de extracción de ZIPs deben eliminarse o archivarse en fase posterior, según decisión docente.
- **Artefactos de corrección**: feedback individual, informes privados, CSVs de calificaciones, resultados rellenados, dashboards de corrección y ficheros intermedios.
- **Derivados generados**: HTML/PDF generados desde Markdown, salvo que sean el único formato disponible o se usen como versión de publicación.
- **Outputs de proyectos base**: por ejemplo, `data/output/resultado.csv` dentro de packs de práctica; puede conservarse como ejemplo, pero no debería confundirse con fuente principal.

Ejemplos claros detectados:

- `ud04-bi-orquestacion/04-evaluacion/Lab*/Calificaciones-*.csv`
- `ud04-bi-orquestacion/04-evaluacion/Lab*/informe_privado_profesor.md`
- `ud04-bi-orquestacion/04-evaluacion/Lab*/feedback_alumnado/`
- `ud05-spark-mllib/04-evaluacion/Lab*/Calificaciones-*.csv`
- `ud05-spark-mllib/04-evaluacion/Lab*/informe_privado_profesor.md`
- `ud05-spark-mllib/04-evaluacion/*/entregas_extraidas/`
- ZIPs Moodle de laboratorios en `ud04-bi-orquestacion/04-evaluacion/` y `ud05-spark-mllib/04-evaluacion/`.

## 5. Riesgos, duplicidades y material dudoso

### Duplicidades relevantes

- Abundan pares o tríos `.md` + `.html` + `.pdf`. Conviene marcar un formato fuente y otro de publicación.
- En UD1 hay duplicados claros de README en `lab_p2_modelado_documental_analitico`: `README.md`, `README (1).md`, `READMEbis.md`, `READMEbis.html`.
- En UD1 aparecen ZIPs duplicados o similares: `lab_p3_eda_calidad_duckdb.zip` y `lab_p3_eda_calidad_duckdb1.zip`.
- En UD2 hay versiones antiguas numeradas y versiones nuevas `UD2_01`, `UD2_02`, etc. Hay que decidir si conviven o si una serie reemplaza a la otra.
- En UD4 los documentos de BI tienen varias versiones de Power BI (`Desktop`, `V1`, `V2`, `Web`) que conviene ordenar por propósito.
- En UD5 hay enunciados en `03-practicas` y copias en `04-evaluacion`; eso puede ser correcto, pero debe documentarse.

### Material potencialmente obsoleto o que requiere contexto

- **Hadoop/HDFS**: sigue siendo útil curricularmente, pero debería presentarse como base histórica/conceptual y compararse con enfoques actuales.
- **Zeppelin**: revisar si compensa frente a notebooks/Colab/Jupyter u otras herramientas más sostenibles.
- **Kibana/Grafana/Prometheus**: vigentes para observabilidad, pero requieren confirmar stack disponible y coste operativo.
- **Airflow**: muy relevante profesionalmente, pero puede ser pesado para ciertos entornos de aula.
- **Mage AI**: interesante para orquestación moderna, pero revisar continuidad, documentación y facilidad de instalación.
- **Power BI**: útil y vigente, pero revisar licencias, cuentas educativas y viabilidad en equipos del centro.
- **Airbyte/Redpanda Cloud**: revisar límites gratuitos actuales y alternativas locales.
- **AWS/GCP/Azure**: revisar coste, cuentas educativas y riesgo de facturación.

### Material sin contexto claro

- `lab_MLMLDD.ipynb`
- `UD_AWS_ML_PIPELINE.zip`
- `lab-mlops-aula.zip`
- `lab-mlops-monitoring-pro.zip`
- `stepfunctions_graph.svg`
- `skill_builder/Skill Builder Meetings.html`
- `ud06-proyecto-integrador/99-profesor/git-worktrees-conversacion.md`

No los descartaría todavía. Pero tampoco los pondría como materiales principales sin revisar. ACÁ hay que ser prolijo: si no sabés para qué sirve, no lo metas en una unidad porque “suena parecido”. Después esa deuda se paga cuando el alumnado se pierde.

## 6. Recomendaciones para la siguiente fase

### 6.1. Diseñar una estructura común entre módulos

Propuesta de estructura base por unidad:

```txt
udXX-nombre-unidad/
├── README.md
├── 01-teoria/
├── 02-ejemplos/
├── 03-practicas/
├── 04-evaluacion/
├── 05-recursos/
├── 90-archivo/
└── 99-profesor/
```

Criterios:

- `README.md`: índice real de la unidad, con orden de uso y enlaces.
- `01-teoria`: fuentes editables principales, preferiblemente Markdown.
- `02-ejemplos`: notebooks, scripts y ejemplos no evaluables.
- `03-practicas`: guiones de laboratorio y proyectos base para alumnado.
- `04-evaluacion`: enunciados evaluables, rúbricas y plantillas de entrega.
- `05-recursos`: datasets, imágenes, plantillas, requirements y packs de aula.
- `90-archivo`: material histórico, versiones antiguas, ZIPs archivados.
- `99-profesor`: guías internas, soluciones, notas docentes y prompts de corrección.

### 6.2. Separar material docente, evaluación, corrección, entregas y archivo histórico

Separación recomendada:

- **Material docente principal**: apuntes, prácticas, ejemplos, datasets y plantillas usadas en clase.
- **Evaluación reutilizable**: enunciados, rúbricas y plantillas de entrega.
- **Corrección**: prompts, guías operativas y plantillas de corrección.
- **Entregas de alumnado**: fuera del árbol docente principal o en archivo controlado.
- **Artefactos de corrección**: CSVs de notas, feedback e informes privados en archivo separado.
- **Derivados generados**: HTML/PDF en carpeta de publicación o regenerables desde fuente.

### 6.3. Preparar la revisión curricular del curso siguiente

Prioridades:

1. Definir por unidad una fuente canónica y eliminar duplicidades aparentes.
2. Revisar herramientas cloud por coste real y disponibilidad educativa.
3. Mantener Hadoop/HDFS como fundamento si lo pide la normativa, pero conectarlo con arquitecturas actuales.
4. Alinear UD4, UD5 y UD6 para que BI, orquestación, MLlib y proyecto integrador formen una progresión clara.
5. Convertir los packs ZIP útiles en carpetas fuente documentadas, dejando ZIPs sólo como distribución o archivo.
6. Separar definitivamente correcciones y entregas del material docente principal.
7. Añadir en cada unidad una tabla de relación aproximada con RA/CE cuando se revise la normativa.

La base está bastante bien, pero está mezclada. El siguiente trabajo importante no es “crear más material”; es **ordenar el material bueno para que cada cosa tenga una función clara**.
