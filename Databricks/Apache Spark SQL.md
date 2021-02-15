# INTRODUCTION SQL SPARK DATABRIKS

## Basic Query
```sql 
%sql --Assing sql as the language of below code
CREATE OR REPLACE TEMPORARY VIEW WomenBornAfter1990 AS --create a temporary view that is deleted when cluster is turned off
  SELECT 
       firstName
       ,middleName
       ,lastName
       ,year(birthDate) AS birthYear --is a built in function to convert the date to year
       ,salary   
  FROM People10M  
  WHERE year(birthDate) > 1990 AND gender = 'F'  
```  

Create a temporary view called PeopleWithFixedSalaries, where all the negative salaries have been
converted to positive numbers:

``` sql
%sql
CREATE OR REPLACE TEMPORARY VIEW PeopleWithFixedSalaries AS
SELECT 
  case
    when salary < 0 then salary * (-1)
    else salary 
  end as salary
--abs(salary) as salary -- can also be done using abs()
FROM People10M
order by salary desc
limit 10
```

Eventhough a date is not formated, you can compare with date no fully equal.
ex: birthDate is YYYY-MM-DD HH:MM:SS but I can compare only with the begining 
   where gender = "F" and firstName = "Caren" and birthDate < '1980-03-01'

### Excluding a table
```sql
DROP TABLE IF EXISTS PeopleWithFixedSalaries;
```
## Accessing Data
DBFS is azure alternative dor HDFS (hadoop distributed file)

For Parquet files, you need to specify only one option: the path to the file.
Side Note A Parquet "file" is actually a collection of files stored in a single directory. 
The Parquet format offers features making it the ideal choice for storing "big data" on distributed 
file systems. For more information, see Apache Parquet.

You can create a table from an existing DBFS file with a simple SQL CREATE TABLE statement.
If you don't select a database, the database called "default" is used.
```sql
%sql
CREATE DATABASE IF NOT EXISTS databricks;

USE databricks;

CREATE TABLE IF NOT EXISTS IPGeocode
  USING parquet
  OPTIONS (
    path "dbfs:/mnt/training/ip-geocode.parquet"
  )
```

Programatically exectue a similar SQL command as above

```py
spark.sql(f"USE {databaseName}")
```

## Reading a sample of a file

```python
%fs head /mnt/training/bikeSharing/data-001/day.csv --maxBytes=492
```

Spark can create a table from that CSV file, as well.
There is a header
The file is comma separated (the default)
Let Spark infer what the schema is

```sql
%sql
CREATE TABLE IF NOT EXISTS BikeSharingDay
  USING csv
  OPTIONS (
    path "/mnt/training/bikeSharing/data-001/day.csv",
    inferSchema "true",
    header "true"
  )
```

dropping the table

```sql
%sql
DROP TABLE BikeSharingDay
````

## Mounting Blobs

Mount a Databricks Azure blob (using read-only access and secret key pair), access one of the files in the blob as a DBFS path, then unmount the blob.
The mount point must start with /mnt/.
 If the directory was already mounted, you would receive the following error:
Directory already mounted: /mnt/temp-training
In this case, use a different mount point such as temp-training-2, and ensure you update all three references below. the next cell is in Scala!

```py
# the sas url is the key to connect to blob and create the storage
sasURL = "https://dbtraineastus2.blob.core.windows.net/?sv=2017-07-29&ss=b&srt=sco&sp=rl&se=2023-04-19T06:32:30Z&st=2018-04-18T22:32:30Z&spr=https&sig=BB%2FQzc0XHAH%2FarDQhKcpu49feb7llv3ZjnfViuI9IWo%3D"
sasKey = sasURL[sasURL.index('?'): len(sasURL)]
storageAccount = "dbtraineastus2"
containerName = "training"
mountPoint = "/mnt/temp-training"

