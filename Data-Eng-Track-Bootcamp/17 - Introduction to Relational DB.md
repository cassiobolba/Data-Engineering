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

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/17%20-%20Introduction%20to%20Relational%20DB/postgree_datatypes.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>   
Postgree docs: https://www.postgresql.org/docs/10/datatype-datetime.html#DATATYPE-DATETIME-INPUT

* Enforce data types on table creation
* To change data types on the fly ( just in the query, not in the table ) use CAST:
```sql
-- Calculate the net amount as amount + fee
SELECT transaction_date, CAST(amount as INTEGER) + cast(fee as INTEGER) AS net_amount 
FROM transactions;
```
## 2.2 WORKING WITH DATA TYPES
* The most common
    * text
    * varchar
    * char
    * boolean
    * date
    * time
    * timestamp
    * integer ( just whole numbers )
    * numeric (3.14)
    * big int
* Types are specified on the table creation
* Data type can be changed after creation:
```SQL
-- Specify the correct fixed-length character type
ALTER TABLE professors
ALTER COLUMN university_shortname
TYPE char(3);
-- or
-- Change the type of firstname
ALTER TABLE professors
ALTER COLUMN firstname
TYPE varchar(64);
```
* When altering a column from varchar(64) to varchar(16) to reduce space reserved in the system you will get an error because 64 (current lenght) does not fit the 16 spaces. Then you have to transform the current lengh during the type change:
```sql
-- Convert the values in firstname to a max. of 16 characters
ALTER TABLE professors 
ALTER COLUMN firstname 
TYPE varchar(16)
USING SUBSTRING(firstname FROM 1 FOR 16)
```

## 2.3 NOT NULL CONSTRAINTS
* Does not allow nulls
* Can only be used in columns with no null values
* And it will not be possible to add nulls later
* for example, for a students table, stundent name should never be null, otherwise makes no sense have other values for a student you doesn't know the name
* Using it in table creation:
```sql
CREATE TALBE students (
     ssn integer not null
    ,lastname varchar(64) not null
    ,home_phone integer
    ,office_phone integer
);
```
* You can also add or remove null constraints
```sql
-- Disallow NULL values in firstname
ALTER TABLE professors 
ALTER COLUMN firstname SET NOT NULL;
```

## 2.4 UNIQUE CONSTRAINTS
* A values can only exists once in a table
* Avoid redundancy
* for universities table, we should not have university name more than once
* Can make a column unique on table creation
```sql
CREATE TABLE table_name (
 column_name UNIQUE
);
```
* Can also add or remove unique constraints after table creation
```sql
-- Make universities.university_shortname unique
ALTER TABLE universities
ADD CONSTRAINT  university_shortname_unq UNIQUE(university_shortname);
```

# 3. UNIQUELY IDENTIFY RECORDS WITH KEY CONSTRAINTS
# 3.1 KEYS AND SUPERKEYS
After adding the constraints to data types, we need to create unique identifiers to the rows, called keys:
* They are attributes that identify a record uniquely in a context
* Superkeys are combinations of attributes, but some of the attributes can be removed and still will be unique
* Key is the minimum combination of attributes to indentify a record uniquely
* Can check the count of records in a table by using count, and find the number o distinct values for a record with count distinct:
```sql
-- Count the number of rows in universities
SELECT count(*) 
FROM universities;

-- Count the number of distinct values in the university_city column
SELECT count(distinct(university_city)) 
FROM universities;
```
Creating PK in table creation:
```sql
CREATE TABLE products (
    product_no integer PRIMARY KEY
    ,name text
    , price numeric
    -- compound primary key
    --,PRIMARY KEY (name,price)
)
```
Adding PK constraint to an existing column:
```sql
-- Rename the organization column to id
ALTER TABLE organizations
RENAME COLUMN organization TO id;

-- Make id a primary key
ALTER TABLE organizations
ADD CONSTRAINT organization_pk PRIMARY KEY (id);
```

