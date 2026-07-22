import sys
from pathlib import Path
from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from airflow.providers.standard.operators.python import PythonOperator
from datetime import datetime, timedelta

PROJECT_ROOT = Path(__file__).resolve().parents[1]
API_REQUEST_DIR = PROJECT_ROOT / "api-request"
DBT_PROJECT_DIR = PROJECT_ROOT / "dbt" / "my_project"
DBT_PROFILES_DIR = PROJECT_ROOT / "dbt"

sys.path.append(str(API_REQUEST_DIR))
from insert_records import main

default_args = {
    'description': 'Orchestrator DAG for Weather API Project',
    'start_date': datetime(2026, 1, 16),
    'catchup': False,
}


dag = DAG(
    dag_id = "weather-api-dbt-orchestrator",
    default_args=default_args,
    schedule=timedelta(minutes=5)
)

with dag:
    task1 = PythonOperator(
        task_id='ingest_data_task',
        python_callable=main
    )
    task2 = BashOperator(
        task_id='transform_data_task',
        bash_command=f'cd "{DBT_PROJECT_DIR}" && dbt run --profiles-dir "{DBT_PROFILES_DIR}"',
    )

    task1 >> task2
