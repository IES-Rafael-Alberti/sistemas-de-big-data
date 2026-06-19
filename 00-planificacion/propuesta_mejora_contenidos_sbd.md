# Propuesta de mejora de contenidos — Sistemas de Big Data 2026/2027

## 1. Resumen ejecutivo

El núcleo de **Sistemas de Big Data** debe mantenerse alrededor de sistemas, arquitectura, integración, procesamiento, almacenamiento, calidad, visualización técnica y selección razonada de herramientas. La separación con **Big Data Aplicado** no debe vaciar SBD: debe quitarle peso a lo demasiado aplicado/operacional y reforzar su identidad técnica.

Se mantiene como núcleo de SBD:

- Fundamentos de Big Data, arquitecturas batch/streaming, Lambda/Kappa y capas.
- Modelado, formatos y almacenamiento: CSV, JSON, Parquet, SQL/NoSQL, DuckDB, MongoDB, Cassandra, HDFS como concepto.
- Ingesta e integración: scripts, Airbyte/Debezium como aproximación moderna, calidad incremental y RGPD.
- Procesamiento distribuido con Spark/PySpark como práctica principal, contextualizando Hadoop/MapReduce como antecedente.
- Cuadros de mando y visualización técnica para análisis, no tanto BI de negocio profundo.
- ML distribuido con Spark MLlib cuando se enfoque como técnica de análisis Big Data.

Queda como candidato a Big Data Aplicado:

- Monitorización/observabilidad profunda: Prometheus, Grafana, Kibana como operación de servicios.
- Cloud aplicado extremo a extremo: AWS EC2/RDS/DynamoDB/Step Functions si se evalúa como solución cliente.
- Orquestación operativa avanzada con Airflow/Mage AI cuando sea pipeline desplegado.
- BI orientada a negocio: mini-proyectos, Power BI aplicado y propuestas de predicción/ventas.
- MLOps/cloud packs sin contexto claro.

Huecos que aparecen en SBD si se reduce lo aplicado:

- Falta una práctica clara de arquitectura Big Data moderna sin depender de cloud de pago.
- Falta una actividad corta de evaluación de coste/calidad/viabilidad de sistemas Big Data.
- Falta una visualización técnica alternativa si parte de BI se lleva a BDA.
- Falta una práctica compacta de pipeline local reproducible que cubra ingesta → almacenamiento → procesamiento → visualización técnica.
- Falta una explicación explícita de “Hadoop como concepto histórico vs Spark como práctica actual”.

Herramientas a mantener como principales: Python, pandas, DuckDB, Parquet, MongoDB, Spark/PySpark, Spark MLlib, Docker básico y una herramienta BI ligera como Metabase o Superset según viabilidad.

Herramientas a contextualizar: Hadoop/HDFS, MapReduce, Pig/Hive/Sqoop/Oozie, Zeppelin.

Herramientas a revisar por coste/viabilidad: AWS, Airbyte Cloud, Redpanda Cloud, Power BI, Superset, Airflow, Mage AI.

## 2. Identidad curricular propuesta para SBD

**Sistemas de Big Data** debe ser el módulo donde el alumnado entiende y practica cómo se construye técnicamente un sistema Big Data: cómo se integran datos, cómo se almacenan, cómo se procesan, cómo se evalúa su calidad, cómo se visualizan resultados y cómo se eligen herramientas con criterios de coste, rendimiento, seguridad y viabilidad.

La parte aplicada a cliente, negocio, operación avanzada, monitorización de servicios y BI como solución empresarial debe coordinarse con **Big Data Aplicado**.

SBD no debe convertirse en “un catálogo de herramientas”. Debe enseñar criterios: por qué usar una arquitectura, un formato, un motor, una librería o una plataforma.

## 3. Mapa RA/CE de Sistemas de Big Data

