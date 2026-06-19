# Power BI Service (Web) - Demo práctica

Guía paso a paso para usar Power BI en la nube (app.powerbi.com). Ideal para Linux y entornos donde no se puede instalar Power BI Desktop.

---

## Requisitos previos

- Cuenta Microsoft (educativa o profesional)
- Acceso a internet
- Navegador web (Chrome, Edge, Firefox)

---

## 0️⃣ Acceso a Power BI Service

1. Abre el navegador y ve a: **app.powerbi.com**
2. Inicia sesión con tu cuenta Microsoft
3. Verás la página principal con el panel de navegación lateral

### Panel de navegación

- **Mi área de trabajo**: Espacio personal para tus informes y dashboards
- **Áreas de trabajo**: Espacios compartidos para colaboración
- **Explorar**: Acceder a contenido recomendado
- **Aplicaciones**: Ver aplicaciones publicadas

---

## 1️⃣ Importar datos (Crear modelo semántico)

Vamos a usar el **ejemplo financiero de Microsoft** para la práctica.

### Opción A: Usar datos de ejemplo de Microsoft

1. En la página principal, selecciona **Explorar** en el panel izquierdo
2. Busca "Ejemplo financiero" o "Financial sample"
3. Selecciona el conjunto de datos de ejemplo
4. Se abrirá automáticamente un informe con datos de ejemplo

### Opción B: Importar tu propio archivo Excel

