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