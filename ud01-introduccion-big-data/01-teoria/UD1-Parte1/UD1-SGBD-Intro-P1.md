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
editor_options: 
  markdown: 
    wrap: sentence
---

# UD1 · Parte 1 — Big Data 101

## 1. Punto de partida: la promesa y el problema

Cada organización, desde un instituto hasta una multinacional, genera y recibe datos sin parar: ventas, visitas a una web, encuestas, sensores, documentación, imágenes, correos… La promesa del llamado *Big Data* es convertir ese ruido en decisiones mejores y más rápidas: planificar personal, ajustar stock, detectar fraude, optimizar rutas, personalizar contenidos, anticipar la demanda.
El problema es que los datos ya no caben en una sola hoja de cálculo ni obedecen a un único formato.
No llegan todos al mismo ritmo, no tienen la misma calidad y, sobre todo, no cuestan lo mismo de almacenar y procesar.
Big Data no es un eslogan: es el nombre de un conjunto de prácticas y tecnologías que hacen viable extraer valor de datos **grandes**, **rápidos** y **variados** sin arruinarnos por el camino.

## 2. Qué es Big Data (y qué no es)

Llamaremos Big Data a la capacidad de **obtener valor accionable** a partir de datos cuyo **volumen**, **velocidad** o **variedad** desbordan las herramientas tradicionales, y que exigen enfoques de **procesamiento y almacenamiento coste-eficientes**.
No es solo “datos enormes” ni “poner Hadoop/Spark y ya está”.
Tampoco es únicamente inteligencia artificial.
Big Data empieza **cuando los límites prácticos** de nuestras herramientas habituales (RAM, CPU de una sola máquina, tiempos de espera razonables) nos obligan a distribuir el almacenamiento y/o el cómputo, a elegir formatos más inteligentes y a automatizar el movimiento de datos con métodos reproducibles.

## 3. Por qué ahora: una convergencia

Hay tres fuerzas que explican el auge del Big Data.
Primero, la **digitalización** masiva: casi todo lo que hacemos deja huella en forma de evento, log o registro.
Segundo, la **caída del precio** del almacenamiento y el cómputo: clústeres con hardware “normalito” y la nube han hecho accesible lo que antes era exclusivo.
Tercero, el **ecosistema abierto**: proyectos como Spark, Kafka o sistemas columnares (Parquet, ORC) resolvieron cuellos de botella y democratizaron la analítica a gran escala.
El resultado es un terreno fértil: hoy es razonable plantearse preguntas complejas con datos verdaderamente voluminosos y obtener respuestas en tiempos útiles para el negocio.

## 4. Las “5 V” como manera de pensar

Hablar de Big Data sin las “5 V” es como hablar de cocina sin ingredientes.
No son una definición legal, sino una **brújula** para decidir arquitecturas y costes.

**Volumen.** Imagina años de ventas de un retail a nivel de ticket, más logs de navegación y devoluciones.
El volumen no es solo el tamaño total en disco: influye en cómo particionas los datos, en cuántos ficheros produces y en si un *join* cabe o no en memoria.

-   **Velocidad.** Hay casos en los que los datos llegan como un goteo continuo (sensores, clics, transacciones).
    Procesar al vuelo o por micro-lotes importa porque el valor caduca: detectar un pico de tráfico hoy vale; mañana, es historia.

-   **Variedad.** CSVs, JSON jerárquicos, tablas relacionales, imágenes, texto libre.
    La variedad nos obliga a **normalizar**, validar y traducir formatos para hacer posible el análisis conjunto.

-   **Veracidad.** Sin calidad, no hay decisión fiable.
    Nulos, duplicados, errores de formato o inconsistencias entre columnas pueden anular un KPI brillante.
    La veracidad exige reglas explícitas de validación y corrección.

-   **Valor.** La V más olvidada y la más decisiva.
    Todo lo anterior tiene sentido si termina en **acciones**: menos roturas de stock, menos abandono de clientes, más eficiencia operativa.

## 5. Tipologías de datos: estructura, latencia y sensibilidad

Cuando pensamos *qué datos tenemos*, conviene clasificarlos en tres dimensiones.
**Estructura.** Los datos **estructurados** viven en tablas con tipos claros y claves (ventas, alumnos, facturas).
Los **semiestructurados** (JSON, XML) mezclan jerarquías y listas; son flexibles para APIs y eventos.
Los **no estructurados** (texto, imagen, audio, vídeo) requieren técnicas específicas para ser “analizables”.
**Latencia.** Algunos datos exigen respuesta en **tiempo real** (milisegundos o segundos), otros permiten **lote** (minutos, horas, D+1).
La latencia determina tecnologías y costes: no es lo mismo apuntar una alerta inmediata que preparar un informe mensual.
**Sensibilidad.** No todo pesa lo mismo en términos legales y éticos.
Identificadores personales, salud o finanzas requieren otro nivel de control que datos anónimos o públicos.
Esta dimensión conecta con RGPD, gobierno y acceso.

## 6. Formatos: por qué Parquet gana al CSV (y cuándo usar Avro o JSON)

