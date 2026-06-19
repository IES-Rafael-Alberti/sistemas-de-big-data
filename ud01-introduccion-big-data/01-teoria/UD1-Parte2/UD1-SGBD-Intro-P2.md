---
title: "SGBD UD1 · Introducción a Big Data · Parte 1"
author: "José Manuel Sánchez Álvarez - IES Rafael Alberti"
output:
  pdf_document:
    toc: true
    toc_depth: 3
    number_sections: false
    latex_engine: xelatex
fontsize: 11pt
geometry: margin=1.5cm
header-includes:
  - \renewcommand{\contentsname}{Índice de contenidos}
---

# UD1 · Parte 2 — Almacenamiento de datos y NoSQL en Big Data

## 1. De “guardar filas” a “diseñar para escalar”

Cuando el volumen, la velocidad o la variedad de los datos empiezan a apretar, el **modo clásico de guardar filas en una única base relacional** deja de ser suficiente. No porque el SQL “no valga”, sino porque el **patrón de acceso** y la **exigencia de escalado** cambian: pasamos de una única máquina potente a **varias máquinas normales**, y de un esquema estable a **estructuras que evolucionan** con el producto. Esa transición explica por qué surgen las familias **NoSQL** (mal nombre, mejor pensar en *Not Only SQL*): tecnologías que **priorizan escalabilidad y disponibilidad**, aceptando modelos y garantías distintas de las del relacional tradicional. 

En Big Data, este cambio no es ideológico: es **práctico**. Si tu aplicación necesita capturar millones de eventos por hora y leerlos con latencias bajas, **distribuir** el almacenamiento y el cómputo no es opcional; es la única forma razonable de que la cuenta salga. Por eso verás que hablamos de **clúster**, **particionado** y **replicación** con naturalidad: son las piezas que hacen posible que el sistema crezca sin romperse. 

---

## 2. Qué significa “No Solo SQL”

En la práctica, *No Solo SQL* agrupa motores que **no siguen el modelo relacional** clásico, **permiten esquemas flexibles** y suelen **distribuir datos** por varias máquinas. A cambio, su prioridad suele ser **rendimiento, escalabilidad y alta disponibilidad** antes que el conjunto de garantías ACID en cada operación compleja. No es que “no tengan transacciones”, sino que su **modelo de datos** y **consistencia** están diseñados para otros compromisos. 

Hay cuatro **grandes familias** que conviene dominar de forma conceptual: **documentales**, **clave-valor**, **basadas en columnas** y **de grafos**. Cada una **optimiza un tipo de problema** y obliga a modelar de forma distinta. Veremos enseguida qué resuelve cada una y cuándo **no** conviene usarlas. 

---

## 3. Esquemas que cambian: *schema-on-read*

Una diferencia clave con el mundo relacional es que muchas bases NoSQL **no exigen definir el esquema a priori** para poder insertar un registro. Esto acelera el desarrollo —puedes empezar a almacenar hoy y decidir mañana cómo leer—, pero no elimina la necesidad de **validar**. La validación se traslada a la lectura: hablamos de *schema-on-read*. En términos didácticos: **“esquema al escribir”** (SQL/DW) frente a **“esquema al leer”** (mucho NoSQL). En Big Data, especialmente en ingesta de eventos y APIs, esa flexibilidad puede marcar la diferencia. 

---

## 4. Particionar para crecer (y para no sufrir)

Escalar horizontalmente significa **repartir datos entre varias máquinas**. A ese reparto lo llamamos **particionado** o **sharding**. También existe el particionado en bases relacionales (horizontal por filas, vertical por columnas), pero en NoSQL se vuelve **central** porque **cada lectura/escritura** puede acabar en **nodos distintos** según la clave de partición. Elegir mal esa clave se paga caro: creas “**puntos calientes**” (mucho tráfico en un nodo) o imposibilitas las consultas que de verdad necesitas. 

Un patrón sano para empezar: **elige la clave** en función de **cómo vas a leer**. Si tu consulta típica es “dame todos los eventos del usuario *u* en el último mes”, la partición por `usuario_id` y por **rango temporal** encaja. Si lo que haces es “agrega por producto”, quizá quieras particionar por `producto_id` o mantener **vistas derivadas** que materialicen esa agregación. No hay bala de plata: hay **compromisos**.

---

## 5. Replicar para sobrevivir

La **replicación** mantiene **copias de los datos** en varios nodos para que el sistema sobreviva a caídas. Los esquemas más conocidos:

* **Primario–secundario** (maestro-esclavo): **se escribe en el primario**, que **replica a los secundarios**. Es simple y eficiente para lecturas, pero introduce un **punto único de fallo** si la elección del primario no está automatizada.
* **Par-a-par** (peer-to-peer): **todos los nodos pueden escribir**. La contrapartida es gestionar **conflictos** y **consistencia** cuando dos escrituras chocan. 

Piensa la replicación como un **seguro**: pagas un extra en **espacio** y **complejidad**, pero a cambio ganas **disponibilidad**. En analítica, además, te permite **acercar lecturas** a quien las necesita.

---

## 6. Modelado documental: cuando el “objeto” es el documento

En una base **documental** (p. ej. MongoDB o CouchDB) el **registro se guarda como un documento** —normalmente JSON— con **campos anidados** y **arrays**. El diseño mental es cercano a la orientación a objetos: **datos que se usan juntos se guardan juntos**, reduciendo *joins* y simplificando lecturas. Puedes **indexar** campos simples o anidados y contar con índices especiales (texto, geoespacial, TTL) para acelerar patrones de búsqueda reales. 

