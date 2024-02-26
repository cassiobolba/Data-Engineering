### Models
SQL definitions that materliaze as tables and views and contain all business logics.   

#### SRC models
[src_hosts](./dbt_project/models/src/src_hosts.sql)    
[src_listings](./dbt_project/models/src/src_listings.sql)    
[src_reviews](./dbt_project/models/src/src_reviews.sql)   

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
Setup in the file [dbt_project.yml](./dbt_project/dbt_project.yml) by the code below. All folders in the project will be by default views. But, dim folder models not, they are tables (except if there is a model specific materialization config in the sql file).
```yml
models:
  dbt_project:
    # Config indicated by + and applies to all files under models/example/
    +materialized: view
    dim:
      +materialized: table
```

