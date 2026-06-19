---
output:
  pdf_document: 
    latex_engine: xelatex
    toc: true
    number_sections: true
  html_document: default
---
# Manual de Creación de DAGs en Apache Airflow


## 1. ¿Qué es un DAG?

DAG significa **Directed Acyclic Graph** (Grafo Acíclico Dirigido).

Es un conjunto de tareas con:
- **Directed**: las tareas tienen dirección (A → B).
- **Acyclic**: no hay bucles (A no puede depender de A).
- **Graph**: representa un flujo de trabajo completo.

Un DAG define:

- qué tareas ejecutar,
- en qué orden,
- con qué frecuencia,
- cómo manejar errores.

---

## 2. Estructura básica de un DAG

Todo DAG es un fichero Python ubicado en la carpeta `dags/`.

Estructura mínima:

```python
from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id="mi_primer_dag",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
) as dag:
    
    tarea1 = BashOperator(
        task_id="tarea_ejemplo",
        bash_command="echo 'Hola Airflow'",
    )
```

---

## 3. Parámetros principales del DAG

### 3.1. `dag_id` (obligatorio)
Identificador único del DAG.

```python
dag_id="pipeline_ventas"
```

Debe ser:
- único en toda la instalación,
- descriptivo,
- sin espacios (usar guiones bajos).

### 3.2. `start_date` (obligatorio)
Fecha desde la cual el DAG es válido.

```python
from datetime import datetime
start_date=datetime(2024, 1, 1)
```

No ejecuta tareas anteriores a esta fecha.

### 3.3. `schedule` (antes `schedule_interval`)
Frecuencia de ejecución.

Valores comunes:

```python
schedule=None              # ejecución manual
schedule="@daily"          # diario a medianoche
schedule="@hourly"         # cada hora
schedule="0 3 * * *"       # cada día a las 03:00 (cron)
schedule="*/15 * * * *"    # cada 15 minutos
```

Expresiones cron:

```
┌─── minuto (0-59)
│ ┌─── hora (0-23)
│ │ ┌─── día del mes (1-31)
│ │ │ ┌─── mes (1-12)
│ │ │ │ ┌─── día de la semana (0-6, domingo=0)
│ │ │ │ │
* * * * *
```

### 3.4. `catchup`

Si `True`, ejecuta todas las ejecuciones pasadas desde `start_date`.

```python
catchup=False  # recomendado para evitar ejecuciones históricas
```

### 3.5. `tags`
Etiquetas para organizar DAGs.

```python
tags=["produccion", "ventas", "diario"]
```

### 3.6. `default_args`

Argumentos por defecto para todas las tareas.

```python
from datetime import timedelta

default_args = {
    "owner": "data_team",
    "retries": 3,
    "retry_delay": timedelta(minutes=5),
    "email_on_failure": True,
    "email": ["admin@empresa.com"],
}

with DAG(
    dag_id="pipeline_con_defaults",
    default_args=default_args,
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
) as dag:
    # ...
```

---

## 4. Tipos de operadores

### 4.1. BashOperator

Ejecuta comandos de shell.

```python
from airflow.operators.bash import BashOperator

tarea_bash = BashOperator(
    task_id="ejecutar_script",
    bash_command="python /opt/airflow/scripts/procesar.py",
)
```

Ejemplos:

```python
# Comando simple
BashOperator(
    task_id="listar_archivos",
    bash_command="ls -la /data",
)

# Múltiples comandos
BashOperator(
    task_id="pipeline_shell",
    bash_command="cd /data && python extraer.py && python transformar.py",
)
```

### 4.2. PythonOperator

Ejecuta funciones Python.

```python
from airflow.operators.python import PythonOperator

def mi_funcion():
    print("Ejecutando tarea Python")
    return "Resultado OK"

tarea_python = PythonOperator(
    task_id="procesar_datos",
    python_callable=mi_funcion,
)
```

Con parámetros:

```python
def procesar_archivo(nombre_archivo, fecha):
    print(f"Procesando {nombre_archivo} del día {fecha}")

tarea = PythonOperator(
    task_id="procesar_con_params",
    python_callable=procesar_archivo,
    op_kwargs={"nombre_archivo": "ventas.csv", "fecha": "2024-01-01"},
)
```

### 4.3. EmptyOperator (antes DummyOperator)
Placeholder sin lógica, útil para estructurar flujos.

```python
from airflow.operators.empty import EmptyOperator

inicio = EmptyOperator(task_id="inicio")
fin = EmptyOperator(task_id="fin")
```

