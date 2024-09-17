use Weather_v2;

select distinct jsondata ->> '$.location.name' as locationName,
       jsondata ->> '$.location.region' as region,
       jsondata ->> '$.location.country' as country,
       jsondata -> '$.location.lat' as latitude,
       jsondata -> '$.location.lon' as longitude,
       jsondata ->> '$.location.tz_id' as timeZone,
       jsondata -> '$.location.localtime_epoch' as localTimeEpoch,
       jsondata ->> '$.location.localtime' as local_Time

from Weather_v2.weatherjsonload;

