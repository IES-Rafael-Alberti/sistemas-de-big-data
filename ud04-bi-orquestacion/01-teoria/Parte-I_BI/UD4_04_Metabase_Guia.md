# UD4 - Documento 04
## Metabase - Guía de uso para Business Intelligence

---

## 1. Introducción a Metabase

Metabase es una herramienta de Business Intelligence orientada a:

- crear consultas de forma sencilla,
- construir gráficos sin escribir SQL obligatorio,
- diseñar dashboards de negocio.

Es adecuada para entornos docentes porque:

- es sencilla de instalar,
- tiene curva de aprendizaje baja,
- permite trabajar tanto con interfaz gráfica como con SQL.

En esta unidad será la herramienta principal para la creación de cuadros de mando.

---

## 2. Conexión a la base de datos

Una vez desplegado Metabase mediante contenedores, el primer paso es conectar la herramienta a la base de datos.

Pasos generales:

1. Acceder a Metabase desde el navegador.
2. Crear una cuenta de administrador.
3. Seleccionar "Add database".
4. Elegir el tipo de base de datos (PostgreSQL).
5. Introducir los datos de conexión:
   - Host
   - Puerto
   - Base de datos
   - Usuario
   - Contraseña
6. Guardar y comprobar la conexión.

Una vez conectada la base, Metabase detectará automáticamente las tablas disponibles.

---

## 3. Concepto de "Pregunta" en Metabase

En Metabase, una consulta se denomina "Question".

Una pregunta puede construirse:

- mediante interfaz gráfica,
- mediante SQL.

Las preguntas permiten:

- seleccionar columnas,
- aplicar filtros,
- agrupar,
- ordenar,
- agregar métricas.

---

## 4. Creación de una pregunta simple

Ejemplo:

Objetivo: calcular el total de ventas por mes.

Pasos generales:

1. Crear nueva pregunta.
2. Seleccionar tabla de hechos (por ejemplo, ventas).
3. Elegir columna fecha.
4. Agrupar por mes.
5. Agregar suma de importe.
6. Seleccionar tipo de visualización (gráfico de líneas).
7. Guardar la pregunta.

Es importante comprobar:

- que la agregación es correcta,
- que la dimensión temporal está bien configurada.

---

## 5. Filtros y segmentación

Las preguntas pueden incluir filtros como:

- rango de fechas,
- categoría de producto,
- región,
- segmento de cliente.

Los filtros permiten analizar subconjuntos de datos.

Es fundamental verificar que los filtros no alteran la granularidad original de forma incorrecta.

---

## 6. Visualizaciones

Metabase permite distintos tipos de visualización:

- tabla,
- gráfico de barras,
- gráfico de líneas,
- gráfico circular,
- indicador numérico.

La elección del gráfico debe depender del tipo de dato.

Ejemplos:

- evolución temporal -> gráfico de líneas,
- comparación de categorías -> barras,
- valor único destacado -> indicador numérico.

Evitar gráficos que no aporten información clara.

---

## 7. Creación de dashboards

Un dashboard integra varias preguntas.

Pasos generales:

1. Crear nuevo dashboard.
2. Añadir preguntas previamente guardadas.
3. Organizar los elementos.
4. Añadir filtros globales si es necesario.

Un dashboard debe:

- responder a un conjunto concreto de preguntas,
- tener coherencia visual,
- evitar sobrecarga de información.

---

## 8. Filtros globales

Metabase permite crear filtros globales que afectan a varias visualizaciones.

Ejemplo:

- filtro por rango de fechas que afecta a todos los gráficos.

Esto permite mayor interactividad y coherencia.

---

## 9. Permisos y publicación

En entornos profesionales se gestionan:

- permisos de acceso,
- edición de dashboards,
- visibilidad por roles.

En el contexto del módulo:

- se trabajará con un entorno simplificado,
- pero es importante conocer que existen estos mecanismos.

---

## 10. Errores comunes en Metabase

Errores frecuentes:

- no agrupar correctamente antes de sumar,
- mezclar columnas con distinta granularidad,
- crear demasiados gráficos sin objetivo claro,
- no revisar valores nulos.

La herramienta facilita la visualización, pero no corrige errores conceptuales.

---

## 11. Conexión con el proyecto integrador

En la UD6 será obligatorio:

- crear al menos un dashboard de negocio,
- justificar los KPI elegidos,
- explicar las decisiones tomadas.

Lo aprendido en Metabase servirá como base para ese proyecto.

---

## 12. Conclusiones

Metabase es una herramienta accesible para construir cuadros de mando.

Sin embargo, la calidad del dashboard depende:

- del modelo de datos,
- de la coherencia de las métricas,
- de la interpretación final.

La herramienta es solo el medio; la decisión es el objetivo.

---

## Fin del documento
