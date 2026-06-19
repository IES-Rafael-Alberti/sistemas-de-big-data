# Prompt para alineación curricular — Sistemas de Big Data vs Big Data Aplicado

## Objetivo

Analizar el material reorganizado del curso **Sistemas de Big Data 2026/2027** y marcar qué materiales encajan mejor en:

- **Sistemas de Big Data**
- **Big Data Aplicado**
- ambos módulos
- ninguno claramente, quedando pendientes de revisión docente

El objetivo NO es borrar ni mover materiales todavía.

El objetivo es crear una **matriz de alineación curricular** que ayude a decidir, en una fase posterior, qué materiales se mantienen en Sistemas de Big Data y cuáles serían más adecuados para Big Data Aplicado.

## Directorio de trabajo

Trabaja sobre la copia reorganizada:

`./`

No uses el curso original como destino de cambios.

## Entradas obligatorias

Usa estos archivos como fuentes principales:

- `00-planificacion/SistemasDeBIG_DATA-RAs_CE.md`
- `00-planificacion/BigDataAplicado-RAs_CE.md`
- `00-planificacion/herramientas_usadas_curso.md`
- `00-planificacion/inventario_material_sbd.md`
- `00-planificacion/INFORME_REORGANIZACION_FINA.md`

Puedes consultar también los README de cada unidad y los materiales concretos si necesitas contexto.

## Principio curricular fundamental

La parte esencial y obligatoria de la normativa son:

- los **Resultados de Aprendizaje (RA)**
- sus **Criterios de Evaluación (CE)** correspondientes

Estos son los elementos que deben guiar la decisión.

Otras partes del currículo, como:

- orientaciones pedagógicas,
- contenidos básicos,
- ejemplos de tecnologías,
- listados de herramientas,
- formulaciones históricas,

son útiles como contexto, pero son **orientativas** y pueden estar anticuadas respecto a las prácticas actuales del sector.

Por tanto:

> Si una práctica actual permite evidenciar un RA/CE aunque use herramientas distintas a las mencionadas en contenidos orientativos antiguos, puede considerarse curricularmente válida.

## Contexto tecnológico importante

Ten en cuenta que la normativa suele ser mucho más estática que el mercado tecnológico.

Ejemplos:

- La ley puede sugerir mucho contenido de Hadoop, pero en la práctica actual Hadoop clásico suele estar desplazado o contextualizado.
- Spark, PySpark, Spark MLlib y herramientas relacionadas pueden ser más representativas de la práctica real actual.
- Algunas tecnologías se mantienen por valor conceptual, aunque no sean la opción profesional dominante.
- Muchas herramientas cloud dependen del presupuesto, licencias y acceso educativo.
- Se usan tiers gratuitos o entornos educativos, por ejemplo AWS Academy, cuando permiten trabajar ciertos RA/CE.
- No siempre se puede practicar todo lo deseable en cloud por coste, límites de cuenta, restricciones del centro o riesgo de facturación.

No penalices automáticamente una herramienta por no aparecer literalmente en la normativa si permite evidenciar bien un RA/CE.

Tampoco fuerces tecnologías modernas dentro de RA/CE donde no encajan.

Hay que ajustar con criterio docente: a veces el encaje entre normativa y herramientas reales se hace “a martillazos”, pero debe quedar justificado.

## Regla de no destrucción

No borres materiales.

No muevas materiales.

No renombres materiales.

No edites materiales docentes durante esta fase.

Sólo puedes crear documentos de análisis dentro de:

`00-planificacion/`

## Qué debes producir

Genera este archivo:

`00-planificacion/matriz_alineacion_curricular_sbd_bigdata_aplicado.md`

## Estructura obligatoria del informe

