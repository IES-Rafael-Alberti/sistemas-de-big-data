# Matriz de alineación curricular — SBD vs Big Data Aplicado

## 1. Resumen ejecutivo

La copia reorganizada de **Sistemas de Big Data** contiene materiales que cubren bien los RA/CE de SBD, pero también incluye bloques que, por enfoque aplicado, monitorización, operación de servicios, BI de negocio o solución completa para cliente, encajan mejor o al menos de forma compartida con **Big Data Aplicado**.

Encajan claramente en **Sistemas de Big Data**:

- Fundamentos de Big Data, arquitecturas batch/streaming, Lambda/Kappa y capas.
- Almacenamiento, NoSQL, integración, ingesta, calidad, RGPD y seguridad.
- Procesamiento distribuido con Spark como evolución práctica de Hadoop/HDFS.
- Cuadros de mando y visualización cuando el foco es configurar herramientas y analizar datos.
- ML distribuido con Spark MLlib cuando se usa para técnicas de análisis y modelos predictivos.

Parecen más propios de **Big Data Aplicado** o compartibles:

- Laboratorios de monitorización/observabilidad con Prometheus, Grafana y Kibana.
- Soluciones cloud concretas con AWS, DynamoDB, RDS, EC2 o Step Functions cuando el foco sea resolver un caso extremo a extremo.
- Orquestación operativa con Airflow/Mage AI si se evalúa como solución desplegada o pipeline de negocio.
- BI aplicado a modelo de negocio, cliente final, interpretación y toma de decisiones.
- Proyecto integrador si se plantea como solución completa de negocio.

Materiales transversales:

- Python, pandas, notebooks, CSV/JSON/Parquet, Docker, Git y datasets.
- Spark/PySpark: puede servir a SBD como sistema/procesamiento y a Big Data Aplicado como aplicación sobre problemas reales.
- Power BI/Metabase/Superset: SBD los cubre por cuadros de mando y visualización; Big Data Aplicado los cubre por BI aplicada al negocio.

Tensión principal detectada: la normativa menciona herramientas y enfoques clásicos —Hadoop, HDFS, MapReduce, Pig, Hive, Sqoop, Oozie, Jobtracker/Namenode, Ganglia—, pero la práctica actual suele trabajar con Spark/PySpark, notebooks, servicios cloud, herramientas BI modernas, orquestadores y observabilidad actual. La decisión docente razonable es usar RA/CE como marco obligatorio y reinterpretar herramientas obsoletas cuando una alternativa actual evidencie el mismo criterio.

## 2. Criterios usados para decidir

- **Mandato principal**: RA y CE son la parte obligatoria. Contenidos básicos y orientaciones ayudan, pero no mandan por encima de RA/CE.
- **SBD** prioriza integración, procesamiento, análisis, sistemas, almacenamiento, cuadros de mando y visualización dentro de soluciones Big Data.
- **Big Data Aplicado** prioriza solución aplicada, ecosistemas de almacenamiento, integridad, monitorización, estabilidad de servicios y BI orientada a negocio/cliente.
- Una herramienta actual puede sustituir a una antigua si permite evidenciar el mismo RA/CE con más realismo profesional.
- Hadoop/HDFS se mantiene como base conceptual o histórica cuando sea útil, pero Spark/PySpark/MLlib son más defendibles como práctica actual.
- Las herramientas cloud se valoran por encaje curricular, coste, disponibilidad educativa y riesgo de facturación. AWS Academy y tiers gratuitos permiten cubrir parte del currículo, pero no todo.
- No se propone borrar ni mover nada todavía: sólo marcar decisiones provisionales.

## 3. Matriz principal de materiales

