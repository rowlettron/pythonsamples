use weather_v2;

-- Location
select wjl_id, 
       json_unquote(json_extract(jsondata, '$.location.name')) as locationname,
       json_unquote(json_extract(jsondata, '$.location.region')) as region,
       json_unquote(json_extract(jsondata, '$.location.country')) as country,
       json_extract(jsondata, '$.location.lat') as latitude,
       json_extract(jsondata, '$.location.lon') as longitude,
       json_unquote(json_extract(jsondata, '$.location.tz_id')) as timezone,
       json_extract(jsondata, '$.location.localtime_epoch') as localtime_epoch,
       json_unquote(json_extract(jsondata, '$.location.localtime')) as local_time
from weatherjsonload_test
where processed = 0;

-- Current
select wjl_id,
       json_extract(jsondata, '$.current.last_updated_epoch') as last_updated_epoch,
       json_unquote(json_extract(jsondata, '$.current.last_updated')) as last_updated,
       json_extract(jsondata, '$.current.temp_c') as temp_c,
       json_extract(jsondata, '$.current.temp_f') as temp_f,
       json_extract(jsondata, '$.current.is_day') as is_day,
       json_unquote(json_extract(jsondata, '$.current.condition.text')) as conditions,
       json_extract(jsondata, '$.current.wind_mph') as wind_mph,
       json_extract(jsondata, '$.current.wind_kph') as wind_kph,
       json_extract(jsondata, '$.current.wind_degree') as wind_degree,
       json_unquote(json_extract(jsondata, '$.current.wind_dir')) as wind_dir,
       json_extract(jsondata, '$.current.pressure_mb') as pressure_mb,
       json_extract(jsondata, '$.current.pressure_in') as pressure_in,
       json_extract(jsondata, '$.current.precip_mm') as precip_mm,
       json_extract(jsondata, '$.current.precip_in') as precip_in,
       json_extract(jsondata, '$.current.humidity') as humidity,
       json_extract(jsondata, '$.current.cloud') as cloud,
       json_extract(jsondata, '$.current.feelslike_c') as feelslike_c,
       json_extract(jsondata, '$.current.feelslike_f') as feelslike_f,
       json_extract(jsondata, '$.current.windchill_c') as windchill_c,
       json_extract(jsondata, '$.current.windchill_f') as windchill_f,
       json_extract(jsondata, '$.current.heatindex_c') as heatindex_c,
       json_extract(jsondata, '$.current.heatindex_f') as heatindex_f,
       json_extract(jsondata, '$.current.dewpoint_c') as dewpoint_c,
       json_extract(jsondata, '$.current.dewpoint_f') as dewpoint_f,
       json_extract(jsondata, '$.current.vis_km') as vis_km,
       json_extract(jsondata, '$.current.vis_miles') as vis_miles,
       json_extract(jsondata, '$.current.uv') as uv,
       json_extract(jsondata, '$.current.gust_mph') as gust_mph,
       json_extract(jsondata, '$.current.gust_kph') as gust_kph
from weatherjsonload_test
where processed = 0;