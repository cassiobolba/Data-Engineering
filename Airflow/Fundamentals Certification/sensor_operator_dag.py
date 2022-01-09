from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.sensors.filesystem import FileSensor
from datetime import datetime,timedelta
from airflow.sensors.filesystem import FileSensor

default_args = {
         'retry' : 5
        ,'retry_delay' : timedelta(minutes=5)
    }

# let's check if the file myfile.txt is in the folder
def _downloading_data (**kwargs):
    with open ('/tmp/myfile.txt','w'):
        f.write('my_data')


with DAG (   dag_id = 'simple_dag'
            ,schedule_interval = "*/10 * * * *"
            ,start_date = datetime(2021,1,1) 
            ,catchup = False #disable backfilling
            ,default_args = default_args
            ) as dag:

    downloading_data = PythonOperator (
         task_id = 'downloading_data'
        ,python_callable = _downloading_data
    )

    waiting_data = FileSensor (
         task_id = 'waiting_data'
        ,fs_conn_id= = 'con_id'
        ,filepath =  'my_file.txt'
        ,poke_interval = 15
    )