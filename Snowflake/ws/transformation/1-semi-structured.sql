/*-------------------------------------------------------------
ACCESS JSON AND CASTING
-------------------------------------------------------------*/
SELECT RAW_FILE FROM RAW;

--Selecting attribute/column
SELECT RAW_FILE:id AS id FROM MEDIAS.YOUTUBE.RAW;

SELECT $1:id AS code FROM RAW;

--Selecting attribute/column - formattted
SELECT RAW_FILE:id::int as id  FROM RAW;

SELECT RAW_FILE:description::string as desc FROM RAW;

SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:description::STRING as desc
FROM RAW;


/*-------------------------------------------------------------
NESTED DATA - DOT NOTATION AND ARRAYS
-------------------------------------------------------------*/
-- get dictionary
SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:description::STRING as desc,
    $1:likeDislike
FROM RAW;

-- dot notation / bracket notation
SELECT 
    RAW_FILE:id::int as id,  
    RAW_FILE:description::STRING as desc,
    $1:likeDislike.dislikes dislikes,
    $1:likeDislike.dislikes likes,
    $1['likeDislike']['userAction'] user_action
FROM RAW;


--Handling arrays
SELECT DISTINCT
    RAW_FILE:id::int as id,
    $1:multiMedia multiMedia
FROM RAW
;

--Handling arrays
SELECT DISTINCT
    RAW_FILE:id::int as id,
    $1:multiMedia multiMedia
FROM RAW
WHERE ID = 2121;

-- indices 
--Handling arrays
SELECT DISTINCT
    RAW_FILE:id::int as id,
    $1:multiMedia[0] multiMedia,
    $1:multiMedia[1] multiMedia2
FROM RAW
WHERE ID = 2121;

-- count the number of medias
SELECT
    RAW_FILE:id::int as id,
    ARRAY_SIZE($1:multiMedia) as multiMedia
FROM RAW;

-- accessing each item
SELECT DISTINCT
    RAW_FILE:id::int as id,
    $1:multiMedia[0].description description,
    $1:multiMedia[0].id meida_id,
    $1:multiMedia[0].likeCount media_likes,
    $1:multiMedia[0].mediatype media_type,
    $1:multiMedia[0].name name,
    $1:multiMedia[0].place place,
    $1:multiMedia[0].url url
FROM RAW
WHERE ID = 2121;


-- combining 2 values from the array
SELECT DISTINCT
    RAW_FILE:id::int as id,
    $1:multiMedia[0].description description,
    $1:multiMedia[0].id meida_id,
    $1:multiMedia[0].likeCount media_likes,
    $1:multiMedia[0].mediatype media_type,
    $1:multiMedia[0].name name,
    $1:multiMedia[0].place place,
    $1:multiMedia[0].url url
FROM RAW
--WHERE ID = 2121
UNION ALL
SELECT DISTINCT
    RAW_FILE:id::int as id,
    $1:multiMedia[1].description description,
    $1:multiMedia[1].id meida_id,
    $1:multiMedia[1].likeCount media_likes,
    $1:multiMedia[1].mediatype media_type,
    $1:multiMedia[1].name name,
    $1:multiMedia[1].place place,
    $1:multiMedia[1].url url
FROM RAW
--WHERE ID = 2121
;


/*-------------------------------------------------------------
DEALING WITH HIERARCHY
-------------------------------------------------------------*/

SELECT distinct
	 RAW_FILE:id::int id
    ,f.value:id
FROM RAW ,
--TABLE(FLATTEN(RAW_FILE:multiMedia)) f 
LATERAL FLATTEN(INPUT => RAW_FILE:multiMedia) f
WHERE ID = 2121;


SELECT distinct
	 RAW_FILE:id::int id
    ,f.value:id::NUMBER(4,0) media_id
    ,f.value:likeCount::NUMBER(2,0) media_likes
    ,f.value:mediatype::NUMBER(2,0) media_type
    ,f.value:name::VARCHAR name
    --,f.value:place::VARCHAR place
    ,f.value:url::VARCHAR url
FROM RAW ,
LATERAL FLATTEN(INPUT => RAW_FILE:multiMedia , OUTER => True) f ;


/*-------------------------------------------------------------
MODELING
-------------------------------------------------------------*/
INSERT INTO EVENTS 
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
FROM RAW
ORDER BY ID DESC ;

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