# Snowflake

- [Getting Started](#getting-started)
  * [Criar Account](#criar-account)
  * [Acessar a instancia](#acessar-a-instancia)
  * [Snowsight - UI](#snowsight---ui)
  * [Architecture Basics](#architecture-basics)
  * [Set up Warehouse - UI](#set-up-warehouse---ui)
    + [Create WH with SQL](#create-wh-with-sql)
  * [Scaling Policy](#scaling-policy)
  * [Databases](#databases)
  * [Load Data](#load-data)
- [Snowflake Architecture](#snowflake-architecture)
  * [Data Warehouse](#data-warehouse)
  * [Cloud Computing](#cloud-computing)
  * [Snowflake Editions](#snowflake-editions)
    + [Standard](#standard)
    + [Enterprise](#enterprise)
    + [Busdiness Critical](#busdiness-critical)
    + [Virtual Private](#virtual-private)
  * [Pricing](#pricing)
    + [Storage](#storage)
    + [Compute](#compute)
    + [Storage](#storage-1)
    + [Recomendation](#recomendation)
  * [Monitor Usage](#monitor-usage)
  * [Roles](#roles)
- [Loading Data](#loading-data)
  * [Loading Methods](#loading-methods)
  * [Stages](#stages)
  * [Creating a Stage](#creating-a-stage)
  * [COPY command](#copy-command)
  * [Transforming with COPY](#transforming-with-copy)
  * [COPY ON_ERROR](#copy-on-error)
  * [FILE_FORMAT object](#file-format-object)
- [COPY options](#copy-options)
  * [Understanding copy options](#understanding-copy-options)
  * [VALIDATION_MODE](#validation-mode)
  * [Working with rejected values](#working-with-rejected-values)
    + [Dealing with errors](#dealing-with-errors)
  * [Other COPY Options](#other-copy-options)
  * [Check COPY history](#check-copy-history)
- [Load Unstructured Data](#load-unstructured-data)
  * [Unstructure data example](#unstructure-data-example)
  * [Creating Stage and Loading Raw](#creating-stage-and-loading-raw)
  * [Parse JSON](#parse-json)
  * [Parsing Nested Data](#parsing-nested-data)
  * [Dealing with Hierarchy](#dealing-with-hierarchy)
  * [Insert Final Data](#insert-final-data)
  * [Querying PARQUET file](#querying-parquet-file)
  * [Loading PARQUET data](#loading-parquet-data)
- [PERFORMANCE OPTIMIZATION](#performance-optimization)
  * [Performance in Snowflake](#performance-in-snowflake)
  * [Dedicated Warehouses](#dedicated-warehouses)
  * [Implement Dedicated WH](#implement-dedicated-wh)
  * [Scalling Up / Down](#scalling-up---down)
  * [Scaling Out](#scaling-out)
  * [Caching](#caching)
    + [Maximizing Cache](#maximizing-cache)
  * [Clustering](#clustering)
    + [When and how to cluster](#when-and-how-to-cluster)
    + [CLUSTER DEMO](#cluster-demo)
- [Loading from Cloud Provider](#loading-from-cloud-provider)
  * [Loading the data](#loading-the-data)
- [Snowpipe](#snowpipe)
  * [What is it?](#what-is-it-)
  * [Steps to Create](#steps-to-create)
  * [Creating the Stage](#creating-the-stage)
  * [Creating the PIPE](#creating-the-pipe)
  * [Creating Notification](#creating-notification)
  * [Error Handling](#error-handling)
  * [Managing Pipes](#managing-pipes)
- [TIME TRAVEL](#time-travel)
  * [Time travel Functions](#time-travel-functions)
  * [Restoring the data](#restoring-the-data)
  * [Undrop Table / Schema / Database](#undrop-table---schema---database)
  * [Retention Period](#retention-period)
  * [Time Travel Cost](#time-travel-cost)
- [FAIL SAFE](#fail-safe)
  * [What is Fail Safe](#what-is-fail-safe)
  * [Continuous Data Protection Lifecycle](#continuous-data-protection-lifecycle)
  * [Fail Safe Storage](#fail-safe-storage)
- [TABLE TYPES](#table-types)
  * [The types](#the-types)
  * [Permanent Tables](#permanent-tables)
  * [Transient Tables](#transient-tables)
  * [Temporary Tables](#temporary-tables)
- [ZERO-COPY CLONING](#zero-copy-cloning)
  * [What is Zero-Copy Cloning?](#what-is-zero-copy-cloning-)
  * [Cloning Tables](#cloning-tables)
  * [Cloning Schemas & Databases](#cloning-schemas---databases)
  * [Cloning with Time Travel](#cloning-with-time-travel)
  * [Swapping Tables](#swapping-tables)
- [DATA SHARING](#data-sharing)
  * [What is Data Sharing](#what-is-data-sharing)
  * [Data share via SQL](#data-share-via-sql)
  * [Data share via UI](#data-share-via-ui)
  * [Share with non SF user](#share-with-non-sf-user)
  * [Crate a Reader Account - Managed Account](#crate-a-reader-account---managed-account)
  * [Create a DB from Share](#create-a-db-from-share)
  * [Create Users to share](#create-users-to-share)
  * [Sharing DB and Schema](#sharing-db-and-schema)
  * [Secure vs Normal view](#secure-vs-normal-view)
  * [Share a Secure View](#share-a-secure-view)
- [DATA SAMPLING](#data-sampling)
  * [Why we need Data Sampling?](#why-we-need-data-sampling-)
  * [Sampling Methods](#sampling-methods)
  * [Sampling the data](#sampling-the-data)
- [SCHEDULING TASKS](#scheduling-tasks)
  * [Understangin tasks](#understangin-tasks)
  * [Creating tasks](#creating-tasks)
  * [Using Cron](#using-cron)
  * [Trees of tasks](#trees-of-tasks)
  * [Creating Tree of tasks](#creating-tree-of-tasks)
  * [Calling a Stored Procedure](#calling-a-stored-procedure)
  * [Task History and Error Handling](#task-history-and-error-handling)
  * [Task with Conditions](#task-with-conditions)
- [STREAMS](#streams)
  * [What are Streams](#what-are-streams)
  * [Insert Operation](#insert-operation)
  * [Update Operation](#update-operation)
  * [Delete Operation](#delete-operation)
  * [Process All Data Changes](#process-all-data-changes)
  * [Combo: Streams + Tasks](#combo--streams---tasks)
  * [Types of Streams](#types-of-streams)
  * [Changes Clause](#changes-clause)
- [MATERIALIZED VIEWS](#materialized-views)
  * [What are Materialized views ?](#what-are-materialized-views--)
  * [Using Materialized view](#using-materialized-view)
  * [Refresh MA](#refresh-ma)
  * [Costs](#costs)
  * [When to use MV](#when-to-use-mv)
  * [MV Liimitations](#mv-liimitations)
- [DYNAMIC DATA MASKING](#dynamic-data-masking)
  * [What is Data Masking](#what-is-data-masking)
  * [Creating a Masking Policy](#creating-a-masking-policy)
  * [Unset and Replace Policy](#unset-and-replace-policy)
  * [Alter an Existing Policy](#alter-an-existing-policy)
  * [Masking Examples](#masking-examples)
- [ACCESS MANAGEMENT](#access-management)
  * [What is Access Management](#what-is-access-management)
    + [Key Concepts](#key-concepts)
  * [Snowflake Roles Overview](#snowflake-roles-overview)
  * [ACCOUNTADMIN](#accountadmin)
  * [ACCOUNTADMIN in practice](#accountadmin-in-practice)
  * [SECUTIRYADMIN](#secutiryadmin)
  * [SECUTIRYADMIN in Practice](#secutiryadmin-in-practice)
  * [SYSADMIN](#sysadmin)
  * [SYSADMIN in Practice](#sysadmin-in-practice)
  * [Custom Roles](#custom-roles)
  * [Custom Roles in Practice](#custom-roles-in-practice)
  * [USERADMIN](#useradmin)
  * [USERADMNI in Practice](#useradmni-in-practice)
  * [PUBLIC](#public)
- [PARTNER CONNECT](#partner-connect)
- [BEST PRACTICES](#best-practices)
  * [Most common Best Practices](#most-common-best-practices)
  * [Virtual Warehouses](#virtual-warehouses)
  * [Table Design](#table-design)
  * [Monitoring](#monitoring)
  * [Retention Period](#retention-period-1)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

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

## Dedicated Warehouses
- Identify and classify user groups and their workload
    - BI, DS, Engineering, MArketing
- For every class, create a custom Warehouse
- try to maximize as much as possible the usage of a wharehouse
Attention:
- Do not create too many WH, avoid under utilization. Even if the WH have auto suspend, it mean a lot of the times it will still on and not used
- Refine classification, work pattern can change over time. Monitor it

## Implement Dedicated WH
We Identified 2 teams, we first create both WH with expeceted usage size
```sql
--Create virtual warehouse for data scientist & DBA
--Data Scientists
CREATE WAREHOUSE DS_WH 
WITH WAREHOUSE_SIZE = 'SMALL'
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 300 
AUTO_RESUME = TRUE 
MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 1 
SCALING_POLICY = 'STANDARD';

--DBA
CREATE WAREHOUSE DBA_WH 
WITH WAREHOUSE_SIZE = 'XSMALL'
WAREHOUSE_TYPE = 'STANDARD' 
AUTO_SUSPEND = 300 
AUTO_RESUME = TRUE 
MIN_CLUSTER_COUNT = 1 
MAX_CLUSTER_COUNT = 1 
SCALING_POLICY = 'STANDARD';
```
After, we create the roles that the users need to be.   
To create the roles you must be using ACCOUNTADMIN
- create roles
- grant the role usage on the WH
- create users
- grant the users a role

```SQL
--Create role for Data Scientists & DBAs
CREATE ROLE DATA_SCIENTIST;
GRANT USAGE ON WAREHOUSE DS_WH TO ROLE DATA_SCIENTIST;

CREATE ROLE DBA;
GRANT USAGE ON WAREHOUSE DBA_WH TO ROLE DBA;

--Setting up users with roles
--Data Scientists
CREATE USER DS1 PASSWORD = 'DS1' LOGIN_NAME = 'DS1' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'DS_WH'  MUST_CHANGE_PASSWORD = FALSE;
CREATE USER DS2 PASSWORD = 'DS2' LOGIN_NAME = 'DS2' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'DS_WH'  MUST_CHANGE_PASSWORD = FALSE;
CREATE USER DS3 PASSWORD = 'DS3' LOGIN_NAME = 'DS3' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'DS_WH'  MUST_CHANGE_PASSWORD = FALSE;

GRANT ROLE DATA_SCIENTIST TO USER DS1;
GRANT ROLE DATA_SCIENTIST TO USER DS2;
GRANT ROLE DATA_SCIENTIST TO USER DS3;

--DBAs
CREATE USER DBA1 PASSWORD = 'DBA1' LOGIN_NAME = 'DBA1' DEFAULT_ROLE='DBA' DEFAULT_WAREHOUSE = 'DBA_WH'  MUST_CHANGE_PASSWORD = FALSE;
CREATE USER DBA2 PASSWORD = 'DBA2' LOGIN_NAME = 'DBA2' DEFAULT_ROLE='DBA' DEFAULT_WAREHOUSE = 'DBA_WH'  MUST_CHANGE_PASSWORD = FALSE;

GRANT ROLE DBA TO USER DBA1;
GRANT ROLE DBA TO USER DBA2;

--Drop objects again
DROP USER DBA1;
DROP USER DBA2;

DROP USER DS1;
DROP USER DS2;
DROP USER DS3;

DROP ROLE DATA_SCIENTIST;
DROP ROLE DBA;

DROP WAREHOUSE DS_WH;
DROP WAREHOUSE DBA_WH;
```

## Scalling Up / Down
- THIS IS NOT USEFUL WHEN NUMBER OF USERS INCRESEAD
- changing the size of VW depending on the workload in different periods
- ie: ETL at certain times (4 to 8pm), or special business event with more workload
- THE COMMON CENARIO IS WHEN QUERY GET MORE COMPLEX
- Can change VW size on UI or via code

```SQL
ALTER WAREHOUSE MY_WH
SET WAREHOUSE_SIZE='XSMAL'
```

## Scaling Out
- Used when we have more concurrent queries to run (NOT MORE COMPLEX QUERIES)
- Add warehouses
- Multi cluster is the feature to use, to automatically change it
- If you have enterprise edition, all warehouses should be set to multi-cluster
- default should be 1 warehouse in multi-cluster
- maximum should suffice the needs with loose
- can test creating a warehouse that would scale up to 3 and run 8x times this query
```SQL
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE T1
CROSS JOIN SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE T2
CROSS JOIN SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE T3
CROSS JOIN (SELECT TOP 57 * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.WEB_SITE)  T4
```

## Caching
- Automatic process to speed up the queries
- if query is executed tiwce, resutls are achached and can be re-used
- cahce lasts 24h or until underlying data changes
- we cant do much about it
- but we can assure same queries are running in the same warehouse (if possible)

### Maximizing Cache
- demo
- run the query test and see and click on 3 dots in query details > profile (should have 3 stages)
- re run the query and check the profile again (should have only stage)
- cerate another user, grant permission to same warehouse, login as him
- with new user, run the same query (1 stage)

```SQL
-- query to test
SELECT AVG(C_BIRTH_YEAR) FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL.CUSTOMER

--Setting up an additional user
CREATE ROLE DATA_SCIENTIST;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE DATA_SCIENTIST;

CREATE USER DS1 PASSWORD = 'DS1' LOGIN_NAME = 'DS1' DEFAULT_ROLE='DATA_SCIENTIST' DEFAULT_WAREHOUSE = 'DS_WH'  MUST_CHANGE_PASSWORD = FALSE;
GRANT ROLE DATA_SCIENTIST TO USER DS1;
```

## Clustering

- it is subset of rows to loacate the data in micro-partitions
- for large tables, it improve scan sfficiency in our queries
- it is maintaned automatically (in regular DBs, DBAS need to mantain)
- In general snowflake produces well-clustered tables
- But, they are not always ideal and can change over time
- example with image to show what snowflake does

### When and how to cluster
- when? when table is more than a couple TBs, this is not for smaller tables
- how? 
    - create a cluster in columns frequenbtly used in where
    - if filter often by 2 columns, it can alse be good to create 2 cluster keys
    - also good for columns frequenlty used in joins
    - the column choose should not be very granular and never have distinct values to avoid hotspot
    - the column value should be very well distributed to enable efficient grouping
- when creating table, we add the cluster key
```sql
-- CLUSTER BY 1 OR MORE COLUMNS
CREATE TABLE MY_TABLE AS SELECT * FROM A CLUSTER BY (COLUMN_A , COLUMN_B)

--CLUSTER BY EXPRESION -> LIKE MONTH
CREATE TABLE MY_TABLE AS SELECT * FROM A CLUSTER BY (MONTH(COLUMN_A))

-- CAN ALSO ALTER TABLE TO ADD OR DROP CLUSTER
ALTER TALBE TABLE MY_TABLE CLUSTER BY (COLUMN_A , COLUMN_B)
```

### CLUSTER DEMO

```SQL
--Publicly accessible staging area    
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

--Load data using copy command
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*OrderDetails.*';
    
--Create table
CREATE OR REPLACE TABLE ORDERS_CACHING (
ORDER_ID	VARCHAR(30)
,AMOUNT	NUMBER(38,0)
,PROFIT	NUMBER(38,0)
,QUANTITY	NUMBER(38,0)
,CATEGORY	VARCHAR(30)
,SUBCATEGORY	VARCHAR(30)
,DATE DATE)    

-- INSERT THE DATA  creting a date column
INSERT INTO ORDERS_CACHING 
SELECT
t1.ORDER_ID
,t1.AMOUNT	
,t1.PROFIT	
,t1.QUANTITY	
,t1.CATEGORY	
,t1.SUBCATEGORY	
,DATE(UNIFORM(1500000000,1700000000,(RANDOM())))
FROM ORDERS t1
CROSS JOIN (SELECT * FROM ORDERS) t2
CROSS JOIN (SELECT TOP 100 * FROM ORDERS) t3

--Query Performance before Cluster Key
--check on the query profiler
SELECT * FROM ORDERS_CACHING  WHERE DATE = '2020-06-09'


--Adding Cluster Key & Compare the result
ALTER TABLE ORDERS_CACHING CLUSTER BY ( DATE ) 
-- check after 45 min to  1h to see results in the query profiler
SELECT * FROM ORDERS_CACHING  WHERE DATE = '2020-01-05'
```

# Loading from Cloud Provider
- Create AWS account
- Create Bucket and folder in the same region as SF to avoid extra cost
- Upload the files
- create policy to create connection between AWS and SF
    - click on profile name (top right) > security credentials > copy the aws account id
    - IAM > Role > Create New Role > Another AWS account > enter aws account id > select require external id > fill external id with 00000 > next
    - search for s3 full acess > next > role name > create role
    - copy the role ARN
    - paste it on the query below
    - run both commands

```sql
--Create storage integration object
create or replace storage integration s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'bla bla bla'
  STORAGE_ALLOWED_LOCATIONS = ('s3://<your-bucket-name>/<your-path>/', 's3://<your-bucket-name>/<your-path>/')
   COMMENT = 'This an optional comment' 
   
--See storage integration properties to fetch external_id so we can update it in S3
DESC integration s3_int;
```
    - after DESC command copy the SOTRAGE_AWS_IAM_USER_ARN  and STORAGE_AWS_EXTERNAL_ID
    - GO to AWS > IAM > role >select the created role > edit
    - on place of principal : AWS paste SOTRAGE_AWS_IAM_USER_ARN
    - on place od sts:ExternalID : place STORAGE_AWS_EXTERNAL_ID

## Loading the data
```sql
--Create table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.movie_titles (
  show_id STRING,
  type STRING,
  title STRING,
  director STRING,
  cast STRING,
  country STRING,
  date_added STRING,
  release_year STRING,
  rating STRING,
  duration STRING,
  listed_in STRING,
  description STRING )
  
--Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE    
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'    
    
--Create stage object with integration object & file format object
CREATE OR REPLACE stage MANAGE_DB.external_stages.csv_folder
    URL = 's3://<your-bucket-name>/<your-path>/'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat

--Use Copy command       
COPY INTO OUR_FIRST_DB.PUBLIC.movie_titles
    FROM @MANAGE_DB.external_stages.csv_folder
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.movie_titles
```    
    
# Snowpipe
https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro.html

## What is it?
- Enable loading once a file appears in a bucket
- if needs data to be available immediately for analysis
- Snowpipe use serverless features instead of Warehouses
- Snowpipe is not meant for bulk loading big files, but instead, to load small and continuou files that might be arriving very often
- can create flow to show
files > s3 bucket >---s3 notification---> serverless > Snowflake DB

## Steps to Create
- Create Stage Object
- create a copy command and test it
- Create a Pipe as object with copy command
- create S3 notification to trigger snowpipe

## Creating the Stage
- it used the employee data 1.csv
- first create the table to insert the data
- then create the file format object
- create the stage (if the stage is in a sub folder of the integration object, you can reuse the same integration objet)
```sql
--Create table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees (
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  location STRING,
  department STRING
  )
    
--Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;
      
--Create stage object with integration object & file format object
CREATE OR REPLACE stage MANAGE_DB.external_stages.csv_folder
    URL = 's3://snowflakes3bucket123/csv/snowpipe'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat
   
--Create stage object with integration object & file format object
LIST @MANAGE_DB.external_stages.csv_folder  
```
## Creating the PIPE
- on Manage DB create a separate schema to save pipes
- create the copy command and test it
- create the pipe AS the copy
- describe the pipe to find out the column notification_channel and copy it
```sql
--Create schema to keep things organized
CREATE OR REPLACE SCHEMA MANAGE_DB.pipes

--Define pipe
CREATE OR REPLACE pipe MANAGE_DB.pipes.employee_pipe
auto_ingest = TRUE
AS
COPY INTO OUR_FIRST_DB.PUBLIC.employees
FROM @MANAGE_DB.external_stages.csv_folder  

--Describe pipe
DESC pipe employee_pipe
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.employees    
```

## Creating Notification
- Go to bucker screen > properties tab > setup event notification
- name it > prefix used for folders where to notifiy > event types (select the desired or ALL) > roll to destination > select SQS queue > select Enter SQS queu ARN > paste the code copied from Snowflake > save changes
- gtest it
    - upload another file to subfolder you set of prefix
    - takes 30 to 60 seconds to event happen
    - check data in snowflake

## Error Handling
- use files employee data 3 and 4
- first show test with error, using wrong delimiter
```sql
--Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ',' -- set a wrong delimiter
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;
```
- upload a new file on bucket
- queries below are to debug
```sql 
-- this command shows the runs that happened
-- just to know if pipe is functioning
ALTER PIPE employee_pipe refresh
 
-- Validate pipe is actually working
SELECT SYSTEM$PIPE_STATUS('employee_pipe')

-- Snowpipe error message
-- sometime can give some general error message
SELECT * FROM TABLE(VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'MANAGE_DB.pipes.employee_pipe',
    START_TIME => DATEADD(HOUR,-2,CURRENT_TIMESTAMP())))

-- COPY command history from table to see error massage
-- here we have more details to understand the error
SELECT * FROM TABLE (INFORMATION_SCHEMA.COPY_HISTORY(
   table_name  =>  'OUR_FIRST_DB.PUBLIC.EMPLOYEES',
   START_TIME =>DATEADD(HOUR,-2,CURRENT_TIMESTAMP())))
```

## Managing Pipes
```sql
-- Manage pipes -- 
DESC pipe MANAGE_DB.pipes.employee_pipe;

SHOW PIPES;

SHOW PIPES like '%employee%'

SHOW PIPES in database MANAGE_DB

SHOW PIPES in schema MANAGE_DB.pipes

SHOW PIPES like '%employee%' in Database MANAGE_DB

-- Changing pipe (alter stage or file format) --
--P reparation table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.employees2 (
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  location STRING,
  department STRING
  )

-- Pause pipe
ALTER PIPE MANAGE_DB.pipes.employee_pipe SET PIPE_EXECUTION_PAUSED = true
 
-- Verify pipe is paused and has pendingFileCount 0 
SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.pipes.employee_pipe') 

 -- Recreate the pipe to change the COPY statement in the definition
CREATE OR REPLACE pipe MANAGE_DB.pipes.employee_pipe
auto_ingest = TRUE
AS
COPY INTO OUR_FIRST_DB.PUBLIC.employees2
FROM @MANAGE_DB.external_stages.csv_folder  

ALTER PIPE  MANAGE_DB.pipes.employee_pipe refresh

-- List files in stage
LIST @MANAGE_DB.external_stages.csv_folder  

SELECT * FROM OUR_FIRST_DB.PUBLIC.employees2

-- Reload files manually that where aleady in the bucket
-- files already loaded will not be realoaded
COPY INTO OUR_FIRST_DB.PUBLIC.employees2
FROM @MANAGE_DB.external_stages.csv_folder  

-- Resume pipe
ALTER PIPE MANAGE_DB.pipes.employee_pipe SET PIPE_EXECUTION_PAUSED = false

-- Verify pipe is running again
SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.pipes.employee_pipe') 
```

# TIME TRAVEL

## Time travel Functions
https://docs.snowflake.com/en/user-guide/data-time-travel.html
- we can look how a table was in an specific point in time
- each snowflake edition has its look back time
    - standard -1 day
    - enterprise and on -90
- first create a table and stages
```sql
--Setting up table
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string)
    
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file
    type = csv
    field_delimiter = ','
    skip_header = 1
    
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    
LIST @MANAGE_DB.external_stages.time_travel_stage

COPY INTO OUR_FIRST_DB.public.test
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv')

SELECT * FROM OUR_FIRST_DB.public.test
```
- this is all set
- the use case is we will accidentally replace all names in a column instead a single value
- there are 3 ways of using 
- Method 1
```sql
--Use-case: Update data (by mistake)
UPDATE OUR_FIRST_DB.public.test
SET FIRST_NAME = 'Joyen' 

-- see all is wrong
SELECT * FROM OUR_FIRST_DB.public.test

--Using time travel: Method 1 - 2 minutes back
SELECT * FROM OUR_FIRST_DB.public.test at (OFFSET => -60*1.5)

-- see all is back to normal
SELECT * FROM OUR_FIRST_DB.public.test
```
- method 2
- recreate the table from beggining to re do the mistake
- get the current timestamp
- use the timestamp
```sql
-- Setting up UTC time for convenience
ALTER SESSION SET TIMEZONE ='UTC'
SELECT DATEADD(DAY, 1, CURRENT_TIMESTAMP)

UPDATE OUR_FIRST_DB.public.test
SET Job = 'Data Scientist'

-- all shoudl be wrong
SELECT * FROM OUR_FIRST_DB.public.test;

-- second method
SELECT * FROM OUR_FIRST_DB.public.test before (timestamp => '2021-04-16 07:30:47.145'::timestamp)

-- all should be all good
SELECT * FROM OUR_FIRST_DB.public.test;
```
- method 3
- recreate the table from beggining to re do the mistake
- get the query id on the history
```sql
--Using time travel: Method 3 - before Query ID
--Altering table (by mistake)
UPDATE OUR_FIRST_DB.public.test
SET EMAIL = null

SELECT * FROM OUR_FIRST_DB.public.test

SELECT * FROM OUR_FIRST_DB.public.test before (statement => '019b9ee5-0500-8473-0043-4d8300073062')
```

## Restoring the data
- setup every data as previous 
- do two mistakes, one at each times to have 2 query id
- recreate the table using time travel on latest mistake id from last query run
- check results and see is not ideal (missing the rollback of first mistake)
- try to recreate using the first mistake query id and get error
- this is because recreate table deletes all metadata
- this is the bad habit of restoring data
``` sql
--Use-case: Update data (by mistake)
UPDATE OUR_FIRST_DB.public.test
SET LAST_NAME = 'Tyson';

UPDATE OUR_FIRST_DB.public.test
SET JOB = 'Data Analyst';

SELECT * FROM OUR_FIRST_DB.public.test before (statement => '019b9eea-0500-845a-0043-4d830007402a')

--Bad method
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '019b9eea-0500-845a-0043-4d830007402a')


SELECT * FROM OUR_FIRST_DB.public.test

-- you shoudl get an error here
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '019b9eea-0500-8473-0043-4d830007307a')
```
- the good method
- recreate everything and do both mistakes
- do the same of restoring not to the ideal query id but with a good practice
- check it and see it not cool but you still can go to right point in time
```sql
-- Good method
CREATE OR REPLACE TABLE OUR_FIRST_DB.public.test_backup as
SELECT * FROM OUR_FIRST_DB.public.test before (statement => '019b9ef0-0500-8473-0043-4d830007309a')

TRUNCATE OUR_FIRST_DB.public.test

INSERT INTO OUR_FIRST_DB.public.test
SELECT * FROM OUR_FIRST_DB.public.test_backup

SELECT * FROM OUR_FIRST_DB.public.test 
```

## Undrop Table / Schema / Database
- SETUP the environment
```sql
--Setting up table
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.customers (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
    
COPY INTO OUR_FIRST_DB.public.customers
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');

SELECT * FROM OUR_FIRST_DB.public.customers;
```
- undrop commands
```sql
--UNDROP command - Tables
DROP TABLE OUR_FIRST_DB.public.customers;

SELECT * FROM OUR_FIRST_DB.public.customers;

UNDROP TABLE OUR_FIRST_DB.public.customers;

--UNDROP command - Schemas
DROP SCHEMA OUR_FIRST_DB.public;

SELECT * FROM OUR_FIRST_DB.public.customers;

UNDROP SCHEMA OUR_FIRST_DB.public;

--UNDROP command - Database
DROP DATABASE OUR_FIRST_DB;

SELECT * FROM OUR_FIRST_DB.public.customers;

UNDROP DATABASE OUR_FIRST_DB;
```
- you can even use undrop to undrop recreated tables and restore the metadatada and do time travel
- but you cant undrop a table that still exists, then you need to rename the current recreated table and then undrop the desired table

## Retention Period
- Standard edition = 1 day
- Enterprise and on = 90 days (but default is 1)
- but it does not mean is always 90 days, need to use query below to see what is the retention time
```sql
SHOW TABLES LIKE '%TABLENAME';
```
- there are 2 methods to set the retention time
```sql
-- existing table
ALTER TALBE MY_TABLE SET DATA_RETENTION_TIME_IN_DAYS = 2;

-- on creation
CREATE OR REPLACE TABLE MY_ABLE AS
( SELECT * FROM A) DATA_RETENTION_TIME_IN_DAYS = 2 ;
```
- IF SETTING a retention period to 0 you can also undrop
- the more the time travel retention period the more storage, thus, more cost

## Time Travel Cost
- not always ideal to have 90 days retention period
- increase storage
```sql
-- storage usage per day in total
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE ORDER BY USAGE_DATE DESC;
-- storage usage per table
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;

-- Query time travel storage
SELECT 	ID, 
		TABLE_NAME, 
		TABLE_SCHEMA,
        TABLE_CATALOG,
		ACTIVE_BYTES / (1024*1024*1024) AS STORAGE_USED_GB,
		TIME_TRAVEL_BYTES / (1024*1024*1024) AS TIME_TRAVEL_STORAGE_USED_GB
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
ORDER BY STORAGE_USED_GB DESC,TIME_TRAVEL_STORAGE_USED_GB DESC;
```

# FAIL SAFE

## What is Fail Safe
- Protection of historical data in case of disaster
- non-configurable 7-day period for permanent tables (most common, non views)
- perios starts immediately after time travel priods ends
- No user interaction & recoverable only by snowflake support
- Contribute to storage cost

## Continuous Data Protection Lifecycle
- in the data lifecycle we have:
    - first layer of data: current storage and data, we use to regular queries
    - time travel data: data from a permanent table from 1 up to 90 days ago (used to time travel or undrop)
    - Fail Safe Data: for permament tables, 7 days ago from the time travel data (if TT is set to 90, then up to 97 days ago). 
    - Transient tables do not have fail safe

## Fail Safe Storage
- 2 ways to find it out
- log as account admin
- first method: UI > account > sotrage used > select fail safe on UI
- second method: use the queries below
```sql
-- Storage usage on account level
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE ORDER BY USAGE_DATE DESC;

--Storage usage on account level formatted
SELECT 	USAGE_DATE, 
		STORAGE_BYTES / (1024*1024*1024) AS STORAGE_GB,  
		STAGE_BYTES / (1024*1024*1024) AS STAGE_GB,
		FAILSAFE_BYTES / (1024*1024*1024) AS FAILSAFE_GB
FROM SNOWFLAKE.ACCOUNT_USAGE.STORAGE_USAGE ORDER BY USAGE_DATE DESC;


--Storage usage on table level
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS;

--Storage usage on table level formatted
SELECT 	ID, 
		TABLE_NAME, 
		TABLE_SCHEMA,
		ACTIVE_BYTES / (1024*1024*1024) AS STORAGE_USED_GB,
		TIME_TRAVEL_BYTES / (1024*1024*1024) AS TIME_TRAVEL_STORAGE_USED_GB,
		FAILSAFE_BYTES / (1024*1024*1024) AS FAILSAFE_STORAGE_USED_GB
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
ORDER BY FAILSAFE_STORAGE_USED_GB DESC;
```

# TABLE TYPES

## The types
- Permanent Tables
    - Standard table created by the CREATE TABLE command
    - have fail safe
    - Have time travel (0-90 days)
    - can cost more, because fail safe andd TT storage costs
    - live until dropped
- Transient Tables
    - CREATE TRANSIENT TABLE
    - Have TT (0-1 days)
    - DONT HAVE fail safe, so the data there must not need protection
    - live until dropped
    - good for large tables without protection, to reduce costs
- Temporary Table
    - CREATE TEMPORARY TABLE
    - Have TT (0-1 days)
    - No fail safe
    - live ONLY IN THE SESSION , no other user can see
    - good for development, non permanent data

- theses type of tables are used mainly for cost management
- these types are also available for schemas and databases
    - if creating a temporary database, all schemas and tables will be temporary
- for temporary tables, there will be no name conflict with permanent or transient tables

## Permanent Tables
- lets check any table we have created
```sql
-- column options would show if transietn or not, retention time value TT
SHOW DATABASES;

-- can see size in bytes, retention time
SHOW TABLES;

--View table metrics (takes a bit to appear)
-- see if transient, active bytes, fail saffe and TT bytes
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS

SELECT 	ID, 
       	TABLE_NAME, 
		TABLE_SCHEMA,
        TABLE_CATALOG,
		ACTIVE_BYTES / (1024*1024*1024) AS ACTIVE_STORAGE_USED_GB,
		TIME_TRAVEL_BYTES / (1024*1024*1024) AS TIME_TRAVEL_STORAGE_USED_GB,
		FAILSAFE_BYTES / (1024*1024*1024) AS FAILSAFE_STORAGE_USED_GB,
        IS_TRANSIENT,
        DELETED,
        TABLE_CREATED,
        TABLE_DROPPED,
        TABLE_ENTERED_FAILSAFE
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
--WHERE TABLE_CATALOG ='PDB'
WHERE TABLE_DROPPED is not null -- this is to show space ocupied by dropped tables
ORDER BY FAILSAFE_BYTES DESC;
```

## Transient Tables
```sql
-- creating a new DB to test
CREATE OR REPLACE DATABASE TDB;

-- createing the transient table
CREATE OR REPLACE TRANSIENT TABLE TDB.public.customers_transient (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);

-- inserting data to transient table
INSERT INTO TDB.public.customers_transient
SELECT t1.* FROM OUR_FIRST_DB.public.customers t1
CROSS JOIN (SELECT * FROM OUR_FIRST_DB.public.customers) t2

-- be in admin role
-- run the command below to see the table 
-- we can see size and transient flag of this table
SHOW TABLES;

-- lets check storage metrics Query storage
-- it may take sometime to update values about the recently created table
-- but there will be no fail safe storage for transiente tables
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS

-- way to better check it
SELECT 	ID, 
       	TABLE_NAME, 
		TABLE_SCHEMA,
        TABLE_CATALOG,
		ACTIVE_BYTES,
		TIME_TRAVEL_BYTES / (1024*1024*1024) AS TIME_TRAVEL_STORAGE_USED_GB,
		FAILSAFE_BYTES / (1024*1024*1024) AS FAILSAFE_STORAGE_USED_GB,
        IS_TRANSIENT,
        DELETED,
        TABLE_CREATED,
        TABLE_DROPPED,
        TABLE_ENTERED_FAILSAFE
FROM SNOWFLAKE.ACCOUNT_USAGE.TABLE_STORAGE_METRICS
WHERE TABLE_CATALOG ='TDB'
ORDER BY TABLE_CREATED DESC;

-- Creating transient schema and then table 
-- showing that all below the schema is also transient
CREATE OR REPLACE TRANSIENT SCHEMA TRANSIENT_SCHEMA;

SHOW SCHEMAS;

CREATE OR REPLACE TABLE TDB.TRANSIENT_SCHEMA.new_table (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);

-- this will not be possible, because transient table have TT max 1
ALTER TABLE TDB.TRANSIENT_SCHEMA.new_table
SET DATA_RETENTION_TIME_IN_DAYS  = 2

SHOW TABLES;
```

## Temporary Tables
```sql
USE DATABASE PDB;

Create permanent table 
CREATE OR REPLACE TABLE PDB.public.customers (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);

INSERT INTO PDB.public.customers
SELECT t1.* FROM OUR_FIRST_DB.public.customers t1

SELECT * FROM PDB.public.customers

--Create temporary table (with the same name)
CREATE OR REPLACE TEMPORARY TABLE PDB.public.customers (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);

--Validate temporary table is the active table
SELECT * FROM PDB.public.customers;

--Create second temporary table (with a new name)
CREATE OR REPLACE TEMPORARY TABLE PDB.public.temp_table (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);

--Insert data in the new table
INSERT INTO PDB.public.temp_table
SELECT * FROM PDB.public.customers

SELECT * FROM PDB.public.temp_table

SHOW TABLES;
```

# ZERO-COPY CLONING

## What is Zero-Copy Cloning?
- Create copies of a database, shcema and tables at once
- other databases need to do copies separately: first DB, then schema, then table , then PK...
- Clone is a metadata operation
- since the data is on S3, snowflake only creates a reference to the file there and create a new table
- Cloned table is an independent table, even tought referencing to same files
- When making changes to the clone table, snowflake make sure just to save the data that has been modefied, not all the table
- Easy to copy all meta data & improved sotrage management
- Very useful for backups and development environment
- Wirks with time travel too
```sql
CREATE TABLE NAME
CLONE SOURCE_TABLE
BEFORE (TIMESTAMP => 1231516)
```
- Any structure of the object and meta data is inherited
    - clustering keys, comments...
- Can perform on DB, table. schema, stages, file formats, task...

## Cloning Tables
```sql
-- Cloning
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS

CREATE TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE
CLONE OUR_FIRST_DB.PUBLIC.CUSTOMERS

-- Validate the data is the same
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE

--Update cloned table
UPDATE OUR_FIRST_DB.public.CUSTOMERS_CLONE
SET LAST_NAME = NULL

-- original table is still the same
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS 

-- clone table is changed
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE

--Cloning a temporary table is not possible
CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TEMP_TABLE(
  id int)

-- try and get the error
CREATE TABLE OUR_FIRST_DB.PUBLIC.TABLE_COPY
CLONE OUR_FIRST_DB.PUBLIC.TEMP_TABLE

-- but if cloning as a temporary table, it works
CREATE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TABLE_COPY
CLONE OUR_FIRST_DB.PUBLIC.TEMP_TABLE

SELECT * FROM OUR_FIRST_DB.PUBLIC.TABLE_COPY
```

## Cloning Schemas & Databases
```sql
-- Cloning Schema in a transient mode
-- they inherit everything
CREATE TRANSIENT SCHEMA OUR_FIRST_DB.COPIED_SCHEMA
CLONE OUR_FIRST_DB.PUBLIC;

-- check all data is there
SELECT * FROM COPIED_SCHEMA.CUSTOMERS

-- clone the schema with satage to see that under databases > this schema > all stages are there
CREATE TRANSIENT SCHEMA OUR_FIRST_DB.EXTERNAL_STAGES_COPIED
CLONE MANAGE_DB.EXTERNAL_STAGES;

--Cloning Database
--you see that all is there
CREATE TRANSIENT DATABASE OUR_FIRST_DB_COPY
CLONE OUR_FIRST_DB;

--clea up
DROP DATABASE OUR_FIRST_DB_COPY
DROP SCHEMA OUR_FIRST_DB.EXTERNAL_STAGES_COPIED
DROP SCHEMA OUR_FIRST_DB.COPIED_SCHEMA
```

## Cloning with Time Travel
```sql
--Cloning using time travel
--Setting up table

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.time_travel (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
    
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file
    type = csv
    field_delimiter = ','
    skip_header = 1;
    
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    
LIST @MANAGE_DB.external_stages.time_travel_stage;

COPY INTO OUR_FIRST_DB.public.time_travel
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');

SELECT * FROM OUR_FIRST_DB.public.time_travel
------ END OF SETUP

--Update data to test TT
UPDATE OUR_FIRST_DB.public.time_travel
SET FIRST_NAME = 'Frank' 

-- Using time travel in the simple way
SELECT * FROM OUR_FIRST_DB.public.time_travel at (OFFSET => -60*1)

-- Using time travel with clone
-- this is very useful to compare with current table status
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.time_travel_clone
CLONE OUR_FIRST_DB.public.time_travel at (OFFSET => -60*1.5)

SELECT * FROM OUR_FIRST_DB.PUBLIC.time_travel_clone

--Update data on clone table -  can create a clone of a clone
UPDATE OUR_FIRST_DB.public.time_travel_clone
SET JOB = 'Snowflake Analyst' 

-- Using time travel: Method 2 - before Query
SELECT * FROM OUR_FIRST_DB.public.time_travel_clone before (statement => '<your-query-id>')

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.time_travel_clone_of_clone
CLONE OUR_FIRST_DB.public.time_travel_clone before (statement => '<your-query-id>')

SELECT * FROM OUR_FIRST_DB.public.time_travel_clone_of_clone 
```

## Swapping Tables
- useful for moving a developing table to a production scenario
- similar to clioning, because it is only a metadata operation
- it swaps only the metadata
```sql
ALTER TALBE MYTABLE
SWAP WITH OTHERTABLE
```
- Can do for schema and databases also
- test ideia
    - have 2 tables with same data
    - delete some data from one
    - check they are different
    - use the swap command
    - the other table should be equal to the deleted data table

# DATA SHARING

## What is Data Sharing
- it is usually very complicated because we need to set up everything
- Due to snowflake decoupled architecture, where storage is separate from processing it is easy here
- Can do data sharing without actual copy of the data & that is up to date
- shared data can be consumed by their own compute resources
    - separate costs
- can share to external users with reader account
- ex
    - we have 2 SF account
    - 1 account is the one we use, creating data
    - other account is a consumer, read only
    - account 2 use their own compute resources
- account owning the data have full controll over the data sharing

## Data share via SQL
- steps:
- create a share -> this will be the obejct shared with other instance
- grant to share usage access to schema and database
- grant to the share select on table access
- check the grant with show grants
- add the consumer account into the share
```sql
--Create a share object
CREATE OR REPLACE SHARE ORDERS_SHARE;

---- Setup Grants ----
--Grant usage on database
GRANT USAGE ON DATABASE DATA_S TO SHARE ORDERS_SHARE; 

-- Grant usage on schema
GRANT USAGE ON SCHEMA DATA_S.PUBLIC TO SHARE ORDERS_SHARE; 

-- Grant SELECT on table

GRANT SELECT ON TABLE DATA_S.PUBLIC.ORDERS TO SHARE ORDERS_SHARE; 

-- Validate Grants
SHOW GRANTS TO SHARE ORDERS_SHARE;

---- Add Consumer Account ----
ALTER SHARE ORDERS_SHARE ADD ACCOUNT=<consumer-account-id>;
```
- move to the other account
- show share, to see the share name
- check more info with desc share share_name
- you cant see the shared data, you need to create a database to see it
- now you ca query from the share
```sql
SHOW SHARES;

DESC SHARE SHARE.NAME;

CREATE DATABASE MY_DB FROM SHARE SHARE.NAME;
```

## Data share via UI
- go to share on ui
- select role account admin
- inboundL shared with us 
- outbound: what we share
- can add cosumer, drop, edit
- create a new one, fill aal, add account, select full to add acnother account (reader is for external)

## Share with non SF user
- For this you create a reader account within your account
- this account will consume for yours account, but will have different login, user, url...
- but it is an independent instance using computing recources
- steps:
    - create a reader account
    - share the data
    - on the reader account: as admin, create users and role

## Crate a Reader Account - Managed Account
```sql
-- Create Reader Account--
-- after running this, you get the url and account printed
CREATE MANAGED ACCOUNT tech_joy_account
ADMIN_NAME = tech_joy_admin,
ADMIN_PASSWORD = 'set-pwd',
TYPE = READER;

--Make sure to have selected the role of accountadmin
--Show accounts and get url and account id
SHOW MANAGED ACCOUNTS;

-- Share the data -- 
ALTER SHARE ORDERS_SHARE 
ADD ACCOUNT = <reader-account-id>;

-- if using business critical, need to change restriction to be able to share with non business critical
ALTER SHARE ORDERS_SHARE 
ADD ACCOUNT =  <reader-account-id>
SHARE_RESTRICTIONS=false;
```

## Create a DB from Share
- Here we gonna login with reader account with credential created before
- follow steps below
```sql
-- Create database from share --
-- Show all shares (consumer & producers)
-- use accountadmin
SHOW SHARES;

-- See details on share
DESC SHARE QNA46172.ORDERS_SHARE;

-- Setup virtual warehouse
CREATE WAREHOUSE READ_WH WITH
WAREHOUSE_SIZE='X-SMALL'
AUTO_SUSPEND = 180
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

-- Create a database in consumer account using the share
CREATE DATABASE DATA_SHARE_DB FROM SHARE <account_name_producer>.ORDERS_SHARE;

-- Validate table access
SELECT * FROM  DATA_SHARE_DB.PUBLIC.ORDERS
```

## Create Users to share
- crate user on the reader account
- after, you should be able to query
```sql
-- Create and set up users --
-- Create user
CREATE USER MYRIAM PASSWORD = 'difficult_passw@ord=123'

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE READ_WH TO ROLE PUBLIC;

-- Grating privileges on a Shared Database for other users
GRANT IMPORTED PRIVILEGES ON DATABASE DATA_SHARE_DB TO ROLE PUBLIC;
```

## Sharing DB and Schema
- Up to now, we just shared a table
```sql 
SHOW SHARES;

-- Create share object
CREATE OR REPLACE SHARE COMEPLETE_SCHEMA_SHARE;

-- Grant usage on dabase & schema to share created
GRANT USAGE ON DATABASE OUR_FIRST_DB TO SHARE COMEPLETE_SCHEMA_SHARE;
GRANT USAGE ON SCHEMA OUR_FIRST_DB.PUBLIC TO SHARE COMEPLETE_SCHEMA_SHARE;

-- Grant select on all tables in schema and db
GRANT SELECT ON ALL TABLES IN SCHEMA OUR_FIRST_DB.PUBLIC TO SHARE COMEPLETE_SCHEMA_SHARE;
GRANT SELECT ON ALL TABLES IN DATABASE OUR_FIRST_DB TO SHARE COMEPLETE_SCHEMA_SHARE;

-- Add account to share the db and schema
ALTER SHARE COMEPLETE_SCHEMA_SHARE
ADD ACCOUNT=KAA74702
```
- Login in the share
```sql
-- LOGIN ON READER ACCOUNT --
-- should see the new share
SHOW SHARES;

-- CREATE A DATABASE FROM THE SHARE
-- NOW YOU SHOULD BE ABLE TO QUERY
CREATE DATABASE MY_SHARED_DB FROM SHARE ACCOOUNTID.COMEPLETE_SCHEMA_SHARE
```
- If now you change data on the main account, it will reflected on reader
- if you add new tables on the mais account schema, will not appear on reader because they have no access
- must grant permission (or use future when granting)
```sql
-- Updating data
UPDATE OUR_FIRST_DB.PUBLIC.ORDERS
SET PROFIT=0 WHERE PROFIT < 0

-- Add new table
CREATE TABLE OUR_FIRST_DB.PUBLIC.NEW_TABLE (ID int)
```

## Secure vs Normal view
- in real business sncenario we usually just share a subset of data in a view
- use any table to the example
```sql
-- example table
SELECT * FROM  CUSTOMER_DB.PUBLIC.CUSTOMERS;

-- Create VIEW filtering the data out you dont want to show
CREATE OR REPLACE VIEW CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW AS
SELECT 
FIRST_NAME,
LAST_NAME,
EMAIL
FROM CUSTOMER_DB.PUBLIC.CUSTOMERS
WHERE JOB != 'DATA SCIENTIST'; 

-- Grant usage & SELECT to public user
GRANT USAGE ON DATABASE CUSTOMER_DB TO ROLE PUBLIC;
GRANT USAGE ON SCHEMA CUSTOMER_DB.PUBLIC TO ROLE PUBLIC;
GRANT SELECT ON TABLE CUSTOMER_DB.PUBLIC.CUSTOMERS TO ROLE PUBLIC;
GRANT SELECT ON VIEW CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW TO ROLE PUBLIC;

-- select the public role and run query below
-- you can see that view definition is apprearing, column and values that are in view deifnition also, and you want to hide them
SHOW VIEWS LIKE '%CUSTOMER%';

-- Create SECURE VIEW -- 
CREATE OR REPLACE SECURE VIEW CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW_SECURE AS
SELECT 
FIRST_NAME,
LAST_NAME,
EMAIL
FROM CUSTOMER_DB.PUBLIC.CUSTOMERS
WHERE JOB != 'DATA SCIENTIST' 

-- do the grants
GRANT SELECT ON VIEW CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW_SECURE TO ROLE PUBLIC;

-- go again to the public role and execute the query below
SHOW VIEWS LIKE '%CUSTOMER%';
```

## Share a Secure View
- view can only be shared on secure mode
- 
```sql
SHOW SHARES;

-- Create share object
CREATE OR REPLACE SHARE VIEW_SHARE;

-- Grant usage on dabase & schema
GRANT USAGE ON DATABASE CUSTOMER_DB TO SHARE VIEW_SHARE;
GRANT USAGE ON SCHEMA CUSTOMER_DB.PUBLIC TO SHARE VIEW_SHARE;

-- Grant select on view non secured, you gonna receive an error
GRANT SELECT ON VIEW  CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW TO SHARE VIEW_SHARE;

-- grant select access to share, on the secure view, should work
GRANT SELECT ON VIEW  CUSTOMER_DB.PUBLIC.CUSTOMER_VIEW_SECURE TO SHARE VIEW_SHARE;

-- Add account to share
ALTER SHARE VIEW_SHARE
ADD ACCOUNT=KAA74702
```
- go the other account
- create a database from the share with view
- in public schema see the shared view
- the icon is a bit different

# DATA SAMPLING

## Why we need Data Sampling?

- use case:
- we have an extremelly large dataset like 20 TB
- to do testing an development it would be very expensive to run queries on all data and also very slow
- If increse the WH size it would be faster, but would cost more processing
- sampling, as for DS people, is randonly taking a subset of the data to work with
- this is faster, and save compute resources, and since is rano sample, have high accuracy
- good for data analysis and development

## Sampling Methods
2 methods
- Row or Bernuolli Method
    - every row have a probability of x percent in being in the sample
    - it is a bit more random
    - less efficient
    - for smaller tables
- block or system method
    - every block of data (micro partition) have a probability of x percent in being in the sample
    - this is more proccesgin effective
    - for extremelly large tables

## Sampling the data
```sql
-- lets create a transient table for testing
CREATE OR REPLACE TRANSIENT DATABASE SAMPLING_DB;

-- use the snoeflake sample data
CREATE OR REPLACE VIEW ADDRESS_SAMPLE
AS 
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CUSTOMER_ADDRESS
-- row(1) means that we get 1% of dataset
-- see(27) is basically a version of it and make create a hisotry
-- if want someone else to use the same sample as me, should use seed(x) to have the same version
SAMPLE ROW (1) SEED(27);

SELECT * FROM ADDRESS_SAMPLE

-- run the query below with having the view with row(1) and later row(10) 
-- when useing row(10) dont forget to increase the numberos rows in the division below, it is 10x more rows
-- compare both results and see that the null percentage is very similar
-- shows that this sample can be very efficient
SELECT CA_LOCATION_TYPE, COUNT(*)/3254250*100
FROM ADDRESS_SAMPLE
GROUP BY CA_LOCATION_TYPE


-- just showing the usage of a better performant approach
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CUSTOMER_ADDRESS 
SAMPLE SYSTEM (1) SEED(23);

SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CUSTOMER_ADDRESS 
SAMPLE SYSTEM (10) SEED(23);
```

# SCHEDULING TASKS

## Understangin tasks
- sql statement that runs periodically
- 1 sql statement per task
- standalone or tree os task and dependencies
- course agenda

## Creating tasks
```sql
-- createing a temporary db to the lesson
CREATE OR REPLACE TRANSIENT DATABASE TASK_DB;

-- Prepare table
CREATE OR REPLACE TABLE CUSTOMERS (
    -- autoincrement to show new data
    CUSTOMER_ID INT AUTOINCREMENT START = 1 INCREMENT =1, 
    FIRST_NAME VARCHAR(40) DEFAULT 'JENNIFER' ,
    CREATE_DATE DATE)
    
-- Create task
CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    -- schedule is always in minutes
    SCHEDULE = '1 MINUTE'
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);
    
-- check the task is no started
SHOW TASKS;

-- Task starting
ALTER TASK CUSTOMER_INSERT RESUME;

-- check new data being inserted
SELECT * FROM CUSTOMERS;

-- Task suspending
ALTER TASK CUSTOMER_INSERT SUSPEND;
```

## Using Cron
```sql

CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 0 7,10 * * 5L UTC'
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);
    
# __________ minute (0-59) - 0 = every full hour
# | ________ hour (0-23)
# | | ______ day of month (1-31, or L) L = last day of the month
# | | | ____ month (1-12, JAN-DEC)
# | | | | __ day of week (0-6, SUN-SAT, or L) 
# | | | | |
# | | | | |
# * * * * *

-- Every minute
SCHEDULE = 'USING CRON * * * * * UTC'

-- Every day at 6am UTC timezone
SCHEDULE = 'USING CRON 0 6 * * * UTC'

-- Every hour starting at 9 AM and ending at 5 PM on Sundays 
-- 9-17 from 9 to 17
-- 9,17 at 9 and at 17
SCHEDULE = 'USING CRON 0 9-17 * * SUN America/Los_Angeles'


CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 0 9,17 * * * UTC'
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);
```  
  
## Trees of tasks
- crate dependencies
- show a graph of dependencies
- the parent task should be scheduled
- child tasks depends on parent task
- a child task can have only 1 parent task as dependency but can have multiple child tasks upstream
- up to 1000 tasks in a tree of tasks
- up to 100 tasks as dependency for a child task
```sql
CREATE TASK ...
    AFTER PARENT_TASK
    AS

-- ALTER and add a task after the other
ALTER TASK
    ADD AFTER
```

## Creating Tree of tasks
```sql
-- select our current db for tasks
USE TASK_DB;
 
-- we should have 1 
SHOW TASKS;

-- we should have a couple rows
SELECT * FROM CUSTOMERS;

-- Prepare a second table
CREATE OR REPLACE TABLE CUSTOMERS2 (
    CUSTOMER_ID INT,
    FIRST_NAME VARCHAR(40),
    CREATE_DATE DATE)
    
-- Suspend parent task
ALTER TASK CUSTOMER_INSERT SUSPEND;
    
-- Create a child task
CREATE OR REPLACE TASK CUSTOMER_INSERT2
    WAREHOUSE = COMPUTE_WH
    AFTER CUSTOMER_INSERT
    AS 
    INSERT INTO CUSTOMERS2 SELECT * FROM CUSTOMERS;
        
-- Prepare a third table
CREATE OR REPLACE TABLE CUSTOMERS3 (
    CUSTOMER_ID INT,
    FIRST_NAME VARCHAR(40),
    CREATE_DATE DATE,
    INSERT_DATE DATE DEFAULT DATE(CURRENT_TIMESTAMP))    
    
-- Create a child task
CREATE OR REPLACE TASK CUSTOMER_INSERT3
    WAREHOUSE = COMPUTE_WH
    AFTER CUSTOMER_INSERT2
    AS 
    INSERT INTO CUSTOMERS3 (CUSTOMER_ID,FIRST_NAME,CREATE_DATE) SELECT * FROM CUSTOMERS2;

-- see that all tasks have ACCOUNTADMIN permission, should eb aware of
SHOW TASKS;

ALTER TASK CUSTOMER_INSERT 
SET SCHEDULE = '1 MINUTE'

-- Resume tasks (first root task)
ALTER TASK CUSTOMER_INSERT RESUME;
ALTER TASK CUSTOMER_INSERT2 RESUME;
ALTER TASK CUSTOMER_INSERT3 RESUME;

SELECT * FROM CUSTOMERS2

SELECT * FROM CUSTOMERS3

-- Suspend tasks again
ALTER TASK CUSTOMER_INSERT SUSPEND;
ALTER TASK CUSTOMER_INSERT2 SUSPEND;
ALTER TASK CUSTOMER_INSERT3 SUSPEND;
```

## Calling a Stored Procedure
```sql
-- Create a stored procedure
USE TASK_DB;

SELECT * FROM CUSTOMERS

CREATE OR REPLACE PROCEDURE CUSTOMERS_INSERT_PROCEDURE (CREATE_DATE varchar)
    RETURNS STRING NOT NULL
    LANGUAGE JAVASCRIPT
    AS
        $$
        var sql_command = 'INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(:1);'
        snowflake.execute(
            {
            sqlText: sql_command,
            binds: [CREATE_DATE]
            });
        return "Successfully executed.";
        $$;
         
CREATE OR REPLACE TASK CUSTOMER_TAKS_PROCEDURE
WAREHOUSE = COMPUTE_WH
SCHEDULE = '1 MINUTE'
AS CALL  CUSTOMERS_INSERT_PROCEDURE (CURRENT_TIMESTAMP);

SHOW TASKS;

ALTER TASK CUSTOMER_TAKS_PROCEDURE RESUME;

SELECT * FROM CUSTOMERS;
```

## Task History and Error Handling
```sql
SHOW TASKS;

-- must be in the context of your db
USE DEMO_DB;

-- Use the table function "TASK_HISTORY()"
select *
  from table(information_schema.task_history())
  order by scheduled_time desc;
  
-- See results for a specific Task in a given time
-- analyze and show what we have in the columns
select *
from table(information_schema.task_history(
    scheduled_time_range_start=>dateadd('hour',-4,current_timestamp()),
    result_limit => 5,
    task_name=>'CUSTOMER_INSERT2'));
  
-- See results for a given time period
select *
  from table(information_schema.task_history(
    scheduled_time_range_start=>to_timestamp_ltz('2021-04-22 11:28:32.776 -0700'),
    scheduled_time_range_end=>to_timestamp_ltz('2021-04-22 11:35:32.776 -0700')));  

-- find out the current timestamp to use in above query  
SELECT TO_TIMESTAMP_LTZ(CURRENT_TIMESTAMP)  
```

## Task with Conditions
- set condition to execute or not a task
- on task_hisotry table can check the condition and error message
- the drawback is that you can use only one function in the WHEN parameter
```sql
CREATE OR REPLACE TASK CUSTOMER_INSERT
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 0 7,10 * * 5L UTC'
    WHEN 1 = 1
    AS 
    INSERT INTO CUSTOMERS(CREATE_DATE) VALUES(CURRENT_TIMESTAMP);
```

# STREAMS

## What are Streams
- To ingest data we usually use use ETL
- Also we use Delta load, just new records appended / insert / deleted on tables
- It is objects record (DML) changes made to table
- This is called CDC - change data capture
- summary: streams are object that have the same columns as destination table and detect any insert / update / or delete operation between the source and destination, by watching a table and seing the changes
- it also show more 3 columns (apart from the table columns)
    - METADATA$ACTION
    - METADATA$UPDATE
    - METADATA$ROW_ID
- The data on stream object is not charged, just a very minimum for the metadata
```sql
CREATE STREAM STREA_NAME
    ON TABLE TABLE_NAME
```

## Insert Operation
- first lets setup the case
```sql
-------------------- Stream example: INSERT SETUP ------------------------
CREATE OR REPLACE TRANSIENT DATABASE STREAMS_DB;

-- Create example table 
-- we gonna track changes on this table and insert to final table in case changes happens
create or replace table sales_raw_staging(
  id varchar,
  product varchar,
  price varchar,
  amount varchar,
  store_id varchar);
  
-- insert values to have something as starting point
insert into sales_raw_staging 
    values
        (1,'Banana',1.99,1,1),
        (2,'Lemon',0.99,1,1),
        (3,'Apple',1.79,1,2),
        (4,'Orange Juice',1.89,1,2),
        (5,'Cereals',5.98,2,1);  

-- create a map table with some extra info
create or replace table store_table(
  store_id number,
  location varchar,
  employees number);

-- insert values to mapping store table, with info about the store
INSERT INTO STORE_TABLE VALUES(1,'Chicago',33);
INSERT INTO STORE_TABLE VALUES(2,'London',12);

-- this will be the final table to insert date with already some more data about store
create or replace table sales_final_table(
  id int,
  product varchar,
  price number,
  amount int,
  store_id int,
  location varchar,
  employees int);

 -- Insert into final table to have same data available
INSERT INTO sales_final_table 
    SELECT 
    SA.id,
    SA.product,
    SA.price,
    SA.amount,
    ST.STORE_ID,
    ST.LOCATION, 
    ST.EMPLOYEES 
    FROM SALES_RAW_STAGING SA
    JOIN STORE_TABLE ST ON ST.STORE_ID=SA.STORE_ID ;
```
- after setup we start with stream creation
```sql
-- Create a stream object
create or replace stream sales_stream on table sales_raw_staging;

-- check info about stream
SHOW STREAMS;

DESC STREAM sales_stream;

-- Get changes on data using stream (INSERTS)
-- should have 0 rows, nothing changed on the tables being checked
select * from sales_stream;

-- staging should have 5 rows
select * from sales_raw_staging;
                            
-- insert values 2 rows to tables being checked
insert into sales_raw_staging  
    values
        (6,'Mango',1.99,1,2),
        (7,'Garlic',0.99,1,1);
        
-- Get changes on data using stream (INSERTS)
-- now should have 2 row, because they were added after table being checked on stream
-- check the metadata columns indicating a insert
select * from sales_stream;

select * from sales_raw_staging;

-- why here we still have the same 5 rows? We need to insert with a command            
select * from sales_final_table;        
        
-- Consume stream object as a source and insert only the missing rows
INSERT INTO sales_final_table 
    SELECT 
    SA.id,
    SA.product,
    SA.price,
    SA.amount,
    ST.STORE_ID,
    ST.LOCATION, 
    ST.EMPLOYEES 
    FROM SALES_STREAM SA
    JOIN STORE_TABLE ST ON ST.STORE_ID=SA.STORE_ID ;

-- final table should now have the 7 rows and stream object must be empty, because they were consumed
-- Get changes on data using stream (INSERTS)
select * from sales_stream;

-- insert values to check it again
insert into sales_raw_staging  
    values
        (8,'Paprika',4.99,1,2),
        (9,'Tomato',3.99,1,2);
```

## Update Operation
```sql
-- ******* UPDATE 1 ********
-- stage shoudl with same rows as before
SELECT * FROM SALES_RAW_STAGING;     

-- we have nmothing in the stream
SELECT * FROM SALES_STREAM;

-- we now update a row in staging instead of inserting
UPDATE SALES_RAW_STAGING
SET PRODUCT ='Potato' WHERE PRODUCT = 'Banana'

-- when checking the stream we see 2 rows, one for update other for delete
-- in the delete we see old value, in insert we see new value (potato)
SELECT * FROM SALES_STREAM;

-- create a new merge query
merge into SALES_FINAL_TABLE F      -- Target table to merge changes from source table
using SALES_STREAM S                -- Stream that has captured the changes
   on  f.id = s.id                 
when matched 
    and S.METADATA$ACTION ='INSERT'
    and S.METADATA$ISUPDATE ='TRUE'        -- Indicates the record has been updated 
    then update 
    set f.product = s.product,
        f.price = s.price,
        f.amount= s.amount,
        f.store_id=s.store_id;
        
-- we see the table updated
SELECT * FROM SALES_FINAL_TABLE

-- stream should be empty also       
SELECT * FROM SALES_STREAM;
```

## Delete Operation
```sql   
-- ******* DELETE  ********           
SELECT * FROM SALES_FINAL_TABLE

SELECT * FROM SALES_RAW_STAGING;     
        
SELECT * FROM SALES_STREAM;    

DELETE FROM SALES_RAW_STAGING
WHERE PRODUCT = 'Lemon';
        
-- ******* Process stream  ********            
    
merge into SALES_FINAL_TABLE F      -- Target table to merge changes from source table
using SALES_STREAM S                -- Stream that has captured the changes
   on  f.id = s.id          
when matched 
    and S.METADATA$ACTION ='DELETE' 
    and S.METADATA$ISUPDATE = 'FALSE'
    then delete               
```

## Process All Data Changes
```sql
-- ******* Process UPDATE,INSERT & DELETE simultaneously  ********                     
merge into SALES_FINAL_TABLE F      -- Target table to merge changes from source table
USING ( SELECT STRE.*,ST.location,ST.employees
        FROM SALES_STREAM STRE
        JOIN STORE_TABLE ST
        ON STRE.store_id = ST.store_id
       ) S
ON F.id=S.id
when matched                        -- DELETE condition
    and S.METADATA$ACTION ='DELETE' 
    and S.METADATA$ISUPDATE = 'FALSE'
    then delete                   
when matched                        -- UPDATE condition
    and S.METADATA$ACTION ='INSERT' 
    and S.METADATA$ISUPDATE  = 'TRUE'       
    then update 
    set f.product = s.product,
        f.price = s.price,
        f.amount= s.amount,
        f.store_id=s.store_id
when not matched 
    and S.METADATA$ACTION ='INSERT'
    then insert 
    (id,product,price,store_id,amount,employees,location)
    values
    (s.id, s.product,s.price,s.store_id,s.amount,s.employees,s.location)
        

-- queries to validate each procedure - insert-delete and update
SELECT * FROM SALES_RAW_STAGING;     
        
SELECT * FROM SALES_STREAM;

SELECT * FROM SALES_FINAL_TABLE;


-- INSERT TEST       
INSERT INTO SALES_RAW_STAGING VALUES (2,'Lemon',0.99,1,1);

-- UPDATE TEST
UPDATE SALES_RAW_STAGING
SET PRODUCT = 'Lemonade'
WHERE PRODUCT ='Lemon'
    
-- DELETE TEST
DELETE FROM SALES_RAW_STAGING
WHERE PRODUCT = 'Lemonade';       


--- Example 2 ---
-- ALL THE OPERATIONS AT ONCE
INSERT INTO SALES_RAW_STAGING VALUES (10,'Lemon Juice',2.99,1,1);

UPDATE SALES_RAW_STAGING
SET PRICE = 3
WHERE PRODUCT ='Mango';
       
DELETE FROM SALES_RAW_STAGING
WHERE PRODUCT = 'Potato';    
```

## Combo: Streams + Tasks
```sql
------- Automatate the updates using tasks --
CREATE OR REPLACE TASK all_data_changes
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('SALES_STREAM') -- condition to only run when stream has data
    AS 
merge into SALES_FINAL_TABLE F      -- Target table to merge changes from source table
USING ( SELECT STRE.*,ST.location,ST.employees
        FROM SALES_STREAM STRE
        JOIN STORE_TABLE ST
        ON STRE.store_id = ST.store_id
       ) S
ON F.id=S.id
when matched                        -- DELETE condition
    and S.METADATA$ACTION ='DELETE' 
    and S.METADATA$ISUPDATE = 'FALSE'
    then delete                   
when matched                        -- UPDATE condition
    and S.METADATA$ACTION ='INSERT' 
    and S.METADATA$ISUPDATE  = 'TRUE'       
    then update 
    set f.product = s.product,
        f.price = s.price,
        f.amount= s.amount,
        f.store_id=s.store_id
when not matched 
    and S.METADATA$ACTION ='INSERT'
    then insert 
    (id,product,price,store_id,amount,employees,location)
    values
    (s.id, s.product,s.price,s.store_id,s.amount,s.employees,s.location)

-- resume the task because they are by default not started
ALTER TASK all_data_changes RESUME;

-- check if task is created
SHOW TASKS;


-- Change data to test
INSERT INTO SALES_RAW_STAGING VALUES (11,'Milk',1.99,1,2);
INSERT INTO SALES_RAW_STAGING VALUES (12,'Chocolate',4.49,1,2);
INSERT INTO SALES_RAW_STAGING VALUES (13,'Cheese',3.89,1,1);

UPDATE SALES_RAW_STAGING
SET PRODUCT = 'Chocolate bar'
WHERE PRODUCT ='Chocolate';
       
DELETE FROM SALES_RAW_STAGING
WHERE PRODUCT = 'Mango';    


-- Verify results
-- stage should be changed
SELECT * FROM SALES_RAW_STAGING;     
-- stream shoudl have the data changed (if the task did not run yet)        
SELECT * FROM SALES_STREAM;
-- after task run (1min) final table should have the new updates
SELECT * FROM SALES_FINAL_TABLE;


-- Verify the history
select *
from table(information_schema.task_history())
order by name asc,scheduled_time desc;
```

## Types of Streams
- there are 2 types of streams
- the default is the one we used
- can see the stream mode by SHOW STREAM on mode columns
- STANDARD
    - capture all data changes
    - insert, update and delete
- APPEND ONLY
    - only use INSERT
```sql
------- Append-only type ------
USE STREAMS_DB;
SHOW STREAMS;

SELECT * FROM SALES_RAW_STAGING;     

-- Create stream with default
CREATE OR REPLACE STREAM SALES_STREAM_DEFAULT
ON TABLE SALES_RAW_STAGING;

-- Create stream with append-only
CREATE OR REPLACE STREAM SALES_STREAM_APPEND
ON TABLE SALES_RAW_STAGING 
APPEND_ONLY = TRUE;

-- View streams
SHOW STREAMS;


-- Insert values
INSERT INTO SALES_RAW_STAGING VALUES (14,'Honey',4.99,1,1);
INSERT INTO SALES_RAW_STAGING VALUES (15,'Coffee',4.89,1,2);
INSERT INTO SALES_RAW_STAGING VALUES (15,'Coffee',4.89,1,2);

-- aftger inser should see both streams have 3 rows
SELECT * FROM SALES_STREAM_APPEND;
SELECT * FROM SALES_STREAM_DEFAULT;

-- Delete values
DELETE FROM SALES_RAW_STAGING WHERE ID=7;

-- after delete, only the default stream should have 4 rows, because append only do not detect the deletion
SELECT * FROM SALES_STREAM_APPEND;
SELECT * FROM SALES_STREAM_DEFAULT;


-- Consume stream via "CREATE TABLE ... AS"
CREATE OR REPLACE TEMPORARY TABLE PRODUCT_TABLE
AS SELECT * FROM SALES_STREAM_DEFAULT;
CREATE OR REPLACE TEMPORARY TABLE PRODUCT_TABLE
AS SELECT * FROM SALES_STREAM_APPEND;


-- Update
UPDATE SALES_RAW_STAGING
SET PRODUCT = 'Coffee 200g'
WHERE PRODUCT ='Coffee';
       

SELECT * FROM SALES_STREAM_APPEND;
SELECT * FROM SALES_STREAM;
```

## Changes Clause
- Changes is another method to capture data changes, different from streams
- in changes different from streams is that we use TT and the differences are not consumed
```SQL
----- Change clause ------ 
--- Create example db & table ---
CREATE OR REPLACE DATABASE SALES_DB;

create or replace table sales_raw(
	id varchar,
	product varchar,
	price varchar,
	amount varchar,
	store_id varchar);

-- insert values
insert into sales_raw
	values
		(1, 'Eggs', 1.39, 1, 1),
		(2, 'Baking powder', 0.99, 1, 1),
		(3, 'Eggplants', 1.79, 1, 2),
		(4, 'Ice cream', 1.89, 1, 2),
		(5, 'Oats', 1.98, 2, 1);

-- this is how to track the changes
ALTER TABLE sales_raw
SET CHANGE_TRACKING = TRUE;

-- usgin the changes
SELECT * FROM SALES_RAW
CHANGES(information => default) -- defaulkt see all changes
AT (offset => -0.5*60) -- see the changes using time travel

-- can use the timestamp in the TT 
-- get the timestamp before inserting the values below
SELECT CURRENT_TIMESTAMP;

-- Insert values
INSERT INTO SALES_RAW VALUES (6, 'Bread', 2.99, 1, 2);
INSERT INTO SALES_RAW VALUES (7, 'Onions', 2.89, 1, 2);

-- paste the timestamp below in the query, run and see the changed values
SELECT * FROM SALES_RAW
CHANGES(information  => default)
AT (timestamp => 'your-timestamp'::timestamp_tz)

-- if updateing should also
UPDATE SALES_RAW
SET PRODUCT = 'Toast2' WHERE ID=6;


-- should see the update row
SELECT * FROM SALES_RAW
CHANGES(information  => default)
AT (timestamp => 'your-timestamp'::timestamp_tz)

-- should not see the update row
SELECT * FROM SALES_RAW
CHANGES(information  => append_only)
AT (timestamp => 'your-timestamp'::timestamp_tz)

SELECT * FROM PRODUCTS;
```

# MATERIALIZED VIEWS

## What are Materialized views ?
- Imagine you have a view that take long time to run, it cause issues:
    - bad user experience
    - processing cost increase
- Matelized view solve this kind of problem
- Mateliazed view saves the data in a table to make the query speed faster
- And everytime the sources tables change, it automatically update the MV table
- It joins the best of both worlds

## Using Materialized view
```sql
-- Remove caching just to have a fair test -- Part 1
ALTER SESSION SET USE_CACHED_RESULT=FALSE; -- disable global caching
ALTER warehouse compute_wh suspend;
ALTER warehouse compute_wh resume;


-- Prepare table
CREATE OR REPLACE TRANSIENT DATABASE ORDERS;

CREATE OR REPLACE SCHEMA TPCH_SF100;

CREATE OR REPLACE TABLE TPCH_SF100.ORDERS AS
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS;

SELECT * FROM ORDERS LIMIT 100


-- Example statement view that we use very frequently for a lot of users-- 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE);

-- Create materialized view
-- to speed up the queries from users
CREATE OR REPLACE MATERIALIZED VIEW ORDERS_MV
AS 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE);

-- column behind by show many seconds behind the real table
-- last refresh time column
-- show also it is not a secure view
SHOW MATERIALIZED VIEWS;

-- Query view and then query the real table and see the difference
SELECT * FROM ORDERS_MV
ORDER BY YEAR;
```

## Refresh MA
```sql
-- UPDATE or DELETE values to test
UPDATE ORDERS
SET O_CLERK='Clerk#99900000' 
WHERE O_ORDERDATE='1992-01-01'

-- Test updated data --
-- Example statement view -- 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE);

-- Query view
-- it initially may not appear the changes because it may take some time
-- afterr changes, first query on the view may take some time
-- check the command below
SELECT * FROM ORDERS_MV
ORDER BY YEAR;

-- if MA not refreshe, we see the behind time with some seconds
-- also the refresh data and compact date are also not changed
SHOW MATERIALIZED VIEWS;
```

## Costs
- we do not use our WH to process it, it is an underlying process managedd by SF
- So, there are aditional costs
- can see the costs byt selecting account admin > account > usage , and see the MV costs
- or can use the qyery below
```sql
select * from table(information_schema.materialized_view_refresh_history())
```

## When to use MV
- Cases
    - when a view is taking too long to run
    - and the underlying data o not change very frequently an on a regular basis
- alternative for tables that change frequently are tasks + streams
    - create a stream that checks changes on data source and update the underlying table
    - everytime there is new data on underlying table a task update the final table
    - this give us control over how frequent to update the final table 
    - thius helping on reducing costs

## MV Liimitations
- only available on enterprise or higher
- self joins are not supported and joiins are not also
- some aggregations functions are not supported
- having, order,  limit an UDFs also not supported

# DYNAMIC DATA MASKING

## What is Data Masking
- this is a columns level security feature
- it is fully customized
- can be assigned to roles

## Creating a Masking Policy
```sql
USE DEMO_DB;
USE ROLE ACCOUNTADMIN;

-- Prepare table --
create or replace table customers(
  id number,
  full_name varchar, 
  email varchar,
  phone varchar,
  spent number,
  create_date DATE DEFAULT CURRENT_DATE);

-- insert values in table --
insert into customers (id, full_name, email,phone,spent)
values
  (1,'Lewiss MacDwyer','lmacdwyer0@un.org','262-665-9168',140),
  (2,'Ty Pettingall','tpettingall1@mayoclinic.com','734-987-7120',254),
  (3,'Marlee Spadazzi','mspadazzi2@txnews.com','867-946-3659',120),
  (4,'Heywood Tearney','htearney3@patch.com','563-853-8192',1230),
  (5,'Odilia Seti','oseti4@globo.com','730-451-8637',143),
  (6,'Meggie Washtell','mwashtell5@rediff.com','568-896-6138',600);



-- set up roles
-- test with 2 roles
CREATE OR REPLACE ROLE ANALYST_MASKED;
CREATE OR REPLACE ROLE ANALYST_FULL;

-- grant select on table to roles
GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CUSTOMERS TO ROLE ANALYST_MASKED;
GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CUSTOMERS TO ROLE ANALYST_FULL;

GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ANALYST_MASKED;
GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ANALYST_FULL;

-- grant warehouse access to roles
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ANALYST_MASKED;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ANALYST_FULL;

-- assign roles to a user (in this case, us)
GRANT ROLE ANALYST_MASKED TO USER NIKOLAISCHULER;
GRANT ROLE ANALYST_FULL TO USER NIKOLAISCHULER;



-- Set up masking policy
create or replace masking policy phone 
    as (val varchar) returns varchar ->
            case        
            when current_role() in ('ANALYST_FULL', 'ACCOUNTADMIN') then val
            else '##-###-##'
            end;
  
-- Apply policy on a specific column 
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN phone 
SET MASKING POLICY PHONE;



-- Validating policies
USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;

USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;
```

## Unset and Replace Policy
```sql
--#### More examples  #####
USE ROLE ACCOUNTADMIN;
--- 1) Apply policy to multiple columns
-- Apply policy on a specific column 
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN full_name 
SET MASKING POLICY phone;
-- Apply policy on another specific column 
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN phone
SET MASKING POLICY phone;



--- 2) Replace or drop policy
-- if trying to alter the policy, you need to unset the policy
DROP masking policy phone;

-- List and describe policies
DESC MASKING POLICY phone;
SHOW MASKING POLICIES;

-- Show columns with applied policies
SELECT * FROM table(information_schema.policy_references(policy_name=>'phone'));

-- Remove policy before replacing/dropping 
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN full_name 
UNSET MASKING POLICY phone;

ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN email
UNSET MASKING POLICY;

ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN phone
UNSET MASKING POLICY;



create or replace masking policy phone as (val varchar) returns varchar ->
            case
            when current_role() in ('ANALYST_FULL', 'ACCOUNTADMIN') then val
            else CONCAT(LEFT(val,2),'*******')
            end;

-- replace policy
create or replace masking policy names as (val varchar) returns varchar ->
            case
            when current_role() in ('ANALYST_FULL', 'ACCOUNTADMIN') then val
            else CONCAT(LEFT(val,2),'*******')
            end;

-- apply policy
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN full_name
SET MASKING POLICY names;


-- Validating policies
USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;

USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;
```

## Alter an Existing Policy
- recreating a policy remove the columns it was applied
- if qant to change the policy and keep it applied where it is, we should alter the policy
```sql
-- Alter existing policies 
USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;

USE ROLE ACCOUNTADMIN;

alter masking policy phone set body ->
case        
 when current_role() in ('ANALYST_FULL', 'ACCOUNTADMIN') then val
 else '**-**-**'
 end;

            
ALTER TABLE CUSTOMERS MODIFY COLUMN email UNSET MASKING POLICY;
```

## Masking Examples

```sql
--### More examples - 1 - ###
-- leave email domain unmasked
USE ROLE ACCOUNTADMIN;

create or replace masking policy emails as (val varchar) returns varchar ->
case
  when current_role() in ('ANALYST_FULL') then val
  when current_role() in ('ANALYST_MASKED') then regexp_replace(val,'.+\@','*****@') -- leave email domain unmasked
  else '********'
end;

-- apply policy
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN email
SET MASKING POLICY emails;
-- Validating policies
USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;

USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;

USE ROLE ACCOUNTADMIN;



--### More examples - 2 - ###
--return hash of the column value
-- this is still traceable hashing 
create or replace masking policy sha2 as (val varchar) returns varchar ->
case
  when current_role() in ('ANALYST_FULL') then val
  else sha2(val) -- return hash of the column value
end;

-- apply policy
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN full_name
SET MASKING POLICY sha2;

ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN full_name
UNSET MASKING POLICY;

-- Validating policies
USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;

USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;

USE ROLE ACCOUNTADMIN;


-- ### More examples - 3 - ###
-- returns 0001-01-01 00:00:00.000
create or replace masking policy dates as (val date) returns date ->
case
  when current_role() in ('ANALYST_FULL') then val
  else date_from_parts(0001, 01, 01)::date -- returns 0001-01-01 00:00:00.000
end;

-- Apply policy on a specific column 
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN create_date 
SET MASKING POLICY dates;

-- Validating policies
USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;

USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;
```

# ACCESS MANAGEMENT

## What is Access Management
- Management of who can access and perfom actions on objects in snowflake
- There are 2 aspect of access control combined
    - DAC - Discretionary Access Control: each object has an owner who can grant access to that object
    - RBAC - Access privileges are assigned to roles, which are in turn assigned to users
Example:
```
                                |--> USER 0
ROLE 1 ---> TABLE 1 ---> ROLE 2 ---> USER 1
                    |--> ROLE 3 ---> USER 2
                                |--> USER 3
```
- Role 1 create tables 1 and then role 1 can give access to the table to whomever he wants
- Role 1 grive access to the table to Roles 2 and 3
- User 0 and 1 have the Role 2, so they can read table 1
- same for roles 3 and the users that have this roles
We have also 2 level off objects: Account Objects and Schema Objects. The schema objects are under the Database Object (which is an Account object)
    - ACCOUNT OBJECTS:  user, role, database, warehouse ...
    - SCHEMA OBJECTS: table, view, stage, integration....
- Every object is owned by a single row
- Owner roles has all privileges by default

### Key Concepts
- USER: Perople or system
- Role: entity taht receives the privileges
- Privilege: Level of access to an object (select, delete, create...)
- Securable Object: Object to which privileges can be granted

## Snowflake Roles Overview
- there are 5 system defined roles
- ACCOUNTADMIN: can do all that opther roles do (limited users should have it)
- SECURITYADMIN: Do all USERADMIN can, manage users and roles, manage any object grant globally
- SYSADMIN: create WH and DB, recommended all custom roles are assigned this
- USERADMIN: dedicated to user and role management only, create roles and users
- PUBLIC: all user have this access, create own objects like other roles

## ACCOUNTADMIN
- To level roles
- Manage  & view all objects
- All configurations on account level
- All account operations (billing, create readear account)
- automatically assigned to first user
- Used mainly to initial setup & managin account level objects 
BEST PRACTICES
- very controlled and few users should have it
- all user with it should have MFA
- at least 2 users should have this role 
- avoid creating object with this role unless you have to

## ACCOUNTADMIN in practice
- Select the ACCOUNTADMIN Role
- on UI you can then see the Account icon, enter on it, and you can manage
    - Billing and payment
    - reader account
    - usage 
    - Users
    - Roles
    - sessions
    - Policies
    - Resource Monitor
- this role can also create MFA
    - click arrow beside user > preferences > general > Enrol MFA > add phone number
- Can also set other account admins:
```sql
--- User 1 ---
CREATE USER maria PASSWORD = '123' 
DEFAULT_ROLE = ACCOUNTADMIN 
MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE ACCOUNTADMIN TO USER maria;

--- User 2 ---
CREATE USER frank PASSWORD = '123' 
DEFAULT_ROLE = SECURITYADMIN 
MUST_CHANGE_PASSWORD = TRUE;

GRANT ROLE SECURITYADMIN TO USER frank;

--- User 3 ---
CREATE USER adam PASSWORD = '123' 
DEFAULT_ROLE = SYSADMIN 
MUST_CHANGE_PASSWORD = TRUE;
GRANT ROLE SYSADMIN TO USER adam;
```

## SECUTIRYADMIN    
- Still have some access to Account tab, but limitedd
- Can create and manage users and roles
- Grant and Revoke privileges to roles

## SECUTIRYADMIN in Practice
- we have created some roles before, lets re use them
- for this example we gonna create a sales Admin role as child of SYSADMIN, and a Sales Role as a child os Sales Admin
- Also, for testing, we will create a HR Admin Role (NOT CHILD OF SYSADMIN) and HR Role child of HR ADMIN (TO SHOW PROBLEMS)
```sql
-- SECURITYADMIN role --
--  Create and Manage Roles & Users --
-- Create Sales Roles & Users for SALES--
-- first login with frank account, created on past lecture
-- enter the context of SECURITYADMIN to perform below actions
create role sales_admin;
create role sales_users;

-- Create hierarchy
grant role sales_users to role sales_admin;

-- As per best practice assign roles to SYSADMIN
grant role sales_admin to role SYSADMIN;

-- create sales user
CREATE USER simon_sales PASSWORD = '123' DEFAULT_ROLE =  sales_users 
MUST_CHANGE_PASSWORD = TRUE;
GRANT ROLE sales_users TO USER simon_sales;

-- create user for sales administration
CREATE USER olivia_sales_admin PASSWORD = '123' DEFAULT_ROLE =  sales_admin
MUST_CHANGE_PASSWORD = TRUE;
GRANT ROLE sales_admin TO USER  olivia_sales_admin;

-----------------------------------
-- lets to the same thing here, but not assing the admin to sysadmin
-- Create Sales Roles & Users for HR--
create role hr_admin;
create role hr_users;

-- Create hierarchy
grant role hr_users to role hr_admin;

-- This time we will not assign roles to SYSADMIN (against best practice)
-- grant role hr_admin to role SYSADMIN;

-- create hr user
CREATE USER oliver_hr PASSWORD = '123' DEFAULT_ROLE =  hr_users 
MUST_CHANGE_PASSWORD = TRUE;
GRANT ROLE hr_users TO USER oliver_hr;

-- create user for sales administration
CREATE USER mike_hr_admin PASSWORD = '123' DEFAULT_ROLE =  hr_admin
MUST_CHANGE_PASSWORD = TRUE;
GRANT ROLE hr_admin TO USER mike_hr_admin;
```
- we used the SECURITYADMIN for its purpose or creating security via roles
- next lecture lets see why we need to assing admin roles to SYSADMIN

## SYSADMIN
- Can create  and manage objects: WH, DB , tables, etc
- Custom roles should be assigned to the SYSADMIN as the parent
- Then, this role has the ability to grant provileges on WH, DB, and other objects to the custom rols
- This is the recommended best practice

## SYSADMIN in Practice
- for this practice we gonna create VW, DB and tables and assign it to the custom roles
```sql
-- SYSADMIN --
-- login as Adam, roles created in previous lecture
-- Create a warehouse of size X-SMALL
create warehouse public_wh with
warehouse_size='X-SMALL'
auto_suspend=300 
auto_resume= true

-- grant usage to role public
grant usage on warehouse public_wh 
to role public

-- create a database accessible to everyone
create database common_db;
grant usage on database common_db to role public;

-- create sales database for sales
create database sales_database;
grant ownership on database sales_database to role sales_admin;
grant ownership on schema sales_database.public to role sales_admin

-- see the owner of each DB
SHOW DATABASES;

-- create database for hr
create database hr_db;
-- grant the ownership to hr_admin
grant ownership on database hr_db to role hr_admin;
-- try to grant something else, not possible because hr_admin is not a child of SYSADMIN
-- we can no longer do anyrhing
-- it makes really hard to sysadmin to manage the roles
grant ownership on schema hr_db.public to role hr_admin;
```

## Custom Roles
- used to customize roles according to needs and also reflect the hierarchy on your company
- they are usually created by SECURITYADMIN
- also assigned to SYSADMIN to allow it to manage

## Custom Roles in Practice
- we gonna reuse the roles created on previous lecture to test
- continue logged as Adam and on contect of sysadmin

```sql
-- select the roles to administrate sales objects
USE ROLE SALES_ADMIN;
USE SALES_DATABASE;

-- Create table -  we are the owner of it
create or replace table customers(
  id number,
  full_name varchar, 
  email varchar,
  phone varchar,
  spent number,
  create_date DATE DEFAULT CURRENT_DATE);

-- insert values in table --
insert into customers (id, full_name, email,phone,spent)
values
  (1,'Lewiss MacDwyer','lmacdwyer0@un.org','262-665-9168',140),
  (2,'Ty Pettingall','tpettingall1@mayoclinic.com','734-987-7120',254),
  (3,'Marlee Spadazzi','mspadazzi2@txnews.com','867-946-3659',120),
  (4,'Heywood Tearney','htearney3@patch.com','563-853-8192',1230),
  (5,'Odilia Seti','oseti4@globo.com','730-451-8637',143),
  (6,'Meggie Washtell','mwashtell5@rediff.com','568-896-6138',600);
  
SHOW TABLES;

-- query from table --
-- with roles sales_admin we should be able to query it
-- changing to sales_user we should not be able
SELECT* FROM CUSTOMERS;
USE ROLE SALES_USERS;
SELECT* FROM CUSTOMERS;


-- grant usage to role
USE ROLE SALES_ADMIN;

GRANT USAGE ON DATABASE SALES_DATABASE TO ROLE SALES_USERS;
GRANT USAGE ON SCHEMA SALES_DATABASE.PUBLIC TO ROLE SALES_USERS;
GRANT SELECT ON TABLE SALES_DATABASE.PUBLIC.CUSTOMERS TO ROLE SALES_USERS


-- Validate privileges --
USE ROLE SALES_USERS;
SELECT* FROM CUSTOMERS; -- able
DROP TABLE CUSTOMERS; -- not able
DELETE FROM CUSTOMERS; -- not able
SHOW TABLES;

-- grant DROP on table
-- now user should be able to delete
USE ROLE SALES_ADMIN;
GRANT DELETE ON TABLE SALES_DATABASE.PUBLIC.CUSTOMERS TO ROLE SALES_USERS
```

## USERADMIN
- dedicated to users and roles ( user and roles management )
- the diferenece between this and securityadmin is that this one cant grant much privileges (only to the object it owns)

## USERADMNI in Practice
- lets try to solve the HR_ADMIN Problem with objects created that are not linked to sysadmin
```sql
-- USERADMIN --
-- set the context to USERADMIN
--- User 4 ---
CREATE USER ben PASSWORD = '123' 
DEFAULT_ROLE = ACCOUNTADMIN 
MUST_CHANGE_PASSWORD = TRUE;

-- try to grant the role using useradmin, will not work
-- then try with sysadmin, should work
GRANT ROLE HR_ADMIN TO USER ben;

SHOW ROLES;
-- with secutiry admin you can the fix the HR_ADMIN not linked to SYSADMIN
-- this is thge main difference: USER ADMIN cant grant accesss to other roles, because it has small priovileges
GRANT ROLE HR_ADMIN TO ROLE SYSADMIN;
```

## PUBLIC
- Least privileged roles
- every user have this roles
- can own objects, and this is avaialbe to all users
- useful for data that should be accessible to everyone
- the last one in the hierarchy

# PARTNER CONNECT
- Can easily integrate with partners
- need to be on account admin role
- of course, the parter will charge but give you a 14 trial
- do a sample with mattilion

# BEST PRACTICES

## Most common Best Practices
- Virtual Warehouse
- Table design
- Retention Period
- Monitoring

## Virtual Warehouses
- Alway enable auto-suspend 
- Enable auto resume
- Set appropriate timeouts for auto-suspend
    - ETL / data load -> set to minimum, 1min
    - BI -> set to 10min or higher to enable use of caching
    - DEV or DS -> set to 5min, since the queries change all the time
- set the correct size
    - complex queries -> englare the VW
    - if many concurrent query, enable multi cluster

## Table Design
- choose appropriate table table
    - for staging table, use transient table
    - it saves money (failsafe 7 days storage, 1 day TT)
    - for production, use permanent
    - Development tables - transient tables (reducing TT and failsafe cost)
- Appropriate data type
    - for dates always use date format, no varchar for example, because date is more efficient
    - numbers always on number format because they are also more efficient
    - use varchar(n) when possible to find errors and reduce storage 
- Set cluster keys only if necessary
    - only for large tables (TBs and on)
    - Most query time for table scan in the query profiling
    - use it on dimensions: for ecample we have a table with data arriving on natural order being added by transaction date but we very ofter filter on a dimenion, lets say region, could be a good idea to add a cluster key on region

## Monitoring
- 1 way of monitoring the usage is loggin as ACCOUNTADMIN > Account > usage of data storage and credits
- to analyze more specifically, we can query and visualize in a BI tool
```sql
-- Table Storage
SELECT * FROM "SNOWFLAKE"."ACCOUNT_USAGE"."TABLE_STORAGE_METRICS";

-- How much is queried in databases
SELECT * FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY";

SELECT 
DATABASE_NAME,
COUNT(*) AS NUMBER_OF_QUERIES,
SUM(CREDITS_USED_CLOUD_SERVICES)
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."QUERY_HISTORY"
GROUP BY DATABASE_NAME;

-- Usage of credits by warehouses
SELECT * FROM "SNOWFLAKE"."ACCOUNT_USAGE"."WAREHOUSE_METERING_HISTORY";

-- Usage of credits by warehouses // Grouped by day
SELECT 
DATE(START_TIME),
SUM(CREDITS_USED)
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."WAREHOUSE_METERING_HISTORY"
GROUP BY DATE(START_TIME);

-- Usage of credits by warehouses // Grouped by warehouse
SELECT
WAREHOUSE_NAME,
SUM(CREDITS_USED)
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."WAREHOUSE_METERING_HISTORY"
GROUP BY WAREHOUSE_NAME;

-- Usage of credits by warehouses // Grouped by warehouse & day
SELECT
DATE(START_TIME),
WAREHOUSE_NAME,
SUM(CREDITS_USED)
FROM "SNOWFLAKE"."ACCOUNT_USAGE"."WAREHOUSE_METERING_HISTORY"
GROUP BY WAREHOUSE_NAME,DATE(START_TIME);
```

## Retention Period
- for staging db or schema, we should use transient table, and zero retention days to save storage (Failsafe and TT)
- production table should be at least 1 day, but good to be 4-7 days
Example of storage
- I have a 20gb table being updated 20x a day, the active storage is 20gb, but the TT storage for 1 day is 400gb, and the faile safe storage is around 2.8Tb. 
- This is a good case of zero retention periods, specially if the data continues available in other source