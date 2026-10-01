# UD1 · Big Data 101 (Conceptos esenciales)  
**Curso:** 2026/2027

> **Problema de partida (realista):**  
Una cadena minorista sufre **roturas de stock** y discrepancias en ventas porque recibe datos diarios desde tiendas en **CSV** y de e‑commerce en **JSON**. Hay **retrasos** (datos llegan con 48–72 h), **inconsistencias** en códigos SKU y **duplicados** cuando se reenvían ficheros. Dirección pide **indicadores fiables** y **tiempos de respuesta menores**.

Antes de elegir herramientas conviene entender el problema. La empresa no tiene
un único dato “malo”: tiene datos que llegan desde sitios distintos, con ritmos
distintos y con significados que deben cuadrar. Si el mismo producto aparece con
dos códigos diferentes, si las ventas online llegan dos días tarde o si un
fichero se procesa dos veces, los indicadores de dirección dejan de ser fiables.
Big Data empieza precisamente ahí: cuando el reto no es solo guardar datos, sino
**integrarlos, validarlos y convertirlos en decisiones a tiempo**.

## 0. Vocabulario mínimo del caso

| Término | Qué significa | Por qué importa aquí |
|---|---|---|
| **SKU** | Código único de producto (*Stock Keeping Unit*). Por ejemplo, una camiseta roja talla M puede tener un SKU distinto a la misma camiseta en talla L. | Si el mismo producto aparece con códigos distintos, se rompen los recuentos de ventas y stock. |
| **Catálogo maestro** | Tabla o sistema de referencia con la versión válida de productos, tiendas, canales u otras entidades. | Sirve para comprobar si un SKU existe, cómo se llama y a qué categoría pertenece. |
| **Fuente de verdad** | Sistema que se toma como referencia cuando dos fuentes discrepan. | Evita que cada equipo use una versión distinta del mismo dato. |
| **Dato raw** | Dato tal como llega, sin corregir ni enriquecer. | Permite auditar errores y reprocesar si una regla de limpieza estaba mal. |
| **Dato curado** | Dato limpio, tipado, validado y documentado para análisis. | Es el que debería alimentar informes, consultas y dashboards. |

## 1. Qué es Big Data y las 5V
- **Volumen, Velocidad, Variedad, Veracidad, Valor** (y **Variabilidad**).
- Riesgos típicos: *garbage in → garbage out*, sesgos, datos retrasados.

Las 5V no son una lista para memorizar, sino una forma de diagnosticar el
problema. **Volumen** pregunta cuánto dato tenemos y cuánto crecerá. **Velocidad**
pregunta cada cuánto llega y cuánto tarda en ser útil. **Variedad** mira formatos
y estructuras diferentes: CSV, JSON, tablas, logs o eventos. **Veracidad** mide si
podemos confiar en el dato. **Valor** obliga a conectar todo lo anterior con una
decisión concreta: reducir roturas de stock, detectar errores o mejorar tiempos
de respuesta.

**Aplicado al problema:**  
- Volumen moderado (pero creciente).  
- Velocidad irregular (lotes diarios con picos).  
- Variedad (CSV y JSON).  
- Veracidad baja (duplicados, dominios incorrectos).  
- Valor depende de tiempos y calidad.

## 2. Procesos de datos: ETL, ELT y compañía
- **ETL**: extraer → transformar → cargar (útil cuando el destino es DW con reglas estrictas).
- **ELT**: extraer → cargar → transformar *in‑place* (útil con *lakes* y compute barato).  
- **Wrangling/Cleansing**: normalización, tipado, imputación, deduplicación.  
- **Enrichment**: añadir dimensiones (catálogo maestro SKU, calendario, divisas).  
- **Batch vs micro‑batch vs streaming** (en UD3 veremos micro‑batch con Spark).

En **ETL**, el dato se corrige antes de entrar en el sistema analítico. Es útil
cuando el destino exige mucha estructura desde el principio. En **ELT**, primero
guardamos el dato y lo transformamos después; esto facilita conservar el raw,
reprocesar y comparar versiones. En este módulo usaremos a menudo esta segunda
mentalidad: aterrizar, comprobar, limpiar y publicar.

**Batch** significa procesar por lotes: por ejemplo, todas las ventas de ayer.
**Micro-batch** son lotes pequeños y frecuentes: cada pocos minutos. **Streaming**
procesa eventos de forma continua. No siempre hace falta streaming: si el informe
diario resuelve el problema, batch será más barato y fácil de mantener.

**Decisión para el caso:**  
- Empezar con **ELT ligero en *data lake*** (Parquet particionado) + **curado** con reglas de calidad.  
- Catálogo maestro como **fuente de verdad** para códigos SKU.

## 3. Almacenamiento y formatos
- **Data Lake** (S3/HDFS/MinIO) vs **Warehouse** (OLAP) vs **Lakehouse** (tablas ACID sobre lake: Delta/Iceberg/Hudi).
- Formatos: **CSV** (simple), **JSON** (flexible), **Parquet** (columna, compresión, *predicate pushdown*).

Un **data lake** es una zona de almacenamiento flexible donde pueden convivir
datos crudos y transformados en ficheros. Un **data warehouse** está más orientado
a consulta analítica estructurada, con tablas modeladas para informes. Un
**lakehouse** intenta unir ambas ideas: mantener la flexibilidad del lake, pero
añadiendo control de tablas, transacciones y versiones. Tecnologías como Delta
Lake, Iceberg o Hudi aportan esas capas, aunque en UD1 nos basta con entender el
concepto.

Los formatos también son una decisión de arquitectura. **CSV** es fácil de abrir,
pero obliga a leer y parsear texto. **JSON** es cómodo para APIs y datos
jerárquicos, pero puede ser pesado para analítica. **Parquet** guarda por columnas,
comprime bien y permite leer solo lo necesario. Eso es el *predicate pushdown*:
si una consulta pide junio y la columna `importe`, el motor puede evitar leer
partes irrelevantes del dataset.

**Decisión práctica:**  
- Aterrizar *raw* en el lake y **curar** a **Parquet** particionado por **fecha** y **canal**.  
- Consultar con **DuckDB** directamente sobre Parquet para exploración.

## 4. Coste ↔ Calidad ↔ Tiempo
- Compresión (snappy/zstd), particionado correcto, y tipado **reducen coste** y **mejoran tiempo**.
- **Métricas de calidad** (ver doc UD1_02) guían decisiones objetivas.

## 5. Checklist conceptual rápido (para usar en el resto del curso)
- [ ] ¿Cuál es el **objetivo de valor** del dato?  
- [ ] ¿Qué **V**s dominan este caso?  
- [ ] ¿ETL o ELT? ¿Dónde se transformará?  
- [ ] ¿Lake, Warehouse o Lakehouse? ¿Por qué?  
- [ ] ¿Formato y **particionado**?  
- [ ] ¿Qué **métricas de calidad** se seguirán?

---

## Actividad A (20’) — “Big Data en una página”
- Actividad formativa de aula, integrada en la segunda clase. Completa una página con las 5V del caso, una decisión ETL/ELT, el flujo raw → curado y una comparación **Parquet vs CSV** con dos razones. No se califica ni se entrega como tarea independiente.
