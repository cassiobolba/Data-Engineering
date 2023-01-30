# Snowflake

# Getting Started 

## Criar Account
- explicar as difrencas 
- enquanto espera o email mostrar por cima as docs

## Acessar a instancia
- url
- login app.snowflake.com enter the instance name
- save the link to login to your account
- mostrar onde no painel pegar o account name

## Snowsight - UI
- sheets - executa código, pode organizar, estilo notebook
- databases - dbs que tem acesso
- se nao tiver acesso as samples:
```sql
-- Create a database from the share.
create database snowflake_sample_data from share sfc_samples.sample_data;

-- Grant the PUBLIC role access to the database.
-- Optionally change the role name to restrict access to a subset of users.
grant imported privileges on database snowflake_sample_data to role public;
	we can’t run, because no warehouse
```

## Architecture Basics
https://docs.snowflake.com/en/user-guide/intro-key-concepts.html
- 3 layers
- storage: columnar compressed data stored in object storage (if - selected AWS, S3)
- query processing: virtual WH are servers
    - Various sizes XS (1 - server)  to 4XL (128 servers) that are independent
    - Billed by - credit (1 server = 1 credit) billed by second (min 1min). Can - use multi cluster to increase WH number during usage peak
- cloud provider: chooses provider that manages various activities to run snowflake

## Set up Warehouse - UI
- Admin > Warehouse >
- nome padrao > TEAM_NAME_WH
- size
- Query Accelation: Dynamic Scalling for specific situation custa mais)
- Multi-cluster Warehouse: scale computer resource as query need change
    - scaling policy: Standard andd Economy
- auto resume
- auto suspend after x min
- warehouse type: Standard and Snowpark (optimized for large queries and ML models)

### Create WH with SQL
```sql
CREATE OR REPLACE WAREHOUSE COMPUTE_WH
WITH
    WAREHOUSE_SIZE=XSMALL
    MAX_CLUSTER_COUNT=2
    AUTO_SUSPEND=300
    AUTO_RESUME=TRUE
    COMMENT='BLA BLA'
```

## Scaling Policy
- In multi cluster we can start dinamically more nodes to scale according to needs
- use case:
    - more user at certain times
    - more queries being run
- if we have more queries, is better to increse warehosuse size
- when to start scaling?
- Standard
    - favor in perfomance, not in saving credits
    - it minimize queues and start more clusters to reduce it
    - start when either a query is queued or when there are more queries than it can execute
    - stops when 2 or 3 sucessful checks (every 1mni is a check)
- Economy
    - in favor of saving credits
    - it will first fully load clusters and save credits
    - can result in longer query times
    - starts when it detects there aret enough query to keep cluester running for at least 6 minutes
    - after 5 or 6 checks

## Databases
- can create table and schema via UI
- can set privileges

## Load Data
- follow the scripts

# Snowflake Architecture

## Data Warehouse
- consolidate data for analysis and reporting
- consolidate many and differente sources via ETL 

## Cloud Computing
- before was necessary to have data center
- build the infrastructure, secutiry, electricy, cooling, hardware and software upgrades
- Now, with cloud we use SaaS
- in snowflake you just responsible for the application, all undelying resourcers are now managed by cloud
    - cloud respo: physical machine, virtual machine, storage
    - snowflake resp: opearting system, data, software
    - user (us): application, a DW

## Snowflake Editions
look for link with comparation image    
https://docs.snowflake.com/en/user-guide/intro-editions.html

### Standard
introductory level
- Complete DWH
- Automatic Encryption
- Time travel up to 1 day
- Disaster Recovery for 7 days beyond time travel
- Secure Data Share
- Premier Support 24/7

### Enterprise
- All standard
- Multi-cluster WH
- time travel up to 90 days
- materialized views
- search optimization
- column-level secutiry

### Busdiness Critical
higher level of protection for very critical 
- all enterprise
- data encryption everywhere
- extended support
- DB failover and recovery

### Virtual Private
- All business critical
- dedicated servers and completely separate snowflake environment

## Pricing
https:--www.snowflake.com/pricing/
- Pay as you go
- scalable amount of sotrage at affordable pice
- pricing depending on the region
- compute and storage costs decoupled

### Storage
- Monthly sotrage cost
- based on avg storage used per month
- cost calculated after compression
- charged in the cloud providers

