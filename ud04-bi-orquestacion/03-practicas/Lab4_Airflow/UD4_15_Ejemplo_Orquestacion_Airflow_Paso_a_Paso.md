# UD4 - Ejemplo paso a paso de orquestacion con Airflow

## 1. Objetivo

Construir y ejecutar un pipeline minimo con Airflow que haga estas tareas en orden:

1. `descarga`
2. `limpieza`
3. `procesamiento`
4. `guardado`

Al final, el alumnado debe saber:

- como levantar Airflow en Docker,
- como definir un DAG,
- como lanzar una ejecucion manual,
- como revisar estados y logs.

---

## 2. Requisitos previos

Necesitas tener instalado:

- Docker
- Docker Compose

Comprobar instalacion:

```bash
docker --version
docker compose version
```

---

## 3. Estructura del laboratorio

Situate en la carpeta `Lab4_Airflow` y crea esta estructura:

```text
Lab4_Airflow/
  docker-compose-airflow-minimo.yml
  dags/
    pipeline_basico.py
  scripts/
    descarga.py
    limpieza.py
    procesamiento.py
    guardado.py
```

Comando rapido:

```bash
mkdir -p dags scripts
```

---

## 4. Crear scripts de ejemplo

Crea estos ficheros dentro de `scripts/`.

Archivo `scripts/descarga.py`:

```python
print("Descargando datos...")
```

Archivo `scripts/limpieza.py`:

```python
print("Limpiando datos...")
```

Archivo `scripts/procesamiento.py`:

```python
print("Procesando datos...")
```

Archivo `scripts/guardado.py`:

```python
print("Guardando resultados...")
```

---

## 5. Definir el DAG de orquestacion

Crea `dags/pipeline_basico.py` con el siguiente contenido:

```python
from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id="pipeline_basico",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
    tags=["ud4", "laboratorio"],
) as dag:
    descarga = BashOperator(
        task_id="descarga",
        bash_command="python /opt/airflow/scripts/descarga.py",
    )

    limpieza = BashOperator(
        task_id="limpieza",
        bash_command="python /opt/airflow/scripts/limpieza.py",
    )

    procesamiento = BashOperator(
        task_id="procesamiento",
        bash_command="python /opt/airflow/scripts/procesamiento.py",
    )

    guardado = BashOperator(
        task_id="guardado",
        bash_command="python /opt/airflow/scripts/guardado.py",
    )

    descarga >> limpieza >> procesamiento >> guardado
```

La linea final define las dependencias entre tareas.

---

## 6. Levantar Airflow

Desde `Lab4_Airflow`, ejecutar:

```bash
docker compose -f docker-compose-airflow-minimo.yml up -d
```

Comprobar que el contenedor esta levantado:

```bash
docker ps
```

---

## 7. Entrar a la interfaz web

1. Abre `http://localhost:8081`
2. Usuario: `admin`
3. Password: `admin`

Si no aparece a la primera, espera 20-40 segundos y recarga.

---

## 8. Ejecutar el DAG manualmente

1. Busca `pipeline_basico`.
2. Activa el DAG (interruptor).
3. Pulsa `Trigger DAG`.
4. Abre la vista `Graph`.
5. Verifica el flujo `descarga -> limpieza -> procesamiento -> guardado`.

---

## 9. Verificacion de resultados

Para cada tarea, revisa:

- estado (`success`, `failed`, `running`),
- hora de inicio/fin,
- logs de ejecucion.

En los logs deben aparecer los textos de los scripts:

- `Descargando datos...`
- `Limpiando datos...`
- `Procesando datos...`
- `Guardando resultados...`

---

## 10. Diagnostico rapido de errores

Si el DAG no aparece:

- comprueba que `pipeline_basico.py` esta dentro de `dags/`,
- revisa errores de sintaxis en el archivo,
- mira logs del contenedor:

```bash
docker logs airflow_lab --tail 100
```

Si una tarea falla:

- abre los logs de esa tarea en Airflow,
- comprueba la ruta del script en `bash_command`,
- verifica que el archivo existe dentro de `scripts/`.

---

## 11. Parar el entorno

Cuando termines:

```bash
docker compose -f docker-compose-airflow-minimo.yml down
```

---

## 12. Extension opcional

Como mejora, añade una rama paralela:

- `descarga` -> `limpieza_ventas`
- `descarga` -> `limpieza_clientes`
- ambas convergen en `procesamiento`

Asi practicas dependencias en paralelo y convergencia de tareas.