1. En **Mi área de trabajo**, selecciona **Nuevo** → **Modelo semántico de elemento**

   ![Nuevo modelo semántico](https://learn.microsoft.com/es-es/power-bi/fundamentals/media/service-get-started/power-bi-new-mode.png)

2. Selecciona **Excel** como origen de datos

   ![Seleccionar Excel](https://learn.microsoft.com/es-es/power-bi/fundamentals/media/service-get-started/build-excel-reports.png)

3. Elige **Vincular al archivo** (recomendado) o **Cargar**

   > **Vincular**: El archivo permanece en OneDrive/SharePoint y se actualiza automáticamente
   > **Cargar**: El archivo se copia a Power BI

4. Selecciona tu archivo Excel y haz clic en **Siguiente**

5. Selecciona la hoja o tabla que contiene los datos

6. Haz clic en **Crear**

Power BI importará los datos y creará el modelo semántico.

---

## 2️⃣ Crear un informe

Desde el modelo semántico que has creado o abierto:

### Método 1: Crear informe desde cero

1. En el modelo semántico, selecciona **Crear informe**

   ![Crear informe](https://learn.microsoft.com/es-es/power-bi/fundamentals/media/service-get-started/power-bi-blank-page.png)

2. Se abre el **Editor de informes** con tres paneles:

   - **Panel Datos** (izquierda): Campos disponibles
   - **Panel Visualizaciones** (derecha): Tipos de gráficos
   - **Lienzo** (centro): Donde se crean las visualizaciones

### Método 2: Usar Q&A (Preguntas y respuestas)

Q&A te permite preguntar en lenguaje natural y Power BI genera automáticamente visualizaciones.

1. En el editor de informes, busca el cuadro **"Formular una pregunta"** en la barra superior

   ![Q&A en informe](https://learn.microsoft.com/es-es/power-bi/fundamentals/media/service-get-started/report-editor-qna-box.png)

2. Escribe una pregunta, por ejemplo:
   - "¿Cuál es el total de ventas?"
   - "Ventas por categoría"
   - "Beneficio por mes"

3. Q&A generará una visualización automática

4. Para guardarla en el informe, selecciona **Anclar objeto visual**

### Método 3: Crear visual manualmente

1. En el panel **Visualizaciones**, selecciona un tipo de gráfico (ej: gráfico de columnas)

2. En el panel **Datos**:
   - Arrastra un campo al área **Eje X** (ej: Categoría)
   - Arrastra un campo al área **Valores** (ej: Ventas)

3. Power BI creará la visualización automáticamente

### Ejemplo práctico: Crear un gráfico de ventas por categoría

1. Selecciona **Gráfico de columnas agrupadas** en Visualizaciones

2. En el panel Datos, busca el campo **Categoría** y márcalo (o arrástralo a Eje X)

3. Busca el campo **Ventas** y arrástralo a **Valores**

4. Verás el gráfico mostrar las ventas por cada categoría

---

## 3️⃣ Añadir más visualizaciones

Repite el proceso para crear diferentes tipos de visualizaciones:

| Tipo de visualización | Uso recomendado |
| --------------------- | --------------- |
| Tarjeta | Mostrar un solo valor (KPI) |
| Gráfico de líneas | Tendencias a lo largo del tiempo |
| Gráfico de barras | Comparaciones entre categorías |
| Gráfico circular | Distribución porcentual |
| Mapa | Datos geográficos |
| Tabla | Ver datos detallados |

### Configurar una visualización

1. Selecciona la visualización en el lienzo
2. En el panel Visualizaciones, usa las secciones:
   - **Eje X/Y**: Campos para los ejes
   - **Leyenda**: Categorías para colorear
   - **Filtros**: Aplicar filtros a esa visualización

---

## 4️⃣ Crear un Dashboard

Los dashboards son vistas resumidas con visualizaciones ancladas desde los informes.

### Desde un informe ya creado

1. Abre el informe que contains las visualizaciones que quieres incluir

2. Pasa el cursor sobre una visualización y selecciona el icono **Fijar objeto visual**

   ![Anclar visual](https://learn.microsoft.com/es-es/power-bi/fundamentals/media/service-get-started/power-bi-pin-report-visual.png)

3. Elige **Nuevo panel** o selecciona uno existente

4. Asigna un nombre al panel y haz clic en **Anclar**

### Crear panel desde Q&A

1. En el panel, selecciona **Hacer una pregunta sobre los datos**

   ![Q&A en dashboard](https://learn.microsoft.com/es-es/power-bi/fundamentals/media/service-get-started/dashboard-qna-box.png)

2. Escribe tu pregunta y Power BI mostrará una visualización

3. Selecciona **Anclar objeto visual** para añadirla al panel

---

## 5️⃣ Editar el Dashboard

Una vez creado el dashboard, puedes personalizarlo:

### Mover un icono

1. Selecciona el icono y arrástralo a la nueva posición

### Redimensionar un icono

1. Selecciona el icono
2. Arrastra la esquina inferior derecha para ajustar el tamaño

### Cambiar el título

1. Selecciona el icono
2. Haz clic en **Más opciones (...)** → **Editar detalles**
3. Cambia el campo **Título**
4. Selecciona **Aplicar**

### Eliminar un icono

1. Selecciona el icono
2. Haz clic en **Más opciones (...)** → **Eliminar**

---

## 6️⃣ Guardar y compartir

### Guardar el informe

1. En el editor de informes, selecciona **Archivo** → **Guardar**

2. Dale un nombre al informe

3. Se guardará en **Mi área de trabajo**

### Compartir el dashboard

1. Abre el dashboard

2. Selecciona **Compartir** en la barra superior

3. Introduce los correos de las personas con quienes compartir

4. Configura los permisos:
   - **Puede ver**: Solo ver el dashboard
   - **Puede editar**: Ver y modificar

5. Selecciona **Enviar**

---

## 7️⃣ Flujo de trabajo típico en Power BI Service

```
1. Importar datos (Excel, CSV, base de datos...)
       ↓
2. Crear modelo semántico
       ↓
3. Crear informe con visualizaciones
       ↓
4. Anclar visualizaciones a un dashboard
       ↓
5. Editar y organizar el dashboard
       ↓
6. Compartir con usuarios
       ↓
7. Programar actualización de datos (opcional)
```

---

## Diferencias clave: Desktop vs Service

| Característica | Power BI Desktop | Power BI Service |
| --------------- | ----------------- | ----------------- |
| Instalación | Requiere Windows | Solo navegador |
| Power Query | Completo | Limitado |
| Modelo de datos | Completo | Ver únicamente |
| DAX | Completo | No disponible |
| Publicación | Requiere Service | No aplica |
| Trabajo offline | Sí | No |

---

## Ejercicios propuestos

1. **Importar el ejemplo financiero** de Microsoft
2. **Crear un informe** con:
   - Un KPI (tarjeta) mostrando el total de ventas
   - Un gráfico de líneas mostrando ventas por fecha
   - Un gráfico de barras mostrando ventas por categoría
3. **Crear un dashboard** anclando las tres visualizaciones
4. **Editar el dashboard** reorganizando los iconos
5. **Compartir** el dashboard con un compañero

---

## Recursos adicionales

- Tutorial oficial de Microsoft: https://learn.microsoft.com/es-es/power-bi/fundamentals/service-get-started
- Ejemplo financiero de Microsoft: https://go.microsoft.com/fwlink/?LinkID=521962
- Vídeos de formación: https://www.youtube.com/@MicrosoftPowerBI