## 3.2 SURROGATE KEYS
* Sort of artifical PK
* you can create an artificial surrogate key by using serial and increment by number that will never repeat
* Also, you can concatenate two existing columns to create a surrogate key
* Surrogate key can also be used to refer to columns in other tables
Creating Surrogate with SERIAL:
```sql
-- Add the new column to the table
ALTER TABLE professors 
ADD COLUMN id serial;

-- Make id a primary key
ALTER TABLE professors 
ADD CONSTRAINT professors_pkey PRIMARY KEY (id);

-- Have a look at the first 10 rows of professors
select * from professors limit 10;
```
Creating Surrogate with CONCAT:
```sql
-- Add the id column
ALTER TABLE cars
ADD COLUMN id varchar(128);

-- Update id with make + model
UPDATE cars
SET id = CONCAT(make, model);

-- Make id a primary key
ALTER TABLE cars
ADD CONSTRAINT id_pk PRIMARY KEY (id);
```

# 4 GLUE TOGETHER TABLES WITH FOREING KEYS
## 4.1 1:N RELATIONSHIPS WITH FOREING KEYS
It is time to relate tables with keys:
* 1:N means 1 record in table relates to n records in another table (cardinality)

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/17%20-%20Introduction%20to%20Relational%20DB/1_n_relationship.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>  

* FK relates to others table PK
* FK and PK must be of same domain
* each FK must exists in the PK table (referential integrity)
* when you have a PK and FK constraint, you won't be able to add a value for the FK that does not exists on the PK
* It enhance the referential integrity
* FK is not a PK, because it can be null
Add a FK referencing a PK, on existing values:

```sql
-- Rename the university_shortname column
ALTER TABLE professors
RENAME COLUMN university_shortname TO university_id;

-- Add a foreign key on professors referencing universities
ALTER TABLE professors 
ADD CONSTRAINT professors_fkey FOREIGN KEY (university_id) REFERENCES universities (id);
```
## 4.2 MODEL MORE COMPLEX RELATIONSHIPS
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/17%20-%20Introduction%20to%20Relational%20DB/n_n_relationships.jpg" style="border: 1px solid #aaa; border-radius: 10px 10px 10px 10px"/>   

* n to n relationship happens among FK, not PK
* in the example above, one organization can have the same professor in differente functions. The opposite is also true, one professor can work in many organizations
* Most cases create an intermediary table to connect both side: professors and organizations, the table affiliations.
* Can be created at table creation:
```sql
CREATE TABLE affiliations (
    professor_id integer REFERENCES professors (id),
    organization_id varchar(256) REFERENCES organizations (id),
    function varchar(256)
);
```
* No primary keys here!
* In case of tables currently existing, you can modifify it bu add the FK column, and creating the references, and after updating the keys

## 4.3 REFERENCITAL INTEGRITY
"A record referencing another table must refert to an existing record in that table"
* Specified between 2 tables
* Referenctial integrity can be violated when a record being referenced is deleted or a record is being inserted in one table and not being refereced in another (and should)
* FK enforce it won't happen
* Also, on table creation you can create a rule to not allow a deletion that may violate the integrity, SHOWING ERROR
```sql
CREATE TABLE a (
    column_a varchar(64),
    b_id interger REFERENCES b (id) ON DELETE NO ACTION
);
```
* Also, can use the CASCADE to when a referenced item is deleted, all item related to it will also be deleted, not leaving any data breaking the referential integrity:
```sql
CREATE TABLE a (
    column_a varchar(64),
    b_id interger REFERENCES b (id) ON DELETE CASCADE
);
```
* More Options:
    * RESTRICT
    * SET NULL: Set null to all missing references after a deletion
    * SET DEFAULT Set a default value to all missing references after a deletion

How to check the existing FK constraints:
```sql
-- Identify the correct constraint name
SELECT constraint_name, table_name, constraint_type
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY';
```