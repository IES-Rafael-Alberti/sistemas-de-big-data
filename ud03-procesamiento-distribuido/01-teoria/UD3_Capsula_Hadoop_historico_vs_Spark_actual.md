# UD3 — Cápsula: Hadoop histórico vs Spark actual

## Resultado de aprendizaje de esta cápsula

Al terminar esta cápsula debes poder explicar **por qué Hadoop fue fundamental históricamente**, **por qué Spark es la herramienta práctica principal hoy** y **qué parte del ecosistema Hadoop sigue teniendo sentido conocer**.

La idea no es “Hadoop malo, Spark bueno”. Ese razonamiento es demasiado pobre. La idea correcta es:

> Hadoop cambió la forma de pensar el procesamiento distribuido. Spark resolvió muchas de sus limitaciones prácticas para analítica moderna.

## Relación curricular

Esta cápsula ayuda especialmente a cubrir:

- **RA1.f-g**: seleccionar sistemas y herramientas valorando coste, calidad y adecuación.
- **RA3**: entender almacenamiento y procesamiento distribuido en grandes volúmenes.
- **RA4**: justificar herramientas de procesamiento automático.

## 1. Qué problema resolvió Hadoop

Hadoop aparece como respuesta a una necesidad muy concreta: almacenar y procesar grandes volúmenes de datos repartidos entre muchas máquinas.

Sus ideas principales fueron:

| Idea | Qué aporta |
| ---- | ---------- |
| **HDFS** | Sistema de ficheros distribuido: los datos se reparten entre nodos. |
| **MapReduce** | Modelo de procesamiento paralelo basado en fases de mapeo y reducción. |
| **YARN** | Gestor de recursos para ejecutar trabajos distribuidos. |
| **Escalado horizontal** | Añadir máquinas para aumentar capacidad y procesamiento. |
| **Tolerancia a fallos** | Asumir que los nodos fallan y diseñar el sistema para recuperarse. |

Esto es IMPORTANTÍSIMO conceptualmente. Aunque no montemos un clúster Hadoop real en clase, muchas ideas siguen vivas en herramientas actuales.

## 2. La limitación práctica: MapReduce es rígido

MapReduce funciona bien para ciertos procesos batch muy grandes, pero tiene problemas en escenarios modernos:

- obliga a pensar en fases `map` y `reduce`, poco naturales para muchos análisis;
- escribe muchos resultados intermedios a disco;
- no encaja bien con análisis interactivo;
- penaliza procesos iterativos;
- no es cómodo para explorar datos desde Python o SQL;
- exige bastante infraestructura si se quiere montar de verdad.

Por eso no tiene sentido que la práctica central del módulo sea “programar MapReduce” como si estuviéramos en 2012.

Sí tiene sentido entenderlo como **base histórica y conceptual**.

## 3. Qué aporta Spark

Spark conserva la idea de procesamiento distribuido, pero ofrece una forma más moderna y práctica de trabajar.

Sus ventajas principales:

| Aspecto | Por qué importa |
| ------- | --------------- |
| **Procesamiento en memoria** | Evita mucha escritura intermedia a disco y mejora trabajos iterativos. |
| **DataFrames y SQL** | Permite trabajar con abstracciones cercanas a Pandas y SQL. |
| **PySpark** | Encaja con Python, que ya usa el alumnado. |
| **Motor unificado** | Batch, SQL, streaming y MLlib dentro del mismo ecosistema. |
| **Ejecución local o distribuida** | Permite practicar en portátil y escalar el concepto a clúster. |
| **Integración con formatos modernos** | Trabaja bien con CSV, JSON, Parquet, ORC, Avro y fuentes externas. |

La documentación oficial de Spark lo define como un motor unificado para analítica a gran escala, con APIs de alto nivel y herramientas como Spark SQL, Structured Streaming y MLlib.

## 4. Entonces, ¿hay que enseñar Hadoop?

Sí, pero con cabeza.

