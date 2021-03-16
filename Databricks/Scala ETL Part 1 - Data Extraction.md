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
No notes taken
## 2. ETL Process Overview

### A Basic ETL Job
Let's suppose we already have a blob storage mounted:
```scala
// setting the path of files
val path = "/mnt/training/EDGAR-Log-20170329/EDGAR-Log-20170329.csv"

// creating the logDF dataframe
val logDF = spark
  .read
  .option("header", true)
  .csv(path)
  .sample(withReplacement=false, fraction=0.3, seed=3) // using a sample to reduce data size

display(logDF)
```
Next, select only codes 500 and 600

```scala
val serverErrorDF = logDF
  .filter(($"code" >= 500) && ($"code" < 600))
  .select("date", "time", "extention", "code")

display(serverErrorDF)
```

### Data Validation

One aspect of ETL jobs is to validate that the data is what you expect.  This includes:<br>
* Approximately the expected number of records
* The expected fields are present
* No unexpected missing values

```scala
// importing functions from pyspark.sql
import org.apache.spark.sql.functions.{from_utc_timestamp, hour}
// new DF from serverErrorDF
val countsDF = serverErrorDF
  .select(hour(from_utc_timestamp($"time", "GMT")).alias("hour"))
  .groupBy($"hour")
  .count()
  .orderBy($"hour")

display(countsDF)
```

### Saving Back to DBFS

Save the parsed DataFrame back to DBFS as parquet using the `.write` method.
```scala
val targetPath = workingDir + "/log20170329/serverErrorDF.parquet"

serverErrorDF
  .write
  .mode("overwrite") // overwrites a file if it already exists
  .parquet(targetPath)
```

### Exercise 1
Create a DataFrame `ipCountDF` that uses `logDF` to create a count of each time a given IP address appears in the logs, with the counts sorted in descending order.  The result should have two columns: `ip` and `count`.
```scala
val ipCountDF = logDF
  .select($"ip")
  .groupBy($"ip")
  .count()
  .orderBy($"count".desc)
```

## 3. Connecting to Cloud Data Storage
Apache spark is coming as a replacemente to map reduce because it can connect to far more data sources, environments and data applications.

### DBFS Mounts and Azure Blob Storage
Azure Blob Storage is the backbone of Databricks workflows.  It offers data storage that easily scales by colocating data with Spark clusters, Databricks quickly reads from and writes to Azure Blob Storage in a distributed manner.

The Databricks File System (DBFS), is a layer over Azure Blob Storage that allows you to mount Blob containers, making them available to other users in your workspace and persisting the data after a cluster is shut down.

In our road map for ETL, this is the <b>Extract and Validate</b> step:

### **Unmounting** a Blob Storage
```scala
try {
  dbutils.fs.unmount(s"$mountPoint") // Use this to unmount as needed
} catch {
  case ioe: java.rmi.RemoteException => println(s"$mountPoint already unmounted")
}
```

### **Mounting** a Blob Storage
check out [this](https://docs.databricks.com/data/data-sources/azure/azure-storage.html#mount-azure-blob-storage-containers-with-dbfs&language-python) template of mounting:

```scala
// Declare the needed variables
val storageAccount = "dbtraineastus2"
val container = "training"
// Sahred Access Signature, informed in the storage account
val sasKey = "?sv=2017-07-29&ss=b&srt=sco&sp=rl&se=2023-04-19T06:32:30Z&st=2018-04-18T22:32:30Z&spr=https&sig=BB%2FQzc0XHAH%2FarDQhKcpu49feb7llv3ZjnfViuI9IWo%3D"
// Mounting Path (/mnt is mandatory)
val mountPoint = s"/mnt/etlp1a-$username-ss"

// Define two strings populated with the storage account and container information. This will be passed to the mount function.
val sourceString = s"wasbs://$container@$storageAccount.blob.core.windows.net/"
val confKey = s"fs.azure.sas.$container.$storageAccount.blob.core.windows.net"

try {
  dbutils.fs.mount(
    source = sourceString,
    mountPoint = mountPoint,
    extraConfigs = Map(confKey -> sasKey)
  )
}
catch {
  case e: Exception =>
    println(s"*** ERROR: Unable to mount $mountPoint. Run previous cells to unmount first")
}
```
Now, check out the files mounted:
```py
%fs ls /mnt/training
```
check out this article on <a href="https://docs.azuredatabricks.net/user-guide/secrets/index.html" target="_blank">secret management to securely store and reference your credentials in notebooks and jobs.</a> 

### Adding Options

When you import that data into a cluster, you can add options based on the specific characteristics of the data.
**NOTE:** Find a [full list of parameters here.](https://spark.apache.org/docs/latest/api/python/pyspark.sql.html?highlight=dateformat#pyspark.sql.DataFrameReader.csv)
```scala
val crimeDF = (spark.read
    // since it is a csv, we set the delimiter
  .option("delimiter", "\t")
    // from csv, the dataframe doesnt get that 1st line is header
  .option("header", True)
    // we can set a standard timestamp
  .option("timestampFormat", "mm/dd/yyyy hh:mm:ss a")
    // asking for the dataframe infer the schema
  .option("inferSchema", True)
    // and, the format and path of the file for reading
  .csv("/mnt/training/Chicago-Crimes-2018.csv")
)
display(crimeDF)
```

## 4. Connecting to JDBC
Java Database Connectivity (JDBC) is an application programming interface (API) that defines database connections in Java environments.  
Spark is written in Scala, which runs on the Java Virtual Machine (JVM). 

* Spark uses an optimization called predicate pushdown.  **Predicate pushdown uses the database itself to handle certain parts of a query (the predicates).**  In mathematics and functional programming, a predicate is anything that returns a Boolean.    

In SQL terms, this often refers to the `WHERE` clause.  Since the database is filtering data before it arrives on the Spark cluster, there's less data transfer across the network and fewer records for Spark to process.  Spark's Catalyst Optimizer includes predicate pushdown communicated through the JDBC API, making JDBC an ideal data source for Spark workloads.

### Creating the connection
In Databriks you can easily move from language to anotehr. Our default language is python, but JDBC runs only in Scala.   

```scala
// Run the below code to certifiy e call the postgree driver
%scala
// run this regardless of language type
Class.forName("org.postgresql.Driver")

// Define your database connection criteria. In this case, you need the hostname, port, and database name.
val jdbcHostname = "server1.databricks.training"
val jdbcPort = 5432
val jdbcDatabase = "training"

val jdbcUrl = s"jdbc:postgresql://$jdbcHostname:$jdbcPort/$jdbcDatabase"

// Create a connection properties object with the username and password for the database.
import java.util.Properties

val connectionProperties = new Properties()
connectionProperties.put("user", "readonly")
connectionProperties.put("password", "readonly")

```
After creating the JDBC connection, you can connect to database like this:
```scala
val tableName = "training.people_1m"

val peopleDF = spark.read.jdbc(url=jdbcUrl, table=tableName, properties=connectionProperties)

display(peopleDF)
```
The command above was executed as a serial read through a single connection to the database. This works well for small data sets; at scale, parallel reads are necessary for optimal performance.

See the [Managing Parallelism](https://docs.databricks.com/spark/latest/data-sources/sql-databases.html#managing-parallelism) section of the Databricks documentation.


## 5. Applying Schemas to JSON Data
