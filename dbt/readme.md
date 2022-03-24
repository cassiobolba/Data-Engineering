# DBT Fundamentals

## 1. Who is an Analytical Engineer

### 1.1 Traditional Data Teams
* 2 roles
    * DE -> responsible for etl, orchestrate, clean, store , python, java
    * DA -> Dashboard, analitycs , excel sql, power bi
* There is a gap between these roles
* DE usually know only how to build
* DA only know how analyze, query, business rules

### 1.2 ETL and ELT
* ETL
    * Usually ETL is handled by DE
    * Require programing skills
    * Usually use the traditional data teams
* ELT 
    * Cloud DW changed the world
        * it is more scalable
        * Scalable storage
        * Reduction os transfer data time 
    * Now data can be stored directly on DW for later transformation
    * Data can be transformed as needed by analysts
    * Enabled analytics engineer new role

### 1.3 Analytics Engineer
* Focused on transforming the raw data up to BI layer
* Analysts take it from there and work with analytics engineer 
* DE is now focused on loading raw datam infrastructure
* Modern Data Team
    * DE + AE + DA

image dbt_and_alatycs_engineer

### 1.4 The Modern Data Stack

image modern_data_platform

* We have various data sources
* These data need to arrive to the company data platform
* Can be done by python, cloud services (many options)
* Data platform serve data to Bi tools
* dbt enters in the Data Platform

image dbt_workflow

* dbt allows:
    * develop data transformations focused on sql modules (sql selects basically)
    * create tests (unique pk, not null values) and reuse the tests
    * document the data transformations while you write the code
    * deploy the data to data platform for bi purposes mantaining the data lineage documenteded
    * create test pipelines and schedule periodically tests
    * dbt is the T in ELT platforms
    * dbt empowers data teams to leverage software engineering principles for transforming data

## 2. Setup DBT 
create free accounts on:
* dbt cloud -> https://www.getdbt.com
* a cloud dw provider (BQ and snowflake are recomended) -> https://snowflakecommunity.force.com/s/
* git hub account -> https://github.com
* Create databases and schema with script **insert_sf_dbt_training_data.sql**

### 2.2 Set Up DBT Cloud
* go to your project in dbt 
* go the add a new database - Ill be usgin snowflake
* fill the following info:
    * account (in snowflake panel, under organization)
    * database (for this demo is Analytics - we created via sql before)
    * warehouse (for this demo is transforming - we created via sql before)
    * then fill user ans password
    * hit test to check, then finalize