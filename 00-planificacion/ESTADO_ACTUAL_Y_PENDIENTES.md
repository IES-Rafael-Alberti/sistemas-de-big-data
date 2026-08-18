# Estado actual y pendientes — SBD 2026/2027

Este documento es la **fuente única de seguimiento** para saber qué está terminado, qué queda abierto y qué notas antiguas deben leerse como históricas.

## Lectura rápida

| Bloque | Estado actual | Qué hacer |
| ------ | ------------- | -------- |
| Reorganización gruesa y fina | ✅ Cerrada | No reabrir salvo incidencias concretas. |
| Sitio público MkDocs | ✅ Cerrado en forma | Mantenerlo sin material interno, docente o archivado; regenerar en destino si se copia con Unison. |
| UD1 — revisión didáctica | ✅ Revisada | Usarla como referencia para el resto de unidades. |
| UD2–UD6 — revisión didáctica | ✅ Cerrada | UD2, UD3, UD4, UD5 y UD6 revisadas. |
| Alineación curricular RA/CE | ✅ Criterio cerrado | Aplicarlo al revisar cada unidad; no mover materiales sin revisión de unidad. |
| Arquitecturas Big Data / Medallion | ✅ Cerrado | Mantener como núcleo lakehouse/Medallion + streaming-first; no abrir más arquitecturas salvo necesidad concreta. |
| Infraestructura docente | ✅ Preparada en documentación | Validar acceso real a Airbyte/Postgres y AWS Academy antes de clase. |

## Criterio de verdad actual

En un momento anterior la reforma se dio por concluida. Después, al revisar con más detalle, se detectaron materiales incompletos, huecos didácticos y tareas nuevas. Por tanto:

- Las menciones antiguas a “reforma completa” son **históricas**.
- Este documento manda sobre listas antiguas de pendientes.
- Los documentos de informe siguen siendo útiles como evidencia de lo hecho, pero no como estado vivo.

## Bloques de seguimiento

### 1. Alineación curricular RA/CE

**Estado:** criterio docente cerrado.

La separación entre **Sistemas de Big Data** y **Big Data Aplicado** queda definida por enfoque evaluativo:

- **SBD**: sistema, arquitectura, integración, almacenamiento, procesamiento, calidad, seguridad, cuadros de mando técnicos y elección de herramientas.
- **Big Data Aplicado**: solución aplicada, cliente, negocio, explotación, monitorización de servicios, estabilidad, BI final y toma de decisiones.

No se deben mover materiales físicamente todavía. La decisión debe aplicarse al revisar cada unidad, separando qué queda como ruta principal SBD, qué queda como ampliación, qué se archiva y qué se deja preparado para BDA.

Decisiones principales:

- Power BI completo y MLOps/cloud avanzado quedan como material para BDA o archivo en SBD.
- Spark/PySpark, Spark Structured Streaming, almacenamiento, ingesta, calidad, RGPD y Medallion quedan como núcleo SBD.
- Metabase/Superset, Airflow, AWS Academy y proyecto integrador son compartidos, pero con enfoque evaluativo distinto.
- Grafana/Kibana/Prometheus deben tratarse como BDA o ampliación compartida salvo que se reduzcan a visualización técnica mínima.

Fuentes:

- `00-planificacion/matriz_alineacion_curricular_sbd_bigdata_aplicado.md`
- `00-planificacion/herramientas_usadas_curso.md`

### 2. Revisión didáctica de UD2–UD6

**Estado:** cerrada.

UD1 se revisó en profundidad y UD2–UD6 ya tienen revisión didáctica cerrada. La revisión incluyó ruta pública, navegación, foco evaluativo SBD/BDA, prácticas principales, ampliaciones y actualización de estado.

Acciones por unidad:

| Unidad | Revisión pendiente |
| ------ | ------------------ |
| UD2 — Almacenamiento e ingesta | ✅ Revisada: se reforzó la ruta didáctica, mini-ingesta, calidad operativa, RGPD, métricas y costes. |
| UD3 — Procesamiento distribuido | ✅ Revisada: se reforzó la ruta Spark, Parquet, particionado, benchmark y streaming; Kibana/Grafana quedan como ampliación. |
| UD4 — BI y orquestación | ✅ Revisada: se reforzó ruta BI técnica/orquestación, modelo estrella, ejemplos correcto/incorrecto de dashboard y flujo pipeline → dashboard. |
| UD5 — Spark MLlib | ✅ Revisada: se reforzó criterio antes del código, features, métricas, baseline, errores comunes y conexión con notebooks/ejemplos. |
| UD6 — Proyecto integrador | ✅ Revisada: se reforzó ruta por fases, separación SBD/BDA/PIA, plantillas por fase y entregables mínimos aceptables. |

