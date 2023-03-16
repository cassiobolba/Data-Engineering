
CREATE OR REPLACE TABLE MEDIAS.YOUTUBE.STATISTICS AS
SELECT distinct
	 RAW_FILE:id::int id
	,TO_TIMESTAMP(RAW_FILE:createdAt) createdAt
    ,RAW_FILE:description::string description
    ,RAW_FILE:likeDislike.dislikes::INT dislikes
	,RAW_FILE:likeDislike.likes::INT likes
    ,RAW_FILE:likeDislike.userAction::INT user_action
    ,f.value:id::INT multimedia_id
FROM MEDIAS.YOUTUBE.STATISTICS_RAW ,
table(flatten(RAW_FILE:multiMedia)) f 
;

SELECT COUNT(*) FROM MEDIAS.YOUTUBE.STATISTICS;

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