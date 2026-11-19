# UD1 · Modelado de datos: qué es, cómo se hace y cómo se elige

## 1. Qué es modelar datos

**Modelar datos** es decidir cómo se organizan los datos para poder **guardarlos y
consultarlos** de forma razonable según lo que vayamos a hacer con ellos.

No es una tarea opcional al final del proceso: es la decisión que determina si las
consultas son rápidas, si se entiende el dato, si se puede crecer y si no se
producen errores por duplicar o perder información.

No existe un modelo universalmente mejor. El modelo adecuado depende del
**objetivo del sistema**, de sus **patrones de acceso**, del volumen, la
consistencia, la concurrencia y la evolución esperada del esquema.

Modelar no es «hacer una tabla bonita». Es responder a estas preguntas antes de
guardar:

- ¿Qué entidad estoy representando? (un pedido, una venta, un usuario)
- ¿Qué campos tiene esa entidad?
- ¿Qué campos repito para poder relacionar datos (claves)?
- ¿Cómo voy a **leer** estos datos después?
- ¿Qué formato y modelo de almacenamiento me conviene?

## 1.1. ¿Para qué sirve el modelado?

El modelado sirve para:

1. **Representar el dominio:** identificar clientes, pedidos, productos,
   eventos, mediciones y sus relaciones.
2. **Evitar ambigüedades:** definir qué significa cada campo, qué unidad tiene y
   cuándo puede ser nulo.
3. **Mantener la integridad:** reducir duplicidades, referencias rotas y
   contradicciones.
4. **Facilitar las consultas:** organizar los datos para que las operaciones
   principales sean sencillas y eficientes.
5. **Controlar el coste:** influir en el volumen almacenado, la compresión, la
   memoria y el tiempo de respuesta.
6. **Permitir la evolución:** hacer explícitos los cambios de esquema y sus
   efectos sobre los consumidores.
7. **Hacer reproducible el trabajo:** documentar por qué se eligieron ciertas
   claves, campos, relaciones y formatos.

## 2. Un mismo dato, dos modelos posibles

El caso que usamos en la práctica (la tarea de modelado) lo deja claro: unos
**pedidos** pueden representarse de dos formas distintas según cómo los consultemos.

### Modelo documental (JSON)

Un pedido es un **documento** que agrupa todo lo suyo:

```json
{
  "order_id": 1,
  "customer_id": 234,
  "ts": "2024-06-01T12:00:00",
  "canal": "web",
  "items": [
    {"sku": "SKU0007", "qty": 2, "price": 12.50, "cost": 8.10}
  ]
}
```

Aquí el pedido **y sus líneas** están juntos. Para recuperar un pedido completo se
lee un único documento, sin hacer *joins*.

### Modelo analítico (tablas planas / Parquet)

El mismo pedido se **aplana**: una fila por línea de pedido, repitiendo el
`order_id` y los datos del pedido en cada fila.

| order_id | customer_id | fecha | canal | sku | qty | price | cost |
|---|---|---|---|---|---|---|---|
| 1 | 234 | 2024-06-01 | web | SKU0007 | 2 | 12.50 | 8.10 |
| 1 | 234 | 2024-06-01 | web | SKU0088 | 1 | 5.00 | 3.20 |

Si un pedido tiene 4 líneas, en el modelo plano tiene **4 filas que repiten**
`order_id`, `customer_id` y `canal`.

## 3. El criterio para elegir: cómo vas a leer

La regla práctica del módulo es **empezar por las consultas**:

| Necesito… | Modelo conveniente |
|---|---|
| Recuperar una entidad completa (ej. un pedido con sus líneas) | **Documental** |
| Recuperar el valor de una clave exacta rápido | **Clave-valor** |
| Agregar masivamente pocas columnas de muchas filas, hacer BI | **Tablas planas / columnar / Parquet** |
| Explorar relaciones (conocidos, rutas, dependencias) | **Grafo** |

En **analítica sobre un *data lake* curificado**, casi siempre nos conviene el
modelo **plano + Parquet + DuckDB**: es barato, comprime bien y las agregaciones
son directas en SQL.

En **servir entidades completas a una aplicación**, el modelo **documental**
(estilo MongoDB) evita reconstruir una entidad uniendo piezas.

En sistemas reales **se combinan**: documental para servir por entidad, Parquet
para la analítica que consume BI y modelos.

## 4. Cómo se hace en la práctica

Sobre un dataset (por ejemplo pedidos), el proceso de modelado es:

1. **Entender la entidad y su nivel.** Un pedido es la unidad lógica; sus líneas
   son subelementos. Decidir si el resultado será «un documento por pedido» o
   «una fila por línea».
