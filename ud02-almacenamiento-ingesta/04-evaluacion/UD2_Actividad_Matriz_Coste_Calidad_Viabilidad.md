# UD2 — Actividad: Matriz de coste, calidad y viabilidad

> **RA/CE**: RA1.g — Determinar criterios de coste y calidad necesarios para la
> eficacia y eficiencia de la implementación de un sistema Big Data.
>
> **Duración estimada**: 2 sesiones (una de investigación, una de puesta en común)
>
> **Entrega**: Individual o parejas. Documento Markdown o PDF con la matriz completada
> y las preguntas de reflexión respondidas.

---

## Contexto

Acabas de completar la práctica local Medallion donde construiste un pipeline:

```
CSV/JSONL raw → Bronze Parquet → Silver limpio → Gold consultable → DuckDB
```

Esa práctica usa una combinación de **Python + DuckDB + Parquet** en local. Pero
en un proyecto real te enfrentarías a decidir **qué herramientas usar** según el
contexto: presupuesto, equipo, volumen de datos, requisitos de calidad, etc.

En esta actividad vas a comparar tu pipeline local con otras alternativas reales
usando la **matriz de coste, calidad y viabilidad**.

---

## Objetivos

1. Aplicar criterios objetivos de coste y calidad para comparar alternativas técnicas.
2. Justificar decisiones de diseño de forma razonada y documentada.
3. Relacionar la selección de herramientas con el contexto del problema.

---

## Alternativas a comparar

Compara **4 enfoques** para implementar un pipeline de ingesta y almacenamiento:

| # | Alternativa | Descripción |
| - | ----------- | ----------- |
| 1 | **Local Python + DuckDB + Parquet** | Tu pipeline Medallion local. Sin cloud, sin Java, reproducible. |
| 2 | **Local con Spark/PySpark** | Mismo pipeline pero usando Spark DataFrame API para las transformaciones. |
| 3 | **Cloud (AWS Academy / servicio gestionado)** | Usar S3 + Glue/Athena o similar desde una cuenta AWS Academy. |
| 4 | **Herramienta ETL (Airbyte / Pentaho / talend)** | Ingesta y transformación vía herramienta visual o configurable. |

Puedes sustituir alguna alternativa por otra que conozcas mejor o que te interese
explorar (por ejemplo, Snowflake, Databricks, Google BigQuery, etc.).

---

## Instrucciones

### 1. Descarga la plantilla

Usa la plantilla transversal disponible en:

```
00-planificacion/plantillas/plantilla_matriz_coste_calidad_viabilidad.md
```

Copia la tabla y adáptala a tu comparación.

### 2. Investiga cada alternativa

Para cada una, dedica tiempo a buscar información realista:

- **Coste económico**: busca precios de licencias, créditos cloud, límites gratuitos.
- **Coste operativo**: ¿qué hay que instalar/configurar? ¿qué conocimientos previos requiere?
- **Calidad de datos**: ¿tiene validaciones incorporadas? ¿se puede auditar el pipeline?
- **Escalabilidad**: ¿aguanta 1 GB? ¿y 100 GB? ¿y 10 TB?
- **Seguridad**: ¿cómo maneja datos personales? ¿cifrado? ¿control de acceso?
- **Viabilidad en aula**: ¿se puede montar en 1 hora? ¿funciona sin internet?

### 3. Completa la matriz

Asigna valoraciones **1-5** a cada criterio para cada alternativa.
Cada valoración debe ir acompañada de una **justificación breve** (1-2 frases).

### 4. Responde las preguntas de reflexión

Las 6 preguntas de la plantilla. Son la parte más importante: demuestran que
entiendes los trade-offs, no solo que rellenas celdas.

### 5. Añade una conclusión personal

¿Qué alternativa elegirías para un proyecto real y por qué? ¿En qué circunstancias
elegirías otra?

---

## Criterios de evaluación

| Criterio | Peso | Excelente (4) | Notable (3) | Aprobado (2) | Insuficiente (1) |
| -------- | ---- | ------------- | ----------- | ------------ | ---------------- |
| **Matriz completa** | 30% | 4 alternativas valoradas con justificaciones concretas | 4 alternativas, justificaciones genéricas | 3 alternativas o justificaciones superficiales | <3 alternativas o sin justificaciones |
| **Reflexión crítica** | 40% | Muestra comprensión de trade-offs, compara y contrasta, identifica limitaciones | Reflexión adecuada pero sin profundidad | Reflexión superficial, no muestra comprensión real | Sin reflexión o copiada |
| **Conclusión razonada** | 20% | Decisión clara con criterios explícitos y condiciones de cambio | Decisión clara pero sin condiciones alternativas | Decisión vaga o sin justificación | Sin conclusión |
| **Formato y claridad** | 10% | Documento bien estructurado, tabla clara, sin errores | Aceptable, con pequeños errores de formato | Tabla desordenada o difícil de leer | Formato inaceptable |

---

## Referencias útiles

- [Precios AWS (free tier)](https://aws.amazon.com/free/)
- [Precios Databricks (community edition)](https://www.databricks.com/product/pricing)
- [Airbyte pricing](https://airbyte.com/pricing)
- [Apache Spark — documentación oficial](https://spark.apache.org/docs/latest/)
- [DuckDB — documentación](https://duckdb.org/docs/)

---

## Histórico de cambios

| Fecha       | Cambio |
| ----------- | ------ |
| 2026-06-18 | Creación de la actividad para UD2. |