### Compute
- per active WH hours
- dependes on WH sizes
- billed per second (min 1 min)
- charged in snowflake credits
- buy credits
- prices vary on region and cloud provider
- in US East: 
    - standard $2 / credit
    - enterprise $3/ credit
    - business critical $4/ credit
- In frankfurt
    - $2.7
    - 4
    - 5
- really important to select WH size based on complexity and workload

### Storage
- 2 options
- On demand:
    - pay what use 
    - ie: $45/ TB
- Capacity Storage
    - Pay a defined capacity upfront
    - ie: $23 / TB
- Example: We think we need 1TB  

| **Scenaio** | **On Demand** | **Capacity Storage** |
|-------------|---------------|----------------------|
| use 100gb | 0.1TB x $40 = $4| 1TB x $23 = $23  |
| use 800gb | 0.8TB x $40 = $32| 1TB x $23 = $23 |

### Recomendation
- Start with On Demand
- Once you are sure the amount used, moce to capacity storage

## Monitor Usage
- Via UI select Admin role > Admin tab > Usage > select warehouse > shoudl see dashboard
- see breaks by compute, storage (DB, fail safe, stage), day / hour
- Datatransfer: when take data out of SF you pay
- data ingested from cloud is not payied 
- data transfer is not charged withing organization

## Roles
5 pre defined roles
- ACCOUNTADMIN: can do all that opther roles do
- SECURITYADMIN: Do all USERADMIN can, manage users and roles, manage any object grant globally
- SYSADMIN: create WH and DB, recommended all custom roles are assigned this
- USERADMIN: dedicated to user and role management only, create roles and users
- PUBLIC: all user have this access, create own objects like other roles



# Loading Data

## Loading Methods
- Bulk Loading
    - Most used method
    - use warehouses
    - loading from stages
    - using copy command
    - transformations possible
- Continuous Loading
    - designated to load small volumes
    - automatically once they are added to stages
    - Lates results for analysis
    - Snowpipe (serverless feature)


## Stages
- Not to be confused with staging area
- Stages are location fo data files where data can be loaded from
- 2 types
- External Stage
    - most common
    - external cloud providers (GCP,AWS)
    - is a database object created in schema
    - CREATE STAGE (URL, access_settings)
    - can have aditional costs if region or platforms differ
- Internal Stages
    - Local storage maintended by snowflake

## Creating a Stage
```sql
-- Database to manage stage objects, fileformats etc.
CREATE OR REPLACE DATABASE MANAGE_DB;

CREATE OR REPLACE SCHEMA external_stages;

-- Creating external stage
-- this is not the best practice to authenticate to a stage
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3:--bucketsnowflakes3'
    credentials=(aws_key_id='ABCD_DUMMY_ID' aws_secret_key='1234abcd_key');
-- Description of external stage
DESC STAGE MANAGE_DB.external_stages.aws_stage; 
    
-- Alter external stage   
ALTER STAGE aws_stage
    SET credentials=(aws_key_id='XYZ_DUMMY_ID' aws_secret_key='987xyz');
    
-- Publicly accessible staging area, no need for credentials 
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3:--bucketsnowflakes3';

-- List files in stage
LIST @aws_stage;

--Load data using copy command
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*';
```

## COPY command
- Use the copy command to copy data from stage to a table
- create a table first, to copy data from stage
```sql
-- Creating ORDERS table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS;
   
-- First copy command
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @aws_stage
    file_format = (type = csv field_delimiter=',' skip_header=1);

-- Copy command with fully qualified stage object
-- can use wildcards on files names also
-- snowflake collects metadata and will not upload 2 times the same data
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    --files = ('OrderDetails.csv')
    pattern = '.*Order.*[.]csv'
    ;
```

## Transforming with COPY
```sql
-- Transforming using the SELECT statement
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM (select s.$1, s.$2 from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');

--Example 1 - Table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT
    )
   
   
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
   
--Example 2 - Table    
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    PROFITABLE_FLAG VARCHAR(30)
  
    )

--Example 2 - Copy Command using a SQL function (subset of functions available)
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            CASE WHEN CAST(s.$3 as int) < 0 THEN 'not profitable' ELSE 'profitable' END 
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');


SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX

--Example 3 - Table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    CATEGORY_SUBSTRING VARCHAR(5)
  
    )

--Example 3 - Copy Command using a SQL function (subset of functions available)
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            substring(s.$5,1,5) 
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');


SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

--Example 3 - Table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    PROFITABLE_FLAG VARCHAR(30)
  
    )

--Example 4 - Using subset of columns
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX (ORDER_ID,PROFIT)
    FROM (select 
            s.$1,
            s.$3
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');

SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

--Example 5 - Table Auto increment
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID number autoincrement start 1 increment 1,
    AMOUNT INT,
    PROFIT INT,
    PROFITABLE_FLAG VARCHAR(30)
    )

--Example 5 - Auto increment ID
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX (PROFIT,AMOUNT)
    FROM (select 
            s.$2,
            s.$3
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');


SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX WHERE ORDER_ID > 15;

DROP TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX
```