2. **Elegir las claves.** `order_id` identifica el pedido. Si aplanamos, repetimos
   esa clave en cada fila para no perder la relación entre líneas del mismo pedido.
3. **Decidir qué campos conservar y cuáles calcular.** Un `importe` puede
   calcularse como `qty × price`; a veces conviene guardarlo para que las consultas
   sean rápidas.
4. **Elegir formato de almacenamiento.** Para analítica: Parquet. Para servir por
   entidad: JSON/documental. CSV solo para intercambio ligero.
5. **Documentar la decisión.** Por qué aplané, por qué guardé Parquet, qué campo
   calculé. Sin esa justificación, el modelo no es reproducible.

## 5. Qué hace el laboratorio P2

El laboratorio `lab_p2_modelado_documental_analitico` compara **los dos modelos
sobre el mismo negocio**:

- `genera_datos_p2.py` crea **dos vistas** de los pedidos:
  - `data/orders.ndjson`: modelo **documental** (un documento por pedido con `items`).
  - `data/orders_flat.csv`: modelo **plano** (una fila por línea de pedido).
- `p2_duckdb.sql` toma la vista **plana**, calcula `importe` y `margen_u`,
  exporta a **Parquet** y responde tres consultas de negocio (ventas por canal y
  mes, top de margen por SKU, clientes con muchos pedidos).
- El enfoque **documental con MongoDB es opcional**; sirve para comparar cómo se
  respondería la misma pregunta recuperando documentos.

El laboratorio **no te enseña qué es modelar**: asume que ya sabes por qué el
mismo pedido tiene dos representaciones. Esta guía es la explicación previa que
necesitas antes de hacerlo.

## 6. Relación con el resto del módulo y con EDA

- **Modelado documental / analítico** se apoya en lo visto en Almacenamiento y
  NoSQL (familia documental, columna/Parquet).
- Lo que decides modelar condiciona el **EDA y la calidad**: si aplanas o anidas
  cambia qué filas hay, qué nulos caben y qué _joins_ harás después.
- En UD4 se verá el **modelado dimensional** propio de BI, una profundización de
  la misma idea: cómo organizar los datos para consultarlos eficientemente.

## 7. Errores frecuentes

- **Decir «hago modelado» pero no explicar el criterio.** El modelo se justifica
  por cómo se va a leer, no por gusto.
- **Aplanar sin conservar la clave del padre.** Si repites `order_id`, asegúrate
  de que esa clave une de nuevo las filas del mismo pedido.
- **Guardar datos calculados sin documentarlos.** Un `importe` guardado hay que
  justificar por qué (rendimiento) y cómo se calcula.
- **Creer que documental y analítico son excluyentes.** Se combinan según el
  patrón de lectura.

## 8. Niveles de modelado

El modelado suele hacerse en tres niveles. No siempre se crean tres diagramas
separados, pero conviene distinguir las decisiones:

| Nivel | Pregunta | Ejemplo |
|---|---|---|
| **Conceptual** | ¿Qué objetos y relaciones existen en el dominio? | Cliente realiza pedidos |
| **Lógico** | ¿Qué atributos, claves, cardinalidades y reglas tienen? | `orders(order_id, customer_id, order_date)` |
| **Físico** | ¿Cómo se guardará en una tecnología concreta? | PostgreSQL, MongoDB, Parquet o DuckDB |

El modelo conceptual no debería depender de MongoDB, PostgreSQL o DuckDB. El
modelo físico sí debe tener en cuenta índices, particiones, compresión, tipos,
formato de archivo y límites de la tecnología.

## 9. Conceptos que deben quedar fijados

### 9.1. Entidades, atributos y relaciones

Una **entidad** es algo que queremos representar: un cliente, un pedido, un
producto o una lectura de temperatura. Un **atributo** describe una entidad:
`customer_id`, `status`, `price` o `timestamp`.

En un sistema de ventas podemos distinguir:

```text
Cliente ── realiza ── Pedido ── contiene ── Línea de pedido ── corresponde a ── Producto
```

La **cardinalidad** describe cuántos elementos se relacionan con otros: un
cliente puede realizar muchos pedidos (1:N), y un producto puede aparecer en
muchos pedidos. Esta última relación N:M suele resolverse con una entidad
intermedia como `order_items`.

### 9.2. Claves

- **Clave primaria:** identifica de forma única una entidad, como `order_id`.
- **Clave foránea:** referencia otra entidad, como `customer_id` dentro de un
  pedido.
- **Clave natural:** procede del dominio, como un ISBN o un código de producto.
- **Clave técnica:** la genera el sistema, como un entero o un UUID.

