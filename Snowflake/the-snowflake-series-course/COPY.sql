SELECT 
	$1
    ,$2
FROM @MANAGE_DB.EXTERNAL_STAGES.GDELT_EVENTS/events/20190916.export.csv ;

CREATE DATABASE GDELT;

CREATE SCHEMA EVENTS;

CREATE TABLE IF NOT EXISTS GDELT.EVENTS.EVENTS_FULL (

     GLOBALEVENTID INT

    ,SQLDATE  varchar

    ,MonthYear varchar

    ,Year varchar

    ,FractionDate varchar

    ,Actor1Code varchar

    ,Actor1Name varchar

    ,Actor1CountryCode varchar

    ,Actor1KnownGroupCode varchar

    ,Actor1EthnicCode varchar

    ,Actor1Religion1Code varchar

    ,Actor1Religion2Code varchar

    ,Actor1Type1Code varchar

    ,Actor1Type2Code varchar

    ,Actor1Type3Code varchar

    ,Actor2Code varchar

    ,Actor2Name varchar

    ,Actor2CountryCode varchar

    ,Actor2KnownGroupCode varchar

    ,Actor2EthnicCode varchar

    ,Actor2Religion1Code varchar

    ,Actor2Religion2Code varchar

    ,Actor2Type1Code varchar

    ,Actor2Type2Code varchar

    ,Actor2Type3Code varchar

    ,IsRootEvent varchar

    ,EventCode varchar

    ,EventBaseCode varchar

    ,EventRootCode varchar

    ,QuadClass varchar

    ,GoldsteinScale varchar

    ,NumMentions varchar

    ,NumSources varchar

    ,NumArticles varchar

    ,AvgTone varchar

    ,Actor1Geo_Type varchar

    ,Actor1Geo_FullName varchar

    ,Actor1Geo_CountryCode varchar

    ,Actor1Geo_ADM1Code varchar

    ,Actor1Geo_Lat varchar

    ,Actor1Geo_Long varchar

    ,Actor1Geo_FeatureID varchar

    ,Actor2Geo_Type varchar

    ,Actor2Geo_FullName varchar

    ,Actor2Geo_CountryCode varchar

    ,Actor2Geo_ADM1Code varchar

    ,Actor2Geo_Lat varchar

    ,Actor2Geo_Long varchar

    ,Actor2Geo_FeatureID varchar

    ,ActionGeo_Type varchar

    ,ActionGeo_FullName varchar

    ,ActionGeo_CountryCode varchar

    ,ActionGeo_ADM1Code varchar

    ,ActionGeo_Lat varchar

    ,ActionGeo_Long varchar

    ,ActionGeo_FeatureID varchar

    ,DATEADDED varchar

    ,SOURCEURL varchar

    );


COPY INTO GDELT.EVENTS.EVENTS_FULL
	FROM @MANAGE_DB.EXTERNAL_STAGES.GDELT_EVENTS/events
    file_format = ( type = 'csv' field_delimiter = '\t')
    pattern = '.*2019091.*'
    ;

select * from GDELT.EVENTS.EVENTS_FULL;



    