## COPY ON_ERROR
- example, deal with type format error
- in this error, it suggest to use on_error option
- ON_ERROR = 'CONTINUE'
    - you see where the error occured
- default ON_ERROR = 'ABORT'
    - if error occur, ti stops all operations, even for good files with no error
- ON_ERROR = 'SKIP_FILE'    
    - skip only the file with error, other files are included
    - can use SKIP_FILE_<number> where number is the number of errors accepted, if there are more errors than that, file is skipped.
    - can also use a percentage like SKIP_FILE_%3 , if there are more than 3% of line with error, skip the file then

```sql
-- Create new stage
 CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage_errorex
    url='s3:--bucketsnowflakes4';
 
-- List files in stage
 LIST @MANAGE_DB.external_stages.aws_stage_errorex;
 
-- Create example table
 CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
 
-- Demonstrating error message
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
     file_format= (type = csv field_delimiter=',' skip_header=1)
     files = ('OrderDetails_error.csv');
    
 -- Validating table is empty    
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX  ;  
    
-- Error handling using the ON_ERROR option
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'CONTINUE';
    
  -- Validating results and truncating table 
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
SELECT COUNT(*) FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;

-- Error handling using the ON_ERROR option = ABORT_STATEMENT (default)
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'ABORT_STATEMENT';


  -- Validating results and truncating table 
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
SELECT COUNT(*) FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;

-- Error handling using the ON_ERROR option = SKIP_FILE
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE';
     
  -- Validating results and truncating table 
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
SELECT COUNT(*) FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;    
    
-- Error handling using the ON_ERROR option = SKIP_FILE_<number>
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE_2';    
     
-- Validating results and truncating table 
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;
SELECT COUNT(*) FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

TRUNCATE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX;    

-- Error handling using the ON_ERROR option = SKIP_FILE_<number>
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = 'SKIP_FILE_3%'; 
  
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS_EX;

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv','OrderDetails_error2.csv')
    ON_ERROR = SKIP_FILE_3 
    SIZE_LIMIT = 30;
```

## FILE_FORMAT object
- Can create a file format as object and reuse it
- best practice to save file formats
    - create a schema
```sql
-- Specifying file_format in Copy command
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

-- Creating table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));    
    
-- Creating schema to keep things organized
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;

-- Creating file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format;

-- See properties of file format object
DESC file format MANAGE_DB.file_formats.my_file_format;

-- Using file format object in Copy command       
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

-- Altering file format object
ALTER file format MANAGE_DB.file_formats.my_file_format
    SET SKIP_HEADER = 1;
    
-- Defining properties on creation of file format object   
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format
    TYPE=JSON,
    TIME_FORMAT=AUTO;    
    
-- See properties of file format object    
DESC file format MANAGE_DB.file_formats.my_file_format;   

-- Using file format object in Copy command       
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

-- Altering the type of a file format is not possible
ALTER file format MANAGE_DB.file_formats.my_file_format
SET TYPE = CSV;

-- Recreate file format (default = CSV)
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format

-- See properties of file format object    
DESC file format MANAGE_DB.file_formats.my_file_format;   

-- Truncate table
TRUNCATE table OUR_FIRST_DB.PUBLIC.ORDERS_EX;

-- Overwriting properties of file format object      
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM  @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (FORMAT_NAME= MANAGE_DB.file_formats.my_file_format  field_delimiter = ',' skip_header=1 )
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

DESC STAGE MANAGE_DB.external_stages.aws_stage_errorex;
```

# COPY options

## Understanding copy options
The basics we already have seen:
```sql
COPY INTO <table name>
FROM externalStage
FILES = ( 'file 1','file 2')
FILE_FORMAT = <file format name>
ON_ERROR = CONTINUE
```

