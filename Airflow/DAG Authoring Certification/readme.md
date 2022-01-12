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

### Limitations
* Xcoms are limited in size according to database
    * postgres - 1gb per xcom
    * sqlite - 2gb
    * mysqkl - 64kb
* Can create an xcom backend (like s3...) to increase
        
### Ways of using Xcom
* first was seen before
* second, use the return standard from the callable
```py
def _extract(ti): #ti is tansk instance in the callable
    partner_name = "netflix"
    return partner_name #use the value in the return, is same as use xcom_push

def _read(ti): # the task will read the scom must also have ti as argument
    partner_name = ti.xcom_pull(key="return_value", task_id=_extract) #the push is made automatically to the key return_value, just ccall it with ti.xcom_pull
```
* for multiple values to be shared
```py
def _extract(ti): #ti is tansk instance in the callable
    partner_name = "netflix"
    partner_num = 123
    return {"partner_name" : partner_name, "partner_num" : partner_num } #use the value in the return, is same as use xcom_push, but now with json

def _read(ti): # the task will read the xcom must also have ti as argument
    partner_values= ti.xcom_pull(key="return_value", task_id=_extract) #the push is made automatically to the key return_value, just ccall it with ti.xcom_pull
    partner_name = partner_values["partner_name"]
    partner_num = partner_values["partner_num"]
```
* after the dag runs, got to Admin -> Xcoms and see the values

## Taskflow API - The new way of creating DAGs 
* Taskflow API is divided into 2 components:
* Decorators: help creations of dag in an easier way 
    * @task.python -> create a task and execute on puthon operator
    * @task.virtualenv -> create and execute the taks in the virtual env
    * @task_grou -> group many tasks together
```py
from airflow.decorators import task

@task.python
def extract(): 
    partner_name = "netflix"

@task.python
def read(): 
    print(test)

with DAG ( <MY DAG PARAMS>) as dag:
    extract() >> read() # must use parentesis as a function

```
* Xcom Args:
    * allow data dependencies among taks
    * make the implicit dependencies, explicit
    * have task A -> B -> C , C need xcom data from A, but the dag usually dont show it because xcom are under the table. Now we can see it
    * after code below, check UI and will see the dependency create amonth tasks, without explicitly declaring with >>
```py
@task.python
def extract(): 
    partner_name = "netflix"
    return partner_name #push it to xcom with the return

@task.python
def read(partner_name): #pull it using as an argument to the depndendant function
    print(partner_name)

with DAG ( <MY DAG PARAMS>) as dag:
    read(extract()) # create the xcom as dependency, and create dag dependencies automatically
```

## XComs with the TaskFlow API
* Before we created one xcom with return
* to return multiple xcoms values separately, there are 2 ways
    * use the **multiple_outputs = True** and pass in the function return a json
    * use the from typing import Dict, and in the function def use **def my_func() -> Dict [str,str]:** 
```py
@task.python(multiple_outputs = True)
def extract(): 
    partner_name = "netflix"
    partner_num = 123
    return {"partner_name" : partner_name, "partner_num" : partner_num } 

@task.python
def read(partner_name): #pull it using as an argument to the depndendant function
    print(partner_name)

with DAG ( <MY DAG PARAMS>) as dag:
    read(extract()) # create the xcom as dependency, and create dag dependencies automatically

```
or
```py
from typing import Dict

@task.python
def extract() -> Dict [str,str]: 
    partner_name = "netflix"
    partner_num = 123
    return {"partner_name" : partner_name, "partner_num" : partner_num } 

#to read it
with DAG ( <MY DAG PARAMS>) as dag:
    partner_settings = extract() # get the return from xcoms in a variable
    read(partner_settings['partner_name']) # create the xcom as dependency, and create dag dependencies automatically
```

#  Grouping your tasks
## SubDAGs: The Hard Way of Grouping your Tasks
* Creates sub dags to group some tasks in one single tasl in the parent dag
* need the subdagoperator and a factory to generate the subdags
* from aiflow.operators.subdag import SubdagOperator (check documentations)
* create a folder called subdags and create a dag there
* import the dag in the subfolder from subdagfolder import subdag_dag
* it is a sensor behind the scenes

