
/*-------------------------------------------------------------
PREP
-------------------------------------------------------------*/
-------------------- Stream example: INSERT SETUP ------------------------
CREATE OR REPLACE TRANSIENT DATABASE STREAMS_DB;

-- Create example table 
-- we gonna track changes on this table and insert to final table in case changes happens
CREATE OR REPLACE TABLE CARS_STG(
  id varchar,
  car_model varchar,
  price varchar,
  in_stock varchar,
  vendor_id varchar);
  
-- insert values to have something as starting point
INSERT INTO CARS_STG 
    VALUES
        (1,'chevete',1000,1,1),
        (2,'celta',2000,1,1),
        (3,'uno',5000,1,2),
        (4,'uno mille',8000,1,2),
        (5,'uno com escada',1000000,2,1);  

-- create a map table with some extra info
 CREATE OR REPLACE TABLE  VENDORS(
  vendor_id number,
  location varchar,
  employees number);

-- insert values to mapping store table, with info about the store
INSERT INTO VENDORS VALUES(1,'FIAT',33);
INSERT INTO VENDORS VALUES(2,'FORD',12);

-- this will be the final table to insert date with already some more data about store
CREATE OR REPLACE TABLE  CARS_STOCK_CURATED(
  id int,
  car_model varchar,
  price number,
  in_stock int,
  vendor_id int,
  location varchar,
  employees int);

 -- Insert into final table to have same data available
INSERT INTO CARS_STOCK_CURATED 
    SELECT 
    SA.id,
    SA.car_model,
    SA.price,
    SA.in_stock,
    ST.vendor_id,
    ST.LOCATION, 
    ST.EMPLOYEES 
    FROM CARS_STG SA
    JOIN VENDORS ST ON ST.vendor_id=SA.vendor_id ;


/*-------------------------------------------------------------
STREAMS - INSERT
-------------------------------------------------------------*/

-- Create a stream object
CREATE OR REPLACE STREAM CARS_STREAM ON TABLE CARS_STG
    COMMENT = 'my stream'
    -- APPEND_ONLY = TRUE | FALSE --only in tables
    -- INSERT_ONLY = TRUE | FALSE --only in external tables
    -- SHOW_INITIAL_ROWS = TRUE | FALSE -- show rows existing on source object on stream creation
;

-- check info about stream
SHOW STREAMS;

DESC STREAM CARS_STREAM;

-- Get changes on data using stream (INSERTS)
-- should have 0 rows, nothing changed on the tables being checked
select * from CARS_STREAM;

-- staging should have 5 rows
select * from CARS_STG;
                            
-- insert values 2 rows to tables being checked
insert into CARS_STG  
    values
        (6,'mercedes',1.99,1,2),
        (7,'Garlic',0.99,1,1);
        
-- Get changes on data using stream (INSERTS)
-- now should have 2 row, because they were added after table being checked on stream
-- check the metadata columns indicating a insert
select * from CARS_STREAM;

select * from CARS_STG;

-- why here we still have the same 5 rows? We need to insert with a command            
select * from CARS_STOCK_CURATED;        
        
-- Consume stream object as a source and insert only the missing rows
INSERT INTO CARS_STOCK_CURATED 
    SELECT 
    SA.id,
    SA.car_model,
    SA.price,
    SA.in_stock,
    ST.vendor_id,
    ST.LOCATION, 
    ST.EMPLOYEES 
    FROM CARS_STREAM SA
    JOIN VENDORS ST ON ST.vendor_id=SA.vendor_id ;

-- final table should now have the 7 rows and stream object must be empty, because they were consumed
-- Get changes on data using stream (INSERTS)
select * from CARS_STREAM;

-- insert values to check it again
insert into CARS_STG  
    values
        (8,'Paprika',4.99,1,2),
        (9,'Tomato',3.99,1,2);

        
/*-------------------------------------------------------------
STREAMS - UPDATE
-------------------------------------------------------------*/
-- ******* UPDATE 1 ********
-- stage should be with same rows as before
SELECT * FROM CARS_STG;     

-- we have nothing in the stream
SELECT * FROM CARS_STREAM;

