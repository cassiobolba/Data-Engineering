# INTRODUCTION TO DATA ENGINEERING
## INTRODUCTION TO DATA ENGINEERING
### TASKS OF DATA ENGINEERS
* Connect to Data sources
* Extract Data
* Store Data
* Clean and Prepare Data
* Create and Mantain Data Pipelines

### DATA ENGINEERS PROBLEMS
* Data scientists are querying the online store databases directly and slowing down the functioning of the application since it's using the same database.
* Problems with slow process due to memory are usually Infrastructure related, not a Data Engineer issue.

### TOOLS OF DATA ENGINEERS 
(small list of examples)
* Databases - SQL, NoSQL - MySQL
* Procesing tools (Clean, Aggr... ) - Hive, Spark
* Scheduling Tool (Plan Jobs) - Airflow

A DATA PIPELINE

fig 1 - Pipeline
<img src="http://....jpg" width="200" height="200" />

### CLOUD PROVIDERS
When using self-hosted Data Center:
* Have to have extra processing capabilities for peak hours
* Pay maintenance
* Pay People to maintain
* Pay cooling and electricity bills  

When using Cloud:
* Don't have to buy hardware
* Care only about the application
* No extra processing for peak hour, it is scalable

#### Big 3
* AWS - 32% of market  
Storage - S3  
Computation - AWS EC2  
Databases - AWS RDS

* Azure - 17%  
Storage - Blob Storage  
Computation - Azure VM  
Databases - Azure SQL Database

* Google - 10%  
Storage - Google Cloud Storage  
Computation - Google Compute Engine  
Databases - Google Cloud SQL

## DATA ENGINEERING TOOLBOX
### DATABASES
Usually a large collection o data organized for rapid search and retrieval.
* Holds Data
* Organize Data
* Retrieve and search data through DBMS

### STRUCTURES
* SQL: Tables, Database Schema, Relational Database (My SQL, Postgree)

* NoSQL:  Non-Relational, Structured and unstructured data, key value pair, Document (redis, Mongo)

### SQL STAR SCHEMA
One or more fact tables referencing to many dimensional tables, having fact table centralized

fig 2 - Star Schema

Fact: Values of actions that happened  
dimensions: Categorical data classifying the facts

#### Querying from Database with Python
```py
# Complete the SELECT statement
data = pd.read_sql("""
SELECT first_name,last_name FROM "Customer"
ORDER BY last_name, first_name
""", db_engine)

# Show the first 3 rows of the DataFrame
print(data.head(3))

# Show the info of the DataFrame
print(data.info())
```

#### Joining tables with Python
```py
data = pd.read_sql("""
SELECT * FROM "Customer"
INNER JOIN "Order"
ON "Order"."customer_id"="Customer"."id"
""", db_engine)

# Show the id column of data
print(data.id)
```

### PARALLEL COMPUTING
Basis of modern processing tools, because of memory and Processing Power. The idea is: take a big task, split into subtasks working together to finish the task.

fig 3 - Parallel Computing

#### Benefits
* Processing Power
* Memory partition of the dataset 

#### Risks
* Overhead due to comunication of subtasks
* Tasks need to be large
* Need Several processing units
* Parallel Slow Down

#### Dask to parallelize with python
```py
import dask.dataframe as dd

# Set the number of partitions  
athlete_events_dask = dd.from_pandas(athlete_events, npartitions = 4)

# Calculate the mean Age per Year
print(athlete_events_dask.groupby('Year').Age.mean().compute())
```

### Parallel Computation Frameworks  
#### Apache Hadoop  
* HDFS - Similar to folder separated as in sharepoint, google drive  
* Hadoop Map Reduce: This is similar to what we saw before, tasks are divided into nodes. 

#### Hive
* Hive: Layer on top of Hadoop to make easy to use. Use Hive SQL
* Spark: 

#### RDD - Resilient Distributed Dataset  
* Use as much as possible memory processing.  
* Spark rely on this system RDD. It is similar to list of tuples.  
* People use PySpark as spark interface, look similar to Pandas. There is also spark SQL

```py
# Print the type of athlete_events_spark
print(type(athlete_events_spark))

# Print the schema of athlete_events_spark
print(athlete_events_spark.printSchema())

# Group by the Year, and find the mean Age
print(athlete_events_spark.groupBy('Year').mean('Age'))

# Group by the Year, and find the mean Age and show
print(athlete_events_spark.groupBy('Year').mean('Age').show())
```

### workflow Scheduling
Now we know different sources of data, the power o parallel processing and also how to store it in DW or DL. How to put this work together, sync, make tasks dependent?
* DAG - Direct Acyclic Graph: Set of nodes, Directed Edges, no cycles, can be scheduled

#### Tools for Scheduling
* Linux cron
* Spotify Luigi
* Apache Airflow (air BNB)

fig 4 - DAG Example Air Flow

airflow python code:
```py 
# Create the DAG object
dag = DAG(dag_id="car_factory_simulation",
          default_args={"owner": "airflow","start_date": airflow.utils.dates.days_ago(2)},
          schedule_interval="0 * * * *")

# Task definitions
assemble_frame = BashOperator(task_id="assemble_frame", bash_command='echo "Assembling frame"', dag=dag)
place_tires = BashOperator(task_id="place_tires", bash_command='echo "Placing tires"', dag=dag)
assemble_body = BashOperator(task_id="assemble_body", bash_command='echo "Assembling body"', dag=dag)
apply_paint = BashOperator(task_id="apply_paint", bash_command='echo "Applying paint"', dag=dag)

# Complete the downstream flow
assemble_frame.set_downstream(place_tires)
assemble_frame.set_downstream(assemble_body)
assemble_body.set_downstream(apply_paint)
```

## ETL - Extract, Transform and Load
Having been exposed to the toolbox of data engineers, it's now time to jump into the bread and butter of a data engineer's workflow! With ETL, you will learn how to extract raw data from various sources, transform this raw data into actionable insights, and load it into relevant databases ready for consumption!

### Extract:
Getting data from persisting storages, like files, databases S3...
* Extract data fom text files: plain text (unstructured), row and columns (flat files) like csv  
* Extract from JSON (semi structured)
* Extract Data on Web: use resquest do get it through APIs
* Extract from Databases: Transaction DB (OLTP) or OLAP (analitical DB to data processing)
There are many python libraries to connect to each os these type os extraction described above. (import json, import requests)

#### Fetching data from an API
```py
import requests

# Fetch the Hackernews post
resp = requests.get("https://hacker-news.firebaseio.com/v0/item/16222426.json")

# Print the response parsed as JSON format
print(resp.json())

# Assign the score of the test to post_score, we knew that score was on of the itens in the json
post_score = resp.json()["score"]
print(post_score)
```
#### Fetching data from a Database
```py
# Function to extract table to a pandas DataFrame
def extract_table_to_pandas(tablename, db_engine):
    query = "SELECT * FROM {}".format(tablename)
    return pd.read_sql(query, db_engine)

# Connect to the database using the connection URI
connection_uri = "postgresql://repl:password@localhost:5432/pagila" 
db_engine = sqlalchemy.create_engine(connection_uri)

# Extract the film table into a pandas DataFrame
extract_table_to_pandas("film", db_engine)

# Extract the customer table into a pandas DataFrame
extract_table_to_pandas("customer", db_engine)
```
