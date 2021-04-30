There are 2 JSON files. The first JSON file (people.json) contains information about individuals. The second JSON (exercises.json) contains exercise data for those individuals. An individual is identified by the “user” key which is connected to “id” key in people.json file. Write a Spark pipeline in Scala that derives the following information from this data:

Person report that contains the following for each unique person
* Total number of exercises for person 
    (count of start time group by user id)
* Average duration of exercise for person 
    (avg (end - start time) group by user id)
* Average exercise rating for person 
    (avg exercise_rating group by user id)
* Average heart rate during exercise for person

Exercise report containing the following info on each exercise:
* Starting/ending time of exercise and duration
* Hourly average heart rate
* Hourly minimum/maximum heart rate

Process the JSON data and create at least the above reports (”PersonReport” and “Exercises”).