## VALIDATION_MODE
- when using, it does not copy any data, just validate
- return_erros print row with errors
- return_n_rows print the n rows and test these rows, fail at first error (if any)

```sql
---- VALIDATION_MODE ----
-- Prepare database & table
CREATE OR REPLACE DATABASE COPY_DB;

CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

-- Prepare stage object
CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/size/';
  
LIST @COPY_DB.PUBLIC.aws_stage_copy;
  
 --Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;
    
SELECT * FROM ORDERS;    
    
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
   VALIDATION_MODE = RETURN_5_ROWS ;

--- Use files with errors ---

create or replace stage copy_db.public.aws_stage_copy
    url ='s3://snowflakebucket-copyoption/returnfailed/';
    
list @copy_db.public.aws_stage_copy;

-- show all errors --
copy into copy_db.public.orders
    from @copy_db.public.aws_stage_copy
    file_format = (type=csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    validation_mode=return_errors;

-- validate first n rows --
copy into copy_db.public.orders
    from @copy_db.public.aws_stage_copy
    file_format = (type=csv field_delimiter=',' skip_header=1)
    pattern='.*error.*'
    validation_mode=return_1_rows;
```

## Working with rejected values
there are 2 ways of retrieving the errors that have occured:   
Method 1:
    - use validation_mode = return_errors
    - this just print the errors
    - create a table 'rejected' as select * from (result_scan(last_query_id()))

```sql
--- SETUP
---- Use files with errors ----
CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/returnfailed/';

LIST @COPY_DB.PUBLIC.aws_stage_copy;    

COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;

COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_1_rows;
    
-------------- Working with error results -----------
---- 1) Saving rejected files after VALIDATION_MODE ---- 
CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;

--Storing rejected /failed results in a table
CREATE OR REPLACE TABLE rejected AS 
select rejected_record from table(result_scan(last_query_id()));

-- Adding additional records --
INSERT INTO rejected
select rejected_record from table(result_scan(last_query_id()));

SELECT * FROM rejected;
```
Method 2:   
- use ON_ERROR=CONTINUE instead of validation
- then select * from table(validate(orders, job_id => '_last') or insert into a tables this data
- it will only save in rejected the data with errors, and the good data will go to

```sql
---- 2) Saving rejected files without VALIDATION_MODE ---- 
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    ON_ERROR=CONTINUE;
   
select * from table(validate(orders, job_id => '_last'));
```
### Dealing with errors
- After saving the errors to another table we can easily tream them
- since the reject values were not transformed in columns, we need to do it with the query below
- other options is to return these values to responsible people in source 

```sql
---- 3) Working with rejected records ---- 
SELECT REJECTED_RECORD FROM rejected;

CREATE OR REPLACE TABLE rejected_values as
SELECT 
SPLIT_PART(rejected_record,',',1) as ORDER_ID, 
SPLIT_PART(rejected_record,',',2) as AMOUNT, 
SPLIT_PART(rejected_record,',',3) as PROFIT, 
SPLIT_PART(rejected_record,',',4) as QUATNTITY, 
SPLIT_PART(rejected_record,',',5) as CATEGORY, 
SPLIT_PART(rejected_record,',',6) as SUBCATEGORY
FROM rejected; 

SELECT * FROM rejected_values;
```

## Other COPY Options
- SIZE_LIMIT = 20000 
    - limit value in kb
    - size limit for all files combined
    - a file will always be loaded completely]
    - ie: 3 files with 20000 size each, we set the limit to 30000. First 2 files are fully loaded, but 3rd is not, because loading the 2nd file exceeded the limit
- RETURN_FAILED_ONLY = TRUE | FALSE
    - useful together with ON_ERROR = CONTINUE
    - default is false
    - set to true ( with continue ) and returns only the tables names tahat had erros, thus you can focus on only on it
- TRUNCATECOLUMNS = TRUE | FALSE
    - IE: COLUMN type is varchar 10, then we try to insert a 12 char string, it will cause error
    - set this parameter to true to truncate the 12 char value  to 10 char and have no error
- FORCE = TRUE | FALSE 
    - Force a file to be copied again even tought has already been copied
    - can lead to uplicated values

## Check COPY history
- INFROMATION_SCHEMA.load_history view
    - in the DB you are copying data, go to INFROMATION_SCHEMA.load_history view
    - can see file names, load files, size, rows loaded...
    - this shows the history since the table creation
    - maybe the table was recreate, then we need next approach

