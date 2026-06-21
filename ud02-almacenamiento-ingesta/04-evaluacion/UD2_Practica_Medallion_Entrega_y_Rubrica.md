# UD2 — Entrega y rúbrica: práctica local Medallion

Esta ficha convierte la práctica local Medallion en una entrega evaluable cerrada. El guion técnico está en `../03-practicas/UD2_Practica_Local_Medallion_Parquet_DuckDB_Spark.md`.

## Modalidad

- **Agrupamiento**: parejas.
- **Ruta principal**: Python + pandas + Parquet + DuckDB.
- **Ampliación**: repetir una parte con Spark/PySpark y comparar cuándo merece la pena.

## Relación curricular

| RA/CE | Evidencia evaluada |
| ----- | ------------------ |
| RA1.b | Extracción de información desde fuentes raw y KPIs Gold. |
| RA1.c-d | Combinación de CSV/JSONL y construcción de datasets relacionados. |
| RA1.f-g | Justificación de herramientas, coste, calidad y viabilidad. |
| RA3.a-b-d | Ingesta, almacenamiento eficiente, Parquet, calidad, seguridad e idempotencia. |
| RA4.a-e-f | Datos semiestructurados, procesamiento automático y consulta/visualización técnica. |

## Entregables

El repositorio o carpeta de entrega debe incluir:

```text
datos/practica_medallion/
├── raw/
├── bronze/
├── silver/
└── gold/
```

Y estos documentos o artefactos:

| Entregable | Mínimo esperado |
| ---------- | --------------- |
| `README.md` | Cómo ejecutar la práctica desde cero. |
| Scripts de ingesta | Conversión raw CSV/JSONL → Bronze Parquet. |
| Scripts de transformación | Silver y Gold reproducibles. |
| `quality_report.md` o `.json` | Reglas de calidad, incidencias y decisiones. |
| `README_RGPD.md` | Búsqueda de identificadores y anonimización si procede. |
| Consultas DuckDB | 5 consultas obligatorias con resultado o captura. |
| Memoria breve | Coste, calidad, viabilidad, problemas y conclusión técnica. |

## Criterios de aceptación

Una entrega aceptable debe cumplir todo esto:

- Bronze conserva las fuentes originales en Parquet sin limpiar en exceso.
- Silver aplica limpieza, tipado, normalización e integración entre fuentes.
- Gold contiene KPIs concretos, no “todo el dataset”.
- El pipeline es reproducible: se puede ejecutar de nuevo sin pasos manuales ocultos.
- Las reglas de calidad tienen acción asociada: aceptar, corregir, aislar o rechazar.
- DuckDB consulta directamente los Parquet generados.
- RGPD queda documentado, aunque sea para justificar ausencia de identificadores.

## Rúbrica /10

| Criterio | Peso | Excelente | Suficiente | Insuficiente |
| -------- | ---: | --------- | ---------- | ------------ |
| Arquitectura Medallion | 1.5 | Bronze/Silver/Gold tienen responsabilidades claras y justificadas. | Capas presentes con alguna ambigüedad. | Capas confundidas o ausentes. |
| Ingesta y Bronze | 1.5 | CSV/JSONL convertidos a Parquet de forma reproducible, con estructura limpia. | Ingesta funcional pero poco documentada. | Ingesta manual o no reproducible. |
| Silver y calidad | 2 | Limpieza, tipado, joins y reglas de calidad con evidencias. | Transformaciones básicas con calidad parcial. | Sin limpieza real ni métricas. |
| Gold y KPIs | 1.5 | KPIs útiles, consultables y alineados con preguntas técnicas. | KPIs simples pero válidos. | Gold es una copia de Silver o no responde preguntas. |
| DuckDB y evidencia | 1 | Consultas obligatorias correctas y explicadas. | Consultas ejecutadas pero poco interpretadas. | Sin consultas verificables. |
| Coste, viabilidad y herramientas | 1 | Compara DuckDB/Spark o alternativas con criterio técnico. | Justificación básica. | No justifica herramientas. |
| RGPD, reproducibilidad y documentación | 1.5 | README, linaje, RGPD, ejecución y problemas bien documentados. | Documentación suficiente pero incompleta. | No se puede reproducir o defender la entrega. |

## Conexión SBD/BDA

En **SBD** se evalúa el sistema: ingesta, capas, formato, calidad, procesamiento y consulta técnica.

El mismo Gold puede alimentar **Big Data Aplicado**, pero allí el foco sería distinto: dashboard de negocio, cliente, interpretación y toma de decisiones.
