USE DATABASE MANAGE_DB;

CREATE OR REPLACE SCHEMA MANAGE_DB.PIPES;

USE SCHEMA PIPES;

CREATE OR REPLACE PIPE MANAGE_DB.PIPES.YOUTUBE_RAW
    AUTO_INGEST = TRUE
    -- ERROR_INTEGRATION = -- Required only when configuring Snowpipe to send error notifications to a cloud messaging service.
    -- AWS_SNS_TOPIC = ''
    -- INTEGRATION = '' -- Required only when configuring AUTO_INGEST for Google Cloud Storage or Microsoft Azure stages.
    COMMENT = 'Pipe to autoingest youtube data from S3'
AS
COPY INTO MEDIAS.YOUTUBE.RAW
    FROM @MANAGE_DB.EXTERNAL_STAGES.SNOWFLAKE_WORKSHOP
    FILE_FORMAT= MANAGE_DB.FILE_FORMATS.JSON_FMT
    ON_ERROR = SKIP_FILE
    --FORCE = TRUE
    ;

DESC PIPE YOUTUBE_RAW;
    
SELECT * FROM MEDIAS.YOUTUBE.RAW ;  


/*-------------------------------------------------------------
ERROR HANDLING
-------------------------------------------------------------*/

-- Validate pipe is actually working
SELECT SYSTEM$PIPE_STATUS('YOUTUBE_RAW');

-- Snowpipe error message
-- sometime can give some general error message
SELECT * FROM TABLE(VALIDATE_PIPE_LOAD(
    PIPE_NAME => 'MANAGE_DB.PIPES.YOUTUBE_RAW',
    START_TIME => DATEADD(YEAR,-2,CURRENT_TIMESTAMP())
        ));

-- COPY command history from table to see error massage
-- here we have more details to understand the error
SELECT * FROM TABLE (INFORMATION_SCHEMA.COPY_HISTORY(
   TABLE_NAME  =>  'MEDIAS.YOUTUBE.RAW',
   START_TIME => DATEADD(YEAR,-2,CURRENT_TIMESTAMP())))
   -- END_TIME => 
   ;

select *
  from table(information_schema.pipe_usage_history(
    date_range_start=> DATEADD(YEAR,-2,CURRENT_TIMESTAMP()),
    pipe_name=>'MANAGE_DB.PIPES.YOUTUBE_RAW')); --14 dias
   
-- Pause pipes
ALTER PIPE MANAGE_DB.PIPES.YOUTUBE_RAW SET PIPE_EXECUTION_PAUSED = false;

ALTER PIPE MANAGE_DB.PIPES.YOUTUBE_RAW REFRESH; --if pipe was created after file ingestion

select * from MEDIAS.YOUTUBE.RAW;
/*-------------------------------------------------------------
MANAGING PIPES
-------------------------------------------------------------*/

-- Manage pipes -- 
DESC PIPE MANAGE_DB.PIPES.YOUTUBE_RAW;

SHOW PIPES;

SHOW PIPES LIKE '%YOUTUBE%';

SHOW PIPES IN DATABASE MANAGE_DB;

SHOW PIPES IN SCHEMA MANAGE_DB.PIPES;

SHOW PIPES LIKE '%YOUTUBE%' IN DATABASE MANAGE_DB;