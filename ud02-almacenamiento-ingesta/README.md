# UD2 — Almacenamiento e ingesta

## Estructura

| Sección | Uso | Nº archivos |
| ------- | --- | ----------: |
| `01-teoria/` | Fuentes editables y apuntes principales. | 41 |
| `02-ejemplos/` | Notebooks, scripts y ejemplos no evaluables. | 0 |
| `03-practicas/` | Guiones de laboratorio y prácticas de aula. | 50 |
| `04-evaluacion/` | Enunciados evaluables, rúbricas y documentos de entrega. | 2 |
| `05-recursos/` | Datasets, imágenes, plantillas, ZIPs docentes y dependencias. | 5 |
| `90-archivo/` | Derivados publicados, histórico y material no canónico. | 30 |
| `99-profesor/` | Notas internas, guías docentes y corrección reutilizable. | 4 |

## RA/CE cubiertos

| RA/CE | Material | Tipo |
|-------|----------|------|
| **RA1.b** | Práctica Medallion (Bronze: extraer de CSV/JSONL) | Evaluable |
| **RA1.c** | Práctica integración dlt (combinar 4 fuentes) | Evaluable |
| **RA1.d** | Práctica Medallion (Silver → Gold: datasets relacionados) | Evaluable |
| **RA1.f** | Matriz coste-calidad-viabilidad (selección herramientas) | Evaluable |
| **RA1.g** | Matriz coste-calidad-viabilidad | Evaluable |
| **RA1.g** | Tarea UD2 (apartado calidad) | Evaluable |
| **RA3.a** | Práctica integración dlt + Práctica Medallion (ingesta) | Evaluable |
| **RA3.b** | Práctica Medallion (Parquet + DuckDB: tecnologías eficientes) | Evaluable |
| **RA3.d** | Tarea UD2 (RGPD) + prácticas (idempotencia) | Evaluable |
| **RA4.a** | Práctica Medallion (JSONL — datos semiestructurados) | Evaluable |

Ver `00-planificacion/matriz_ra_ce_materiales.md` para el detalle completo.

## Regla transversal desde UD2 — RGPD y anonimización

A partir de esta unidad, toda práctica o proyecto donde se procesen datos debe
seguir un proceso obligatorio de anonimización:

- primero se buscan datos personales e identificadores directos o indirectos;
- si no aparecen, se indica explícitamente: **“Anonimización completada: no se
  han detectado datos personales ni identificadores directos o indirectos”**;
- si aparecen, se anonimiza, seudonimiza, agrega, generaliza o elimina hasta que
  el dataset quede listo para publicar o explotar sin identificar personas;
- la decisión debe quedar documentada en `README_RGPD.md` o en la checklist
  calidad/RGPD/seguridad.

La idea docente es que el alumnado interiorice que anonimizar y gestionar bien
datos personales no es opcional: una filtración que permita identificar a alguien
directa o indirectamente puede tener consecuencias legales y económicas graves.

## Material nuevo — Matriz coste-calidad-viabilidad

- `04-evaluacion/UD2_Actividad_Matriz_Coste_Calidad_Viabilidad.md` — actividad evaluable donde el alumnado compara 4 alternativas de pipeline usando la plantilla transversal.
- Referencia la plantilla en `00-planificacion/plantillas/plantilla_matriz_coste_calidad_viabilidad.md`.

Cubre **RA1.g** de forma explícita.

## Material nuevo — Práctica local Medallion

- `03-practicas/UD2_Practica_Local_Medallion_Parquet_DuckDB_Spark.md` — práctica local reproducible para construir un pipeline raw → Bronze → Silver → Gold con Parquet, DuckDB y ampliación Spark/PySpark.
- `05-recursos/practica-local-medallion/generar_datos_turismo.py` — generador de datos sintéticos CSV/JSONL para la práctica.

## Material principal — Integración con dlt

- `03-practicas/Tareas/005/00-Integracion_y_calidad/05-Integracion_y_calidad-tarea.md` — práctica consolidada de integración y calidad.
- Ruta A: **dlt** (`pip install dlt`) como alternativa principal a Airbyte.
- Ruta B: **Python + DuckDB** para integración sin herramienta ELT externa.
- `05-recursos/dlt-ingesta-pipeline/pipeline_ingesta_dlt.py` — pipeline de ejemplo sobre los datos Medallion.

**Decisión docente**: dlt es la ruta principal porque es Python-nativo,
ligero, reproducible y no depende de un servidor. Airbyte queda como
ampliación si el docente consigue montarlo en infraestructura propia.

## Material optativo — Herramientas reales: Airbyte + AWS Academy

- `05-recursos/practica-herramientas-reales/README.md` — visión general y notas de montaje.
- `05-recursos/practica-herramientas-reales/airbyte-comparativa.md` — práctica Airbyte GUI si hay servidor Proxmox preparado.
- `05-recursos/practica-herramientas-reales/aws-ingesta-serverless.md` — práctica AWS Academy con S3 + Glue Crawler + Athena.

Uso previsto:

1. Primero el alumnado hace la práctica principal con **dlt**.
2. Después, si la infraestructura está disponible, compara el mismo flujo con:
   - **Airbyte**: herramienta ELT real con interfaz gráfica.
   - **AWS Academy**: enfoque serverless, datos en S3 catalogados con Glue y consultados con Athena.
3. La comparación cubre **RA1.f**, **RA1.g**, **RA3.a** y **RA3.b**.

Pendiente docente para verano:

- Instalar y probar Airbyte 1.x en servidor Proxmox.
- Validar que AWS Academy permite S3, Glue Crawler y Athena.
- Decidir destino Airbyte: DuckDB si está disponible; Postgres como alternativa más segura.

Estas prácticas son **optativas y no bloquean el curso**: la ruta principal local
queda cubierta por dlt, DuckDB y Parquet.

## Cuestionarios semanales (formato Moodle GIFT)

- `04-evaluacion/quiz-ud2.gift` — 8 preguntas en formato GIFT sobre HDFS, NoSQL, dlt, calidad de datos, RGPD y Medallion.