## TaskGroups: The Best Way of Grouping your Tasks
* Group tasks in a much easier way than SubDagOperator
```py
from airflow.utils.task_group import TaskGroup #import the function

@task.python(multiple_outputs = True) #same function pushing variable to xcom
def extract(): 
    partner_name = "netflix"
    partner_num = 123
    return {"partner_name" : partner_name, "partner_num" : partner_num } 

@task.python() # task to be grouped
def print_1(partner_name , partner_num ): 
    print(partner_name)
    print(partner_num)

@task.python() # task to be grouped
def print_2(partner_name , partner_num ): 
    print(partner_name)
    print(partner_num)

with DAG ( <MY DAG PARAMS>) as dag:

    partner_settings = extract() 

    with TaskGroup(group_id='process_tasks') as process_tasks: #instantiate task group inside the task
        print_1(partner_settings['partner_name'],partner_settings['partner_num'])
        print_2(partner_settings['partner_name'],partner_settings['partner_num'])

    #dependencies are aiutomatically created because we use taskflow API
```
* in the UI you will see a blue task, double click and see the task belonging to the group
* To keep code clean, you can create a new file in a folder under dags and create the task groups there and the call in the taskgroups 
* Can also have a task group inside anoter task groups

# Advanced Concepts
## Dynamics Dags (not so dynamic)
* create dags that have similar task, just changing few arguments in a loop
* First have a dict of arguments
```py
partners = {
    "partner_1":
    {
        "partner_name":"netflix"
        "partner_num":1
    },
        "partner_2":
    {
        "partner_name":"snowflake"
        "partner_num":2
    },
        "partner_3":
    {
        "partner_name":"azure"
        "partner_num":3
    }
}
```
* create the loop on the dag
```py
from airflow.utils.task_group import TaskGroup #import the function

# we moved the extract task to the loop

@task.python() 
def print(partner_name , partner_num ): 
    print(partner_name)
    print(partner_num)

with DAG ( <MY DAG PARAMS>) as dag:

    for partner,details in partners.items():
        @task.python(task_id=f"extract_{partner}",multiple_outputs = True) #same function pushing variable to xcom, now with dynamic name
        def extract(partner_name,partner_num): 
            return {"partner_name" : partner_name, "partner_num" : partner_num } 
        extracted_values = extract(details['name'],details['num'])

        extracted_values >> print
```

## Make your choices with Branching
* depending on conditions from a task you select the next one task or another
* there are a few branch operators:
    * branch python operator
    * sql branch operator
    * more
* example, execute specific extract based on week day
``` py
from airflow.operators.python import BranchPythonOperator, PythonOperator
from airflow.operators.Dummy import DummyOperator

def _choosin_partner_based_on_day(execution_date): #create condition to return a specific value
    day = execution_date.day_of_week
    if (day == 1):
        return "partner_1"
    if (day == 3):
        return "partner_2"
    if (day == 5):
        return "partner_3"
    else:
        return "stop" # this condition is in case is day for no partner, you can stop with a dummy operator

@task.python() 
def print(partner_name , partner_num ): 
    print(partner_name)
    print(partner_num)

with DAG ( <MY DAG PARAMS>) as dag:

    start = DummyOperator(task_id="start")

    stop = DummyOperator(task_id="stop",trigger_rule=none_failed_or_skipped)

    choosin_partner_based_on_day = BranchPythonOperator = (
            task_id="choosin_partner_based_on_day"
            ,python_callable=_choosin_partner_based_on_day
        )

    for partner,details in partners.items():
        @task.python(task_id=f"extract_{partner}",multiple_outputs = True) #same function pushing variable to xcom, now with dynamic name
        def extract(partner_name,partner_num): 
            return {"partner_name" : partner_name, "partner_num" : partner_num } 
        extracted_values = extract(details['name'],details['num'])

        start >> extracted_values >> choosin_partner_based_on_day >> print
        choosin_partner_based_on_day >> stop
```
* You end up with this dag:
IMAGE - > Python Branch Operator
* In case you need to add a taks to run after one of the process taks, make sure to add the **trigger_rule=none_failed_or_skipped** in the task deifnition, otherwise the task will only run when all task succeed, which will never happen when using branch operator

