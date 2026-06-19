---
output:
  pdf_document: default
  html_document: default
---
# Unidad Didáctica - Pipelines y Orquestación de Datos
## Arquitectura, Automatización y Coordinación de procesos

---

# 1. Introducción

En ingeniería de datos no basta con:

- ingerir datos,
- transformarlos,
- visualizarlos.

Es necesario coordinar todo el flujo.

Esta unidad aborda el concepto de pipeline automatizado y su orquestación mediante Apache Airflow.

---

# 2. Qué es un pipeline de datos

Un pipeline es una secuencia estructurada de procesos que transforma datos desde su origen hasta su consumo final.

Fases típicas:

1. Ingesta
2. Limpieza
3. Transformación
4. Integración
5. Procesamiento
6. Almacenamiento
7. Visualización
8. Analítica avanzada

Un pipeline puede ser:

- manual,
- programado,
- automatizado,
- monitorizado.

---

# 3. Orquestación frente a ejecución

Ejecución manual:

- Scripts independientes.
- Orden decidido por el usuario.
- Sin control centralizado.

Orquestación:

- Definición formal del flujo.
- Dependencias explícitas.
- Reintentos automáticos.
- Monitorización centralizada.

La orquestación no sustituye el procesamiento.
Lo coordina.

---

# 4. Apache Airflow - Arquitectura interna

Componentes principales:

Scheduler  
Programa ejecuciones.

Webserver  
Interfaz gráfica de control.

Executor  
Motor que ejecuta tareas.

Metadata Database  
Almacena estados y configuración.

DAG  
Definición del flujo.

Task  
Unidad ejecutable.

---

# 5. Tipos de ejecutores

SequentialExecutor  
Ejecución secuencial. Adecuado para entorno educativo.

LocalExecutor  
Ejecución paralela en una sola máquina.

CeleryExecutor  
Distribuido con cola de mensajes.

KubernetesExecutor  
Ejecución en contenedores dinámicos.

En esta unidad se utilizará SequentialExecutor.

---

# 6. Estructura de un DAG profesional

Un DAG debe:

- Tener descripción clara.
- Definir start_date coherente.
- Definir schedule.
- Evitar ciclos.
- Incluir manejo básico de errores.

Buenas prácticas:

- Modularizar tareas.
- No incluir lógica compleja en el DAG.
- Usar scripts externos.

---

# 7. Scheduling y dependencia temporal

Airflow permite:

- Ejecución diaria.
- Ejecución horaria.
- Ejecución manual.
- Ejecución condicional.

Es importante entender:

- start_date
- catchup
- schedule_interval

Errores comunes:

- Definir fechas futuras.
- No desactivar catchup cuando no es necesario.

---

# 8. Manejo de errores y reintentos

Cada tarea puede definir:

- número de reintentos,
- tiempo entre reintentos,
- comportamiento ante fallo.

Esto permite robustez en pipelines reales.

---

# 9. Integración con Spark

Airflow puede lanzar:

- spark-submit
- scripts PySpark
- tareas que ejecuten notebooks

No ejecuta Spark directamente.
Coordina su ejecución.

---

# 10. Integración con ML

Airflow puede orquestar:

- entrenamiento periódico,
- recálculo de modelos,
- evaluación automática,
- actualización de resultados.

En entornos reales esto es habitual.

---

# 11. Monitorización

Airflow permite:

- visualizar estado de tareas,
- revisar logs,
- identificar cuellos de botella,
- analizar tiempos de ejecución.

Esto es clave en sistemas de producción.

---

# 12. Buenas prácticas profesionales

- No mezclar transformaciones complejas dentro del DAG.
- Versionar los DAG.
- Documentar dependencias.
- Mantener coherencia en nombres de tareas.
- Separar entornos desarrollo y producción.

---

# 13. Relación con el proyecto integrador

En el proyecto final el alumnado deberá:

- Diseñar el pipeline completo.
- Representarlo como DAG.
- Justificar dependencias.
- Orquestación del pipeline con Airflow.

La comprensión de la orquestación es evaluable aunque no se implemente completamente.

---

# 14. Limitaciones de Airflow

Airflow no es:

- Motor ETL completo.
- Sistema de streaming.
- Procesador de datos.

Es un coordinador.

---

# 15. Conclusiones

La orquestación completa el ciclo de ingeniería de datos.

Sin orquestación:

- No hay automatización.
- No hay trazabilidad.
- No hay gestión robusta de errores.

Con Airflow se pasa de ejecuciones manuales a pipelines gestionados.

---

## Fin de la unidad

