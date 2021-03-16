# ETL Part 1: Data Extraction
## Lessons
1. Course Overview and Setup
2. ETL Process Overview
3. Connecting to Cloud Data Storage
4. Connecting to JDBC
5. Applying Schemas to JSON Data
6. Corrupt Record Handling
7. Loading Data and Productionalizing

## 1. Course Overview and Setup
Overview of ETL:

<img src="https://files.training.databricks.com/images/eLearning/ETL-Part-1/ETL-overview.png" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>

## 2. ETL Process Overview

### A Basic ETL Job

In this lesson you use web log files from the <a href="https://www.sec.gov/dera/data/edgar-log-file-data-set.html" target="_blank">US Securities and Exchange Commission website</a> to do a basic ETL for a day of server activity. You will extract the fields of interest and load them into persistent storage.

The Databricks File System (DBFS) is an HDFS-like interface to bulk data stores like Amazon's S3 and Azure's Blob storage service.

Let's suppose we already have a blob storage mounted:
```py
# setting the path of files
path = "/mnt/training/EDGAR-Log-20170329/EDGAR-Log-20170329.csv"

# creating the logDF dataframe
logDF = (spark
  .read
  .option("header", True)
  .csv(path)
  .sample(withReplacement=False, fraction=0.3, seed=3) # using a sample to reduce data size
)

display(logDF)
```
Next, select only codes 500 and 600

```py
# importing the col function frompyspark sql
from pyspark.sql.functions import col

# create a new df
serverErrorDF = (logDF
  .filter((col("code") >= 500) & (col("code") < 600))
  .select("date", "time", "extention", "code")
)

display(serverErrorDF)
```


### Data Validation

One aspect of ETL jobs is to validate that the data is what you expect.  This includes:<br>
* Approximately the expected number of records
* The expected fields are present
* No unexpected missing values

```py
# importing functions from pyspark.sql
from pyspark.sql.functions import from_utc_timestamp, hour, col
# new DF from serverErrorDF
countsDF = (serverErrorDF
  .select(hour(from_utc_timestamp(col("time"), "GMT")).alias("hour"))
  .groupBy("hour")
  .count()
  .orderBy("hour")
)

display(countsDF)
```

### Saving Back to DBFS