| Nivel | Decisión docente |
| ----- | ---------------- |
| Conceptos de HDFS, MapReduce, YARN | **Sí**, como fundamentos. |
| Ecosistema Hadoop histórico | **Sí**, para entender de dónde viene Big Data. |
| Instalación completa de clúster Hadoop | **No como núcleo**, salvo demo muy controlada. |
| Programar MapReduce a mano | **Sólo si aporta contraste**, no como práctica principal. |
| Hive/HDFS/EMR/cloud | **Según viabilidad**, mejor como contexto o práctica guiada corta. |
| Spark/PySpark/DataFrames | **Sí como práctica central**. |

## 5. Qué parte sigue viva en arquitecturas actuales

Aunque usemos Spark, DuckDB, Parquet, lakehouse o Medallion, muchas ideas vienen de Hadoop:

- dividir datos en bloques o particiones;
- procesar cerca de donde están los datos;
- tolerar fallos;
- planificar tareas distribuidas;
- separar almacenamiento y cómputo;
- usar formatos eficientes para lectura analítica;
- pensar en batch, streaming y capas de procesamiento.

Por eso Hadoop no se borra. Se coloca en su sitio.

## 6. Relación con la arquitectura Medallion

En una arquitectura Medallion moderna:

| Capa | Tecnología típica en aula | Relación con Hadoop/Spark |
| ---- | ------------------------- | ------------------------- |
| Bronze | CSV/JSON/Parquet raw | Idea de almacenamiento masivo y trazable. |
| Silver | Parquet limpio con validaciones | Spark o DuckDB transforman y limpian. |
| Gold | agregados, KPIs, datasets finales | Spark SQL/DuckDB preparan explotación. |

La práctica actual no necesita montar HDFS para entender esto. Podemos trabajar localmente con carpetas y Parquet, y explicar que en producción esas carpetas podrían vivir en HDFS, S3, ADLS, GCS o un lakehouse.

## 7. Decisión práctica para este módulo

En Sistemas de Big Data vamos a usar este criterio:

> Hadoop se estudia como fundamento histórico y conceptual. Spark/PySpark se usa como herramienta práctica principal para procesamiento distribuido moderno.

Esto evita dos errores:

1. Quedarse atrapados en herramientas históricas por inercia normativa.
2. Usar herramientas modernas sin entender qué problema resolvieron.

Y esto último es clave: usar Spark sin entender Hadoop, MapReduce o procesamiento distribuido es conducir una excavadora sin saber qué es una obra.

## 8. Mini-actividad de cierre

Responde brevemente:

1. ¿Qué problema resolvía Hadoop que una base de datos tradicional no resolvía bien?
2. ¿Por qué MapReduce puede ser incómodo para análisis exploratorio o iterativo?
3. ¿Qué ventajas aporta Spark para una práctica de aula?
4. ¿Qué conceptos de Hadoop siguen siendo útiles aunque no montemos un clúster?
5. En una arquitectura Medallion, ¿dónde encajan Spark y Parquet?

## 9. Criterio de evaluación rápido

| Nivel | Evidencia |
| ----- | --------- |
| Básico | Distingue Hadoop, HDFS, MapReduce y Spark sin confundirlos. |
| Correcto | Explica por qué Spark sustituye a MapReduce como práctica central. |
| Avanzado | Relaciona Hadoop/Spark con formatos, arquitectura Medallion, coste y viabilidad. |

## Referencias consultadas

- Aitor Medrano — Hadoop y su ecosistema: https://aitor-medrano.github.io/iabd/hadoop/hadoop.html
- Aitor Medrano — Apache Spark: https://aitor-medrano.github.io/iabd/spark/spark.html
- Aitor Medrano — Materiales IABD: https://aitor-medrano.github.io/iabd/
- Apache Spark Documentation: https://spark.apache.org/docs/latest/
- Apache Hadoop Documentation: https://hadoop.apache.org/docs/current/