| Material | Unidad actual | Herramientas / tecnologías | RA/CE Sistemas de Big Data | RA/CE Big Data Aplicado | Encaje mejor | Decisión provisional | Justificación | Revisión humana |
| -------- | ------------- | -------------------------- | -------------------------- | ----------------------- | ------------ | -------------------- | ------------- | --------------- |
| `ud01-introduccion-big-data/01-teoria/UD1_01_BigData101.md` y dossier UD1 | UD1 | Big Data, arquitecturas, HDFS, Spark, conceptos | SBD RA1, RA3, RA4 | BDA RA1, RA2 | Sistemas de Big Data | mantener_en_sbd | Base conceptual necesaria para entender sistemas, almacenamiento, procesamiento y visualización. | No |
| `ud01-introduccion-big-data/01-teoria/UD1_02_EDA_y_calidad.md` | UD1 | EDA, Python, pandas, calidad | SBD RA1, RA2 | BDA RA5, RA3 | Ambos | compartir_entre_modulos | En SBD introduce análisis/calidad; en BDA sirve para limpieza, transformación y BI. | Sí |
| `ud01-introduccion-big-data/01-teoria/UD1-Parte2/` | UD1 | DuckDB, MongoDB, NoSQL, SQL, PyMongo | SBD RA1, RA3 | BDA RA1, RA2 | Sistemas de Big Data | mantener_en_sbd | Buen bloque de fundamentos de almacenamiento y búsqueda en grandes conjuntos. | No |
| `ud01-introduccion-big-data/01-teoria/UD1-Parte3/` | UD1 | Batch, streaming, Lambda, Kappa | SBD RA1, RA3, RA4 | BDA RA2 | Sistemas de Big Data | mantener_en_sbd | Arquitecturas de sistemas Big Data: base previa a aplicación. | No |
| `ud01-introduccion-big-data/03-practicas/UD1-Parte2/lab_p2_modelado_documental_analitico/` | UD1 | JSON, Parquet, DuckDB | SBD RA1.c-d, RA3.a-d | BDA RA1.a-c | Sistemas de Big Data | mantener_en_sbd | Modelado y formatos encajan con gestión/almacenamiento y construcción de datasets complejos. | No |
| `ud01-introduccion-big-data/03-practicas/UD1-Parte4/lab_p3_eda_calidad_duckdb/` | UD1 | DuckDB, Parquet, EDA, calidad | SBD RA1, RA3 | BDA RA3, RA5 | Ambos | compartir_entre_modulos | Calidad y EDA son fundamento SBD y también técnica aplicada BDA. | Sí |
| `ud01-introduccion-big-data/04-evaluacion/UD1_03_Tarea_y_rubrica.md` | UD1 | EDA, Parquet, calidad | SBD RA1, RA3 | BDA RA3, RA5 | Ambos | compartir_entre_modulos | Evaluación útil para evidenciar análisis y calidad; puede reutilizarse en BDA con enfoque negocio. | Sí |
| `ud02-almacenamiento-ingesta/01-teoria/001-008*.md` | UD2 | Almacenamiento, HDFS, SQL/NoSQL, MongoDB, Cassandra, Hadoop, Spark, cloud | SBD RA1, RA3, RA4 | BDA RA1, RA2, RA3 | Sistemas de Big Data | mantener_en_sbd | Núcleo de almacenamiento, sistemas y tecnologías Big Data. | No |
| `ud02-almacenamiento-ingesta/01-teoria/005-IntegracionTransferenciaDatos*.md` | UD2 | Airbyte, Debezium, integración, transferencia | SBD RA1.c-f, RA3.a-d | BDA RA1.b-d | Sistemas de Big Data | mantener_en_sbd | La ingesta e integración son centrales para SBD; BDA podría reutilizar prácticas aplicadas. | Sí |
| `ud02-almacenamiento-ingesta/01-teoria/UD2_01_Problema_y_arquitectura.md` | UD2 | Arquitectura de datos, ingesta | SBD RA1, RA3 | BDA RA1 | Sistemas de Big Data | mantener_en_sbd | Define arquitectura y problema del sistema. | No |
| `ud02-almacenamiento-ingesta/01-teoria/UD2_02_Ingesta_scripts_y_Airbyte.md` | UD2 | Python, pandas, Airbyte OSS | SBD RA1.c-f, RA3.a | BDA RA1.b-d | Sistemas de Big Data | mantener_en_sbd | La ingesta es base de sistema; vigilar viabilidad de Airbyte. | Sí |
| `ud02-almacenamiento-ingesta/01-teoria/UD2_03_Integracion_y_calidad_incremental.md` | UD2 | Joins, upsert, calidad, ETL | SBD RA1.c-d, RA3.a-d | BDA RA3, RA5.b | Ambos | compartir_entre_modulos | En SBD se ve integración; en BDA calidad/integridad y transformación aplicada. | Sí |
| `ud02-almacenamiento-ingesta/01-teoria/UD2_04_RGPD_y_seguridad.md` | UD2 | RGPD, seguridad | SBD RA3.d | BDA RA1, RA2 | Transversal | compartir_entre_modulos | Normativa y seguridad atraviesan ambos módulos. | Sí |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/002/TareaHDFS.md` | UD2 | HDFS, Parquet | SBD RA3.c-d, RA4.c | BDA RA2, RA3 | Ambos | mantener_como_base_conceptual | HDFS está menos vigente, pero evidencia almacenamiento distribuido e integridad. | Sí |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/003/` | UD2 | AWS, EC2, RDS, DynamoDB, Spark/Hadoop | SBD RA1.f-g, RA3 | BDA RA1, RA2 | Big Data Aplicado | candidato_big_data_aplicado | Caso cloud aplicado y de solución; el límite real es coste/tier gratuito/AWS Academy. | Sí |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/004/ActividadCassandraMongoDB.md` | UD2 | MongoDB, Cassandra | SBD RA3 | BDA RA1, RA2 | Sistemas de Big Data | mantener_en_sbd | Comparativa de almacenamiento NoSQL; útil como sistema y diseño de datos. | No |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/005/` | UD2 | Airbyte, Redpanda, Python, integración, calidad | SBD RA1.c-f, RA3 | BDA RA1, RA5 | Ambos | compartir_entre_modulos | Pipeline moderno: sistema en SBD, caso aplicado en BDA. Revisar coste/cloud. | Sí |
| `ud02-almacenamiento-ingesta/04-evaluacion/UD2_05_Tarea_y_rubrica.md` | UD2 | Ingesta, calidad, integración | SBD RA1, RA3 | BDA RA1, RA3, RA5 | Ambos | compartir_entre_modulos | Buena tarea evaluativa puente. | Sí |
| `ud03-procesamiento-distribuido/01-teoria/` | UD3 | Spark, Kibana/Grafana, Zeppelin | SBD RA1, RA3, RA4 | BDA RA2, RA4 | Sistemas de Big Data | mantener_en_sbd | Procesamiento distribuido es núcleo del sistema; monitorización puede compartirse. | Sí |
| `ud03-procesamiento-distribuido/03-practicas/Spark_Labs/` | UD3 | Spark, PySpark, datasets | SBD RA1.b-f, RA3.d, RA4.d-e | BDA RA2.b, RA5 | Sistemas de Big Data | mantener_en_sbd | Spark sustituye de forma razonable a parte de la pila clásica Hadoop/MapReduce. | No |
| `ud03-procesamiento-distribuido/03-practicas/Kibana_Labs/` | UD3 | Kibana, Elastic, dashboards | SBD RA2, RA4 | BDA RA4, RA5 | Big Data Aplicado | candidato_big_data_aplicado | Si el foco es seguimiento, visualización operacional o análisis de servicio, BDA encaja mejor. | Sí |
| `ud03-procesamiento-distribuido/03-practicas/Prometheus_grafana_lab/` | UD3 | Prometheus, Grafana | SBD RA4 | BDA RA4 | Big Data Aplicado | candidato_big_data_aplicado | Monitorización, métricas, alertas y estabilidad son RA4 de BDA de forma clarísima. | Sí |
| `ud03-procesamiento-distribuido/04-evaluacion/Spark_Labs/` | UD3 | Spark, rúbricas | SBD RA1, RA3 | BDA RA2 | Sistemas de Big Data | mantener_en_sbd | Evaluación directa de procesamiento distribuido. | No |
| `ud03-procesamiento-distribuido/99-profesor/` | UD3 | Spark, Kibana, Zeppelin | SBD RA1, RA3, RA4 | BDA RA2, RA4 | Transversal | mantener_como_recurso_profesor | Guías internas útiles para decidir enfoque y adaptar prácticas. | Sí |
| `ud04-bi-orquestacion/01-teoria/Parte-I_BI/` | UD4 | Metabase, Superset, Power BI, dashboards | SBD RA2, RA4 | BDA RA5 | Ambos | compartir_entre_modulos | SBD cubre cuadros de mando; BDA cubre BI aplicada a negocio. | Sí |
| `ud04-bi-orquestacion/01-teoria/ParteII-Orquestacion/` | UD4 | Airflow, Mage AI, pipelines | SBD RA1.f-g, RA3, RA4.d-e | BDA RA1, RA2, RA4 | Ambos | compartir_entre_modulos | Orquestación puede ser sistema en SBD o solución aplicada/operativa en BDA. | Sí |
| `ud04-bi-orquestacion/01-teoria/ParteII-Orquestacion/practica/mage_ai_pack/` | UD4 | Mage AI, Docker, Python, pipelines | SBD RA1.f, RA3, RA4 | BDA RA1, RA2 | Big Data Aplicado | candidato_big_data_aplicado | Pack de solución aplicada/pipeline; mantener copia en SBD sólo si se usa como ejemplo de sistema. | Sí |
| `ud04-bi-orquestacion/01-teoria/UD4_13_BI_Comparativa_Metabase_Superset_PowerBI.md` | UD4 | Metabase, Superset, Power BI | SBD RA2, RA4 | BDA RA5 | Ambos | compartir_entre_modulos | Comparativa de herramientas: útil en SBD y decisión aplicada en BDA. | No |
| `ud04-bi-orquestacion/03-practicas/Lab1_Metabase/` | UD4 | Metabase, BI | SBD RA2, RA4 | BDA RA5 | Ambos | compartir_entre_modulos | Cuadro de mando sencillo y BI de negocio. | Sí |
| `ud04-bi-orquestacion/03-practicas/Lab2_Superset/` | UD4 | Superset, BI | SBD RA2, RA4 | BDA RA5 | Ambos | compartir_entre_modulos | Igual que Metabase, con más complejidad de instalación. | Sí |
| `ud04-bi-orquestacion/03-practicas/Lab3_miniProy/` | UD4 | BI, dashboards, proyecto | SBD RA2, RA4, RA1.g | BDA RA5 | Big Data Aplicado | candidato_big_data_aplicado | Mini-proyecto de negocio/decisión encaja con validación BI de BDA. | Sí |
| `ud04-bi-orquestacion/03-practicas/Lab4_Airflow/` | UD4 | Airflow, DAGs, Python | SBD RA1.f, RA3, RA4.d-e | BDA RA1, RA2, RA4 | Ambos | compartir_entre_modulos | Airflow es sistema/orquestación en SBD y operación/aplicación en BDA. | Sí |
| `ud04-bi-orquestacion/03-practicas/Lab5_Sesion_PowerBI/` | UD4 | Power BI, dashboards | SBD RA2, RA4 | BDA RA5 | Ambos | compartir_entre_modulos | En SBD sirve para visualización; en BDA para BI aplicada al negocio. | Sí |
| `ud05-spark-mllib/01-teoria/` | UD5 | Spark MLlib, ML, pipelines | SBD RA1, RA2.d, RA4.d-e | BDA RA5 | Sistemas de Big Data | mantener_en_sbd | La normativa SBD incluye técnicas predictivas complejas y análisis; MLlib es defensa práctica actual. | Sí |
| `ud05-spark-mllib/02-ejemplos/` | UD5 | PySpark, MLlib, Colab, datasets | SBD RA1.b, RA2.d, RA3 | BDA RA5 | Sistemas de Big Data | mantener_en_sbd | Ejemplos técnicos de ML distribuido; útiles como soporte. | No |
| `ud05-spark-mllib/03-practicas/` | UD5 | Spark, MLlib, regresión, clasificación | SBD RA1, RA2.d-e | BDA RA5 | Ambos | compartir_entre_modulos | Si el foco es técnica y sistema: SBD; si es modelo de negocio/decisión: BDA. | Sí |
| `ud05-spark-mllib/04-evaluacion/*` | UD5 | Spark MLlib, rúbricas | SBD RA1, RA2 | BDA RA5 | Ambos | compartir_entre_modulos | Evaluación defendible en SBD; podría adaptarse a BDA con caso de negocio. | Sí |
| `ud06-proyecto-integrador/01-teoria/UD6_Proyecto_Integrador_BigData_BI_ML.md` | UD6 | Big Data, BI, ML | SBD RA1-RA4 | BDA RA1-RA5 | Ambos | compartir_entre_modulos | Proyecto integrador puede cerrar SBD o actuar como caso aplicado transversal. | Sí |
| `ud06-proyecto-integrador/01-teoria/UD6_Proyectos_Modelo_Propuestos.md` | UD6 | Predicción, ventas, BI, ML | SBD RA1, RA2 | BDA RA5 | Big Data Aplicado | candidato_big_data_aplicado | Propuestas de negocio y toma de decisiones encajan fuerte con BDA RA5. | Sí |
| `00-recursos-comunes/pendiente_revision/mlops_cloud/` | General | AWS, MLOps, monitoring | SBD RA1.g, RA3 | BDA RA1, RA4, RA5 | Big Data Aplicado | candidato_big_data_aplicado | MLOps/cloud/monitoring son más aplicados; revisar coste y alcance. | Sí |
| `00-recursos-comunes/pendiente_revision/notebooks/lab_MLMLDD.ipynb` | General | Notebook, ML | SBD RA1, RA2.d | BDA RA5 | Revisión docente | archivar_o_revisar | Falta contexto: no clasificar sin abrir y validar propósito. | Sí |

