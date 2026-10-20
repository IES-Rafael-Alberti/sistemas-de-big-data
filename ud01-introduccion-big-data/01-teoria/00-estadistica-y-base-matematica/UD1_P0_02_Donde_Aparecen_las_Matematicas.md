# UD1 · Dónde aparecen las matemáticas en Sistemas de Big Data

En este módulo la **estadística sí se estudia de forma explícita**, porque hay
que aprender a resumir e interpretar distribuciones. La matemática discreta, la
lógica algorítmica y la complejidad tienen otro papel: no forman una asignatura
teórica separada, pero ya las usamos al integrar fuentes, validar datos,
construir pipelines y comparar soluciones.

Este mapa complementa la [cápsula matemática normativa](UD1_P0_Capsula_Matematica_Normativa.md)
y señala dónde reconocer esos conceptos durante el curso. No hace falta tratar
cada aparición como un tema nuevo.

Para explicarlos de forma conectada en clase, usa el [notebook guiado de 60 minutos](../../02-ejemplos/UD1_Matematicas_en_el_Pipeline_Sesion_60min.ipynb): ejecuta ejemplos pequeños con CadenaRetail y muestra dónde reaparecen en UD2, UD3 y UD4.

## Mapa de conceptos a decisiones del curso

| Concepto | Dónde reaparece | Qué estamos haciendo con él |
|---|---|---|
| **Conjuntos y pertenencia** | UD1: [actividad matemática con CadenaRetail](../../03-practicas/fundamentos-matematicos-cadenaretail/UD1_P0_Actividad_Fundamentos_Matematicos_CadenaRetail.md). UD2: [integración y calidad incremental](../../../ud02-almacenamiento-ingesta/01-teoria/UD2_03_Integracion_y_calidad_incremental.md). | Comparar SKU vendidos con el catálogo; distinguir valores conocidos, desconocidos o ausentes; validar si un valor pertenece a un dominio permitido. Los filtros y las operaciones de conjuntos expresan ideas relacionadas. |
| **Relaciones, claves y joins** | UD1: actividad de CadenaRetail. UD2: joins y upsert en la [integración de datos](../../../ud02-almacenamiento-ingesta/01-teoria/UD2_03_Integracion_y_calidad_incremental.md). UD4: [modelado mínimo para BI](../../../ud04-bi-orquestacion/01-teoria/Parte-I_BI/UD4_02_Modelado_minimo_para_BI.md). | Representar que una venta pertenece a un producto, tienda o fecha; elegir claves para combinar tablas; comprobar que una relación no multiplica filas por claves duplicadas. No formalizamos álgebra relacional. |
| **Lógica algorítmica y condiciones** | UD1: [reglas de calidad y EDA](../04-eda-calidad-duckdb/UD1_02_EDA_y_calidad.md) y actividad de CadenaRetail. UD2: reglas de integración y calidad. UD3: filtros y transformaciones con Spark. | Expresar decisiones reproducibles como `SI precio_total != unidades * precio_unitario, ENTONCES marcar para revisión`, y traducirlas a filtros o validaciones ejecutables. |
| **Grafos y dependencias** | UD4: orquestación con Airflow y [DAG](../../../ud04-bi-orquestacion/01-teoria/ParteII-Orquestacion/UD4_07_Orquestacion_con_Airflow.md). | Entender tareas como nodos y dependencias como flechas: una transformación no puede ejecutarse antes de que estén listos sus datos de entrada. Reconocemos esta estructura; no estudiamos algoritmos avanzados de grafos. |
| **Conteos, cardinalidad y combinaciones** | UD1: frecuencias y métricas de unicidad en EDA. UD2: conteos, agrupaciones y joins. UD3: agregaciones y consultas del benchmark. | Contar filas y valores distintos, anticipar cuántas categorías o particiones pueden aparecer y detectar cuándo claves repetidas hacen crecer inesperadamente el resultado de un join. No desarrollamos combinatoria formal como bloque independiente. |
| **Complejidad y crecimiento del coste** | UD1: comparación de búsqueda en la actividad de CadenaRetail. UD3: [benchmark de pandas, DuckDB y Spark](../../../ud03-procesamiento-distribuido/03-practicas/Spark_Labs/UD3_Lab_Benchmark_Pandas_DuckDB_Spark.md). | Razonar por qué una solución que recorre o compara todos los registros puede dejar de ser viable al crecer el volumen; medir coste, tiempo y recursos al comparar motores. No se piden demostraciones formales. |

## Qué nivel se espera

No necesitas resolver ejercicios abstractos de todos estos campos. Sí necesitas
poder:

1. **Reconocer** el concepto cuando aparece en un sistema de datos.
2. **Usarlo en su forma práctica básica**: comprobar pertenencia, elegir una clave,
   escribir una condición o leer un DAG.
3. **Explicar la consecuencia técnica**: filas desconocidas, duplicados,
   resultados multiplicados, dependencias mal ordenadas o coste que crece al
   aumentar los datos.

La estadística requiere más estudio deliberado: calcular e interpretar medidas,
distribuciones y gráficos. Estos fundamentos matemáticos se trabajan de forma
integrada en problemas reales; la cápsula sirve para darles nombre y permitirte
explicar lo que ya estás haciendo.

No se espera que memorices demostraciones, estudies teoría profunda de grafos ni
calcules complejidades avanzadas. Se espera que no trates las claves, los joins,
las condiciones y el coste de procesamiento como magia: hay una idea matemática
sencilla detrás de cada decisión.
