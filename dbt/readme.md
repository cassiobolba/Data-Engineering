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
        * it can be tricky
        * I used instead the account the locator and the cloud region
        * *MF58790.eu-central-1*
        * Also went to the schema and granted the provileges 'CREATE SCHEMA' and 'USAGE' in the analytcs schema to the role account admin
        * docs for this -> https://docs.getdbt.com/reference/warehouse-profiles/snowflake-profile
    * database (for this demo is Analytics - we created via sql before)
    * warehouse (for this demo is transforming - we created via sql before)
    * then fill user ans password from snowflake
    * hit test to check, then finalize

### 2.3 Set Up the Git Repository
* Create a repository in your git account
* Allow dbt accesing the repo if first time
* then add a repo or all repos to your profile
* go to hamburger on top left > home > select the account your using in case more tahn one > continue 
* select git hub again > find the repo you created for this project > continue and continue
* hit start developing
* hit initialize your project -> it will create all necessary files and projects
* hit commit to push it to master and transform in a dbt repo
* create a branch to start dev environment and start making changes

### 2.4 DBT IDE UI
* Git controls
    * All git commands in the IDE are completed here.
    * This will change dynamically based on the git status of your project.

* File tree
    * This is the main view into your dbt project.
    * This is where a dbt project is built in the form of .sql, .yml, and other file * types.

* Text editor
    * This is where individual files are edited. You can open files by selecting them * from the file tree to the left.
    * You can open multiple files in tabs so you can easily switch between files.
    * Statement tabs are allow you to run SQL against your data warehouse while you are * developing, but they are not saved in your project. If you want to save SQL * queries, you can create .sql files in the analysis folder.

* Preview / Compile SQL
    * These two buttons apply to statements and SQL files.
    * Preview will compile and run your query against the data warehouse. The results * will be displayed in the "Query Results" tab along the bottom of your screen.
    * Compile SQL will compile any Jinja into pure SQL. This will be displayed in the * Info Window in the "Compiled SQL" tab along the bottom of your screen.

* Info window
    * This window will show results when you click on Preview or Compile SQL.
    * This is helpful for troubleshooting errors during development.
    * The "Lineage" will also show a diagram of the model that is currently open in the * text editor and its ancestors and dependencies.

* Command line
    * This is where you can execute specific dbt commands (e.g. dbt run, dbt test).
    * This will pop up to show the results as they are processed. Logs can also be * viewed here.

* View docs
    * This button will display the documentation for your dbt project.
    * More details on this in the documentation module.

## 3. Models
### 3.1 What are Models
* Models are .sql files that live in the models folder.
* Models are simply written as select statements - there is no DDL/DML 
* This allows the developer to focus on the logic.

### 3.2 Building first model
* Get the query dim_customers.sql
* Navigate on dbt cloud to the previously created repo > model > create a new file and name it dim_customers.sql
* Press preview and see same data as we inserted on snowflake (case do not see, check if you really uploaded data to SF)
* In the Cloud IDE, the Preview button will run this select statement against your data warehouse. The results shown here are equivalent to what this model will return once it is materialized.
* To move it to Snowflake > save the file > on botton command line do dbt run
* After constructing a model, dbt run in the command line will actually materialize the models into the data warehouse
* The default materialization is a view.
* The materialization can be configured as a table with the following configuration block at the top of the model file:
```py
{{ config(
materialized='table' # or 'view'
) }}
```
* When dbt run is executing, dbt is wrapping the select statement in the correct DDL/DML to build that model as a table/view. If that model already exists in the data warehouse, dbt will automatically drop that table or view before building the new database object. **Note: If you are on BigQuery, you may need to run dbt run --full-refresh for this to take effect.
* The DDL/DML that is being run to build each model can be viewed in the logs through the cloud interface or the target folder
* if run only 'dbt run' it will rebuild all the models
* To rebuild only one, run 'dbt run --select dim_customers'

### 3.3 Modularity
* We could build each of our final models in a single model as we did with dim_customers, however with dbt we can create our final data products using modularity.
* Modularity is the degree to which a system's components may be separated and recombined, often with the benefit of flexibility and variety in use.
* This allows us to build data artifacts in logical steps.
* For example, we can stage the raw customers and orders data to shape it into what we want it to look like. Then we can build a model that references both of these to build the final dim_customers model.
* Thinking modularly is how software engineers build applications. Models can be leveraged to apply this modular thinking to analytics engineering.

### 3.4 Modularity and ref Macro

* Models can be written to reference the underlying tables and views that were building the data warehouse (e.g. analytics.dbt_jsmith.stg_customers). This hard codes the table names and makes it difficult to share code between developers.
* The ref function allows us to build dependencies between models in a flexible way that can be shared in a common code base. The ref function compiles to the name of the database object as it has been created on the most recent execution of dbt run in the particular development environment. This is determined by the environment configuration that was set up when the project was created.
* Example: {{ ref('stg_customers') )} compiles to analytics.dbt_jsmith.stg_customers.
* The ref function also builds a lineage graph like the one shown below. dbt is able to determine dependencies between models and takes those into account to build models in the correct order.

IAMGE LINEAGE GRAPH

* Go to models > create new file > stg_customers.sql (as file sample here)
* Go to models > create new file > stg_orders.sql (as file sample here)
* Refactor the dim_customers.sql to the sim_customers-2.sql sample
    * here we apply the ref macro to create denpendencies on the stage and have the lineage dependencies