Fuente:

- `00-planificacion/PENDIENTES_REVISION_CONTENIDOS.md`

### 3. Arquitecturas Big Data / Medallion

**Estado:** cerrado.

Ya se amplió la teoría de arquitectura y se creó una actividad Medallion. También se creó una práctica local UD2 con flujo:

```text
raw CSV/JSON → Bronze Parquet → Silver limpio → Gold consultable → DuckDB/Spark
```

Decisiones cerradas:

- La actividad de diseño Medallion de UD1 queda fijada en **parejas**. No se convierte en mini-proyecto porque su función es preparar criterio arquitectónico antes de la práctica técnica.
- La práctica local Medallion de UD2 queda formalizada como evaluable mediante `ud02-almacenamiento-ingesta/04-evaluacion/UD2_Practica_Medallion_Entrega_y_Rubrica.md`.
- La conexión SBD/BDA queda delimitada: SBD evalúa arquitectura, ingesta, capas, formato, calidad, procesamiento y consulta técnica; BDA puede reutilizar Gold para BI de negocio y toma de decisiones.
- La revisión posterior de arquitecturas confirma como núcleo **lakehouse/Medallion** y **event-driven/streaming-first**. `Data products/Data Mesh` se incluye como modelo organizativo; `Data Fabric`, `HTAP` y microservicios quedan como mención contextual, no como práctica central.

Fuentes:

- `00-planificacion/nota_pendiente_mejora_arquitecturas.md`
- `00-planificacion/INFORME_REFORMA_ARQUITECTURAS.md`
- `00-planificacion/INFORME_HUECO_HADOOP_SPARK.md`
- `00-planificacion/INFORME_PRACTICA_LOCAL_MEDALLION.md`

### 4. Infraestructura docente no bloqueante

**Estado:** documentación preparada; validación técnica pendiente antes de usarla en clase.

Las prácticas principales funcionan con herramientas locales. Las ampliaciones de infraestructura quedan preparadas así:

- Airbyte se asume ya instalado en servidor Proxmox.
- El destino Airbyte queda fijado como **Postgres**, no DuckDB.
- AWS Academy queda preparada para S3 + Glue Crawler + Athena, con plan B si los permisos del laboratorio no permiten completar la práctica.
- Antes de impartirla hay que validar acceso real desde el aula, credenciales, conectores, Postgres y permisos AWS Academy.

Fuente:

- `00-planificacion/ESTADO_REFORMA_SBD_2026_2027.md`
- `ud02-almacenamiento-ingesta/05-recursos/practica-herramientas-reales/README.md`
- `ud02-almacenamiento-ingesta/05-recursos/practica-herramientas-reales/airbyte-comparativa.md`
- `ud02-almacenamiento-ingesta/05-recursos/practica-herramientas-reales/aws-ingesta-serverless.md`

### 5. Sitio público MkDocs

**Estado:** cerrado en forma; requiere regeneración si se copia entre equipos.

El sitio público se genera con MkDocs y no debe tratarse como fuente canónica:

- `site/` está ignorado en Git; no se versiona la salida generada.
- La publicación se construye desde Markdown con `mkdocs build --strict`.
- Al copiar el repositorio con **Unison**, los enlaces simbólicos pueden no copiarse correctamente. En el equipo de destino hay que regenerar el sitio siguiendo el checklist de abajo en lugar de confiar en una copia previa de `site/`.
- Si se usa otro ordenador, comprobar primero que el entorno de MkDocs está instalado y después ejecutar el build estricto antes de publicar.

**Checklist de regeneración en destino:**

```bash
# 1. Crear symlinks de unidades (nav_generator.py los necesita)
cd docs
ln -sf ../ud01-introduccion-big-data    ud01-introduccion-big-data
ln -sf ../ud02-almacenamiento-ingesta   ud02-almacenamiento-ingesta
ln -sf ../ud03-procesamiento-distribuido ud03-procesamiento-distribuido
ln -sf ../ud04-bi-orquestacion          ud04-bi-orquestacion
ln -sf ../ud05-spark-mllib              ud05-spark-mllib
ln -sf ../ud06-proyecto                 ud06-proyecto
cd ..

# 2. Crear symlinks de plantillas
ln -sf 00-planificacion/plantillas     plantillas
ln -sf ../00-planificacion/plantillas  docs/plantillas

# 3. Asegurar que mkdocs + tema material están instalados
#    (si no: pip install mkdocs mkdocs-material)

# 4. Build estricto
mkdocs build --strict
```

Validación conocida:

- `mkdocs build --strict` pasa correctamente.
- Los mensajes de anclas antiguas en UD1 aparecen como `INFO`, no como errores bloqueantes.

