## 5. Definir el DAG de orquestacion

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