- SNOWFLAKE.ACCOUNT_USAGE.LOAD_HISTORY
    - this has global table info
    - each table has one table_id and we can compare other tables 

# Load Unstructured Data
## Unstructure data example
in the example below we have dictionary, nested dictionary (job), array of dictionaries, array of values
```json
{
   "id":12,
   "first_name":"Isahella",
   "last_name":"Leadbeatter",
   "gender":"Female",
   "city":"Koncang",
   "job":{
      "title":"Structural Engineer",
      "salary":13500
   },
   "spoken_languages":[
      {
         "language":"Hindi",
         "level":"Basic"
      },
      {
         "language":"Portuguese",
         "level":"Advanced"
      },
      {
         "language":"Luxembourgish",
         "level":"Expert"
      }
   ],
   "prev_company":[
      "Walker, O'Hara and Graham",
      "Turcotte, Crist and Rodriguez",
      "Blanda LLC"
   ]
},
```
recomended process to deal with unstructured data:
- create stage
- load raw data (as variant)
- analyse and parse
- flatten and load

## Creating Stage and Loading Raw
```sql
--First step: Load Raw JSON
CREATE OR REPLACE stage MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
     url='s3://bucketsnowflake-jsondemo';

CREATE OR REPLACE file format MANAGE_DB.FILE_FORMATS.JSONFORMAT
    TYPE = JSON;
    
    
CREATE OR REPLACE table OUR_FIRST_DB.PUBLIC.JSON_RAW (
    raw_file variant);
    
COPY INTO OUR_FIRST_DB.PUBLIC.JSON_RAW
    FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    file_format= MANAGE_DB.FILE_FORMATS.JSONFORMAT
    files = ('HR_data.json');
    
   
SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;
```

## Parse JSON
- access jason values and casting

```sql
--Second step: Parse & Analyse Raw JSON 
--Selecting attribute/column

SELECT RAW_FILE:city FROM OUR_FIRST_DB.PUBLIC.JSON_RAW

SELECT $1:first_name FROM OUR_FIRST_DB.PUBLIC.JSON_RAW

--Selecting attribute/column - formattted
SELECT RAW_FILE:first_name::string as first_name  FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT RAW_FILE:id::int as id  FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:last_name::STRING as last_name,
    RAW_FILE:gender::STRING as gender

FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

--Handling nested data   
SELECT RAW_FILE:job as job  FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;
```

## Parsing Nested Data
- dot notation
- accesing values in array

```sql
--Handling nested data 
SELECT RAW_FILE:job as job  FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

-- dot notation
SELECT 
      RAW_FILE:job.salary::INT as salary
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT 
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:job.salary::INT as salary,
    RAW_FILE:job.title::STRING as title
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


--Handling arrays
SELECT
    RAW_FILE:prev_company as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;
-- indices 
SELECT
    RAW_FILE:prev_company[1]::STRING as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;
-- count the number of companies a person worked
SELECT
    ARRAY_SIZE(RAW_FILE:prev_company) as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;

-- combining 2 values from the array
SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:prev_company[0]::STRING as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:prev_company[1]::STRING as prev_company
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
ORDER BY id
```

## Dealing with Hierarchy
- accessing nester json
- accessing array values
- using table and flatten in a column

```sql
-- check the spoken language structure -> array of dictionaries
SELECT 
    RAW_FILE:spoken_languages as spoken_languages
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;
-- fetching the 1st spoken languages
SELECT 
    RAW_FILE:first_name::STRING as first_name,
    RAW_FILE:spoken_languages[0] as First_language
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;
-- entenring each element in the array to get the language and level
SELECT 
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[0].language::STRING as First_language,
    RAW_FILE:spoken_languages[0].level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW


-- usgin the inneficient and not correct way of unioning 
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[0].language::STRING as First_language,
    RAW_FILE:spoken_languages[0].level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[1].language::STRING as First_language,
    RAW_FILE:spoken_languages[1].level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
UNION ALL 
SELECT 
    RAW_FILE:id::int as id,
    RAW_FILE:first_name::STRING as First_name,
    RAW_FILE:spoken_languages[2].language::STRING as First_language,
    RAW_FILE:spoken_languages[2].level::STRING as Level_spoken
FROM OUR_FIRST_DB.PUBLIC.JSON_RAW
ORDER BY ID


-- CORRECT OPTION
select
      RAW_FILE:first_name::STRING as First_name,
    f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;
```

