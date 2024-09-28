USE Weather_v2;

DROP PROCEDURE IF EXISTS insert_hourly_forecast;

DELIMITER //

CREATE PROCEDURE insert_hourly_forecast ()
BEGIN
    
    DROP TABLE IF EXISTS hourly_source;
    
    CREATE TEMPORARY TABLE hourly_source AS (
    SELECT id,  
           jsondata ->> '$.location.name' AS location_name,
           forecast_hour, 
           forecast_time_epoch,
           temp_c,
           temp_f,
           is_day,
           hourlycondition,
           wind_mph,
           wind_kph,
           wind_degree,
           wind_dir,
           pressure_mb,
           pressure_in,
           precip_mm,
           precip_in, 
           snow_cm,
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
           will_it_rain,
           chance_of_rain,
           will_it_snow,
           chance_of_snow,
           vis_km,
           vis_miles,
           gust_mph, 
           gust_kph, 
           uv
    FROM Weather_v2.weatherjsonload wjl,
    JSON_TABLE(jsondata, '$.forecast.forecastday[*]' columns (
        
        NESTED PATH '$.hour[*]' columns (
            id for ordinality,
            forecast_hour DATETIME PATH '$.time', 
            forecast_time_epoch INT PATH '$.time_epoch',
            temp_c NUMERIC(9,2) PATH '$.temp_c',
            temp_f NUMERIC(9,2) PATH '$.temp_f',
            is_day BIT PATH '$.is_day',
            hourlycondition VARCHAR(50) PATH '$.condition.text',
            wind_mph NUMERIC(9,2) PATH '$.wind_mph',
            wind_kph NUMERIC(9,2) PATH '$.wind_kph',
            wind_degree NUMERIC(9,2) PATH '$.wind_degree',
            wind_dir varchar(50) PATH '$.wind_dir',
            pressure_mb NUMERIC(9,2) PATH '$.pressure_mb',
            pressure_in NUMERIC(9,2) PATH '$.pressure_in',
            precip_mm NUMERIC(9,2) PATH '$.precip_mm', 
            precip_in NUMERIC(9,2) PATH '$.precip_in', 
            snow_cm NUMERIC(9,2) PATH '$.snow_cm',
            humidity NUMERIC(9,2) PATH '$.humidity', 
            cloud INT PATH '$.cloud',
            feelslike_c NUMERIC(9,2) PATH '$.feelslike_c',
            feelslike_f NUMERIC(9,2) PATH '$.feelslike_f',
            windchill_c NUMERIC(9,2) PATH '$.windchill_c',
            windchill_f NUMERIC(9,2) PATH '$.windchill_f',
            heatindex_c NUMERIC(9,2) PATH '$.heatindex_c',
            heatindex_f NUMERIC(9,2) PATH '$.heatindex_f',
            dewpoint_c NUMERIC(9,2) PATH '$.dewpoint_c',
            dewpoint_f NUMERIC(9,2) PATH '$.dewpoint_f',
            will_it_rain BOOLEAN PATH '$.will_it_rain',
            chance_of_rain NUMERIC(9,2) PATH '$.chance_of_rain',
            will_it_snow BOOLEAN PATH '$.will_it_snow',
            chance_of_snow NUMERIC(9,2) PATH '$.chance_of_snow',
            vis_km NUMERIC(9,2) PATH '$.vis_km',
            vis_miles NUMERIC(9,2) PATH '$.vis_miles',
            gust_mph NUMERIC(9,2) PATH '$.gust_mph',
            gust_kph NUMERIC(9,2) PATH '$.gust_kph', 
            uv NUMERIC(9,2) PATH '$.uv'
            )
        
        )
    ) hourly
    WHERE processed = 0
    );
    
    INSERT INTO Weather_v2.HourlyForecast(LocationID, forecast_hour, forecast_time_epoch, temp_c, temp_f, is_day, hourlycondition, wind_mph,
                                          wind_kph, wind_degree, wind_dir, pressure_mb, pressure_in, precip_mm, precip_in, snow_cm, humidity, cloud,
                                          feelslike_c, feelslike_f, windchill_c, windchill_f, heatindex_c, heatindex_f, dewpoint_c, dewpoint_f,
                                          will_it_rain, chance_of_rain, will_it_snow, chance_of_snow, vis_km, vis_miles, gust_mph, gust_kph, uv)
    SELECT b.LocationID, 
		forecast_hour, 
        forecast_time_epoch, 
        temp_c, 
        temp_f, 
        is_day, 
        hourlycondition, 
        wind_mph,
        wind_kph, 
        wind_degree, 
        wind_dir, 
        pressure_mb, 
        pressure_in, 
        precip_mm, 
        precip_in, 
        snow_cm, 
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
        will_it_rain, 
        chance_of_rain, 
        will_it_snow, 
        chance_of_snow, 
        vis_km, 
        vis_miles, 
        gust_mph, 
        gust_kph, 
        uv
    FROM hourly_source a
    INNER JOIN Weather_v2.Location b ON a.location_name = b.name 
	ON DUPLICATE KEY UPDATE temp_c = a.temp_c,
                            temp_f = a.temp_f,
                            is_day = a.is_day,
                            hourlycondition = a.hourlycondition,
                            wind_mph = a.wind_mph,
                            wind_kph = a.wind_kph,
                            wind_degree = a.wind_degree,
                            wind_dir = a.wind_dir,
                            pressure_mb = a.pressure_mb,
                            pressure_in = a.pressure_in,
                            precip_mm = a.precip_mm,
                            precip_in = a.precip_in, 
                            snow_cm = a.snow_cm, 
                            humidity = a.humidity,
                            cloud = a.cloud,
                            feelslike_c = a.feelslike_c,
                            feelslike_f = a.feelslike_f,
                            windchill_c = a.windchill_c,
                            windchill_f = a.windchill_f,
                            heatindex_c = a.heatindex_c,
                            heatindex_f = a.heatindex_f,
                            dewpoint_c = a.dewpoint_c,
                            dewpoint_f = a.dewpoint_f,
                            will_it_rain = a.will_it_rain,
                            chance_of_rain = a.chance_of_rain,
                            will_it_snow = a.will_it_snow,
                            vis_km = a.vis_km,
                            vis_miles = a.vis_miles,
                            gust_mph = a.gust_mph,
                            gust_kph = a.gust_kph,
                            uv = a.uv ;
    
END;
//

DELIMITER ;
