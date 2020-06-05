# INTRODUCTION TO DATA ENGINEERING
## 1. INTRODUCTION TO DATA ENGINEERING
### 1.1 TASKS OF DATA ENGINEERS
* Connect to Data sources
* Extract Data
* Store Data
* Clean and Prepare Data
* Create and Mantain Data Pipelines

### 1.2 DATA ENGINEERS PROBLEMS
* Data scientists are querying the online store databases directly and slowing down the functioning of the application since it's using the same database.
* Problems with slow process due to memory are usually Infrastructure related, not a Data Engineer issue.

### 1.3TOOLS OF DATA ENGINEERS 
(small list of examples)
* Databases - SQL, NoSQL - MySQL
* Procesing tools (Clean, Aggr... ) - Hive, Spark
* Scheduling Tool (Plan Jobs) - Airflow

A DATA PIPELINE

fig 1 - Pipeline
<img src="http://....jpg" width="200" height="200" />

### 1.4 CLOUD PROVIDERS
When using self-hosted Data Center:
* Have to have extra processing capabilities for peak hours
* Pay maintenance
* Pay People to maintain
* Pay cooling and electricity bills  

When using Cloud:
* Don't have to buy hardware
* Care only about the application
* No extra processing for peak hour, it is scalable

#### 1.4.1 Big 3
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

## 2. DATA ENGINEERING TOOLBOX
### 2.1 DATABASES
Usually a large collection o data organized for rapid search and retrieval.
* Holds Data
* Organize Data
* Retrieve and search data through DBMS

### 2.2 STRUCTURES
* SQL: Tables, Database Schema, Relational Database (My SQL, Postgree)

* NoSQL:  Non-Relational, Structured and unstructured data, key value pair, Document (redis, Mongo)

### 2.3 SQL STAR SCHEMA
One or more fact tables referencing to many dimensional tables, having fact table centralized

fig 2 - Star Schema

Fact: Values of actions that happened  
dimensions: Categorical data classifying the facts

#### 2.3.1 Querying from Database with Python
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

#### 2.3.2 Joining tables with Python
```py
data = pd.read_sql("""
SELECT * FROM "Customer"
INNER JOIN "Order"
ON "Order"."customer_id"="Customer"."id"
""", db_engine)

# Show the id column of data
print(data.id)
```

### 2.4 PARALLEL COMPUTING
Basis of modern processing tools, because of memory and Processing Power. The idea is: take a big task, split into subtasks working together to finish the task.

fig 3 - Parallel Computing

#### 2.4.1 Benefits
* Processing Power
* Memory partition of the dataset 

#### 2.4.2 Risks
* Overhead due to comunication of subtasks
* Tasks need to be large
* Need Several processing units
* Parallel Slow Down

#### 2.4.3 Dask to parallelize with python
```py
import dask.dataframe as dd

# Set the number of partitions  
athlete_events_dask = dd.from_pandas(athlete_events, npartitions = 4)

# Calculate the mean Age per Year
print(athlete_events_dask.groupby('Year').Age.mean().compute())
```

### 2.5 Parallel Computation Frameworks  
#### 2.5.1 Apache Hadoop  
* HDFS - Similar to folder separated as in sharepoint, google drive  
* Hadoop Map Reduce: This is similar to what we saw before, tasks are divided into nodes. 

#### 2.5.2 Hive
* Hive: Layer on top of Hadoop to make easy to use. Use Hive SQL
* Spark: 

#### 2.5.3 RDD - Resilient Distributed Dataset  
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

### 2.6 workflow Scheduling
Now we know different sources of data, the power o parallel processing and also how to store it in DW or DL. How to put this work together, sync, make tasks dependent?
* DAG - Direct Acyclic Graph: Set of nodes, Directed Edges, no cycles, can be scheduled

#### 2.6.1 Tools for Scheduling
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

## 3. ETL - Extract, Transform and Load
Having been exposed to the toolbox of data engineers, it's now time to jump into the bread and butter of a data engineer's workflow! With ETL, you will learn how to extract raw data from various sources, transform this raw data into actionable insights, and load it into relevant databases ready for consumption!

### 3.1 Extract:
Getting data from persisting storages, like files, databases S3...
* Extract data fom text files: plain text (unstructured), row and columns (flat files) like csv  
* Extract from JSON (semi structured)
* Extract Data on Web: use resquest do get it through APIs
* Extract from Databases: Transaction DB (OLTP) or OLAP (analitical DB to data processing)
There are many python libraries to connect to each os these type os extraction described above. (import json, import requests)

