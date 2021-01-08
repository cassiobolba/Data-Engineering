# STREAMLINED DATA INGESTION WITH PANDAS

- [STREAMLINED DATA INGESTION WITH PANDAS](#streamlined-data-ingestion-with-pandas)
  * [1. IMPORTING FLAT FILES](#1-importing-flat-files)
    + [1.1 DATA FRAMES](#11-data-frames)
    + [1.2 MODIFY FLAT FILE IMPORTS](#12-modify-flat-file-imports)
      - [Limit Columns with usecol](#limit-columns-with-usecol)
      - [Limit rows with nrows and skiprows](#limit-rows-with-nrows-and-skiprows)
      - [Assigning Column Names](#assigning-column-names)
      - [Exercise - reading necessary columns](#exercise---reading-necessary-columns)
      - [Exercise - reading chuncks of data](#exercise---reading-chuncks-of-data)
    + [1.3 HANDLING ERRORS AND MISSING DATA](#13-handling-errors-and-missing-data)
      - [Specify data types](#specify-data-types)
      - [Missing Datas](#missing-datas)
      - [Lines Pandas Can't Parse](#lines-pandas-can-t-parse)
  * [2. IMPORTING DATA FROM EXCEL](#2-importing-data-from-excel)
    + [2.1 INTRODUCTION TO SPREADSHEETS](#21-introduction-to-spreadsheets)
      - [Loading Spreadsheets](#loading-spreadsheets)
      - [Exercise](#exercise)
    + [2.2 GETTING DATA FROM MULTIPLE WORKSHEETS](#22-getting-data-from-multiple-worksheets)
      - [Execise:](#execise-)
    + [2.3 MODIFY IMPORTS: TRUE/FALSE BOOLEANS](#23-modify-imports--true-false-booleans)
    + [2.4 MODIFY IMPORTS: PARSING DATES](#24-modify-imports--parsing-dates)
      - [Parsing Regular Dates](#parsing-regular-dates)
      - [Parsing Split up Dates](#parsing-split-up-dates)
      - [Non-Standard Dates](#non-standard-dates)
      - [Exercise](#exercise-1)
  * [3. IMPORTING DATA FROM DATABASES](#3-importing-data-from-databases)
    + [3.1 CONNECTING TO DATABASES](#31-connecting-to-databases)
      - [Exercise](#exercise-2)
    + [3.2 REFINING IMPORTS WITH SQL QUERIES](#32-refining-imports-with-sql-queries)
      - [Exercise](#exercise-3)
    + [3.3 MORE COMPLEX SQL QUERIES](#33-more-complex-sql-queries)
      - [Exercise](#exercise-4)
    + [3.4 LOADING MULTIPLE TABLES WITH JOINS](#34-loading-multiple-tables-with-joins)
      - [Exercise](#exercise-5)
  * [4. IMPORTING JSON DATA AND WORKING WITH API](#4-importing-json-data-and-working-with-api)
    + [4.1 INTRODUCTION TO JSON](#41-introduction-to-json)
      - [Exercise](#exercise-6)
    + [4.2 INTRODUCTION TO API](#42-introduction-to-api)
      - [requests() method](#requests---method)
      - [Parsing from Yelp API](#parsing-from-yelp-api)
    + [4.3 WORKING WITH NESTED JSON](#43-working-with-nested-json)
      - [Deeply Nested Data](#deeply-nested-data)
    + [4.4 COMBINING MULTIPLE DATASETS](#44-combining-multiple-datasets)
      - [Exercise](#exercise-7)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


## 1. IMPORTING FLAT FILES
### 1.1 DATA FRAMES
* Used for data analisys
* specific for dataframes - 2 dimensional data


<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/2%20-%20Streamlined%20data%20with%20pandas/fig%201%20-%20Dataframe.JPG?raw=true"/>   

fig 1 - Dataframes  

* you can work with many type of files
* most common are flat files like csv
* use same code to export any kind of csv

```PY
import pandas as pd
tax_data = pd.read_csv("file name.csv")

tax_data.head(4)
```
* Load other flat files like tsv with same read_csv

```py
import pandas as pd
tax_data = pd.read_csv("file name.tsv", sep="\t")
```

* Use pandas to viz some data
```py
# Plot the total number of tax returns by income group
counts = data.groupby("agi_stub").N1.sum()
counts.plot.bar()
plt.show()
```

### 1.2 MODIFY FLAT FILE IMPORTS  
If you have big dateframes, it is a good practice to reduce size to only needed data.  
#### Limit Columns with usecol
```py
col_names = ['Col1','Col2']  
tax_data = pd.read_csv("file_name.csv",
                         usecols = col_names)
```

#### Limit rows with nrows and skiprows
nrows - select the number of rows you want to see
skiprows - use to read chunks of data. Accept number, list of rows or function 
```py
tax_data = pd.read_csv("file_name.csv",
                         usecols = col_names,
                         nrows = 500,
                         skiprows = 1000,
                         header = None)
```

#### Assigning Column Names
use the parameter names to add names to the columns
```py
# col_names = list(tax_data_first rows) -> bring list names from an existing dataframe
col_names = ['Col1','Col2']  
tax_data = pd.read_csv("file_name.csv",
                         names = col_names)
```

#### Exercise - reading necessary columns
```py
# Create list of columns to use
cols = ['zipcode','agi_stub','mars1','MARS2','NUMDEP']

# Create data frame from csv using only selected columns
data = pd.read_csv("vt_tax_data_2016.csv", usecols = cols)

# View counts of dependents and tax returns by income level
print(data.groupby("agi_stub").sum())
```

#### Exercise - reading chuncks of data
```py
# Create data frame of next 500 rows with labeled columns
vt_data_next500 = pd.read_csv("vt_tax_data_2016.csv",
                              names = vt_data_first500 ,
                       		  nrows = 500,
                       		  skiprows = 500,
                       		  header = None
                       		  )

# View the Vermont data frames to confirm they're different
print(vt_data_first500.head())
print(vt_data_next500.head())
```

### 1.3 HANDLING ERRORS AND MISSING DATA
Common issues are:
* Columns data types is wrong
* missing Values
* Record that can't be read by pandas

#### Specify data types
Pandas automatically infers type if not specified
check types by:
```py
print(dataframe_name.dtypes)
```
change a type by using dtype, adding the parameters in key pair values:
```py
dataframe_name = pd.read_csv("file.csv", dtype={"Column_name": str })
print(dataframe_name.dtypes)
```
or
```py
# Create dict specifying data types for agi_stub and zipcode
data_types = {"agi_stub":"category",
			  "zipcode": str}

# Load csv using dtype to set correct data types
data = pd.read_csv("vt_tax_data_2016.csv", dtype=data_types)

# Print data types of resulting frame
print(data.dtypes.head())
```

#### Missing Datas
Pandas sometimes recognize NaN and null values, making easy to treat.  
But can't recognize dummy values (ex: someone or system apply some values to fill blank erroneously).  
Use na_values paramenter to convert a value in a column to NaN.
```py
# Create dict specifying that 0s in zipcode are NA values
null_values = {"zipcode":0}

# Load csv using na_values keyword argument
data = pd.read_csv("vt_tax_data_2016.csv", 
                   na_values = null_values)

# View rows with NA ZIP codes
print(data[data.zipcode.isna()])
```
#### Lines Pandas Can't Parse
you can ignore the lines causing parsing errors, or pass through it with warning by using the parameters:
* error_bad_lines = False   
* warn_bad_lines = True
```py
try:
  # Set warn_bad_lines to issue warnings about bad records
  data = pd.read_csv("vt_tax_data_2016_corrupt.csv", 
                     error_bad_lines=False, 
                     warn_bad_lines=True)
  
  # View first 5 records
  print(data.head())

# Case there are errors, you get the print below 
except pd.io.common.CParserError:
    print("Your data contained rows that could not be parsed.")
```
## 2. IMPORTING DATA FROM EXCEL
### 2.1 INTRODUCTION TO SPREADSHEETS
* Are excel files
* Organize like dataframes (row and columns)
* Support formulas
* Excel can have many spreadsheets

#### Loading Spreadsheets
* similar to csv with read_excel()  
* Excel usually have non taular data, like headers and formulas
* there are parameters to read excel to help skip rows like nrows, skiprows, usecols
* usecols accept a range of values in this case
 
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/2%20-%20Streamlined%20data%20with%20pandas/fig%202%20-%20Loading%20Excel.JPG?raw=true"/> 

fig 2 - Loading Excel

```py
survey_data = pd.read_excel ("file_name.xlsx",
                                skiprows = 2
                                usecols = "W:AB, AR"
                                )
```
#### Exercise
Create a string with the range columns to read from a CSV, then print the columns names
```py
# Create string of lettered columns to load
col_string = "AD, AW:BA"

# Load data with skiprows and usecols set
survey_responses = pd.read_excel("fcc_survey_headers.xlsx", 
                        skiprows = 2, 
                        usecols = col_string)

# View the names of the columns selected
print(survey_responses.columns)
```
### 2.2 GETTING DATA FROM MULTIPLE WORKSHEETS
* Excel can have multiple sheets
* Can contain charts and other visuals
* use argument sheet_name to choose the sheet
* sheets are loc by index starting in 0 or can call by name '2017'
* If sheets need different parameters, use multiple read calls
* To call all sheets, pass None to the parameter sheet_name, It creates a dictionary

#### Execise: 
Bring only the second sheet and plot vertical bar chart of count from JobPref column
```py
# Create df from second worksheet by referencing its position
responses_2017 = pd.read_excel("fcc_survey.xlsx",
                               sheet_name = 1)

# Graph where people would like to get a developer job
job_prefs = responses_2017.groupby("JobPref").JobPref.count()
job_prefs.plot.barh()
plt.show()
```

Bring all sheets and print the keys of each sheet:

```py
# Load all sheets in the Excel file
all_survey_data = pd.read_excel("fcc_survey.xlsx",
                                sheet_name = None)

# View the sheet names in all_survey_data
print(all_survey_data.keys())
```

Append all sheets from an excel, then print employment status

```py
# Create an empty data frame
all_responses = pd.DataFrame()

# Set up for loop to iterate through values in responses
for df in responses.values():
  # Print the number of rows being added
  print("Adding {} rows".format(df.shape[0]))
  # Append df to all_responses, assign result
  all_responses = all_responses.append(df)

# Graph employment statuses in sample
counts = all_responses.groupby("EmploymentStatus").EmploymentStatus.count()
counts.plot.barh()
plt.show()
```

### 2.3 MODIFY IMPORTS: TRUE/FALSE BOOLEANS
* Usually, booleans are interpreted as floats
* convert the booleand to bool by the argument dtype { "column" : bool}
* Still NaN, or yes/no are interpreted wrong, as True, mostly. Have to fix it.
Set the column to boolean and then check it
```py
# Set dtype to load appropriate column(s) as Boolean data
survey_data = pd.read_excel("fcc_survey_subset.xlsx",
                            dtype = {"HasDebt":bool})

# View financial burdens by Boolean group
print(survey_data.groupby("HasDebt").sum())
```

Convert yes and no to true or false in the "AttendeBootCampYesNo" Column:

```py
# Load file with Yes as a True value and No as a False value
survey_subset = pd.read_excel("fcc_survey_yn_data.xlsx",
                              dtype={"HasDebt": bool,
                              "AttendedBootCampYesNo": bool},
                              true_values = ['Yes'],
                              false_values = ['No'])

# View the data
print(survey_subset.head())
```

### 2.4 MODIFY IMPORTS: PARSING DATES
* Pandas stores dates and times in it own format
* It can be translated to string representations
* Pandas normally bring datetimes as string, use parse_date argument to specify date type
* parse_date accept, list of names or numbers, list of lists to be combined together as date

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/2%20-%20Streamlined%20data%20with%20pandas/fig%203%20-%20Datetime%20Table.JPG?raw=true"/> 

fig 3 - Datetime Table

#### Parsing Regular Dates 
```py
# Pass a list with datetime column names
date_cols = ['Date1','Date2']

# Load the file converting the date
survey_df = pd.read_excel("File.csv",
                            parse_dates = date_cols)
```

#### Parsing Split up Dates
Pass a list with date columns, then a list on the list as with the 2 columns
```py
# pass a dictionary instead a list to parse and control column names
date_cols = {'Date_renamed' : 'Date',
            'Time_renamed' : 'Time',
                'Datetime': ['Date','Time'] }

survey_df = pd.read_excel( "File.csv",
                            parse_dates = date_cols)

```
#### Non-Standard Dates
* parse_dates only works with standard formats
* use pd.to_datetitme() after laoding data, if parse_dates don't work
* use format codes:

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/2%20-%20Streamlined%20data%20with%20pandas/fig%204%20-%20Datetime%20Formatting.JPG?raw=true"/> 
fig 4 - Datetime Formatting

```py
# create a string with the desired format
format_string = "%m%d%Y %H:%M:%S"
# Apply the formatting to the column
survey_df["Column"] = pd.to_datetime(survey_df["Column"],
                                        format = format_string)
```

#### Exercise
Load file, with Part1StartTime parsed as datetime data and Print first few values of Part1StartTime:
```py
survey_data = pd.read_excel("fcc_survey.xlsx",
                            parse_dates = ['Part1StartTime'])

print(survey_data.Part1StartTime.head())
```

Create dict of columns to combine into new datetime column, then Load file, supplying the dict to parse_dates and View summary statistics about Part2Start

```py
datetime_cols = {"Part2Start": ["Part2StartDate","Part2StartTime"]}

survey_data = pd.read_excel("fcc_survey_dts.xlsx",
                            parse_dates = datetime_cols)

print(survey_data.Part2Start.describe())
```

## 3. IMPORTING DATA FROM DATABASES
* Data arranged into tables
* There are relationships via unique keys
* Support more data, usually have quality control
* use sql as language
* this course use SQLite, which store data like computer files

### 3.1 CONNECTING TO DATABASES
It is made in 2 steps:
* Conecting to the database
* Querying from it, with pandas, for ex, with sqlalchemy
How to use SQLAlchemy
* use create_engine() to make an engine the handle DB connections
* needs string to connect to DB 
* It follow a pattern depending on the database 
        For sqlite: *sqlite:///filename.db*
After, comes the second step, which is the query:
* Can query with pd.read_sql( query , engine)
* query is a string containing SQL query
* engine is the connection

#### Exercise
Import sqlalchemy's create_engine() function, Create the database engine and View the tables in the database
```py
from sqlalchemy import create_engine
engine = create_engine("sqlite:///data.db")
print(engine.table_names())
```

Load libraries, Create the database engine, Load hpd311calls without any SQL and View the first few rows of data

```py
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('sqlite:///data.db')

hpd_calls = pd.read_sql( 'hpd311calls' , engine)

print(hpd_calls.head())
```

Create the database engine, Create a SQL query to load the entire weather table, Load weather with the SQL query and View the first few rows of data

```py
engine = create_engine("sqlite:///data.db")
query = """
SELECT * 
  FROM weather;
"""
weather = pd.read_sql(query , engine)
print(weather.head())
```

### 3.2 REFINING IMPORTS WITH SQL QUERIES
* Select only columns quanted like usecol
* use where operator
* use comparing operator like > < <>
* Combine conditions with and / or

#### Exercise
Create database engine for data.db, then Write query to get date, tmax, and tmin from weather and Make a data frame by passing query and engine to read_sql. Pandas and sql alchemy are already loaded.
```py
engine = create_engine("sqlite:///data.db")

query = """
SELECT date, 
       tmax, 
       tmin
  FROM weather;
"""

temperatures = pd.read_sql(query,engine)
```

Create query to get hpd311calls records about safety, Query the database and assign result to safety_calls and Graph the number of safety calls by borough:

```py
query = """
SELECT *
FROM hpd311calls
WHERE complaint_type = 'SAFETY';
"""
safety_calls = pd.read_sql(query,engine)

call_counts = safety_calls.groupby('borough').unique_key.count()
call_counts.plot.barh()
```

### 3.3 MORE COMPLEX SQL QUERIES
* Get distinct values
* Aggregate functions: Sum, avg, Max...
* Aggregate by categories must use group by

#### Exercise
Create a query to get month and max tmax by month, Get data frame of monthly weather stats, View weather stats by month:
```py
query = """
SELECT month, 
       max(tmax),
       MIN(tmin),
       SUM(prcp)
  FROM weather 
  GROUP BY month;"""

weather_by_month = pd.read_sql(query, engine)

print(weather_by_month)
```

### 3.4 LOADING MULTIPLE TABLES WITH JOINS
* bring or join data tables by key values
* EX: join a table to other by date:
```sql
SELECT * FROM TABLE1 
    JOIN TABLE2 ON TABLE1.DATE = TABLE2.DATE
WHERE TABLE1.SALES > 0
```

#### Exercise
Modify query to join tmax and tmin from weather by date, Query database and save results as df and View first 5 records.
```py
query = """
SELECT hpd311calls.created_date, 
	   COUNT(*), 
       weather.tmax,
       weather.tmin
  FROM hpd311calls 
       JOIN weather
       ON hpd311calls.created_date = weather.date
 WHERE hpd311calls.complaint_type = 'HEAT/HOT WATER' 
 GROUP BY hpd311calls.created_date;
 """

df = pd.read_sql(query, engine)

print(df.head(5))
```
In this case we did not needed to use min or max in the tmax and tmin because they only have one value per row. Otherwise it would be necessary.
## 4. IMPORTING JSON DATA AND WORKING WITH API
### 4.1 INTRODUCTION TO JSON
* Based on javascript
* common web data format
* not tabular to make more efficient to storage
* Objects, collections of attributes
* use read_json() to read it, the parameter can be a file or URL ended in .json
* Pandas infer the structure according to json orientation that can be Record oriented or column oriented. column oriented reduce size.

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/2%20-%20Streamlined%20data%20with%20pandas/fig%205%20-%20JSON%20Object%20Oriented.JPG?raw=true"/>   

fig 5 - JSON Record Oriented

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/2%20-%20Streamlined%20data%20with%20pandas/fig%206%20-%20JSON%20Column%20Oriented.JPG?raw=true"/> 

fig 6 - JSON Column Oriented

* there are more orientation, like split.
* you can define the orientation in the argument orient
```py
import pandas as pd
dataframename = pd.read_json ("jasonname.json", orient = "split")
```

#### Exercise
Load the JSON with orient specified and split orient, Plot total population in shelters over time 
```py
 try:
     df = pd.read_json("dhs_report_reformatted.json",
                      orient = "split")
    
    df["date_of_census"] = pd.to_datetime(df["date_of_census"])
    df.plot(x="date_of_census", 
            y="total_individuals_in_shelter")
    plt.show()
    
except ValueError:
    print("pandas could not parse the JSON.")
```

### 4.2 INTRODUCTION TO API
* Applications Programing Interfaces
* Most common source of json
* Defined way to of an app communicate with other programs
* Way to get data from app without knowing database details
* It is like a catalogue, you send a resquest, and receive what you asked back
* There are libraries, we wil use requests

#### requests() method
* To get data from url use requests.get(url_string)
* Key arguments:
    * *param* : takes a dictionary or param to customize the request
    * *headers* : takes a dictionary and is also used to user authentication
* Result:
    * *response.json* : this return only the data in a dictionry that read_json() cannot read
    * need to convert to dataframe using pd.DataFrame()

#### Parsing from Yelp API

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/2%20-%20Streamlined%20data%20with%20pandas/fig%207%20-%20Yelp%20Documentation.JPG?raw=true"/> 

fig 7 - Yelp Documentation

```py
import pandas as pd
import requests

api_url = "https://api.yelp.com/v3/businesses/search"

# Get data about NYC cafes from the Yelp API
response = requests.get( api_url , 
                headers=headers, 
                params=params)

# Extract JSON data from the response
data = response.json()

# Load data to a data frame
cafes = pd.DataFrame(data["businesses"])

# View the data's dtypes
print(cafes.dtypes)
```

Above, the parameters headers and params where defined. Now, let's define it.
Create dictionary to query API for cafes in NYC, Create dictionary that passes Authorization and key string, Query the Yelp API with headers and params set, Extract JSON data from response and Load "businesses" values to a data frame and print head:
```py
import pandas as pd
import requests

api_url = "https://api.yelp.com/v3/businesses/search"

# Create dictionary to query API for cafes in NYC
parameters = { "term":"cafe",
          	   "location":"NYC"}

# Create dictionary that passes Authorization and key string
headers = {"Authorization" : "Bearer {}".format(api_key)}

# Query the Yelp API with headers and params set
response = requests.get( api_url,
                headers=headers,
                params = parameters)

# Extract JSON data from response
data = response.json()

# Load "businesses" values to a data frame and print head
cafes = pd.DataFrame(data["businesses"])
print(cafes.head())
```
check out documentation in: https://www.yelp.com/developers/documentation/v3/authentication

### 4.3 WORKING WITH NESTED JSON
* Nested lists and dictionaries
* pandas.io.json subpackage and json_normalize() method are used in this cases to flatten ou
* can change sep to use different separator in the parent column notation
```py
# we already set up API connection
bookstores = json_normalize(data["businesses"], sep = "_")
print(list(bookstores))
```

#### Deeply Nested Data
There are cases where data is nested in multiple levels. In this cases you can specify the path in order to extract the data by using the following parameters in json_normalize:
* *record_path* : string/list of strings attributes to nested data
* *meta* : list of other attributes to load to data frame
* *meta_prefix* : string to prefix to meta column names
```py
df = json_normalize(data["businesses"],
                        ser = "_",
                        record_path = "categories",
                        meta = ["name",
                                "alias",
                                "rating",
                                ["coordinates","latitude"],
                                ["coordinates","longitude"]],
                        meta_prefix = "biz_"
                        )
```

### 4.4 COMBINING MULTIPLE DATASETS
* append: Used to add row from on df to another
* Paramenter ignore_index = True in case you want to renumber the index
```py
df1.append(df2)
```
* Merging: Used to combine data via shared key
```py
df.merge()
```
* Arguments: second DF, columns to merge on,  left_on key and right_on kwy
* Key columns must be the same datatype 

#### Exercise
Merge crosswalk into cafes on their zip code fields, then  Merge pop_data into cafes_with_pumas on puma field, and View the data
```py
cafes_with_pumas = cafes.merge(crosswalk,
                                left_on = "location_zip_code",
                                right_on = "zipcode")

cafes_with_pop = cafes_with_pumas.merge(pop_data,
                                        left_on = "puma",
                                        right_on = "puma")

print(cafes_with_pop.head())
```
