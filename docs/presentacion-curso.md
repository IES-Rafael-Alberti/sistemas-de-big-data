# Presentación del curso: Sistemas de Big Data

> **Uso en el aula:** presentación inicial de 15-20 minutos. No se lee entera:
> se siguen los apartados de este guion y se deja el resto como documento de
> consulta para el alumnado.

## Guion breve de exposición

| Tiempo | Mensaje | Apoyo en esta página |
|---:|---|---|
| 0-3 min | Un sistema Big Data convierte datos dispersos en decisiones técnicas fiables; no consiste en hacer una gráfica ni en usar una herramienta de moda. | Qué vamos a aprender |
| 3-7 min | Recorreremos el flujo completo: fuentes, ingesta, almacenamiento, calidad, procesamiento y visualización. | Ruta del módulo |
| 7-10 min | Trabajaremos sobre todo con Python, DuckDB, Parquet y Spark; habrá prácticas individuales, por parejas y de equipo. | Forma de trabajo |
| 10-14 min | La calificación oficial es por RA/CE. Moodle organiza evidencias; las tareas cooperativas requieren contribución y defensa individual. | Cómo se evalúa |
| 14-17 min | La IA se puede usar, pero debe declararse, verificarse y poder explicarse. | Forma de trabajo |
| 17-20 min | El curso termina en un proyecto compartido con BDA y PIA, pero SBD evalúa arquitectura y pipeline de datos. | Proyecto integrador |

Frase de cierre antes de empezar la clase:

> Antes de aprender una herramienta, necesitamos saber qué problema de datos
> queremos resolver, qué calidad tienen esos datos y cómo podremos repetir y
> defender el proceso.

## Qué vamos a aprender

En Sistemas de Big Data aprenderás a convertir fuentes de datos heterogéneas en información técnica fiable y utilizable. El recorrido completo será:

```text
fuentes -> ingesta -> almacenamiento -> calidad -> procesamiento -> consulta y visualización
```

No basta con obtener una gráfica o ejecutar un notebook. Deberás justificar las decisiones técnicas, reproducir el pipeline, medir y mejorar la calidad de los datos, respetar la privacidad y explicar qué valor aportan los resultados.

## Ruta del módulo

| Unidad | Trabajo principal |
| --- | --- |
| UD1. Fundamentos, estadística y arquitectura | Problemas Big Data, estadística aplicada, EDA/calidad, modelado documental frente a analítico, almacenamiento y arquitectura Medallion. |
| UD2. Almacenamiento e ingesta | Fuentes de datos, formatos, Parquet, integración, calidad, RGPD y pipeline Medallion. |
| UD3. Procesamiento distribuido | Spark, PySpark, procesamiento por lotes y streaming, rendimiento y comparación de motores. |
| UD4. BI y orquestación | Dashboards técnicos, métricas del pipeline y automatización con Airflow. |
| UD5. Spark MLlib | Preparación de datos, pipelines de ML, métricas y valoración de modelos. |
| UD6. Proyecto integrador | Sistema de datos completo, documentación, defensa y coordinación con Big Data Aplicado y PIA. |

El calendario y los plazos concretos se publicarán en Moodle. Las ampliaciones que dependan de infraestructura externa, como Airbyte o AWS Academy, no sustituirán las prácticas principales realizadas con herramientas locales.

La estadística aplicada no es un añadido opcional: la necesitaremos para leer
distribuciones y gráficos, interpretar medidas, reconocer valores atípicos y
comparar la calidad del dataset antes y después de manipularlo. La trabajaremos
antes de pedir conclusiones de EDA, dashboards o modelos.

## Forma de trabajo

Trabajaremos con Python, DuckDB, Parquet, dlt y Spark/PySpark como ruta principal. También utilizaremos, según la unidad, Docker, Redpanda, Metabase, Superset y Airflow.

- Las prácticas deben ser reproducibles: código, configuración, datos de ejemplo y pasos de ejecución claros.
- Las transformaciones se documentan y no dependen de pasos manuales ocultos.
- La calidad se mide mediante métricas, no solo con una impresión subjetiva de los resultados.
- Los datos personales o identificables se detectan, minimizan, anonimizan o eliminan cuando corresponda.
- Git conserva el historial de trabajo, las decisiones y la contribución de cada integrante.
- El trabajo puede ser individual, por parejas o en equipo, según indique la actividad.

La IA generativa puede utilizarse como herramienta de apoyo, pero nunca reemplaza la comprensión. Si se usa para código, consultas, documentación, limpieza o depuración, se debe declarar la herramienta, el propósito, el resultado incorporado, las correcciones realizadas y la verificación aplicada. Ocultarla, copiar resultados sin revisarlos o no poder explicarlos impedirá acreditar las evidencias afectadas.

