# Power BI Desktop - Guía práctica

Guía completa para usar Power BI Desktop, la aplicación de Windows para crear informes y modelos de datos de Business Intelligence.

---

## Requisitos del sistema

- **Sistema operativo**: Windows 10 o Windows 11
- **Memoria RAM**: Mínimo 4 GB (recomendado 8 GB)
- **Espacio en disco**: Al menos 2.5 GB disponible
- **Resolución de pantalla**: 1280 × 720 o superior

> **Nota**: Power BI Desktop no tiene versión nativa para Linux. Si usas Linux, considera usar Power BI Service (versión web) o una máquina virtual con Windows.

---

## 0️⃣ Instalación

### Método recomendado: Microsoft Store

1. Abre el **Microsoft Store** en Windows
2. Busca "Power BI Desktop"
3. Selecciona **Instalar**
4. La aplicación se actualizará automáticamente

### Método alternativo: Descarga directa

1. Ve a: https://www.microsoft.com/es-es/power-bi/power-bi-desktop
2. Selecciona **Descargar gratis**
3. Ejecuta el instalador descargado
4. Sigue los pasos del asistente de instalación

### Iniciar Power BI Desktop

1. Busca "Power BI" en el menú Inicio de Windows
2. Selecciona **Power BI Desktop**
3. La aplicación se abrirá mostrando la pantalla de bienvenida

---

## 1️⃣ Interfaz de Power BI Desktop

Al abrir Power BI Desktop, verás las siguientes áreas principales:

### Cinta de opciones (parte superior)

- **Inicio**: Funciones principales (Obtener datos, transformaciones, visualizar)
- **Insertar**: Insertar elementos adicionales en el informe
- **Modelado**: Crear tablas, relaciones y medidas DAX
- **Ver**: Cambiar vistas y diseño
- **Ayuda**: Documentación y recursos

### Panel Campos (derecha)

Muestra todas las tablas y campos del modelo de datos. Desde aquí puedes arrastrar campos para crear visualizaciones.

### Lienzo de informe (centro)

Área de trabajo donde se crean y organizan las visualizaciones.

### Panel Visualizaciones (derecha)

Permite seleccionar el tipo de visualización y configurar sus opciones.

---

## 2️⃣ Importar datos

### Fuentes de datos compatibles

- Excel (.xlsx, .xlsb)
- CSV / Text
- Bases de datos (SQL Server, MySQL, PostgreSQL, etc.)
- Web (páginas web, APIs)
- Azure, SharePoint, OneDrive

### Paso a paso: Importar un archivo Excel

