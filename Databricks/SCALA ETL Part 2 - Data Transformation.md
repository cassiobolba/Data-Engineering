# SCALA - ETL Part 2: Data Transformation
## 1. Course Overview and Setup
1. Course Overview and Setup
2. Common Transformations
3. User Defined Functions
4. Advanced UDFs
5. Joins and Lookup Tables
6. Database Writes
7. Table Management

## 2. Common Transformations
Common transformations Includes:
* Normalizing values
* Imputing null or missing data
* Deduplicating data
* Performing database rollups
* Exploding arrays
* Pivoting DataFrames

### 2.1 Normalizing Data
Normalizing refers to different practices including restructuring data in normal form to reduce redundancy, and scaling data down to a small, specified range.    
For this case, bound a range of integers between 0 and 1.
```scala
// range of values to be normalized
val intergerDF = spark.range(1000,10000)
```
Then, subtract the minimum and divide by the maximum, minus the minimum
```scala
import org.apache.spark.sql.functions.{col, max, min}
// selecting min value, getting the first min, in case there are more, and saying it is a long, not an any object
val colMin = integerDF.select(min("id")).first()(0).asInstanceOf[Long]
val colMax = integerDF.select(max("id")).first()(0).asInstanceOf[Long]
// performing the calculation
val normalizedIntegerDF = integerDF
  .withColumn("normalizedValue", (col("id") - colMin) / (colMax - colMin) )

display(normalizedIntegerDF)
```
Results in this:   

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/SCALA%20ETL%20Part%202/image%20norrmalization.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>

### 2.2 Imputing Null or Missing Data
Strategies for dealing with this scenario include:
* **Dropping these records:** Works when you do not need to use the information for downstream workloads
* **Adding a placeholder (e.g. `-1`):** Allows you to see missing data later on without violating a schema
* **Basic imputing:** Allows you to have a "best guess" of what the data could have been, often by using the mean of non-missing data
* **Advanced imputing:** Determines the "best guess" of what data should be using more advanced strategies such as clustering machine learning algorithms or oversampling techniques   

Let's create a sample dataset to practice
```scala
val corruptDF = Seq(
  (Some(11), Some(66), Some(5)),
  (Some(12), Some(68), None),
  (Some(1), None, Some(6)),
  (Some(2), Some(72), Some(7))
).toDF("hour", "temperature", "wind")

display(corruptDF)
```
**TO DROP ANY RECORD WITH NULL VALUES**
```scala
val corruptDroppedDF = corruptDF.na.drop("any")
display(corruptDroppedDF)
```
**TO INPUT VALUES WITH ANOTHER ONES, HARDCODED OR MEAN, OR AVG**
```scala
val map = Map("temperature" -> 68, "wind" -> 6)
val corruptImputedDF = corruptDF.na.fill(map)

display(corruptImputedDF)
```
### 2.3 Deduplicating Data
This example for simple dedupe, where all the records for duplicated lines are exactly the same. You can also dedupe by some coluns only.  
There may be more complex scenários of dedupe.
```scala
// creating a duped df
val duplicateDF = Seq(
  (15342, "Conor", "red"),
  (15342, "conor", "red"),
  (12512, "Dorothy", "blue"),
  (5234, "Doug", "aqua")
  ).toDF("id", "name", "favorite_color")

display(duplicateDF)
```
**DEDUPE ON ID AND FAVOURITE_COLOUR**
```scala
val duplicateDedupedDF = duplicateDF.dropDuplicates("id", "favorite_color")

display(duplicateDedupedDF)
```
### 2.4 Other Helpful Data Manipulation Functions

| Function    | Use                                                                                                                        |
|:------------|:---------------------------------------------------------------------------------------------------------------------------|
| `explode()` | Returns a new row for each element in the given array or map                                                               |
| `pivot()`   | Pivots a column of the current DataFrame and perform the specified aggregation                                             |
| `cube()`    | Create a multi-dimensional cube for the current DataFrame using the specified columns, so we can run aggregation on them   |
| `rollup()`  | Create a multi-dimensional rollup for the current DataFrame using the specified columns, so we can run aggregation on them |

**EXERCISE**
* Load the dataframe and examine it
```scala
val dupedDF = spark.read
  .option("header",true)
  .option("Delimiter",":")
  .csv("/mnt/training/dataframes/people-with-dups.txt")
display(dupedDF)
```
* make the 3 names columns lower and remove hyphens from ssn
```scala
import org.apache.spark.sql.functions.{col, lower, translate}

val dupedWithColsDF = (dupedDF
  .select(col("*"),
    lower(col("firstName")).alias("lcFirstName"),
    lower(col("lastName")).alias("lcLastName"),
    lower(col("middleName")).alias("lcMiddleName"),
    translate(col("ssn"), "-", "").alias("ssnNums")
))
display(dupedWithColsDF)
```
Deduplicate the data by dropping duplicates of all records except for the original names (first, middle, and last) and the original `ssn`.  Save the result to `dedupedDF`.  Drop the columns you added in step 2.
```scala
val dedupedDF = dupedWithColsDF
  .dropDuplicates(Array("lcFirstName", "lcMiddleName", "lcLastName", "ssnNums", "gender", "birthDate", "salary"))
  .drop("lcFirstName", "lcMiddleName", "lcLastName", "ssnNums")

display(dedupedDF) 
```

