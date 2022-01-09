# Intallation
* install docker
* install docker compose (included in docker instalation for Mac and Windows)
* install Astronomer Cli (until step 4) https://www.astronomer.io/docs/cloud/stable/develop/cli-quickstart
**had to use this workaround to start dev env https://forum.astronomer.io/t/buildkit-not-supported-by-daemon-error-command-docker-build-t-airflow-astro-bcb837-airflow-latest-failed-failed-to-execute-cmd-exit-status-1/857/3**

# The Basics
## Define your DAG? The right way
* Put dags on dags folder
* Must have the word dag in the file name and in beggining of the file. Commom Practice:   
```py
from airflow import DAG
```
* modify DAG_DISCOVERT_SAFE_MODE to false to disabel that
* on DAG folder and .airflowignore file and fill with thing to be ignored
* use context manager define DAG at once for all operator, don`t define dag for each operator
```py
with DAG (...) as dag:
    DummyOperator(dag=dag)
```
* Important dag definitions:
    * dag_id: unique 
    * description: explain the goal of dag
    * start_date: day where the dag start to run
    * schedule_interval: interval dag will run (@daily, @weekly, cron schedule,timedelta), default is one day
    * dagrun_timeout: when the dag fail for timeout (avoid overlap schedule on short schedule like 5 min)
    * tag: separate by teams and filter on ui
    * catchup: run the missing days before, set false to avoid many runs speacially after error
```py
from datetime import datetime,timdedelta
with DAG (
    dag_id="dummyyy"
    ,description="execute test"
    ,start_date=datetime(2022,1,8)
    ,schedule_interval="@daily"
    ,dagrun_timeout=timdedelta(minutes=10)
    ,tag=["data eng","marketing"]
    ,catchup=False
    ) as dag:
```
## DAG scheduling 101
2 importants parameters:
* start_date=datetime(2022,1,8)
* schedule_interval="* /10 * * *"
The above schedule means: every 10 minutes **AFTER** start date + schedule interval. So, first run is at 00:10 of 08/01/2022, and so on.

## Cron vs Timedelta
*consider start_date for both cases below as 10am 01/01/2022*
* Cron
    * stateless
    * schedule_interval = "@daily" or "0 0 * * *"
    * will run every day at midnight
    * not very good for schedule like every 3 days
* Timedelta
    * statefull (relative)
    * schedule_interval = timedelta(days=1)
    * the delta is relative to the start date, so this dag will run 10am of 02/01/2022

## Task idempotence and determinism 
* Deterministic -> for the same input you always get the same output
* Idempotent -> Every time you run your task it will always produce same side effect
    * ex. dont use CREATE TABLE in a query, it can only be used once, instead use CREATE IF NOT EXISTS
    * ex. 2 using bash operator, dont use mkdir more than once

## Backfilling
* Auto re run past dags
* controlled by catchup parameter in dag definition
* Can change on CATCHUP_BY_DEFAULT on config files to false
* Can also backfill in the CLI: ex run past year dags
```sh
airflow dags backfill -s 2020-01-01 -e 2021-01-01
```
* to avoid multiple active runs use the argument **max_active_runs = 1** in dag definition
* Can also in the UI search for old dag runs, select them all and clear state to re run again

# Master Variables
## Variables
* Reusable key value pair
* UI -> admin -> Variables 
* Prefix the name of variable according to a logic
* Can also create via CLI
* To use:
``` py
from airflow.models import Variable
....
def _extract():
    my_var = Variable.get("my_var_name_created_in_ui")
```
* to hide a value in the ui and logs use some of the following in the key name:
    * password
    * secret

## Properly fetch your variables
* Every time you call Variable.get("my_var_name_created_in_ui") you create a connection with airflow metadatabase
* Can cause issues to have many connections 
* If you have multiple variables to be used under same context, can create a json value in the Val on UI:
```py
{"name":"test","surname":"testeee"}
```
* to call it:
```py 
my_var = Variable.get("my_var_name_created_in_ui", deserialize_json=True)
name = my_var["name"]
surname = my_var["surname"]
```
* Can also call a varialbe as a function parameter, in case your operator runs a function:
```py
extract = PythonOperator (
    task_id="extract"
    ,python_callable=_extract #this is a function like def my_func(variable_param):
    ,op_args=[Variable.get("my_var_name_created_in_ui", deserialize_json=True)["name"]]
)
```
* op_args will pass "name" to the variable of function my_func(variable_param)
* op_args still connect to database several times
* Can use **template engine** to call it only once as your dag runs:
    * var.json -> standard
    * my_var_name_created_in_ui -> var name in the ui
    * name -> attribute from json to access
```py
...
,op_args=["{{var.json.my_var_name_created_in_ui.name }}"]
...
```
## The Power of Environment Variables
* Use docked image to export ENV value
* create an ENV variable with AIRFLOW_VAR_.... in the beggining and Aiflow will now it is airflow variable
```s
ENV AIRFLOW_VAR_MY_VAR="{"name":"test","surname":"testeee"}"
```
* must restart airflow instance to build the image again
* this var dont appear in UI
* retrieve the values in any way as mentioned before with Variable.get()
* ENV carialbes in docker don't create connections to database =D

# Power of TaskFlow API
## Add data at runtime with templating
* 2 paisr of {{}} means something is templated and will run at run time
* Not all arguments can be templated, like op_args
* Verifiy the argument you want to template is possible on the docs. Go to registry airflow and verify in the operator documentation if the argument has the flag (tempalted)
* [example here](https://registry.astronomer.io/providers/postgres/modules/postgresoperator) search for postree operator 
```py
...
fetch_data = PostgresOperator (
    taskid="fetching_data"
    ,sql="SELECT * FROM partners WHERE date = {{ ds }}"
)
```
* ds in this case is a standard variable for current date, but could be any other variable

## Sharing data with XCOMs and limitations
* xcom store data in the metadatabase to be shared between tasks
* this happens via the task instance object, aka as ti, and it must then be present on your python callable
* example of 2 python callables
```py
def _extract(ti): #ti is tansk instance in the callable
    partner_name = "netflix"
    ti.xcom_push(key="partner_name", value=partner_name)

def _read(ti): # the task will read the scom must also have ti as argument
    partner_name = ti.xcom_pull(key="partner_name", task_id=_extract)
```

