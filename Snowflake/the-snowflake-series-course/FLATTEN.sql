SELECT DISTINCT
	RAW_FILE:id id
    ,array_size(RAW_FILE:multiMedia) size
from medias.youtube.statistics_raw ;

SELECT distinct
	 RAW_FILE:id::int id
	,RAW_FILE:createdAt createdAt
    ,RAW_FILE:description::string description
    ,RAW_FILE:likeDislike.dislikes dislikes
	,RAW_FILE:likeDislike.likes likes
    ,RAW_FILE:likeDislike.userAction user_action
    ,f.value:id multimedia_id
FROM MEDIAS.YOUTUBE.STATISTICS_RAW ,
table(flatten(RAW_FILE:multiMedia)) f
--where RAW_FILE:id::int =  2114 


;