| RA/CE SBD | Cobertura actual | Materiales actuales | Problema detectado | Mejora propuesta | Prioridad |
| --------- | ---------------- | ------------------- | ------------------ | ---------------- | --------- |
| RA1.a matemática/lógica/complejidad aplicada | Baja / discutible | Nota del profesor en RA/CE; algunos materiales de EDA/ML | El contenido normativo no encaja bien con lo visto; sería más útil estadística descriptiva y calidad de datos. | Crear una cápsula “estadística útil para Big Data”: distribución, correlación, outliers, métricas de calidad y coste computacional básico. | media |
| RA1.b extracción automática de información/conocimiento | Media | UD1 EDA, UD5 MLlib, notebooks | Riesgo de que ML quede demasiado aplicado a BDA si se orienta a negocio. | Mantener MLlib como técnica de análisis Big Data y crear práctica corta de extracción de patrones con Spark/PySpark. | alta |
| RA1.c combinación de fuentes y tipos de datos | Alta | UD1 JSON/Parquet/DuckDB; UD2 integración; UD2 prácticas | Bien cubierto, pero disperso. | Consolidar una práctica integradora local con CSV+JSON+Parquet y trazabilidad. | alta |
| RA1.d construcción de dataset complejo y relaciones | Alta | UD1 modelado documental/analítico; UD2 integración/calidad | Bien cubierto, pero conviene hacerlo más explícito en evaluación. | Añadir checklist de dataset complejo: fuentes, esquema, relaciones, formato, calidad, particionado. | media |
| RA1.e planificación y organización | Baja / implícita | Proyecto integrador, prácticas | No aparece como entregable claro. | Añadir plantilla de planificación técnica por práctica: objetivos, tareas, tiempos, riesgos. | media |
| RA1.f selección e integración de sistemas de información | Media | Airbyte, Mage/Airflow, Docker, prácticas UD2/UD4 | Parte puede migrar a BDA si es solución aplicada. | Mantener en SBD una comparativa de integración: script vs herramienta ETL vs orquestador, sin exigir despliegue complejo. | alta |
| RA1.g coste y calidad de implementación Big Data | Baja / dispersa | Cloud, AWS, informe de inventario | Cloud tiene coste y restricciones; no hay actividad clara de decisión coste/calidad. | Crear actividad “matriz coste-calidad-viabilidad”: local vs cloud vs servicio gestionado. | alta |
| RA2.a librerías e implementaciones de representación | Media | UD4 comparativa BI, Metabase/Superset/Power BI | Se solapa con BDA. | Mantener comparativa técnica de herramientas y criterios de selección. | media |
| RA2.b objetivo y naturaleza de datos | Media | UD4 BI, UD1 EDA | Puede quedar demasiado negocio si se lleva a BDA. | Reforzar análisis técnico: tipo de dato, agregación, latencia, granularidad, visualización adecuada. | media |
| RA2.c cuadro de mando sencillo | Alta | Metabase, Superset, Power BI | Parte BI aplicada podría moverse a BDA. | Mantener un dashboard técnico mínimo con Metabase o DuckDB + visualización ligera. | alta |
| RA2.d técnicas predictivas complejas | Media | UD5 Spark MLlib | Bien defendible, pero debe centrarse en Big Data distribuido. | Mantener UD5 y añadir nota de frontera: técnica en SBD, caso negocio en BDA. | alta |
| RA2.e impacto del análisis en objetivos | Media | UD4/UD5/UD6 | Puede ser más BDA si se orienta a cliente. | En SBD evaluarlo como impacto técnico/calidad de decisión, no como caso empresarial completo. | media |
| RA3.a extracción y almacenamiento desde diversas fuentes | Alta | UD2 ingesta, Airbyte, scripts, datasets | Bien cubierto. | Consolidar práctica local reproducible sin depender de cloud. | alta |
| RA3.b tecnologías eficientes para extraer valor | Media | DuckDB, Spark, Parquet, cloud | Falta comparativa explícita. | Crear comparativa: DuckDB vs Spark vs pandas según volumen/coste/infraestructura. | alta |
| RA3.c almacenar/procesar grandes cantidades | Media | Hadoop/HDFS, Spark, Parquet | Hadoop clásico no debe dominar. | Mantener HDFS como concepto; practicar Spark + Parquet particionado. | alta |
| RA3.d gestión, almacenamiento, procesamiento eficiente y seguro con normativa | Media | RGPD, seguridad, calidad, UD2 | Normativa aparece aislada. | Integrar RGPD/seguridad en práctica de ingesta/calidad con checklist obligatorio. | media |
| RA3.e habilidades científicas multidisciplinares | Baja / implícita | EDA, ML, proyecto | No está operacionalizado. | Añadir entregable de interpretación técnica: hipótesis, métricas, limitaciones, sesgos. | baja |
| RA4.a escenarios y datos no estructurados | Media | NoSQL, JSON, MongoDB, Kibana | Se puede reforzar. | Añadir mini-práctica JSON/logs/documentos: estructura, consulta, visualización. | media |
| RA4.b BI para extracción de valor | Alta | UD4 BI | Parte aplicada puede ir a BDA. | Mantener BI técnica mínima y pasar caso negocio profundo a BDA. | media |
| RA4.c almacenamiento distribuido/redundante en clúster | Media | HDFS/Hadoop, Spark | Falta práctica actual ligera. | Crear explicación comparativa HDFS/S3/Parquet/lakehouse y práctica simulada/local. | alta |
| RA4.d diferencias entre aplicaciones de procesamiento rápido/eficiente | Media | Spark, DuckDB, pandas, Airflow/Mage | Bien, pero falta comparativa formal. | Añadir benchmark didáctico pequeño: pandas vs DuckDB vs Spark local. | alta |
| RA4.e programación y procesamiento automático de estructura de datos | Media | scripts, Airflow, Mage, PySpark | Si Airflow/Mage pasa a BDA, queda hueco de automatización. | Mantener automatización sencilla con scripts Makefile/Python o notebook parametrizado; dejar Airflow como ampliación. | alta |
| RA4.f formas de visualizar datos | Alta | Metabase, Superset, Power BI, Grafana/Kibana | Grafana/Kibana quizá BDA; Power BI quizá BDA. | Mantener una visualización técnica mínima en SBD y enviar BI/monitorización profunda a BDA. | media |

