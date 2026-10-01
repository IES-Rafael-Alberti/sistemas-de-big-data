# UD1 · Parte 0 · 0 — Por qué vamos a necesitar estadística

## Propósito

Este documento es la puerta de entrada a la base matemática del módulo. Parte del
**caso de comercio que se presentó en la primera sesión** y hace dos cosas:

1. Convierte ese caso de negocio en un **primer diseño técnico**, con decisiones
   explícitas y justificadas.
2. Muestra por qué ese diseño, por sí solo, **no es suficiente** y por qué
   necesitamos estadística (y algo de matemática discreta, lógica y complejidad)
   para poder interpretar los datos que produce.

No es un capítulo de matemáticas. Es el puente entre un problema que cuenta una
persona de negocio y unas decisiones técnicas que hay que defender.

> La estadística descriptiva no es un adorno: ayuda a convertir una tabla de datos
> en un argumento defendible. Empezamos aquí.

## 1. De dónde viene este documento

En la primera sesión planteamos un caso sin usar todavía vocabulario técnico: una
cadena de tiendas que vende en tienda física y online, con datos que llegan de
sitios distintos, con ritmos distintos y con significados que no siempre cuadran.

La pregunta que se dejó abierta fue: *¿qué puede salir mal cuando juntamos datos
de varias fuentes?*

Este documento recoge esa pregunta, la convierte en un diseño y luego muestra el
límite del diseño: podemos construir el pipeline perfecto y seguir tomando
decisiones equivocadas si no sabemos cómo leer los números que salen.

## 2. El caso, con los datos concretos

La cadena **`CadenaRetail`** vende en tiendas físicas y online. Dirección pide
**indicadores fiables** y **tiempos de respuesta menores**. Los nombres de SKU y
los pedidos que aparecen más adelante son datos didácticos inventados para poder
trabajar el caso; no formaban parte de la presentación inicial.

Antes de fijar una métrica, habrá que concretar qué significa «tiempo de
respuesta» en la petición: puede referirse al tiempo de consulta del sistema o al
tiempo de entrega de un pedido. El ejemplo estadístico usa entregas sintéticas
solo para mostrar cómo se interpretan distribuciones y valores extremos.

El síntoma que llega desde negocio no es técnico, es comercial:

> «No nos cuadran las ventas. Aparecen roturas de stock en productos que
> teóricamente había, y los gerentes de zona discuten cifras distintas sobre el
> mismo día.»

Detrás de ese síntoma hay cuatro problemas técnicos distintos, y conviene no
mezclarlos:

| # | Problema | Detalle |
| --- | --- | --- |
| 1 | **Retraso** | Tiendas envían CSV diario, e-commerce manda JSON. Todo llega con 48–72 h de retraso. |
| 2 | **SKU inconsistentes** | La misma camiseta rojo M llega como `TS-ROJO-M` desde tienda y como `TSHIRT_4421` desde la web. |
| 3 | **Duplicados** | Si un fichero se reenvía, las líneas se cargan dos veces. |
| 4 | **Importes sin validar** | Hay filas donde `precio_total != unidades * precio_unitario`. |

Fíjate en que son problemas distintos: unos aparecen al combinar fuentes
(formatos y códigos), otros al procesar repetidamente los mismos ficheros
(duplicados) y otros requieren controles de calidad sobre el contenido
(importes).

## 3. De síntoma de negocio a causa técnica

Este es el trabajo real: traducir «no nos cuadran las ventas» a algo que se puede
diseñar.

| Síntoma que dice negocio | Causa técnica | Respuesta de diseño |
| --- | --- | --- |
| Roturas de stock en productos que «había» | El stock se descuenta cuando **cargamos** el fichero, no cuando **ocurrió** la venta | Guardar `fecha_evento` y `fecha_carga` por separado, y decidir reposición con `fecha_evento` |
| Dos gerentes ven cifras distintas del mismo día | Cada uno consulta su fuente antes de integrar | Una única tabla curada donde el canal es una columna, no dos informes |
| Las ventas están infladas | Duplicados por reenvío de ficheros | Clave idempotente y deduplicación en la zona curada |
| Aparecen productos que «no existen» | SKU distintos para el mismo producto | Catálogo maestro como fuente de verdad + tabla de correspondencia |
| Salen importes imposibles | Tipos y reglas no validados en la carga | Validación tipada antes de publicar |

