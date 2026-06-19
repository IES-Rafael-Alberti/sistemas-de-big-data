# Informe — Reforma de arquitectura Big Data en UD1

## Resumen

Se ha reformado la parte de arquitectura de UD1 para que el bloque de Sistemas de Big Data trabaje arquitecturas actuales con más profundidad: principios, batch/streaming, Lambda, Kappa, arquitectura por capas, lakehouse y Medallion.

El objetivo no es añadir teoría decorativa, sino que el alumnado pueda justificar decisiones técnicas reales: ingesta, almacenamiento, formato, calidad, trazabilidad, procesamiento, coste y viabilidad en aula.

## Archivos afectados

| Archivo | Acción |
| ------- | ------ |
| `ud01-introduccion-big-data/01-teoria/UD1-Parte3/UD1-SGBD-Intro-P3.md` | Reescritura/ampliación del bloque de arquitecturas. |
| `ud01-introduccion-big-data/04-evaluacion/UD1-Parte3/UD1_P3_Actividad_Diseno_Arquitectura_Medallion.md` | Nueva actividad evaluable con caso práctico y rúbrica. |
| `ud01-introduccion-big-data/90-archivo/reforma-arquitecturas-2026/UD1-SGBD-Intro-P3_original_2026-06-17.md` | Copia de seguridad del material original. |
| `ud01-introduccion-big-data/README.md` | Actualizado para reflejar el nuevo material. |

## Criterios aplicados

- Mantener el foco en **Sistemas de Big Data**: arquitectura, almacenamiento, procesamiento, calidad y explotación técnica.
- Usar **Medallion** como estructura moderna comprensible: Bronze, Silver y Gold.
- Relacionar Medallion con Lambda/Kappa y arquitectura por capas, sin tratarlas como recetas cerradas.
- Priorizar tecnologías viables para el aula: Parquet, Spark/PySpark, DuckDB, notebooks y datasets locales.
- Dejar Big Data Aplicado para explotación orientada a negocio, producto, dashboards finales, decisiones operativas y casos aplicados.

## Referencias consultadas

- Aitor Medrano — Materiales IABD: https://aitor-medrano.github.io/iabd/
- Aitor Medrano — Arquitecturas Big Data: https://aitor-medrano.github.io/iabd/de/arq.html
- Databricks — Medallion lakehouse architecture: https://docs.databricks.com/en/lakehouse/medallion.html
- Microsoft Learn — Medallion lakehouse architecture: https://learn.microsoft.com/en-us/azure/databricks/lakehouse/medallion

## Nota sobre IA

La web externa consultada incluye materiales de IA, HuggingFace, datasets y aplicaciones tipo Gradio. No se incorporan como núcleo de esta reforma de arquitectura porque pertenecen mejor a proyectos integrados, pipelines de datos, PIA o Big Data Aplicado.

Sí pueden servir como conexión posterior si se diseña una práctica donde SBD prepare datasets o pipelines que luego otro módulo explote con IA o producto.

## Pendiente recomendado

- Revisar si la actividad Medallion debe ser individual, por parejas o como mini-proyecto.
- Crear una práctica técnica posterior que materialice el diseño: raw CSV/JSON → Bronze/Silver/Gold en Parquet → consulta con DuckDB o Spark.
- Conectar esta reforma con la fase de alineación curricular para marcar claramente qué queda en SBD y qué se deriva a Big Data Aplicado.