## 4. Contenidos que se mantienen y se refuerzan

| Bloque | Materiales actuales | Por qué se mantiene | Mejora recomendada |
| ------ | ------------------- | ------------------- | ------------------ |
| Fundamentos y arquitecturas Big Data | UD1 teoría, arquitecturas batch/streaming/Lambda/Kappa | Es base para RA1, RA3 y RA4. | Añadir cierre explícito “qué se practica hoy y qué queda como historia”. |
| Modelado y formatos | UD1 DuckDB, JSON, Parquet, MongoDB; UD2 almacenamiento | Cubre construcción de datasets y almacenamiento. | Consolidar fuentes y eliminar duplicados; mantener Markdown como fuente. |
| Ingesta e integración | UD2 scripts, Airbyte, integración incremental | Cubre RA1.c-f y RA3.a. | Crear práctica local reproducible que no dependa de servicios cloud. |
| Calidad, seguridad y RGPD | UD1 EDA/calidad; UD2 RGPD | Cubre RA3.d y conecta con RA1/RA3. | Integrar checklist de calidad/seguridad en todas las prácticas de datos. |
| Procesamiento distribuido | UD3 Spark Labs, UD5 Spark MLlib | Es el sustituto práctico razonable frente a Hadoop clásico. | Reforzar Spark/PySpark con explicación comparativa frente a MapReduce/HDFS. |
| Visualización técnica | UD4 Metabase/Superset/Power BI, UD1/UD4 EDA | Cubre RA2 y RA4. | Mantener un dashboard técnico mínimo; separar BI negocio para BDA. |
| Técnicas predictivas | UD5 MLlib | Cubre RA2.d y RA1.b. | Enfatizar ML distribuido y evaluación técnica; negocio en BDA. |

## 5. Contenidos candidatos a Big Data Aplicado y sustitución en SBD