## Insert Final Data
We have a couple options
```sql
--Option 1: CREATE TABLE AS
CREATE OR REPLACE TABLE Languages AS
select
      RAW_FILE:first_name::STRING as First_name,
    f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;

SELECT * FROM Languages;

truncate table languages;

--Option 2: INSERT INTO
INSERT INTO Languages
select
      RAW_FILE:first_name::STRING as First_name,
    f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(RAW_FILE:spoken_languages)) f;

SELECT * FROM Languages;
```

## Querying PARQUET file
Usually done in 2 steps
    - first open the parquet file to see the structure (in case unknown)
    - copy the structure and parse it

```sql
--Create file format and stage object  
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT
    TYPE = 'parquet';

CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
    url = 's3://snowflakeparquetdemo'   
    FILE_FORMAT = MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT;
    
--Preview the data  
LIST  @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;   
    
SELECT * FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;
    

-- File format in Queries
-- if not specify file format on stage creation
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
    url = 's3://snowflakeparquetdemo'  

-- specify during the table read with    
SELECT * 
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
(file_format => 'MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT')


--Querying with conversions and aliases    
SELECT 
$1:__index_level_0__::int as index_level,
$1:cat_id::VARCHAR(50) as category,
DATE($1:date::int ) as Date,
$1:"dept_id"::VARCHAR(50) as Dept_ID,
$1:"id"::VARCHAR(50) as ID,
$1:"item_id"::VARCHAR(50) as Item_ID,
$1:"state_id"::VARCHAR(50) as State_ID,
$1:"store_id"::VARCHAR(50) as Store_ID,
$1:"value"::int as value
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;
```

## Loading PARQUET data

We can also add some metadata
```sql
--Adding metadata
SELECT 
$1:__index_level_0__::int as index_level,
$1:cat_id::VARCHAR(50) as category,
DATE($1:date::int ) as Date,
$1:"dept_id"::VARCHAR(50) as Dept_ID,
$1:"id"::VARCHAR(50) as ID,
$1:"item_id"::VARCHAR(50) as Item_ID,
$1:"state_id"::VARCHAR(50) as State_ID,
$1:"store_id"::VARCHAR(50) as Store_ID,
$1:"value"::int as value,
METADATA$FILENAME as FILENAME,
METADATA$FILE_ROW_NUMBER as ROWNUMBER,
TO_TIMESTAMP_NTZ(current_timestamp) as LOAD_DATE
FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE;

SELECT TO_TIMESTAMP_NTZ(current_timestamp);


--Create destination table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.PARQUET_DATA (
    ROW_NUMBER int,
    index_level int,
    cat_id VARCHAR(50),
    date date,
    dept_id VARCHAR(50),
    id VARCHAR(50),
    item_id VARCHAR(50),
    state_id VARCHAR(50),
    store_id VARCHAR(50),
    value int,
    Load_date timestamp default TO_TIMESTAMP_NTZ(current_timestamp)
    )

--Load the parquet data 
COPY INTO OUR_FIRST_DB.PUBLIC.PARQUET_DATA
    FROM (SELECT 
            METADATA$FILE_ROW_NUMBER,
            $1:__index_level_0__::int,
            $1:cat_id::VARCHAR(50),
            DATE($1:date::int ),
            $1:"dept_id"::VARCHAR(50),
            $1:"id"::VARCHAR(50),
            $1:"item_id"::VARCHAR(50),
            $1:"state_id"::VARCHAR(50),
            $1:"store_id"::VARCHAR(50),
            $1:"value"::int,
            TO_TIMESTAMP_NTZ(current_timestamp)
        FROM @MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE);
        
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.PARQUET_DATA;
```

# PERFORMANCE OPTIMIZATION

## Performance in Snowflake
- a little bit different then traditional databases
- usually to save costs and make faster queries
- WE DO NOT DO LIKE THE TRADICIONAL WAY
    - Indexes
    - table aprtitions
    - analyze execution plan
    - remove unecessary full table scans
- Snowflake have Auto managed micro parittions
- Normal optmizations in SF:
    - type data
    - size virtual warehouses according to workloads
    - scaling up for known work load
    - scaling out dinamically for unknown work load
    - maximize automatic cache
    - cluster keys for larger tables