## Cómo se evalúa

La evaluación es continua, criterial e individual. Séneca calcula la calificación oficial a partir de los resultados de aprendizaje y sus criterios de evaluación; el total de Moodle solo organiza las evidencias y es informativo.

| Resultado de aprendizaje | Qué se acredita | Peso |
| --- | --- | ---: |
| RA1 | Integración, procesamiento y análisis de información; arquitectura, fuentes, planificación, coste y calidad. | 30 % |
| RA2 | Cuadros de mando y análisis de su impacto. | 20 % |
| RA3 | Gestión, almacenamiento, eficiencia, seguridad y tratamiento de grandes conjuntos de datos. | 25 % |
| RA4 | Herramientas Big Data, datos no estructurados, procesamiento y visualización. | 25 % |

Para superar el módulo debes acreditar los RA y CE correspondientes con evidencias suficientes. Estas evidencias incluirán prácticas, cuestionarios Moodle individuales, repositorios, informes técnicos, demostraciones y defensas.

Las tareas cooperativas aportan una evidencia de equipo, pero no acreditan automáticamente a cada integrante. El profesorado revisará la contribución localizable, la trazabilidad y la defensa individual. Podrá pedir explicaciones, comprobaciones o una modificación dirigida cuando sea necesario confirmar la autoría y la comprensión técnica.

## Entregas

Cada actividad de Moodle indicará el producto a entregar, su rúbrica, los RA/CE que recoge y el plazo. Una entrega técnica debe incluir lo necesario para revisarla: código, instrucciones, datos o muestras permitidas, resultados de pruebas, documentación y enlaces accesibles.

Antes de entregar, comprueba que:

1. El repositorio o los archivos están accesibles para el profesorado.
2. El pipeline puede ejecutarse siguiendo el `README` sin depender de pasos privados o manuales.
3. Los datos y secretos no vulneran privacidad, licencias o seguridad.
4. Las decisiones de arquitectura, calidad y transformación se pueden localizar y explicar.
5. Si usaste IA, la declaración está actualizada y el resultado ha sido verificado.

Los plazos de Moodle forman parte del procedimiento de evaluación. Comunica cualquier incidencia técnica antes de su vencimiento y conserva evidencias de ella. La recuperación se centrará en los RA y CE que sigan pendientes, sin obligar a repetir lo ya acreditado.

## Proyecto integrador

La UD6 desarrolla un único proyecto final compartido con **Big Data Aplicado (BDA)** y **Programación de la IA (PIA)**. No son tres proyectos distintos, pero cada módulo evalúa sus propias evidencias. En SBD se valoran la arquitectura y el pipeline de datos; el informe de negocio es propio de BDA y el modelo de IA, cuando exista, corresponde a PIA.

El grupo, normalmente de 3 o 4 personas, construirá un sistema Big Data mínimo pero completo usando al menos dos fuentes de datos. La secuencia será:

| Fase | Entregable SBD mínimo |
| --- | --- |
| Definición | Problema, fuentes, alcance, arquitectura Medallion inicial y planificación. |
| Ingesta | Script reproducible, capa Bronze en Parquet, reporte de calidad inicial y diagrama actualizado. |
| Calidad y procesamiento | Transformaciones Silver y Gold, métricas antes/después, linaje, idempotencia y checklist RGPD. |
| Dashboard técnico | Visualizaciones que expliquen volumen, calidad, latencia, errores o estado del pipeline. |
| Cierre y defensa | Repositorio completo, README, memoria técnica, declaración de IA y presentación. |

El dashboard técnico de SBD no equivale a un dashboard de negocio: debe permitir comprender la salud y el funcionamiento del pipeline. El proyecto debe poder revisarse aunque el modelo de PIA o el análisis de BDA no estén presentes.

En la defensa, cada integrante debe poder explicar el flujo de datos, las decisiones de arquitectura, las reglas de calidad, las transformaciones, las métricas y su aportación concreta. Si una parte esencial no puede explicarse o verificarse, no se considerará acreditada aunque el sistema funcione.

## Recursos

- [Ruta del curso](index.md).
- [Plantilla de planificación técnica](plantillas/plantilla_planificacion_tecnica.md).
- [Checklist de calidad, RGPD y seguridad](plantillas/plantilla_checklist_calidad_rgpd.md).
- [Declaración de uso de IA](plantillas/plantilla_declaracion_uso_ia.md).
- [Guión completo del proyecto integrador](ud06-proyecto/guion_proyecto.md).
- [Rúbrica común por RA/CE](plantillas/rubrica_comun_SBD_por_RA_CE.md).