La última fila es la más importante conceptualmente: **no basta con mover datos,
hay que decidir qué se acepta y qué se rechaza.** Y esa decisión necesita un
criterio, no una opinión.

## 4. Primer diseño técnico

Un primer diseño no es el diseño final. Es el mínimo razonable que ya permite
razonar. Lo ampliamos en las unidades siguientes.

### 4.1 Las cuatro capas

```text
  Tiendas (CSV) ───────┐
                       │
  E-commerce (JSON) ────┼──▶ LANDING (raw) ──▶ CURADO ──▶ SERVING
                       │     originales       Parquet     ventas y vistas
  Catálogo maestro ─────┘     CSV/JSON         tipado
        (referencia SKU)      conservados      validado
```

**Landing (raw).** Se conservan los ficheros originales tal como llegan (CSV de
tiendas y JSON de e-commerce), junto con metadatos de recepción. Esta copia es
inmutable: permite auditar y reprocesar sin volver a pedir los ficheros a las
fuentes.

**Curado.** Zona donde el dato se tipa, se deduplica, se unifica contra el
catálogo maestro y se validan las reglas. Se publica en Parquet, particionado
con criterio y volumen adecuados, y se conservan `fecha_evento` y
`fecha_carga`.

**Serving.** La tabla que consumen informes y dashboards. A partir de este punto,
el resto del módulo trabaja sobre datos de los que se puede responder «¿de dónde
sale este número?».

**Catálogo maestro.** No es una capa del pipeline: es la **fuente de verdad**
contra la que se validan los SKU. Sin él, el problema del punto 2 no tiene una
solución fiable.

### 4.2 Las decisiones que tomamos, y por qué

| Decisión | Alternativa descartada | Motivo |
| --- | --- | --- |
| **ELT** (aterrizar, luego transformar) | ETL (transformar antes de cargar) | Queremos conservar el raw para auditar y reprocesar. El coste de datos brutos es bajo. |
| **Parquet en Curado** | Analizar repetidamente CSV / JSON | Es columnar y comprime bien para consultas analíticas; Raw conserva los originales. |
| **Particionado en Curado, si el volumen lo justifica** | Particionar por defecto | La clave de partición se elige midiendo volumen y consultas; particionar demasiado genera ficheros pequeños y sobrecoste. |
| **Procesamiento por lotes como primera versión** | Streaming desde el inicio | Las fuentes envían lotes diarios y streaming añade complejidad; el retraso de 48–72 h exige además mejorar la entrega desde origen. |
| **Clave idempotente basada en un identificador estable de línea de pedido** | Confiar en que no llegan duplicados | Reprocesar el mismo evento no debe volver a contar la venta; la clave se confirma con el esquema real de origen. |

Sobre la última fila merece la pena detenerse: una clave idempotente bien elegida
convierte un problema de calidad (duplicados) en una propiedad del diseño. Eso es
preferible a detectar y limpiar duplicados cada día.

### 4.3 Lo que todavía NO hacemos

Un buen diseño sabe lo que descarta:

- **No** montamos un dashboard. Dirección pidió indicadores fiables; un dashboard
  sobre datos sin medir no es fiable, es decorativo.
- **No** entrenamos modelos. Primero hacen falta un histórico limpio y una
  pregunta predictiva concreta.
- **No** usamos streaming. Sería optimizar un problema que aún no está medido.
- **No** fijamos aún la SLA de entrega. Para eso necesitamos saber cómo se
  distribuyen los tiempos reales, y eso es un dato estadístico.

Ese último punto es el puente con la sección siguiente.

## 5. El problema que el diseño no resuelve

Con el diseño anterior, la cadena tiene un pipeline ordenado, tipado y
auditable. Y aun así, dos cosas siguen sin respuesta:

1. ¿El pedido de 168 horas es un **error de captura** o una **entrega
   realmente tardía**? El pipeline lo ha ingerido correctamente en ambos casos.
