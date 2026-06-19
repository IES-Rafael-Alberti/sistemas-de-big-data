# Informe — Hueco cubierto: Hadoop histórico vs Spark actual

## Resumen

Se ha cubierto el hueco de prioridad alta detectado en la propuesta de mejora: crear una cápsula breve para justificar el papel histórico de Hadoop y el uso práctico actual de Spark/PySpark.

## Archivo creado

| Archivo | Acción |
| ------- | ------ |
| `ud03-procesamiento-distribuido/01-teoria/UD3_Capsula_Hadoop_historico_vs_Spark_actual.md` | Nueva cápsula teórica breve con mini-actividad y criterio de evaluación rápido. |

## Decisión docente

Hadoop queda como fundamento histórico y conceptual: HDFS, MapReduce, YARN, escalado horizontal, tolerancia a fallos y procesamiento distribuido.

Spark/PySpark queda como herramienta práctica principal para procesamiento moderno: DataFrames, SQL, batch, streaming, Parquet, ejecución local/distribuida y conexión con Medallion.

## Uso de la web externa

Se ha usado la web de Aitor Medrano como contraste y referencia de organización, especialmente sus bloques de Hadoop, Spark, formatos, ingeniería de datos y flujos. No se copia material; se adapta el criterio a la separación propia de este curso entre Sistemas de Big Data, Big Data Aplicado y módulos específicos de IA.

## Pendiente siguiente recomendado

El siguiente hueco de prioridad alta sería crear la práctica local:

> ingesta CSV/JSON → Parquet → consulta/procesamiento con DuckDB o Spark.

Esa práctica materializaría lo ya trabajado en arquitectura y en esta cápsula.
