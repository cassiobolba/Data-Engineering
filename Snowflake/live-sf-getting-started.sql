------------------------  Prep para carregar dados ------------------------------

CREATE OR REPLACE TABLE EVENTS
(
	 GLOBALEVENTID integer
    ,SQLDATE date
    ,MONTHYEAR string
    ,Actor1Name string
    ,NumMentions integer
    ,SOURCEURL string
);    

list @GDELT_EVENTS;


CREATE OR REPLACE FILE FORMAT CSV_TAB_FMT
	FIELD_DELIMITER = '\t'
    	TYPE = CSV;

show file formats in database GDELT;
        
------------------------  Carregando os dados ------------------------------

COPY INTO EVENTS FROM (
SELECT 
	 $1::int GLOBALEVENTID
    ,TO_DATE($2,'YYYYMMDD') AS SQLDATE
    ,$3::string MONTHYEAR
    ,$7::string Actor1Name
    ,$34::int NumMentions
    ,$58::string SOURCEURL
FROM @MANAGE_DB.EXTERNAL_STAGES.GDELT_EVENTS/events/20190917.export.csv
(file_format => MANAGE_DB.FILE_FORMATS.CSV_TAB_FMT) );
--(file_format => MANAGE_DB.FILE_FORMATS.CSV_TAB_FMT)
);


--mostrar que nao tem mais nada
select * from EVENTS limit 10;

--change warehouse size from small to large (4x)
alter warehouse compute_wh set warehouse_size='large';

--load data with large warehouse
show warehouses;

--Rodar novamente comando copy e mostar que foi mais rapido



------------------------  Cache results e Clone ------------------------------

select * from EVENTS limit 20;

SELECT 
     Actor1Name as actor_name
    ,sum(NumMentions) mentions_actor
    ,count(GLOBALEVENTID) events_actor
FROM EVENTS
where Actor1Name is not null
group by 1
order by 2 desc;


create table trips_dev clone trips;


------------------------  Psemi-structured data  ------------------------------

create database weather;

use role sysadmin;
use warehouse compute_wh;
use database weather;
use schema public;

create table json_weather_data (v variant);

create stage nyc_weather
url = 's3://snowflake-workshop-lab/weather-nyc';

list @nyc_weather;

copy into json_weather_data 
from @nyc_weather 
file_format = (type=json);

select * from json_weather_data limit 10;

create view json_weather_data_view as
select
  v:time::timestamp as observation_time,
  v:city.id::int as city_id,
  v:city.name::string as city_name,
  v:city.country::string as country,
  v:city.coord.lat::float as city_lat,
  v:city.coord.lon::float as city_lon,
  v:clouds.all::int as clouds,
  (v:main.temp::float)-273.15 as temp_avg,
  (v:main.temp_min::float)-273.15 as temp_min,
  (v:main.temp_max::float)-273.15 as temp_max,
  v:weather[0].main::string as weather,
  v:weather[0].description::string as weather_desc,
  v:weather[0].icon::string as weather_icon,
  v:wind.deg::float as wind_dir,
  v:wind.speed::float as wind_speed
from json_weather_data
where city_id = 5128638;


------------------------  time travel  ------------------------------

drop table json_weather_data;=

Select * from json_weather_data limit 10;

undrop table json_weather_data;

use role sysadmin;
use warehouse compute_wh;
use database citibike;
use schema public;

update trips set start_station_name = 'oops';

select 
start_station_name as "station",
count(*) as "rides"
from trips
group by 1
order by 2 desc
limit 20;

set query_id = 
(select query_id from 
table(information_schema.query_history_by_session (result_limit=>5)) 
where query_text like 'update%' order by start_time limit 1);

create or replace table trips as
(select * from trips before (statement => $query_id));
        
select 
start_station_name as "station",
count(*) as "rides"
from trips
group by 1
order by 2 desc
limit 20;






