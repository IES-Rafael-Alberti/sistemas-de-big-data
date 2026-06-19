# UD4 - Documento 03
## Preparación de datos para cuadros de mando

---

## 1. Introducción

Antes de crear cuadros de mando en herramientas como Metabase o Superset, es necesario preparar los datos de forma adecuada.

Un error frecuente es conectar directamente una base de datos operacional a una herramienta BI y comenzar a crear gráficos sin ningún tipo de preparación previa.

En entornos profesionales, los datos suelen pasar por una fase intermedia de transformación y preparación.

En esta unidad aplicaremos una versión simplificada de ese proceso.

---

## 2. Tablas derivadas y vistas para BI

En muchos casos no es recomendable trabajar directamente con las tablas originales.

Es habitual crear:

- vistas SQL,
- tablas derivadas,
- tablas agregadas.

Esto permite:

- simplificar el modelo,
- reducir errores,
- controlar mejor las métricas.

Ejemplo de vista simplificada:

```sql
CREATE VIEW ventas_resumen AS
SELECT
    fecha,
    producto_id,
    SUM(cantidad) AS total_cantidad,
    SUM(importe) AS total_importe
FROM ventas
GROUP BY fecha, producto_id;
````

Esta vista facilita el trabajo posterior en la herramienta BI.

---

## 3. Agregaciones y preagregaciones

Una agregación consiste en resumir datos a un nivel superior.

Ejemplos:

* ventas por mes,
* ventas por región,
* ventas por categoría.

Las preagregaciones pueden ser útiles cuando:

* el volumen de datos es alto,
* las consultas son repetitivas,
* el rendimiento es importante.

No siempre es necesario preagregar, pero es importante entender el concepto.

---

## 4. Fechas y calendarios

El tiempo es una dimensión fundamental en BI.

Problemas frecuentes:

* fechas almacenadas como texto,
* ausencia de columnas para mes o año,
* dificultad para agrupar por periodos.

Es recomendable disponer de:

* fecha completa,
* mes,
* año,
* trimestre,
* semana si es necesario.

Ejemplo de tabla de fechas simplificada:

* fecha
* día
* mes
* año
* trimestre

Esto facilita la creación de gráficos temporales coherentes.

---

## 5. Medidas calculadas vs medidas almacenadas

Una medida puede:

* almacenarse directamente en la base de datos,
* calcularse en la herramienta BI,
* calcularse mediante vista SQL.

Ejemplo de medida calculada:

Margen = importe - coste

Decidir dónde calcular una medida depende de:

* frecuencia de uso,
* claridad,
* rendimiento,
* necesidad de reutilización.

En este módulo priorizaremos claridad y coherencia.

---

## 6. Control de cambios en el dataset

En entornos reales los datos evolucionan.

Puede cambiar:

* la estructura,
* la granularidad,
* el significado de una columna.

Es importante:

* documentar los cambios,
* evitar modificar estructuras sin justificarlo,
* mantener coherencia en los dashboards.

En el proyecto integrador de la UD6 será obligatorio justificar cualquier cambio estructural.

---

## 7. Consistencia entre modelo y cuadro de mando

Un cuadro de mando debe reflejar correctamente el modelo de datos.

Preguntas que deben hacerse antes de crear un dashboard:

* ¿Qué representa exactamente esta métrica?
* ¿A qué nivel de detalle está calculada?
* ¿Se están mezclando granularidades distintas?
* ¿Existen duplicados que puedan inflar resultados?

Estas preguntas son fundamentales para evitar errores de interpretación.

---

## 8. Conexión con herramientas BI

Cuando los datos están:

* limpios,
* estructurados,
* agregados de forma coherente,
* documentados,

las herramientas BI funcionan mejor y los dashboards son más fiables.

La herramienta no corrige un mal modelo.

---

## 9. Preparación para el laboratorio

En los laboratorios de esta unidad:

* no se trabajará directamente con datos desordenados,
* se utilizará un dataset estructurado,
* se exigirá justificar las agregaciones utilizadas.

El objetivo es aprender a pensar antes de visualizar.

---

## 10. Conclusiones

La preparación de datos es una fase silenciosa pero crítica.

Un dashboard bien construido empieza:

* en la calidad del dato,
* en el modelado,
* en la coherencia de las agregaciones.

En BI, la interpretación depende directamente de la estructura.

---

## Fin del documento