# UD1 · Mini actividad: fundamentos matemáticos sobre CadenaRetail

Actividad breve para aplicar la cápsula matemática normativa al caso
`CadenaRetail`. No busca hacer matemáticas abstractas: busca usar conjuntos,
reglas lógicas y complejidad para tomar mejores decisiones técnicas con datos.

## Duración y formato

- **Tiempo estimado:** 20-30 minutos.
- **Formato:** parejas.
- **Entrega:** breve respuesta escrita o puesta en común en clase.
- **Evaluación:** formativa. Puede usarse como evidencia rápida de RA1/CE1.a si
  se recoge la respuesta.

## Material de partida

La cadena recibe ventas desde tienda física y e-commerce. El catálogo maestro es
la referencia oficial de productos.

### Catálogo maestro

```text
TS-ROJO-M
TS-AZUL-M
TS-NEGRO-L
PANT-VAQ-42
ZAP-BLANCO-39
```

### SKU vendidos en los ficheros recibidos

```text
TS-ROJO-M
TSHIRT_4421
TS-AZUL-M
PANT-VAQ-42
PANT-VAQ-42
ZAP-BLANCO-39
GORRA-VERDE-U
```

### Líneas de venta simplificadas

| pedido_id | sku | unidades | precio_unitario | precio_total | fecha_evento | fecha_carga |
|---:|---|---:|---:|---:|---|---|
| 1001 | TS-ROJO-M | 2 | 12.50 | 25.00 | D | D+1 |
| 1002 | TSHIRT_4421 | 1 | 12.50 | 12.50 | D | D+1 |
| 1003 | TS-AZUL-M | 3 | 10.00 | 25.00 | D | D+1 |
| 1004 | GORRA-VERDE-U | 1 | 8.00 | 8.00 | D | D+3 |
| 1005 | PANT-VAQ-42 | 1 | 30.00 | 30.00 | D | D+1 |

Para esta actividad, considera que el SLA provisional de carga es:

> Los datos de ventas deben estar cargados como máximo en **D+1**.

Un SLA (*Service Level Agreement*, acuerdo de nivel de servicio) es un compromiso
medible sobre el comportamiento esperado de un servicio.

## Parte 1 — Conjuntos: qué pertenece y qué no

Trabaja con dos conjuntos:

- `catalogo`: SKU oficiales del catálogo maestro.
- `vendidos`: SKU que aparecen en los ficheros de ventas.

Responde:

1. ¿Qué SKU aparecen en ventas y **también** existen en catálogo?
2. ¿Qué SKU aparecen en ventas pero **no** existen en catálogo?
3. ¿Qué SKU existen en catálogo pero no aparecen en estas ventas?
4. ¿Qué harías con las ventas cuyo SKU no pertenece al catálogo: cargarlas,
   rechazarlas o enviarlas a cuarentena? Justifica la decisión.

Pista conceptual:

- Intersección: elementos comunes.
- Diferencia: elementos que están en un conjunto y no en otro.

## Parte 2 — Lógica: reglas ejecutables

Convierte estas decisiones en reglas `SI ... ENTONCES ...`:

1. Validación de importe:
   - si `precio_total != unidades * precio_unitario`, la fila no debe publicarse
     en Curado sin revisión.
2. Validación de catálogo:
   - si `sku` no pertenece al catálogo maestro, la fila debe ir a cuarentena.
3. Validación de puntualidad:
   - si `fecha_carga` supera `D+1`, la fila incumple el SLA provisional de carga.

Después aplica las reglas a las cinco líneas de venta y completa esta tabla:

| pedido_id | ¿SKU válido? | ¿Importe válido? | ¿Cumple SLA D+1? | Decisión |
|---:|---|---|---|---|
| 1001 |  |  |  |  |
| 1002 |  |  |  |  |
| 1003 |  |  |  |  |
| 1004 |  |  |  |  |
| 1005 |  |  |  |  |

Usa decisiones concretas, por ejemplo:

- publicar;
- enviar a cuarentena por SKU;
- revisar importe;
- marcar incumplimiento de SLA.

## Parte 3 — Complejidad: qué escala y qué no

Imagina que hay diez ventas y cinco productos: casi cualquier solución parece
rápida. Pero en Big Data no diseñamos solo para diez filas.

Compara estas dos formas de validar si cada `sku` vendido existe en el catálogo:

### Opción A — Buscar recorriendo todo el catálogo

```text
para cada venta:
    para cada sku_catalogo:
        comprobar si son iguales
```

### Opción B — Preparar un conjunto de búsqueda

```text
catalogo_set = conjunto con todos los SKU oficiales

para cada venta:
    comprobar si venta.sku pertenece a catalogo_set
```

Responde:

1. ¿Cuál es más razonable si hay 10 ventas y 5 SKU de catálogo?
2. ¿Cuál es más razonable si hay 10 millones de ventas y 200 000 SKU de catálogo?
3. ¿Por qué una decisión matemática pequeña puede cambiar el coste de un pipeline
   Big Data?

No hace falta calcular tiempos reales. Basta con razonar sobre el número de
comparaciones.

## Parte 4 — Conclusión breve

Escribe 5-7 líneas respondiendo:

> ¿Por qué conjuntos, reglas lógicas y complejidad ayudan a diseñar mejor un
> pipeline de datos?

La respuesta debe mencionar al menos:

- una decisión de calidad de datos;
- una regla que pueda automatizarse;
- una decisión que afecte al rendimiento.

## Criterios de corrección rápida

- Identifica correctamente SKU válidos, desconocidos y ausentes.
- Formula reglas lógicas verificables, no frases vagas.
- Aplica las reglas de forma coherente a las cinco filas.
- Distingue una solución que funciona en pequeño de una que escala mejor.
- Conecta la actividad con el diseño del pipeline, no solo con operaciones
  matemáticas aisladas.