1. Selecciona **Obtener datos** en la cinta Inicio

   ![Obtener datos](https://learn.microsoft.com/es-es/power-bi/fundamentals/media/desktop-getting-started/desktop-get-data.png)

2. Selecciona **Excel** en la lista de fuentes de datos

3. Navega hasta tu archivo Excel y selecciónalo

4. En el **Navegador**, marca las hojas o tablas que quieres importar

   ![Navegador](https://learn.microsoft.com/es-es/power-bi/fundamentals/media/desktop-getting-started/desktop-navigator.png)

5. Selecciona **Cargar** para importar directamente, o **Transformar datos** para editar antes de cargar

### Ejercicio: Importar el ejemplo financiero de Microsoft

1. Descarga el archivo: https://go.microsoft.com/fwlink/?LinkID=521962
2. Sigue los pasos anteriores para importarlo a Power BI Desktop

---

## 3️⃣ Transformar datos con Power Query

Power Query es una herramienta de transformación de datos integrada en Power BI.

### Abrir el Editor de Power Query

1. Selecciona **Transformar datos** en la cinta Inicio

   ![Transformar datos](https://learn.microsoft.com/es-es/power-bi/transform-model/media/desktop-query-overview/query-editor.png)

### Transformaciones comunes

#### Cambiar tipo de datos

1. Haz clic en el icono de tipo de datos en el encabezado de columna
2. Selecciona el tipo apropiado:
   - **Texto**: Para valores de texto
   - **Número entero** / **Número decimal**: Para valores numéricos
   - **Fecha** / **Fecha y hora**: Para fechas

#### Eliminar columnas

1. Selecciona las columnas que no necesitas (mantén Ctrl para varias)
2. Haz clic derecho y selecciona **Eliminar columnas**

#### Filtrar filas

1. Haz clic en la flecha del encabezado de la columna
2. Desmarca los valores que quieres excluir
3. Opcionalmente, usa filtros de texto (comienza con, contiene, etc.)

#### Renombrar columnas

1. Haz clic derecho sobre el nombre de la columna
2. Selecciona **Cambiar nombre**
3. Escribe el nuevo nombre

#### Crear columna personalizada

1. Selecciona **Columna personalizada** en la pestaña Agregar columna
2. Escribe la fórmula en el editor

   Ejemplo: `=[Ventas] * 0.21` para calcular IVA

### Aplicar cambios

1. Una vez realizadas las transformaciones, selecciona **Cerrar y aplicar**

   ![Cerrar y aplicar](https://learn.microsoft.com/es-es/power-bi/transform-model/media/desktop-query-overview/close-apply.png)

2. Los datos se cargarán en el modelo de Power BI

---

## 4️⃣ Modelo de datos

### Vista Modelo

Para ver el modelo de datos:

1. Selecciona el icono **Modelo** en el panel izquierdo

   ![Vista Modelo](https://learn.microsoft.com/es-es/power-bi/transform-model/media/desktop-relationship-view/model-view-01.png)

### Conceptos clave

#### Tabla de hechos (Fact Table)

Contiene los datos cuantitativos que se van a analizar (ventas, unidades, etc.).

#### Tablas de dimensiones (Dim Tables)

Contienen atributos descriptivos (fechas, productos, clientes, etc.).

#### Relaciones

Conectan las tablas de hechos con las dimensiones. La mayoría de relaciones son de **uno a muchos** (1:N).

   - Un lado: Tabla de dimensiones (clave única)
   - Varios lados: Tabla de hechos (puede tener valores repetidos)

### Crear una relación

1. Arrastra un campo desde una tabla hasta otra en la vista Modelo

   O

2. Selecciona **Administrar relaciones** en la cinta Modelado

3. Selecciona **Nueva relación**

4. Configura:
   - Tabla 1 y columna
   - Tabla 2 y columna
   - Cardinalidad (normalmente uno a varios)

5. Selecciona **Aceptar**

### Esquema en estrella

El modelo ideal para Business Intelligence:

```
        DimFecha
           |
     FactVentas
      /    |    \
DimProducto DimCliente DimTienda
```

### Ejercicio: Crear el modelo

1. Importa el ejemplo financiero
2. Ve a Vista Modelo
3. Crea las relaciones necesarias:
   - Fecha → FactVentas
   - Producto → FactVentas
   - Categoría → FactVentas

---

## 5️⃣ Medidas DAX

DAX (Data Analysis Expressions) es el lenguaje de fórmulas de Power BI para crear cálculos.

### Diferencia entre columnas calculadas y medidas

| Característica | Columna calculada | Medida |
| --------------- | ----------------- | -------- |
| Cuándo se evalúa | Fila a fila | En contexto de filtro |
| Se almacena en el modelo | Sí | No |
| Se recalcula | Solo al actualizar | Cada vez que se usa |

### Crear una medida

1. Ve a la **Vista de datos** (icono de tabla en el panel izquierdo)

2. En el panel Campos, haz clic derecho sobre la tabla y selecciona **Nueva medida**

   ![Nueva medida](https://learn.microsoft.com/es-es/power-bi/transform-model/media/desktop-relationships-understand/desktop-new-measure.png)

3. En la barra de fórmulas, escribe la expresión DAX

   ```DAX
   Total Ventas = SUM(FactVentas[Ventas])
   ```

4. Presiona Enter

### Medidas básicas

#### SUMA

```DAX
Total Ventas = SUM(Tabla[Columna])
```

#### CONTAR

```DAX
Numero Registros = COUNT(Tabla[Columna])
```

```DAX
Numero Registros (sin blancos) = COUNTA(Tabla[Columna])
```

#### PROMEDIO

```DAX
Promedio Ventas = AVERAGE(Tabla[Columna])
```

#### CALCULATE (con filtros)

```DAX
Ventas 2024 = CALCULATE(SUM(Ventas[Importe]), Ventas[Año] = 2024)
```

### Medidas rápidas

Power BI puede crear medidas automáticamente:

1. Haz clic derecho sobre un campo numérico
2. Selecciona **Crear medida rápida**
3. Elige el cálculo que necesitas
4. Configura los parámetros

### Ejercicio: Crear medidas

1. Crea las siguientes medidas:
   - Total de Ventas
   - Total de Unidades
   - Promedio de Ventas
   - Beneficio (Ventas - Coste)

---

## 6️⃣ Crear visualizaciones

### Tipos de visualizaciones disponibles

| Icono | Tipo | Uso recomendado |
|-------|------| ----------------|
| ![Tarjeta](https://learn.microsoft.com/es-es/power-bi/visuals/media/card-formatting/power-bi-kpi-template.png) | Tarjeta | Mostrar un solo valor (KPI) |
| ![Tabla](https://learn.microsoft.com/es-es/power-bi/visuals/media/power-bi-visualization-tables/power-bi-table-icon.png) | Matriz | Tablas con totales |
| ![Gráfico barras](https://learn.microsoft.com/es-es/power-bi/visuals/media/power-bi-visualization-bar-chart/power-bi-bar-chart-icon.png) | Gráfico de barras | Comparaciones horizontales |
| ![Gráfico columnas](https://learn.microsoft.com/es-es/power-bi/visuals/media/power-bi-visualization-column-chart/power-bi-column-chart-icon.png) | Gráfico de columnas | Comparaciones verticales |
| ![Gráfico líneas](https://learn.microsoft.com/es-es/power-bi/visuals/media/power-bi-visualization-line-chart/power-bi-line-chart-icon.png) | Gráfico de líneas | Tendencias temporales |
| ![Gráfico circular](https://learn.microsoft.com/es-es/power-bi/visuals/media/power-bi-visualization-pie-chart/power-bi-pie-chart-icon.png) | Gráfico circular | Distribución porcentual |
| ![Mapa](https://learn.microsoft.com/es-es/power-bi/visuals/media/power-bi-visualization-map/power-bi-map-icon.png) | Mapa | Datos geográficos |
| ![KPI](https://learn.microsoft.com/es-es/power-bi/visuals/media/power-bi-visualization-kpi/power-bi-kpi-template.png) | KPI | Indicadores con objetivo |
| ![Segmentador](https://learn.microsoft.com/es-es/power-bi/visuals/media/slicer-visual-types/power-bi-slicer-icon.png) | Segmentador | Filtros interactivos |

### Crear una visualización

1. En el panel Visualizaciones, selecciona el tipo de gráfico

2. Arrastra campos desde el panel Campos:
   - **Eje X** / **Eje Y**: Datos para los ejes
   - **Leyenda**: Categorías para colorear
   - **Valores**: Datos a agregar
   - **Filtros**: Filtrar la visualización

### Ejemplo: Crear un KPI

1. Selecciona el icono **KPI** en Visualizaciones

2. Configura:
   - **Indicador**: Arrastra la medida "Total Ventas"
   - **Meta del objetivo**: Arrastra o escribe un valor objetivo
   - **Dirección del objetivo**: Mayor es mejor / Menor es mejor

3. El KPI mostrará el valor, el objetivo y el estado (rojo/amarillo/verde)

### Ejemplo: Crear un gráfico de líneas

1. Selecciona el icono **Gráfico de líneas**

2. Configura:
   - **Eje X**: Campo de fecha (o jerarquía de fecha)
   - **Eje Y**: Medida "Total Ventas"

3. Power BI creará automáticamente la tendencia temporal

### Formato de visualizaciones

Para acceder a las opciones de formato:

1. Selecciona la visualización
2. Haz clic en el icono de **rodillo de pintar** en el panel Visualizaciones

Opciones de formato comunes:

- **Título**: Cambiar texto, tamaño, color
- **Colores de datos**: Personalizar colores
- **Ejes**: Formatear ejes X e Y
- **Leyenda**: Posición y formato
- **Etiquetas de datos**: Mostrar valores sobre las barras

---

## 7️⃣ Construir un informe

Un informe puede tener varias páginas, cada una con múltiples visualizaciones.

### Agregar una nueva página

1. Haz clic en el icono **+** en la barra de páginas (parte inferior)

   ![Nueva página](https://learn.microsoft.com/es-es/power-bi/create-reports/media/service-add-page-reports/power-bi-add-page.png)

2. La nueva página aparecerá en la lista de páginas

### Diseñar el layout

Recomendación para un dashboard típico:

```
+------------------------------------------+
|  KPI PRINCIPAL (Tarjeta grande)          |
+------------------------------------------+
|  Gráfico de líneas (tendencia)           |
+------------------------------------------+
|  Gráfico de barras  |  Gráfico circular   |
+------------------------------------------+
|  Segmentadores (filtros)                 |
+------------------------------------------+
```

### Segmentadores (Slicers)

Los segmentadores permiten filtrar todas las visualizaciones de la página:

1. Selecciona el icono **Segmentador** en Visualizaciones

2. Arrastra el campo por el que quieres filtrar

3. Configura el tipo:
   - **Lista**: Casillas de verificación
   - **Entre rango**: Rango de fechas o números

### Interacciones entre visualizaciones

Por defecto, al hacer clic en una visualización se filtran las demás:

1. Selecciona una visualización
2. Ve a **Formato** → **Interacciones**
3. Configura qué interactúa con qué

---

## 8️⃣ Guardar y publicar

### Guardar localmente

1. Selecciona **Archivo** → **Guardar**

2. Elige la ubicación y el nombre del archivo

3. El archivo se guardará con extensión .pbix

### Publicar en Power BI Service

1. Selecciona **Publicar** en la cinta Inicio

   ![Publicar](https://learn.microsoft.com/es-es/power-bi/fundamentals/media/desktop-getting-started/desktop-publish.png)

2. Inicia sesión en tu cuenta de Power BI si se pide

3. Selecciona el **Área de trabajo** de destino

4. Haz clic en **Seleccionar**

5. El informe se subirá a Power BI Service

### Publicar en Web (opcional)

Para compartir sin cuenta de Power BI:

1. Archivo → Publicar en la Web
2. Copia el código de inserción generado
3. Comparte el enlace o inserta el código en una página web

---

## 9️⃣ Flujo de trabajo típico

```
1. Obtener datos (Excel, CSV, BD...)
       ↓
2. Transformar datos (Power Query)
       ↓
3. Crear modelo de datos (relaciones)
       ↓
4. Crear medidas (DAX)
       ↓
5. Crear visualizaciones
       ↓
6. Diseñar informe (múltiples páginas)
       ↓
7. Guardar archivo .pbix
       ↓
8. Publicar en Power BI Service
```

---

## Ejercicios propuestos

### Ejercicio 1: Primeros pasos

1. Instala Power BI Desktop
2. Descarga el ejemplo financiero de Microsoft
3. Impórtalo a Power BI Desktop

### Ejercicio 2: Transformar datos

1. Abre Power Query
2. Cambia los tipos de datos:
   - Fecha → Fecha
   - Ventas → Número decimal
3. Renombra las columnas a español
4. Cierra y aplica

### Ejercicio 3: Crear modelo

1. Ve a Vista Modelo
2. Crea las relaciones necesarias
3. Dibuja el esquema en estrella

### Ejercicio 4: Medidas DAX

1. Crea las siguientes medidas:
   - Total Ventas
   - Total Unidades
   - Media Ventas
   - Beneficio

### Ejercicio 5: Visualizaciones

Crea un informe con:

- Página 1: Dashboard principal
  - Tarjeta con Total Ventas
  - Gráfico de líneas (ventas por fecha)
  - Gráfico de barras (ventas por categoría)
  - Segmentador por año

- Página 2: Detalles
  - Tabla con todos los datos
  - Gráfico circular (distribución por región)

### Ejercicio 6: Publicar

1. Guarda el archivo
2. Publica en Power BI Service
3. Comparte el enlace con un compañero

---

## Atajos de teclado útiles

| Atajo | Función |
|-------| --------|
| Ctrl + S | Guardar |
| Ctrl + Z | Deshacer |
| Ctrl + Y | Rehacer |
| Ctrl + D | Duplicar página |
| Ctrl + + | Zoom más |
| Ctrl + - | Zoom menos |
| F5 | Actualizar vista |
| Eliminar | Eliminar visual seleccionado |

---

## Solución de problemas

### El archivo no se carga

- Verifica que el archivo Excel no esté abierto en otra aplicación
- Comprueba que las hojas tengan datos (no estén vacías)

### Las relaciones no funcionan

- Verifica que las claves tengan valores únicos en la tabla de dimensiones
- Evita relaciones bidireccionales a menos que sea necesario

### Las medidas no funcionan

- Comprueba la sintaxis de la fórmula DAX
- Asegúrate de usar los nombres correctos de tablas y columnas

---

## Recursos adicionales

- Documentación oficial: https://learn.microsoft.com/es-es/power-bi/fundamentals/desktop-getting-started
- Referencia DAX: https://learn.microsoft.com/es-es/dax/
- Tutoriales en vídeo: https://www.youtube.com/@MicrosoftPowerBI
- Comunidad: https://community.fabric.microsoft.com/t5/Power-BI-Community/ct-p/powerbi
