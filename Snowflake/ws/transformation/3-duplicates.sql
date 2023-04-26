SELECT * FROM MEDIAS.YOUTUBE.EVENTS;

SELECT * FROM MEDIAS.YOUTUBE.RAW;

MERGE INTO MEDIAS.YOUTUBE.EVENTS tgt
  USING (
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
    FROM MEDIAS.YOUTUBE.RAW 
    ) src
  ON src.id = tgt.id
  WHEN NOT MATCHED THEN 
  INSERT 
      (
    	 id
    	,created_at
        ,description
        ,dislikes
    	,likes
        ,user_action
        ,comment_count
        ,feeds_comment
        ,location
        ,media_type
        ,name
        ,profile_picture
        ,title
        ,user_id
      )
  VALUES 
      (
         src.id
    	,src.created_at
        ,src.description
        ,src.dislikes
    	,src.likes
        ,src.user_action
        ,src.comment_count
        ,src.feeds_comment
        ,src.location
        ,src.media_type
        ,src.name
        ,src.profile_picture
        ,src.title
        ,src.user_id
      );
