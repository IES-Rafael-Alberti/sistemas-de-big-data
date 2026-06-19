# UD3 — Laboratorio: benchmark pandas vs DuckDB vs Spark

## Objetivo

Comparar pandas, DuckDB y Spark/PySpark con un mismo conjunto de datos para decidir **qué herramienta tiene sentido usar según volumen, coste, complejidad e infraestructura**.

No se trata de declarar un ganador universal. Eso sería una barbaridad técnica. Se trata de aprender a justificar:

- cuándo pandas es suficiente;
- cuándo DuckDB simplifica análisis local sobre Parquet;
- cuándo Spark empieza a tener sentido;
- cuándo Spark es demasiado coste para el problema.

## Relación curricular

- **RA1.f-g**: selección e integración de sistemas valorando coste y calidad.
- **RA3.b-c**: uso de tecnologías eficientes para extraer valor y procesar grandes cantidades de datos.
- **RA4.d-e**: diferencias entre aplicaciones de procesamiento eficiente y programación automática de estructuras de datos.

## Herramientas

Ruta mínima:

```bash
python -m venv .venv
source .venv/bin/activate
pip install pandas pyarrow duckdb
```

Ruta completa con Spark:

```bash
pip install pyspark
```

> Si Spark da problemas en un equipo concreto, se documenta la incidencia y se compara pandas vs DuckDB. En sistemas reales, la fricción operativa también forma parte de la decisión.

## Dataset

Generaremos un dataset sintético de eventos turísticos con columnas suficientes para agregaciones, filtros y joins ligeros.

Generación rápida:

```bash
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/generar_dataset_benchmark.py --rows 200000
```

Generación más pesada:

```bash
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/generar_dataset_benchmark.py --rows 1000000
```

Salida:

```text
datos/benchmark_motores/eventos.csv
datos/benchmark_motores/eventos.parquet
datos/benchmark_motores/zonas.csv
datos/benchmark_motores/zonas.parquet
```

## Consultas a comparar

Ejecuta las mismas operaciones con pandas, DuckDB y Spark/PySpark:

| Consulta | Descripción |
| -------- | ----------- |
| Q1 | Conteo total de filas. |
| Q2 | Ventas totales por zona. |
| Q3 | Ventas por zona y mes. |
| Q4 | Top 10 comercios por importe. |
| Q5 | Join con catálogo de zonas y agregación por tipo de zona. |
| Q6 | Filtrado de eventos con importe alto y lluvia. |

## Script de apoyo

Puedes usar el script base:

```bash
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py --engine all
```

Opciones:

```bash
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py --engine pandas
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py --engine duckdb
python ud03-procesamiento-distribuido/05-recursos/benchmark-pandas-duckdb-spark/benchmark_motores.py --engine spark
```

El script mide tiempos aproximados. No lo conviertas en dogma: en benchmarking real influyen cachés, memoria, CPU, disco, versiones y tamaño de datos.

## Entregable

Entrega un informe Markdown:

```md
# UD3 — Benchmark pandas vs DuckDB vs Spark

## 1. Equipo y entorno

- CPU:
- RAM:
- Sistema operativo:
- Python:
- Versiones de pandas/DuckDB/Spark:
- Tamaño del dataset:

## 2. Resultados de tiempo

| Consulta | pandas | DuckDB | Spark |
| -------- | -----: | -----: | ----: |
| Q1 | | | |
| Q2 | | | |
| Q3 | | | |
| Q4 | | | |
| Q5 | | | |
| Q6 | | | |

## 3. Observaciones técnicas

## 4. Coste y fricción operativa

## 5. Decisión razonada

## 6. Conclusión
```

## Preguntas obligatorias

1. ¿En qué consultas destaca pandas y por qué?
2. ¿En qué consultas DuckDB resulta más cómodo o eficiente?
3. ¿Qué coste de arranque o complejidad añade Spark?
4. ¿A partir de qué situación tendría sentido Spark frente a DuckDB?
5. ¿Por qué no debes elegir una herramienta sólo porque “es Big Data”?

## Rúbrica rápida

| Criterio | Peso |
| -------- | ---: |
| Dataset generado y pruebas reproducibles | 20% |
| Comparación con las mismas consultas | 25% |
| Interpretación técnica de resultados | 25% |
| Justificación coste/calidad/viabilidad | 20% |
| Claridad del informe | 10% |

## Cierre conceptual

Una herramienta no es mejor por ser más grande.

- pandas es excelente para análisis local y datasets manejables en memoria.
- DuckDB es potentísimo para SQL analítico local, especialmente con Parquet.
- Spark tiene sentido cuando el volumen, la distribución, el procesamiento paralelo o el ecosistema justifican su coste.

La madurez técnica está en elegir bien, no en usar la herramienta más ruidosa.

## Referencias

- DuckDB Documentation: https://duckdb.org/docs/
- Apache Spark Documentation: https://spark.apache.org/docs/latest/
- pandas Documentation: https://pandas.pydata.org/docs/
- Aitor Medrano — Apache Spark: https://aitor-medrano.github.io/iabd/spark/spark.html
- Aitor Medrano — Formatos de datos: https://aitor-medrano.github.io/iabd/de/formatos.html