## 4. Herramientas y encaje curricular

| Herramienta | Materiales asociados | Encaje RA/CE SBD | Encaje RA/CE Big Data Aplicado | Riesgo / limitación | Decisión provisional |
| ----------- | -------------------- | ---------------- | ------------------------------ | ------------------- | -------------------- |
| Hadoop / HDFS | UD1 arquitecturas, UD2 HDFS, TareaHDFS | SBD RA3.c-d, RA4.c | BDA RA2, RA3 | Tecnología clásica/menos usada; útil para concepto de distribución, redundancia e integridad. | mantener_como_base_conceptual |
| Spark / PySpark | UD2, UD3 Spark Labs, UD5 ejemplos/prácticas | SBD RA1, RA2.d, RA3, RA4.d-e | BDA RA2.b, RA5 | Requiere entorno estable; mucho más actual que MapReduce/Pig/Hive para aula. | mantener_en_sbd_y_compartir |
| Spark MLlib | UD5, UD4 Mage AI + MLlib | SBD RA1.b, RA2.d-e | BDA RA5 | Puede ser demasiado ML si no se conecta con Big Data distribuido. | compartir_entre_modulos |
| DuckDB | UD1 EDA/modelado, UD1 calidad | SBD RA1, RA3 | BDA RA1, RA5 | No es distribuido, pero excelente para bajo coste y aprendizaje de formatos/SQL/Parquet. | mantener_en_sbd |
| FireDuck | UD1 tutorial | SBD RA1, RA3 | BDA RA1 | Archivado: paquete no disponible en PyPI (jun 2026). | archivado |
| MongoDB / Cassandra | UD1/UD2 NoSQL | SBD RA3 | BDA RA1, RA2 | Cassandra puede requerir actualización; MongoDB sigue siendo didáctico. | mantener_en_sbd |
| Airbyte / Debezium | UD2 integración | SBD RA1.c-f, RA3.a | BDA RA1.b-d | Airbyte no es ruta principal; queda como optativa si hay servidor Proxmox. dlt cubre la ruta obligatoria. | mantener_en_sbd_como_optativa |
| Redpanda / Kafka | UD2 pipelines/streaming, UD1 arquitectura | SBD RA1, RA3, RA4.d | BDA RA1, RA2 | Coste/cloud y complejidad; mejor como ampliación si no hay tiempo. | compartir_o_revisar |
| AWS / AWS Academy / EC2 / RDS / DynamoDB | UD2 cloud, tareas AWS, recursos MLOps | SBD RA1.g, RA3 | BDA RA1, RA2, RA5 | AWS Academy queda como optativa UD2 (S3 + Glue + Athena) si el lab lo permite; cloud avanzado/MLOps pasa mejor a BDA. | sbd_optativa_y_bda_avanzado |
| Google Cloud / Azure | UD2 cloud | SBD RA3 | BDA RA1, RA2 | Coste y cuentas educativas. | mantener_como_comparativa |
| Metabase / Superset | UD4 BI Labs | SBD RA2, RA4 | BDA RA5 | Instalación y mantenimiento; Superset puede ser más pesado. | compartir_entre_modulos |
| Power BI | UD4 teoría/lab | SBD RA2, RA4 | BDA RA5 | Licencias, cuentas, equipos del centro. | compartir_entre_modulos |
| Airflow | UD4 Lab Airflow | SBD RA1.f, RA4.d-e | BDA RA1, RA2, RA4 | Pesado para aula; fuerte valor profesional. | compartir_con_revision |
| Mage AI | UD4 práctica/pack | SBD RA1.f, RA3 | BDA RA1, RA2 | Ver continuidad del proyecto, instalación y Docker. | candidato_big_data_aplicado |
| Grafana / Prometheus | UD3 monitorización | SBD RA4 | BDA RA4 | Muy claro para monitorización; más BDA que SBD si el foco es operación. | candidato_big_data_aplicado |
| Kibana / Elastic | UD3 labs | SBD RA4 | BDA RA4, RA5 | Coste/stack/viabilidad. | candidato_big_data_aplicado |
| Docker | Packs y laboratorios | SBD RA1.f, RA3 | BDA RA1, RA2, RA4 | Apoyo técnico imprescindible, no siempre objetivo evaluable. | recurso_transversal |
| Notebooks / Colab | UD1, UD5, recursos | SBD RA1, RA2 | BDA RA5 | Colab facilita bajo coste, pero no sustituye sistemas reales si el RA exige entorno. | recurso_transversal |

