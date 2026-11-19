# UD1 · Taller: del problema al modelo de datos

**Caso:** pedidos de una tienda multicanal (P2).
**Modalidad:** trabajo en parejas.
**RA/CE:** RA4.a (escenarios y tipologías de datos no estructurados) y contraste
con RA1.b (extracción de información).

## Qué vas a hacer

Vas a reconstruir, paso a paso, las decisiones de diseño que hay detrás de un
modelo de datos. El caso es el mismo de la práctica P2: una tienda que vende por
`tienda`, `web` y `app` y necesita recuperar un pedido completo, calcular ventas
por canal y obtener el margen por producto.

No se trata de memorizar campos ni de copiar un esquema. Se trata de decidir:

- qué información hace falta y qué granularidad tiene cada registro;
- qué claves identifican pedidos, clientes y productos;
- qué se anida, qué se duplica y qué se referencia;
- qué reglas de calidad deben cumplirse;
- qué formato conviene para cada tipo de consulta.

Al final del documento tienes la tarea que debes entregar. Esta sesión no crea
una entrega nueva: completa la tarea de modelado P2 que ya está iniciada.

## Antes de empezar

Ten a mano:

- la guía [UD1 · Modelado de datos](../../01-teoria/02-almacenamiento-y-nosql/UD1_Modelado_de_Datos.md),
  especialmente la sección 10;
- el enunciado de la [tarea P2](UD1_02_Tarea_Modelado_Documental_y_Analitico.md);
- la carpeta `lab_p2_modelado_documental_analitico/` con `genera_datos_p2.py`,
  `data/orders_flat.csv`, `data/orders.ndjson`, `p2_duckdb.sql` y su `README.md`.

Los datos son sintéticos: representan compras simuladas, no clientes ni
transacciones reales.

## 1. El problema

Una tienda necesita responder a tres necesidades distintas:

1. recuperar un pedido completo para atender a un cliente;
2. calcular ventas por canal y por mes;
3. calcular el margen por producto (SKU).

Antes de abrir los archivos, responde por parejas:

- ¿Qué información mínima necesitas para esas tres necesidades?
- ¿Basta con una fila por pedido si cada pedido tiene varios productos?
- ¿Qué consultas se harán muchas veces y cuáles serán ocasionales?

No pases al apartado 2 hasta haber escrito vuestras respuestas.

## 2. Método: nueve decisiones de diseño

### Paso 1 · Entender el objetivo

Completa en dos o tres líneas:

> El sistema debe registrar pedidos y sus líneas para poder ______________________,
> analizar ______________________ y calcular ______________________.

Deja claro el alcance. En este ejercicio no se diseñan pagos, devoluciones ni
control de stock.

### Paso 2 · Identificar entidades, hechos y límites

Escribe qué representa cada elemento:

| Elemento | ¿Entidad, hecho o relación? | ¿Qué representa? |
|---|---|---|
| Cliente |  |  |
| Producto |  |  |
| Pedido |  |  |
| Línea de pedido |  |  |

Indica las relaciones y sus cardinalidades. Por ejemplo: un cliente puede hacer
varios pedidos; un pedido tiene una o varias líneas; un producto puede aparecer
en muchas líneas.

Después anota los límites: en P2 solo tienes identificadores de cliente y de
producto. No hay catálogo de clientes ni de productos, así que no puedes
comprobar contra estos archivos que un cliente o un SKU exista realmente.

### Paso 3 · Fijar la granularidad

Completa las dos frases:

- En el documento JSON, cada registro representa exactamente ______________________.
- En el CSV aplanado, cada fila representa exactamente ______________________.

Comprueba que lo has entendido: en estas dos filas, ¿cuántos pedidos hay?

```text
order_id,customer_id,fecha,canal,sku,qty,price,cost
1,2807,2024-06-01,web,SKU0083,2,5.93,3.38
1,2807,2024-06-01,web,SKU0018,2,7.29,5.55
```

Hay **un pedido**, no dos. Son dos líneas del mismo `order_id`. Para contar
pedidos en el CSV hay que usar `COUNT(DISTINCT order_id)`, no `COUNT(*)`.

### Paso 4 · Elegir claves y relaciones

Responde:

- ¿Qué campo identifica un pedido? ______________________
- ¿Qué campo referencia al cliente? ______________________
- ¿Qué campo identifica el producto? ______________________
- ¿Por qué se repite `order_id` en el CSV? ______________________

Una clave de línea deseable sería `(order_id, line_number)`. P2 **no incluye**
`line_number`. Tampoco es seguro usar `(order_id, sku)`, porque un mismo pedido
puede repetir el mismo SKU en dos líneas. Anota esta limitación: la retomarás en
la tarea.

