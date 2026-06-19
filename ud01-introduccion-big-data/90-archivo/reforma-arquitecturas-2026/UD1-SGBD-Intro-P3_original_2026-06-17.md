# UD1 · Parte 3 — Arquitecturas de Big Data (batch, streaming, Lambda, Kappa y capas)

## 1. Para qué sirve una arquitectura (y por qué la necesitamos)

Una **arquitectura de Big Data** es el diseño que permite **ingerir, procesar y analizar** datos cuando su tamaño, ritmo o complejidad superan lo que aguanta una base de datos tradicional. No es un diagrama bonito: es un **conjunto de decisiones** que deben sostenerse en producción y que condicionan coste, latencia y calidad. Sus rasgos no son opcionales: **escalabilidad** (crecer sin reescribir todo), **tolerancia a fallos** (que una caída no tumbe el sistema), **distribución** del dato y del cómputo (varias máquinas trabajando en paralelo) y **localidad del dato** (cálculo cerca del dato para no morir en la red). Si cualquiera de estos pilares falla, la arquitectura se vuelve cara o frágil. 

## 2. Dos ritmos mentales: batch y streaming

Antes de elegir “la” arquitectura, conviene pensar en **qué ritmo** tienen los datos y las decisiones.

**Batch** es procesar **lotes**: empieza, termina y deja un resultado estable (un modelo entrenado, una tabla curada, un informe). Lo usamos cuando la latencia aceptable es de minutos, horas o D+1, y cuando acceder al histórico completo mejora la **precisión** y simplifica la lógica. Es el mundo tradicional del **ETL**, de los **DW** y del **ecosistema Hadoop/MapReduce**, hoy reemplazado en gran parte por Spark. Tras el proceso, los resultados se **sirven** desde almacenes o índices preparados para consulta rápida. 

**Streaming** es un proceso **abierto en el tiempo**, que **consume y transforma** datos a medida que llegan. Aquí la prioridad es la **baja latencia** y la regularidad del flujo. Suelen intervenir colas o buses de mensajes (modelo *publish/subscribe*) que desacoplan productores y consumidores. El estado —acumulados, ventanas temporales, contadores— se actualiza de forma incremental. 

Una observación útil: **no todo “tiempo real” necesita tiempo real**. Si la decisión admite D+1, el coste de mantener streaming puede no compensar. A la inversa, si la decisión **expira** con rapidez (fraude, alertas, logística), no hay alternativa realista a un camino continuo.

## 3. Lambda: precisión histórica + frescura en paralelo

Propuesta en 2012 por **Nathan Marz**, la **arquitectura Lambda** divide el sistema en **dos caminos** que corren **en paralelo** y confluyen en una capa de consulta: uno **lento** (batch) y otro **rápido** (streaming). La **capa batch** ingiere **todos** los datos **inmutables**, combina con el histórico y recalcula resultados “desde cero”, produciendo **batch views** precisas pero con **alta latencia**. La **capa de streaming** aplica lógica **incremental** sobre las novedades para obtener **resultados recientes** con poca latencia. La **capa de serving** expone ambas vistas de forma indexada y con tiempos de respuesta bajos; la respuesta final se **compone** de la vista batch + la vista en tiempo real. Ventaja: precisión histórica sin renunciar a frescura; coste: **duplicar la lógica** en dos caminos. 

En clase, se entiende bien con un símil: la batch es “el censo oficial” que se rehace con calma y exactitud; la streaming es “el padrón provisional” que se actualiza al vuelo para no perderse cambios. La consulta cruza ambas.

## 4. Kappa: un solo flujo, todo es un stream

En 2014, **Jay Kreps** plantea **Kappa** como simplificación: **un único camino** de procesamiento de eventos. La idea es tratar **todo** como **stream** y hacer que el **batch sea un caso particular** (reprocesar el stream histórico). Se sustituye la pluralidad de fuentes por un **log de eventos** (Kafka u otro), se **persisten datos inmutables**, y se **derivan vistas** que pueden reconstruirse si cambia la lógica: “replay del log” y listo. Ventajas: menos complejidad operativa, un solo código, reprocess fácil; contrapartidas: si necesitas constantemente una foto exacta del histórico completo, la **batch “pura”** puede resultar más directa o eficiente. 

Kappa no es negar el batch: es **encapsularlo** como “reprocesar el stream”. Si tu lógica es la **misma** para históricos y novedades, Kappa encaja muy bien. Si usas algoritmos **muy distintos** para histórico y real (por ejemplo, entrenar modelos pesados frente a actualizar contadores), **Lambda** puede darte una separación más clara. 

