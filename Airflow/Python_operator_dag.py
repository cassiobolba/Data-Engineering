#  CONTINUES FROM simple_dag.py
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime,timedelta

default_args = {
         'retry' : 5
        ,'retry_delay' : timedelta(minutes=5)
    }

def _downloading_data (**kwargs, myparam):
    print('test')
    print(kwargs[ds])
    print(my_param)

with DAG (   dag_id = 'simple_dag'
            ,schedule_interval = "*/10 * * * *"
            ,start_date = datetime(2021,1,1) 
            ,catchup = False #disable backfilling
            ,default_args = default_args
            ) as dag:

    downloading_data = PythonOperator (
         task_id = 'downloading_data
        ,python_callable = _downloading_data
        ,op_kwargs= { 'myparam' : 42 }
    )