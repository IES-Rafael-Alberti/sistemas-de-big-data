# UD1 · Parte 4 — EDA y calidad de datos (capítulo ampliado)

## 1. Por qué empezamos por EDA y calidad

Antes de modelar, de “hacer BI” o de entrenar un algoritmo, hay una pregunta silenciosa que manda: **¿confías en tus datos?** La **Exploratory Data Analysis (EDA)** no es una galería de gráficos bonitos, sino una *conversación seria* con el dataset para entender su forma, su salud y sus límites. La **calidad de datos** traduce esa conversación en **reglas medibles** (completitud, unicidad, validez, consistencia, puntualidad) y en **decisiones trazables**: qué conservamos, qué corregimos, qué etiquetamos y qué descartamos. Hacer EDA sin calidad produce *insights* frágiles; vigilar la calidad sin EDA es medir a ciegas.

## 2. Punto de partida y preparación mínima

Trabajaremos con una copia “inmutable” del **raw** y una zona de trabajo que podamos rehacer. Conviene fijar desde el minuto cero tres hábitos:

1. **Tipado explícito** al leer (fechas como fechas, números como números, categorías como categorías).
2. **Registro de decisiones**: cada corrección debe dejar un rastro breve (el “por qué” y el “cuánto” que cambia).
3. **Reproducibilidad**: un cuaderno o script que pueda ejecutarse de nuevo y produzca los mismos resultados (o explique por qué no).

En la práctica: al leer, definimos separadores y codificaciones, normalizamos mayúsculas/minúsculas y espacios en variables clave, y comprobamos el **esquema** esperado (nombres y tipos).

## 3. EDA con sentido: qué miramos y por qué

El EDA empieza con una radiografía y sigue con análisis clínico.

**Radiografía básica.** Tamaño (filas/columnas), rango temporal cubierto, tipos inferidos, memoria aproximada, *top N* valores en categóricas, cinco números de Tukey en numéricas. Esta foto inicial ya suele destapar problemas: fechas como texto, importes como cadenas con comas, códigos mezclados con nombres.

**Distribuciones.** En variables numéricas buscamos forma (simetría/sesgo), presencia de valores imposibles y **outliers**. El **histograma** sirve para ver la masa; el **boxplot** para detectar extremos con rapidez; en series temporales, una **línea agregada por día/semana** muestra estacionalidad y huecos. En categóricas interesa la **cardinalidad** (cuántos valores distintos), la concentración (¿dos categorías son el 90%?) y los valores raros (errores tipográficos, códigos huérfanos).

**Relaciones.** Entre numéricas, una **matriz de correlaciones** orienta sobre redundancias; entre una categórica y una numérica, **barras con media/mediana** ayudan a ver diferencias; entre dos categóricas, una **tabla de contingencia** revela combinaciones imposibles. Para nubes densas, un **hexbin** o una **muestra aleatoria** evita el “manchón” ilegible.

> Por qué estas visualizaciones y no otras: en EDA buscamos **lectura rápida** y **decisiones** (qué arreglar y cómo). Evitamos gráficos 3D y tartas decorativas; preferimos histogramas/boxplots para forma y extremos, barras/contingencias para proporciones, líneas para tiempo.

## 4. Calidad de datos: reglas que se pueden medir

Usaremos cinco dimensiones. Cada una debe tener **definición**, **métrica** y **umbral** (o *expectativa*) acordados.

**Completitud.** Proporción de valores **no nulos** en una columna o clave. Se mide como `no_nulos / total`. Útil por columna y por combinación de columnas que formen una **clave natural** (por ejemplo, `fecha + tienda + sku`).

**Unicidad.** Verifica que una **clave** identifica una fila (o que los duplicados cuestan poco). Se mide como `1 - (duplicadas / total)` o sencillamente “% de filas duplicadas por clave”. Aquí entran también los **duplicados aproximados** (mismos campos salvo mayúsculas/espacios).

