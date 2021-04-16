import airflow
import datetime
from airflow import DAG
from airflow import models
from airflow.operators import BashOperator
from airflow.contrib.operators import bigquery_operator
from airflow.contrib.operators import bigquery_to_gcs
from airflow.utils import trigger_rule

default_dag_args = {
     'start_date': airflow.utils.dates.days_ago(1),
     'email_on_failure': False,
     'email_on_retry': False,
     'retries': 1,
     'retry_delay' : datetime.timedelta(minutes=5),
}

output_file = 'gs://southamerica-east1-cassio-a-77e1beeb-bucket/data/address.csv'
#Replace <Your bucket> with your path details
with DAG(
       dag_id='demo_bq_dag',
       schedule_interval = datetime.timedelta(days = 1),
       default_args = default_dag_args) as dag:

      bq_airflow_commits_query = bigquery_operator.BigQueryOperator(
         task_id = 'bq_airflow_commits_query',
         bql = """    SELECT Address
         FROM [airflow-studies:Address.Add]
          """)
         

      export_commits_to_gcs = bigquery_to_gcs.BigQueryToCloudStorageOperator(
         task_id = 'export_airflow_commits_to_gcs',
         source_project_dataset_table = 'airflow-studies:Address.Add',
         destination_cloud_storage_uris = [output_file],
         export_format = 'CSV')

      bq_airflow_commits_query >> export_commits_to_gcs    
     














