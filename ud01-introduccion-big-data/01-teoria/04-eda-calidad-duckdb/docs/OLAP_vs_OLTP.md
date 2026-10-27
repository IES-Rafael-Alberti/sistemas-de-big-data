# OLAP y OLTP: dos formas de trabajar con datos

La diferencia principal está en el tipo de trabajo que realiza el sistema.

| | **OLTP** | **OLAP** |
|---|---|---|
| Significado | *Online Transaction Processing* | *Online Analytical Processing* |
| Pregunta | ¿Qué está ocurriendo ahora? | ¿Qué ha ocurrido y qué patrón vemos? |
| Operaciones | Muchas operaciones pequeñas de lectura y escritura | Consultas grandes sobre muchas filas |
| Datos | Actuales y operativos | Históricos, integrados o agregados |
| Optimizado para | Transacciones, concurrencia y consistencia | Consultas analíticas y toma de decisiones |
| Ejemplo | Registrar una compra | Calcular ventas por mes y ciudad |

## Ejemplo: una tienda

### OLTP: registrar una venta

El sistema debe responder rápidamente y no perder ninguna operación:

```sql
INSERT INTO pedidos ...;
UPDATE stock SET unidades = unidades - 1 ...;
```

### OLAP: analizar las ventas

La consulta lee muchas filas para encontrar tendencias:

```sql
SELECT ciudad, SUM(importe) AS ventas
FROM ventas
GROUP BY ciudad;
```

## Regla para recordarlo

- **OLTP = tramitar operaciones.**
- **OLAP = analizar operaciones.**

En una arquitectura real suelen convivir ambos tipos de sistema:

```text
OLTP: tienda online → pedidos y stock
                    ↓ ETL/ELT
OLAP: Parquet/DuckDB/Spark → informes y decisiones
```

## ¿Dónde encaja DuckDB?

DuckDB es principalmente **OLAP**. Está pensado para analizar conjuntos de datos
grandes y realizar agregaciones, filtros y joins; no suele ser el sistema principal
de pedidos con muchas escrituras concurrentes.

No significa que OLAP sea “mejor” que OLTP. Resuelven problemas distintos y una
arquitectura de datos suele necesitar los dos.