**Validez.** Comprueba que los valores respetan **dominios** y **rangos**: `canal ∈ {tienda, web, app}`, `0 ≤ unidades ≤ 500`, `precio > 0`. Para textos estructurados, usamos **regex** (“fecha `YYYY-MM`”, “ID con 8 dígitos”, “código postal de 5 cifras”). La métrica típica es “% de filas que cumplen la regla”.

**Consistencia (entre columnas).** Reglas que cruzan campos: `importe ≈ unidades*precio` (con una **tolerancia** de redondeo), `fecha_fin ≥ fecha_inicio`, `categoría` concordante con `sku`. También incluye **integridad referencial** entre tablas (claves que existen en la dimensión).

**Puntualidad/Actualidad.** Vigila la **recencia** de los datos: ¿hasta qué fecha llega el dataset? ¿Cuántos días han pasado desde el último registro? En pipelines, definimos *SLAs* simples (por ejemplo, “los datos de ayer deben estar antes de las 10:00”).

> Consejo operativo: empieza por 8–12 reglas **críticas** y amplía solo si aportan valor; demasiadas reglas sin priorizar entorpecen.

## 5. Outliers y valores faltantes: decisiones con coste

**Outliers.** Detectarlos es fácil, decidir qué hacer es lo difícil. Tres métodos prácticos:

* **IQR** (cuartiles): marca como extremo lo que cae por debajo de `Q1 − 1.5·IQR` o por encima de `Q3 + 1.5·IQR`. Robusto, rápido.
* **Z-score**: distancia en desviaciones estándar respecto a la media. Útil en distribuciones ~normales.
* **MAD** (desviación absoluta mediana): robusto frente a colas pesadas.

Qué hacer con ellos: **corregir** si hay error claro (precio con separador mal puesto), **capar** (*winsorize*) si estropean un KPI pero las colas son razonables, **etiquetar** si aportan información (picos reales de venta). Eliminar a ciegas introduce sesgo.

**Valores faltantes.** Tres estrategias:

* **Eliminar** filas/columnas si la pérdida es pequeña y no rompe llaves.
* **Imputar** con **mediana/moda** (robusto) o **forward/backward fill** en series temporales.
* **Etiquetar**: crear una bandera `missing_<col>` y, si procede, imputar conservadoramente. Documenta siempre el porcentaje afectado y el impacto esperado.

## 6. “Eliminar, limpiar o etiquetar”: una regla simple para decidir

* **Eliminar** cuando el valor viola el **dominio** de forma inequívoca y el porcentaje es bajo (por ejemplo, fechas 2099 en datos históricos, cantidades negativas imposibles).
* **Limpiar** cuando hay un **patrón sistemático** (espacios, mayúsculas, formatos decimales, códigos inconsistentes) o un error corregible (separador coma/punto).
* **Etiquetar** cuando no puedes estar seguro: conserva el registro pero añade una **marca de calidad** (`fuera_rango`, `importe_desviado`, `fecha_inverosímil`) para poder filtrar o ponderar después.

Esta regla evita convertir el EDA en una trituradora de datos o, en el extremo contrario, en un museo de errores.

## 7. Coherencia entre columnas: ejemplos que de verdad pasan

* **Armonía aritmética**: `importe ≈ unidades*precio`. Define una tolerancia (por ejemplo, ±2%) y mide la tasa de incumplimiento.
* **Fechas compatibles**: `fin ≥ inicio`, ausencia de intervalos superpuestos para la misma entidad, cobertura sin huecos si se espera periodicidad.
* **Codificación consistente**: `canal` no debe mezclar `web` / `WEB` / `W`. Define una **tabla de correspondencias** y normaliza.
* **Integridad referencial**: cada `sku` en la tabla de hechos debe existir en la dimensión de productos; si no existe, etiquétalo como **huérfano** y decide si es alta o baja la incidencia.

## 8. Métricas de calidad: fórmulas y lectura

Conviene resumir las métricas en una tabla “antes → después”. Un ejemplo de lectura:

