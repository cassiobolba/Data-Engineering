from airflow import DAG
from airflow.operators.dummy import DummyOperator
from datetime import datetime,timedelta

default_args = {
         'retry' : 5
        ,'retry_delay' : timedelta(minutes=5)
    }

with DAG (   dag_id = 'simple_dag'
            ,schedule_interval = "*/10 * * * *"
            #,schedule_interval = "@daily" 
            #,schedule_interval = timedelta(hours=7) 
            ,start_date = datetime(2021,1,1) 
            ,catchup = False #disable backfilling
            ,default_args = default_args
            ) as dag:

    task_1 = DummyOperator (
        task_id = 'task_1'
    )

    task_2 = DummyOperator (
        task_id = 'task_2'
    )