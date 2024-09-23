use Weather_v2;

DROP PROCEDURE IF EXISTS insert_current_conditions;

delimiter //

CREATE PROCEDURE insert_current_conditions ()
BEGIN
    DROP TABLE IF EXISTS source;
    
    CREATE TEMPORARY TABLE source AS (
	SELECT b.LocationID,
       jsondata -> '$.current.last_updated_epoch' as last_updated_epoch,
       json_unquote(jsondata -> '$.current.last_updated') as last_updated,
       jsondata -> '$.current.temp_c' as temp_c,
       jsondata -> '$.current.temp_f' as temp_f,
       jsondata -> '$.current.is_day' as isday,
       jsondata ->> '$.current.condition.text' as current_conditions,
       jsondata -> '$.current.wind_mph' as wind_mph,
       jsondata -> '$.current.wind_kph' as wind_kph,
       jsondata -> '$.current.wind_degree' as wind_degree,
       jsondata ->> '$.current.wind_dir' as wind_direction,
       jsondata -> '$.current.pressure_mb' as pressure_mb,
       jsondata -> '$.current.pressure_in' as pressure_in,
       jsondata -> '$.current.precip_mm' as precip_mm,
       jsondata -> '$.current.precip_in' as precip_in,
       jsondata -> '$.current.humidity' as humidity,
       jsondata -> '$.current.cloud' as cloud,
       jsondata -> '$.current.feelslike_c' as feelslike_c,
       jsondata -> '$.current.feelslike_f' as feelslike_f,
       jsondata -> '$.current.windchill_c' as windchill_c,
       jsondata -> '$.current.windchill_f' as windchill_f,
       jsondata -> '$.current.heatindex_c' as heatindex_c,
       jsondata -> '$.current.heatindex_f' as heatindex_f, 
       jsondata -> '$.current.dewpoint_c' as dewpoint_c,
       jsondata -> '$.current.dewpoint_f' as dewpoint_f,
       jsondata -> '$.current.vis_km' as vis_km,
       jsondata -> '$.current.vis_miles' as vis_miles,
       jsondata -> '$.current.uv' as uv,
       jsondata -> '$.current.gust_mph' as gust_mph, 
       jsondata -> '$.current.gust_kph' as gust_kph
    FROM weatherjsonload a
    INNER JOIN Weather_v2.Location b on jsondata ->> '$.location.name' = b.LocationID
    WHERE processed = 0
    ) ;
    
    
    
    INSERT Weather_v2.CurrentConditions(LocationID, last_updated_epoch, last_updated, temp_c, temp_f, isday, current_conditions, wind_mph,
                                        wind_kph, wind_degree, wind_direction, pressure_mb, pressure_in, precip_mm, precip_in, humidity,
                                        cloud, feelslike_c, feelslike_f, windchill_c, windchill_f, heatindex_c, heatindex_f, dewpoint_c,
                                        dewpoint_f, vis_km, vis_miles, uv, gust_mph, gust_kph)
	SELECT b.LocationID,
           last_updated_epoch,
		   last_updated,
		   temp_c,
		   temp_f,
		   isday,
		   current_conditions,
		   wind_mph,
		   wind_kph,
		   wind_degree,
		   wind_direction,
		   pressure_mb,
		   pressure_in,
		   precip_mm,
		   precip_in,
		   humidity,
		   cloud,
		   feelslike_c,
		   feelslike_f,
		   windchill_c,
		   windchill_f,
		   heatindex_c,
		   heatindex_f, 
		   dewpoint_c,
		   dewpoint_f,
		   vis_km,
		   vis_miles,
		   uv,
		   gust_mph, 
		   gust_kph
    FROM source
    ON DUPLICATE KEY UPDATE last_updated_epoch = last_updated_epoch,
                            last_updated = last_updated,
                            temp_c = temp_c,
                            temp_f = temp_f,
                            isday = isday,
                            current_conditions = current_conditions,
                            wind_mph = wind_mph,
                            wind_kph = wind_kph,
                            wind_degree = wind_degree,
                            wind_direction = wind_direction,
                            pressure_mb = pressure_mb,
                            pressure_in = pressure_in,
                            precip_mm = precip_mm,
                            precip_in = precip_in,
                            humidity = humidity,
                            cloud = cloud,
                            feelslike_c = feelslike_c,
                            feelslike_f = feelslike_f,
                            windchill_c = windchill_c,
                            windchill_f = windchill_f,
                            heatindex_c = heatindex_c,
                            dewpoint_c = dewpoint_c,
                            dewpoint_f = dewpoint_f,
                            vis_km = vis_km,
                            vis_miles = vis_miles,
                            uv = uv,
                            gust_mph = gust_mph,
                            gust_kph = gust_kph ;

END;
//

delimiter ;