* **Completitud** en `precio`: 98,7% → 99,9% tras imputar 0,9 p.p. con mediana y corregir el separador decimal en 0,3 p.p.
* **Unicidad** de `(fecha, tienda, sku)`: 99,2% → 100% tras normalizar `sku` y eliminar duplicados exactos con *keep=first*.
* **Validez** de `canal`: 95,1% → 100% al mapear `WEB/online` a `web`.
* **Consistencia** `importe` vs `unidades*precio` (±2%): 92,4% → 99,1% tras corregir tipos y redondeos.
* **Puntualidad**: ayer a las 08:00 → ayer a las 06:00 tras ajustar el job de ingesta.

No es obligatorio llegar al 100% en todo: la clave es **explicar los compromisos** y fijar umbrales aceptables para negocio.

## 9. Exportación eficiente y trazabilidad

Cuando el dataset ya es **coherente**, escribimos a **Parquet** con **particionado** por columnas de filtrado natural (por ejemplo, `anio/mes` y, si tiene sentido, `canal` o `tienda`). Elegimos compresión `snappy` o `zstd` y dejamos un **diccionario de datos** con: nombre, tipo, descripción, unidades, dominio/rango y notas de limpieza. Añadimos dos detalles útiles:

* un **`quality_report.json`** con las métricas (para comparar versiones),
* y una **marca de versión** en la ruta (`/curated/v=2024_10_06/`), que evita sobrescribir sin querer y facilita auditoría.

## 10. Mini-guía de visualizaciones rápidas (y por qué)

* **Histograma** para forma y cortes de valores; base de casi todas las decisiones de límites.
* **Boxplot** para hacerse una idea de **dispersión y extremos** sin ruido visual.
* **Barras (top-k)** en categóricas para ver concentración y detectar valores “basura”.
* **Línea temporal** agregada por día/semana para **huecos** y **estacionalidad**.
* **Correlación** (mapa de calor) en numéricas para detectar redundancias o relaciones útiles.
* **Hexbin**/**sample** para nubes densas, evitando el “manchurrón” que no dice nada.

Evita tartas 3D y gráficos ornamentales: a mayor adorno, peor lectura en EDA.

## 11. Ejemplo breve, de principio a fin (en prosa)

Llegan ventas diarias y catálogo de productos. Al leer, parseamos `fecha` y tipamos `precio`/`unidades` como numéricos; normalizamos `sku` a mayúsculas sin espacios. Vemos que `canal` tiene `WEB/online/web`; elegimos `web` como forma canónica y mapeamos el resto. El histograma de `precio` muestra una cola larga; aplicamos **IQR** para detectar extremos y descubrimos precios con coma como separador (se habían leído como texto). Tras corregirlo, la **consistencia** `importe ≈ unidades*precio` sube del 92% al 99%. La **completitud** en `precio` pasa del 98,7% al 99,9% con **mediana** para los pocos nulos restantes (dejamos bandera `precio_imputado=1`). Exportamos a **Parquet** particionando por `anio/mes`. El **benchmark**: el Parquet ocupa la mitad que el CSV y las consultas en DuckDB responden en segundos en vez de decenas.

## 12. Checklist de cierre (para tu UD1)

* El **esquema** está declarado y comprobado al leer.
* Hay **métricas** de calidad antes y después, con **umbral**/objetivo y breve justificación.
* Se tomaron decisiones de **eliminar/limpiar/etiquetar** y están documentadas.
* Existen **gráficos rápidos** que demuestran forma, extremos y relaciones clave.
* El **curated** está en **Parquet** con **particionado razonado** y **diccionario de datos**.
* Se guardó un **reporte de calidad** junto con la versión publicada.

## 13. Para profundizar (lecturas prácticas)

* *Fundamentals of Data Engineering* (Reis & Housley): capítulos de ingestión, validación y *data contracts*.
* *Designing Data-Intensive Applications* (Kleppmann): integridad, consistencia y modelos de almacenamiento.
* Documentación oficial de **pandas/polars**, **DuckDB** y **Parquet** para detalles de tipado, lectura eficiente y *predicate pushdown*.
* Herramientas de validación basadas en expectativas (por ejemplo, implementar tus propias “reglas” simples y medir su cumplimiento en cada *run*).

