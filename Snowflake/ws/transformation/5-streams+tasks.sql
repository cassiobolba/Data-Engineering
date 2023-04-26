------- Automatate the updates using tasks --
CREATE OR REPLACE TASK all_data_changes
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = '1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('CARS_STREAM') -- condition to only run when stream has data
    AS 
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

-- resume the task because they are by default not started
ALTER TASK all_data_changes RESUME;
ALTER TASK all_data_changes SUSPEND;

-- check if task is created
SHOW TASKS;


-- Change data to test
INSERT INTO CARS_STG VALUES (11,'rural',50,1,2);
       
DELETE FROM CARS_STG
WHERE car_model = 'mercedes';    


-- Verify results
-- stage should be changed
SELECT * FROM CARS_STG;     
-- stream shoudl have the data changed (if the task did not run yet)        
SELECT * FROM CARS_STREAM;
-- after task run (1min) final table should have the new updates
SELECT * FROM CARS_STOCK_CURATED;


-- Verify the history
select *
from table(information_schema.task_history())
order by name asc,scheduled_time desc;

show tasks;