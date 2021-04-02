# 1. ESSENTIALS
## 1.1 WHY USE AIRLFOW?
* For ETL processes
* It can chain tasks dependencies
* Allow retry
* Allow monitoring
* Allow manage multiple tasks
* better than cron
## 1.2 WHAT IS AIRFLOW?
**Open source platform to programmatically author, schedule and monitor workflows**
### 1.2.1 BENEFITS:
* **DYNAMIC**: Since it is python based, you have the same flexibility as python offer
* **SCALABLE**: Execute as many tasks as you want
* **INTERACTIVE**: 3 ways to interact: UI, cmd interface or REST API
* **EXTENSIBLE**: Can create own plugin to interact with airflow for anything you need

### 1.2.2 WHAT AIRFLOW IS NOT?
**NOT A STREAMING OR DATA PROCESSING FRAMEWORK**
Use it to trigger data processing frameworks like spark. Do not process the data on ariflow containers, it will fail.

## 1.3 CORE COMPONENTS:
### Web Server
* Flask Server to access the user interface
### Scheduler
* Responsible to trigger task
* Can have multiple scheduler at the same time
* Having more than one, if one fails, other can work
### Metadata Database
* Store all metadata regarding to:
    * User
    * jobs
    * Variables
    * Connections
* Any database compatible with SQLAlchemy can be used
    * MySQL
    * PostGre
    * Oracle
    * SQL lite
    * Mongo (with limitations)

## 1.4 OTHER COMPONENTS
### Executor
* Define how your tasks are goin to be executes by airflow
    * If want to run a kubernetes task, must use the kubernetes executor
    * If you have a powerful machine, run locally with local executor
### Worker
* Is where your task is executed
    * a pod for kubernetes
    * a process for a local runner

## 1.5 COMMON ARCHITECTURES
### 1.5.1 ONE NODE
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/Airflow/img/one_node.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>  

* All components are installed together
* Web Server interacts with metastore, fetching all data needed to display in the UI (status, user, names, connections...)
* When Scheduler wants to trigger a task, it change the statur of the task in the metastore, then a task instance object is created
* After, the task instance in sent from scheduler to the queue of the executor
* When instance is in the queue, it can then by picked up by the worker
* After done, the executor will update the task status in the metastore
* Notice that  web server never talsk to schduler and executor directly
* This is the simplest architecture, like when you install in your computer

### 1.5.2 MULTI NODES (Celery)
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/Airflow/img/multi_node.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>   

* In this scenario, Web Server, schduler and executor are in the same node
* Metastore and Queue are in another node
* Since the queue are in another node, you will need to set a redis or Rabit MQ message system to communicate with executor externally
* Then you can have many Airflow workers as processing nodes
* As in single node, web server talks to metastore, as well as scheduler talks  to metastore and executor
* When task is ready to go, the executori send it to the queue that make it available for workers to get it
* This architecture is meant to execute many task, and you can also increase the number of workers to process more tasks

## 1.6 CORE CONCEPTS
### DAG
* Data Pipeline
* Directed Acyclic Graph
* No loops
* One Node is chained to another linearly

### OPERATOR
* Is the node of a DAG
* It is a Task in the DAG
* There are 3 types: 
 
**ACTION OPERATOR**
* Python
* Bash
* SQL 

**TRANSFER OPERATOR**   
* Used to transfer data from one source to a destination
* My SQL to Presto

**SENSOR OPERATOR**   
* Wait something to happens to start another task
* Like wait a file to land in a destination, and it trigger the next task

### TASK
* When an operator is instantiated, it becomes a task in the DAG
* And whent the task is ready to trigger it becomes a **TASK INSTANCE**
* Task instance is like a DAG + Task + Point in Time

### DEPENDENCIES
* the edges in the nodes are the depencecies
* The following task depends on the previous
* can define it in 2 ways
    * Use the set_upstream or set_downstream
    * or use << or >> (bit shift operator)

### WORFLOW
* It is a combination of all concepts  listed above: DAG + Operator + Task + Dependencies

