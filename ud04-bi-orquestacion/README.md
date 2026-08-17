# UD4 — BI y orquestación

## Estructura

| Sección | Uso | Nº archivos |
| ------- | --- | ----------: |
| `01-teoria/` | Fuentes editables y apuntes principales. | 12 |
| `02-ejemplos/` | Notebooks, scripts y ejemplos no evaluables. | 1 |
| `03-practicas/` | Guiones de laboratorio y prácticas de aula. | 20 |
| `04-evaluacion/` | Enunciados evaluables, rúbricas y documentos de entrega. | 12 |
| `05-recursos/` | Datasets, imágenes, plantillas, ZIPs docentes y dependencias. | 25 |
| `90-archivo/` | Derivados publicados, histórico y material no canónico. | 19 |
| `99-profesor/` | Notas internas, guías docentes y corrección reutilizable. | 10 |

## Material nuevo — Dashboard técnico de monitorización de pipeline

- `03-practicas/Lab6_Dashboard_Tecnico/UD4_Lab6_Dashboard_Tecnico_Pipeline_Medallion.md` — laboratorio que construye un dashboard técnico supervisando el pipeline Medallion (bronce→silver→gold) con Metabase, usando datos de la UD2.
- `05-recursos/dashboard-tecnico-medallion/load_pipeline_data.py` — script que carga los datos Medallion a PostgreSQL y genera metadatos de pipeline y log de calidad.

Diferencia clave: este lab hace **dashboard técnico/operativo** (SBD), no BI de negocio (BDA). Monitoriza caudal, calidad y rendimiento del pipeline.

Cubre **RA2** y **RA4** con enfoque técnico.

## Material archivado — Power BI

El material completo de Power BI (guias Desktop/V1/V2/Web, práctica Lab5 y evaluación)
se ha movido a `90-archivo/power-bi-para-BDA/` porque su enfoque es BI de negocio.
Disponible para el profesor de Big Data Aplicado si quiere usarlo.

En SBD se conserva solo la **comparativa conceptual**:
- `01-teoria/UD4_13_BI_Comparativa_Metabase_Superset_PowerBI.md`

## RA/CE cubiertos

| RA/CE | Material | Tipo |
|-------|----------|------|
| **RA2.a** | Comparativa Metabase vs Superset vs PowerBI | Teoría |
| **RA2.b** | Lab1 Metabase, Lab2 Superset (cruzar info con datos) | Evaluable |
| **RA2.c** | Lab1 Metabase (dashboard básico) + Lab6 (dashboard técnico) | Evaluable |
| **RA2.e** | Lab3 miniProyecto + Lab6 (reflexión, impacto) | Evaluable |
| **RA4.b** | Lab1 Metabase, Lab2 Superset, Lab3 miniProyecto (implantar BI) | Evaluable |
| **RA4.e** | Lab4 Airflow (orquestación programada) | Evaluable |
| **RA4.f** | Labs 1-3 y 6 (visualización de datos y resultados) | Evaluable |

> RA2.d cubierto por la sección 10 del Lab6 (predicción con media móvil
> + conexión a regresión con Spark MLlib de UD5).

> Labs 1-2 (Metabase y Superset) se mantienen en SBD como demostración técnica de
> configuración, modelado, consulta y visualización. Lab3 miniProyecto queda como
> ampliación: si se evalúa como solución de negocio, encaja mejor en Big Data
> Aplicado; si se usa en SBD, debe centrarse en modelo, calidad, métricas técnicas
> y trazabilidad del pipeline.

## Secuencia didáctica recomendada

| Fase | Material | Evidencia esperada |
| ---- | -------- | ------------------ |
| 1. BI técnica | `01-teoria/Parte-I_BI/UD4_00_Introduccion_BI.md` | Diferenciar dashboard técnico de BI de negocio. |
| 2. Modelo | `01-teoria/Parte-I_BI/UD4_02_Modelado_minimo_para_BI.md` | Modelo estrella mínimo con granularidad justificada. |
| 3. Diseño | `01-teoria/Parte-I_BI/UD4_09_Diseno_profesional_de_dashboards.md` | Boceto con KPI, filtros y visualizaciones justificadas. |
| 4. Herramientas | Labs Metabase/Superset | Dashboard funcional y comparación de herramienta. |
| 5. Dashboard técnico | `03-practicas/Lab6_Dashboard_Tecnico/` | Métricas de caudal, calidad y rendimiento del pipeline. |
| 6. Orquestación | Airflow/MageAI | DAG o flujo con dependencias explícitas y evidencias de ejecución. |

## Cuestionarios semanales (formato Moodle GIFT)

- `04-evaluacion/quiz-ud4.gift` — 6 preguntas en formato GIFT sobre BI tools, dashboards, Airflow y monitorización Medallion.

Ver `00-planificacion/matriz_ra_ce_materiales.md` para el detalle completo.
