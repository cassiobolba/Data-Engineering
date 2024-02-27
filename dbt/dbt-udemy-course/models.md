### Models
SQL definitions that materliaze as tables and views and contain all business logics.   

#### SRC models
[src_hosts](./dbt-course-udemy/dbt_project/models/src/src_hosts.sql)    
[src_listings](./dbt-course-udemy/dbt_project/models/src/src_listings.sql)    
[src_reviews](./dbt-course-udemy/dbt_project/models/src/src_reviews.sql)   

#### ref tag
Jinja template tag (jinja is a template engine).   
DBT depends heavilly in jinja, used a lot for macros.   
To query from a src table:
```sql
  SELECT
    *
  FROM
    {{ ref('src_listings') }}
```

### Materializations 
4 types:
* view
* table
* Incremental (append only)
* Ephemeral (create CTE)

#### Project Level Materialization
Setup in the file [dbt_project.yml](./dbt-course-udemy/dbt_project/dbt_project.yml) by the code below. All folders in the project will be by default views. But, dim folder models not, they are tables (except if there is a model specific materialization config in the sql file).
```yml
models:
  dbt_project:
    # Config indicated by + and applies to all files under models/example/
    +materialized: view
    dim:
      +materialized: table
```

#### Incremental Materizalization
like in [fct_reviews.sql](./dbt-course-udemy/dbt_project/models/fct/fct_reviews.sql). Can only append.To test the incremental model, Get every review for listing 3176:
```sql
SELECT * FROM "AIRBNB"."DEV"."FCT_REVIEWS" WHERE listing_id=3176;
```
Add a new record to the table:
```sql
INSERT INTO "AIRBNB"."RAW"."RAW_REVIEWS"
VALUES (3176, CURRENT_TIMESTAMP(), 'Zoltan', 'excellent stay!', 'positive');
```
Making a full-refresh:
```bash
dbt run --full-refresh
```

#### Ephemeral Materizalization
good for staging data. can also set in the project level on [dbt_project.yml](./dbt-course-udemy/dbt_project/dbt_project.yml).   
Since we changed all views in source to ephemeral we can drop the views.  
Now the src folder queries were converted to ephemeral, it is no longer shown as tables or views when running dbt run command. They are converted to CTEs during query compilations when running dbt run.   
For example dim_hosts_cleansed use src_hosts, and to see the full query compiled with the now ephemeral materialization in src queries, go to the target folder and see it [here](./dbt_project/target/compiled/dbt_project/models/dim/dim_hosts_cleansed.sql), but you can only see this file in your local, because target folder is hiden. But the query look like this:
```sql
WITH  __dbt__cte__src_hosts as (
WITH raw_hosts AS (
    SELECT
        *
    FROM
       AIRBNB.RAW.RAW_HOSTS
)
SELECT
    id AS host_id,
    NAME AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    raw_hosts
), src_hosts AS (
    SELECT
        *
    FROM
        __dbt__cte__src_hosts
)
SELECT
    host_id,
    NVL(
        host_name,
        'Anonymous'
    ) AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    src_hosts
```

### Seed x Sources
#### Seeds
In seeds folder we can create static data by dropping csv files there. Goog for lookups data entered manually.
#### Sources
Add 1 more semantic layer in DBT, good for lineage.   
Intead of reading from raw tables, can read from sources created in [sources.yml](./dbt_project/target/compiled/dbt_project/models/sources.yml) using the jinja macro for sources:
```sql
SELECT * FROM
 --AIRBNB.RAW.RAW_REVIEWS
{{ source ('airbnb','reviews') }}
```
run compile to see if it works (or run the project)
```bash
dbt compile
```

### Source Freshness
Can set for each source the freshness to check last time the column was updated based on date column. Check [sources.yml](./dbt_project/target/compiled/dbt_project/models/sources.yml) to see how to implement, and then run the command:
```bash
dbt source freshness
```

### Snapshots
Used to handle type 2 SCD