dbutils.fs.mount(
  source = f"wasbs://{containerName}@{storageAccount}.blob.core.windows.net/",
  mount_point = mountPoint,
  extra_configs = {f"fs.azure.sas.{containerName}.{storageAccount}.blob.core.windows.net": sasKey}
)
```

take a look inside some blob mounted
%fs ls /mnt/temp-training

### Review Questions
**Q:** What is Azure Blob Store?  
**A:** Blob Storage stores from hundreds to billions of objects such as unstructured data—images, videos, audio, documents easily and cost-effectively.

**Q:** What is DBFS?  
**A:** DBFS stands for Databricks File System.  DBFS provides for the cloud what the Hadoop File System (HDFS) provides for local spark deployments.  DBFS uses Azure Blob Store and makes it easy to access files by name.

**Q:** Which is more efficient to query, a parquet file or a CSV file?  
**A:** Parquet files are highly optimized binary formats for storing tables.  The overhead is less than required to parse a CSV file.  Parquet is the big data analogue to CSV as it is optimized, distributed, and more fault tolerant than CSV files.

**Q:** How can you create a new table?  
**A:** Create new tables by either:
* Uploading a new file using the Data tab on the left.
* Mounting an existing file from DBFS.

**Q:** What is the SQL syntax for defining a table in Spark from an existing parquet file in DBFS?  
**A:** ```CREATE TABLE IF NOT EXISTS IPGeocode
USING parquet
OPTIONS (
  path "dbfs:/mnt/training/ip-geocode.parquet"
)```

## Querying JSON
### Examining the contents of a JSON file

JSON is a common file format in big data applications and in data lakes (or large stores of diverse data).  Datatypes such as JSON arise out of a number of data needs.  For instance, what if...  
<br>
* Your schema, or the structure of your data, changes over time?
* You need nested fields like an array with many values or an array of arrays?
* You don't know how you're going use your data yet so you don't want to spend time creating relational tables?

The popularity of JSON is largely due to the fact that JSON allows for nested, flexible schemas.

Querying the head of the JSON File:
```sql
%fs head dbfs:/mnt/training/databricks-blog.json
```

Creating a table from JSON:
```sql
%sql
CREATE TABLE IF NOT EXISTS DatabricksBlog
  USING json
  OPTIONS (
    path "dbfs:/mnt/training/databricks-blog.json",
    inferSchema "true"
  )
```

Checking the type of data inside the JSON table:
```sql
%sql
DESCRIBE Table_Name
```
There cabn have multiple different formats od JSON data like: 
* Struct: EX: date colum with two column inside like CreatedDate and PublishedDate;  
* Array Strings: list of strings in an array format

## Querying from Structs
Like this case, the dates are structs, you can use the . approach.  
Once you read that field it is going to be a string type, thus is not possible to compare with dates, so, you can use the `cast` function to convert to timestamp.
```sql
%sql
CREATE OR REPLACE TEMPORARY VIEW DatabricksBlog2 AS
  SELECT *, 
         cast(dates.publishedOn AS timestamp) AS publishedOn 
  FROM DatabricksBlo
```

### Converting to Dates
In case you want to check all published articles in 2013, it is easier to convert the timestamp to date, with the `date_format` command.
```sql
%sql
SELECT title, 
       date_format(publishedOn, "MMM dd, yyyy") AS date, 
       link 
FROM DatabricksBlog2
WHERE year(publishedOn) = 2013
ORDER BY publishedOn
```

## Querying Arrays
The table also contains array columns. 
Easily determine the size of each array using the built-in `size(..)` function with array columns.
```sql
%sql
SELECT size(authors), 
       authors 
FROM DatabricksBlog
```

Pull the first element from the array authors using an array subscript operator.

```sql
%sql
SELECT authors[0] AS primaryAuthor 
FROM DatabricksBlog
```
## Exploding Arrays
The explode function allows you to split an array column into multiple rows, copying all the other columns into each new row.
For example, you can split the column authors into the column author, with one author per row.
As we know, `authors` and `categories` are arrays with multiple objects in it.
Restricting to all publications with more than one author:
```sql
%sql
SELECT title, 
       authors, 
       explode(authors) AS author, 
       link 
