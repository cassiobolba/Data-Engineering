# 1. ESSENTIALS

## 1.1 Why to use it?
* For ETL processes
* It can chain tasks dependencies
* Allow retry
* Allow monitoring
* Allow manage multiple tasks
* better than cron
## 1.2 What is Airflow?
**Open source platform to programmatically author, schedule and monitor workflows**
### 1.2.1 Benefits:
* **DYNAMIC**: Since it is python based, you have the same flexibility as python offer
* **SCALABLE**: Execute as many tasks as you want
* **INTERACTIVE**: 3 ways to interact: UI, cmd interface or REST API
* **EXTENSIBLE**: Can create own plugin to interact with airflow for anything you need

### 1.2.2 What Airflow IS NOT?
**NOT A STREAMING OR DATA PROCESSING FRAMEWORK**
Use it to trigger data processing frameworks like spark. Do not process the data on ariflow containers, it will fail.

## 1.3 Core Components:
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

## 1.4 Other Components
### Executor
* Define how your tasks are goin to be executes by airflow
    * If want to run a kubernetes task, must use the kubernetes executor
    * If you have a powerful machine, run locally with local executor
### Worker
* Is where your task is executed
    * a pod for kubernetes
    * a process for a local runner

## 1.5 Common Architectures
### 1.5.1 One Node
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/Airflow/img/one_node.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>  

* All components are installed together
* Web Server interacts with metastore, fetching all data needed to display in the UI (status, user, names, connections...)
* When Scheduler wants to trigger a task, it change the statur of the task in the metastore, then a task instance object is created
* After, the task instance in sent from scheduler to the queue of the executor
* When instance is in the queue, it can then by picked up by the worker
* After done, the executor will update the task status in the metastore
* Notice that  web server never talsk to schduler and executor directly
* This is the simplest architecture, like when you install in your computer

### 1.5.2 Multi Nodes (Celery)
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/Airflow/img/multi_node.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>   

* In this scenario, Web Server, schduler and executor are in the same node
* Metastore and Queue are in another node
* Since the queue are in another node, you will need to set a redis or Rabit MQ message system to communicate with executor externally
* Then you can have many Airflow workers as processing nodes
* As in single node, web server talks to metastore, as well as scheduler talks  to metastore and executor
* When task is ready to go, the executori send it to the queue that make it available for workers to get it
* This architecture is meant to execute many task, and you can also increase the number of workers to process more tasks
