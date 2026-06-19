Perfecto.
Te dejo el **documento completo en Markdown**, estructurado para que lo puedas subir directamente a Moodle, GitHub Classroom o integrarlo en tu repositorio del módulo SBD.

---

# 📊 Práctica de Business Intelligence con Power BI

## Objetivo de la sesión

El alumnado será capaz de:

* Instalar o acceder a Power BI.
* Conectar un dataset.
* Construir un modelo relacional.
* Crear medidas en DAX.
* Diseñar visualizaciones clave.
* Construir un dashboard.
* Entender el flujo de publicación.

---

# 0️⃣ Instalación o Acceso

## Opción A — Power BI Desktop

**Software:** Microsoft Power BI Desktop

**Requisitos:**

* Windows 10/11
* Cuenta Microsoft (opcional)

**Instalación:**

1. Descargar desde la web oficial.
2. Ejecutar instalador.
3. Abrir aplicación.

> ⚠ No existe versión nativa para Linux.

---

## Opción B — Power BI en la nube

**Plataforma:** Power BI Service

Acceso vía navegador.

Permite:

* Visualizar reportes.
* Crear dashboards.
* Compartir informes.
* Trabajo colaborativo.

> El modelado avanzado se realiza mejor en Desktop.

---

# 1️⃣ Conexión a un Dataset

## Dataset ejemplo: Ventas

| Fecha      | Producto | Categoría  | Ventas | Unidades |
| ---------- | -------- | ---------- | ------ | -------- |
| 2024-01-01 | A        | Tecnología | 2000   | 5        |

## Pasos

1. Inicio → **Obtener datos**
2. Seleccionar fuente (CSV / Excel / BD)
3. Transformar datos en **Power Query**
4. Comprobar tipos de datos:

   * Fecha → Date
   * Ventas → Decimal
   * Unidades → Entero
5. Cargar datos

---

# 2️⃣ Creación del Modelo

Ir a **Vista Modelo**.

## Conceptos clave

* Tabla de hechos: `FactVentas`
* Tablas dimensión:

  * `DimFecha`
  * `DimProducto`
* Relación 1:N
* Esquema en estrella

Ejemplo conceptual:

```
DimFecha 1 ──── N FactVentas N ──── 1 DimProducto
```

## Buenas prácticas

* Crear tabla calendario.
* Evitar relaciones bidireccionales innecesarias.
* Cardinalidad correcta.
* Claves limpias y únicas.

---

# 3️⃣ Medidas en DAX

## Medida básica

```DAX
Total Ventas = SUM(FactVentas[Ventas])
```

## Otra medida

```DAX
Total Unidades = SUM(FactVentas[Unidades])
```

## Diferencia conceptual

| Columna Calculada     | Medida                          |
| --------------------- | ------------------------------- |
| Se evalúa fila a fila | Se evalúa en contexto de filtro |
| Se almacena           | Se calcula dinámicamente        |

> En BI profesional se priorizan medidas.

---

# 4️⃣ Creación de Visualizaciones

## 🔹 KPI

Visual tipo **Tarjeta**.

Campos:

* Valor: `Total Ventas`
* Opcional: Objetivo

Objetivo didáctico:

* Mostrar valor agregado principal.

---

## 🔹 Serie Temporal

Visual tipo **Línea**.

* Eje X: Fecha (jerarquía Año-Mes)
* Eje Y: Total Ventas

Permite analizar:

* Tendencia
* Estacionalidad
* Evolución mensual

---

## 🔹 Gráfico Categórico

Visual tipo **Barras / Columnas**.

* Eje: Categoría
* Valor: Total Ventas

Permite:

* Comparación entre grupos
* Identificación de Top categorías

---

# 5️⃣ Construcción del Dashboard

## Diseño recomendado

```
--------------------------------
| KPI Principal               |
--------------------------------
| Serie Temporal              |
--------------------------------
| Gráfico por Categoría       |
--------------------------------
| Segmentadores (Filtros)     |
--------------------------------
```

## Elementos clave

* Segmentadores (Slicers)
* Drill-down
* Interacciones entre gráficos
* Tooltips informativos

---

# 6️⃣ Publicación Conceptual

Desde Desktop:

1. Clic en **Publicar**
2. Seleccionar Workspace
3. Subir informe

En la nube:

* Crear Dashboard
* Anclar visualizaciones
* Compartir
* Configurar actualización programada

---

# 🔁 Flujo Profesional BI

1. Extracción de datos
2. Transformación (ETL)
3. Modelado
4. Medidas (DAX)
5. Visualización
6. Publicación
7. Consumo por negocio

---