2. ¿Es aceptable que la desviación típica de los tiempos de entrega sea de 44
   horas? La respuesta depende de qué se considere «normal» en esta empresa, y eso
   no lo decide un `SELECT`.

El pipeline garantiza que el dato llega **entero**. No garantiza que su
contenido signifique algo.

Y hay un tercer punto, más incómodo: la dirección pidió «indicadores fiables».
Fíjate en que **fiabilidad es una afirmación estadística**, no técnica. Un
indicador no es fiable o no lo es *en relación a una distribución*. No existe
«el indicador fiable» en abstracto.

## 6. Por qué hace falta estadística

### 6.1 Un valor suelto no se puede interpretar

El pedido de 168 h, aislado, no permite saber si es un error o una entrega real.
La estadística no resuelve esa causa, pero permite compararlo con los demás
pedidos y cuantificar cuánto se aparta del patrón observado.

En el ejemplo, siete de los diez pedidos tardan 30 h o menos y uno tarda 168 h.
La distribución deja visible esa diferencia; no demuestra por sí sola si el
registro es erróneo ni si representa el comportamiento habitual de toda la cadena.

> La estadística ayuda a detectar valores inusuales y medir su distancia respecto
> al conjunto. Investigar su origen y decidir qué hacer son tareas del negocio y
> de ingeniería.

### 6.2 «Indicadores fiables» es una afirmación estadística

Un indicador útil se enuncia de forma verificable, y casi siempre en términos de
distribución:

- «La entrega media es de 28 horas» resume un aspecto del conjunto, pero puede
  ocultar la cola de entregas lentas.
- «El 90% de los pedidos de este periodo se entrega en menos de X horas» es una
  afirmación comprobable mediante un percentil; el objetivo X debe acordarse con
  negocio y medirse con un periodo representativo.

El segundo enunciado es el que dirección puede exigir y el que un pipeline puede
verificar cada día. Es una diferencia de fondo entre un informe y un sistema.

### 6.3 Detectar es fácil; decidir qué hacer es el problema real

La estadística marca el valor sospechoso. **No te dice si es un error.** Eso es
trabajo de ingeniería y de negocio, y hay que decidirlo explícitamente.

El ejemplo de la sección 8 lo deja claro: quitar la fila de 168 h baja la
desviación típica de 44,32 h a 2,93 h. Las dos lecturas son «correctas»:

| Lectura | Cuándo es la decisión correcta |
| --- | --- |
| Es un error de captura → descartar | El valor no es representativo del proceso real |
| Es una entrega real tardía → conservar | El valor ES el proceso real, y por eso hay que arreglarlo |

Un pipeline que borra outliers sin criterio está **mintiendo con la mejor
intención**. Un pipeline que los conserva todos está **ocultando un problema
operativo**. La estadística te da los números de esa decisión; la decisión es
tuya.

### 6.4 Porque los datos también mienten

La sesión 1 ya planteó los riesgos de datos incompletos y discordantes. La
estadística permite hacer algunos de esos problemas explícitos y medibles:

| Sesgo | Cómo se detecta | Qué riesgo tiene |
| --- | --- | --- |
| Sólo hay datos de 3 provincias | Comparar el recuento por `ciudad` con la lista real | Decidir reposición sólo donde hay datos |
| Faltan los lunes | Completitud por día de la semana | Concluir que lunes se vende poco cuando no se registró |
| Un canal manda 90% de los registros | Moda y frecuencias por `canal` | Ajustar stock online cuando el problema es de tienda |

Nótese que estos problemas se pueden investigar con **recuentos y
comparaciones**, antes de recurrir a modelos.

### 6.5 Y las medidas cuestan: exacto o aproximado

En diez filas ordenamos todo y listo. En cien millones, ordenar puede ser
inviable. Muchas herramientas ofrecen medidas aproximadas:

```python
df.approxQuantile('tiempo_entrega_h', [0.5, 0.9], 0.01)
```

La pregunta técnica no es sólo *qué medida calculo*, sino *cuánto cuesta
calcularla y qué error acepto*. Un P90 aproximado con 1% de error puede ser
suficiente para ciertos usos. El error aceptable depende del objetivo; no se
debe asumir que una tolerancia concreta sirve para cualquier SLA.

