# Informe — Práctica local Medallion UD2

## Resumen

Se ha creado una práctica local para materializar la arquitectura Big Data moderna sin depender de cloud ni servicios externos.

La práctica conecta:

```text
raw CSV/JSON → Bronze Parquet → Silver limpio → Gold consultable → DuckDB/Spark
```

## Archivos creados

| Archivo | Acción |
| ------- | ------ |
| `ud02-almacenamiento-ingesta/03-practicas/UD2_Practica_Local_Medallion_Parquet_DuckDB_Spark.md` | Guion completo de práctica. |
| `ud02-almacenamiento-ingesta/05-recursos/practica-local-medallion/generar_datos_turismo.py` | Generador de datos sintéticos sin dependencias externas. |
| `ud02-almacenamiento-ingesta/05-recursos/practica-local-medallion/README.md` | Instrucciones de uso del generador. |

## Decisión docente

La práctica se coloca en UD2 porque cubre almacenamiento, ingesta, formatos, calidad y construcción de dataset complejo. Además sirve como puente natural hacia UD3, donde Spark/PySpark puede repetir o ampliar parte del pipeline.

## Referencias externas usadas como contraste

- Aitor Medrano — Formatos de datos.
- Aitor Medrano — Arquitecturas Big Data.
- Aitor Medrano — Apache Spark.
- Documentación de DuckDB y Apache Spark.

## Pendiente posterior

Si se quiere hacer evaluable formalmente, puede extraerse una versión cerrada en `04-evaluacion/` con plantilla de entrega y rúbrica separada.
