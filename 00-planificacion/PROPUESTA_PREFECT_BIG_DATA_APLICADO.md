# Propuesta — Prefect en Big Data Aplicado

Se propone evaluar **Prefect** como práctica de orquestación aplicada para Big Data Aplicado. No sustituye ni modifica Airflow en Sistemas de Big Data: Airflow continúa como la herramienta evaluable de orquestación técnica en UD4.

## Siguiente paso

Consultar esta propuesta con el profesorado de Big Data Aplicado. Solo si valida el encaje curricular y operativo se autorizará un piloto corto y autocontenido antes de incorporarlo a la programación.

## Por qué Prefect

| Criterio | Encaje en Big Data Aplicado |
| --- | --- |
| Python-first | Los flujos y tareas se definen en Python, reutilizando el lenguaje ya empleado en los pipelines del alumnado. |
| Ejecución aplicada | Permite coordinar ingesta, transformación, validación, publicación y notificación como una solución reproducible. |
| Observabilidad | La interfaz muestra ejecuciones, estados, dependencias y fallos; encaja con la explotación y la estabilidad de servicios. |
| Despliegue local | Prefect OSS puede ejecutarse con un servidor local o mediante Docker, sin depender de una plataforma gestionada. |

## Alcance del piloto

Un flujo de una sesión que orqueste un caso ya conocido:

```text
CSV/API → validación → transformación a Parquet → carga/consulta en DuckDB o Postgres → informe de ejecución
```

El alumnado debe implementar un `flow` con tareas separadas, dependencias visibles, reintento ante un fallo controlado y una evidencia de ejecución en la interfaz.

## Encaje curricular

| Módulo | Papel de la herramienta |
| --- | --- |
| Sistemas de Big Data | Airflow: DAG, dependencias, planificación y orquestación técnica de un pipeline. |
| Big Data Aplicado | Prefect: ejecución operativa de una solución, observabilidad, recuperación de fallos y evidencia de servicio. |

La separación evita repetir la misma práctica: SBD enseña el sistema y el criterio de orquestación; Big Data Aplicado usa el flujo para entregar y operar una solución de datos.

## No incluido

- Sustituir Airflow en SBD.
- Migrar materiales o prácticas existentes.
- Introducir Prefect Cloud como requisito.
- Añadir Dagster o Kestra en paralelo al piloto.

## Validación antes de adoptar

- [ ] El entorno del aula puede iniciar Prefect OSS localmente o con Docker sin cuentas externas.
- [ ] El flujo se completa en una sesión y se recupera de un fallo controlado.
- [ ] La interfaz aporta una evidencia docente más clara que ejecutar scripts sueltos.
- [ ] No duplica los resultados de aprendizaje ni la evaluación de Airflow en SBD.
- [ ] Se documentan versión, requisitos y plan de contingencia antes de convertirlo en actividad evaluable.

## Decisión posterior

Si el piloto supera la validación, se diseñará una única práctica evaluable para Big Data Aplicado. Si no aporta una mejora clara frente a Python + Docker + Airflow, no se incorporará otra herramienta de orquestación.

## Referencias

- [Quickstart de Prefect](https://docs.prefect.io/v3/get-started/quickstart)
- [Servidor Prefect autoalojado con Docker Compose](https://docs.prefect.io/v3/how-to-guides/self-hosted/docker-compose)
