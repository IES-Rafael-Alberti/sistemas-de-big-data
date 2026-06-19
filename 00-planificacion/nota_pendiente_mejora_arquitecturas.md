# Nota pendiente — Mejorar bloque de arquitecturas Big Data

## Contexto

Queda pendiente mejorar la parte de **arquitecturas Big Data** dentro de Sistemas de Big Data.

El material actual parece algo escueto y conviene reforzarlo antes de cerrar la versión 2026/2027.

## Punto importante observado

Durante este curso se ha trabajado con arquitectura **Medallion**.

Debe incorporarse explícitamente en el bloque de arquitecturas junto con otras arquitecturas ya presentes o mencionadas, como:

- batch,
- streaming,
- Lambda,
- Kappa,
- capas de datos,
- pipelines,
- lakehouse / data lake si procede.

## Observación curricular

Se detecta que en **Big Data Aplicado** se han trabajado contenidos que parecen más propios de **Sistemas de Big Data** que de aplicación pura.

Esto debe tenerse en cuenta en la siguiente revisión curricular para no duplicar ni descompensar módulos.

## Acción pendiente

Crear o ampliar un material de teoría/práctica sobre arquitecturas Big Data modernas, incluyendo:

- arquitectura Medallion,
- relación con data lake / lakehouse,
- zonas bronze / silver / gold,
- calidad de datos por capa,
- trazabilidad,
- formatos como Parquet,
- relación con Spark/DuckDB,
- cuándo usar batch, streaming, Lambda, Kappa o Medallion,
- ejemplo didáctico aplicable en aula.

## Ubicación probable

`ud01-introduccion-big-data/01-teoria/UD1-Parte3/`

También podría conectarse con UD2 si se trabaja como pipeline de ingesta y almacenamiento.
