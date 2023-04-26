
/*-------------------------------------------------------------
PREP
-------------------------------------------------------------*/

CREATE TABLE EVENTS IF NOT EXISTS
(
	 id int
	,created_at timestamp
    ,description string 
    ,dislikes int 
	,likes int 
    ,user_action int 
    ,comment_count int 
    ,feeds_comment string 
    ,location string 
    ,media_type int 
    ,name string 
    ,profile_picture string 
    ,title string 
    ,user_id int
);

CREATE TABLE EVENT_MEDIAS IF NOT EXISTS
(
	 id int
    ,media_id NUMBER(4,0) 
    ,media_likes NUMBER(2,0)
    ,media_type NUMBER(2,0)
    ,name VARCHAR
    ,url VARCHAR
) ;


/*-------------------------------------------------------------
TASK command
-------------------------------------------------------------*/

CREATE SCHEMA MANAGE_DB.TASKS;

-- Create task
CREATE OR REPLACE TASK MANAGE_DB.TASKS.YT_EVENTS_INGEST
    -- WAREHOUSE = COMPUTE_WH
    -- USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'SMALL' -- for serverless 
    
    SCHEDULE = '1 MINUTE'
        -- # __________ minute (0-59) - 0 = every full hour
        -- # | ________ hour (0-23)
        -- # | | ______ day of month (1-31, or L) L = last day of the month
        -- # | | | ____ month (1-12, JAN-DEC)
        -- # | | | | __ day of week (0-6, SUN-SAT, or L) 
        -- # | | | | |
        -- # | | | | |
        -- # * * * * *
        
        -- Every minute
        -- SCHEDULE = 'USING CRON * * * * * UTC'
        
        -- Every day at 6am UTC timezone
        -- SCHEDULE = 'USING CRON 0 6 * * * UTC'
        
        -- Every hour starting at 9 AM and ending at 5 PM on Sundays 
        -- 9-17 from 9 to 17
        -- 9,17 at 9 and at 17
        -- SCHEDULE = 'USING CRON 0 9-17 * * SUN America/Los_Angeles'

    ALLOW_OVERLAPPING_EXECUTION = FALSE
    COMMENT = 'Task to create table xxx'
    -- USER_TASK_TIMEOUT_MS = 3600000 -- in ms, default is 3600000 (1h)
    -- SUSPEND_TASK_AFTER_NUM_FAILURES = 1 -- default is 0 (no suspension)
    -- ERROR_INTEGRATION = <integration_name> --send error notifications using SNS,Event Grid, or Pub/Sub.
    -- AFTER <string> -- list of strings with task names to preceed 
    --WHEN <boolean_expr> -- sql or function (only stream function suppoer atm)
    AS 
    INSERT INTO MEDIAS.YOUTUBE.EVENTS 
    SELECT distinct
    	 RAW_FILE:id::int id
    	,TO_TIMESTAMP(RAW_FILE:createdAt) created_at
        ,RAW_FILE:description::string description
        ,RAW_FILE:likeDislike.dislikes::int dislikes
    	,RAW_FILE:likeDislike.likes::int likes
        ,RAW_FILE:likeDislike.userAction::int user_action
        ,RAW_FILE:commentCount::int comment_count
        ,RAW_FILE:feedsComment::string feeds_comment
        ,RAW_FILE:location::string location
        ,RAW_FILE:mediatype::int media_type
        ,RAW_FILE:name::string name
        ,RAW_FILE:profilePicture::string profile_picture
        ,RAW_FILE:title::string title
        ,RAW_FILE:userId::int user_id
    FROM MEDIAS.YOUTUBE.RAW ;

 TRUNCATE TABLE EVENTS;
 TRUNCATE TABLE EVENT_MEDIAS;
 
-- check the task is no started
SHOW TASKS IN SCHEMA MANAGE_DB.TASKS;

-- Task starting
ALTER TASK MANAGE_DB.TASKS.YT_EVENTS_INGEST RESUME;
ALTER TASK MANAGE_DB.TASKS.YT_EVENT_MEDIAS_INGEST RESUME; -- INITIATE TASKS FROM LAST TO FIRST
ALTER TASK MANAGE_DB.TASKS.YT_TRUNC_RAW RESUME;

-- check new data being inserted
SELECT * FROM EVENTS;
SELECT * FROM EVENT_MEDIAS;
SELECT * FROM RAW;

-- Task suspending
ALTER TASK MANAGE_DB.TASKS.YT_EVENTS_INGEST SUSPEND;
ALTER TASK MANAGE_DB.TASKS.YT_EVENT_MEDIAS_INGEST SUSPEND;
ALTER TASK MANAGE_DB.TASKS.YT_TRUNC_RAW SUSPEND;


CREATE OR REPLACE TASK MANAGE_DB.TASKS.YT_EVENT_MEDIAS_INGEST
    --WAREHOUSE = COMPUTE_WH
    USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'SMALL' -- for serverless 
    ALLOW_OVERLAPPING_EXECUTION = FALSE
    COMMENT = 'Task to create table EVENT_MEDIAS'
    AFTER MANAGE_DB.TASKS.YT_EVENTS_INGEST
    AS 
INSERT INTO MEDIAS.YOUTUBE.EVENT_MEDIAS
SELECT distinct
	 RAW_FILE:id::int id
    ,f.value:id::NUMBER(4,0) media_id
    ,f.value:likeCount::NUMBER(2,0) media_likes
    ,f.value:mediatype::NUMBER(2,0) media_type
    ,f.value:name::VARCHAR name
    --,f.value:place::VARCHAR place
    ,f.value:url::VARCHAR url
FROM MEDIAS.YOUTUBE.RAW ,
LATERAL FLATTEN(INPUT => RAW_FILE:multiMedia ,OUTER => True) f ;

select *
  from table(information_schema.task_history())
  order by scheduled_time desc;

CREATE OR REPLACE TASK MANAGE_DB.TASKS.YT_TRUNC_RAW
    --WAREHOUSE = COMPUTE_WH
    USER_TASK_MANAGED_INITIAL_WAREHOUSE_SIZE = 'SMALL' -- for serverless 
    COMMENT = 'TRUNCATE RAW'
    AFTER MANAGE_DB.TASKS.YT_EVENT_MEDIAS_INGEST
    AS 
    TRUNCATE MEDIAS.YOUTUBE.RAW ;

SHOW TASKS IN DATABASE MANAGE_DB;