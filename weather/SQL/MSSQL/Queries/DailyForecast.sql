use Weather_v2;
go

select a.name,
       b.forecast_date,
       b.forecast_date_epoch,
       c.maxtemp_c,
       c.maxtemp_f,
       c.mintemp_c,
       c.mintemp_f,
       c.avgtemp_c,
       c.avgtemp_f,
       c.maxwind_mph,
       c.maxwind_kph,
       c.totalprecip_mm,
       c.totalprecip_in,
       c.totalsnow_cm,
       c.avgvis_km,
       c.avgvis_miles,
       c.avghumidity,
       c.daily_will_it_rain,
       c.daily_chance_of_rain,
       c.daily_will_it_snow,
       c.daily_chance_of_snow,
       c.conditions,
       c.uv

from dbo.WeatherJsonLoad lvl1

cross apply openjson(lvl1.JsonData) with (
    name varchar(50) '$.location.name',
    forecast nvarchar(max) '$.forecast.forecastday' as json
) as a
cross apply openjson(a.forecast) with (
    forecast_date date '$.date',
    forecast_date_epoch int '$.date_epoch',
    day nvarchar(max) '$.day' as json
) as b
cross apply openjson(b.day) with (
    maxtemp_c float '$.maxtemp_c',
    maxtemp_f float '$.maxtemp_f',
    mintemp_c float '$.mintemp_c',
    mintemp_f float '$.mintemp_f',
    avgtemp_c float '$.avgtemp_c',
    avgtemp_f float '$.avgtemp_f',
    maxwind_mph float '$.maxwind_mph',
    maxwind_kph float '$.maxwind_kph',
    totalprecip_mm float '$.totalprecip_mm',
    totalprecip_in float '$.totalprecip_in',
    totalsnow_cm float '$.totalsnow_cm',
    avgvis_km float '$.avgvis_km',
    avgvis_miles float '$.avgvis_miles',
    avghumidity float '$.avghumidity',
    daily_will_it_rain bit '$.daily_will_it_rain',
    daily_chance_of_rain float '$.daily_chance_of_rain',
    daily_will_it_snow bit '$.daily_will_it_snow',
    daily_chance_of_snow float '$.daily_chance_of_snow',
    conditions varchar(255) '$.condition.text',
    uv float '$.uv'
) as c