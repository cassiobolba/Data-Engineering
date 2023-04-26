-- Time Travel
--Use-case: Update data (by mistake)
UPDATE OUR_FIRST_DB.public.test
SET FIRST_NAME = 'Joyen' ;

-- see all is wrong
SELECT * FROM OUR_FIRST_DB.public.test;

--Using time travel: Method 1 - 2 minutes back
InSELECT * FROM OUR_FIRST_DB.public.test at (OFFSET => -60*1.5);

-- see all is back to normal
SELECT * FROM OUR_FIRST_DB.public.test;


DROP DATABASE ;

UNDROP DATABASE ;


-- Zero-Copy Clone
CREATE DATABASE MEDIAS_DEV CLONE MEDIA;
-- BEFORE (TIMESTAMP => 1231516)