A common and highly effective design pattern in the Databricks and Spark ecosystem involves loading structured data back to DBFS as a parquet file. Learn more about [the scalable and optimized data storage format parquet here](http://parquet.apache.org/) or also [here](https://www.youtube.com/watch?v=itm0TINmK9k)

Save the parsed DataFrame back to DBFS as parquet using the `.write` method.
```py
targetPath = workingDir + "/log20170329/serverErrorDF.parquet"

(serverErrorDF
  .write
  .mode("overwrite") # overwrites a file if it already exists | append
  .parquet(targetPath)
)
```

### Exercise 1
Create a DataFrame `ipCountDF` that uses `logDF` to create a count of each time a given IP address appears in the logs, with the counts sorted in descending order.  The result should have two columns: `ip` and `count`.
```py
from pyspark.sql.functions import desc

ipCountDF = ( logDF
             .select("ip")
             .groupBy("ip")
             .count()
             .orderBy(desc("count"))
)
display(ipCountDF)
```

### Review
**Question:** How does the Spark approach to ETL deal with devops issues such as updating a software version?  
**Answer:** By decoupling storage and compute, updating your Spark version is as easy as spinning up a new cluster.  Your old code will easily connect to S3, the Azure Blob, or other storage.  This also avoids the challenge of keeping a cluster always running, such as with Hadoop clusters.

**Question:** How does the Spark approach to data applications differ from other solutions?  
**Answer:** Spark offers a unified solution to use cases that would otherwise need individual tools. For instance, Spark combines machine learning, ETL, stream processing, and a number of other solutions all with one technology.

## 3. Connecting to Cloud Data Storage
Apache spark is coming as a replacemente to map haddop because it can connect to far more data sources, environments and data applications.

### DBFS Mounts and Azure Blob Storage
Azure Blob Storage is the backbone of Databricks workflows.  It offers data storage that easily scales by colocating data with Spark clusters, Databricks quickly reads from and writes to Azure Blob Storage in a distributed manner.

The Databricks File System (DBFS), is a layer over Azure Blob Storage that allows you to mount Blob containers, making them available to other users in your workspace and persisting the data after a cluster is shut down.

In our road map for ETL, this is the <b>Extract and Validate </b> step:

<img src="https://files.training.databricks.com/images/eLearning/ETL-Part-1/ETL-Process-1.png" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px; box-shadow: 5px 5px 5px #aaa"/>

### **Unmounting** a Blob Storage
```py
try:
  dbutils.fs.unmount(mountPoint) # Use this to unmount as needed
except:
  print("{} already unmounted".format(mountPoint))
```

### **Mounting** a Blob Storage
check out [this](https://docs.databricks.com/data/data-sources/azure/azure-storage.html#mount-azure-blob-storage-containers-with-dbfs&language-python) template of mounting:

```py
# Declare the needed variables
storageAccount = "dbtraineastus2"
container = "training"
# Sahred Access Signature, informed in the storage account
sasKey = "?sv=2017-07-29&ss=b&srt=sco&sp=rl&se=2023-04-19T06:32:30Z&st=2018-04-18T22:32:30Z&spr=https&sig=BB%2FQzc0XHAH%2FarDQhKcpu49feb7llv3ZjnfViuI9IWo%3D"
# Mounting Path (/mnt is mandatory)
mountPoint = f"/mnt/etlp1a-{username}-si"

# Define two strings populated with the storage account and container information. This will be passed to the mount function.
sourceString = f"wasbs://{container}@{storageAccount}.blob.core.windows.net/"
confKey = f"fs.azure.sas.{container}.{storageAccount}.blob.core.windows.net"

try:
  dbutils.fs.mount(
    source = sourceString,
    mount_point = mountPoint,
    extra_configs = {confKey: sasKey}
  )
except Exception as e:
  print(f"ERROR: {mountPoint} already mounted. Run previous cells to unmount first")
```
Now, check out the files mounted:
```py
%fs ls /mnt/training
```
check out this artivle on <a href="https://docs.azuredatabricks.net/user-guide/secrets/index.html" target="_blank">secret management to securely store and reference your credentials in notebooks and jobs.</a> 

### Adding Options

When you import that data into a cluster, you can add options based on the specific characteristics of the data.
**NOTE:** Find a [full list of parameters here.](https://spark.apache.org/docs/latest/api/python/pyspark.sql.html?highlight=dateformat#pyspark.sql.DataFrameReader.csv)
```py
crimeDF = (spark.read
    # since it is a csv, we set the delimiter
  .option("delimiter", "\t")
    # from csv, the dataframe doesnt get that 1st line is header
  .option("header", True)
    # we can set a standard timestamp
  .option("timestampFormat", "mm/dd/yyyy hh:mm:ss a")
    # asking for the dataframe infer the schema
  .option("inferSchema", True)
    # and, the format and path of the file for reading
  .csv("/mnt/training/Chicago-Crimes-2018.csv")
)
display(crimeDF)
```
### Review

**Question:** What accounts for Spark's quick rise in popularity as an ETL tool?  
**Answer:** Spark easily accesses data virtually anywhere it lives, and the scalable framework lowers the difficulties in building connectors to access data.  Spark offers a unified API for connecting to data making reads from a CSV file, JSON data, or a database, to provide a few examples, nearly identical.  This allows developers to focus on writing their code rather than writing connectors.

**Question:** What is DBFS and why is it important?  
**Answer:** The Databricks File System (DBFS) allows access to scalable, fast, and distributed storage backed by S3 or the Azure Blob Store.

**Question:** How do you connect your Spark cluster to the Azure Blob?  
**Answer:** By mounting it. Mounts require Azure credentials such as SAS keys and give access to a virtually infinite store for your data. One other option is to define your keys in a single notebook that only you have permission to access. Click the arrow next to a notebook in the Workspace tab to define access permissions.

**Question:** How do you specify parameters when reading data?  
**Answer:** Using `.option()` during your read allows you to pass key/value pairs specifying aspects of your read.  For instance, options for reading CSV data include `header`, `delimiter`, and `inferSchema`.

**Question:** What is the general design pattern for connecting to your data?  
**Answer:** The general design pattern is as follows:
* Define the connection point
* Define connection parameters such as access credentials
* Add necessary options such as for headers or parallelization

## 4. Connecting to JDBC
Java Database Connectivity (JDBC) is an application programming interface (API) that defines database connections in Java environments.  
Spark is written in Scala, which runs on the Java Virtual Machine (JVM). 

Databases are advanced technologies that benefit from decades of research and development. To leverage the inherent efficiencies of database engines, Spark uses an optimization called predicate pushdown.  **Predicate pushdown uses the database itself to handle certain parts of a query (the predicates).**  In mathematics and functional programming, a predicate is anything that returns a Boolean.  In SQL terms, this often refers to the `WHERE` clause.  Since the database is filtering data before it arrives on the Spark cluster, there's less data transfer across the network and fewer records for Spark to process.  Spark's Catalyst Optimizer includes predicate pushdown communicated through the JDBC API, making JDBC an ideal data source for Spark workloads.

### Creating the connection
In Databriks you can easily move from language to anotehr. Our default language is python, but JDBC runs only in Scala.   

```py
# Run the below code to certifiy e call the postgree driver
%scala
// run this regardless of language type
Class.forName("org.postgresql.Driver")

# Define your database connection criteria. In this case, you need the hostname, port, and database name.
jdbcHostname = "server1.databricks.training"
jdbcPort = 5432
jdbcDatabase = "training"

jdbcUrl = f"jdbc:postgresql://{jdbcHostname}:{jdbcPort}/{jdbcDatabase}"

# Create a connection properties object with the username and password for the database.
connectionProps = {
  "user": "readonly",
  "password": "readonly"
}

```
After creating the JDBC connection, you can connect to database like this:
```py
tableName = "training.people_1m"

peopleDF = spark.read.jdbc(url=jdbcUrl, table=tableName, properties=connectionProps)

display(peopleDF)
```
The command above was executed as a serial read through a single connection to the database. This works well for small data sets; at scale, parallel reads are necessary for optimal performance.

See the [Managing Parallelism](https://docs.databricks.com/spark/latest/data-sources/sql-databases.html#managing-parallelism) section of the Databricks documentation.


### Review

**Question:** What is JDBC?  
**Answer:** JDBC stands for Java Database Connectivity, and is a Java API for connecting to databases such as MySQL, Hive, and other data stores.

**Question:** How does Spark read from a JDBC connection by default?  
**Answer:** With a serial read.  With additional specifications, Spark conducts a faster, parallel read.  Parallel reads take full advantage of Spark's distributed architecture.

**Question:** What is the general design pattern for connecting to your data?  
**Answer:** The general design patter is as follows:
* Define the connection point
* Define connection parameters such as access credentials
* Add necessary options such as for headers or parallelization

## 5. Applying Schemas to JSON Data
