SHOW TASKS;

SELECT * FROM MEDIAS.YOUTUBE.STATISTICS_RAW;
TRUNCATE TABLE MEDIAS.YOUTUBE.STATISTICS_RAW;

SELECT * FROM MEDIAS.YOUTUBE.STATISTICS;

CREATE OR REPLACE TASK LOAD_STATISTICS
	WAREHOUSE = COMPUTE_WH
    COMMENT = 'SEGUNDA TAREFA'
    AFTER LOAD_RAW
    AS
    INSERT INTO MEDIAS.YOUTUBE.STATISTICS
    SELECT distinct
    	 RAW_FILE:id::int id
    	,TO_TIMESTAMP(RAW_FILE:createdAt) createdAt
        ,RAW_FILE:description::string description
        ,RAW_FILE:likeDislike.dislikes::INT dislikes
    	,RAW_FILE:likeDislike.likes::INT likes
        ,RAW_FILE:likeDislike.userAction::INT user_action
        ,f.value:id::INT multimedia_id
    FROM MEDIAS.YOUTUBE.STATISTICS_RAW ,
    table(flatten(RAW_FILE:multiMedia)) f ;

    SHOW TASKS;

    ALTER TASK LOAD_RAW RESUME;
    ALTER TASK LOAD_STATISTICS RESUME;



select *
  from table(information_schema.task_history())
  order by scheduled_time desc ;