## 5. Materiales candidatos a Big Data Aplicado

| Material | Unidad actual | Motivo | RA/CE Big Data Aplicado relacionado | Qué pasaría con SBD |
| -------- | ------------- | ------ | ----------------------------------- | ------------------- |
| `ud03-procesamiento-distribuido/03-practicas/Prometheus_grafana_lab/` | UD3 | Monitorización, métricas, alertas y estabilidad. | BDA RA4.a-f | SBD puede conservar mención como visualización/observabilidad, pero no debería ocupar demasiado. |
| `ud03-procesamiento-distribuido/03-practicas/Kibana_Labs/` | UD3 | Visualización operacional y análisis con stack específico. | BDA RA4, RA5 | SBD puede dejarlo como ampliación o ejemplo de visualización. |
| `ud04-bi-orquestacion/03-practicas/Lab3_miniProy/` | UD4 | Mini-proyecto de cuadro de mando aplicado a toma de decisiones. | BDA RA5.a-f | SBD puede conservar versión corta para RA2/RA4. |
| `ud04-bi-orquestacion/01-teoria/ParteII-Orquestacion/practica/mage_ai_pack/` | UD4 | Pack de solución pipeline aplicada con Docker/Mage. | BDA RA1, RA2 | SBD puede mantener la teoría de orquestación, no necesariamente todo el pack. |
| `ud04-bi-orquestacion/03-practicas/Lab4_Airflow/` | UD4 | Orquestación operacional y DAGs; fuerte componente aplicado. | BDA RA1, RA2, RA4 | SBD puede mantener conceptos de pipeline/orquestación. |
| `ud04-bi-orquestacion/03-practicas/Lab5_Sesion_PowerBI/` | UD4 | BI orientada a resultados de negocio. | BDA RA5 | SBD conserva cuadro de mando básico si se necesita RA2/RA4. |
| `ud05-spark-mllib/03-practicas/` | UD5 | ML aplicado puede encajar con BI/decisión si se orienta a negocio. | BDA RA5 | SBD mantiene ML distribuido técnico; BDA adapta caso de negocio. |
| `ud06-proyecto-integrador/01-teoria/UD6_Proyectos_Modelo_Propuestos.md` | UD6 | Propuestas orientadas a predicción, ventas y negocio. | BDA RA5 | SBD conserva proyecto integrador técnico o versión reducida. |
| `00-recursos-comunes/pendiente_revision/mlops_cloud/` | General | MLOps/cloud/monitoring aplicado. | BDA RA1, RA4, RA5 | Revisar si alguna parte sirve como ejemplo de arquitectura SBD. |
| `ud02-almacenamiento-ingesta/03-practicas/Tareas/003/` | UD2 | AWS SQL/NoSQL y despliegue cloud de solución. | BDA RA1, RA2 | SBD puede mantener comparativa de almacenamiento/cloud sin práctica completa. |

