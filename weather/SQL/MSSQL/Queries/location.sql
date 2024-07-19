use Weather_V2;
go  

select a.name,
       a.region,
       a.country,
       a.latitude,
       a.longitude,
       a.timezone,
       a.localtime_epoch,
       a.localtime
from dbo.WeatherJsonLoad as lvl1
cross apply openjson(lvl1.JsonData) with (
    name varchar(50) '$.location.name',
    region varchar(50) '$.location.region',
    country varchar(100) '$.location.country',
    latitude float '$.location.lat',
    longitude float '$.location.lon',
    timezone varchar(50) '$.location.tz_id',
    localtime_epoch int '$.location.localtime_epoch',
    localtime datetime '$.location.localtime'
) as a


where Processed = 0;