## Continuación sin memoria externa

Si se retoma este repositorio desde otro ordenador o sin memoria de sesión, leer primero este documento y después revisar los últimos commits locales.

Últimos bloques cerrados:

| Commit | Bloque cerrado | Qué quedó hecho |
| ------ | -------------- | --------------- |
| `c4e311b` | Medallion evaluable | Se formalizó la entrega/rúbrica de la práctica Medallion de UD2 y se cerró la conexión curricular SBD/BDA. |
| `c5fe9b5` | Arquitecturas Big Data | Se ampliaron las arquitecturas relevantes: lakehouse/Medallion y event-driven/streaming-first como núcleo; Data Mesh como contexto organizativo; Data Fabric/HTAP/microservicios como menciones. |
| `b5ac37b` | Airbyte + AWS Academy | Se prepararon las prácticas optativas de herramientas reales: Airbyte sobre Proxmox con destino Postgres y AWS Academy con S3, Glue Crawler y Athena, incluyendo plan B y limpieza. |
| `bf1c600` | Estado portable | Se actualizó este documento para poder continuar desde otro equipo sin depender de memoria externa. |
| `dacf6a5`–`61af324` | Sincronización y limpieza | Exclusión de material profesor/privado en `.gitignore`, commits temáticos de UD1 a UD6, limpieza de borradores/notebooks ajenos en UD5 y subida completa a GitHub. |

Estado operativo actual:

- La ruta principal del curso queda cubierta con herramientas locales: Python, dlt, DuckDB, Parquet y Spark/PySpark.
- Airflow es la única herramienta de orquestación evaluable de UD4. Mage AI se retiró de la ruta activa y se trasladó a `90-archivo/mage-ai/`: no debe recuperarse salvo revisión docente expresa. Si en el futuro se necesitara una alternativa, se evaluarán Prefect, Dagster o Kestra desde una necesidad didáctica concreta.
- Airbyte y AWS Academy son ampliaciones realistas, no bloqueantes ni imprescindibles para evaluar UD2.
- No hay que depender de Engram para saber qué se hizo: este fichero es la fuente viva de continuidad.
- Antes de impartir las ampliaciones hay que validar infraestructura real: URL/credenciales Airbyte, conectividad a Postgres, conectores disponibles, permisos AWS Academy, región y salida Athena.

## Correcciones verificadas

- Mage AI se archivó y dejó de ser una alternativa activa o evaluable frente a Airflow.
- La tabla RA/CE de UD03 ya marca Grafana y Kibana como ampliación.
- `mkdocs build --strict` genera correctamente la página y navegación de `ud06-proyecto/guion_proyecto.md`.

## Elementos que NO son pendientes vivos

Estos elementos pueden aparecer con palabras como “pendiente”, “revisar” o casillas `[ ]`, pero no deben tratarse automáticamente como tareas abiertas del curso:

- `00-planificacion/prompt_*`: instrucciones históricas de trabajo.
- `00-planificacion/plantillas/*`: plantillas para alumnado/profesorado; sus casillas vacías son parte del uso normal.
- Informes de cierre anteriores: documentan decisiones ya tomadas, aunque incluyan secciones de pendientes ya absorbidas aquí.
- Material en `90-archivo/`: archivo histórico salvo que este documento diga expresamente que hay que recuperarlo.

## Orden recomendado de trabajo

1. **Validación técnica de infraestructura**: hacer solo antes de impartir las ampliaciones Airbyte/AWS. No bloquea la ruta principal del curso.
2. **Mantenimiento normal**: cualquier cambio nuevo debe actualizar este documento y quedar en un commit de unidad de trabajo.

## Regla de mantenimiento

Cuando aparezca un pendiente nuevo:

1. Añadirlo aquí.
2. Si procede, enlazar el informe o documento donde se detectó.
3. No crear nuevas listas paralelas de pendientes salvo que sean checklists internas de una tarea concreta.

## Pendientes finales

1. [ ] **Prefect / Big Data Aplicado:** consultar con su profesorado la propuesta de piloto en `00-planificacion/PROPUESTA_PREFECT_BIG_DATA_APLICADO.md`. No modifica Airflow ni la evaluación de SBD.
2. [ ] **Infraestructura de ampliaciones:** antes de impartir Airbyte o AWS Academy, validar desde el aula la URL y credenciales de Airbyte, conectividad y conectores de Postgres, y permisos, región y salida Athena de AWS Academy.
3. [ ] **Cambio de equipo con Unison:** regenerar el sitio en destino con `mkdocs build --strict` después de reconstruir los enlaces simbólicos indicados en este documento.