### 4.4. Otros operadores comunes

```python
# Para SQL
from airflow.providers.postgres.operators.postgres import PostgresOperator

# Para APIs HTTP
from airflow.providers.http.operators.http import SimpleHttpOperator

# Para Spark
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator
```

---

## 5. Definición de dependencias

### 5.1. Sintaxis básica

```python
# Operador >> significa "se ejecuta antes que"
tarea1 >> tarea2

# Equivalente a:
tarea1.set_downstream(tarea2)
```

### 5.2. Cadena lineal

```python
descarga >> limpieza >> procesamiento >> guardado
```

### 5.3. Ejecución paralela

```python
tarea1 >> [tarea2, tarea3, tarea4]
```

Resultado:
```
tarea1
  ├─→ tarea2
  ├─→ tarea3
  └─→ tarea4
```

### 5.4. Convergencia

```python
[tarea1, tarea2, tarea3] >> tarea4
```

Resultado:
```
tarea1 ─┐
tarea2 ─┤→ tarea4
tarea3 ─┘
```

### 5.5. Flujo complejo

```python
inicio = EmptyOperator(task_id="inicio")
extraccion1 = BashOperator(task_id="extraer_ventas", bash_command="echo ventas")
extraccion2 = BashOperator(task_id="extraer_clientes", bash_command="echo clientes")
union = EmptyOperator(task_id="union")
carga = BashOperator(task_id="cargar_bd", bash_command="echo cargando")
fin = EmptyOperator(task_id="fin")

inicio >> [extraccion1, extraccion2] >> union >> carga >> fin
```

Diagrama:
```
inicio
  ├─→ extraccion1 ─┐
  └─→ extraccion2 ─┤→ union → carga → fin
```

---

## 6. Ejemplo completo: Pipeline de datos

```python
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.operators.empty import EmptyOperator

def validar_datos():
    print("Validando calidad de datos...")
    return True

default_args = {
    "owner": "equipo_datos",
    "retries": 2,
    "retry_delay": timedelta(minutes=3),
}

with DAG(
    dag_id="pipeline_completo_ventas",
    default_args=default_args,
    description="Pipeline diario de procesamiento de ventas",
    start_date=datetime(2024, 1, 1),
    schedule="0 2 * * *",  # Cada día a las 02:00
    catchup=False,
    tags=["produccion", "ventas"],
) as dag:
    
    inicio = EmptyOperator(task_id="inicio")
    
    extraer_datos = BashOperator(
        task_id="extraer_datos_fuente",
        bash_command="python /opt/airflow/scripts/extraer.py",
    )
    
    validar = PythonOperator(
        task_id="validar_calidad",
        python_callable=validar_datos,
    )
    
    transformar = BashOperator(
        task_id="transformar_datos",
        bash_command="python /opt/airflow/scripts/transformar.py",
    )
    
    cargar_staging = BashOperator(
        task_id="cargar_staging",
        bash_command="python /opt/airflow/scripts/cargar_staging.py",
    )
    
    cargar_produccion = BashOperator(
        task_id="cargar_produccion",
        bash_command="python /opt/airflow/scripts/cargar_prod.py",
    )
    
    fin = EmptyOperator(task_id="fin")
    
    # Definir flujo
    inicio >> extraer_datos >> validar >> transformar
    transformar >> [cargar_staging, cargar_produccion] >> fin
```

---

## 7. Variables y contexto

### 7.1. Uso de variables de Airflow

```python
from airflow.models import Variable

def procesar():
    ruta = Variable.get("ruta_datos")
    print(f"Procesando en {ruta}")

tarea = PythonOperator(
    task_id="usar_variable",
    python_callable=procesar,
)
```

Las variables se configuran en la UI: **Admin → Variables**.

### 7.2. Uso de contexto (templating)

```python
tarea = BashOperator(
    task_id="fecha_ejecucion",
    bash_command="echo 'Fecha: {{ ds }}'",  # ds = fecha en formato YYYY-MM-DD
)
```

Variables de contexto comunes:
- `{{ ds }}`: fecha de ejecución (YYYY-MM-DD)
- `{{ ds_nodash }}`: fecha sin guiones (YYYYMMDD)
- `{{ execution_date }}`: timestamp de ejecución
- `{{ dag.dag_id }}`: nombre del DAG
- `{{ task.task_id }}`: nombre de la tarea

---

## 8. Buenas prácticas

### 8.1. Nombres descriptivos
```python
# ❌ Malo
dag_id="dag1"
task_id="t1"

# ✅ Bueno
dag_id="ventas_diarias_etl"
task_id="extraer_ventas_api"
```