## Change task execution with Trigger Rules
* define the behaviour of a taks with **trigger_rule**
* default is on_success -> only trigger whel all other success
    * on_failure -> when all before fail
    * one_failed -> if one failed
    * one_success -> if one succeeded 
    * none_failed -> if none before failed (if they skiped or succeed)
    * none_failed_or_skipped -> if one succeed
    * dummy -> trigger anyways

## Dependencies and Helpers
* defining dependencies old way
    * t2.set_upstream(t1)
    * t1.set_downstream(t2)
* new way
    * t1 >> t2
    * t2 << t1
* cross dendencies for 1 task 
    * from airflow.models.baseoperator import CrossDownstream
    * cross_downstream([t1,t2,t3],[t4,t5,t6])
    * t4 dependends on the t1,t2,t3 , t5 also depend on the 3
* you can`t create dependencies between two lists
* chain function for chain dependencies
    * airflow.models.baseoperator import Chain
    * chain(t1,[t2,t3],[t4,t5],t6)
    * **THE LIST MUST HAVE SAME NUMBER OS TASKS**
    IMAGE CHAIN OPERATOR
* you can mix both functions    

## Get the control of your tasks
* In the config file, is possible to do following configurations
    * PARALLELISM = 32 (default) -> max num of task running at same time in the instance
    * DAG_CONCURRENCY = 16 (default) -> max num of tasks running in the same dag
    * MAX_ACTIVE_RUNS_PER_DAG = 16 (default) -> max num of dag_runs running for same dag
* In DAG deifnition can also set some configs:
    * concurrency -> max num of task for the tasks
    * max_active_runs -> max num of dag runs concurrentlty
```py
with DAG ( <MY DAG PARAMS>, concurrency=2,max_active_runs=2) as dag:
```
* In task level tou can set other 2
    * task_concurrency -> max task instances running for this task on all dag runs at same time
    * pool -> NEXT CLASS
```py
start = DummyOperator(task_id="start",task_concurrency=1,pool='default_pool')
```

## Dealing with resource consuming tasks with Pools
* For resource intensive tasks
* like ML model
* Example: you have 3 task for ML model that could run concurrently, but for those tasks only you want to run one at time to save resources
* Pool is a number of tasks slots that are running in the same instance
* You can go to admin -> pools and create another pool with 1 slot 
* default is to same pool default_pool
```py
...
    for partner,details in partners.items():
        @task.python(task_id=f"extract_{partner}",multiple_outputs = True, pool = 'my_pool')
...
```
* Can do it without creating a pool by using
```py
...
    for partner,details in partners.items():
        @task.python(task_id=f"extract_{partner}",multiple_outputs = True, pool_slots = 1 )
...
```

## TASK PRIORITY - Execute critical tasks first, the others after
* All operators have an argument to change the priority of execution
* Can use the argument priority_weight in the task definition
* task priority is defined within the same pool, if the task run in different pool, task priority wont work
* Create some argument to differentiate
```py
partners = {
    "partner_1":
    {
        "partner_name":"netflix"
        "partner_num":1,
        "order":3
    },
        "partner_2":
    {
        "partner_name":"snowflake"
        "partner_num":2,
        "order":3
    },
        "partner_3":
    {
        "partner_name":"azure"
        "partner_num":3,
        "order":1
    }
}
.....

    for partner,details in partners.items():
        @task.python(task_id=f"extract_{partner}",priority_weight=partners['order'], multiple_outputs = True) 
```
 ## Depends on past - What if a task needs the output of its previous execution?
 * Defined at task level
 * is depends_on_past = true , the task with that argument will only run if the previous task SUCCEDD or SKIPEED
 * If the task on past fails, the taks in the next dag run wont work, it will get  no status

 ## Demystifying wait for downstream
* Run the task only if in the previous dag run, that same task and the next downstream task after that had also suceeded
* set wait_for_downstream = true in the definition
```py
t1 >> t2 >> t3
```
* t1 in the second dag run will run if t1 and t2 succeed in the previous dag run

## Sensors
* Operator that waits a condition set to true