## 6. Materiales que deben quedarse en Sistemas de Big Data

| Material | Unidad actual | RA/CE SBD relacionado | Motivo |
| -------- | ------------- | --------------------- | ------ |
| UD1 fundamentos y arquitecturas | UD1 | RA1, RA3, RA4 | Base conceptual del módulo. |
| UD1 modelado documental/analítico | UD1 | RA1.c-d, RA3 | Construcción de datasets, formatos y relaciones. |
| UD2 almacenamiento e ingesta | UD2 | RA1, RA3 | Núcleo de almacenamiento, integración y tratamiento de datos. |
| UD2 NoSQL MongoDB/Cassandra | UD2 | RA3 | Gestión de datos y sistemas de almacenamiento. |
| UD2 RGPD y seguridad | UD2 | RA3.d | Normativa y seguridad dentro de sistemas Big Data. |
| UD3 Spark Labs | UD3 | RA1, RA3, RA4 | Procesamiento distribuido actual y defendible frente a pila Hadoop clásica. |
| UD4 comparativa BI | UD4 | RA2, RA4 | Clasificación y selección de herramientas de cuadros de mando. |
| UD5 teoría Spark MLlib | UD5 | RA1, RA2.d-e | Técnicas predictivas complejas sobre ecosistema Big Data. |