Una clave no es sólo un detalle de implementación: permite conservar la
identidad cuando los datos se transforman, se aplanan o se distribuyen.

### 9.3. Granularidad

La **granularidad** indica qué representa exactamente una fila, un documento o
un evento. Debe poder expresarse en una frase:

- una fila por pedido;
- una fila por línea de pedido;
- un documento por cliente;
- un evento por cambio de estado;
- una medición por sensor y minuto.

Si la granularidad no está clara, las sumas y los recuentos pueden ser
incorrectos. Por ejemplo, sumar el importe del pedido en una tabla con una fila
por línea puede contar el mismo pedido varias veces.

### 9.4. Datos originales y derivados

Un dato **original** procede de la fuente, como `qty` y `unit_price`. Un dato
**derivado** se calcula a partir de otros:

```text
importe = qty × unit_price
margen  = importe − (qty × unit_cost)
```

Guardar derivados puede mejorar el rendimiento, pero exige documentar la fórmula,
su fecha de cálculo y qué ocurre si cambian los datos de origen.

## 10. Método completo de diseño

La versión resumida del proceso es:

1. **Entender el objetivo.** Escribe qué debe hacer el sistema: registrar
   compras, recuperar pedidos, calcular ventas, encontrar rutas o consultar
   mediciones.
2. **Identificar entidades, eventos y límites.** Separa objetos relativamente
   estables de hechos que ocurren en el tiempo.
3. **Fijar la granularidad.** Completa: «Cada registro representa exactamente
   __________».
4. **Elegir claves y relaciones.** Define identificadores estables,
   cardinalidades, reglas de unicidad y referencias.
5. **Elegir el modelo según el patrón de acceso.** Considera consultas,
   escrituras, actualizaciones, concurrencia y evolución.
6. **Decidir qué normalizar, duplicar o anidar.** Justifica la decisión y cómo
   se mantendrá la consistencia.
7. **Definir calidad y consistencia.** Documenta tipos, unidades, dominios,
   nulos, duplicados, fechas y reglas de negocio.
8. **Elegir formato y organización física.** Considera índices, particiones,
   compresión, lectura por columnas y almacenamiento temporal.
9. **Probar y documentar.** Usa consultas representativas, datos realistas y
   registra alternativas, supuestos y limitaciones.

La **normalización** separa datos para reducir duplicidades y facilitar su
actualización. La **desnormalización** duplica o combina datos para leer más
rápido y reducir joins. En un modelo documental, algunos datos relacionados se
**anidan** dentro del documento.

Una regla práctica es:

- normalizar cuando los datos cambian de forma independiente;
- duplicar cuando la lectura es prioritaria y la sincronización está controlada;
- anidar cuando los elementos tienen el mismo ciclo de vida y se recuperan
  normalmente juntos;
- referenciar cuando una relación es grande, compartida o cambia por separado.

## 11. Diferencias entre modelos de datos

### 11.1. Relacional y SQL

El modelo **relacional** organiza la información en tablas con filas y columnas,
claves y relaciones. **SQL es el lenguaje** utilizado por muchos sistemas
relacionales; no es sinónimo de una única base de datos.

```sql
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    order_id INTEGER NOT NULL,
    line_number INTEGER NOT NULL,
    sku VARCHAR NOT NULL,
    qty INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, line_number)
);
```

Suele encajar bien cuando hay entidades y relaciones claras, se necesitan
restricciones y transacciones, o muchas aplicaciones deben escribir datos
operativos. Sus costes habituales son la complejidad de algunos joins, la
planificación del esquema y la menor comodidad ante datos muy variables o
profundamente anidados.

### 11.2. Documental

El modelo **documental** agrupa en documentos los datos que suelen recuperarse
juntos. JSON es un formato habitual, pero el modelo no se reduce al formato del
archivo.

```json
{
  "order_id": 1,
  "customer_id": 234,
  "ts": "2024-06-01T12:00:00Z",
  "channel": "web",
  "items": [
    {"sku": "SKU0007", "qty": 2, "unit_price": 12.50}
  ]
}
```

Encaja cuando la aplicación recupera una entidad completa, los elementos
anidados tienen un ciclo de vida parecido o el esquema evoluciona con frecuencia.
Sus límites aparecen al duplicar datos sin estrategia de actualización, crear
documentos muy grandes o consultar relaciones complejas entre muchos documentos.

### 11.3. Clave-valor

Cada clave apunta a un valor. Es apropiado para búsquedas exactas y rápidas,
como sesiones, cachés, preferencias o contadores. No es la mejor opción para
consultas ad hoc sobre muchas entidades relacionadas.