### 8.2. Tareas idempotentes
Las tareas deben poder ejecutarse múltiples veces con el mismo resultado.

```python
# ❌ Malo: duplica datos si se reintenta
INSERT INTO tabla VALUES (...)

# ✅ Bueno: elimina antes de insertar
DELETE FROM tabla WHERE fecha = '2024-01-01';
INSERT INTO tabla VALUES (...);
```

### 8.3. Separar lógica de negocio
```python
# ❌ Malo: código complejo en el DAG
def procesar():
    # 200 líneas de código...
    pass

# ✅ Bueno: importar módulos externos
from scripts.procesamiento import procesar_ventas

tarea = PythonOperator(
    task_id="procesar",
    python_callable=procesar_ventas,
)
```

### 8.4. Usar EmptyOperator para estructura
```python
inicio = EmptyOperator(task_id="inicio")
grupo_extracciones = EmptyOperator(task_id="extracciones_completadas")
fin = EmptyOperator(task_id="fin")

inicio >> [tarea1, tarea2] >> grupo_extracciones >> tarea3 >> fin
```

### 8.5. Documentar el DAG
```python
with DAG(
    dag_id="ventas_pipeline",
    description="Extrae ventas de la API, valida y carga en BD de producción",
    doc_md="""
    # Pipeline de Ventas
    
    Este DAG realiza:
    1. Extracción de ventas de API externa
    2. Validación de calidad
    3. Carga en base de datos
    
    Contacto: equipo-datos@empresa.com
    """,
    # ...
) as dag:
    pass
```

---

## 9. Troubleshooting común

### 9.1. El DAG no aparece en la UI

**Causas:**
- Error de sintaxis en el archivo Python.
- Archivo no está en carpeta `dags/`.
- Nombre de archivo incorrecto.

**Solución:**
```bash
# Ver logs del scheduler
docker logs airflow_lab --tail 100 | grep ERROR

# Validar sintaxis Python
python dags/mi_dag.py
```

### 9.2. Tarea falla inmediatamente

**Revisar:**
- Logs de la tarea en UI → Graph → Click en tarea → Logs.
- Ruta del comando/script es correcta.
- Permisos de ejecución.

### 9.3. DAG está en pausa

Por defecto, DAGs nuevos empiezan pausados.

**Solución:**
- Activar toggle en la UI junto al nombre del DAG.

### 9.4. Dependencias circulares

```python
# ❌ Error: B depende de A, A depende de B
tareaA >> tareaB
tareaB >> tareaA
```

Airflow rechaza DAGs con ciclos.

---

## 10. Recursos adicionales

### 10.1. Comando para listar DAGs

```bash
docker exec airflow_lab airflow dags list
```

### 10.2. Ejecutar DAG desde CLI

```bash
docker exec airflow_lab airflow dags trigger pipeline_basico
```

### 10.3. Ver estado de ejecución

```bash
docker exec airflow_lab airflow dags state pipeline_basico 2024-01-01
```

### 10.4. Validar DAG sin ejecutar

```bash
docker exec airflow_lab python /opt/airflow/dags/mi_dag.py
```

---

## 11. Ejemplo avanzado: Branching (ramificación condicional)

```python
from airflow.operators.python import BranchPythonOperator

def decidir_rama():
    import random
    if random.random() > 0.5:
        return "tarea_si"
    else:
        return "tarea_no"

rama = BranchPythonOperator(
    task_id="decision",
    python_callable=decidir_rama,
)

tarea_si = BashOperator(task_id="tarea_si", bash_command="echo SI")
tarea_no = BashOperator(task_id="tarea_no", bash_command="echo NO")

inicio >> rama >> [tarea_si, tarea_no]
```

---

## 12. Resumen rápido

**Para crear un DAG:**

1. Crear archivo `.py` en `dags/`.
2. Importar `DAG` y operadores.
3. Definir DAG con parámetros (`dag_id`, `start_date`, `schedule`).
4. Crear tareas (operadores).
5. Definir dependencias con `>>`.
6. Guardar y esperar que Airflow lo detecte (~30 segundos).
7. Activar en UI y ejecutar.

**Plantilla base:**

```python
from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id="nombre_dag",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
) as dag:
    
    tarea = BashOperator(
        task_id="nombre_tarea",
        bash_command="echo 'Hola'",
    )
```

---

## Fin del manual

Con esta guía tienes todo lo necesario para crear DAGs desde básicos hasta avanzados en Apache Airflow.
