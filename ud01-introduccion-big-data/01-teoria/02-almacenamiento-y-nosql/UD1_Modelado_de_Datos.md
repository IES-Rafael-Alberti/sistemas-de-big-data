# UD1 · Modelado de datos: qué es y cómo se hace

## 1. Qué es modelar datos

**Modelar datos** es decidir cómo se organizan los datos para poder **guardarlos y
consultarlos** de forma razonable según lo que vayamos a hacer con ellos.

No es una tarea opcional al final del proceso: es la decisión que determina si las
consultas son rápidas, si se entiende el dato, si se puede crecer y si no se
producen errores por duplicar o perder información.

Modelar no es «hacer una tabla bonita». Es responder a estas preguntas antes de
guardar:

- ¿Qué entidad estoy representando? (un pedido, una venta, un usuario)
- ¿Qué campos tiene esa entidad?
- ¿Qué campos repito para poder relacionar datos (claves)?
- ¿Cómo voy a **leer** estos datos después?
- ¿Qué formato y modelo de almacenamiento me conviene?

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