#### 3.1.1 Fetching data from an API
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
#### 3.1.2 Fetching data from a Database
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

### 3.2 Transform:
Data engineers might need to perform many kinds of transformations:
* Select attributes
* Translate codes like NY to New York
* Validate inputs
* Split columns into multiples
* Join from multiple sources

#### 3.2.1 Split in Pandas
```py
# split the e-mail in an array inside the column by the delimiter and expand
split_email = customer_df.email.str.split("@", expand = True) 
# create 2 new columns using the columns created before
customer_df = customer_df.assign(
    username = split_email[0],
    domain = split_email[1]
)
```
#### 3.2.2 Join in pySpark
```py
# we have 2 dfs, custoemr and rating
# first group by to have the same granularity
ratings_per_customer = ratings_df.groupBy("customer_id").mean("rating")
# join on custumer ID
customer_df.join(
    ratings_per_customer,
    customer_df.customer_id == ratings_per_customer.customer_id
)
```
#### Exercise - convert - split 
```py
# Get the rental rate column as a string
rental_rate_str = film_df.rental_rate.astype("str")

# Split up and expand the column
rental_rate_expanded = rental_rate_str.str.split('.', expand=True)

# Assign the columns to film_df
film_df = film_df.assign(
    rental_rate_dollar=rental_rate_expanded[0],
    rental_rate_cents =rental_rate_expanded[1],
)
```
#### Exercise - Group by - join
```py
# Use groupBy and mean to aggregate the column
ratings_per_film_df = rating_df.groupBy('film_id').mean('rating')

# Join the tables using the film_id column
film_df_with_ratings = film_df.join(
    ratings_per_film_df,
    film_df.film_id==rating_df.film_id
)

# Show the 5 first results
print(film_df_with_ratings.show(5))
```

### 3.3 Loading:
When loading, there are considerations to make regarding the type o database, analitycs or application. There is also MPP Database, for parallelization.

#### 3.3.1 Analitycs (OLAP)
* Aggregate data and queries
* Column oriented
* queries about  subsets of columns
* good for parallelization

#### 3.3.2 Applications (OLTP)
* Lots os transactions
* Row oriented
* Stored per record
* ex: add a customer is fast

#### 3.3.3 Massive parallel Processing (MPP)
* Queries computed on several nodes
* Amazon Redshift, azure SQL DW and google big query

fig 5 - MPP

* this kind of storage use parquet or avro files, they are prepared to be processed parallely
* Are also stored in lakes like S3 or blob
```py
# writing parquet in pandas method
df.to_parquet("./s3://path/file.parquet")
# writing parquet in spark method
df.write.parquet("./s3://path/file.parquet")
# writing in PostgreSQL
recommendations.to_sql("recommendations",
                        db_engine,
                        schema="store",
                        if_exists="replace"
)
```
### Putting it all together - Schedule
After you have the full ETL process described in python you can use airflow as a refresher.
* It is a workflow scheduler
* made in python
* use DAG
* Tasks defined in operator (eg: bashOperator)

#### Scheduling with DAG in Airflow
```py
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator

dag = DAG(dag_id="sample",
            ...,
            schedule_interval="0 0 * * *"
            )
etl_task = PythonOperator (task_id="etl_task", #id for task
                            #python_callable is the etl defined before
                            python_callable=etl,
                            #identify the dag it belong to
                            dag=dag 
                            )
# now we can set up dependencies upstream or downstream
etl_task.set_upstream(wait_for_this_task)
# in this case, it will run only after wait_for_this_task run
```
once this script is done, you can save as etl_dag.py and save in ~/airflow/dags/ inside the airflow

fig 6 - AirFlow UI

#### Exercise - Define ETL Function
```py
# Define the ETL function
def etl():
    film_df = extract_film_to_pandas()
    film_df = transform_rental_rate(film_df)
    load_dataframe_to_film(film_df)

# Define the ETL task using PythonOperator
etl_task = PythonOperator(task_id='etl_film',
                          python_callable=etl,
                          dag=dag)

# Set the upstream to wait_for_table and sample run etl()
etl_task.set_upstream(wait_for_table)
etl()
```

#### Exercise - Find null values and replace it
```py
course_data = extract_course_data(db_engines)

# Print out the number of missing values per column in the course_data Dataset
print(course_data.isnull().sum())

# The transformation should fill in the missing values in the column 
def transform_fill_programming_language(course_data):
    imputed = course_data.fillna({"programming_language": "r"})
    return imputed

transformed = transform_fill_programming_language(course_data)

# Print out the number of missing values per column of transformed
print(transformed.isnull().sum())
```