* now use dbt run to deploy the model
* Can see the lineage graph
* Now you can run 'dbt docs generate' to generate the documentation

### 3.5 Modeling History
* There have been multiple modeling paradigms since the advent of database technology. Many of these are classified as normalized modeling.
* Normalized modeling techniques were designed when storage was expensive and compute was not as affordable as it is today.
With a modern cloud-based data warehouse, we can approach analytics differently in an agile or ad hoc modeling technique. This is often referred to as denormalized modeling.
* dbt can build your data warehouse into any of these schemas. dbt is a tool for how to build these rather than enforcing what to build.

### 3.5 Naming Conventions 
In working on this project, we established some conventions for naming our models.
* **Sources** (src) refer to the raw table data that have been built in the warehouse through a loading process. (We will cover configuring Sources in the Sources module)
* **Staging** (stg) refers to models that are built directly on top of sources. These have a one-to-one relationship with sources tables. These are used for very light transformations that shape the data into what you want it to be. These models are used to clean and standardize the data before transforming data downstream. Note: These are typically materialized as views.
* **Intermediate** (int) refers to any models that exist between final fact and dimension tables. These should be built on staging models rather than directly on sources to leverage the data cleaning that was done in staging.
* **Fact** (fct) refers to any data that represents something that occurred or is occurring. Examples include sessions, transactions, orders, stories, votes. These are typically skinny, long tables.
* **Dimension** (dim) refers to data that represents a person, place or thing. Examples include customers, products, candidates, buildings, employees.
Note: The Fact and Dimension convention is based on previous normalized modeling techniques.

### 3.6 Reorganize Project
* When dbt run is executed, dbt will automatically run every model in the models directory.
* The subfolder structure within the models directory can be leveraged for organizing the project as the data team sees fit.
* This can then be leveraged to select certain folders with dbt run and the model selector.
* Example: If dbt run -s staging will run all models that exist in models/staging. (Note: This can also be applied for dbt test as well which will be covered later.)
* The following framework can be a starting part for designing your own model organization:
    * Marts folder: All intermediate, fact, and dimension models can be stored here. Further subfolders can be used to separate data by business function (e.g. marketing, finance)
    * Staging folder: All staging models and source configurations can be stored here. Further subfolders can be used to separate data by data source (e.g. Stripe, Segment, Salesforce). (We will cover configuring Sources in the Sources module)
* Create the following Structure:
```
dbt-learn
├── analysis
├── dbt_modules
├── logs
├── macros
├── models
    └── marts
        └── core
            └── dim_customers.sql  
    └── staging
        └── jaffle_shop
            ├── stg_customers.sql
            └── stg_orders.sql 
├── snapshots
├── target
├── tests
├── .gitignore
├── dbt_project.yml
└── README.md
```
* Also, instead of declaring the table materialization type in sql model file, we can do that no the dbt_project.yml
* Go to the file and replace the example settings below module (all above remains the same)
```yml 
models:
  jaffle_shop:
    # Applies to all files under models/jaffle_shop/
    marts:
      core:
        +materialized: table
    staging:
      +materialized: view
```      
### 3.7 Practice
#### 3.7.1 Building a fct_orders Model

* Use a statement tab or Snowflake to inspect raw.stripe.payment
* Create a stg_payments.sql model in models/staging/stripe
* Create a fct_orders.sql (not stg_orders) model with the following fields.  Place this in the marts/core directory.
    * order_id
    * customer_id
    * amount (hint: this has to come from payments)

#### 3.7.2 Refactor your dim_customers Model
* Add a new field called lifetime_value to the dim_customers model:
    * lifetime_value: the total amount a customer has spent at jaffle_shop
    * Hint: The sum of lifetime_value is $1,672

#### Answers om files:
* fct_orders.sql
* stg_payments.sql
* dim_customer-3.sql

## 4. Sources
### 4.1 What are Sources?
* Sources represent the raw data that is loaded into the data warehouse.
* We can reference tables in our models with an explicit table name (raw.jaffle_shop.customers)
* However, setting up Sources in dbt and referring to them with the source function enables a few important tools.
    * Multiple tables from a single sources can be configured in one place.
    * Sources are easily identified as green nodes in the Lineage Graph.
    * You can use dbt source freshness to check the freshness of raw tables.
* Sources make easyto change data location in case they move schema. Just change the source path in the yml file, and then all queries (models) using that source will automatically be adjusted

### 4.2 Configure and Select from Sources
* official doc for sources https://docs.getdbt.com/reference/source-properties
* Sources are configured in YML files in the models directory.
* The following code block configures the table raw.jaffle_shop.customers and raw.jaffle_shop.orders:
```yml
version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
      - name: orders
```
* Create a file under modesl/stagins/jaffle_sjop called src_jaffle_shop.yml like the the code above (and like the sample file in this directory).

### 4.2.1 Configure Select from Source
* The ref function is used to build dependencies between models.
* Similarly, the source function is used to build the dependency of one model to a source.
* Given the source configuration above, the snippet {{ source('jaffle_shop','customers') }} in a model file will compile to raw.jaffle_shop.customers.
* The Lineage Graph will represent the sources in green.
* On the stg_customers and orders, change the hardcoded table name to source
* In these files, it is the commented lines