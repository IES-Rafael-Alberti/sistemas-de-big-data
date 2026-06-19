# UD3 — Procesamiento Distribuido y Analítica Escalable en Sistemas de Big Data

## 1. Introducción: cambio de fase en el proyecto Big Data

En las unidades anteriores del módulo **Sistemas de Big Data**, el trabajo se ha centrado en una fase fundamental: **preparar los datos**.

Hasta ahora hemos abordado:

- Ingesta de datos desde distintas fuentes.
- Integración de datasets heterogéneos.
- Limpieza y control de calidad.
- Anonimización y adecuación legal (RGPD).
- Almacenamiento de los datos en un destino común.

Gracias a este trabajo, los datos ya no son “datos en bruto”, sino **datos estructurados, coherentes y utilizables**.

A partir de este punto, el problema principal deja de ser *cómo obtener los datos* y pasa a ser **cómo procesarlos de forma eficiente cuando el volumen crece**. Este cambio marca el inicio real del **Big Data operativo**.

---

## 2. El límite del enfoque clásico: análisis secuencial con pandas

Durante las primeras unidades, gran parte del procesamiento se ha realizado con:

- Python
- pandas
- Ficheros CSV u otros formatos simples

Este enfoque es correcto, profesional y ampliamente utilizado en la industria, pero **no escala indefinidamente**.

### 2.1 ¿Qué hace bien pandas?

- Análisis exploratorio de datos (EDA).
- Limpieza y transformaciones complejas.
- Prototipado rápido.
- Datasets pequeños o medianos.

Por este motivo, pandas sigue siendo una herramienta clave incluso en entornos Big Data.

### 2.2 ¿Dónde aparecen las limitaciones?

Cuando el volumen de datos crece, surgen problemas estructurales:

- **Memoria**: los datos se cargan completos en RAM.
- **CPU**: el procesamiento es secuencial.
- **Tiempo**: operaciones simples se vuelven lentas.
- **Escalabilidad**: añadir más datos no implica más capacidad de proceso.

Ejemplo conceptual:

- Dataset de 10 MB → funciona sin problemas.
- Dataset de 5 GB → empieza a ser lento o inestable.
- Dataset de 200 GB → directamente no es viable.

Aquí es donde el Big Data deja de ser una cuestión teórica y se convierte en un **problema técnico real**.

---

## 3. Nuevo paradigma: procesamiento paralelo y distribuido

Para superar estas limitaciones no basta con optimizar código.  
Es necesario **cambiar el modelo de procesamiento**.

En lugar de:

- Un único proceso
- En una única máquina
- Ejecutando instrucciones secuenciales

Pasamos a:

- Múltiples procesos
- Repartidos entre varias CPU o nodos
- Ejecutándose **en paralelo** sobre fragmentos del dataset

Este enfoque se conoce como **procesamiento distribuido**.

---

## 4. Apache Spark: motor de procesamiento distribuido

### 4.1 ¿Qué es Apache Spark?

Apache Spark es un **motor de procesamiento distribuido** diseñado para trabajar con grandes volúmenes de datos de forma eficiente.

Sus principales características son:

- Procesamiento en memoria.
- Ejecución paralela.
- Escalabilidad horizontal.
- Capacidad de trabajar desde un portátil hasta un clúster completo.

Spark **no sustituye a pandas**, sino que responde a otra necesidad.

| pandas | Spark |
|------|------|
| Memoria local | Memoria distribuida |
| Procesamiento secuencial | Procesamiento paralelo |
| Dataset pequeño/medio | Dataset grande |
| Exploración y prototipado | Procesamiento masivo |

### 4.2 ¿Qué cambia para el programador?

Desde el punto de vista del código, muchas operaciones resultan familiares:

- Lectura de datos
- Filtrado
- Agrupaciones
- Cálculo de métricas
- Transformaciones de columnas

La diferencia clave es conceptual:

1. Los datos están **repartidos**.
2. Las operaciones se **planifican y ejecutan en paralelo**.

El programador define **qué** quiere hacer; Spark decide **cómo** hacerlo de forma eficiente.

---

## 5. Qué vamos a hacer en la UD3

Esta unidad no consiste en aprender Spark como una herramienta aislada, sino en **entender su papel dentro de un sistema Big Data completo**.

### 5.1 Flujo de trabajo de la unidad

Partimos de los resultados de la UD2:

1. Datos integrados.
2. Datos anonimizados.
3. Datos almacenados en un destino común.

A partir de ahí:

4. Procesamiento distribuido con Spark.
5. Cálculo de agregaciones y métricas a gran escala.
6. Preparación de resultados para visualización.
7. Base para la automatización de pipelines (Airflow).

---

## 6. Spark frente a pandas: comparación práctica

Durante la unidad se trabajará con **operaciones equivalentes** en ambos enfoques:

- Agrupaciones por ciudad, fecha o canal.
- Cálculo de métricas globales.
- Filtrado de grandes volúmenes.
- Preparación de datasets finales.

El objetivo no es memorizar APIs, sino responder a preguntas clave:

- ¿Cuándo deja de ser suficiente pandas?
- ¿Qué aporta Spark cuando el volumen crece?
- ¿Qué coste tiene usar Spark?
- ¿Cuándo no merece la pena usar procesamiento distribuido?

---

## 7. Herramientas que intervienen en la UD3

### 7.1 Spark (núcleo de la unidad)

- Motor de procesamiento distribuido.
- Base técnica de la UD3.
- Punto de conexión con etapas posteriores (automatización).

### 7.2 Zeppelin (laboratorio optativo)

- Entorno interactivo orientado a Big Data.
- Similar a un notebook, pero diseñado para Spark.
- Permite combinar:
  - Código
  - Resultados
  - Visualizaciones

No es obligatorio, pero facilita la comprensión del procesamiento distribuido.

### 7.3 Kibana (laboratorios de visualización)

- Herramienta de visualización y exploración.
- Trabaja sobre datos ya procesados.
- Permite crear:
  - Dashboards
  - Gráficas
  - Informes visuales

Aquí se ve claramente la separación entre:
- **Procesar datos** (Spark)
- **Explorar resultados** (Kibana)

---

## 8. Relación con la automatización: Airflow

Aunque no se aborda en profundidad en esta fase, la UD3 deja preparado el escenario para:

- Automatizar pipelines de datos.
- Encadenar procesos de:
  - Ingesta
  - Procesamiento
  - Almacenamiento
  - Visualización

Spark será uno de los bloques principales que Airflow orquestará en unidades posteriores.

---

## 9. Objetivo real de la UD3

Al finalizar esta unidad, el objetivo no es que el alumnado:

- Instale clústeres complejos.
- Memorice toda la API de Spark.

El objetivo es que:

- Comprenda **cuándo y por qué** se necesita procesamiento distribuido.
- Sea capaz de usar Spark a nivel básico.
- Entienda el papel de herramientas como Kibana y Zeppelin.
- Perciba el Big Data como **un sistema completo**, no como scripts aislados.

---

## 10. Cierre de la introducción

Hasta ahora hemos aprendido a **preparar datos**.  
A partir de ahora vamos a **procesarlos a escala**.

Spark no sustituye lo aprendido: **lo amplía cuando el volumen de datos lo exige**.
