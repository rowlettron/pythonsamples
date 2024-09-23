use Weather_v2;

DROP PROCEDURE IF EXISTS insert_daily_forecast;

delimiter //

CREATE PROCEDURE insert_daily_forecast ()
BEGIN
    DROP TABLE IF EXISTS source;
    
    CREATE TEMPORARY TABLE source AS (
    SELECT DISTINCT jsondata ->> '$.location.name' as locationName,
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
	FROM Weather_v2.weatherjsonload wjl,
	JSON_TABLE(jsondata, '$.forecast.forecastday[*]' columns (
		forecastDate DATE PATH '$.date',
		forecastDateEpoch INT PATH '$.date_epoch',
		forecastMaxTempC NUMERIC(9,2) PATH '$.day.maxtemp_c',
		forecastMaxTempF NUMERIC(9,2) PATH '$.day.maxtemp_f',
		forecastMinTempC NUMERIC(9,2) PATH '$.day.mintemp_c',
		forecastMinTempF NUMERIC(9,2) PATH '$.day.mintemp_f',
		forecastAvgTempC NUMERIC(9,2) PATH '$.day.avgtemp_c',
		forecastAvgTempF NUMERIC(9,2) PATH '$.day.avgtemp_f',
		forecastMaxWindMPH NUMERIC(9,2) PATH '$.day.maxwind_mph',
		forecastMaxWindKPH NUMERIC(9,2) PATH '$.day.maxwind_kph',
		forecastTotalPrecipMM NUMERIC(9,2) PATH '$.day.totalprecip_mm',
		forecastTotalPrecipIN NUMERIC(9,2) PATH '$.day.totalprecip_in',
		forecastTotalSnowCM NUMERIC(9,2) PATH '$.day.totalsnow_cm',
		forecastAvgVisKM NUMERIC(9,2) PATH '$.day.avgvis_km',
		forecastAvgVisMiles NUMERIC(9,2) PATH '$.day.avgvis_miles',
		forecastAvgHumidity NUMERIC(9,2) PATH '$.day.avghumidity',
		forecastDailyWillItRain BIT PATH '$.day.daily_will_it_rain',
		forecastDailyChanceOfRain NUMERIC(9,2) PATH '$.day.daily_chance_of_rain',
		forecastDailyWillItSnow BIT PATH '$.day.daily_will_it_snow',
		forecastDailyChanceOfSnow NUMERIC(9,2) PATH '$.day.daily_chance_of_snow',
		forecastConditions varchar(50) PATH '$.day.condition.text',
		forecastUV NUMERIC(9,2) PATH '$.day.uv'
		) 
	) forecast
	WHERE processed = 0);
    
    INSERT INTO Weather_v2.DailyForecast (LocationID, forecast_date, forecast_date_epoch, maxtemp_c, maxtemp_f, mintemp_c, mintemp_f,
                                          avgtemp_c, avgtemp_f, maxwind_mph, maxwind_kph, totalprecip_mm, totalprecip_in, totalsnow_cm, 
    
END;
//

delimiter ;
