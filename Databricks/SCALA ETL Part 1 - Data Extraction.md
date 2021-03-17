# SCALA - ETL Part 1: Data Extraction

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
* A schema describes the structure of your data by naming columns and declaring the type of data in that column
* Rigorously enforcing schemas leads to significant performance optimizations and reliability of code.
```scala
// printing the schema of a json
val zipsDF = spark.read.json("/mnt/training/zips.json")
zipsDF.printSchema
```
You can store the schema checked before on a variable to reuse later
```scala
val zipsSchema = zipsDF.schema
zipsSchema.foreach(println)
```
* Schema inference means Spark scans all of your data, creating an extra job, which can affect performance
* Consider providing alternative data types (for example, change a `Long` to a `Integer`)
* Consider throwing out certain fields in the data, to read only the data of interest
```scala
// importing the needed libraries to use
import org.apache.spark.sql.types.{StructType, StructField, IntegerType, StringType, ArrayType, FloatType}

val zipsSchema3 = StructType(List(
  StructField("city", StringType, true), 
  StructField("loc", 
    ArrayType(FloatType, true), true),
  StructField("pop", IntegerType, true)
))

// load the file using the schema provided
val zipsDF3 = (spark.read
  .schema(zipsSchema3)
  .json("/mnt/training/zips.json")
)
display(zipsDF3)-
```
**EXERCISE**  
Import Libs, create a schema with the column SMS, and create a df with all non null SMS values
```scala
import org.apache.spark.sql.types.{StructType, StructField, IntegerType, StringType, ArrayType, FloatType}

val schema = StructType(List(StructField("SMS",StringType,true)))

val SMSDF = spark.read
  .option("Header", true)
  .schema(schema)
  .json("/mnt/training/UbiqLog4UCI/14_F/log*")
  .filter($"SMS".isNotNull)
```

## 6. Corrupt Record Handling
ETL pipelines need robust solutions to handle corrupt data. This is because data corruption scales as the size of data and complexity of the data application grow. Corrupt data includes:

* Missing information
* Incomplete information
* Schema mismatch
* Differing formats or data types
* User errors when writing data producers    

There are three different options for handling corrupt records [set through the `ParseMode` option](https://github.com/apache/spark/blob/master/sql/catalyst/src/main/scala/org/apache/spark/sql/catalyst/util/ParseMode.scala#L34):  

| `ParseMode` | Behavior |
|-------------|----------|
| `PERMISSIVE` | Includes corrupt records in a "_corrupt_record" column (by default) |
| `DROPMALFORMED` | Ignores all corrupted records |
| `FAILFAST` | Throws an exception when it meets corrupted records |  

```scala
// creating sample corrupt records
val data = """{"a": 1, "b":2, "c":3}|{"a": 1, "b":2, "c":3}|{"a": 1, "b, "c":10}""".split('|')

// 
val corruptDF = spark.read
  .option("mode", "PERMISSIVE")
  .option("columnNameOfCorruptRecord", "_corrupt_record")
  .json(sc.parallelize(data))

display(corruptDF)
```
The result is:
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/SCALA%20ETL%20Part%201/spark%20permissive%20mode.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>

```scala
val data = """{"a": 1, "b":2, "c":3}|{"a": 1, "b":2, "c":3}|{"a": 1, "b, "c":10}""".split('|')

val corruptDF = spark.read
  .option("mode", "DROPMALFORMED")
  .json(sc.parallelize(data))

display(corruptDF)
```
Result in this:
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/SCALA%20ETL%20Part%201/spark%20drop%20malformed%20mode.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>

The following cell throws an error once a corrupt record is found, rather than ignoring or saving the corrupt records:
```scala
try {
  val data = """{"a": 1, "b":2, "c":3}|{"a": 1, "b":2, "c":3}|{"a": 1, "b, "c":10}""".split('|')

  val corruptDF = spark.read
    .option("mode", "FAILFAST")
    .json(sc.parallelize(data))

  display(corruptDF)  

// catch the exception  
} 
  catch {
  case e:Exception => print(e)
}
```
Failfast mode throws an error to debbug.

### Recommended approach in Databricks
Databricks Runtime has [a built-in feature](https://docs.databricks.com/spark/latest/spark-sql/handling-bad-records.html) that saves corrupt records to a given end point. To use this, set the `badRecordsPath`.  
```scala
// needs firts to define a folder to store the badrecords
// working dir was defined pevriously as 'dbfs:/user/cassio.bolba@gmail.com/etl_part_1/etl1_06___corrupt_record_handling_ssp/'
val myBadRecords = s"$workingDir/badRecordsPath"

println(s"""Your temp directory is "$myBadRecords" """)
println("-"*80)

// create the bad records
val data = """{"a": 1, "b":2, "c":3}|{"a": 1, "b":2, "c":3}|{"a": 1, "b, "c":10}""".split('|')

val corruptDF = spark.read
  .option("badRecordsPath", myBadRecords)
  .json(sc.parallelize(data))

display(corruptDF);
```
```scala
// reading the file with the bad record
val path = "%s/*/*/*".format(myBadRecords)
display(spark.read.json(path))
```
**EXERCISE**  
Import the data used in the last lesson, which is located at `/mnt/training/UbiqLog4UCI/14_F/log*`.  Import the corrupt records in a new column `SMSCorrupt`.  <br>

Save only the columns `SMS` and `SMSCorrupt` to the new DataFrame `SMSCorruptDF`.
```scala
val SMSCorruptDF = spark.read
  .option("mode", "PERMISSIVE")
  .option("columnNameOfCorruptRecord", "SMSCorrupt")
  .json("/mnt/training/UbiqLog4UCI/14_F/log*")
  .select("SMSCorrupt","SMS")
  .filter($"SMSCorrupt".isNotNull)
display(SMSCorruptDF)
```

## 7. Loading Data and Productionalizing
* Use parquet for reading files to get more speed
* Productionalize in a simple way means automate the execution
*  [Apache Parquet](https://parquet.apache.org/documentation/latest/) is a highly efficient, column-oriented data format that shows massive performance increases over other options such as CSV. For instance, Parquet compresses data repeated in a given column and preserves the schema from a write.
```scala
// getting the crime dataframe
val crimeDF = spark.read
  .option("delimiter", "\t")
  .option("header", true)
  .option("timestampFormat", "mm/dd/yyyy hh:mm:ss a")
  .option("inferSchema", true)
  .csv("/mnt/training/Chicago-Crimes-2018.csv")

display(crimeDF)
```
Rename the columns in CrimeDF so there are no spaces or invalid characters. This is required by Spark and is a best practice. Use camel case.
```scala
val cols = crimeDF.columns
val camelCols = new scala.collection.mutable.ListBuffer[String]()
cols.foreach(camelCols += _.toLowerCase.split(" ").reduceLeft(_+_.capitalize))

val crimeRenamedColsDF = crimeDF.toDF(camelCols:_*)
display(crimeRenamedColsDF)
```
### 7.1 Writting to Parquet
You can write and leave to spark define the numbers of parquet partitions
```scala
val targetPath = s"$workingDir/crime.parquet"
crimeRenamedColsDF.write.mode("overwrite").parquet(targetPath)
//check the output files created
display(dbutils.fs.ls(targetPath))
```
Or you can write and define the number of partitions
```scala
val repartitionedPath = s"$workingDir/crimeRepartitioned.parquet"
crimeRenamedColsDF.repartition(1).write.mode("overwrite").parquet(repartitionedPath)
//check the output files created
display(dbutils.fs.ls(repartitionedPath))
```
