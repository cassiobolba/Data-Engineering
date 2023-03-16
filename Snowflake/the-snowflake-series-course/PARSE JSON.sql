SELECT * FROM MEDIAS.YOUTUBE.STATISTICS_RAW;

SELECT raw_file:createdAt
FROM MEDIAS.YOUTUBE.STATISTICS_RAW;

SELECT distinct
	 $1:id::int id
	,$1:createdAt createdAt
    ,$1:description::string description
    ,$1:likeDislike.dislikes dislikes
	,$1:likeDislike.likes likes
    ,$1:likeDislike.userAction user_action
    ,RAW_FILE:multiMedia[0].name name
FROM MEDIAS.YOUTUBE.STATISTICS_RAW
where RAW_FILE:id::int =  2134
union all
SELECT distinct
	 $1:id::int id
	,$1:createdAt createdAt
    ,$1:description::string description
    ,$1:likeDislike.dislikes dislikes
	,$1:likeDislike.likes likes
    ,$1:likeDislike.userAction user_action
    ,RAW_FILE:multiMedia[1].name name
FROM MEDIAS.YOUTUBE.STATISTICS_RAW
where RAW_FILE:id::int =  2134


;

