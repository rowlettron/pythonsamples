use Weather_v2;

-- SELECT people.* 
-- FROM t1, 
--      JSON_TABLE(json_col, '$.people[*]' COLUMNS (
--                 name VARCHAR(40)  PATH '$.name',
--                 address VARCHAR(100) PATH '$.address')
--      ) people;
     
select distinct jsondata ->> '$.location.name' as locationName,
       forecast.forecastDate,
       forecast.forecastDateEpoch,
       forecast.forecastMaxTempC,
       forecast.forecastMaxTempF,
       forecast.forecastMinTempC,
       forecast.forecastMinTempF,
       forecast.forecastAvgTempC,
       forecast.forecastAvgTempF,
       forecast.forecastMaxWindMPH,
       forecast.forecastMaxWindKPH,
       forecast.forecastTotalPrecipMM,
       forecast.forecastTotalPrecipIN,
       forecast.forecastTotalSnowCM,
       forecast.forecastAvgVisKM,
       forecastAvgVisMiles,
       forecastAvgHumidity,
       forecastDailyWillItRain,
       forecastDailyChanceOfRain,
       forecastDailyWillItSnow,
       forecastDailyChanceOfSnow,
       forecastConditions,
       forecastUV
from Weather_v2.weatherjsonload wjl,
json_table(jsondata, '$.forecast.forecastday[*]' columns (
    forecastDate date path '$.date',
    forecastDateEpoch int path '$.date_epoch',
    forecastMaxTempC numeric(9,2) path '$.day.maxtemp_c',
    forecastMaxTempF numeric(9,2) path '$.day.maxtemp_f',
    forecastMinTempC numeric(9,2) path '$.day.mintemp_c',
    forecastMinTempF numeric(9,2) path '$.day.mintemp_f',
    forecastAvgTempC numeric(9,2) path '$.day.avgtemp_c',
    forecastAvgTempF numeric(9,2) path '$.day.avgtemp_f',
    forecastMaxWindMPH numeric(9,2) path '$.day.maxwind_mph',
    forecastMaxWindKPH numeric(9,2) path '$.day.maxwind_kph',
    forecastTotalPrecipMM numeric(9,2) path '$.day.totalprecip_mm',
    forecastTotalPrecipIN numeric(9,2) path '$.day.totalprecip_in',
    forecastTotalSnowCM numeric(9,2) path '$.day.totalsnow_cm',
    forecastAvgVisKM numeric(9,2) path '$.day.avgvis_km',
    forecastAvgVisMiles numeric(9,2) path '$.day.avgvis_miles',
    forecastAvgHumidity numeric(9,2) path '$.day.avghumidity',
    forecastDailyWillItRain bit path '$.day.daily_will_it_rain',
    forecastDailyChanceOfRain numeric(9,2) path '$.day.daily_chance_of_rain',
    forecastDailyWillItSnow bit path '$.day.daily_will_it_snow',
    forecastDailyChanceOfSnow numeric(9,2) path '$.day.daily_chance_of_snow',
    forecastConditions varchar(50) path '$.day.condition.text',
    forecastUV numeric(9,2) path '$.day.uv'
    ) 
) forecast
order by jsondata ->> '$.location.name',
         forecast.forecastDate asc; 

