use Weather_v2;

DROP PROCEDURE IF EXISTS insert_daily_forecast;

delimiter //

CREATE PROCEDURE insert_daily_forecast ()
BEGIN
    DROP TABLE IF EXISTS source;
    
    CREATE TEMPORARY TABLE source AS (
    SELECT DISTINCT jsondata ->> '$.location.name' AS location_name,
           forecast_date,
           forecast_date_epoch,
           maxtemp_c,
           maxtemp_f,
           mintemp_c,
           mintemp_f,
           avgtemp_c,
           avgtemp_f,
           maxwind_mph,
           maxwind_kph,
           totalprecip_mm,
           totalprecip_in,
           totalsnow_cm,
           avgvis_km, 
           avgvis_miles,
           avghumidity,
           daily_will_it_rain,
           daily_chance_of_rain,
           daily_will_it_snow,
           daily_chance_of_snow, 
           conditions,
           uv
	FROM Weather_v2.weatherjsonload wjl,
	JSON_TABLE(jsondata, '$.forecast.forecastday[*]' columns (
		forecast_date DATE PATH '$.date',
		forecast_date_epoch INT PATH '$.date_epoch',
		maxtemp_c NUMERIC(9,2) PATH '$.day.maxtemp_c',
		maxtemp_f NUMERIC(9,2) PATH '$.day.maxtemp_f',
		mintemp_c NUMERIC(9,2) PATH '$.day.mintemp_c',
		mintemp_f NUMERIC(9,2) PATH '$.day.mintemp_f',
		avgtemp_c NUMERIC(9,2) PATH '$.day.avgtemp_c',
		avgtemp_f NUMERIC(9,2) PATH '$.day.avgtemp_f',
		maxwind_mph NUMERIC(9,2) PATH '$.day.maxwind_mph',
		maxwind_kph NUMERIC(9,2) PATH '$.day.maxwind_kph',
		totalprecip_mm NUMERIC(9,2) PATH '$.day.totalprecip_mm',
		totalprecip_in NUMERIC(9,2) PATH '$.day.totalprecip_in',
		totalsnow_cm NUMERIC(9,2) PATH '$.day.totalsnow_cm',
		avgvis_km NUMERIC(9,2) PATH '$.day.avgvis_km',
		avgvis_miles NUMERIC(9,2) PATH '$.day.avgvis_miles',
		avghumidity NUMERIC(9,2) PATH '$.day.avghumidity',
		daily_will_it_rain BOOLEAN PATH '$.day.daily_will_it_rain',
		daily_chance_of_rain NUMERIC(9,2) PATH '$.day.daily_chance_of_rain',
		daily_will_it_snow BOOLEAN PATH '$.day.daily_will_it_snow',
		daily_chance_of_snow NUMERIC(9,2) PATH '$.day.daily_chance_of_snow',
		conditions varchar(50) PATH '$.day.condition.text',
		uv NUMERIC(9,2) PATH '$.day.uv'
		) 
	) forecast
	WHERE processed = 0);
    
    INSERT INTO Weather_v2.DailyForecast (LocationID, forecast_date, forecast_date_epoch, maxtemp_c, maxtemp_f, mintemp_c, mintemp_f,
                                          avgtemp_c, avgtemp_f, maxwind_mph, maxwind_kph, totalprecip_mm, totalprecip_in, totalsnow_cm, 
                                          avgvis_km, avgvis_miles, avghumidity, daily_will_it_rain, daily_chance_of_rain, daily_will_it_snow,
                                          daily_chance_of_snow, conditions, uv)
	   SELECT DISTINCT LocationID,
           forecast_date,
           forecast_date_epoch,
           maxtemp_c,
           maxtemp_f,
           mintemp_c,
           mintemp_f,
           avgtemp_c,
           avgtemp_f,
           maxwind_mph,
           maxwind_kph,
           totalprecip_mm,
           totalprecip_in,
           totalsnow_cm,
           avgvis_km, 
           avgvis_miles,
           avghumidity,
           daily_will_it_rain,
           daily_chance_of_rain,
           daily_will_it_snow,
           daily_chance_of_snow, 
           conditions,
           uv
    FROM source a 
    INNER JOIN Weather_v2.Location b ON a.location_name = b.name
    ON DUPLICATE KEY UPDATE maxtemp_c = a.maxtemp_c,
                            maxtemp_f = a.maxtemp_f,
                            mintemp_c = a.mintemp_c,
                            mintemp_f = a.mintemp_f,
                            avgtemp_c = a.avgtemp_c,
                            avgtemp_f = a.avgtemp_f,
                            maxwind_mph = a.maxwind_mph,
                            maxwind_kph = a.maxwind_kph,
                            totalprecip_mm = a.totalprecip_mm,
                            totalprecip_in = a.totalprecip_in,
                            totalsnow_cm = a.totalsnow_cm,
                            avgvis_km = a.avgvis_km,
                            avgvis_miles = a.avgvis_miles,
                            avghumidity = a.avghumidity,
                            daily_will_it_rain = a.daily_will_it_rain,
                            daily_chance_of_rain = a.daily_chance_of_rain,
                            daily_will_it_snow = a.daily_will_it_snow,
                            daily_chance_of_snow = a.daily_chance_of_snow,
                            conditions = a.conditions,
                            uv = a.uv
    ;
    
END;
//

delimiter ;