FROM DatabricksBlog 
WHERE size(authors) > 1 
ORDER BY title
```

## Lateral View Explode
Next, use LATERAL VIEW to explode multiple columns at once, in this case, the columns `authors` and `categories`.
```sql
%sql
SELECT dates.publishedOn, title, author, category
FROM DatabricksBlog
LATERAL VIEW explode(authors) exploded_authors_view AS author
LATERAL VIEW explode(categories) exploded_categories AS category
WHERE title = "Apache Spark 1.1: The State of Spark Streaming"
ORDER BY author, category
```

### Exercise
Count how many times each category is referenced in the Databricks blog. Remember that each category is an array, so, each title can appear in multiple categories.

```sql
%sql
CREATE OR REPLACE TEMPORARY VIEW TotalArticlesByCategory AS
  SELECT DISTINCT
     category
    ,count(title) as total
  FROM DatabricksBlog
  LATERAL VIEW explode(categories) exploded_categories AS category
  group by category;
```

### Review Questions
**Q:** What is the syntax for accessing nested columns?  
**A:** Use the dot notation: ```SELECT dates.publishedOn```

**Q:** What is the syntax for accessing the first element in an array?  
**A:** Use the [subscript] notation:  ```SELECT authors[0]```

**Q:** What is the syntax for expanding an array into multiple rows?  
**A:** Use the explode keyword, either:  
```SELECT explode(authors) as Author``` or  
```LATERAL VIEW explode(authors) exploded_authors_view AS author```

## Data Lakes

Companies frequently have thousands of large data files gathered from various teams and departments, typically using a diverse variety of formats including CSV, JSON, and XML.  Analysts often wish to extract insights from this data.

The classic approach to querying this data is to load it into a central database called a Data Warehouse.  This involves the time-consuming operation of designing the schema for the central database, extracting the data from the various data sources, transforming the data to fit the warehouse schema, and loading it into the central database.  The analyst can then query this enterprise warehouse directly or query smaller data marts created to optimize specific types of queries.

This classic Data Warehouse approach works well but requires a great deal of upfront effort to design and populate schemas.  It also limits historical data, which is restrained to only the data that fits the warehouse's schema.

An alternative to this approach is the Data Lake.  A _Data Lake_:

* Is a storage repository that cheaply stores a vast amount of raw data in its native format
* Consists of current and historical data dumps in various formats including XML, JSON, CSV, Parquet, etc.
* Also may contain operational relational databases with live transactional data

Spark is ideal for querying Data Lakes as the Spark SQL query engine is capable of reading directly from the raw files and then executing SQL queries to join and aggregate the Data.

You will see in this lesson that once two tables are created (independent of their underlying file type), we can join them, execute nested queries, and perform other operations across our Data Lake.


## Review Questions
**Q:** What is a Data Lake?  
**A:** Data Lakes are a loose collection of data files gathered from various sources.  Spark loads each file as a table and then executes queries joining and aggregating these files.

**Q:** What are some advantages of Data Lakes over more classic Data Warehouses?  
**A:** Data Lakes allow for large amounts of data to be aggregated from many sources with minimal ceremony or overhead.  Data Lakes also allow for very very large files.  Powerful query engines such as Spark can read the diverse collection of files and execute complex queries efficiently.

**Q:** What are some advantages of Data Warehouses?  
**A:** Data warehouses are neatly curated to ensure data from all sources fit a common schema.  This makes them very easy to query.

**Q:** What's the best way to combine the advantages of Data Lakes and Data Warehouses?  
**A:** Start with a Data Lake.  As you query, you will discover cases where the data needs to be cleaned, combined, and made more accessible.  Create periodic Spark jobs to read these raw sources and write new "golden" tables that are cleaned and more easily queried.