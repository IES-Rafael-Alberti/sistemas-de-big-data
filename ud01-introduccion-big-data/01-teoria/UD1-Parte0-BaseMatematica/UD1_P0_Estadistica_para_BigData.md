# UD1 · Parte 0 — Estadística aplicada para Big Data

## Propósito

Antes de limpiar datos, construir datasets, interpretar gráficos o entrenar modelos, necesitamos una base mínima de estadística aplicada.

No buscamos hacer matemáticas por hacer matemáticas. Buscamos entender los datos lo suficiente como para tomar buenas decisiones técnicas.

Esta parte ayuda a cubrir el **RA1** de Sistemas de Big Data, especialmente cuando habla de aplicar técnicas de análisis de datos, extraer información, construir datasets complejos y valorar calidad/coste de una solución.

## 1. Por qué estadística en Big Data

En Big Data no basta con cargar muchos datos. Hay que saber responder preguntas como:

- ¿Los datos tienen sentido?
- ¿Hay valores imposibles?
- ¿Hay variables muy relacionadas entre sí?
- ¿Hay datos sesgados?
- ¿Hay outliers que rompen el análisis?
- ¿Una gráfica muestra una relación real o sólo ruido?
- ¿Una variable aporta información o duplica otra?
- ¿La calidad del dataset permite tomar decisiones?

La estadística aplicada nos da herramientas para detectar estos problemas antes de construir dashboards, pipelines o modelos.

## 2. Tipos de variables

| Tipo | Ejemplos | Qué permite hacer |
| ---- | -------- | ----------------- |
| Numérica continua | temperatura, precio, peso, ingresos | medias, desviaciones, correlaciones, histogramas |
| Numérica discreta | nº de pedidos, nº de errores, nº de visitas | conteos, distribuciones, agregaciones |
| Categórica nominal | ciudad, producto, país, tipo de cliente | frecuencias, agrupaciones, segmentación |
| Categórica ordinal | bajo/medio/alto, nivel de riesgo | comparación ordenada, ranking |
| Temporal | fecha, hora, timestamp | series temporales, ventanas, tendencia |
| Texto/no estructurada | comentarios, logs, reseñas | extracción, clasificación, búsqueda |

Primera regla práctica: **no se visualiza ni se transforma igual una variable numérica que una categórica o temporal**.

## 3. Medidas básicas

### Media

La media resume el valor promedio.

Problema: es sensible a outliers.

Ejemplo: si la mayoría de ventas están entre 10 y 100 euros, pero aparece una venta de 100.000 euros, la media puede dejar de representar bien el comportamiento normal.

### Mediana

La mediana es el valor central al ordenar los datos.

Suele ser más robusta cuando hay outliers.

### Moda

La moda es el valor más frecuente.

Es útil en variables categóricas.

### Desviación típica

Mide cuánto se dispersan los valores respecto a la media.

Una desviación alta indica datos muy variables; una desviación baja indica datos concentrados.

### Rango e IQR

- Rango: máximo - mínimo.
- IQR: rango intercuartílico, entre Q1 y Q3.

El IQR ayuda a detectar outliers de forma más robusta.

## 4. Distribuciones

Una distribución describe cómo se reparten los valores de una variable.

Preguntas útiles:

- ¿Los datos están concentrados o dispersos?
- ¿Hay una cola larga?
- ¿Hay varios grupos?
- ¿Hay valores extremos?
- ¿La variable parece normal, sesgada o irregular?

Visualizaciones típicas:

- Histograma.
- Boxplot.
- Curva de densidad.
- Barras de frecuencia.

## 5. Outliers

Un outlier es un valor extremo respecto al resto.

No siempre es un error.

Puede ser:

- un dato mal introducido,
- una unidad incorrecta,
- un caso raro pero real,
- una señal de fraude,
- un evento especial,
- una oportunidad de análisis.

Regla importante: **no se borran outliers sin justificar**.

Antes de actuar:

1. Detectar.
2. Entender.
3. Decidir.
4. Documentar.

## 6. Correlación