## 7. Material transversal o compartible

| Material | Uso en SBD | Uso en Big Data Aplicado | Recomendación |
| -------- | ---------- | ------------------------ | ------------- |
| Python/pandas/notebooks | Apoyo para análisis, ingesta y prototipado. | Apoyo para solución aplicada y presentación de resultados. | Mantener como herramienta transversal. |
| CSV/JSON/Parquet | Formatos y almacenamiento. | Formatos para resolver casos de negocio. | Compartir criterios y datasets. |
| Spark/PySpark | Procesamiento distribuido/sistemas. | Procesamiento aplicado a casos reales. | SBD base técnica; BDA aplicación. |
| BI con Metabase/Superset/Power BI | Cuadros de mando y visualización. | BI de negocio y toma de decisiones. | Compartir, pero cambiar enfoque evaluativo. |
| Airflow/Mage AI | Orquestación de sistemas/pipelines. | Soluciones aplicadas y operación. | Compartir o mover parte práctica avanzada a BDA. |
| Docker | Entornos reproducibles. | Despliegue de soluciones. | Recurso técnico común. |
| RGPD/calidad | Seguridad, normativa, calidad. | Integridad y fiabilidad de soluciones. | Mantener transversal. |

## 8. Material histórico, obsoleto o dudoso

| Material | Problema detectado | Valor posible | Decisión provisional |
| -------- | ------------------ | ------------- | -------------------- |
| Hadoop/HDFS/MapReduce como eje principal | Menos representativo de práctica actual. | Base conceptual de almacenamiento distribuido, redundancia e integridad. | mantener_como_base_conceptual |
| Pig/Hive/Flume/Sqoop/Oozie mencionados en normativa | Anticuados para práctica actual general. | Referencia histórica para explicar evolución del ecosistema. | archivar_o_mencionar_breve |
| Zeppelin | Puede estar desplazado por notebooks/Colab/Jupyter. | Mostrar ecosistema histórico de Spark. | revision_docente |
| FireDuck | Archivado — paquete no disponible en PyPI (jun 2026). | N/A | archivado |
| AWS cloud avanzado | Coste y riesgo de facturación. | AWS Academy para práctica parcial S3 + Glue + Athena. | optativa_ud2_y_bda_avanzado |
| Redpanda/Airbyte Cloud | Límites gratuitos y cambios de producto. | Airbyte en servidor propio si se instala; Redpanda queda como referencia/ampliación. | optativa_o_archivo |
| MLOps root packs | Falta contexto curricular claro. | Podrían encajar en BDA si se orientan a solución/monitorización. | revision_docente |
| `lab_MLMLDD.ipynb` | Falta contexto. | Posible recurso ML. | revision_docente |
| `skill_builder/Skill Builder Meetings.html` | Pertenencia dudosa al módulo. | Puede ser recurso externo/documental. | archivar_o_revisar |

## 9. Recomendaciones para la siguiente fase

1. No mover aún materiales físicamente entre módulos.
2. Revisar con calma los candidatos a Big Data Aplicado de la sección 5.
3. Crear una columna de decisión docente final: `se_queda`, `se_duplica`, `se_adapta`, `se_mueve`, `se_archiva`.
4. Para cada candidato, decidir si se mueve completo, se duplica parcialmente o se deja como referencia transversal.
5. Separar enfoque técnico de enfoque aplicado:
   - SBD: sistemas, herramientas, procesamiento, almacenamiento, cuadros de mando.
   - BDA: solución, operación, monitorización, cliente, BI aplicada y decisión de negocio.
6. Preparar infraestructura opcional: Airbyte en Proxmox y AWS Academy (S3, Glue, Athena). No bloquea la ruta principal con dlt.
7. Mantener Hadoop/HDFS como concepto si ayuda a RA/CE, pero no convertirlo en el centro práctico salvo que sea estrictamente necesario.
8. Usar Spark/PySpark/MLlib como reinterpretación moderna y defendible de procesamiento distribuido y análisis Big Data.
9. Preparar después un plan de cambios físicos sobre la copia: mover/duplicar/adaptar sólo lo validado por el docente.
