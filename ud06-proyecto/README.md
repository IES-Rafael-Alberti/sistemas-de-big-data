# UD6 — Proyecto integrador

## Estructura

| Sección | Uso | Nº archivos |
| ------- | --- | ----------: |
| `01-teoria/` | Fuentes editables y apuntes principales. | 1 |
| `02-ejemplos/` | Notebooks, scripts y ejemplos no evaluables. | 1 |
| `03-practicas/` | Guiones de laboratorio y prácticas de aula. | 1 |
| `04-evaluacion/` | Enunciados evaluables, rúbricas y documentos de entrega. | 2 |
| `05-recursos/` | Datasets, imágenes, plantillas, ZIPs docentes y dependencias. | 1 |
| `90-archivo/` | Derivados publicados, histórico y material no canónico. | 1 |
| `99-profesor/` | Notas internas, guías docentes y corrección reutilizable. | 1 |

*Nota: La guía técnica principal del proyecto se centraliza en `guion_proyecto.md` en la raíz de esta unidad.*

## Naturaleza del proyecto

**Proyecto integrador multi-módulo**: SBD + Big Data Aplicado + Programación de IA.

No se plantean tres proyectos separados. El alumnado desarrolla **un único
proyecto común** y cada módulo evalúa su propia perspectiva sobre ese mismo
trabajo.

Los alumnos trabajan en el mismo proyecto, pero cada módulo evalúa su propia
perspectiva:

| Módulo | Enfoque | Evalúa |
|--------|---------|--------|
| **SBD** | Arquitectura, ingesta, almacenamiento, calidad, procesamiento, dashboard técnico, coste/viabilidad | RA1-RA4 |
| **BDA** | BI de negocio, dashboards aplicados, caso de uso, toma de decisiones | (sus RA) |
| **PIA** | Modelos de ML, predicciones, integración de IA | (sus RA) |

La coordinación entre módulos es responsabilidad del equipo docente. Este guión
se centra en la **parte SBD** del proyecto.

## Secuencia didáctica recomendada

| Fase | SBD evalúa | BDA/PIA pueden reutilizar |
| ---- | ---------- | ------------------------- |
| 0. Tema y alcance | Fuentes, problema técnico, arquitectura inicial, planificación. | Caso de uso, usuario final, hipótesis de negocio o IA. |
| 1. Ingesta | Scripts reproducibles, Bronze, formatos, particionado inicial. | Fuentes y contexto de negocio. |
| 2. Calidad y procesamiento | Silver/Gold, métricas, RGPD, linaje, idempotencia. | Dataset fiable para BI o modelos. |
| 3. Dashboard técnico | Caudal, calidad, latencia, errores, estado del pipeline. | Dashboard de negocio o predicciones. |
| 4. Defensa | Reproducibilidad, coste, limitaciones y decisiones técnicas. | Impacto, interpretación y producto final. |

## Uso de IA generativa

En UD6 la declaración de uso de IA es **obligatoria si se ha usado IA**.

Plantilla:

- `../00-planificacion/plantillas/plantilla_declaracion_uso_ia.md`

El alumnado debe indicar herramientas/modelos, prompts relevantes, partes donde
se usó IA, qué se verificó y qué decisiones tomó el grupo. El docente podrá hacer
preguntas de defensa oral sobre cualquier parte asistida por IA.

No se aplica aquí la escala completa 0-5 de uso de IA de Programación de 1º. En
SBD basta con una exigencia más ligera pero imprescindible: el grupo debe saber
explicar el proceso seguido, qué cambió tras usar IA y qué aprendió al verificar
o corregir la ayuda recibida.

## Cuestionarios semanales (formato Moodle GIFT)

- `04-evaluacion/quiz-ud6.gift` — 4 preguntas en formato GIFT sobre fases del proyecto, integración multi-módulo e IA.

## Material archivado

La carpeta antigua `ud06-proyecto-integrador/` se archivó en
`90-archivo/proyecto-integrador-antiguo/`. Se conserva como histórico porque era
una versión anterior y duplicada de la UD6. La idea de proyecto común SBD+BDA+PIA
sí se mantiene: la versión canónica está en `guion_proyecto.md` y las ideas
aprovechables se han rescatado en `05-recursos/ideas_proyecto.md`.
