---
title: "UD1 — Modelado de datos"
author: "José Manuel Sánchez Álvarez"
institution: "IES Rafael Alberti"
course: "Sistemas de Big Data · 2025–2026"
revealjs-theme: simple
revealjs-transition: slide
---

## UD1 — Modelado de datos

Cómo convertir una pregunta en una estructura que funciona

---

## El modelo empieza por el uso

Modelar datos es decidir **cómo organizarlos para guardarlos y consultarlos** según el objetivo del sistema.

```text
pregunta de negocio → patrón de lectura → modelo → formato → tecnología
```

No hay un modelo universalmente mejor: hay un modelo adecuado para cada acceso.

---

## ¿Qué ganamos al modelar?

- **Significado:** cada campo tiene una definición, unidad y regla.
- **Integridad:** menos duplicidades, referencias rotas y contradicciones.
- **Rendimiento:** consultas y agregaciones más directas.
- **Evolución:** cambios de esquema visibles y controlables.
- **Coste:** menos datos leídos, mejor compresión y menos memoria.

> Un buen modelo hace explícitas decisiones que, de otro modo, aparecen como errores.

---

## Antes de guardar: entidad y granularidad

La **granularidad** dice qué representa exactamente cada registro.

```text
un pedido       → 1 documento
una línea       → 1 fila
un cambio       → 1 evento
una medición    → 1 sensor y minuto
```

Completa siempre la frase: **«Cada registro representa exactamente…»**

Si no está clara, un `SUM` puede contar el mismo pedido varias veces.

---

## Claves: identidad que sobrevive a las transformaciones

| Clave | Papel | Ejemplo |
|---|---|---|
| Primaria | identifica una entidad | `order_id` |
| Foránea | conserva una relación | `customer_id` en `orders` |
| Natural | viene del dominio | ISBN, SKU |
| Técnica | la genera el sistema | entero, UUID |

Al aplanar un pedido, repetir `order_id` en sus filas permite reconstruir la relación con sus líneas.

---

## Del dominio al almacenamiento

```text
CONCEPTUAL           LÓGICO                    FÍSICO
Cliente realiza      orders(order_id,          PostgreSQL / MongoDB /
Pedidos              customer_id, fecha)       Parquet + DuckDB
```

- **Conceptual:** objetos y relaciones, sin casarse con una tecnología.
- **Lógico:** atributos, claves, cardinalidades y reglas.
- **Físico:** índices, particiones, tipos, compresión y formato.

---

## Seis familias, seis preguntas

| Modelo | Unidad | Encaja cuando preguntamos… |
|---|---|---|
| Relacional | fila relacionada | ¿qué transacción e integridad necesito? |
| Documental | documento JSON | ¿puedo devolver la entidad completa? |
| Clave-valor | clave → valor | ¿cuál es el valor de esta clave exacta? |
| Grafo | nodos + aristas | ¿qué conexiones y rutas existen? |
| Series temporales | medición + tiempo | ¿cómo evoluciona esta señal? |
| Columnar | columnas de muchas filas | ¿qué agregación analítica calculo? |

---

## Relacional: reglas y transacciones

```text
customers ──1:N──► orders ──1:N──► order_items
```

- Tablas, claves, relaciones y restricciones explícitas.
- Adecuado para **OLTP**: muchas operaciones pequeñas y consistentes.
- Los `JOIN` recomponen información repartida sin duplicarla.

**Elegirlo** cuando importan la integridad referencial y las transacciones entre entidades.

---

## Documental: una entidad lista para servir

```json
{
  "order_id": 1,
  "customer_id": 234,
  "items": [{"sku": "SKU0007", "qty": 2, "price": 12.50}]
}
```

- Pedido y líneas viajan juntos: una lectura, sin `JOIN`.
- Flexible ante campos que evolucionan.
- No es la mejor opción para agregaciones globales muy repetidas.

Ideal para APIs que recuperan **un objeto completo**.

---

## Clave-valor, grafo y series temporales

| Si el dato principal es… | Modelo | Ejemplo de acceso |
|---|---|---|
| una clave exacta | Clave-valor | `sesion:ana → carrito` |
| una relación | Grafo | rutas, recomendaciones, fraude |
| una señal en el tiempo | Series temporales | sensor por minuto, métricas |

La relación o el tiempo no son adornos: determinan la consulta que conviene optimizar.

---

## Columnar: leer menos para analizar más

```text
filas:  pedido  cliente  fecha  sku  qty  importe
columnas:       [fecha] [sku] [importe]
                         └── leer sólo lo necesario ──┘
```

- Agrupa valores por columna y comprime muy bien.
- Adecuado para **OLAP**: muchas filas, pocas columnas y agregaciones.
- Parquet aporta tipos, compresión y lectura selectiva; DuckDB consulta localmente con SQL.

---

## OLTP y OLAP no hacen la misma pregunta

| | OLTP | OLAP |
|---|---|---|
| Objetivo | registrar/servir operaciones | explorar y resumir histórico |
| Acceso | pequeño, frecuente, concurrente | grande, analítico, por lotes |
| Modelo típico | relacional o documental | plano, columnar, Parquet |
| Pregunta | «¿qué pedido tiene Ana?» | «¿ventas por canal y mes?» |

En un sistema real se combinan: servir no es lo mismo que analizar.

---

## Un pedido, dos representaciones

**Documental (JSON):** un documento por pedido, con `items` anidados.

**Analítica (plana + Parquet):** una fila por línea, repitiendo la clave del pedido.

```text
JSON:     pedido 1 ──► [línea A, línea B]
Parquet:  pedido 1 ──► fila A
                     └► fila B
```

La elección depende de la lectura: entidad completa frente a agregación masiva.

---

## Ejemplo: JSON para servir, Parquet para preguntar

```sql
SELECT canal, date_trunc('month', fecha) AS mes,
       SUM(qty * price) AS ventas
FROM 'orders.parquet'
GROUP BY canal, mes;
```

- JSON/documental: la aplicación recupera un pedido sin reconstruirlo.
- Parquet + DuckDB: el motor lee `canal`, `fecha`, `qty` y `price`, no todo el fichero.
- El dato derivado (`importe`) debe documentar su fórmula y momento de cálculo.

---

## Proceso de diseño: de la pregunta al modelo

```text
1 objetivo → 2 entidades/eventos → 3 granularidad → 4 claves
     → 5 originales/derivados → 6 formato → 7 justificación y pruebas
```

Diseñar desde las consultas evita elegir una tecnología por moda.

Pregunta de control: **¿qué operación debe ser rápida y qué consistencia necesita?**

---

## Checklist antes de entregar

- [ ] Puedo explicar qué representa cada fila, documento o medición.
- [ ] Las claves conservan identidad y relaciones.
- [ ] El modelo responde a consultas reales, no sólo a un diagrama.
- [ ] He separado necesidades OLTP y OLAP.
- [ ] El formato elegido justifica coste, compresión y lectura.
- [ ] Los campos derivados tienen fórmula, tipos y fecha de cálculo.
- [ ] He documentado anticasos y cómo evolucionará el esquema.

---

## Para llevarse

**Modelar es decidir antes de almacenar.**

1. Empieza por cómo vas a leer.
2. Fija la granularidad y protege las claves.
3. Elige el modelo que hace natural la consulta.
4. Combina documental para servir y columnar para analizar cuando tenga sentido.

> La mejor tecnología es la que hace explícito el patrón de acceso.