```text
session:8f31 → {"user_id": 234, "expires_at": "..."}
```

### 11.4. Columnas anchas o familias de columnas

Organizan los datos alrededor de claves de fila y conjuntos de columnas que
pueden variar. Son útiles en ciertos sistemas distribuidos con grandes volúmenes
de escritura y patrones de acceso conocidos, pero exigen diseñar pensando en las
consultas y no suelen ser cómodas para relaciones arbitrarias.

### 11.5. Grafos

Representan **nodos** y **aristas**: personas conectadas, rutas, dependencias,
recomendaciones o relaciones entre servicios. Son adecuados cuando la relación
entre elementos es el centro de la consulta, por ejemplo, encontrar caminos o
vecinos a varios saltos.

### 11.6. Series temporales

Organizan mediciones o eventos indexados por tiempo y, normalmente, por
dimensiones como sensor, dispositivo o ubicación. Son útiles para telemetría,
métricas y observabilidad, donde predominan las inserciones y las consultas por
intervalos temporales.

### 11.7. Tablas analíticas y formato columnar

Para analítica es frecuente usar tablas planas almacenadas en formatos como
**Parquet**. Parquet es un formato de archivo columnar, no una base de datos
completa. **DuckDB** es un motor SQL analítico que puede consultar esos archivos
directamente.

```sql
SELECT canal, SUM(qty * price) AS ventas
FROM 'orders_flat.parquet'
GROUP BY canal;
```

Este enfoque suele funcionar bien para agregaciones sobre muchas filas y pocas
columnas. La elección del modelo sigue siendo anterior a la elección del formato:
primero se decide qué representa cada fila y después cómo se almacena.

## 12. Elegir según el objetivo

| Objetivo principal | Modelo o enfoque habitual | Razón |
|---|---|---|
| Registrar pedidos, pagos y stock | Relacional/SQL transaccional | Restricciones, transacciones y consistencia |
| Recuperar un pedido completo | Documental | Pedido y líneas juntos |
| Buscar una sesión por identificador | Clave-valor | Acceso directo por clave |
| Analizar ventas históricas | Tabular/columnar + Parquet/DuckDB | Agregaciones y lectura eficiente de columnas |
| Recorrer dependencias o recomendaciones | Grafo | Las relaciones son el centro de la consulta |
| Analizar sensores por intervalos | Series temporales | Escrituras y filtros por tiempo |
| Procesar muchos datos distribuidos | Tablas/archivos en arquitectura distribuida | Particionado y ejecución en varios nodos |

Un sistema real puede combinar varios modelos: SQL para operaciones, documentos
para servir una API y Parquet con DuckDB o Spark para análisis.

## 13. OLTP, OLAP y el modelado

El objetivo también determina el tipo de carga:

| | **OLTP** | **OLAP** |
|---|---|---|
| Trabajo | Tramitar operaciones | Analizar operaciones |
| Consultas | Muchas, pequeñas y concurrentes | Menos numerosas, sobre muchas filas |
| Prioridad | Consistencia y respuesta inmediata | Agregaciones y rendimiento analítico |
| Ejemplo | Registrar una compra y actualizar stock | Ventas por mes, canal y ciudad |

Un modelo normalizado suele ser conveniente para OLTP porque evita actualizar la
misma información en muchos lugares. Un modelo plano o desnormalizado suele ser
cómodo para OLAP porque reduce joins y favorece el escaneo de grandes volúmenes.
No es una separación absoluta: existen sistemas híbridos y decisiones
intermedias.

## 14. Schema-on-write y schema-on-read

- **Schema-on-write:** se valida y transforma la estructura antes de guardar los
  datos. Favorece la consistencia y simplifica el consumo posterior.
- **Schema-on-read:** los datos se conservan con una estructura más flexible y se
  interpreta el esquema al leer. Facilita explorar fuentes cambiantes, pero
  desplaza complejidad a las consultas y validaciones.

En una arquitectura pueden convivir ambos enfoques: conservar datos originales
con flexibilidad y publicar capas curadas con un esquema documentado.

## 15. Checklist de diseño

- [ ] Se puede explicar qué representa cada fila, documento o evento.
- [ ] Las claves son estables y permiten identificar o relacionar datos.
- [ ] Las cardinalidades y los campos obligatorios están documentados.
- [ ] Las consultas principales se han probado con datos realistas.
- [ ] Se sabe qué datos son originales y cuáles son derivados.
- [ ] La normalización, duplicación o anidamiento tiene una justificación.
- [ ] Se han considerado volumen, crecimiento, concurrencia y evolución.
- [ ] Las reglas de nulos, tipos, unidades y calidad son verificables.
- [ ] El formato y la tecnología elegidos son adecuados al objetivo.
- [ ] Se han anotado limitaciones, alternativas descartadas y supuestos.

