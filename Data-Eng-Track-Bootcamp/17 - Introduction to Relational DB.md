#  INTRODUCTION TO RELATIONAL DB
# 1. YOUR FIRST DB
## 1.1 A RELATIONAL DB
key concepts:
* Constraints
* Keys
* Referencial Integrity

## 1.2 TABLES: THE DB CORE
* Separate tables according to entity types
* in the old table, there are 3 entities/topics: info about professor, organization and univerties
* It better when you separe them into more tables and create relationships via keys
* This reduce redundancy, because data from 1 entity can duplicate data in another:
* For example: A professor can work in two universites, if both entities are in same table, it means I'll have 1 porofessor in 2 lines (repeated), because I have 2 not repeated universities

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/17%20-%20Introduction%20to%20Relational%20DB/ENTITY_MODELS.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>


### 1.2.1 Create Tables
```sql
CREATE TALBE table_name (
     column_1 type_column1
    ,column_2 type_column2
    ,column_3 type_column3
    ,column_4 type_column4
)
```
There are many types of data, we will se later. A real example:
```sql
-- Create a table for the professors entity type
CREATE TABLE professors (
 firstname text,
 lastname text
);
--AND
-- Create a table for the universities entity type
CREATE TABLE universities (
 university_shortname text,
 university text,
 university_city text
);
```

### 1.2.1 Add Columns to Tables
Sometimes we need to add columns to existing tables:
```sql
ALTER TABLE professors
ADD COLUMN university_shortname text;
```

## 1.3 UPDATE THE DB TO CHANGE STRUCTURE
After create new tables to split the model acordding the image above, we need to insert the values on it. Most of the time we will want to insert distinct values.  
Also, it is common to need to do changes in the tables, like alter column names or drop a columns
```sql
-- Rename the organisation column
ALTER TABLE affiliations
RENAME COLUMN organisation TO organization;

-- Delete the university_shortname column
ALTER TABLE affiliations
DROP COLUMN university_shortname;
```
Now, insert data into the table:
```sql
-- Insert unique professors into the new table
INSERT INTO professors 
SELECT DISTINCT firstname, lastname, university_shortname 
FROM university_professors;

-- Insert unique affiliations into the new table
INSERT INTO affiliations 
SELECT DISTINCT firstname, lastname, function, organization 
FROM university_professors;
```
After migrating the data to a new table, we can delete the old one.
```sql
-- Delete the university_professors table
DROP TABLE university_professors;
```

# 2. ENFORCE DATA CONSISTENCY WITH ATTRIBUTES CONSTRAINTS
## 2.1 CONSTRAINTS FOR DATA QUALITY
So far we just created tables from a unique table to avoid data redundancy. Now we need to add constraints to theses tables to guarantee data integrity.  
There 3 types of data integrity constraints:
* Attribute constraints: data types (this chapter)
* Key constraints: primary keys - PK (chapter 3)
* Referential Integrity constraints: foreing keys (chpater 4)

### 2.2 Why use constraints?
* It gives data structure
* Assure that a date will always be in the same format, for ie.
* Consistency and data quality
* Easier to enforce a constraint than treat the different formats later
* The common data types in postgree are:

imagem