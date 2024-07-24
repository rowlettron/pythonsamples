CREATE OR REPLACE PROCEDURE public.insert_daily_forecast() --Do not remove parentheses
LANGUAGE plpgsql
AS
$$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.insert_daily_forecast();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE v_message TEXT;
        v_sqlstate TEXT;
BEGIN
    DROP TABLE IF EXISTS _daily_forecast;

    CREATE TEMP TABLE _daily_forecast AS 
    SELECT l.locationid,
           CAST(arr.item_object ->> 'date' AS timestamp) AS forecast_date,
           CAST(arr.item_object ->> 'date_epoch' AS int8) AS forecast_date_epoch,
           CAST(arr.item_object -> 'day' ->> 'maxtemp_c' AS float8) AS maxtemp_c,
           CAST(arr.item_object -> 'day' ->> 'maxtemp_f' AS float8) AS maxtemp_f,
           CAST(arr.item_object -> 'day' ->> 'mintemp_c' AS float8) AS mintemp_c,
           CAST(arr.item_object -> 'day' ->> 'mintemp_f'AS float8) AS mintemp_f,
           CAST(arr.item_object -> 'day' ->> 'avgtemp_c'AS float8) AS avgtemp_c,
           CAST(arr.item_object -> 'day' ->> 'avgtemp_f'AS float8) AS avgtemp_f,
           CAST(arr.item_object -> 'day' ->> 'maxwind_mph'AS float8) AS maxwind_mph,
           CAST(arr.item_object -> 'day' ->> 'maxwind_kph'AS float8) AS maxwind_kph,
           CAST(arr.item_object -> 'day' ->> 'totalprecip_mm'AS float8) AS totalprecip_mm,
           CAST(arr.item_object -> 'day' ->> 'totalprecip_in'AS float8) AS totalprecip_in,
           CAST(arr.item_object -> 'day' ->> 'totalsnow_cm'AS float8) AS totalsnow_cm,
           CAST(arr.item_object -> 'day' ->> 'avgvis_miles'AS float8) AS avgvis_miles,
           CAST(arr.item_object -> 'day' ->> 'avgvis_km'AS float8) AS avgvis_km,
           CAST(arr.item_object -> 'day' ->> 'avghumidity'AS float8) AS avghumidity,
           CAST(arr.item_object -> 'day' ->> 'daily_will_it_rain' AS bit) AS daily_will_it_rain,
           CAST(arr.item_object -> 'day' ->> 'daily_chance_of_rain'AS float8) AS daily_chance_of_rain,
           CAST(arr.item_object -> 'day' ->> 'daily_will_it_snow' AS bit) AS daily_will_it_snow,
           CAST(arr.item_object -> 'day' ->> 'daily_chance_of_snow'AS float8) AS daily_chance_of_snow,
           arr.item_object -> 'day' -> 'condition' ->> 'text' AS daily_conditions,
           CAST(arr.item_object -> 'day' ->> 'uv'AS float8) AS daily_uv,
           position
    FROM public.weatherjsonload wjl
    CROSS JOIN jsonb_array_elements(jsondata -> 'forecast' -> 'forecastday') WITH ordinality arr(item_object, position)
    INNER JOIN public.location l ON wjl.jsondata -> 'location' ->> 'name' = l."name"
	WHERE wjl.Processed = 0; 

    MERGE INTO public.dailyforecast AS t 

    USING _daily_forecast AS s 
    ON s.locationid = t.locationid 
    AND s.forecast_date_epoch = t.forecast_date_epoch

    WHEN MATCHED THEN 
    UPDATE SET maxtemp_c = s.maxtemp_c,
               maxtemp_f = s.maxtemp_f,
               mintemp_c = s.mintemp_c,
               mintemp_f = s.mintemp_f,
               avgtemp_c = s.avgtemp_c,
               avgtemp_f = s.avgtemp_f,
               maxwind_mph = s.maxwind_mph,
               maxwind_kph = s.maxwind_kph,
               totalprecip_mm = s.totalprecip_mm,
               totalprecip_in = s.totalprecip_in,
               totalsnow_cm = s.totalsnow_cm,
               avgvis_km = s.avgvis_km,
               avgvis_miles = s.avgvis_miles,
               avghumidity = s.avghumidity,
               daily_will_it_rain = s.daily_will_it_rain,
               daily_chance_of_rain = s.daily_chance_of_rain,
               daily_will_it_snow = s.daily_will_it_snow,
               daily_chance_of_snow = s.daily_chance_of_snow,
               conditions = s.daily_conditions,
               uv = s.daily_uv 

    WHEN NOT MATCHED THEN 
    INSERT (locationid,
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
            uv)
    VALUES (s.locationid,
            s.forecast_date,
            s.forecast_date_epoch,
            s.maxtemp_c,
            s.maxtemp_f,
            s.mintemp_c,
            s.mintemp_f,
            s.avgtemp_c,
            s.avgtemp_f,
            s.maxwind_mph,
            s.maxwind_kph,
            s.totalprecip_mm,
            s.totalprecip_in,
            s.totalsnow_cm,
            s.avgvis_km,
            s.avgvis_miles,
            s.avghumidity,
            s.daily_will_it_rain,
            s.daily_chance_of_rain,
            s.daily_will_it_snow,
            s.daily_chance_of_snow,
            s.daily_conditions,
            s.daily_uv);

        EXCEPTION WHEN OTHERS THEN 
        GET STACKED DIAGNOSTICS v_message = message_text,
                                v_sqlstate = returned_sqlstate;

        INSERT INTO public.ErrorLog(tablename, errornumber, errormessage)
        VALUES('DailyForecast', v_sqlstate, v_message);

END;

$$
