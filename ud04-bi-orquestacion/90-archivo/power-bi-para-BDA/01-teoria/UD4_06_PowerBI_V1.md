# 📊 Guía práctica de Business Intelligence con Power BI

Documento estructurado para una **sesión práctica completa de BI con Power BI**, cubriendo desde la instalación hasta la publicación conceptual de un dashboard.

---

# 0️⃣ Instalación o acceso a Power BI

## 🔹 Opción A — Instalar Microsoft Power BI Desktop

![Image](https://monashdatafluency.github.io/Power_BI/figures/ch01/desktop-interface.png)

![Image](https://learn.microsoft.com/en-us/power-bi/connect-data/media/desktop-data-view/dataview_fullscreen.png)

![Image](https://learn.microsoft.com/en-us/power-bi/transform-model/media/desktop-relationship-view/model-view-03.png)

![Image](https://learn.microsoft.com/en-us/power-bi/transform-model/media/desktop-modeling-view/modeling-view-07.png)

**Requisitos:**

* Windows 10/11
* Descarga desde la web oficial de Microsoft

**Pasos:**

1. Descargar el instalador.
2. Ejecutar instalación estándar.
3. Iniciar sesión con cuenta Microsoft (opcional pero recomendable).

> Nota: No existe versión nativa para Linux. Alternativas:
>
> * Máquina virtual Windows
> * Acceso vía Power BI Service (web)
> * Uso puntual en entorno Windows del alumnado

---

## 🔹 Opción B — Acceder a Power BI Service (nube)

![Image](https://learn.microsoft.com/vi-vn/power-bi/collaborate-share/media/service-new-workspaces/power-bi-workspace-opportunity.png)

![Image](https://learn.microsoft.com/en-us/power-bi/create-reports/media/service-dashboards/power-bi-dashboard2.png)

![Image](https://learn.microsoft.com/en-us/power-bi/create-reports/media/service-the-report-editor-take-a-tour/power-bi-report-editor-overview-2.png)

![Image](https://learn.microsoft.com/en-us/power-bi/create-reports/media/service-the-report-editor-take-a-tour/power-bi-report-editor-panes-2.png)

**Requisitos:**

* Cuenta Microsoft (educativa o profesional)

Permite:

* Visualizar informes
* Crear dashboards
* Publicar y compartir
* Trabajo colaborativo

> Limitación: modelado más completo en Desktop.

---

# 1️⃣ Conexión a un dataset

En Power BI Desktop:

**Inicio → Obtener datos**

Fuentes habituales:

* CSV
* Excel
* Base de datos (PostgreSQL, MySQL, SQL Server)
* Web API
* Parquet (vía conector adecuado)

### Ejemplo práctico

Dataset de ventas:

| Fecha | Producto | Categoría | Ventas | Unidades |
| ----- | -------- | --------- | ------ | -------- |

Pasos:

1. Seleccionar fuente.
2. Transformar datos (Power Query).
3. Limpiar columnas (tipos correctos).
4. Cargar modelo.

---

# 2️⃣ Creación del modelo de datos

![Image](https://learn.microsoft.com/en-us/power-bi/transform-model/media/desktop-relationship-view/model-view-03.png)

![Image](https://learn.microsoft.com/en-us/power-bi/guidance/media/star-schema/star-schema-example-1.svg)

![Image](https://www.scaler.com/topics/images/power-bi-model-relationships-example.webp)

![Image](https://learn.microsoft.com/en-us/power-bi/transform-model/media/desktop-relationships-understand/model-diagram-cardinality.png)

Vista **Modelo** → relaciones entre tablas.

## Conceptos clave

* Tabla de hechos (FactVentas)
* Tablas de dimensiones (DimFecha, DimProducto)
* Relaciones 1:N
* Esquema en estrella

Ejemplo:

```
DimFecha 1 —— N FactVentas N —— 1 DimProducto
```

Buenas prácticas:

* Crear tabla calendario
* Evitar relaciones ambiguas
* Cardinalidad correcta
* Dirección de filtro simple

---

# 3️⃣ Definición de una medida básica (DAX)

Power BI utiliza **DAX (Data Analysis Expressions)**.

Ejemplo: total de ventas

```DAX
Total Ventas = SUM(FactVentas[Ventas])
```

Ejemplo: total unidades

```DAX
Total Unidades = SUM(FactVentas[Unidades])
```

Diferencia conceptual:

* **Columna calculada** → se evalúa fila a fila.
* **Medida** → se evalúa en contexto de filtro.

> En BI profesional casi todo se hace con medidas.

---

# 4️⃣ Creación de visualizaciones

## 🔹 KPI

![Image](https://learn.microsoft.com/en-us/power-bi/visuals/media/power-bi-visualization-kpi/power-bi-kpi-template.png)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1400/1%2Aa6F9A5dujG4a3VX55aZpLw.png)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1200/0%2ACcmAkVs-TaB7CiRu.png)

![Image](https://miro.medium.com/1%2AW4od4Yf8uImJfHSKIEciTg.png)

Visual tipo **Tarjeta** o **KPI**.

Ejemplo:

* Indicador: Total Ventas
* Objetivo: 100.000 €
* Tendencia: respecto al mes anterior

---

## 🔹 Serie temporal

![Image](https://community.fabric.microsoft.com/t5/image/serverpage/image-id/18693i8E891E31EA59A527?v=v2)

![Image](https://community.fabric.microsoft.com/t5/image/serverpage/image-id/513406i76EB2EC1F073AD83?v=v2)

![Image](https://community.fabric.microsoft.com/t5/image/serverpage/image-id/409453iC84346342E58DDF8?v=v2)

![Image](https://i.sstatic.net/nj0Iz.png)

Visual tipo **Línea**.

Ejes:

* X → Fecha (jerarquía Año-Mes)
* Y → Total Ventas

Permite:

* Análisis de tendencia
* Estacionalidad
* Comparativas interanuales

---

## 🔹 Gráfico categórico

![Image](https://community.fabric.microsoft.com/t5/image/serverpage/image-id/678356i3F26FE968543C506?v=v2)

![Image](https://zoomchartswebstorage.blob.core.windows.net/blog/20250602-151540-mceu-70592733281748877341419.png)

![Image](https://learn.microsoft.com/en-us/power-bi/create-reports/media/sample-store-sales/power-bi-select-category.png)

![Image](https://learn.microsoft.com/en-us/power-bi/create-reports/media/sample-sales-and-marketing/sales1.png)

Visual tipo:

* Barras
* Columnas
* Gráfico apilado

Ejemplo:

* Eje: Categoría
* Valor: Total Ventas

---

# 5️⃣ Construcción de un Dashboard

En Desktop → se construye un **Reporte**.

En Power BI Service → se crea un **Dashboard** anclando visualizaciones.

## Buen diseño

✔ Jerarquía visual clara
✔ KPI arriba
✔ Tendencias en centro
✔ Desglose abajo
✔ Filtros laterales

Conceptos clave:

* Segmentadores (Slicers)
* Drill-down
* Interacción entre gráficos
* Tooltips personalizados

---

# 6️⃣ Publicación conceptual

Desde Desktop:

**Publicar → Workspace**

En la nube:

* Compartir con usuarios
* Programar actualización
* Crear dashboard
* Configurar permisos

## Flujo profesional típico

1. Desktop → Modelado
2. Publicación
3. Gateway (si datos locales)
4. Actualización programada
5. Consumo por negocio

---

# 🧠 Resultado final esperado en la práctica

Deberíais ser capaces de:

* Importar un dataset
* Crear modelo relacional
* Escribir una medida en DAX
* Construir:

  * 1 KPI
  * 1 serie temporal
  * 1 gráfico categórico
* Diseñar un dashboard coherente
* Explicar el flujo de publicación

