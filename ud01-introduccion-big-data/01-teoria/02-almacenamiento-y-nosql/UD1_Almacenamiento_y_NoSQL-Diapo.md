---
title: "UD1 — Almacenamiento y NoSQL"
author: "José Manuel Sánchez Álvarez"
institution: "IES Rafael Alberti"
course: "Sistemas de Big Data · 2025–2026"
revealjs-theme: simple
revealjs-transition: slide
---

## UD1 — Almacenamiento y NoSQL

Del dato que guardamos al sistema que puede crecer

---

## Cuando una máquina ya no basta

- Aumentan el **volumen**, la velocidad y la variedad.
- Millones de eventos por hora exigen baja latencia.
- Una única máquina potente tiene límites de CPU, RAM, disco y disponibilidad.

```text
una máquina ──► cuello de botella
varias máquinas ──► capacidad + disponibilidad
```

---

## Escalar horizontalmente

En vez de comprar siempre una máquina mayor, repartimos el trabajo:

```text
             ┌─ nodo A ─┐
clientes ────┼─ nodo B ─┼── datos distribuidos
             └─ nodo C ─┘
```

El almacenamiento distribuido combina **particionado** y **replicación**.

---

## ¿Qué significa NoSQL?

**No Solo SQL**: motores que no siguen necesariamente el modelo relacional clásico.

- Modelos flexibles y distribución entre nodos.
- Priorizan según el caso: escalabilidad, latencia o disponibilidad.
- No significa “sin transacciones” ni “sin consistencia”.

> No hay una base mejor en abstracto: hay un compromiso adecuado para cada acceso.

---

## Schema-on-read

```text
ingesta rápida ──► documentos con versiones distintas
                         │
                         ▼
                 esquema al leer
```

- Se puede almacenar antes de fijar toda la estructura.
- Acelera APIs y eventos que evolucionan.
- Traslada la validación al consumo: la flexibilidad **no elimina** la calidad.

---

## Particionar (sharding)

Repartimos filas o documentos según una **clave de partición**:

```text
usuario_id = 1, 4 ──► nodo A
usuario_id = 2, 5 ──► nodo B
usuario_id = 3, 6 ──► nodo C
```

Elegir mal produce un **punto caliente** o consultas que deben recorrer todo el clúster.

---

## Diseñar desde la consulta

Pregunta primero: **¿cómo voy a leer?**

- Eventos de un usuario y mes → `usuario_id + rango_temporal`.
- Agregaciones por producto → partición o vista derivada por `producto_id`.

No existe una clave universal: particionar es aceptar compromisos entre distribución, latencia y consultas.

---

## Replicar para sobrevivir

La replicación mantiene copias en distintos nodos:

```text
primario ──replica──► secundario 1
    └─────replica──► secundario 2
```

- **Primario-secundarios**: escritura sencilla, lecturas distribuidas.
- **Par a par**: varios nodos escriben; hay que resolver conflictos.

Se paga con espacio y complejidad a cambio de disponibilidad.

---

## Cuatro familias NoSQL

| Familia | Unidad principal | Consulta típica |
|---|---|---|
| Documental | documento JSON | entidad completa |
| Clave-valor | clave → valor | clave exacta |
| Columna-familia | columnas agrupadas | muchas filas, pocas columnas |
| Grafo | nodos y aristas | recorridos y relaciones |

---

## Documental

```json
{ "pedido": 42,
  "cliente": "Ana",
  "lineas": [{"producto":"P1", "unidades":2}]
}
```

- MongoDB, CouchDB.
- Brilla al recuperar objetos completos y esquemas cambiantes.
- Anticaso: transacciones cruzadas o agregados de almacén de datos muy complejos.

---

## Clave-valor

```text
"sesion:ana" ──► {carrito: [...], expira: ...}
```

- Redis, Riak, DynamoDB.
- Ideal para caché, sesiones, preferencias y carritos.
- El valor es opaco: si necesitamos filtrar por sus campos, este modelo no encaja por sí solo.

---

## Columna-familia

Agrupa datos por columnas o familias para leer pocas columnas de muchas filas.

```text
filas masivas ──► [temperatura] [presión]
                   leer solo una familia
```

- HBase y Cassandra (referencia: Bigtable).
- Adecuada para analítica, OLAP/BI y grandes volúmenes.
- Anticaso: OLTP con muchas escrituras puntuales y transaccionales.

---

## Grafos

```text
(Ana) ──compra──► (libro)
  │                 │
 sigue            escrito_por
  ▼                 ▼
(Luis) ─────────► (autora)
```

- Neo4j, ArangoDB, Neptune.
- La relación es el dato: rutas, recomendaciones, redes y fraude.
- Anticaso: actualizaciones masivas homogéneas o tablas transaccionales clásicas.

---

## Elegir: casos y anticasos

```text
¿documento completo? ──► documental
¿clave exacta?        ──► clave-valor
¿agregación masiva?   ──► columna-familia / Parquet
¿patrón de conexiones?──► grafo
```

Después comprobamos volumen, latencia, disponibilidad, evolución del esquema y coste.

---

## UD1, UD2 y UD3: una cadena

```text
UD1: calidad + tipos + formatos + coste
  │
  ▼
UD2: ingesta API/CSV ──► Parquet / NoSQL de servicio
  │
  ▼
UD3: Spark ──► procesamiento distribuido y analítica
```

Una arquitectura real puede combinar modelos: NoSQL para servir, Parquet para batch y grafos para relaciones.

---

## Ideas para llevarse

- Escalar significa distribuir datos y responsabilidades.
- NoSQL cambia el modelo y los compromisos; no elimina el diseño.
- **Modelar desde las consultas** evita particiones inútiles.
- Schema-on-read requiere validaciones explícitas.
- Elegir tecnología es elegir un patrón de acceso.