La correlación mide la relación entre dos variables numéricas.

Valores típicos:

| Correlación | Interpretación aproximada |
| ----------- | ------------------------- |
| Cerca de 1 | relación positiva fuerte |
| Cerca de -1 | relación negativa fuerte |
| Cerca de 0 | poca relación lineal |

Ejemplo:

- Si aumenta la inversión publicitaria y aumentan las ventas, puede haber correlación positiva.
- Si aumenta el tiempo de carga de una web y baja la conversión, puede haber correlación negativa.

Pero cuidado:

> Correlación no implica causalidad.

Dos variables pueden estar relacionadas por casualidad o por una tercera variable oculta.

## 7. Scatter plots

Un scatter plot muestra puntos para comparar dos variables numéricas.

Sirve para ver:

- relaciones lineales,
- relaciones no lineales,
- grupos,
- outliers,
- patrones raros,
- dispersión.

Preguntas para interpretar un scatter plot:

- ¿Los puntos suben o bajan?
- ¿Hay forma clara o sólo nube?
- ¿Hay grupos separados?
- ¿Hay puntos aislados?
- ¿La relación parece lineal?
- ¿Puede haber una variable externa explicando el patrón?

## 8. Colinealidad

Hay colinealidad cuando dos o más variables explican casi lo mismo.

Ejemplo:

- `precio_total`
- `precio_sin_iva`
- `iva`

O:

- `metros_cuadrados`
- `numero_habitaciones`

Problema:

- Puede confundir modelos.
- Puede duplicar información.
- Puede hacer que una explicación parezca más sólida de lo que es.

En limpieza y preparación de datos, conviene detectar variables redundantes.

## 9. Sesgo

Un dataset está sesgado cuando no representa bien la realidad que pretende estudiar.

Ejemplos:

- Sólo hay datos de clientes de una ciudad.
- Faltan datos de ciertos meses.
- Hay más registros de un tipo de usuario que de otro.
- Los datos vienen de una fuente con comportamiento especial.

El sesgo puede hacer que un dashboard o modelo parezca correcto pero tome malas decisiones.

## 10. Calidad de datos

Dimensiones habituales:

| Dimensión | Pregunta |
| --------- | -------- |
| Completitud | ¿Faltan datos? |
| Validez | ¿Los valores cumplen reglas esperadas? |
| Consistencia | ¿Los datos coinciden entre fuentes? |
| Unicidad | ¿Hay duplicados? |
| Actualidad | ¿Los datos están actualizados? |
| Precisión | ¿Reflejan la realidad con suficiente exactitud? |

Estas dimensiones conectan directamente con limpieza, integración y construcción de datasets complejos.

## 11. Relación con Big Data

En datasets pequeños, un error puede detectarse a ojo.

En Big Data, eso no escala.

Por eso necesitamos:

- métricas automáticas,
- validaciones,
- perfiles de datos,
- dashboards de calidad,
- reglas reproducibles,
- documentación de decisiones.

La estadística aplicada no es un añadido teórico: es una herramienta para no construir sistemas Big Data sobre basura.

## 12. Checklist de análisis inicial

Antes de usar un dataset:

- [ ] Identifico tipos de variables.
- [ ] Calculo medidas básicas.
- [ ] Reviso nulos.
- [ ] Reviso duplicados.
- [ ] Reviso outliers.
- [ ] Analizo distribuciones.
- [ ] Compruebo correlaciones relevantes.
- [ ] Busco colinealidad.
- [ ] Reviso posibles sesgos.
- [ ] Documento decisiones de limpieza.

## 13. Qué debe saber explicar el alumnado

Al terminar esta parte, el alumnado debe poder explicar:

- qué tipo de variables tiene un dataset,
- qué medidas resumen mejor cada variable,
- qué muestra un histograma,
- cómo interpretar un boxplot,
- cómo leer un scatter plot,
- qué significa correlación,
- por qué correlación no implica causalidad,
- qué es colinealidad,
- qué problemas de calidad existen,
- qué decisiones de limpieza aplicaría y por qué.