## 3. Common Transformations
* First, *built-in functions are finely tuned* so they run faster than less efficient code provided by the user.  
* Secondly, Spark (or, more specifically, Spark's optimization engine, the Catalyst Optimizer) knows the objective of built-in functions so it can *optimize the execution of your code by changing the order of your tasks.* 
* UDFs are generally more performant in Scala than Python since for Python, Spark has to spin up a Python interpreter on every executor to run the function. This causes a substantial performance bottleneck due to communication across the Py4J bridge (how the JVM inter-operates with Python) and the slower nature of Python execution.

<div><img src="https://files.training.databricks.com/images/eLearning/ETL-Part-2/built-in-vs-udfs.png" style="height: 400px; margin: 20px"/></div>

### 3.1 Basic UDF
* First Create a function
```scala
// function to split a string by space
def manual_split: String => Seq[String] = _.split(" ")
manual_split("this is my example string")
```
* Then register the function by designating
  * name to access the function in scala (`manualSplitScalaUDF`)
  * name for access in SQL (`manualSplitSQLUDF`)
  * function itself (created previously)
```scala
val manualSplitScalaUDF = spark.udf.register("manualSplitSQLUDF", manual_split)
```
To test, create a DataFrame of 100k values with a string to index. Do this by using a hash function, in this case `SHA-1`.
```scala
import org.apache.spark.sql.functions.{sha1, rand}

val randomDF = (spark.range(1, 10000 * 10 * 10 * 10)
  .withColumn("random_value", rand(seed=10).cast("string"))
  .withColumn("hash", sha1($"random_value"))
  .drop("random_value")
)

display(randomDF)
```
Apply the UDF by using it just like any other Spark function.
```scala
val randomAugmentedDF = randomDF.select($"*", manualSplitScalaUDF($"hash").alias("augmented_col"))

display(randomAugmentedDF)
```

## 4. Joins and Lookup Tables 
There are basically 2 types of joins:  
**A standard (or shuffle) join**
* Moves all the data on the cluster for each table to a given node on the cluster
* This is expensive not only because of the computation needed to perform row-wise comparisons
* Also because data transfer across a network is often the biggest performance bottleneck of distributed systems.

**A broadcast join** 
* remedies this situation when one DataFrame is sufficiently small
* A broadcast join duplicates the smaller of the two DataFrames on each node of the cluster
* Avoiding the cost of shuffling the bigger DataFrame
* If spark detects one of the tables are less then 10mb, it sets automatically to broadcast join

<div><img src="https://files.training.databricks.com/images/eLearning/ETL-Part-2/shuffle-and-broadcast-joins.png" style="height: 400px; margin: 20px"/></div>

## 4.1 Lookup Tables
Usually smaller tables to enrich main data  
```scala
// load the smaller data table
val labelsDF = spark.read.parquet("/mnt/training/day-of-week")
display(labelsDF)

// then load the big table - this set to legacy os basically to be able to use the "u" in timestamp because it is a spark 2.0 function
// in spart 3.0 u = F
spark.conf.set("spark.sql.legacy.timeParserPolicy","LEGACY")
import org.apache.spark.sql.functions.date_format

val pageviewsDF = spark.read
  .parquet("/mnt/training/wikipedia/pageviews/pageviews_by_second.parquet/")
  .withColumn("dow", date_format($"timestamp", "u").alias("dow"))
display(pageviewsDF)

// then join both dataframes
val pageviewsEnhancedDF = pageviewsDF.join(labelsDF, "dow")
display(pageviewsEnhancedDF)
```
Now, aggregate the results to see trends by day of the week
```scala
val aggregatedDowDF = pageviewsEnhancedDF
  .groupBy($"dow", $"longName", $"abbreviated", $"shortName")  
  .sum("requests")                                             
  .withColumnRenamed("sum(requests)", "Requests")
  .orderBy($"dow")

display(aggregatedDowDF)
```
## 4.2 Eploring the performed Join
In these joins, no type was specified. To check how it went:
```scala
aggregatedDowDF.explain()
```
To explicitly change to a broadcast join:
```scala
import org.apache.spark.sql.functions.broadcast

pageviewsDF.join(broadcast(labelsDF), "dow").explain()
```

**EXERCISE**
Join a table that includes country name to a lookup table containing the full country name
```scala
// read both tables
val countryLookupDF = spark.read.option("multiline",true).parquet("/mnt/training/countries/ISOCountryCodes/ISOCountryLookup.parquet")

val logWithIPDF = spark.read.option("multiline",true).parquet("/mnt/training/EDGAR-Log-20170329/enhanced/logDFwithIP.parquet")

// import the broadcast
import org.apache.spark.sql.functions.broadcast

// join the tables using boradcast, selecting cols to compare, then drop the columns from lookup table
val logWithIPEnhancedDF = (logWithIPDF
  .join(broadcast(countryLookupDF), logWithIPDF.col("IPLookupISO2") === countryLookupDF.col("alpha2Code"))
  .drop("alpha2Code", "alpha3Code", "numericCode", "ISO31662SubdivisionCode", "independentTerritory")
)
```
