# import DAG class
from airflow import DAG

# instantiate the dag object
# define dag_id
# if no specify any scheduling, default is every day
# owner is not specified by default
with DAG (dag_id = 'simple_dag') as dag:
    NotImplementedError