### Paso 5 · Elegir el modelo según el acceso

Completa la tabla con los campos que necesitarías en cada caso:

| Necesidad | Modelo propuesto | Campos necesarios |
|---|---|---|
| Recuperar un pedido completo | Documento con líneas anidadas |  |
| Ventas por canal y mes | Fila por línea |  |
| Margen por producto | Fila por línea |  |

Para este ejercicio se supone que los pedidos son pequeños y que se lee muchas
veces el pedido completo. En producción habría que medir escrituras,
concurrencia, crecimiento y evolución del esquema. El generador de P2 no
demuestra esas propiedades.

Solo ahora abre los archivos y compara tus decisiones con sus campos reales.

### Paso 6 · Normalizar, duplicar o anidar

Completa la tabla de decisiones:

| Dato o relación | Decisión (anidar / duplicar / referenciar) | Motivo | Riesgo |
|---|---|---|---|
| Líneas de un pedido |  |  |  |
| Cliente del pedido |  |  |  |
| Producto de la línea |  |  |  |
| Campos de cabecera en el CSV |  |  |  |

Ten en cuenta:

- en el documento se anidan las líneas porque se recuperan con el pedido;
- en el CSV se duplican los campos de cabecera para facilitar agregaciones;
- si cambia una cabecera, hay que actualizar coherentemente la vista plana;
- el precio de la línea es el precio histórico de esa compra, no el precio
  actual de catálogo;
- evita listas que puedan crecer sin límite.

### Paso 7 · Definir calidad y consistencia

Completa al menos cuatro reglas. Para cada una indica qué comprobarías y qué
harías si no se cumple, sin borrar el dato original.

| Campo o regla | ¿Qué comprobarías? | Si no se cumple |
|---|---|---|
| `order_id` |  |  |
| `canal` |  |  |
| `qty` |  |  |
| `price`, `cost` |  |  |
| `fecha` / `ts` |  |  |
| Campos de cabecera |  |  |

Estas son reglas de diseño, no controles que P2 ya aplique automáticamente.
Distingue siempre un precio de compra histórico de un precio de catálogo
actualizado.

### Paso 8 · Elegir formato y organización física

P2 genera NDJSON para documentos y CSV para filas. El SQL exporta la vista plana
a Parquet para consulta columnar.

Responde:

- ¿NDJSON es una base de datos documental? ______________________
- ¿Qué ganarías indexando `order_id` en una base documental? ______________________
- ¿Qué implicaría particionar por fecha en un volumen grande? ______________________
- ¿Qué política de conservación o caducidad necesitarían los datos temporales?
  ______________________

Ninguna de esas optimizaciones está implementada en P2 ni justificada por una
medida. Son decisiones que debes razonar, no afirmar como si ya estuvieran
resueltas.

### Paso 9 · Probar y documentar

Abre `p2_duckdb.sql` y localiza estas dos consultas:

- **Ventas por canal y mes:** agrupa por `canal` y por `strftime(fecha, '%Y-%m')`,
  y suma el importe calculado.
- **Margen por SKU:** suma `(price - cost) * qty` por SKU y ordena de mayor a
  menor.

Después comprueba la lógica con el ejemplo de cálculo del apartado 3.

Documenta al final:

- finalidad del modelo;
- granularidad de cada registro;
- claves y relaciones;
- reglas de calidad;
- formatos elegidos;
- limitaciones: falta de clave de línea, ausencia de catálogos, datos sintéticos
  y ausencia de medidas de rendimiento.

## 3. Comprobaciones

### Ejemplo de cálculo

Estas dos líneas son un ejemplo de trabajo. No tienen por qué coincidir con las
filas actuales de `data/orders_flat.csv`, porque el generador puede haberse
ejecutado de nuevo. Sirven para comprobar la lógica:

```text
order_id,customer_id,fecha,canal,sku,qty,price,cost
1,2807,2024-06-01,web,SKU0083,2,5.93,3.38
1,2807,2024-06-01,web,SKU0018,2,7.29,5.55
```

- Importe de la primera línea: `2 × 5.93 = 11.86 €`.
- Importe de la segunda línea: `2 × 7.29 = 14.58 €`.
- Importe total del pedido: `11.86 + 14.58 = 26.44 €`.
- Margen de la primera línea: `2 × (5.93 − 3.38) = 5.10 €`.
- Margen de la segunda línea: `2 × (7.29 − 5.55) = 3.48 €`.

Puedes comprobar el total directamente:

```sql
SELECT 2 * 5.93 + 2 * 7.29 AS total_pedido;
```

Y comprobar que `order_id = 1` cuenta como un pedido y no como dos:

