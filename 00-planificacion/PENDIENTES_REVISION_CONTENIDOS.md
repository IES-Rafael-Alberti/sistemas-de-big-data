# Pendientes de revisión de contenidos

## Cierre de la revisión actual

En esta pasada se ha trabajado principalmente sobre la forma del sitio público y sobre el contenido matemático-estadístico de UD1.

## Hecho

- Se sustituyeron los README internos de unidad por guías públicas para el alumnado en `docs/unidades/`.
- La navegación pública quedó orientada a teoría, prácticas, evaluación y recursos, sin mostrar inventarios internos de carpetas.
- Se excluyeron del sitio público materiales internos, docentes o archivados.
- Se activó MathJax para representar fórmulas matemáticas.
- Se amplió la base estadística de UD1 con fórmulas, ejemplos calculados, percentiles, cuartiles, IQR, outliers, correlación, colinealidad y métricas de calidad.
- Se añadió un ejemplo de estadística con Python y un notebook ejecutable en `ud01-introduccion-big-data/02-ejemplos/`.
- Se añadieron gráficas SVG para histograma, boxplot y scatter plot en UD1.
- Se revisó la redacción generada para usar español de España en los materiales.

## Pendiente importante

Hay que aplicar el mismo tipo de revisión al resto de unidades. UD1 ha servido como primera unidad corregida, pero no debe quedarse como caso aislado.

### UD2 — Almacenamiento e ingesta

- Revisar si la teoría explica los conceptos antes de usarlos en prácticas.
- Añadir ejemplos guiados con datos pequeños antes de pasar a pipelines completos.
- Comprobar que calidad, RGPD, formatos y costes tienen fórmulas, métricas o criterios operativos.
- Conectar teoría, práctica y recursos con enlaces explícitos.

### UD3 — Procesamiento distribuido

- Revisar si Spark, particionado, Parquet y streaming tienen explicación conceptual suficiente antes del laboratorio.
- Añadir diagramas o gráficas cuando se hable de rendimiento, particionado, latencia o throughput.
- Comprobar que los laboratorios tienen una progresión clara y no saltan pasos.

### UD4 — BI y orquestación

- Revisar que BI, modelado, dashboards y orquestación se expliquen con ejemplos visuales.
- Añadir criterios de diseño de dashboard con ejemplos correctos/incorrectos.
- Conectar pipelines, Airflow/MageAI y cuadros de mando con una ruta de aprendizaje clara.

### UD5 — Spark MLlib

- Revisar que ML distribuido no se presente como receta de código.
- Añadir explicación previa de métricas, features, entrenamiento, evaluación y errores comunes.
- Incluir notebooks o ejemplos ejecutables conectados con la teoría.

### UD6 — Proyecto integrador

- Revisar que el guion sea accionable para el alumnado.
- Añadir ejemplos de proyectos modelo, entregables esperados y criterios de calidad.
- Comprobar que las plantillas transversales están enlazadas desde cada fase.

## Criterio para las siguientes revisiones

Cada unidad debe responder a estas preguntas:

1. ¿La guía pública ayuda al alumnado a saber por dónde empezar?
2. ¿La teoría explica los conceptos antes de pedir que se apliquen?
3. ¿Hay ejemplos, fórmulas, diagramas, gráficas o código cuando el concepto lo necesita?
4. ¿Las prácticas enlazan con la teoría correspondiente?
5. ¿Las entregas y rúbricas están escritas para el alumnado, no para el profesor?
6. ¿El material usa español de España y evita giros regionales o tono conversacional excesivo?
7. ¿El sitio público evita material interno, archivado o docente?