El formato es una decisión de coste y rendimiento camuflada de detalle técnico.
**CSV** es universal y humano, pero **caro** para analítica: cada lectura implica parsear texto y no permite saltar a columnas concretas.
**JSON** es ideal para intercambio y APIs; su jerarquía es expresiva, pero también **pesada** de procesar en grandes volúmenes.
**Parquet** y **ORC** almacenan por **columnas**, comprimen muy bien y permiten *predicate pushdown*: si solo necesitas `importe` de junio, no lees el resto.
Parquet se ha convertido en la **opción por defecto** para zonas *curated* de un *data lake*.
**Avro** almacena por filas y convive muy bien con **streaming** y **Kafka** gracias al *Schema Registry*.
Es apropiado cuando importa preservar el esquema versión a versión y la escritura es continua.
En resumen: **CSV/JSON para ingesta e intercambio**, **Parquet para analítica**, **Avro** para flujos de eventos y contratos de esquema.

## 7. Data warehouse, data lake y la idea de “lakehouse”

Un **data warehouse** tradicional prioriza estructura, gobernanza y rendimiento en SQL empresarial; obliga a transformar y cargar datos ya “limpios” y bien modelados.
Un **data lake** es barato y flexible: puedes aterrizar datos casi crudos, de muchos tipos, y procesarlos después.
El **lakehouse** intenta unir lo mejor de ambos: mantener datos en formatos de *lake* (Parquet) con **capas transaccionales** que ofrecen *ACID*, *time travel* y *upserts* (ej. Delta Lake, Iceberg, Hudi).
En la práctica educativa, basta con entender que el warehouse es el salón ordenado, el lake es el trastero enorme, y el lakehouse es el trastero ordenado con estanterías etiquetadas.

## 8. ETL o ELT: el orden de los factores sí altera el coste

En **ETL** transformas antes de cargar: útil cuando el destino es rígido y caro (un warehouse con licencias y reglas estrictas).
En **ELT** cargas primero al *lake* y transformas después, aprovechando cómputo elástico y barato.
Para este módulo trabajaremos mentalmente en **ELT**: aterrizamos en **raw**, estandarizamos en **processed** y publicamos en **curated**, casi siempre en **Parquet** y con **particionado temporal** (año, mes, día).
Esta estrategia simplifica el re-procesado, abarata experimentación y deja huella clara del linaje.

## 9. Un caso pequeño para amarrar ideas

Pensemos en un ayuntamiento que quiere **asignar personal** a oficinas de turismo y coordinarlo con **stock** en tiendas municipales.
Hay un CSV mensual con **afluencia turística por municipio**, y una API diaria con **ventas por canal** (tienda, web, app).
El flujo razonable es este, en prosa: los CSV aterrizan tal cual y se **normalizan tipos** (fechas, enteros).
La API se consulta a diario y se guarda en ficheros Parquet por día.
Con ambas fuentes en *raw*, se construye un **conjunto curado** uniendo por fecha y municipio.
A partir de ahí, se calculan **KPIs** sencillos: visitantes por día, venta media por canal, ratio venta/visitante.
La decisión práctica surge sola: si ayer hubo pico de visitantes y la venta *in situ* crece más que online, el **personal** se refuerza hoy en esas oficinas y se **reposiciona stock**.
No hace falta “predicción mágica” para crear valor: basta con **datos veraces, oportunos y bien modelados**.

## 10. Coste, calidad y tiempo: tres cuerdas que tensar

El triángulo *coste–calidad–tiempo* gobierna cada elección.
Un ejemplo: si dejamos todo en CSV para “no complicarnos”, el almacenamiento parece barato, pero la **lectura** y las uniones se vuelven lentas y frágiles; el tiempo de espera sube y acabamos “costando” más en horas y errores.
Otro ejemplo: declarar una columna `precio` como texto obliga a reconversiones y arruina la compresión; declararla como `double` desde el principio ahorra tamaño y acelera filtros.
Decidir **particionado por fecha** permite que una consulta de una semana no lea años completos.
Son decisiones pequeñas con impacto multiplicado.

## 11. Errores frecuentes y antídotos

El primer error es **coleccionar** datos sin plan de uso: acumular gigas no es una estrategia.
Debe existir una **pregunta de negocio** que haga de brújula.
El segundo es **idealizar** el tiempo real: la mayoría de decisiones aceptan **D+1**; perseguir latencias milimétricas sin necesidad eleva exponencialmente la complejidad.
El tercero es **subestimar la calidad**: un KPI espectacular construido sobre duplicados o fechas mal tipadas es humo.
Validar dominios, rangos y consistencia entre columnas es tan importante como el modelo visual que lo mostrará.
Y el cuarto, muy común, es **mantener CSV eternos** en producción: úsalo para intercambiar, pero persiste tu capa **curated** en **Parquet** y mide la mejora.

## 12. Qué viene a continuación en la UD1

Ahora que tenemos el mapa, nos meteremos en la mecánica: **EDA y calidad de datos** (qué mirar y cómo decidir), **tipado y limpieza**, **exportación eficiente a Parquet** y **primeras consultas interactivas con DuckDB**.
Veremos el impacto de pasar un dataset de CSV a Parquet en tamaño y velocidad, y cómo documentar, con cabeza, las decisiones que afectan a la veracidad y al coste.