```sql
SELECT COUNT(*) AS lineas,
       COUNT(DISTINCT order_id) AS pedidos
FROM read_csv('data/orders_flat.csv', AUTO_DETECT = TRUE)
WHERE order_id = 1;
```

El resultado esperado es `lineas = 2` y `pedidos = 1`.

### Consultas del laboratorio

Si tienes DuckDB disponible, trabaja sobre una **copia** de la carpeta del
laboratorio: `p2_duckdb.sql` crea una tabla y escribe un Parquet dentro de
`data/`.

```bash
duckdb -c ".read p2_duckdb.sql"
```

Consulta de ventas por canal y mes:

```sql
SELECT canal,
       strftime(fecha, '%Y-%m') AS ym,
       ROUND(SUM(qty * price), 2) AS venta
FROM orders_flat
GROUP BY 1, 2
ORDER BY 2, 3 DESC;
```

Consulta de margen por SKU (top 5):

```sql
SELECT sku,
       ROUND(SUM((price - cost) * qty), 2) AS margen_total
FROM orders_flat
GROUP BY 1
ORDER BY margen_total DESC
LIMIT 5;
```

No presentes estas pruebas como un benchmark. El dataset es pequeño y sintético:
sirve para comprobar que las consultas son correctas, no para prometer tiempos de
rendimiento ni escalabilidad.

## 4. Trabajo en parejas

Elegid una regla del paso 7 y preparad una respuesta breve con estos cuatro
puntos:

1. sobre qué granularidad se mide;
2. cómo se detecta un incumplimiento;
3. qué haríais sin perder el dato original;
4. qué decisión de anidamiento o duplicación habéis tomado y por qué.

Añadid también una limitación de P2 que hayáis encontrado. Al terminar, dos
parejas explicarán su decisión al grupo.

## 5. Tarea que debes entregar

Completa la tarea **Modelado documental y consulta analítica** ya iniciada. No es
una entrega nueva ni cambia la rúbrica de la práctica.

### Qué entregar

Un único archivo:

```text
apellido1_apellido2_ud1_modelado.zip
```

Con esta estructura mínima:

```text
respuestas.md
p2_duckdb.sql
README.md
```

No incluyas entornos virtuales, dependencias instaladas, bases de datos generadas
ni archivos grandes que puedan volver a generarse con el material de partida.

### Contenido mínimo

1. **Modelo documental.** Incluye en `respuestas.md` un ejemplo abreviado de un
   documento JSON y explica dos ventajas y una limitación del modelado
   documental para este caso.

2. **Consultas DuckDB.** Completa o adapta `p2_duckdb.sql` para responder, como
   mínimo, a estas preguntas:
   - margen por producto;
   - evolución temporal de pedidos;
   - una consulta adicional justificada por ti.

   Las consultas deben ser legibles y reproducibles. Comenta las decisiones que
   no sean evidentes.

3. **Formato analítico.** Explica qué datos conservarías en Parquet y por qué
   DuckDB permite explorarlos sin desplegar un servidor.

4. **Reproducción.** Documenta en un `README.md` breve cómo se reproduce tu
   resultado: nombres de los integrantes, requisitos, comandos exactos, orden de
   ejecución y resultados esperados.

5. **Limitaciones.** Indica al menos: falta de clave de línea (`line_number`),
   ausencia de catálogos de clientes y productos, y carácter sintético de los
   datos. Si afirmas algo sobre rendimiento, limita la conclusión al prototipo o
   aporta una ampliación reproducible.

### Rúbrica (/10)

| Criterio | Puntos |
|---|---:|
| Identifica correctamente estructura, tipologías y campos del documento JSON | 2 |
| Justifica el uso y límites del modelo documental | 2 |
| Consultas DuckDB correctas, legibles y reproducibles | 3 |
| Compara razonadamente JSON/documental y Parquet/analítico | 2 |
| README y entrega ordenados | 1 |

### Autoría y trabajo en pareja

La actividad se realiza en pareja. Ambos integrantes entregan el mismo ZIP e
indican los dos nombres en el `README.md`, pero deben poder explicar cualquier
consulta, decisión de modelado y comparación. El profesorado podrá solicitar una
modificación o comprobación individual.

### Antes de entregar

- [ ] El ZIP contiene solo `respuestas.md`, `p2_duckdb.sql` y `README.md`.
- [ ] El `README.md` indica los dos nombres y los comandos de ejecución.
- [ ] El ejemplo JSON se entiende sin abrir otros archivos.
- [ ] Las consultas se ejecutan sin errores sobre una copia del laboratorio.
- [ ] La consulta adicional está justificada.
- [ ] Se explican las limitaciones y no se prometen tiempos de rendimiento.