## 16. Resumen

Modelar datos es convertir una necesidad del negocio en una representación
precisa, consultable y mantenible. El proceso comienza por el objetivo y las
consultas, fija entidades, claves y granularidades, elige una estructura y una
tecnología, prueba los casos importantes y documenta las decisiones.

La pregunta clave no es «¿qué base de datos es mejor?», sino:

> **¿Qué operaciones y consultas debe resolver este sistema, con qué volumen,
> consistencia, evolución y coste?**

---

## 17. Embeber o referenciar, y la validación de esquema

Continuando con el ejemplo de los pedidos, hay una decisión de modelado que en la
práctica ya usamos pero conviene nombrar de forma explícita: cuándo la información
**va dentro del documento o la fila** (embebida) y cuándo **se apunta mediante una
referencia o una clave a otra parte**.

### 17.1. Embeber (guardar los datos juntos)

Un pedido **embebe** sus líneas:

```json
{
  "order_id": 1,
  "customer_id": 234,
  "items": [
    {"sku": "SKU0007", "qty": 2, "price": 12.50}
  ]
}
```

- Se recupera todo de una sola vez, sin un segundo acceso ni un _join_.
- Mantener juntos los datos que se usan juntos es la idea del modelo documental.
- Es adecuado cuando los elementos **comparten ciclo de vida** (las líneas no
  existen sin su pedido) y son **pocos** (unas pocas líneas por pedido).

### 17.2. Referenciar (guardar una clave y tener los datos en otra parte)

Cuando una relación es grande o cambia por separado, se guarda una **referencia**:

```json
{
  "cliente_id": 234,
  "pedidos": [1001, 1002, 1003]
}
```

- Los datos pasan a estar en otra colección o tabla y se recuperan con otro acceso
  o un _join_.
- Es adecuado cuando hay **muchos** elementos (por ejemplo, miles de líneas, o
  millones de eventos de log) o cuando el dato referenciado **cambia por su
  cuenta** (el precio de catálogo de un producto evoluciona, la dirección de un
  cliente se modifica, etc.).
- Evita documentos o filas que crecen sin control.

### 17.3. El criterio: definir primero la carga

Antes de elegir, hay que saber **qué se va a leer y escribir, y cuánto**:

| Pregunta | Por qué importa |
|---|---|
| ¿Qué consultas son las más frecuentes? | Determina qué conviene tener junto. |
| ¿Cuántos elementos hay en cada lado de la relación? | Pocos → embeber; muchos → referenciar. |
| ¿Se lee mucho o se escribe mucho? | Las lecturas favorecen embeber; las escrituras frecuentes favorecen referenciar. |
| ¿El dato referenciado cambia independientemente? | Si cambia solo, referenciarlo evita actualizar todo. |
| ¿La suma de los elementos puede crecer sin límite? | Un array que crece sin control es un antipatrón. |

Si la consulta típica es «dame el pedido completo», embeber las líneas tiene
sentido. Si hay aplicaciones de log con millones de mensajes, referencias tiene
sentido.

### 17.4. Validación de esquema: la calidad de datos aplicada al modelo

Una vez modelado, el esquema define **las reglas que los datos deben cumplir**:
qué campos existen, cuáles son obligatorios, qué tipo tienen y qué valores se
aceptan.

Esto **no es un paso aparte de la calidad de datos**: es la misma validez de
datos, expresada sobre el modelo.

| Regla que puede declarar el esquema | Dimensión de calidad que comprueba |
|---|---|
| `order_id` y `customer_id` obligatorios | **Completitud** (no hay nulos donde no debe haberlos) |
| `order_id` único | **Unicidad** (la clave identifica) |
| `price` numérico, `qty` entero | **Validez de tipos** |
| `channel` sólo `tienda`, `web`, `app` | **Validez de dominio** |
| `qty > 0`, `price > 0` | **Validez de rango** |
| `importe ≈ qty × price` | **Consistencia entre campos** |

En un modelo relacional estas reglas se expresan con restricciones (`NOT NULL`,
claves primarias, claves foráneas, `CHECK`). En un modelo documental muchas bases
permiten **validación de esquema** al escribir (campos obligatorios, tipos y
rangos). El paso de **schema-on-read a schema-on-write** es otra forma de guardar
esas reglas.

Por tanto, el modelado y la calidad no son bloques separados: el **modelo define
las reglas**, y la **calidad comprueba que los datos las cumplen** y documenta qué
hacer cuando no se cumplen.