Esta es la primera vez que la estadística toca el diseño, y no como adorno.

## 7. Las mismas preguntas, en el otro bloque de matemáticas

Tres ideas del bloque discreto/lógico aparecen **ya** en el diseño anterior, sin
haberlas nombrado:

| Pregunta del caso | Herramienta | Dónde |
| --- | --- | --- |
| ¿El `SKU` existe? | **Pertenencia a un conjunto** (SKU vendidos ∩ catálogo maestro) | Diferencia: productos vendidos no reconocidos |
| ¿Esta fila es válida? | **Lógica algorítmica**: reglas `SI … ENTONCES …` | `precio_total = unidades * precio_unitario` |
| ¿Esto escalará? | **Complejidad**: el cruce con el catálogo es O(n) o O(n²) | Un join mal planteado no escala |

Estas tres tienen su sitio en la
[cápsula matemática normativa](UD1_P0_Capsula_Matematica_Normativa.md). No la
estudiamos como asignatura: la usamos para justificar decisiones de diseño.

## 8. Ejemplo: diez pedidos de la cadena

### 8.1 Los datos

Diez pedidos **sintéticos**, ya en la zona curada. Nos centraremos en
`tiempo_entrega_h`.

| pedido_id | canal | ciudad | unidades | precio_total | tiempo_entrega_h |
| ---: | --- | --- | ---: | ---: | ---: |
| 1001 | tienda | Cádiz | 2 | 24 | 24 |
| 1002 | web | Cádiz | 1 | 15 | 26 |
| 1003 | tienda | Sevilla | 3 | 30 | 30 |
| 1004 | web | Sevilla | 4 | 44 | 28 |
| 1005 | app | Málaga | 2 | 28 | 25 |
| 1006 | tienda | Málaga | 1 | 22 | 31 |
| 1007 | web | Cádiz | 2 | 36 | 27 |
| 1008 | web | Sevilla | 1 | 18 | 29 |
| 1009 | tienda | Granada | 3 | 33 | 33 |
| 1010 | web | Málaga | 1 | 27 | **168** |

`tiempo_entrega_h` ordenado:

\[
24,\ 25,\ 26,\ 27,\ 28,\ 29,\ 30,\ 31,\ 33,\ 168
\]

\(n = 10\), y hay un valor que se sale del grupo. El objetivo de las siguientes
secciones es **cuantificar** lo que el ojo ya intuye.

Los cuartiles de este ejemplo se calculan con interpolación lineal, como hace
`pandas` por defecto. Otros métodos pueden dar valores ligeramente distintos;
por eso, al comparar resultados de herramientas, conviene indicar el método usado.

### 8.2 Media

\[
\bar{x} = \frac{\sum x_i}{n} = \frac{421}{10} = 42{,}1 \text{ h}
\]

Nueve pedidos están entre 24 y 33 h. La media sale 42,1 h.

**Interpretación:** la media es correcta, pero queda muy afectada por el pedido
de 168 h. Por eso no conviene presentarla sola como descripción de una entrega
típica.

### 8.3 Mediana

Con \(n\) par, la mediana es la media de los dos valores centrales (posiciones 5
y 6): 28 y 29.

\[
\text{mediana} = \frac{28 + 29}{2} = 28{,}5 \text{ h}
\]

**Interpretación:** la mitad de los pedidos queda en 28,5 h o menos y la otra
mitad en 28,5 h o más, según esta muestra. La diferencia con la media
(13,6 h) muestra que el valor extremo afecta mucho a la media.

Regla práctica: en importes, tiempos e ingresos, acompaña siempre la media con
la mediana. Si difieren mucho, alguien tiene que explicar por qué.

### 8.4 Moda

La moda es el valor más frecuente. En datos discretos suele aparecer en variables
**categóricas**.

Contando `canal`:

| canal | nº de pedidos |
| --- | ---: |
| web | **5** |
| tienda | 4 |
| app | 1 |

La **moda de `canal` es `web`**: es el canal más frecuente del piloto.

Dos advertencias que conviene interiorizar aquí:

