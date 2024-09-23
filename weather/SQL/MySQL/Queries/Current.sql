use Weather_v2;

select jsondata ->> '$.location.name' as locationName,
       b.LocationID, 
       jsondata -> '$.current.last_updated_epoch' as lastUpdatedEpoch,
       json_unquote(jsondata -> '$.current.last_updated') as lastUpdated,
       jsondata -> '$.current.temp_c' as tempC,
       jsondata -> '$.current.temp_f' as tempF,
       jsondata -> '$.current.is_day' as isDay,
       jsondata ->> '$.current.condition.text' as currentConditions,
       jsondata -> '$.current.wind_mph' as windMPH,
       jsondata -> '$.current.wind_kph' as windKPH,
       jsondata -> '$.current.wind_degree' as windDegree,
       jsondata ->> '$.current.wind_dir' as windDir,
       jsondata -> '$.current.pressure_mb' as pressureMB,
       jsondata -> '$.current.pressure_in' as pressureIN,
       jsondata -> '$.current.precip_mm' as precipMM,
       jsondata -> '$.current.precip_in' as precipIN,
       jsondata -> '$.current.humidity' as humidity,
       jsondata -> '$.current.cloud' as cloud,
       jsondata -> '$.current.feelslike_c' as feelsLikeC,
       jsondata -> '$.current.feelslike_f' as feelsLikeF,
       jsondata -> '$.current.windchill_c' as windChillC,
       jsondata -> '$.current.windchill_f' as windChillF,
       jsondata -> '$.current.heatindex_c' as heatIndexC,
       jsondata -> '$.current.heatindex_f' as heatIndexF, 
       jsondata -> '$.current.dewpoint_c' as dewPointC,
       jsondata -> '$.current.dewpoint_f' as dewPointF,
       jsondata -> '$.current.vis_km' as visKM,
       jsondata -> '$.current.vis_miles' as visMiles,
       jsondata -> '$.current.uv' as uv,
       jsondata -> '$.current.gust_kph' as gustKPH,
       jsondata -> '$.current.gust_mph' as gustMPH

from weatherjsonload AS a
inner join Weather_v2.Location b on jsondata ->> '$.location.name' = b.name


;

