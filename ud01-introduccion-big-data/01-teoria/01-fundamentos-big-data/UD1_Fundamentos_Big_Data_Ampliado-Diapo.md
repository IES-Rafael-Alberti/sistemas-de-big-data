---
title: "UD1 — Fundamentos de Big Data"
author: "José Manuel Sánchez Álvarez"
institution: "IES Rafael Alberti"
course: "Sistemas de Big Data · 2025–2026"
revealjs-theme: simple
revealjs-transition: slide
---

## UD1 — Fundamentos de Big Data

### Del dato al valor

---

## El problema

- Datos grandes, rápidos y variados
- Diferentes calidades y formatos
- El dato también tiene un coste

> Big Data no es acumular datos: es extraer valor de forma sostenible.

---

## Caso: una cadena minorista

```text
Tiendas físicas ── CSV ──┐
                         ├─► ¿Qué vender y cuándo reponer?
Comercio web ──── JSON ──┘
```

- SKUs escritos como `ABC-123`, `abc123` o `ABC123`
- Ficheros reenviados y duplicados
- Retrasos y dudas sobre la fuente correcta

---

## ¿Cuándo hablamos de Big Data?

Cuando el volumen, la velocidad o la variedad superan los límites prácticos de las herramientas habituales.

```text
Una máquina ──► RAM/CPU/tiempo insuficientes
                     │
                     ▼
          almacenamiento y cómputo distribuidos
```

No basta con añadir Hadoop, Spark o IA: hay que elegir un diseño.

---

## Las 5 V: nuestra brújula

| V | Pregunta | Ejemplo retail |
|---|---|---|
| **Volumen** | ¿Cuánto hay? | Años de tickets y logs |
| **Velocidad** | ¿Cuándo llega? | Clics y transacciones |
| **Variedad** | ¿Qué forma tiene? | CSV, JSON, imágenes |
| **Veracidad** | ¿Es fiable? | Duplicados y nulos |
| **Valor** | ¿Qué acción permite? | Evitar roturas de stock |

*La variabilidad —campañas, picos y cambios— obliga a revisar las reglas.*

---

## Tres dimensiones del dato

```text
ESTRUCTURA       LATENCIA             SENSIBILIDAD
tabla / JSON /   tiempo real /        público / personal /
imagen            lote (D+1)          salud / financiero
```

- La estructura condiciona cómo procesamos
- La latencia condiciona la arquitectura y el coste
- La sensibilidad condiciona acceso, gobierno y RGPD

---

## Formatos: cada uno tiene su lugar

| Formato | Fortalezas | Uso típico |
|---|---|---|
| **CSV** | Universal y legible | Intercambio sencillo |
| **JSON** | Flexible y jerárquico | APIs y eventos |
| **Parquet** | Columnar, comprimido, rápido | Analítica y capa curated |
| **Avro** | Filas y esquemas versionados | Streaming y Kafka |

```text
Ingesta/intercambio: CSV, JSON  ──►  Analítica: Parquet
Eventos con contrato: Avro
```

---

## Warehouse, lake y lakehouse

```text
Data warehouse      Data lake             Lakehouse
estructura y SQL    flexible y barato     lake + ACID + SQL
datos transformados datos casi crudos     Parquet + transacciones
```

- **Warehouse**: salón ordenado, gobernado
- **Lake**: gran almacén flexible
- **Lakehouse**: almacén flexible con estanterías y garantías

---

## ETL o ELT

```text
ETL:  Extraer ──► Transformar ──► Cargar
ELT:  Extraer ──► Cargar ────────► Transformar
```

- **ETL**: útil si el destino es rígido y exige datos limpios
- **ELT**: conserva el original y transforma usando cómputo elástico
- En esta unidad razonaremos principalmente con **ELT**

---

## Tres capas para no perder el contexto

```text
raw ─────────► processed ─────────► curated
original       tipado y normalizado  listo para consultar
```

- **raw**: conserva lo que llegó
- **processed**: fechas, tipos, nombres y reglas básicas
- **curated**: calidad validada, KPIs y decisiones documentadas

---

## Del caso a una tubería de datos

```text
CSV + JSON
    │
    ▼
 raw (originales)
    │ normalizar SKU, tipos y duplicados
    ▼
 processed
    │ validar catálogo maestro
    ▼
 curated / Parquet / partición por fecha
    │
    ▼
 ventas · unidades · stock · canal
```

Clave de duplicado posible: `fecha + tienda + sku`.

---

## Calidad, coste y tiempo

```text
                 CALIDAD
                /       \
               /         \
           COSTE ─────── TIEMPO
```

- CSV puede parecer barato, pero encarece lecturas y uniones
- Tipos correctos mejoran compresión y filtros
- Particionar por fecha evita leer años para consultar una semana

> Optimizar una sola esquina suele desplazar el problema a otra.

---

## Decisiones que sí crean valor

- Definir primero una pregunta de negocio
- Aceptar **D+1** cuando el tiempo real no aporta valor
- Validar dominios, rangos y consistencia
- Medir tamaño y velocidad al pasar de CSV a Parquet

```text
Dato veraz + oportuno + bien modelado ──► decisión accionable
```

---

## Actividad de cierre

En parejas, diseñad el flujo para detectar roturas de stock:

1. ¿Qué fuente llega y con qué latencia?
2. ¿Qué guardaríais en `raw`, `processed` y `curated`?
3. ¿CSV, JSON, Parquet o Avro? Justificadlo.
4. ¿Qué regla de calidad y qué KPI comprobaríais?

### Idea para llevarse

**La arquitectura adecuada convierte datos fiables en decisiones, sin pagar complejidad innecesaria.**