- La moda informa de frecuencia, no de calidad ni rentabilidad. `web` es el canal
  más frecuente, no necesariamente el mejor o el más rentable.
- Si varios valores empatan, puede haber más de una moda. En
  `ciudad` tenemos Cádiz, Sevilla y Málaga con 3 pedidos cada una: es una
  distribución trimodal.
  Eso no es un defecto del cálculo: la muestra presenta varios valores de moda y
  esa variable no se resume en un solo valor.

### 8.5 Rango

\[
\text{rango} = \max - \min = 168 - 24 = 144 \text{ h}
\]

El rango resume la distancia entre los extremos. Depende de **un solo** valor en
cada extremo, por lo que conviene acompañarlo de medidas menos sensibles a
valores extremos; no es una medida que debamos descartar siempre.

### 8.6 Varianza

La varianza mide la dispersión **alrededor de la media**, en unidades al cuadrado.

\[
s^{2} = \frac{\sum (x_i - \bar{x})^{2}}{n - 1}
\]

| h | \(x_i - \bar{x}\) | \((x_i - \bar{x})^{2}\) |
| ---: | ---: | ---: |
| 24 | −18,10 | 327,61 |
| 25 | −17,10 | 292,41 |
| 26 | −16,10 | 259,21 |
| 27 | −15,10 | 228,01 |
| 28 | −14,10 | 198,81 |
| 29 | −13,10 | 171,61 |
| 30 | −12,10 | 146,41 |
| 31 | −11,10 | 123,21 |
| 33 | −9,10 | 82,81 |
| 168 | +125,90 | **15 850,81** |
| **Σ** | **0** | **17 680,90** |

\[
s^{2} = \frac{17\,680{,}90}{9} \approx 1964{,}54 \text{ h}^{2}
\]

Mira la tabla. **Una sola fila aporta el 90% de la varianza total.** Ése es el
momento en que la medida deja de ser ruido y empieza a ser un diagnóstico.

> Detalle técnico: aquí dividimos por \(n-1\) (varianza *muestral*). Si dividimos
> por \(n\) sale otra cifra. Por eso hay que declarar siempre qué convención se
> usa: `pandas` usa \(n-1\) por defecto en `std()` y `var()`, mientras que
> `numpy` usa \(n\). Es el tipo de detalle que hace que dos personas discutan
> cifras distintas sobre el mismo dato.

### 8.7 Desviación típica

\[
s = \sqrt{s^{2}} = \sqrt{1964{,}54} \approx 44{,}32 \text{ h}
\]

**Interpretación:** la desviación típica (44,32 h) es grande en relación con la
media (42,1 h). En esta muestra refleja la dispersión introducida por el valor
de 168 h; no hay una regla general para identificar un error comparando ambas.

### 8.8 Cuartiles e IQR: la valla

Los cuartiles dividen los datos ordenados en cuatro partes:

| Cuartil | Percentil | Valor |
| --- | --- | ---: |
| Q1 | P25 | 26,25 |
| Q2 | P50 | 28,5 |
| Q3 | P75 | 30,75 |

\[
IQR = Q3 - Q1 = 30{,}75 - 26{,}25 = 4{,}5 \text{ h}
\]

La **regla del IQR** marca como anomalía cualquier valor fuera de las vallas:

\[
\text{valla superior} = Q3 + 1{,}5 \cdot IQR = 30{,}75 + 6{,}75 = 37{,}5 \text{ h}
\]

\[
\text{valla inferior} = Q1 - 1{,}5 \cdot IQR = 19{,}5 \text{ h}
\]

Los nueve pedidos de entre 24 y 33 h caen dentro de la valla. **El de 168 h
queda fuera.** La regla lo señala como valor atípico estadístico, no demuestra
que sea un error ni justifica borrarlo automáticamente.

Y observa el contraste entre las dos reglas:

| Regla | Resultado |
| --- | --- |
| Rango | «Hay 144 h de recorrido» → no dice quién |
| Desviación típica | 44,32 h → no señala el valor |
| **IQR** | **168 h > 37,5 h → este registro concreto** |

La regla del IQR identifica la fila que queda fuera de las vallas. Es una forma
de localizar valores atípicos estadísticos, que después deben investigarse con
contexto de negocio y calidad.

