select wjl_id, 
       json_unquote(json_extract(jsondata, '$.location.name')) as locationname,
       json_unquote(json_extract(jsondata, '$.location.region')) as region,
       json_unquote(json_extract(jsondata, '$.location.country')) as country,
       json_extract(jsondata, '$.location.lat') as latitude,
       json_extract(jsondata, '$.location.lon') as longitude,
       json_unquote(json_extract(jsondata, '$.location.tz_id')) as timezone,
       json_extract(jsondata, '$.location.localtime_epoch') as localtime_epoch,
       json_unquote(json_extract(jsondata, '$.location.localtime')) as local_time
from weatherjsonload_test;

select wjl_id,
       json_extract(jsondata, '$.current.last_updated_epoch') as last_updated_epoch,
       json_unquote(json_extract(jsondata, '$.current.last_updated')) as last_updated,
       json_extract(jsondata, '$.current.temp_c') as temp_c,
       json_extract(jsondata, '$.current.temp_f') as temp_f,
       json_extract(jsondata, '$.current.is_day') as is_day,
       json_unquote(json_extract(jsondata, '$.current.condition.text')) as conditions,
       json_extract(jsondata, '$.current.wind_mph') as wind_mph,
       json_extract(jsondata, '$.current.wind_kph') as wind_kph,
       json_extract(jsondata, '$.current.wind_degree') as wind_degree
from weatherjsonload_test;

-- SELECT JSONCOL->>'$.PATH' FROM tableName
-- JSON_EXTRACT(jsondata, '$.phone.home') as phone

/* 
current": {
        "last_updated_epoch": 1724353200,
        "last_updated": "2024-08-22 20:00",
        "temp_c": 19.2,
        "temp_f": 66.6,
        "is_day": 1,
        "condition": {
            "text": "Light rain",
            "icon": "//cdn.weatherapi.com/weather/64x64/day/296.png",
            "code": 1183
        },
        "wind_mph": 13.6,
        "wind_kph": 22.0,
        "wind_degree": 220,
        "wind_dir": "SW",
        "pressure_mb": 1004.0,
        "pressure_in": 29.65,
        "precip_mm": 0.0,
        "precip_in": 0.0,
        "humidity": 88,
        "cloud": 50,
        "feelslike_c": 19.2,
        "feelslike_f": 66.6,
        "windchill_c": 17.8,
        "windchill_f": 64.1,
        "heatindex_c": 17.8,
        "heatindex_f": 64.1,
        "dewpoint_c": 14.7,
        "dewpoint_f": 58.5,
        "vis_km": 10.0,
        "vis_miles": 6.0,
        "uv": 4.0,
        "gust_mph": 16.8,
        "gust_kph": 27.0
*/