| Contenido/material candidato a BDA | Motivo | RA/CE SBD que deja hueco | Sustitución o refuerzo propuesto para SBD | Acción recomendada |
| --------------------------------- | ------ | ------------------------ | --------------------------------------- | ------------------ |
| Prometheus/Grafana lab | Monitorización/alertas/estabilidad encaja mejor con BDA RA4. | SBD RA4.f visualización técnica. | Mantener en SBD una demo breve de métricas; pasar laboratorio completo a BDA. | mantener_resumen_en_sbd |
| Kibana Labs | Observabilidad/análisis operacional encaja con BDA RA4/RA5. | SBD RA4.a/f datos no estructurados y visualización. | Sustituir por mini-práctica de logs JSON + consulta + visualización simple. | crear_sustituto_sbd |
| AWS EC2/RDS/DynamoDB tasks | Solución cloud aplicada y coste/riesgo. | SBD RA1.g, RA3 almacenamiento/cloud. | Crear actividad comparativa cloud/local con AWS Academy opcional, sin depender de ejecución completa. | duplicar_y_adaptar_para_bda |
| Mage AI pack | Pipeline aplicado/desplegado con Docker. | SBD RA1.f, RA4.e automatización. | Mantener teoría de pipeline y práctica local con scripts o notebook parametrizado; Mage como ampliación. | dejar_como_ampliacion |
| Airflow Lab completo | Orquestación operacional pesada. | SBD RA1.f, RA4.e. | Mantener DAG conceptual y alternativa ligera con Python + cron/Makefile o Prefect/Mage demo si viable. | mantener_resumen_en_sbd |
| Mini-proyecto BI UD4 | Toma de decisiones negocio. | SBD RA2/RA4 dashboard. | Mantener dashboard técnico mínimo; mover caso de negocio completo a BDA. | duplicar_y_adaptar_para_bda |
| Power BI sesión | BI negocio/licencias. | SBD RA2/RA4 visualización. | Mantener comparativa y una demo corta; usar Metabase/DuckDB/Notebook si Power BI falla. | mantener_resumen_en_sbd |
| Proyecto integrador negocio | Solución aplicada completa. | SBD RA1-RA4 cierre integrador. | Crear proyecto corto técnico de sistema Big Data, no necesariamente negocio completo. | crear_sustituto_sbd |
| MLOps/cloud packs | Enfoque aplicado/operacional. | SBD RA1.g y RA3 si habla de arquitectura. | Revisar y rescatar sólo arquitectura/coste; dejar MLOps operativo para BDA. | revisar_antes_de_mover |

## 6. Contenido nuevo recomendado para SBD

| Nuevo contenido | RA/CE SBD que cubre | Tipo | Herramientas sugeridas | Justificación | Prioridad |
| --------------- | ------------------- | ---- | ---------------------- | ------------- | --------- |
| Cápsula “Hadoop histórico vs Spark actual” | RA3.c-d, RA4.c-d | teoría breve | Hadoop/HDFS, Spark, Parquet | Evita enseñar tecnología obsoleta como centro y justifica Spark frente a normativa. | alta |
| Práctica “pipeline local reproducible” | RA1.c-f, RA3.a-d, RA4.e | práctica guiada | Python, pandas, DuckDB, Parquet, Makefile/script | Sustituye parte de cloud/orquestación pesada con algo viable en aula. | alta |
| Benchmark didáctico pandas vs DuckDB vs Spark local | RA3.b-c, RA4.d | laboratorio | pandas, DuckDB, PySpark | Ayuda a elegir tecnología según volumen, coste y complejidad. | alta |
| Matriz coste-calidad-viabilidad de sistemas Big Data | RA1.g | checklist / actividad | Local, cloud, AWS Academy, Docker | Cubre un CE clave que ahora está disperso. | alta |
| Mini-práctica de logs JSON/no estructurados | RA4.a, RA4.f | práctica guiada | JSON, DuckDB/MongoDB, visualización simple | Sustituye Kibana profundo si pasa a BDA, manteniendo datos no estructurados. | media |
| Checklist de calidad, RGPD y seguridad por práctica | RA3.d | checklist | RGPD, calidad, anonimización básica | Integra normativa en prácticas reales. | media |
| Dashboard técnico mínimo | RA2.a-c, RA4.f | laboratorio | Metabase o DuckDB + notebook | Mantiene visualización en SBD sin convertirlo en BI de negocio. | alta |
| Práctica Spark + Parquet particionado | RA1.b, RA3.c-d, RA4.d-e | laboratorio | PySpark, Parquet | Refuerza procesamiento distribuido moderno. | alta |
| Rúbrica SBD común por RA/CE | RA1-RA4 | rúbrica | Markdown | Evita que cada práctica evalúe cosas inconexas. | media |
| Plantilla de planificación técnica de práctica | RA1.e | recurso profesor / plantilla alumnado | Markdown | Hace visible organización, tiempos, riesgos y decisiones técnicas. | media |

