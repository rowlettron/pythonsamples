use Weather_v2;
go

select a.name,
       b.forecast_date,
       c.[time],
       c.time_epoch,
       c.temp_c,
       c.temp_f,
       c.is_day,
       c.condition,
       c.wind_mph,
       c.wind_kph,
       c.wind_degree,
       c.wind_dir,
       c.pressure_mb,
       c.pressure_in,
       c.precip_mm,
       c.precip_in,
       c.snow_cm,
       c.humidity,
       c.cloud,
       c.feelslike_c,
       c.feelslike_f,
       c.windchill_c,
       c.windchill_f,
       c.heatindex_c,
       c.heatindex_f,
       c.dewpoint_c,
       c.dewpoint_f,
       c.will_it_rain,
       c.chance_of_rain,
       c.will_it_snow,
       c.chance_of_snow,
       c.vis_km,
       c.vis_miles,
       c.gust_mph,
       c.gust_kph,
       c.uv

from dbo.WeatherJsonLoad lvl1

cross apply openjson(lvl1.JsonData) with (
    name varchar(50) '$.location.name',
    forecast nvarchar(max) '$.forecast.forecastday' as json
) as a
cross apply openjson(a.forecast) with (
    forecast_date date '$.date',
    forecast_date_epoch int '$.date_epoch',
    hour nvarchar(max) '$.hour' as json
) as b
cross apply openjson(b.[hour]) with (
    [time] datetime '$.time', 
    time_epoch int '$.time_epoch',
    temp_c float '$.temp_c',
    temp_f float '$.temp_f',
    is_day bit '$.is_day',
    condition varchar(255) '$.condition.text',
    wind_mph float '$.wind_mph',
    wind_kph float '$.wind_kph',
    wind_degree int '$.wind_degree',
    wind_dir varchar(255) '$.wind_dir',
    pressure_mb float '$.pressure_mb',
    pressure_in float '$.pressure_in',
    precip_mm float '$.precip_mm',
    precip_in float '$.precip_in',
    snow_cm float '$.snow_cm',
    humidity float '$.humidity',
    cloud float '$.cloud',
    feelslike_c float '$.feelslike_c',
    feelslike_f float '$.feelslike_f',
    windchill_c float '$.windchill_c',
    windchill_f float '$.windchill_f',
    heatindex_c float '$.heatindex_c',
    heatindex_f float '$.heatindex_f',
    dewpoint_c float '$.dewpoint_c',
    dewpoint_f float '$.dewpoint_f',
    will_it_rain bit '$.will_it_rain',
    chance_of_rain float '$.chance_of_rain',
    will_it_snow bit '$.will_it_snow',
    chance_of_snow float '$.chance_of_snow',
    vis_km float '$.vis_km',
    vis_miles float '$.vis_miles',
    gust_mph float '$.gust_mph',
    gust_kph float '$.gust_kph',
    uv float '$.uv'
) as c
where lvl1.Processed = 0;

