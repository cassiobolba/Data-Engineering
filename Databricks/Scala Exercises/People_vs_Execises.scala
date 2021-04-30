// Databricks notebook source
// READING FROM FILE STORE
//File location and type
val path_people = "/FileStore/tables/people.json"
val path_exercises = "/FileStore/tables/exercises.json"
val file_type = "json"

// COMMAND ----------

// using multiline due to json file format 
val dfPeople = spark.read.option("multiline","true").json(path_people)

val dfExercisesRaw = spark.read.option("multiline","true").json(sc.parallelize(path_exercises))

// COMMAND ----------

//val explode = dfExercises.withColumn("exercises",explode($"exercises"))
//display(explode)
//
//val dfExercises = spark.read.option("multiline","true").schema(exercisesSchema).json(path_exercises)

// COMMAND ----------

new_df = old_df.withColumn("name",explode("user_info.name"))
                .withColumn("last_name",explode("user_info.last_name"))

// COMMAND ----------

import org.apache.spark.sql.functions._

val dfExercisesExp = dfExercisesRaw
                     .withColumn("date",explode($"exercises.date"))
                     .withColumn("exercise_end_time",explode($"exercises.exercise_end_time"))
                     .withColumn("exercise_start_time",explode($"exercises.exercise_start_time"))
                     .withColumn("user",explode($"exercises.user"))
                     .withColumn("exercise_rating", explode($"exercises.metadata.exercise_rating"))
                     .withColumn("heart_rate_samples",explode($"exercises.heart_rate_samples"))
                     .drop($"exercises")


// COMMAND ----------

val test = dfExercisesExp.select($"date",$"user",$"heart_rate_samples.*")
display(test)
//display(test.select(explode('heart_rate_samples) as (Seq("x", "y"))))


// COMMAND ----------



// COMMAND ----------

val test = dfExercisesExp.select($"date",$"user",explode_outer($"heart_rate_samples"))
display(test)

// COMMAND ----------

//unpivot
//val unPivotDF = test.select($"user",
//expr("stack(4, '11:15', '11:15','11:20','11:20') as (Country)"))
//.where("Total is not null")
//unPivotDF.show()

// COMMAND ----------

display(test.select(explode('heart_rate_samples) as (Seq("x", "y"))))

// COMMAND ----------

//val unpivotedDf = test
//    .selectExpr("date","user","stack(1,'11:15','11:15')")
//    .withColumnRenamed("col0","device") // default name of this column is col0

// COMMAND ----------

//display(test.select($"heart_rate_samples.*"))