## 1.7 TASK LIFECYCLE 
* Create a python file and place in the DAGs Folder
* Web server (every 30s) and scheduler (every 5min) parses the python file
* If the task is ready to trigger, the scheduler creates a dag run object (instance of task)
* It changes the taks status in the metastore to "Schduled"
* Then the scheduler send the task to the executor and the status change to "Queued"
* The task is ready to be taken by an executor and run
* When the task is running the executor update task status to "running"
* After run, executor change status to "success"
* Then the scheduler task if there is anything else to run and update to next status
* Finnally, the web server fetch data from metastore and update the UI

## 1.8 EXTRAS AND PROVIDERS
* Airflow offer the basics functions
* But you can extend its capabilities by adding extras
* Extra is a provider with aditional dependencies
* It is totally independent from airflow, it can be updated separatly
* Like adding a Postgree providers
* EXTRA : Adds all dependencies
* PROVIDERS : Just a hook or connection for operators, for example

# 2. INTERACTING WITH APACHE AIRFLOW
## 2.1 3 WAYS
* UI : Check logs, Monitor Logs, DAGs
* CLI: Initialize, if you don't have acces to UI
* REST API: To build something on the top of Airflow, to communicate with other applications

## 2.2 UI
### 2.2.1 **DAG VIEW**
* Login page (admin/admin)
* Default logs to DAGs view
* toggle to enable task execution, stop it
* DAGs name, dag owner
* Dag runs: check de current run, past runs, success of failure 
* Schedule: Interval of execution
* Last Run: Last time of exection
* Recebnt Tasks: Status of all tasks running or last runs
* Actions: Tigger manually (toogle must be on), refresh DAG (read again from DAG folder), Delete all metadata (but nor files)
* Links: To acces other views in Airflow

### 2.2.2 **Tree View**
* View when clic on a Dags
* Good to see which task failed, and its status
* Spot late runs and failures
* Can check how are the DAGs running simultaneouslly 
* See task dependencies
* Can see the previous runs and status

### 2.2.3 **Graph View**
* Check task dependencies and Relationship of tasks
* Check status of the last DAG run
* Border color is the state of the task (gree, red...)
* Hover over a taks to see which task is triggered by it
* Can enable auto update

### 2.2.4 **Gaant View**
* Analyze task duration and overlaps
* Task parallel running and which taks and time is taking longer

### 2.3 INTERACTING WITH TASKS
* In in view, click on task to get taks instance view

IMAGEM

ON THE TOP : TASK INSTANCES
* Instance Details: Dag ID, execution date, duration
* Rendered: Output of data
* Logs: see logs, outoput, status
* All Instances: See all instances created to run a specific task
* Filter Upstream: Check the tasks that run after the task selected

TASK ACTIONS:  
* Run: Runs the task
* Clear: Clear the task state (border go white, can retry the task)
* Mark Success and failures

### 2.4 COMMAND LINE INTERFACE (CLI)
* Connect to web server
* airflow db init - initialize db
* airflow db upgrade
* airflow db reset - strat for scratch
* airflow webserver - start webserver
* ariflow scheduler - star scheduler
* ariflow celery worker - star celery nodes
* ariflow dags pause or unpause - same as the toggle button in dag view
* ariflow dags trigger -e -> trigger a dat and pass execution date
* ariflow dags list - list of dags
* ariflow tasks list example_dag - list all tasks a dag has
* ariflow tasks test dag_id task_id 2021-01-01 - execute a specific task in a dag to test before running all dag
* ariflow dags backfill -s <start_date> -e <stop_date> - rerun dags from past days

### 2.5 REST API
* go to docs
* see the endpoints available

# 3. DAGS AND TASKS
## 3.1 DAG SKELETON
Lets create first DAG:
```py
from airflow import DAG

with DAG (dag_id = 'simple_dag') as dag:
    NotImplementedError
```
* import DAG class
* instantiate the dag object
* define dag_id
* if no specify any scheduling, default is every day
* owner is not specified by default