## 7. Herramientas recomendadas para SBD

| Herramienta | Papel en SBD | Estado | Motivo | Alternativa si falla |
| ----------- | ------------ | ------ | ------ | -------------------- |
| Python | Lenguaje base para ingesta, limpieza, scripts y ejemplos. | principal | Bajo coste, ubicuo, fácil de ejecutar. | Notebooks guiados o scripts preparados. |
| pandas | Prototipado y transformación inicial. | principal | Buen puente hacia límites de memoria y necesidad de Big Data. | DuckDB para datasets medianos. |
| DuckDB | SQL local, Parquet, análisis rápido. | principal | Excelente para aula sin cloud y para explicar formatos/consultas. | SQLite + pandas, aunque peor para Parquet. |
| Parquet | Formato columnar principal. | principal | Muy vigente y conecta con Spark/lakehouse. | CSV como entrada, no como formato final. |
| MongoDB | NoSQL documental. | principal | Didáctico y vigente. | JSON + DuckDB para simplificar. |
| Cassandra | Comparativa NoSQL distribuida. | apoyo | Útil para discutir diseño distribuido, pero no necesariamente práctica profunda. | Explicación comparativa sin despliegue. |
| Hadoop/HDFS | Concepto histórico de distribución/redundancia. | contexto histórico | Sirve para RA/CE de clúster e integridad, pero no debe dominar. | Spark + Parquet + explicación de lakehouse. |
| Spark/PySpark | Procesamiento distribuido moderno. | principal | Sustituto práctico razonable de pila Hadoop clásica. | Spark local/Colab si no hay clúster. |
| Spark MLlib | Técnicas predictivas distribuidas. | principal | Cubre RA2.d sin desplazar todo a BDA. | scikit-learn para prototipo, explicando límite. |
| Airbyte | Ingesta con herramienta moderna. | pendiente de viabilidad | Buena herramienta, pero instalación/cambios de producto pueden molestar. | Scripts Python + CSV/API. |
| Debezium/Redpanda/Kafka | Streaming/integración avanzada. | apoyo | Útil para arquitectura, quizá excesivo para práctica central. | Simulación con archivos/eventos simples. |
| AWS/AWS Academy | Cloud y coste/calidad. | pendiente de viabilidad | Útil si hay cuentas y límites claros. | LocalStack, simulación o análisis comparativo. |
| Metabase | Dashboard técnico sencillo. | principal/apoyo | BI ligera y útil para RA2/RA4. | Notebook + gráficos o Superset si está montado. |
| Superset | BI más potente. | pendiente de viabilidad | Buena, pero instalación más pesada. | Metabase. |
| Power BI | Comparativa y demo. | mejor para BDA | Fuerte orientación negocio/licencias. | Metabase/Notebook en SBD. |
| Airflow | Orquestación conceptual. | apoyo | Profesional, pero pesado. | Script Python + Makefile/cron; Mage demo. |
| Mage AI | Pipeline moderno. | mejor para BDA | Más aplicado/desplegado. | Práctica local simplificada. |
| Grafana/Prometheus/Kibana | Observabilidad. | mejor para BDA | Encajan más con monitorización de servicios. | Demo corta o lectura en SBD. |
| Docker | Entornos reproducibles. | apoyo | Necesario para muchas prácticas. | Conda/venv si Docker falla. |
| Google Colab | Ejecución accesible. | apoyo | Bajo coste y reduce instalación. | Entorno local preparado. |

## 8. Propuesta de estructura revisada por unidades

### UD1 — Introducción Big Data

