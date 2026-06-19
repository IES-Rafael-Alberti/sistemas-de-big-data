---
output:
  pdf_document: default
  html_document: default
---
# UD4 - Documento 07
## Orquestación de pipelines con Apache Airflow

---

# 1. Por qué necesitamos orquestación

Hasta ahora hemos trabajado con:

- scripts de ingesta,
- procesos de limpieza,
- transformaciones con Spark,
- creación manual de dashboards.

En clase ejecutamos estos procesos manualmente.

En entornos reales esto no es viable.

Problemas de ejecución manual:

- olvidos,
- errores de orden,
- falta de control,
- ausencia de monitorización,
- dificultad para repetir procesos.

Aquí entra la orquestación.

---

# 2. Qué es la orquestación de datos

La orquestación consiste en:

- definir tareas,
- establecer dependencias,
- automatizar ejecuciones,
- monitorizar estados,
- gestionar errores.

No procesa datos.
Coordina procesos.

Airflow no sustituye a Spark.
Airflow no sustituye a pandas.
Airflow organiza el flujo.

---

# 3. Concepto clave - DAG

Airflow se basa en DAG.

DAG significa Directed Acyclic Graph.

- Directed: tiene dirección.
- Acyclic: no tiene ciclos.
- Graph: conjunto de tareas conectadas.

Un DAG representa un pipeline.

Ejemplo conceptual:

Descarga -> Limpieza -> Transformación Spark -> Carga BI

Cada bloque es una tarea.
Las flechas indican dependencias.

---

# 4. Componentes principales de Airflow

Scheduler  
Se encarga de programar las ejecuciones.

Webserver  
Interfaz para monitorizar tareas.

Executor  
Mecanismo que ejecuta tareas.

DAG  
Definición del flujo de trabajo.

Task  
Unidad mínima ejecutable.

---

# 5. Diferencia entre script y DAG

Script:

- Secuencia lineal.
- Ejecución manual o cron.
- Poco control de dependencias complejas.

DAG:

- Dependencias explícitas.
- Reintentos automáticos.
- Historial de ejecuciones.
- Visualización del flujo.

---

# 6. Scheduling

Airflow permite definir:

- ejecución diaria,
- ejecución horaria,
- ejecución manual,
- ejecución por eventos.

Esto permite automatizar pipelines completos.

Ejemplo:

Cada día a las 03:00:
- descargar datos,
- limpiar,
- procesar,
- actualizar dashboard.

---

# 7. Manejo de errores

Airflow permite:

- reintentos automáticos,
- registro de logs,
- estado de cada tarea,
- alertas si falla una etapa.

Esto es fundamental en entornos productivos.

---

# 8. Integración con lo visto en el módulo

Airflow puede orquestar:

- scripts Python de ingesta (UD2),
- procesos de calidad (UD2),
- trabajos Spark (UD3),
- actualización de datasets para BI (UD4),
- entrenamiento ML (UD5).

En el proyecto final puede convertirse en el pegamento del pipeline completo.

---

# 9. Arquitectura típica de pipeline completo

Fuente de datos
-> Ingesta
-> Limpieza
-> Integración
-> Procesamiento distribuido
-> Almacenamiento
-> Visualización
-> ML

Airflow coordina las flechas, no los bloques.

---

# 10. Cuándo usar Airflow

Es recomendable cuando:

- existen múltiples pasos dependientes,
- el proceso es recurrente,
- el volumen es alto,
- se necesita trazabilidad.

No es necesario cuando:

- el proceso es puntual,
- el flujo es simple y manual.

---

# 11. Limitaciones

Airflow no:

- procesa datos por sí mismo,
- reemplaza a Spark,
- sustituye a bases de datos.

Es una herramienta de coordinación.

---

# 12. Conexión con el proyecto integrador

En la UD6:

- Se exigirá diagrama del pipeline.
- Se valorará implementación con Airflow.
- Se evaluará comprensión de dependencias.

Si se implementa correctamente, mejora evaluación.

---

# 13. Conclusiones

La orquestación es el siguiente paso natural tras:

- Ingestar.
- Procesar.
- Visualizar.

Completa el ciclo de ingeniería de datos.

Airflow permite pasar de ejecuciones manuales a pipelines automatizados.

---

## Fin del documento