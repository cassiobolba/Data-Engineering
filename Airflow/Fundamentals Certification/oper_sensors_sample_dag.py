from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.sensors.filesystem import FileSensor
from airflow.operators.bash import BashOperator
from datetime import datetime,timedelta
from airflow.sensors.filesystem import FileSensor
from airflow.models.baseoperator import chain, cross_downstream

default_args = {
         'retry' : 5
        ,'retry_delay' : timedelta(minutes=5)
        ,'email_on_failure': True
        ,'email_on_retry' : True
        ,'email' : 'cassio.bolba@gmail.com'
    }

# let's check if the file myfile.txt is in the folder
def _downloading_data (**kwargs):
    with open ('/tmp/myfile.txt','w'):
        f.write('my_data')
    return 42

# call the ti to access the xcoms metadata
def checking_data(ti):
    # call the method in ti and pass the xcoms key (can check in admin panel) and the task id where the xcoms is)
    my_xcoms = ti.xcom_pull(key='return_value', task_ids = ['downaloading_data'])
    print(my_xcoms)
    print('check data')

def _failure(context): # context brings information about
    print(context)

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

    checking_data = PythonOperator (
         task_id = 'checking_data'
        ,python_callable = checking_data
    )

    waiting_data = FileSensor (
         task_id = 'waiting_data'
        ,fs_conn_id= = 'con_id'
        ,filepath =  'my_file.txt'
        ,poke_interval = 15
    )

    processing_data = BashOperator (
        task_id = 'processing_data'
        ,bash_command = 'exit 0'
    )

downloading_data >> [ waiting_data, processing_data ] 

# another way to chain (not in same level)
# chain( downloading_data , waiting_data, processing_data )

# creating cross dependencies
# cross_downstream ( [ downloading_data, checking_data ] , [ waiting_data,processing_data ] )