- **Foco**: conceptos, arquitecturas, formatos, EDA/calidad básica y fundamentos de almacenamiento.
- **Mantener**: Big Data 101, arquitecturas batch/streaming/Lambda/Kappa, DuckDB, MongoDB básico, EDA/calidad.
- **Reducir/ampliación**: FireDuck y material duplicado de README/HTML/PDF.
- **Nuevo a crear**: cápsula “herramientas clásicas vs actuales” y checklist inicial de calidad/dataset.
- **Evaluación sugerida**: mini-práctica de modelado JSON/Parquet + informe de calidad.

### UD2 — Almacenamiento e ingesta

- **Foco**: almacenamiento, ingesta, integración, formatos, seguridad, RGPD y coste/calidad.
- **Mantener**: almacenamiento distribuido, NoSQL, cloud comparativo, Airbyte/scripts, integración incremental, RGPD.
- **Reducir/ampliación**: tareas AWS profundas si dependen de coste/cuentas; HDFS como práctica larga.
- **Nuevo a crear**: práctica local reproducible de ingesta → Parquet → calidad → consulta; matriz coste-calidad.
- **Evaluación sugerida**: tarea de integración/calidad con checklist técnico y decisión de herramienta.

### UD3 — Procesamiento distribuido

- **Foco**: Spark/PySpark, procesamiento eficiente, comparación con ecosistema Hadoop clásico.
- **Mantener**: Spark Labs, teoría de procesamiento distribuido.
- **Reducir/ampliación**: Kibana/Grafana/Prometheus como laboratorio completo si pasa a BDA; Zeppelin como histórico/ampliación.
- **Nuevo a crear**: benchmark pandas vs DuckDB vs Spark; práctica Spark + Parquet particionado.
- **Evaluación sugerida**: laboratorio Spark con justificación de rendimiento/formato.

### UD4 — Visualización técnica y orquestación ligera

- **Foco**: cuadros de mando técnicos, comparativa de herramientas BI y automatización simple de pipeline.
- **Mantener**: comparativa Metabase/Superset/Power BI, lab Metabase/Superset reducido, conceptos Airflow/Mage.
- **Reducir/ampliación**: mini-proyecto BI negocio, Power BI profundo, Airflow/Mage desplegado completo.
- **Nuevo a crear**: dashboard técnico mínimo y práctica de automatización ligera sin infraestructura pesada.
- **Evaluación sugerida**: dashboard técnico + breve justificación de herramienta, datos y objetivo.

### UD5 — Spark MLlib

- **Foco**: técnicas predictivas en contexto Big Data distribuido.
- **Mantener**: teoría MLlib, ejemplos PySpark, laboratorios de regresión/clasificación.
- **Reducir/ampliación**: enfoque de negocio profundo, que puede pasar a BDA.
- **Nuevo a crear**: guía de frontera scikit-learn vs Spark MLlib y checklist de evaluación técnica del modelo.
- **Evaluación sugerida**: práctica MLlib con interpretación técnica, métricas y limitaciones.

### UD6 — Proyecto integrador técnico

- **Foco**: integración técnica de sistema Big Data, no solución empresarial completa.
- **Mantener**: proyecto integrador Big Data + BI + ML como cierre técnico.
- **Reducir/ampliación**: propuestas centradas en predicción de negocio/ventas como candidatas a BDA.
- **Nuevo a crear**: proyecto corto “sistema Big Data mínimo”: ingesta, almacenamiento, procesamiento, dashboard técnico y coste/calidad.
- **Evaluación sugerida**: rúbrica por RA/CE SBD, no por éxito comercial del caso.

## 9. Backlog accionable

