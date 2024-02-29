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
For example dim_hosts_cleansed use src_hosts, and to see the full query compiled with the now ephemeral materialization in src queries, go to the target folder and see it [here](./dbt_project/target/compiled/dbt_project/models/dim/dim_hosts_cleansed.sql), but you can only see this file in your local, because target folder is hiden. 

### Seed x Sources
#### Seeds
In seeds folder we can create static data by dropping csv files there. Goog for lookups data entered manually.
#### Sources
Add 1 more semantic layer in DBT, good for lineage.   
Intead of reading from raw tables, can read from sources created in [sources.yml](./dbt_project/models/sources.yml) using the jinja macro for sources:
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
Can set for each source the freshness to check last time the column was updated based on date column. Check [sources.yml](./dbt_project/models/sources.yml) to see how to implement, and then run the command:
```bash
dbt source freshness
```

### Snapshots
Used to handle type 2 SCD.   
2 Strategies available:
* Timestamp: A unique ley and an updated_at field is defined on the source model, these columns are used for determining changes.
* check: Any change in a set of columns (or all columns) will be picked up as an update.

#### Implementing
Snapshots live in their folder, like [scd_raw_listings.sql](./dbt_project/snapshots/scd_raw_listings.sql), and they ran over a different command:
```bash
dbt snapshot
```
Some columns are added as metadata to use snapshots: DBT_ID, DBT_UPDATED_AT, DBT_VALID_FROM and DBT_VALID_TO. What matter are valid from and valid to, to identify changes. Current data does have valid to as null. When they change a new line is inserted and the old line has a valid to value until when it was valid.   
To test the snapshot:
```sql
UPDATE AIRBNB.RAW.RAW_LISTINGS SET MINIMUM_NIGHTS=30,
    updated_at=CURRENT_TIMESTAMP() WHERE ID=3176;

SELECT * FROM AIRBNB.DEV.SCD_RAW_LISTINGS WHERE ID=3176;
```

### DBT Tests
2 types of tests: 
* Singular 
    * queries created by user, returining empty resultset
* Generic
    * unique, not_null, accepted_values, relationships

#### Generic Test
Create a file called [schema.yml](./dbt_project/models/schema.yml) in models. This is not mandatory, you can create sepatare files inside each model folder, as you wish to organize it. Test it with:
```bash
dbt test
```
Can also check the compiled queries in target folder to see the query created.   
To check a failure, change one of the accepted values to a fake value and run the tests, it should break.

### Single Test
Live in the test folder and are queries, like [dim_listings_minimum_nights.sql](./dbt_project/tests/dim_listings_minimum_nights.sql).   
You can run as dbt test to execute all tests, or can execute just this test (same approach works to dbt run and other dbt commands).
```bash
dbt test --select dim_listings_cleansed
```

### Macros, Custom Tests and Packages
* Macros are jinja templates created in macro folder
* There are many built in macros
* Can be used in model definitions and tests
* A special macro called test can be used to create own generic tests
* Packages can be downloaded with more macros and tests
* in jinja there are control loops and so on, must the study jinja to do more advanced stuff

Create a new macro on macro folders as [no_nulls_in_columns.sql](./dbt_project/macros/no_nulls_in_columns.sql) and then call the macro in tests, creating a specific test like [no_nulls_in_dim_listings.sql](./dbt_project/tests/no_nulls_in_dim_listings.sql), now run dbt tests anc check

#### Custom Generic Tests with Macros
we previously create a single test [dim_listings_minimum_nights.sql](./dbt_project/tests/dim_listings_minimum_nights.sql), but we can conver to generic test, so availalbe to all models. They also live in macros folder, and can be converted from the previous file to [positive_values.sql](./dbt_project/macros/positive_values.sql), and then need to set the test in [schema.yml](./dbt_project/models/schema.yml).

#### Packages
[Available Packages](https://hub.getdbt.com)   
We are testing [dbt-utils funcions](https://github.com/dbt-labs/dbt-utils/tree/1.1.1/).   
To install, must be set in the [packages.yml](./dbt-course-udemy/dbt_project/packages.yml) and execute dbt deps.   
Lets use the generate_surrogate_key funtion in [scd_raw_listings.sql](./dbt_project/models/fct/fct_reviews.sql).   
If executing dbt run, it will fail because fct_reviews is incremental, and we set the incremetal model to fail if there are schema changes. To rebuilt the incremental model, run a full refresh.
```bash
dbt run --full-refresh --select fct_reviews
```

### Documentation
* Can be defined in 2 ways:
    * yml
    * standalone md files
* dbt ships  withs lightweight documentation webserver
* can create custom overview page
* can also store different assets to special folder

#### Documenting a Model
Can be done in the [schema.yml](./dbt_project/models/schema.yml). Every object can gain a description value.   
Run then `dbt docs generate` and it is compiled and saved a folder, as showed in the result of execution.   
Now run `dbt docs serve` to spin up a simple server.

#### docs.md
Can create an md file called docs.md in the models folder and create custom docs inside it and call on the description field in schema.yml. in the description field, call the [docs.yml](./dbt_project/models/docs.yml) by using jinja.
```yml
      - name: minimum_nights
        description: '{{ doc("dim_listing_cleansed_minimum_nights") }}' #this call an md doc
        tests:
          - positive_value
```
Now run `dbt docs generate` and then `dbt docs serve` to see the implementation in the description field on docs.

#### overview.md
Create overview.md in models to for example show the full dag in the overview docs page.   
Can customize the overview page with images, by creating a folder called assests under dbt project and mapping it in the dbt_project.yml

#### Dags 