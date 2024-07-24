CREATE OR REPLACE PROCEDURE public.insert_hourlyforecast() --Do not remove parentheses
LANGUAGE plpgsql
AS
$$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.insert_hourlyforecast();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE v_message TEXT;
        v_sqlstate TEXT;
BEGIN
    DROP TABLE IF EXISTS _hourlyforecast;

    CREATE TEMP TABLE _hourlyforecast AS 
    SELECT l.locationid,
           CAST(arr.item_object ->> 'date' AS timestamp) AS forecast_date,
           CAST(arr2.hour_object ->> 'time' AS timestamp) AS forecast_hour, 
           CAST(arr2.hour_object ->> 'time_epoch' AS int8) AS forecast_time_epoch,
           CAST(arr2.hour_object ->> 'temp_c' AS float8) AS temp_c,
           CAST(arr2.hour_object ->> 'temp_f'AS float8) AS temp_f,
           CAST(arr2.hour_object ->> 'is_day' AS bit) AS is_day,
           arr2.hour_object -> 'condition' ->> 'text' AS forecast_condition,
           CAST(arr2.hour_object ->> 'wind_mph' AS float8) AS wind_mph,
           CAST(arr2.hour_object ->> 'wind_kph' AS float8) AS wind_kph,
           CAST(arr2.hour_object ->> 'wind_degree' AS float8) AS wind_degree,
           arr2.hour_object ->> 'wind_dir' AS wind_dir,
           CAST(arr2.hour_object ->> 'pressure_mb' AS float8) AS pressure_mb,
           CAST(arr2.hour_object ->> 'pressure_in' AS float8) AS pressure_in,
           CAST(arr2.hour_object ->> 'precip_mm' AS float8) AS precip_mm,
           CAST(arr2.hour_object ->> 'precip_in' AS float8) AS precip_in,
           CAST(arr2.hour_object ->> 'snow_cm' AS float8) AS snow_cm,
           CAST(arr2.hour_object ->> 'humidity' AS float8) AS humidity,
           CAST(arr2.hour_object ->> 'cloud' AS float8) AS cloud,
           CAST(arr2.hour_object ->> 'feelslike_c' AS float8) AS feelslike_c,
           CAST(arr2.hour_object ->> 'feelslike_f' AS float8) AS feelslike_f,
           CAST(arr2.hour_object ->> 'windchill_c' AS float8) AS windchill_c,
           CAST(arr2.hour_object ->> 'windchill_f' AS float8) AS windchill_f,
           CAST(arr2.hour_object ->> 'heatindex_c' AS float8) AS heatindex_c,
           CAST(arr2.hour_object ->> 'heatindex_f' AS float8) AS heatindex_f,
           CAST(arr2.hour_object ->> 'dewpoint_c' AS float8) AS dewpoint_c,
           CAST(arr2.hour_object ->> 'dewpoint_f' AS float8) AS dewpoint_f,
           CAST(arr2.hour_object ->> 'will_it_rain' AS bit) AS will_it_rain,
           CAST(arr2.hour_object ->> 'chance_of_rain' AS float8) AS chance_of_rain,
           CAST(arr2.hour_object ->> 'will_it_snow' AS bit) AS will_it_snow,
           CAST(arr2.hour_object ->> 'chance_of_snow' AS float8) AS chance_of_snow,
           CAST(arr2.hour_object ->> 'vis_km' AS float8) AS vis_km,
           CAST(arr2.hour_object ->> 'vis_miles' AS float8) AS vis_miles,
           CAST(arr2.hour_object ->> 'gust_mph' AS float8) AS gust_mph,
           CAST(arr2.hour_object ->> 'gust_kph' AS float8) AS gust_kph,
           CAST(arr2.hour_object ->> 'uv' AS float8) AS uv, 
           arr2.position
        FROM public.weatherjsonload wjl
        CROSS JOIN jsonb_array_elements(jsondata -> 'forecast' -> 'forecastday') with ordinality arr(item_object, position)
        CROSS JOIN jsonb_array_elements(arr.item_object -> 'hour') with ordinality arr2(hour_object, position)
        INNER JOIN public.location l ON wjl.jsondata -> 'location' ->> 'name' = l."name"
		WHERE wjl.processed = 0;

  --       execute 'drop table if exists ' || tmp_name;
		-- execute 'create temp table ' || tmp_name || ' as select * from _hourlyforecast';
		
        MERGE INTO public.hourlyforecast AS t

        USING _hourlyforecast AS s 
        ON s.locationid = t.locationid
        AND s.forecast_time_epoch = t.forecast_time_epoch

        WHEN MATCHED THEN 
        UPDATE SET temp_c = s.temp_c,
                   temp_f = s.temp_f,
                   is_day = s.is_day,
                   forecast_condition = s.forecast_condition,
                   wind_mph = s.wind_mph,
                   wind_kph = s.wind_kph,
                   wind_degree = s.wind_degree,
                   wind_dir = s.wind_dir,
                   pressure_mb = s.pressure_mb,
                   pressure_in = s.pressure_in,
                   precip_mm = s.precip_mm,
                   precip_in = s.precip_in,
                   snow_cm = s.snow_cm,
                   humidity = s.humidity,
                   cloud = s.cloud,
                   feelslike_c = s.feelslike_c,
                   feelslike_f = s.feelslike_f,
                   windchill_c = s.windchill_c,
                   windchill_f = s.windchill_f,
                   heatindex_c = s.heatindex_c,
                   heatindex_f = s.heatindex_f,
                   dewpoint_c = s.dewpoint_c,
                   dewpoint_f = s.dewpoint_f,
                   will_it_rain = s.will_it_rain,
                   chance_of_rain = s.chance_of_rain,
                   will_it_snow = s.will_it_snow,
                   chance_of_snow = s.chance_of_snow,
                   vis_km = s.vis_km,
                   vis_miles = s.vis_miles,
                   gust_mph = s.gust_mph,
                   gust_kph = s.gust_kph,
                   uv = s.uv 
				   
        WHEN NOT MATCHED THEN 
        INSERT (locationid,
                forecast_date,
                forecast_hour,
                forecast_time_epoch,
                temp_c,
                temp_f,
                is_day,
                forecast_condition,
                wind_mph,
                wind_kph,
                wind_degree,
                wind_dir,
                pressure_mb,
                pressure_in,
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
                uv)
        VALUES (s.locationid,
                s.forecast_date,
                s.forecast_hour,
                s.forecast_time_epoch,
                s.temp_c,
                s.temp_f,
                s.is_day,
                s.forecast_condition,
                s.wind_mph,
                s.wind_kph,
                s.wind_degree,
                s.wind_dir,
                s.pressure_mb,
                s.pressure_in,
                s.snow_cm,
                s.humidity,
                s.cloud,
                s.feelslike_c,
                s.feelslike_f,
                s.windchill_c,
                s.windchill_f,
                s.heatindex_c,
                s.heatindex_f,
                s.dewpoint_c,
                s.dewpoint_f,
                s.will_it_rain,
                s.chance_of_rain,
                s.will_it_snow,
                s.chance_of_snow,
                s.vis_km,
                s.vis_miles,
                s.gust_mph,
                s.gust_kph,
                s.uv);
    EXCEPTION WHEN OTHERS THEN 
        GET STACKED DIAGNOSTICS v_message = message_text,
                                v_sqlstate = returned_sqlstate;

        INSERT INTO public.ErrorLog(tablename, errornumber, errormessage)
        VALUES('HourlyForecast', v_sqlstate, v_message);

END;

$$
