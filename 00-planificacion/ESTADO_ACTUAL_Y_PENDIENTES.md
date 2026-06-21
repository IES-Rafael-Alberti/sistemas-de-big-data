# Estado actual y pendientes — SBD 2026/2027

Este documento es la **fuente única de seguimiento** para saber qué está terminado, qué queda abierto y qué notas antiguas deben leerse como históricas.

## Lectura rápida

| Bloque | Estado actual | Qué hacer |
| ------ | ------------- | -------- |
| Reorganización gruesa y fina | ✅ Cerrada | No reabrir salvo incidencias concretas. |
| Sitio público MkDocs | ✅ Cerrado en forma | Mantenerlo sin material interno, docente o archivado. |
| UD1 — revisión didáctica | ✅ Revisada | Usarla como referencia para el resto de unidades. |
| UD2–UD6 — revisión didáctica | 🔴 Pendiente | Aplicar el mismo tipo de revisión hecha en UD1. |
| Alineación curricular RA/CE | ✅ Criterio cerrado | Aplicarlo al revisar cada unidad; no mover materiales sin revisión de unidad. |
| Arquitecturas Big Data / Medallion | 🟡 Parcialmente hecho | Revisar pendientes derivados y conexión curricular. |
| Infraestructura docente | 🟡 No bloqueante | Preparar Airbyte/AWS Academy si se quieren usar como ampliación. |

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

**Estado:** pendiente.

UD1 ya se revisó en profundidad: forma pública, redacción para alumnado, estadística, fórmulas, ejemplos, gráficas y notebook. Hay que hacer el mismo tipo de revisión en el resto.

Acciones por unidad:

| Unidad | Revisión pendiente |
| ------ | ------------------ |
| UD2 — Almacenamiento e ingesta | Comprobar que los conceptos se explican antes de las prácticas; reforzar ejemplos guiados, calidad, RGPD, formatos, costes y enlaces teoría-práctica. |
| UD3 — Procesamiento distribuido | Revisar explicación previa de Spark, particionado, Parquet y streaming; añadir diagramas o gráficas sobre rendimiento, latencia y throughput. |
| UD4 — BI y orquestación | Reforzar ejemplos visuales de BI, modelado, dashboards y orquestación; añadir criterios de diseño de dashboards. |
| UD5 — Spark MLlib | Evitar enfoque de receta; explicar métricas, features, entrenamiento, evaluación y errores comunes antes del código. |
| UD6 — Proyecto integrador | Hacer el guion más accionable: ejemplos de proyectos, entregables esperados, criterios de calidad y enlaces a plantillas. |

Fuente:

- `00-planificacion/PENDIENTES_REVISION_CONTENIDOS.md`

### 3. Arquitecturas Big Data / Medallion

**Estado:** parcialmente hecho, con flecos.

Ya se amplió la teoría de arquitectura y se creó una actividad Medallion. También se creó una práctica local UD2 con flujo:

```text
raw CSV/JSON → Bronze Parquet → Silver limpio → Gold consultable → DuckDB/Spark
```

Pendientes derivados:

- Revisar si la actividad Medallion debe ser individual, por parejas o mini-proyecto.
- Si se quiere evaluar formalmente la práctica local Medallion, crear versión cerrada en `04-evaluacion/` con plantilla de entrega y rúbrica separada.
- Conectar explícitamente la reforma de arquitecturas con la alineación RA/CE SBD / Big Data Aplicado.

Fuentes:

- `00-planificacion/nota_pendiente_mejora_arquitecturas.md`
- `00-planificacion/INFORME_REFORMA_ARQUITECTURAS.md`
- `00-planificacion/INFORME_HUECO_HADOOP_SPARK.md`
- `00-planificacion/INFORME_PRACTICA_LOCAL_MEDALLION.md`

### 4. Infraestructura docente no bloqueante

**Estado:** pendiente, pero no bloquea el curso.

Las prácticas principales funcionan con herramientas locales. Las tareas siguientes son ampliaciones o preparación docente:

- Instalar Airbyte 1.x en servidor Proxmox y verificar conectividad.
- Validar que AWS Academy permita S3, Glue Crawler y Athena en los laboratorios.
- Decidir si se mantiene DuckDB como destino Airbyte o se cambia a Postgres.

Fuente:

- `00-planificacion/ESTADO_REFORMA_SBD_2026_2027.md`

## Elementos que NO son pendientes vivos

Estos elementos pueden aparecer con palabras como “pendiente”, “revisar” o casillas `[ ]`, pero no deben tratarse automáticamente como tareas abiertas del curso:

- `00-planificacion/prompt_*`: instrucciones históricas de trabajo.
- `00-planificacion/plantillas/*`: plantillas para alumnado/profesorado; sus casillas vacías son parte del uso normal.
- Informes de cierre anteriores: documentan decisiones ya tomadas, aunque incluyan secciones de pendientes ya absorbidas aquí.
- Material en `90-archivo/`: archivo histórico salvo que este documento diga expresamente que hay que recuperarlo.

## Orden recomendado de trabajo

1. **Revisión UD2–UD6**: aplicar el estándar de UD1 unidad por unidad usando el criterio RA/CE ya cerrado.
2. **Flecos de arquitectura/Medallion**: cerrar formato evaluable y conexión curricular.
3. **Infraestructura docente**: preparar solo si se van a usar las ampliaciones Airbyte/AWS.

## Regla de mantenimiento

Cuando aparezca un pendiente nuevo:

1. Añadirlo aquí.
2. Si procede, enlazar el informe o documento donde se detectó.
3. No crear nuevas listas paralelas de pendientes salvo que sean checklists internas de una tarea concreta.