-- we now update a row in staging instead of inserting
UPDATE CARS_STG
SET car_model = 'bmw x6' WHERE car_model = 'chevete';

-- when checking the stream we see 2 rows, one for update other for delete
-- in the delete we see old value, in insert we see new value (bmw x6)
SELECT * FROM CARS_STREAM;

-- create a new merge query
MERGE INTO CARS_STOCK_CURATED F      -- Target table to merge changes from source table
USING CARS_STREAM S                -- Stream that has captured the changes
   ON  f.id = s.id                 
WHEN MATCHED 
    AND S.METADATA$ACTION ='INSERT'
    AND S.METADATA$ISUPDATE ='TRUE'        -- Indicates the record has been updated 
    THEN UPDATE 
    SET f.car_model = s.car_model,
        f.price = s.price,
        f.in_stock= s.in_stock,
        f.vendor_id=s.vendor_id;
        
-- we see the table updated
SELECT * FROM CARS_STOCK_CURATED;

-- stream should be empty also       
SELECT * FROM CARS_STREAM;


/*-------------------------------------------------------------
STREAMS - DELETE
-------------------------------------------------------------*/
        
SELECT * FROM CARS_STOCK_CURATED
ORDER BY ID DESC;

SELECT * FROM CARS_STG
ORDER BY ID DESC;     
        
SELECT * FROM CARS_STREAM;    

DELETE FROM CARS_STG
WHERE car_model = 'celta';
        
-- ******* Process stream  ********            
MERGE INTO CARS_STOCK_CURATED F      -- Target table to merge changes from source table
USING CARS_STREAM S                -- Stream that has captured the changes
   ON  f.id = s.id          
WHEN matched 
    AND S.METADATA$ACTION ='DELETE' 
    AND S.METADATA$ISUPDATE = 'FALSE'
    THEN DELETE;


/*-------------------------------------------------------------
STREAMS - UPDATE,INSERT & DELETE
-------------------------------------------------------------*/
                
MERGE INTO CARS_STOCK_CURATED F      -- Target table to merge changes from source table
USING ( SELECT STRE.*
              ,ST.location
              ,ST.employees
        FROM CARS_STREAM STRE
        JOIN VENDORS ST
        ON STRE.vendor_id = ST.vendor_id
       ) S
ON F.id=S.id
WHEN MATCHED                        -- DELETE condition
    AND S.METADATA$ACTION ='DELETE' 
    AND S.METADATA$ISUPDATE = 'FALSE'
    THEN DELETE                   
WHEN MATCHED                        -- UPDATE condition
    AND S.METADATA$ACTION ='INSERT' 
    AND S.METADATA$ISUPDATE  = 'TRUE'       
    THEN UPDATE 
    SET f.car_model = s.car_model,
        f.price = s.price,
        f.in_stock= s.in_stock,
        f.vendor_id=s.vendor_id
WHEN NOT MATCHED 
    AND S.METADATA$ACTION ='INSERT'
    THEN INSERT 
    (
     id
    ,car_model
    ,price
    ,vendor_id
    ,in_stock
    ,employees
    ,location
    )
    values
    (
     s.id
    ,s.car_model
    ,s.price
    ,s.vendor_id
    ,s.in_stock
    ,s.employees
    ,s.location
    );
        

-- queries to validate each procedure - insert-delete and update
SELECT * FROM CARS_STG;     
        
SELECT * FROM CARS_STREAM;

SELECT * FROM CARS_STOCK_CURATED;


-- INSERT TEST       
INSERT INTO CARS_STG VALUES (2,'celta',0.99,1,1);

-- UPDATE TEST
UPDATE CARS_STG
SET car_model = 'celtaade'
WHERE car_model = 'celta';
    
-- DELETE TEST
DELETE FROM CARS_STG
WHERE car_model = 'celtaade';       


--- Example 2 ---
-- ALL THE OPERATIONS AT ONCE
INSERT INTO CARS_STG VALUES (10,'celta bordo',2.99,1,1);

UPDATE CARS_STG
SET PRICE = 3
WHERE car_model ='mercedes';
       
DELETE FROM CARS_STG
WHERE car_model = 'bmw x6';  



CREATE DATABASE MEDIAS_DEV CLONE MEDIAS;




