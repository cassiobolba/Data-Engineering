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
https:--docs.snowflake.com/en/user-guide/intro-key-concepts.html
- 3 layers
- storage: columnar compressed data stored in object storage (if - selected AWS, S3)
- query processing: virtual WH are servers
    - Various sizes XS (1 - server)  to 4XL (128 servers) that are independent
    - Billed by - credit (1 server = 1 credit) billed by second (min 1min). Can - use multi cluster to increase WH number during usage peak
- cloud provider: chooses provider that manages various activities to run snowflake

## Set uo Warehouse - UI
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
https:--docs.snowflake.com/en/user-guide/intro-editions.html

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