| Tarea | Unidad | Tipo | Prioridad | Resultado esperado |
| ----- | ------ | ---- | --------- | ------------------ |
| Crear cápsula “Hadoop histórico vs Spark actual” | UD1/UD3 | teoría breve | alta | Documento claro para justificar sustitución práctica. |
| Crear práctica local ingesta → Parquet → DuckDB/Spark | UD2 | práctica guiada | alta | Sustituir dependencia de cloud para RA1/RA3. |
| Crear benchmark pandas vs DuckDB vs Spark | UD3 | laboratorio | alta | Evidenciar eficiencia y selección de herramientas. |
| Crear matriz coste-calidad-viabilidad | UD2/UD6 | checklist | alta | Cubrir RA1.g de forma explícita. |
| Crear dashboard técnico mínimo | UD4 | laboratorio | alta | Mantener RA2/RA4 sin depender de BI negocio profundo. |
| Crear guía scikit-learn vs Spark MLlib | UD5 | teoría breve | media | Aclarar cuándo ML es Big Data y cuándo no. |
| Crear rúbrica común SBD por RA/CE | Todas | rúbrica | media | Evaluación más coherente. |
| Crear plantilla de planificación técnica | Todas | plantilla | media | Evidenciar RA1.e. |
| ✅ Hecho — Archivado | Revisar FireDuck | UD1 | revisión docente | baja | Archivado: paquete `fireduck` no disponible en PyPI (jun 2026). Tutorial movido a `90-archivo/fireduck/`. |
| ✅ Hecho — Archivado para BDA | Revisar MLOps/cloud packs | General | revisión docente | media | Archivados en `ud04-bi-orquestacion/90-archivo/mlops-cloud-para-BDA/`. |
| ✅ Hecho — dlt + optativas | Revisar Airbyte/Redpanda viabilidad | UD2 | revisión técnica | media | Ruta principal con dlt; Airbyte queda como optativa si hay servidor; AWS Academy como alternativa real. |
| ✅ Hecho — Archivado para BDA | Revisar Power BI/licencias | UD4 | revisión técnica | media | Power BI práctico archivado para BDA; en SBD queda comparativa conceptual. |

## 10. Riesgos y decisiones pendientes

- **Riesgo de exceso de contenido**: SBD ya tiene mucho material. Antes de crear más, conviene consolidar y sustituir, no sólo añadir.
- **Riesgo cloud**: AWS, Redpanda, Airbyte Cloud y Power BI dependen de cuentas, límites y licencias. No deben ser el núcleo si no hay garantía de acceso.
- **Riesgo de obsolescencia normativa**: Hadoop/HDFS/MapReduce/Pig/Hive aparecen o se intuyen en contenidos clásicos, pero no deberían desplazar Spark/PySpark como práctica central.
- **Riesgo de solape con Big Data Aplicado**: BI negocio, monitorización y soluciones cloud completas deben coordinarse para no repetir módulos.
- **Decisión docente pendiente**: qué se duplica entre módulos y qué se mueve realmente.
- **Decisión docente pendiente**: si UD6 será proyecto técnico de SBD, proyecto aplicado compartido o puente hacia Big Data Aplicado.
- **Decisión docente pendiente**: herramienta BI principal de SBD: Metabase, Superset, Power BI o notebook/DuckDB.
- **Decisión docente pendiente**: profundidad real de Airflow/Mage AI en SBD.

La recomendación práctica es clara: SBD debe reforzar sistemas y criterios técnicos. Big Data Aplicado debe absorber la parte de solución, operación, cliente, monitorización y negocio. Pero no se mueve nada hasta validar esta propuesta y convertirla en tareas concretas.

## 11. Estado de ejecución de la propuesta (junio 2026)

La propuesta queda **ejecutada por completo** en la copia reorganizada 2026/2027.

Se han cubierto también los elementos que no estaban en el backlog principal pero
sí aparecían en el análisis:

- **Mini-práctica de logs JSON/no estructurados**: `ud01-introduccion-big-data/03-practicas/UD1-Parte4/lab_logs_json/`.
- **Checklist calidad/RGPD/seguridad**: `00-planificacion/plantillas/plantilla_checklist_calidad_rgpd.md`.
- **Proyecto integrador UD6**: `ud06-proyecto/guion_proyecto.md`, diseñado para coordinar SBD + BDA + PIA.
- **RA/CE completos**: `00-planificacion/matriz_ra_ce_materiales.md` confirma cobertura completa de RA1, RA2, RA3 y RA4.
- **Airbyte/AWS Academy**: documentados como optativas reales en UD2, sin bloquear la ruta principal basada en dlt.
