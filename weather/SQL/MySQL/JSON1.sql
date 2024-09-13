use weather_v2;


select a.*
from dev.t1,
JSON_TABLE (json_col, '$[*]' COLUMNS (	
            id FOR ORDINALITY,
            father VARCHAR(30) PATH '$.father',
            married INTEGER EXISTS PATH '$.marriage_date',
            NESTED PATH '$.children[*]' COLUMNS (
              child_id FOR ORDINALITY,
              child VARCHAR(30) PATH '$.name',
              age INTEGER PATH '$.age') )	
) a; 

select * from weather_v2.weatherjsonload_test;

select distinct a.*
from weather_v2.weatherjsonload_test, 
JSON_TABLE (json_extract(jsondata, '$.*'), '$[*]' COLUMNS (
    location VARCHAR(50) PATH '$.name' ,
    region VARCHAR(50) PATH '$.region',
    country VARCHAR(50) PATH '$.country',
    latitude NUMERIC(9,2) PATH '$.lat', 
    longitude NUMERIC(9,2) PATH '$.lon', 
    timezone VARCHAR(50) PATH '$.tz_id',
    localtime_epoch INT PATH '$.localtime_epoch',
    local_time DATETIME PATH '$.localtime',
    last_updated_epoch INT PATH '$.last_updated_epoch',
    last_updated DATETIME PATH '$.last_updated',
    temp_c NUMERIC(9,2) PATH '$.temp_c',
    temp_f NUMERIC(9.2) PATH '$.temp_f',
    is_day BIT PATH '$.is_day',
    currentConditions VARCHAR(100) PATH '$.condition.text',
    wind_mph NUMERIC(9,2) PATH '$.wind_mph',
    wind_kph NUMERIC(9,2) PATH '$.wind_kph',
    wind_degree NUMERIC(9,2) PATH '$.wind_degree',
    wind_dir VARCHAR(15) PATH '$.wind_dir',
    pressure_mb NUMERIC(9,2) PATH '$.pressure_mb',
    pressure_in NUMERIC(9,2) PATH '$.pressure_in'
    ) 
) a
;
select distinct a.*
from weather_v2.weatherjsonload_test, 
JSON_TABLE (json_extract(jsondata, '$.*'), '$[*]' COLUMNS (
    id FOR ORDINALITY,
    NESTED PATH '$.*' COLUMNS (
        forecastDate DATE PATH '$.forecastday.date'
    )
    ) 
) a
;