## 5. Arquitectura por capas: una vista operativa de extremo a extremo

Además de Lambda/Kappa, es útil pensar la solución como una **secuencia de capas** especializadas:

* **Ingesta**: toca todas las fuentes y aplica primeras reglas (prioridad, clasificación).
* **Colección/transporte**: mueve y descompone los datos hacia el resto del *pipeline*.
* **Procesamiento**: donde ocurre la “cocina” —batch, streaming o híbrido— y de donde salen datos clasificados hacia su destino.
* **Almacenamiento**: decide **dónde** y **cómo** guardar de forma eficiente (data lake, objetos distribuidos, formatos columnares).
* **Consulta**: habilita el análisis ad hoc, APIs y motores SQL para extraer valor.
* **Visualización**: presenta resultados y KPIs a usuarios finales. 

Esta lectura por capas convive con Lambda/Kappa: te ayuda a **asignar responsables** y **tecnologías** a cada tramo y a auditar el flujo.

## 6. Tecnologías (mapa mental razonable)

Sin dogmas ni marcas fijas, pero con cabeza:

* **Ingesta/colección**: **Kafka** (cola *pub/sub*), **NiFi** (flujo declarativo), o ingestas “ligeras” con *connectors* u orquestadores.
* **Batch**: **Hadoop/MapReduce** (histórico), hoy mayoritariamente **Apache Spark**.
* **Streaming**: **Spark Streaming/Structured Streaming**, **Storm**, **Samza**… según necesidades de latencia y ecosistema.
* **Serving/consulta**: motores SQL distribuido (**Presto/Trino**, **Drill**) y **NoSQL** para servicio de vistas (HBase, MongoDB, Redis, DynamoDB).
* **Almacenamiento**: **HDFS** o **S3/compatibles**; formatos **Parquet/ORC**; ACID en lake con **Delta/Iceberg/Hudi**.
  Spark, en particular, puede cubrir **batch y streaming con una sola base de código**, lo que explica su popularidad en despliegues educativos e industriales. 

## 7. Casos de uso: elegir por objetivo, no por moda

El ejemplo típico **Kappa** es la **geolocalización** de usuarios por eventos de antenas: cada aproximación genera un evento, el sistema **actualiza** la posición y sirve un mapa en casi-tiempo-real. Un ejemplo **Lambda** claro es una **recomendación de películas**: la capa batch **entrena** el modelo con todo el histórico; la capa streaming **actualiza** señales con valoraciones recientes para que el usuario vea el efecto **al instante**. En ambos, la palabra clave es **objetivo**: ¿qué latencia y qué exactitud necesitas, y cuánto cuesta mantenerlas? 

Aterrizándolo en nuestro **caso docente** (turismo + ventas): si buscamos **KPIs D+1** para planificar **personal y stock**, un **batch** diario con vistas bien indexadas puede ser suficiente (barato y estable). Si, además, queremos **alertas** al detectar un **pico de afluencia** o un **fallo de TPV**, una **vía streaming** sencilla que escuche eventos y actualice contadores/umbrales aporta valor sin reescribir todo.

## 8. Buenas prácticas para no perderse

Empieza por el **caso de uso**: ¿qué KPI/alerta pide el cliente y con qué **latencia**? Si la respuesta admite lote, **no fuerces** streaming. Si la heterogeneidad de fuentes es alta, combina herramientas de ingesta: no hay una que valga para todo. Monitoriza siempre: con tantas piezas, necesitas **observabilidad** para entender qué se rompe y cuándo. Y sé honesto con el lenguaje: muchos sistemas “de streaming” operan con **micro-lotes**; no es peor, solo diferente y a menudo suficiente para el negocio. 

Un consejo pragmático: **prototipa en pequeño** —una ruta batch y, si hace falta, una mínima cola y un contador streaming—; mide latencias y costes, y **sólo entonces** consolida la arquitectura. La elegancia del diagrama no paga la luz: la factura la paga el run-time.

## 9. Cómo encaja en el módulo

Lo que has leído es la **capa conceptual** que dará sentido a lo que harás después: en **UD2** montarás ingestas reales (APIs/CSV → *data lake*), en **UD3** verás cómo **Spark** implementa batch y micro-batch y cómo elegir particionado y caché, en **UD4** publicarás **KPIs en BI** y en **UD5** conectarás con **ML**. Vuelve a este capítulo cuando dudes entre “hacerlo sencillo hoy” o “prepararlo para crecer”: te recordará que la **arquitectura** es, ante todo, un **compromiso explícito** entre **valor, latencia y coste**.