```md
# Matriz de alineación curricular — SBD vs Big Data Aplicado

## 1. Resumen ejecutivo

Explica:

- Qué materiales encajan claramente en Sistemas de Big Data.
- Qué materiales parecen más propios de Big Data Aplicado.
- Qué materiales son transversales.
- Qué materiales requieren revisión docente.
- Qué tensiones aparecen entre normativa estática y práctica tecnológica actual.

## 2. Criterios usados para decidir

Incluye los criterios aplicados, dejando claro que:

- RA y CE mandan.
- Contenidos y orientaciones son apoyo contextual.
- Herramientas modernas pueden sustituir o reinterpretar tecnologías antiguas si evidencian el mismo RA/CE.
- Coste, disponibilidad educativa y viabilidad técnica importan.

## 3. Matriz principal de materiales

| Material | Unidad actual | Herramientas / tecnologías | RA/CE Sistemas de Big Data | RA/CE Big Data Aplicado | Encaje mejor | Decisión provisional | Justificación | Revisión humana |
| -------- | ------------- | -------------------------- | -------------------------- | ----------------------- | ------------ | -------------------- | ------------- | --------------- |

Valores sugeridos para `Encaje mejor`:

- `Sistemas de Big Data`
- `Big Data Aplicado`
- `Ambos`
- `Transversal`
- `Archivo / histórico`
- `Revisión docente`

Valores sugeridos para `Decisión provisional`:

- `mantener_en_sbd`
- `candidato_big_data_aplicado`
- `compartir_entre_modulos`
- `mantener_como_base_conceptual`
- `mantener_como_recurso_profesor`
- `archivar_o_revisar`

## 4. Herramientas y encaje curricular

| Herramienta | Materiales asociados | Encaje RA/CE SBD | Encaje RA/CE Big Data Aplicado | Riesgo / limitación | Decisión provisional |
| ----------- | -------------------- | ---------------- | ------------------------------ | ------------------- | -------------------- |

Ten en cuenta especialmente:

- Hadoop / HDFS
- Spark / PySpark / MLlib
- DuckDB
- MongoDB / Cassandra
- Airbyte / Debezium / Redpanda / Kafka
- AWS / AWS Academy / cloud tiers gratuitos
- Metabase / Superset / Power BI
- Airflow / Mage AI
- Grafana / Prometheus / Kibana
- Docker
- notebooks / Colab

## 5. Materiales candidatos a Big Data Aplicado

Lista materiales que parecen más adecuados para Big Data Aplicado, pero sin moverlos todavía.

| Material | Unidad actual | Motivo | RA/CE Big Data Aplicado relacionado | Qué pasaría con SBD |
| -------- | ------------- | ------ | ----------------------------------- | ------------------- |

## 6. Materiales que deben quedarse en Sistemas de Big Data

Lista materiales que parecen esenciales para Sistemas de Big Data.

| Material | Unidad actual | RA/CE SBD relacionado | Motivo |
| -------- | ------------- | --------------------- | ------ |

## 7. Material transversal o compartible

Lista materiales que podrían compartirse entre módulos.

| Material | Uso en SBD | Uso en Big Data Aplicado | Recomendación |
| -------- | ---------- | ------------------------ | ------------- |

## 8. Material histórico, obsoleto o dudoso

No descartes automáticamente.

Indica si sirve como:

- base conceptual,
- comparación histórica,
- archivo,
- material a sustituir,
- material pendiente de decisión.

| Material | Problema detectado | Valor posible | Decisión provisional |
| -------- | ------------------ | ------------- | -------------------- |

## 9. Recomendaciones para la siguiente fase

Propón una secuencia de trabajo para aplicar decisiones, sin hacer todavía cambios físicos.
```

## Reglas de razonamiento

- No confundas “herramienta antigua” con “material inútil”.
- No confundas “herramienta moderna” con “mejor encaje curricular”.
- Si un material evidencia bien un RA/CE, puede mantenerse aunque la herramienta sea discutible.
- Si un material usa herramientas muy aplicadas y encaja mejor con Big Data Aplicado, márcalo como candidato, pero no lo muevas.
- Si el encaje es dudoso, marca revisión humana.
- Si una herramienta cloud depende de coste o cuenta educativa, indícalo.
- Si el material sólo puede hacerse con tier gratuito limitado, indícalo.
- Si AWS Academy permite cubrir parte del RA/CE pero no todo lo deseable, explícitalo.

## Salida esperada

Un informe claro, útil para decidir después.

No debe ser una defensa burocrática de la ley.

Debe ser una herramienta práctica para organizar el curso real, respetando RA/CE pero adaptando tecnologías, servicios cloud, librerías y prácticas actuales a la realidad del aula.
