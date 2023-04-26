COPY INTO MEDIAS.YOUTUBE.RAW 
    FROM 
    (
    

    
    )
    
    @MANAGE_DB.EXTERNAL_STAGES.SNOWFLAKE_WORKSHOP
    FILE_FORMAT= MANAGE_DB.FILE_FORMATS.JSON_FMT
    -- PATTERN = '.*error.json'
    -- FILES = ('youtube_data.json')
    ON_ERROR = SKIP_FILE --CONTINUE | SKIP_FILE | SKIP_FILE_<num> | 'SKIP_FILE_<num>%' | ABORT_STATEMENT
    -- SIZE_LIMIT = <num>
    -- PURGE = TRUE
    -- RETURN_FAILED_ONLY = TRUE | FALSE
    -- MATCH_BY_COLUMN_NAME = CASE_SENSITIVE | CASE_INSENSITIVE | NONE
    -- ENFORCE_LENGTH = TRUE | FALSE
    -- TRUNCATECOLUMNS = TRUE | FALSE
    -- FORCE = TRUE


COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM (select 
            s.$1,
            s.$2, 
            s.$3,
            CASE WHEN CAST(s.$3 as int) < 0 THEN 'not profitable' ELSE 'profitable' END 
          from @MANAGE_DB.external_stages.aws_stage s)
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files=('OrderDetails.csv');