**Cuándo brilla.** Cuando el **acceso típico** es recuperar **entidades completas** con sus sub-partes (un pedido con líneas, un post con comentarios), y el **esquema cambia** con frecuencia entre versiones. **Cuándo chirría.** Cuando necesitas **transacciones complejas** que afectan a **muchos documentos** a la vez, o **consultas agregadas** muy cruzadas que imitan un *data warehouse* clásico. 

---

## 7. Clave-valor: la velocidad de un diccionario

Un almacén **clave-valor** es el **diccionario** más rápido que puedas imaginar: das una **clave** y recuperas o escribes un **valor** opaco para el motor. Esa opacidad es su fuerza y su límite: **no puedes filtrar por “lo de dentro”**, solo por la clave. Por eso brilla como **caché**, **sesiones de usuario**, **preferencias**, **carritos** y otros accesos directos por identificador. Para cualquier necesidad de **consultar por campos internos**, este modelo no encaja sin montar capas adicionales. 

---

## 8. Columnar (familia columna-familia): girar la tabla 90 grados

En los sistemas **columnares** (HBase, Cassandra; inspirados en Bigtable) el almacenamiento gira **90 grados**: los datos se **agrupan por columnas** o familias de columnas. Eso permite **comprimir muy bien** y **leer muy rápido** “unas pocas columnas de muchas filas”, justo lo que piden **analítica**, **OLAP** y **BI**. También se usa para **metadatos** y consultas de **alta velocidad** sobre grandes volúmenes. No es la mejor opción para **OLTP** (transaccional con muchas escrituras sobre pocas filas individuales), donde las relacionales siguen dominando. 


---

## 9. Grafos: cuando la relación es el dato

Las bases de **grafos** (Neo4j, ArangoDB, Neptune) guardan **nodos** y **aristas** con **propiedades**. El **dato clave** es la **relación**: “quién conoce a quién”, “qué cruza con qué”, “qué compró el que se parece a…”. Consultar un grafo es **recorrer**: “sígueme *tres saltos* por relaciones de tipo *amigo-de*” o “dame el camino más corto”. Por eso encajan de maravilla en **redes sociales**, **rutas y mapas**, **recomendaciones** y **detección de fraudes** por patrones de conexión. Su talón de Aquiles es **modificar masivamente muchas entidades** o intentar usarlas como si fueran tablas clásicas: **no lo son**. 

---

## 10. Elegir modelo: empezar por las preguntas

Una regla útil para modelar fuera del mundo relacional es **empezar por las consultas**. ¿Qué vas a leer y cómo lo vas a filtrar?

* Si tu lectura típica es **“dame el documento completo”**, piensa en **documental**.
* Si es **“dame el valor de esta clave exacta”**, **clave-valor**.
* Si haces **agregaciones masivas** por **unas pocas columnas**, mira **columna-familia** (y, para batch, Parquet).
* Si lo esencial es **explorar relaciones** y **patrones de conexión**, **grafo**.

Después, pregúntate por el **ritmo de cambios** del esquema, el **volumen** y la **latencia** que necesitas, y por la **disponibilidad** exigida. La respuesta rara vez es “una sola pieza”: en sistemas reales combinamos **varios modelos** (por ejemplo, eventos en documental/clave-valor, análisis en columnares/Parquet y recomendaciones en grafo). 

---

## 11. Casos y anticasos (con ejemplos reales del ecosistema)

* **Documental**: *“un post con sus comentarios y usuarios”*, *“un pedido con líneas”*. Productos: **MongoDB**, **CouchDB**. **Evitar** cuando necesites **transacciones cruzadas** o **agregados muy complejos** al estilo DW. 
* **Clave-valor**: *sesiones*, *perfiles*, *carritos*, *caché*. Productos: **Redis**, **Riak**, **DynamoDB**. **Evitar** si quieres **consultar por el contenido del valor**. 
* **Columna-familia**: *analítica a gran escala*, *OLAP/BI*, *metadatos con lecturas por columnas*. Productos: **HBase**, **Cassandra** (Bigtable como referencia histórica). **Evitar** en **OLTP** puro con alta simultaneidad de escrituras por fila. 
* **Grafos**: *social*, *rutas*, *recomendaciones*, *detección de fraude por relaciones*. Productos: **Neo4j**, **ArangoDB**, **Neptune** (y frameworks como **Giraph** para procesamiento distribuido). **Evitar** cuando necesites **actualizaciones masivas** homogéneas o modelar transacciones complejas tipo financiero tradicional. 

---

## 12. Cómo se conecta esto con nuestra UD1 (y con el resto del módulo)

En la **UD1** anclamos estos conceptos a tierra: **calidad**, **tipos**, **formatos** y **coste-tiempo**. En la **UD2** verás **ingesta desde APIs/CSV** hacia **Parquet** (y, si procede, hacia una **NoSQL** para servir lecturas rápidas), y en la **UD3** trabajaremos con **Spark** sobre ficheros columnares para **procesar a escala**. La idea no es que memorices catálogos, sino que sepas **reconocer el patrón**: *qué consultas vas a hacer, cuánto van a crecer los datos y qué latencia necesitas*. Con eso, elegirás el **modelo de datos** con criterio.

---

## 13. Epílogo: decisiones que pagan dividendos

Tres decisiones tempranas suelen dar **rendimientos compuestos**:

1. **Modelar desde las consultas**: evitarás particiones y claves que te perjudiquen.
2. **Persistir el *curated* en Parquet** aunque uses NoSQL para servir: tendrás **batch barato** y **BI rápido**.
3. **Pactar validaciones** (dominio, rangos, consistencia) aunque trabajes *schema-on-read*: la veracidad no se improvisa.

