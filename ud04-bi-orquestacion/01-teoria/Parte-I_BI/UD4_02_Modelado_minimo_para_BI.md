# UD4 - Documento 02
## Modelado mínimo de datos para Business Intelligence

---

## 1. Por qué el modelado es importante en BI

Un cuadro de mando depende directamente de la estructura de los datos.

Si los datos están:

- desordenados,
- duplicados,
- mal relacionados,
- sin coherencia temporal,

los gráficos pueden parecer correctos, pero las conclusiones serán erróneas.

En BI no basta con tener datos; es necesario tener datos bien estructurados.

---

## 2. Datos operacionales vs datos analíticos

Es fundamental distinguir entre dos tipos de sistemas.

### 2.1 Sistemas operacionales (OLTP)

Están diseñados para:

- registrar operaciones en tiempo real,
- insertar y actualizar registros constantemente,
- garantizar integridad transaccional.

Ejemplos:

- sistema de ventas,
- gestión de pedidos,
- gestión de inventario.

Las bases de datos operacionales suelen estar muy normalizadas.

---

### 2.2 Sistemas analíticos (OLAP)

Están diseñados para:

- consultar grandes volúmenes de datos,
- realizar agregaciones,
- analizar tendencias,
- apoyar decisiones.

En estos sistemas la prioridad es la consulta eficiente, no la actualización constante.

---

## 3. Modelo estrella básico

En BI se suele utilizar una estructura sencilla llamada modelo estrella.

Este modelo consta de:

- una tabla de hechos,
- varias tablas de dimensiones.

---

### 3.1 Tabla de hechos

Contiene:

- las métricas numéricas,
- claves hacia dimensiones.

Ejemplo:

Tabla: ventas

Columnas:

- fecha_id
- producto_id
- cliente_id
- cantidad
- importe

Las métricas suelen ser:

- cantidad
- importe
- margen

---

### 3.2 Tablas de dimensiones

Contienen información descriptiva.

Ejemplo:

Tabla: producto

- producto_id
- nombre
- categoría
- precio

Tabla: cliente

- cliente_id
- región
- segmento

Tabla: fecha

- fecha_id
- día
- mes
- año
- trimestre

---

## 4. Granularidad del dato

La granularidad define el nivel mínimo de detalle de la tabla de hechos.

Ejemplos:

- una fila por venta individual,
- una fila por día y producto,
- una fila por mes y región.

Elegir mal la granularidad puede impedir ciertos análisis.

Regla general:

La tabla de hechos debe tener el nivel más detallado posible razonable.

---

## 5. Jerarquías en dimensiones

Las dimensiones suelen tener jerarquías.

Ejemplo dimensión tiempo:

- día -> mes -> trimestre -> año

Ejemplo dimensión geografía:

- ciudad -> provincia -> país

Estas jerarquías permiten:

- agrupar datos,
- cambiar nivel de análisis,
- comparar periodos.

---

## 6. Calidad del dato aplicada a BI

En BI los errores comunes incluyen:

- valores nulos en dimensiones clave,
- duplicados en tablas de hechos,
- incoherencias temporales,
- categorías mal definidas.

Antes de crear dashboards es necesario verificar:

- que no existan duplicados,
- que las claves externas sean coherentes,
- que los tipos de datos sean correctos,
- que las fechas tengan sentido.

---

## 7. Buenas prácticas básicas de modelado

Para este módulo aplicaremos reglas simples:

1. Separar hechos y dimensiones cuando sea posible.
2. Evitar columnas ambiguas como "valor1", "dato", etc.
3. Usar nombres claros y coherentes.
4. Mantener tipos de datos adecuados.
5. Documentar el significado de las métricas.

---

## 8. Preparación para herramientas BI

Herramientas como Metabase o Superset funcionan mejor cuando:

- las tablas están limpias,
- las relaciones están bien definidas,
- las dimensiones son claras,
- las métricas son coherentes.

Un mal modelado complica innecesariamente el trabajo en BI.

---

## 9. Conexión con UD5 y UD6

Este modelado no solo sirve para cuadros de mando.

En UD5, cuando trabajemos con modelos predictivos:

- la calidad y estructura del dato será determinante.

En UD6, el proyecto integrador exigirá:

- justificar el modelo elegido,
- explicar la granularidad,
- documentar las dimensiones utilizadas.

---

## 10. Conclusiones

Un buen dashboard empieza mucho antes de la herramienta de visualización.

Empieza en el modelado del dato.

Sin un modelo claro:

- los gráficos pueden ser correctos,
- pero las decisiones pueden ser equivocadas.

El modelado mínimo que veremos en esta unidad es suficiente para trabajar BI de forma coherente en el contexto del módulo.

---

## Fin del documento