--arn:aws:iam::749634257170:role/series-snowflake

CREATE SCHEMA MANAGE_DB.STORAGE_INTERGRATION;

USE DATABASE MANAGE_DB;
USE SCHEMA STORAGE_INTERGRATION;


;
create or replace storage integration S3_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::749634257170:role/series-snowflake'
  STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-series/')
  COMMENT = 'My first integration' 
  ;

DESC INTEGRATION S3_INT;