### 8.9 El contraste que lo explica todo

Quitemos **sólo** la fila de 168 h y recalculemos el resto:

| Medida | Con 168 h | Sin 168 h | Cambio |
| --- | ---: | ---: | --- |
| Media | 42,10 h | 28,11 h | −33% |
| Mediana | 28,50 h | 28,00 h | −1,8% |
| Desviación típica | 44,32 h | 2,93 h | **×15** |
| Rango | 144 h | 9 h | — |

Esta tabla es la clase entera resumida:

- La **mediana** apenas se mueve. Es **robusta**.
- La **media** se mueve bastante. Es **sensible**.
- La **desviación típica** se multiplica por 15. Es la medida que **grita** cuando
  hay un problema, y por eso es una alarma útil en un sistema de calidad.

Y la moraleja incómoda: si la varianza de los tiempos de entrega se multiplica
por 15 de un día a otro, **algo ha cambiado** — pero la estadística te dice
**dónde**, no **por qué**. Para el *por qué* hay que ir a la ingeniería.

## 9. Cómo la estadística cambia el diseño técnico

Volvamos al diseño de la sección 4. Estas son consecuencias concretas, no
decorativas:

| Antes (sin estadística) | Después (con estadística) |
| --- | --- |
| «Mejoramos el tiempo de respuesta» | Acordar con negocio un objetivo de percentil y medirlo sobre un periodo definido |
| Vigilamos duplicados | Publicamos **unicidad** = valores distintos / total como métrica |
| El dashboard se publica cada día | Se comprueba si las métricas del día se desvían del histórico antes de publicar; el umbral se acuerda y documenta |
| «Revisamos los valores raros» | Umbral **explícito** (valla del IQR) y reproducible, no criterio personal |
| Nadie sabe por qué el número cambió | Se muestran medidas complementarias (por ejemplo, media, mediana y percentiles) con periodo y población definidos |

La tercera fila merece un comentario, porque es la que más se olvida: el umbral
tiene que estar **escrito y versionado**. Si el criterio de qué es un error vive
en la cabeza de una persona, el pipeline no es reproducible y nadie puede
auditarlo. La estadística aporta el número; la disciplina del proceso aporta la
constancia.

## 10. Qué debe saber explicar el alumnado

Al terminar este documento, el alumnado debe poder:

- Traducir un síntoma de negocio a una causa técnica concreta.
- Justificar por qué el diseño es ELT y no ETL, y por qué batch y no streaming.
- Explicar por qué la clave idempotente resuelve los duplicados por construcción.
- Explicar por qué «indicador fiable» es una afirmación estadística.
- Distinguir cuándo usar media y cuándo mediana, y por qué importa.
- Interpretar moda, rango, varianza y desviación típica sobre un caso.
- Usar la regla del IQR para localizar un registro anómalo.
- Decidir qué hacer con un outlier **razonando**, no borrándolo por reflejo.

## 11. Actividad breve (15 min)

Con los diez pedidos de la sección 8, en parejas:

1. Calculad `precio_total` con media, mediana, moda y desviación típica.
2. ¿Por qué la media (27,70 €) y la mediana (27,50 €) son tan parecidas aquí,
   mientras que en `tiempo_entrega_h` no lo eran?
3. ¿Qué le preguntaríais al equipo de logística sobre la fila 1010 antes de
   decidir si se conserva o se descarta?
4. Escribid **una frase de SLA** para el tiempo de entrega, con la medida
   concreta que la respalda.

La pregunta 4 es la importante: obliga a convertir un deseo de negocio
(«que llegue rápido») en algo verificable. Con solo diez pedidos no podemos
proponer una SLA representativa; la respuesta debe indicar qué periodo y volumen
de datos harían falta para fijarla.

---

## Siguiente paso

Continúa con la [estadística aplicada para Big Data](UD1_P0_Estadistica_para_BigData.md),
que desarrolla distribuciones, outliers, percentiles, correlación y las métricas
de calidad de datos con más profundidad, y con la
[cápsula matemática normativa](UD1_P0_Capsula_Matematica_Normativa.md) para los
bloques de conjuntos, lógica y complejidad.
