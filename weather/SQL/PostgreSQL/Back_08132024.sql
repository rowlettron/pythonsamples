toc.dat                                                                                             0000600 0004000 0002000 00000126377 14656737537 0014506 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP   #                    |        
   Weather_v2    16.1 (Debian 16.1-1.pgdg120+1)    16.3 .    _           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         `           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         a           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         b           1262    16389 
   Weather_v2    DATABASE     w   CREATE DATABASE "Weather_v2" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE "Weather_v2";
                python    false         �            1255    25131    copy_payload_to_table() 	   PROCEDURE     �  CREATE PROCEDURE public.copy_payload_to_table()
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.copy_payload_to_table();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/

BEGIN
    COPY public.weatherjsonload (jsondata) FROM '/datashare/file.txt';
END;

$$;
 /   DROP PROCEDURE public.copy_payload_to_table();
       public          python    false                    1255    16616    insert_current_conditions() 	   PROCEDURE     A  CREATE PROCEDURE public.insert_current_conditions()
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
 *  Object Type:	    Stored Procedure
 *  Function:        
 *  Created By:      
 *  Create Date:     
 *  Maintenance Log:
 *  Execution:       call public.insert_current_conditions();  --Do not remove parentheses
 *
 *  Date          Modified By             Description
 *  ----------    --------------------    ---------------------------------------------------------
 **************************************************************************************************/
DECLARE v_message TEXT;
        v_sqlstate TEXT;
        _countofrows int;
BEGIN
    DROP TABLE IF EXISTS _current_conditions;

    CREATE TEMP TABLE _current_conditions AS 
    SELECT l.locationid,
           CAST(jsondata -> 'current' ->> 'last_updated_epoch' AS int8) AS last_updated_epoch,
           CAST(jsondata -> 'current' ->> 'last_updated' AS timestamp) AS last_updated,
           CAST(jsondata -> 'current' ->> 'temp_c' AS float8) AS temp_c,
           CAST(jsondata -> 'current' ->> 'temp_f' AS float8) AS temp_f,
           CAST(jsondata -> 'current' ->> 'is_day' AS bit) AS isday,
           jsondata -> 'current' -> 'condition' ->> 'text' AS current_condition,
           CAST(jsondata -> 'current' ->> 'wind_mph' AS float8) AS wind_mph,
           CAST(jsondata -> 'current' ->> 'wind_kph' AS float8) AS wind_kph,
           CAST(jsondata -> 'current' ->> 'wind_degree' AS float8) AS wind_degree,
           jsondata -> 'current' ->> 'wind_dir' AS wind_direction,
           CAST(jsondata -> 'current' ->> 'pressure_mb' AS float8) AS pressure_mb,
           CAST(jsondata -> 'current' ->> 'pressure_in' AS float8) AS pressure_in,
           CAST(jsondata -> 'current' ->> 'precip_mm' AS float8) AS precip_mm,
           CAST(jsondata -> 'current' ->> 'precip_in' AS float8) AS precip_in,
           CAST(jsondata -> 'current' ->> 'humidity' AS float8) AS humidity,
           CAST(jsondata -> 'current' ->> 'cloud' AS float8) AS cloud,
           CAST(jsondata -> 'current' ->> 'feelslike_c' AS float8) AS feelslike_c,
           CAST(jsondata -> 'current' ->> 'feelslike_f' AS float8) AS feelslike_f,
           CAST(jsondata -> 'current' ->> 'windchill_c' AS float8) AS windchill_c,
           CAST(jsondata -> 'current' ->> 'windchill_f' AS float8) AS windchill_f,
           CAST(jsondata -> 'current' ->> 'heatindex_c' AS float8) AS heatindex_c,
           CAST(jsondata -> 'current' ->> 'heatindex_f' AS float8) AS heatindex_f,
           CAST(jsondata -> 'current' ->> 'dewpoint_c' AS float8) AS dewpoint_c,
           CAST(jsondata -> 'current' ->> 'dewpoint_f' AS float8) AS dewpoint_f,
           CAST(jsondata -> 'current' ->> 'vis_km' AS float8) AS vis_km,
           CAST(jsondata -> 'current' ->> 'vis_miles' AS float8) AS vis_miles,
           CAST(jsondata -> 'current' ->> 'uv' AS float8) AS uv,
           CAST(jsondata -> 'current' ->> 'gust_mph' AS float8) AS gust_mph,
           CAST(jsondata -> 'current' ->> 'gust_kph' AS float8) AS gust_kph 
    FROM weatherjsonload wjl
    INNER JOIN public.location l ON jsondata -> 'location' ->> 'name' = l."name"
    WHERE wjl.processed = 0;

    GET DIAGNOSTICS _countofrows = ROW_COUNT;
	RAISE NOTICE 'Temp table count: %', _countofrows;

	
    MERGE INTO public.currentconditions AS t 

    USING _current_conditions AS s 
    ON s.locationid = t.locationid 
    AND s.last_updated_epoch = t.last_updated_epoch

    WHEN MATCHED THEN
    UPDATE SET temp_c = s.temp_c,
               temp_f = s.temp_f,
               isday = s.isday, 
               current_conditions = s.current_condition,
               wind_mph = s.wind_mph,
               wind_kph = s.wind_kph,
               wind_degree = s.wind_degree,
               wind_direction = s.wind_direction,
               pressure_mb = s.pressure_mb,
               pressure_in = s.pressure_in,
               precip_mm = s.precip_mm,
               precip_in = s.precip_in,
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
               vis_km = s.vis_km,
               vis_miles = s.vis_miles,
               uv = s.uv,
               gust_mph = s.gust_mph,
               gust_kph = s.gust_kph

    WHEN NOT MATCHED THEN 
    INSERT (locationid,
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
            gust_kph)
    VALUES (s.locationid,
            s.last_updated_epoch,
            s.last_updated,
            s.temp_c,
            s.temp_f,
            s.isday,
            s.current_condition,
            s.wind_mph,
            s.wind_kph,
            s.wind_degree,
            s.wind_direction,
            s.pressure_mb,
            s.pressure_in,
			s.precip_mm,
			s.precip_in, 
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
            s.vis_km,
            s.vis_miles,
            s.uv,
            s.gust_mph,
            s.gust_kph
            );

    EXCEPTION WHEN OTHERS THEN 
        GET STACKED DIAGNOSTICS v_message = message_text,
                                v_sqlstate = returned_sqlstate;

        INSERT INTO public.ErrorLog(tablename, errornumber, errormessage)
        VALUES('CurrentConditions', v_sqlstate, v_message);

END;

$$;
 3   DROP PROCEDURE public.insert_current_conditions();
       public          python    false         �            1255    16674    insert_daily_forecast() 	   PROCEDURE     7  CREATE PROCEDURE public.insert_daily_forecast()
    LANGUAGE plpgsql
    AS $$
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

$$;
 /   DROP PROCEDURE public.insert_daily_forecast();
       public          python    false                    1255    16799    insert_hourlyforecast() 	   PROCEDURE     �  CREATE PROCEDURE public.insert_hourlyforecast()
    LANGUAGE plpgsql
    AS $$
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

$$;
 /   DROP PROCEDURE public.insert_hourlyforecast();
       public          python    false         �            1255    16444    insert_location() 	   PROCEDURE     �  CREATE PROCEDURE public.insert_location()
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.insert_location();
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/

BEGIN
    MERGE INTO public.location t

    USING (SELECT DISTINCT jsondata -> 'location' ->> 'name' AS name,
                    jsondata -> 'location' ->> 'region' AS Region,
                    jsondata -> 'location' ->> 'country' AS Country,
                    cast(jsondata -> 'location' ->> 'lat' AS numeric(9,2)) AS Latitude,
                    cast(jsondata -> 'location' ->> 'lon' AS numeric(9,2)) AS Longitude,
                    jsondata -> 'location' ->> 'tz_id' AS TimeZone,
                    cast(jsondata -> 'location' ->> 'localtime_epoch' AS int) AS LocalTime_Epoch,
                    cast(jsondata -> 'location' ->> 'localtime' AS timestamp) AS local_time
            from weatherjsonload
            where processed = 0) AS s

    ON s.name = t.name
    AND s.region = t.region
    --AND s.localtime = t.local_time

    WHEN MATCHED THEN
    UPDATE SET 
                name = s.name,
                region = s.region,
                country = s.country, 
                latitude = s.latitude,
                longitude = s.longitude,
                timezone = s.timezone,
                localtime_epoch = s.localtime_epoch,
                local_time = s.local_time

    WHEN NOT MATCHED THEN
    INSERT (name, region, country, latitude, longitude, timezone, localtime_epoch, local_time)
    VALUES (s.name, s.region, s.country, s.latitude, s.longitude, s.timezone, s.localtime_epoch, s.local_time)
    ;
	
	UPDATE public.weatherjsonload
	SET processed = 1,
	   processed_date = now()
    WHERE processed = 0;

    RAISE NOTICE 'Finished procedure insert_location';
	
	DELETE FROM public.location
	WHERE name IS NULL;
	    
END;

$$;
 )   DROP PROCEDURE public.insert_location();
       public          python    false                     1255    25142 "   insert_location(character varying) 	   PROCEDURE     
  CREATE PROCEDURE public.insert_location(IN inpostalcode character varying)
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.insert_location();
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE v_message TEXT;
        v_sqlstate TEXT;
BEGIN
    MERGE INTO public.location t

    USING (SELECT DISTINCT jsondata -> 'location' ->> 'name' AS name,
                    jsondata -> 'location' ->> 'region' AS Region,
                    jsondata -> 'location' ->> 'country' AS Country,
                    cast(jsondata -> 'location' ->> 'lat' AS numeric(9,2)) AS Latitude,
                    cast(jsondata -> 'location' ->> 'lon' AS numeric(9,2)) AS Longitude,
                    jsondata -> 'location' ->> 'tz_id' AS TimeZone,
                    cast(jsondata -> 'location' ->> 'localtime_epoch' AS int) AS LocalTime_Epoch,
                    cast(jsondata -> 'location' ->> 'localtime' AS timestamp) AS local_time
            from weatherjsonload
            where processed = 0) AS s

    ON s.name = t.name
    AND s.region = t.region
    --AND s.localtime = t.local_time

    WHEN MATCHED THEN
    UPDATE SET 
	            postalcode = inPostalcode, 
                name = s.name,
                region = s.region,
                country = s.country, 
                latitude = s.latitude,
                longitude = s.longitude,
                timezone = s.timezone,
                local_time_epoch = s.localtime_epoch,
                local_time = s.local_time

    WHEN NOT MATCHED THEN
    INSERT (postalcode, name, region, country, latitude, longitude, timezone, local_time_epoch, local_time)
    VALUES (inPostalCode, s.name, s.region, s.country, s.latitude, s.longitude, s.timezone, s.localtime_epoch, s.local_time);
    EXCEPTION WHEN OTHERS THEN 
        GET STACKED DIAGNOSTICS v_message = message_text,
                                v_sqlstate = returned_sqlstate;

        INSERT INTO public.ErrorLog(tablename, errornumber, errormessage)
        VALUES('Location', v_sqlstate, v_message);
	
    RAISE NOTICE 'Finished procedure insert_location';
	
	DELETE FROM public.location
	WHERE name IS NULL;
	    
END;

$$;
 J   DROP PROCEDURE public.insert_location(IN inpostalcode character varying);
       public          python    false         �            1255    25090    insert_weatherjsonload(jsonb) 	   PROCEDURE     �  CREATE PROCEDURE public.insert_weatherjsonload(IN in_wj jsonb)
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.<proc name>();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE wj jsonb;
BEGIN

    wj := in_wj;

	INSERT INTO public.weatherjsonload(jsondata)
	VALUES (wj);
END;

$$;
 >   DROP PROCEDURE public.insert_weatherjsonload(IN in_wj jsonb);
       public          python    false         �            1255    25122    insert_weatherjsonload(text) 	   PROCEDURE     �  CREATE PROCEDURE public.insert_weatherjsonload(IN in_wj text)
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.<proc name>();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE wj jsonb;
BEGIN

    wj := in_wj;

	INSERT INTO public.weatherjsonload(jsondata)
	VALUES (wj);

END;

$$;
 =   DROP PROCEDURE public.insert_weatherjsonload(IN in_wj text);
       public          python    false         �            1255    25132    update_json_to_processed() 	   PROCEDURE     �  CREATE PROCEDURE public.update_json_to_processed()
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.update_json_to_processed();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/

BEGIN
	UPDATE public.weatherjsonload
	SET processed = 1,
	   processed_date = now()
    WHERE processed = 0;
END;

$$;
 2   DROP PROCEDURE public.update_json_to_processed();
       public          python    false         �            1259    25461    currentconditions    TABLE     �  CREATE TABLE public.currentconditions (
    currentconditionid bigint NOT NULL,
    locationid bigint,
    last_updated_epoch bigint,
    last_updated timestamp without time zone,
    temp_c numeric(6,2),
    temp_f numeric(6,2),
    isday bit(1),
    current_conditions character varying(50),
    wind_mph numeric(6,2),
    wind_kph numeric(6,2),
    wind_degree numeric(6,2),
    wind_direction character varying(255),
    pressure_mb numeric(6,2),
    pressure_in numeric(6,2),
    precip_mm numeric(6,2),
    precip_in numeric(6,2),
    humidity numeric(6,2),
    cloud numeric(6,2),
    feelslike_c numeric(6,2),
    feelslike_f numeric(6,2),
    windchill_c numeric(6,2),
    windchill_f numeric(6,2),
    heatindex_c numeric(6,2),
    heatindex_f numeric(6,2),
    dewpoint_c numeric(6,2),
    dewpoint_f numeric(6,2),
    vis_km numeric(6,2),
    vis_miles numeric(6,2),
    uv numeric(6,2),
    gust_mph numeric(6,2),
    gust_kph numeric(6,2)
);
 %   DROP TABLE public.currentconditions;
       public         heap    python    false         �            1259    25460 (   currentconditions_currentconditionid_seq    SEQUENCE     �   ALTER TABLE public.currentconditions ALTER COLUMN currentconditionid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.currentconditions_currentconditionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          python    false    234         �            1259    25468    dailyforecast    TABLE       CREATE TABLE public.dailyforecast (
    dailyforecastid integer NOT NULL,
    locationid bigint,
    forecast_date timestamp without time zone,
    forecast_date_epoch bigint,
    maxtemp_c numeric(6,2),
    maxtemp_f numeric(6,2),
    mintemp_c numeric(6,2),
    mintemp_f numeric(6,2),
    avgtemp_c numeric(6,2),
    avgtemp_f numeric(6,2),
    maxwind_mph numeric(6,2),
    maxwind_kph numeric(6,2),
    totalprecip_mm numeric(6,2),
    totalprecip_in numeric(6,2),
    totalsnow_cm numeric(6,2),
    avgvis_km numeric(6,2),
    avgvis_miles numeric(6,2),
    avghumidity numeric(6,2),
    daily_will_it_rain bit(1),
    daily_chance_of_rain numeric(6,2),
    daily_will_it_snow bit(1),
    daily_chance_of_snow numeric(6,2),
    conditions character varying(50),
    uv numeric(6,2)
);
 !   DROP TABLE public.dailyforecast;
       public         heap    python    false         �            1259    25467 !   dailyforecast_dailyforecastid_seq    SEQUENCE     �   ALTER TABLE public.dailyforecast ALTER COLUMN dailyforecastid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dailyforecast_dailyforecastid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          python    false    236         �            1259    25574    errorlog    TABLE     �   CREATE TABLE public.errorlog (
    errorlogid integer NOT NULL,
    logdate timestamp without time zone DEFAULT now(),
    tablename character varying(30),
    errornumber integer,
    errormessage character varying(500)
);
    DROP TABLE public.errorlog;
       public         heap    python    false         �            1259    25573    errorlog_errorlogid_seq    SEQUENCE     �   ALTER TABLE public.errorlog ALTER COLUMN errorlogid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.errorlog_errorlogid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          python    false    238         �            1259    25455    hourlyforecast    TABLE     r  CREATE TABLE public.hourlyforecast (
    hourlyforecastid integer NOT NULL,
    locationid bigint,
    forecast_date timestamp without time zone,
    forecast_hour timestamp without time zone,
    forecast_time_epoch bigint,
    temp_c numeric(6,2),
    temp_f numeric(6,2),
    is_day bit(1),
    forecast_condition character varying(50),
    wind_mph numeric(6,2),
    wind_kph numeric(6,2),
    wind_degree numeric(6,2),
    wind_dir character varying(255),
    pressure_mb numeric(6,2),
    pressure_in numeric(6,2),
    precip_mm numeric(6,2),
    precip_in numeric(6,2),
    snow_cm numeric(6,2),
    humidity numeric(6,2),
    cloud numeric(6,2),
    feelslike_c numeric(6,2),
    feelslike_f numeric(6,2),
    windchill_c numeric(6,2),
    windchill_f numeric(6,2),
    heatindex_c numeric(6,2),
    heatindex_f numeric(6,2),
    dewpoint_c numeric(6,2),
    dewpoint_f numeric(6,2),
    will_it_rain bit(1),
    chance_of_rain numeric(6,2),
    will_it_snow bit(1),
    chance_of_snow numeric(6,2),
    vis_km numeric(6,2),
    vis_miles numeric(6,2),
    gust_mph numeric(6,2),
    gust_kph numeric(6,2),
    uv numeric(6,2)
);
 "   DROP TABLE public.hourlyforecast;
       public         heap    python    false         �            1259    25454 #   hourlyforecast_hourlyforecastid_seq    SEQUENCE     �   ALTER TABLE public.hourlyforecast ALTER COLUMN hourlyforecastid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.hourlyforecast_hourlyforecastid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          python    false    232         �            1259    25449    location    TABLE     r  CREATE TABLE public.location (
    locationid integer NOT NULL,
    postalcode character varying(25),
    name character varying(50),
    region character varying(50),
    country character varying(50),
    latitude numeric(6,2),
    longitude numeric(6,2),
    timezone character varying(50),
    local_time_epoch integer,
    local_time timestamp without time zone
);
    DROP TABLE public.location;
       public         heap    python    false         �            1259    25448    location_locationid_seq    SEQUENCE     �   ALTER TABLE public.location ALTER COLUMN locationid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.location_locationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          python    false    230         �            1259    16445    weatherjsonload    TABLE     �   CREATE TABLE public.weatherjsonload (
    wjl_id integer NOT NULL,
    jsondata jsonb,
    createdate timestamp without time zone DEFAULT now(),
    processed smallint DEFAULT 0,
    processed_date timestamp without time zone
);
 #   DROP TABLE public.weatherjsonload;
       public         heap    python    false         �            1259    16452    weatherjsonload_wjl_id_seq    SEQUENCE     �   CREATE SEQUENCE public.weatherjsonload_wjl_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.weatherjsonload_wjl_id_seq;
       public          python    false    227         c           0    0    weatherjsonload_wjl_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.weatherjsonload_wjl_id_seq OWNED BY public.weatherjsonload.wjl_id;
          public          python    false    228         �           2604    16453    weatherjsonload wjl_id    DEFAULT     �   ALTER TABLE ONLY public.weatherjsonload ALTER COLUMN wjl_id SET DEFAULT nextval('public.weatherjsonload_wjl_id_seq'::regclass);
 E   ALTER TABLE public.weatherjsonload ALTER COLUMN wjl_id DROP DEFAULT;
       public          python    false    228    227         X          0    25461    currentconditions 
   TABLE DATA           �  COPY public.currentconditions (currentconditionid, locationid, last_updated_epoch, last_updated, temp_c, temp_f, isday, current_conditions, wind_mph, wind_kph, wind_degree, wind_direction, pressure_mb, pressure_in, precip_mm, precip_in, humidity, cloud, feelslike_c, feelslike_f, windchill_c, windchill_f, heatindex_c, heatindex_f, dewpoint_c, dewpoint_f, vis_km, vis_miles, uv, gust_mph, gust_kph) FROM stdin;
    public          python    false    234       3416.dat Z          0    25468    dailyforecast 
   TABLE DATA           |  COPY public.dailyforecast (dailyforecastid, locationid, forecast_date, forecast_date_epoch, maxtemp_c, maxtemp_f, mintemp_c, mintemp_f, avgtemp_c, avgtemp_f, maxwind_mph, maxwind_kph, totalprecip_mm, totalprecip_in, totalsnow_cm, avgvis_km, avgvis_miles, avghumidity, daily_will_it_rain, daily_chance_of_rain, daily_will_it_snow, daily_chance_of_snow, conditions, uv) FROM stdin;
    public          python    false    236       3418.dat \          0    25574    errorlog 
   TABLE DATA           ]   COPY public.errorlog (errorlogid, logdate, tablename, errornumber, errormessage) FROM stdin;
    public          python    false    238       3420.dat V          0    25455    hourlyforecast 
   TABLE DATA           �  COPY public.hourlyforecast (hourlyforecastid, locationid, forecast_date, forecast_hour, forecast_time_epoch, temp_c, temp_f, is_day, forecast_condition, wind_mph, wind_kph, wind_degree, wind_dir, pressure_mb, pressure_in, precip_mm, precip_in, snow_cm, humidity, cloud, feelslike_c, feelslike_f, windchill_c, windchill_f, heatindex_c, heatindex_f, dewpoint_c, dewpoint_f, will_it_rain, chance_of_rain, will_it_snow, chance_of_snow, vis_km, vis_miles, gust_mph, gust_kph, uv) FROM stdin;
    public          python    false    232       3414.dat T          0    25449    location 
   TABLE DATA           �   COPY public.location (locationid, postalcode, name, region, country, latitude, longitude, timezone, local_time_epoch, local_time) FROM stdin;
    public          python    false    230       3412.dat Q          0    16445    weatherjsonload 
   TABLE DATA           b   COPY public.weatherjsonload (wjl_id, jsondata, createdate, processed, processed_date) FROM stdin;
    public          python    false    227       3409.dat d           0    0 (   currentconditions_currentconditionid_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.currentconditions_currentconditionid_seq', 3, true);
          public          python    false    233         e           0    0 !   dailyforecast_dailyforecastid_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.dailyforecast_dailyforecastid_seq', 3, true);
          public          python    false    235         f           0    0    errorlog_errorlogid_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.errorlog_errorlogid_seq', 1, false);
          public          python    false    237         g           0    0 #   hourlyforecast_hourlyforecastid_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public.hourlyforecast_hourlyforecastid_seq', 864, true);
          public          python    false    231         h           0    0    location_locationid_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.location_locationid_seq', 2, true);
          public          python    false    229         i           0    0    weatherjsonload_wjl_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.weatherjsonload_wjl_id_seq', 7, true);
          public          python    false    228         �           2606    25465 (   currentconditions currentconditions_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.currentconditions
    ADD CONSTRAINT currentconditions_pkey PRIMARY KEY (currentconditionid);
 R   ALTER TABLE ONLY public.currentconditions DROP CONSTRAINT currentconditions_pkey;
       public            python    false    234         �           2606    25472     dailyforecast dailyforecast_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.dailyforecast
    ADD CONSTRAINT dailyforecast_pkey PRIMARY KEY (dailyforecastid);
 J   ALTER TABLE ONLY public.dailyforecast DROP CONSTRAINT dailyforecast_pkey;
       public            python    false    236         �           2606    25459 "   hourlyforecast hourlyforecast_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.hourlyforecast
    ADD CONSTRAINT hourlyforecast_pkey PRIMARY KEY (hourlyforecastid);
 L   ALTER TABLE ONLY public.hourlyforecast DROP CONSTRAINT hourlyforecast_pkey;
       public            python    false    232         �           2606    25453    location location_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (locationid);
 @   ALTER TABLE ONLY public.location DROP CONSTRAINT location_pkey;
       public            python    false    230         �           2606    25580    errorlog pk_errorlog 
   CONSTRAINT     Z   ALTER TABLE ONLY public.errorlog
    ADD CONSTRAINT pk_errorlog PRIMARY KEY (errorlogid);
 >   ALTER TABLE ONLY public.errorlog DROP CONSTRAINT pk_errorlog;
       public            python    false    238         �           2606    16456 $   weatherjsonload weatherjsonload_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.weatherjsonload
    ADD CONSTRAINT weatherjsonload_pkey PRIMARY KEY (wjl_id);
 N   ALTER TABLE ONLY public.weatherjsonload DROP CONSTRAINT weatherjsonload_pkey;
       public            python    false    227         �           1259    25581    ix_errorlog_logdate    INDEX     K   CREATE INDEX ix_errorlog_logdate ON public.errorlog USING btree (logdate);
 '   DROP INDEX public.ix_errorlog_logdate;
       public            python    false    238                                                                                                                                                                                                                                                                         3416.dat                                                                                            0000600 0004000 0002000 00000001115 14656737537 0014274 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	1721394900	2024-07-19 08:15:00	22.40	72.30	1	Sunny	2.20	3.60	10.00	N	1020.00	30.11	0.00	0.00	96.00	0.00	24.70	76.50	23.00	73.40	24.80	76.60	18.90	65.90	16.00	9.00	6.00	11.80	18.90
2	2	1721761200	2024-07-23 14:00:00	29.80	85.70	1	Patchy rain nearby	2.50	4.00	196.00	SSW	1016.00	30.00	0.06	0.00	48.00	76.00	31.20	88.10	29.80	85.70	31.20	88.10	18.10	64.50	10.00	6.00	7.00	2.80	4.60
3	1	1721920500	2024-07-25 10:15:00	27.40	81.30	1	Patchy rain nearby	8.70	14.00	71.00	ENE	1019.00	30.10	0.03	0.00	67.00	71.00	29.70	85.40	27.40	81.30	29.70	85.40	20.80	69.50	10.00	6.00	6.00	10.00	16.20
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                   3418.dat                                                                                            0000600 0004000 0002000 00000000721 14656737537 0014300 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	2024-07-25 00:00:00	1721865600	31.90	89.50	22.30	72.10	26.60	79.80	13.20	21.20	1.44	0.06	0.00	9.50	5.00	72.00	1	94.00	0	0.00	Patchy rain nearby	8.00
2	1	2024-07-26 00:00:00	1721952000	30.10	86.20	20.60	69.20	24.40	75.90	13.00	20.90	0.95	0.04	0.00	7.30	4.00	80.00	1	84.00	0	0.00	Patchy rain nearby	1.00
3	1	2024-07-27 00:00:00	1722038400	28.40	83.20	20.40	68.60	24.00	75.10	13.00	20.90	0.38	0.01	0.00	8.30	5.00	81.00	1	86.00	0	0.00	Patchy rain nearby	11.00
\.


                                               3420.dat                                                                                            0000600 0004000 0002000 00000000005 14656737537 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3414.dat                                                                                            0000600 0004000 0002000 00000100763 14656737537 0014303 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        793	1	2024-07-25 00:00:00	2024-07-25 00:00:00	1721883600	24.50	76.10	0	Clear 	6.30	10.10	92.00	E	1018.00	30.07	\N	\N	0.00	79.00	13.00	26.50	79.70	24.50	76.10	26.50	79.70	20.60	69.10	0	0.00	0	0.00	10.00	6.00	12.70	20.40	0.00
794	1	2024-07-25 00:00:00	2024-07-25 01:00:00	1721887200	24.00	75.10	0	Clear 	6.00	9.70	93.00	E	1018.00	30.06	\N	\N	0.00	82.00	14.00	26.00	78.80	24.00	75.10	26.00	78.80	20.70	69.30	0	0.00	0	0.00	10.00	6.00	12.00	19.40	0.00
795	1	2024-07-25 00:00:00	2024-07-25 02:00:00	1721890800	23.50	74.30	0	Clear 	5.60	9.00	89.00	E	1018.00	30.06	\N	\N	0.00	85.00	16.00	25.60	78.10	23.50	74.30	25.60	78.10	20.80	69.50	0	0.00	0	0.00	10.00	6.00	10.90	17.50	0.00
796	1	2024-07-25 00:00:00	2024-07-25 03:00:00	1721894400	23.10	73.60	0	Clear 	4.50	7.20	89.00	E	1018.00	30.06	\N	\N	0.00	87.00	16.00	25.30	77.60	23.10	73.60	25.30	77.60	20.90	69.50	0	0.00	0	0.00	10.00	6.00	8.50	13.80	0.00
797	1	2024-07-25 00:00:00	2024-07-25 04:00:00	1721898000	22.80	73.00	0	Clear 	3.80	6.10	95.00	E	1018.00	30.07	\N	\N	0.00	89.00	20.00	25.00	77.10	22.80	73.00	25.00	77.10	20.80	69.40	0	0.00	0	0.00	10.00	6.00	7.20	11.60	0.00
798	1	2024-07-25 00:00:00	2024-07-25 05:00:00	1721901600	22.50	72.60	0	Partly Cloudy 	3.60	5.80	90.00	E	1018.00	30.07	\N	\N	0.00	90.00	26.00	24.90	76.80	22.50	72.60	24.90	76.80	20.60	69.10	0	0.00	0	0.00	10.00	6.00	6.80	11.00	0.00
799	1	2024-07-25 00:00:00	2024-07-25 06:00:00	1721905200	22.40	72.40	0	Partly Cloudy 	3.80	6.10	75.00	ENE	1018.00	30.07	\N	\N	0.00	90.00	28.00	24.80	76.60	22.40	72.40	24.80	76.60	20.60	69.10	0	0.00	0	0.00	10.00	6.00	7.20	11.50	0.00
800	1	2024-07-25 00:00:00	2024-07-25 07:00:00	1721908800	23.20	73.70	1	Sunny	5.10	8.30	63.00	ENE	1019.00	30.08	\N	\N	0.00	90.00	15.00	25.40	77.70	23.20	73.70	25.40	77.70	20.60	69.10	0	0.00	0	0.00	10.00	6.00	9.30	14.90	6.00
801	1	2024-07-25 00:00:00	2024-07-25 08:00:00	1721912400	24.50	76.10	1	Sunny	5.80	9.40	69.00	ENE	1019.00	30.10	\N	\N	0.00	83.00	17.00	26.60	79.90	24.50	76.10	26.60	79.90	20.90	69.50	0	0.00	0	0.00	10.00	6.00	8.20	13.20	6.00
802	1	2024-07-25 00:00:00	2024-07-25 09:00:00	1721916000	26.00	78.80	1	Partly Cloudy 	7.40	11.90	72.00	ENE	1020.00	30.11	\N	\N	0.00	75.00	41.00	28.20	82.70	26.00	78.80	28.20	82.70	20.90	69.70	0	0.00	0	0.00	10.00	6.00	8.90	14.30	7.00
803	1	2024-07-25 00:00:00	2024-07-25 10:00:00	1721919600	27.40	81.30	1	Patchy rain nearby	8.70	14.00	71.00	ENE	1019.00	30.10	\N	\N	0.00	67.00	71.00	29.70	85.40	27.40	81.30	29.70	85.40	20.80	69.50	0	64.00	0	0.00	10.00	6.00	10.00	16.20	6.00
804	1	2024-07-25 00:00:00	2024-07-25 11:00:00	1721923200	28.80	83.90	1	Partly Cloudy 	9.60	15.50	66.00	ENE	1019.00	30.10	\N	\N	0.00	61.00	41.00	31.20	88.10	28.80	83.90	31.20	88.10	20.60	69.00	0	0.00	0	0.00	10.00	6.00	11.10	17.80	7.00
805	1	2024-07-25 00:00:00	2024-07-25 12:00:00	1721926800	30.00	86.10	1	Patchy rain nearby	10.10	16.20	75.00	ENE	1019.00	30.09	\N	\N	0.00	55.00	78.00	32.40	90.40	30.00	86.10	32.40	90.40	20.20	68.40	1	100.00	0	0.00	10.00	6.00	11.60	18.60	7.00
806	1	2024-07-25 00:00:00	2024-07-25 13:00:00	1721930400	31.00	87.80	1	Patchy light drizzle	10.50	16.90	84.00	E	1018.00	30.07	\N	\N	0.00	51.00	73.00	33.40	92.20	31.00	87.80	33.40	92.20	19.90	67.70	1	100.00	0	0.00	5.00	3.00	12.10	19.50	7.00
807	1	2024-07-25 00:00:00	2024-07-25 14:00:00	1721934000	31.40	88.50	1	Patchy rain nearby	10.70	17.30	87.00	E	1017.00	30.05	\N	\N	0.00	48.00	87.00	33.80	92.90	31.40	88.50	33.80	92.90	19.70	67.50	1	100.00	0	0.00	10.00	6.00	12.30	19.90	7.00
808	1	2024-07-25 00:00:00	2024-07-25 15:00:00	1721937600	31.40	88.50	1	Partly Cloudy 	11.20	18.00	93.00	E	1017.00	30.03	\N	\N	0.00	49.00	36.00	33.80	92.80	31.40	88.50	33.80	92.80	19.70	67.40	0	0.00	0	0.00	10.00	6.00	12.90	20.70	8.00
809	1	2024-07-25 00:00:00	2024-07-25 16:00:00	1721941200	31.40	88.40	1	Patchy rain nearby	10.70	17.30	98.00	E	1016.00	30.01	\N	\N	0.00	50.00	87.00	33.80	92.80	31.40	88.40	33.80	92.80	19.60	67.30	1	100.00	0	0.00	10.00	6.00	12.70	20.40	7.00
810	1	2024-07-25 00:00:00	2024-07-25 17:00:00	1721944800	30.70	87.30	1	Partly Cloudy 	12.50	20.20	102.00	ESE	1016.00	30.00	\N	\N	0.00	51.00	32.00	33.20	91.70	30.70	87.30	33.20	91.70	19.80	67.70	0	0.00	0	0.00	10.00	6.00	14.60	23.50	8.00
811	1	2024-07-25 00:00:00	2024-07-25 18:00:00	1721948400	29.90	85.80	1	Partly Cloudy 	13.20	21.20	112.00	ESE	1016.00	29.99	\N	\N	0.00	56.00	37.00	32.40	90.40	29.90	85.80	32.40	90.40	20.40	68.80	0	0.00	0	0.00	10.00	6.00	16.20	26.00	8.00
812	1	2024-07-25 00:00:00	2024-07-25 19:00:00	1721952000	28.60	83.50	1	Partly Cloudy 	12.80	20.50	116.00	ESE	1016.00	29.99	\N	\N	0.00	61.00	44.00	31.10	88.00	28.60	83.50	31.10	88.00	20.90	69.70	0	0.00	0	0.00	10.00	6.00	16.30	26.20	7.00
813	1	2024-07-25 00:00:00	2024-07-25 20:00:00	1721955600	27.00	80.60	1	Partly Cloudy 	10.10	16.20	131.00	SE	1016.00	30.00	\N	\N	0.00	70.00	32.00	29.30	84.80	27.00	80.60	29.30	84.80	21.50	70.70	0	0.00	0	0.00	10.00	6.00	14.60	23.50	7.00
814	1	2024-07-25 00:00:00	2024-07-25 21:00:00	1721959200	25.60	78.20	0	Patchy light drizzle	7.60	12.20	126.00	SE	1016.00	30.01	\N	\N	0.00	79.00	58.00	27.90	82.20	25.60	78.20	27.90	82.20	21.50	70.80	1	100.00	0	0.00	5.00	3.00	13.00	20.90	0.00
815	1	2024-07-25 00:00:00	2024-07-25 22:00:00	1721962800	24.30	75.80	0	Patchy rain nearby	8.10	13.00	133.00	SE	1017.00	30.03	\N	\N	0.00	86.00	77.00	26.60	79.90	24.30	75.80	26.60	79.90	21.80	71.20	1	100.00	0	0.00	9.00	5.00	13.10	21.10	0.00
816	1	2024-07-25 00:00:00	2024-07-25 23:00:00	1721966400	23.20	73.80	0	Partly Cloudy 	9.20	14.80	148.00	SSE	1017.00	30.04	\N	\N	0.00	92.00	61.00	25.60	78.10	23.20	73.80	25.60	78.10	21.70	71.00	0	0.00	0	0.00	10.00	6.00	13.40	21.60	0.00
817	1	2024-07-26 00:00:00	2024-07-26 00:00:00	1721970000	22.40	72.30	0	Cloudy 	8.90	14.40	153.00	SSE	1017.00	30.04	\N	\N	0.00	94.00	71.00	25.00	76.90	22.40	72.30	25.00	76.90	21.10	69.90	0	0.00	0	0.00	10.00	6.00	13.00	20.80	0.00
818	1	2024-07-26 00:00:00	2024-07-26 01:00:00	1721973600	21.70	71.10	0	Mist	7.20	11.50	160.00	SSE	1017.00	30.04	\N	\N	0.00	95.00	63.00	21.70	71.10	21.70	71.10	24.60	76.20	20.70	69.20	0	0.00	0	0.00	2.00	1.00	11.00	17.70	0.00
819	1	2024-07-26 00:00:00	2024-07-26 02:00:00	1721977200	21.30	70.30	0	Mist	6.00	9.70	157.00	SSE	1017.00	30.04	\N	\N	0.00	96.00	69.00	21.30	70.30	21.30	70.30	22.70	72.90	20.40	68.80	0	0.00	0	0.00	2.00	1.00	9.50	15.30	0.00
820	1	2024-07-26 00:00:00	2024-07-26 03:00:00	1721980800	21.00	69.80	0	Mist	6.50	10.40	157.00	SSE	1017.00	30.03	\N	\N	0.00	97.00	79.00	21.00	69.80	21.00	69.80	21.70	71.00	20.30	68.50	0	0.00	0	0.00	2.00	1.00	10.10	16.30	0.00
821	1	2024-07-26 00:00:00	2024-07-26 04:00:00	1721984400	20.80	69.50	0	Mist	5.60	9.00	154.00	SSE	1017.00	30.02	\N	\N	0.00	97.00	86.00	20.80	69.50	20.80	69.50	21.20	70.10	20.10	68.20	0	0.00	0	0.00	2.00	1.00	8.90	14.30	0.00
822	1	2024-07-26 00:00:00	2024-07-26 05:00:00	1721988000	20.90	69.50	0	Mist	5.60	9.00	160.00	SSE	1017.00	30.02	\N	\N	0.00	97.00	95.00	20.80	69.50	20.80	69.50	21.00	69.80	20.10	68.20	0	0.00	0	0.00	2.00	1.00	8.80	14.20	0.00
823	1	2024-07-26 00:00:00	2024-07-26 06:00:00	1721991600	20.80	69.50	0	Mist	6.00	9.70	161.00	SSE	1017.00	30.03	\N	\N	0.00	95.00	94.00	20.80	69.50	20.80	69.50	20.90	69.60	20.10	68.20	0	0.00	0	0.00	2.00	1.00	9.30	14.90	0.00
824	1	2024-07-26 00:00:00	2024-07-26 07:00:00	1721995200	21.40	70.50	1	Mist	5.60	9.00	152.00	SSE	1017.00	30.04	\N	\N	0.00	95.00	93.00	21.40	70.50	21.40	70.50	22.70	72.90	20.00	68.00	0	0.00	0	0.00	2.00	1.00	8.60	13.80	5.00
825	1	2024-07-26 00:00:00	2024-07-26 08:00:00	1721998800	22.40	72.40	1	Cloudy 	5.10	8.30	161.00	SSE	1018.00	30.06	\N	\N	0.00	89.00	80.00	24.10	75.40	22.40	72.40	24.10	75.40	20.10	68.10	0	0.00	0	0.00	10.00	6.00	6.80	11.00	5.00
826	1	2024-07-26 00:00:00	2024-07-26 09:00:00	1722002400	23.70	74.70	1	Overcast 	4.70	7.60	154.00	SSE	1018.00	30.06	\N	\N	0.00	82.00	96.00	25.50	77.90	23.70	74.70	25.50	77.90	20.20	68.40	0	0.00	0	0.00	10.00	6.00	5.80	9.30	5.00
827	1	2024-07-26 00:00:00	2024-07-26 10:00:00	1722006000	25.00	77.00	1	Patchy rain nearby	5.10	8.30	138.00	SE	1018.00	30.05	\N	\N	0.00	75.00	100.00	26.80	80.30	25.00	77.00	26.80	80.30	20.40	68.70	1	84.00	0	0.00	10.00	6.00	6.00	9.60	6.00
828	1	2024-07-26 00:00:00	2024-07-26 11:00:00	1722009600	26.20	79.20	1	Patchy rain nearby	5.60	9.00	128.00	SE	1017.00	30.04	\N	\N	0.00	69.00	98.00	28.00	82.40	26.20	79.20	28.00	82.40	20.20	68.30	1	80.00	0	0.00	10.00	6.00	6.40	10.40	6.00
829	1	2024-07-26 00:00:00	2024-07-26 12:00:00	1722013200	27.00	80.60	1	Patchy rain nearby	6.70	10.80	138.00	SE	1017.00	30.04	\N	\N	0.00	64.00	95.00	28.80	83.90	27.00	80.60	28.80	83.90	20.00	68.00	0	67.00	0	0.00	10.00	6.00	7.70	12.40	6.00
830	1	2024-07-26 00:00:00	2024-07-26 13:00:00	1722016800	27.60	81.60	1	Patchy rain nearby	7.60	12.20	142.00	SE	1017.00	30.02	\N	\N	0.00	62.00	74.00	29.40	84.90	27.60	81.60	29.40	84.90	19.80	67.70	0	69.00	0	0.00	10.00	6.00	8.70	14.10	6.00
831	1	2024-07-26 00:00:00	2024-07-26 14:00:00	1722020400	28.40	83.10	1	Patchy rain nearby	7.60	12.20	133.00	SE	1016.00	30.00	\N	\N	0.00	60.00	67.00	30.30	86.50	28.40	83.10	30.30	86.50	19.70	67.50	1	79.00	0	0.00	10.00	6.00	8.70	14.10	6.00
832	1	2024-07-26 00:00:00	2024-07-26 15:00:00	1722024000	29.30	84.70	1	Patchy rain nearby	7.80	12.60	137.00	SE	1015.00	29.98	\N	\N	0.00	56.00	89.00	31.20	88.10	29.30	84.70	31.20	88.10	19.60	67.20	1	83.00	0	0.00	10.00	6.00	9.00	14.50	6.00
833	1	2024-07-26 00:00:00	2024-07-26 16:00:00	1722027600	29.20	84.60	1	Patchy rain nearby	8.30	13.30	119.00	ESE	1014.00	29.95	\N	\N	0.00	53.00	89.00	31.30	88.30	29.20	84.60	31.30	88.30	19.40	66.90	0	64.00	0	0.00	10.00	6.00	9.50	15.30	7.00
834	1	2024-07-26 00:00:00	2024-07-26 17:00:00	1722031200	28.20	82.80	1	Light drizzle	12.50	20.20	126.00	SE	1014.00	29.95	\N	\N	0.00	58.00	92.00	30.40	86.70	28.20	82.80	30.40	86.70	20.20	68.30	1	100.00	0	0.00	2.00	1.00	14.50	23.30	6.00
835	1	2024-07-26 00:00:00	2024-07-26 18:00:00	1722034800	27.30	81.10	1	Patchy rain nearby	13.00	20.90	135.00	SE	1014.00	29.94	\N	\N	0.00	69.00	76.00	29.40	85.00	27.30	81.10	29.40	85.00	21.00	69.70	1	100.00	0	0.00	10.00	6.00	17.20	27.60	6.00
836	1	2024-07-26 00:00:00	2024-07-26 19:00:00	1722038400	26.30	79.30	1	Patchy rain nearby	11.40	18.40	143.00	SE	1014.00	29.94	\N	\N	0.00	73.00	84.00	28.40	83.10	26.30	79.30	28.40	83.10	21.10	70.10	0	60.00	0	0.00	10.00	6.00	15.60	25.10	6.00
837	1	2024-07-26 00:00:00	2024-07-26 20:00:00	1722042000	25.10	77.20	1	Partly Cloudy 	11.00	17.60	141.00	SE	1014.00	29.96	\N	\N	0.00	78.00	32.00	27.20	80.90	25.10	77.20	27.20	80.90	21.20	70.20	0	0.00	0	0.00	10.00	6.00	15.90	25.50	7.00
838	1	2024-07-26 00:00:00	2024-07-26 21:00:00	1722045600	24.10	75.40	0	Clear 	10.50	16.90	141.00	SE	1015.00	29.96	\N	\N	0.00	83.00	18.00	26.20	79.20	24.10	75.40	26.20	79.20	20.90	69.60	0	0.00	0	0.00	10.00	6.00	16.40	26.40	0.00
839	1	2024-07-26 00:00:00	2024-07-26 22:00:00	1722049200	23.30	74.00	0	Clear 	10.10	16.20	143.00	SE	1015.00	29.98	\N	\N	0.00	85.00	16.00	25.50	78.00	23.30	74.00	25.50	78.00	20.60	69.00	0	0.00	0	0.00	10.00	6.00	15.50	25.00	0.00
840	1	2024-07-26 00:00:00	2024-07-26 23:00:00	1722052800	22.80	73.00	0	Clear 	9.40	15.10	146.00	SSE	1015.00	29.98	\N	\N	0.00	88.00	25.00	25.10	77.10	22.80	73.00	25.10	77.10	20.40	68.70	0	0.00	0	0.00	10.00	6.00	14.70	23.60	0.00
841	1	2024-07-27 00:00:00	2024-07-27 00:00:00	1722056400	22.30	72.10	0	Partly Cloudy 	8.90	14.40	142.00	SE	1015.00	29.98	\N	\N	0.00	89.00	34.00	24.70	76.50	22.30	72.10	24.70	76.50	20.30	68.50	0	0.00	0	0.00	10.00	6.00	13.80	22.20	0.00
842	1	2024-07-27 00:00:00	2024-07-27 01:00:00	1722060000	21.80	71.20	0	Partly Cloudy 	7.80	12.60	142.00	SE	1015.00	29.98	\N	\N	0.00	91.00	38.00	21.80	71.20	21.80	71.20	24.50	76.10	20.20	68.40	0	0.00	0	0.00	10.00	6.00	12.10	19.40	0.00
843	1	2024-07-27 00:00:00	2024-07-27 02:00:00	1722063600	21.30	70.30	0	Partly Cloudy 	6.00	9.70	135.00	SE	1015.00	29.97	\N	\N	0.00	93.00	40.00	21.30	70.30	21.30	70.30	22.60	72.70	20.10	68.10	0	0.00	0	0.00	10.00	6.00	9.80	15.70	0.00
844	1	2024-07-27 00:00:00	2024-07-27 03:00:00	1722067200	20.90	69.70	0	Mist	5.80	9.40	148.00	SSE	1015.00	29.97	\N	\N	0.00	95.00	46.00	20.90	69.70	20.90	69.70	21.60	70.90	19.90	67.80	0	0.00	0	0.00	2.00	1.00	9.70	15.70	0.00
845	1	2024-07-27 00:00:00	2024-07-27 04:00:00	1722070800	20.70	69.20	0	Mist	6.70	10.80	148.00	SSE	1015.00	29.96	\N	\N	0.00	95.00	49.00	20.70	69.20	20.70	69.20	21.00	69.80	19.80	67.60	0	0.00	0	0.00	2.00	1.00	11.20	18.00	0.00
846	1	2024-07-27 00:00:00	2024-07-27 05:00:00	1722074400	20.50	69.00	0	Mist	6.00	9.70	144.00	SE	1014.00	29.96	\N	\N	0.00	96.00	56.00	20.50	69.00	20.50	69.00	20.70	69.30	19.70	67.50	0	0.00	0	0.00	2.00	1.00	10.30	16.60	0.00
847	1	2024-07-27 00:00:00	2024-07-27 06:00:00	1722078000	20.60	69.10	0	Mist	6.00	9.70	143.00	SE	1015.00	29.97	\N	\N	0.00	96.00	67.00	20.60	69.10	20.60	69.10	20.70	69.20	19.80	67.70	0	0.00	0	0.00	2.00	1.00	10.00	16.20	0.00
848	1	2024-07-27 00:00:00	2024-07-27 07:00:00	1722081600	21.20	70.10	1	Mist	5.80	9.40	137.00	SE	1015.00	29.98	\N	\N	0.00	96.00	71.00	21.20	70.10	21.20	70.10	22.50	72.60	19.90	67.80	0	0.00	0	0.00	2.00	1.00	9.40	15.10	5.00
849	1	2024-07-27 00:00:00	2024-07-27 08:00:00	1722085200	22.10	71.80	1	Cloudy 	6.70	10.80	144.00	SE	1016.00	29.99	\N	\N	0.00	91.00	69.00	23.90	75.00	22.10	71.80	23.90	75.00	20.20	68.30	0	0.00	0	0.00	10.00	6.00	9.30	14.90	5.00
850	1	2024-07-27 00:00:00	2024-07-27 09:00:00	1722088800	23.10	73.50	1	Overcast 	8.10	13.00	148.00	SSE	1016.00	30.00	\N	\N	0.00	85.00	100.00	25.00	76.90	23.10	73.50	25.00	76.90	20.50	68.90	0	0.00	0	0.00	10.00	6.00	9.90	16.00	5.00
851	1	2024-07-27 00:00:00	2024-07-27 10:00:00	1722092400	23.70	74.70	1	Patchy rain nearby	9.60	15.50	157.00	SSE	1016.00	30.01	\N	\N	0.00	82.00	100.00	25.70	78.30	23.70	74.70	25.70	78.30	20.80	69.50	1	86.00	0	0.00	10.00	6.00	11.40	18.30	5.00
852	1	2024-07-27 00:00:00	2024-07-27 11:00:00	1722096000	24.10	75.40	1	Patchy rain nearby	10.10	16.20	160.00	SSE	1016.00	30.00	\N	\N	0.00	82.00	100.00	26.10	79.00	24.10	75.40	26.10	79.00	21.20	70.10	1	100.00	0	0.00	10.00	6.00	12.10	19.50	5.00
853	1	2024-07-27 00:00:00	2024-07-27 12:00:00	1722099600	24.80	76.70	1	Patchy rain nearby	10.70	17.30	165.00	SSE	1016.00	30.00	\N	\N	0.00	82.00	100.00	26.90	80.30	24.80	76.70	26.90	80.30	21.20	70.10	1	100.00	0	0.00	10.00	6.00	13.40	21.60	5.00
854	1	2024-07-27 00:00:00	2024-07-27 13:00:00	1722103200	26.30	79.30	1	Patchy rain nearby	10.70	17.30	170.00	S	1015.00	29.99	\N	\N	0.00	76.00	94.00	28.40	83.10	26.30	79.30	28.40	83.10	21.10	69.90	1	100.00	0	0.00	10.00	6.00	13.00	21.00	6.00
855	1	2024-07-27 00:00:00	2024-07-27 14:00:00	1722106800	27.00	80.70	1	Patchy rain nearby	11.40	18.40	185.00	S	1015.00	29.96	\N	\N	0.00	65.00	100.00	29.10	84.30	27.00	80.70	29.10	84.30	20.60	69.20	1	100.00	0	0.00	10.00	6.00	13.10	21.10	6.00
856	1	2024-07-27 00:00:00	2024-07-27 15:00:00	1722110400	27.40	81.40	1	Patchy rain nearby	13.00	20.90	193.00	SSW	1014.00	29.95	\N	\N	0.00	63.00	80.00	29.40	84.90	27.40	81.40	29.40	84.90	20.20	68.30	1	76.00	0	0.00	10.00	6.00	15.10	24.40	6.00
857	1	2024-07-27 00:00:00	2024-07-27 16:00:00	1722114000	27.80	82.10	1	Patchy rain nearby	13.00	20.90	195.00	SSW	1014.00	29.94	\N	\N	0.00	62.00	80.00	29.70	85.50	27.80	82.10	29.70	85.50	19.80	67.70	1	82.00	0	0.00	10.00	6.00	15.80	25.40	6.00
858	1	2024-07-27 00:00:00	2024-07-27 17:00:00	1722117600	28.10	82.60	1	Patchy rain nearby	11.60	18.70	198.00	SSW	1013.00	29.93	\N	\N	0.00	60.00	81.00	29.90	85.90	28.10	82.60	29.90	85.90	19.70	67.40	1	78.00	0	0.00	10.00	6.00	14.00	22.50	6.00
859	1	2024-07-27 00:00:00	2024-07-27 18:00:00	1722121200	27.70	81.80	1	Sunny	11.20	18.00	197.00	SSW	1013.00	29.92	\N	\N	0.00	58.00	21.00	29.40	85.00	27.70	81.80	29.40	85.00	19.50	67.00	0	0.00	0	0.00	10.00	6.00	13.80	22.20	7.00
860	1	2024-07-27 00:00:00	2024-07-27 19:00:00	1722124800	26.70	80.10	1	Sunny	9.60	15.50	175.00	S	1013.00	29.92	\N	\N	0.00	64.00	13.00	28.50	83.30	26.70	80.10	28.50	83.30	19.80	67.60	0	0.00	0	0.00	10.00	6.00	13.90	22.40	7.00
861	1	2024-07-27 00:00:00	2024-07-27 20:00:00	1722128400	25.50	77.90	1	Sunny	12.50	20.20	155.00	SSE	1013.00	29.93	\N	\N	0.00	71.00	12.00	27.30	81.10	25.50	77.90	27.30	81.10	20.20	68.40	0	0.00	0	0.00	10.00	6.00	18.80	30.20	7.00
862	1	2024-07-27 00:00:00	2024-07-27 21:00:00	1722132000	24.50	76.00	0	Clear 	11.60	18.70	164.00	SSE	1014.00	29.93	\N	\N	0.00	77.00	6.00	26.40	79.50	24.50	76.10	26.40	79.50	20.00	68.00	0	0.00	0	0.00	10.00	6.00	20.00	32.20	0.00
863	1	2024-07-27 00:00:00	2024-07-27 22:00:00	1722135600	23.60	74.50	0	Clear 	11.00	17.60	167.00	SSE	1014.00	29.95	\N	\N	0.00	81.00	5.00	25.70	78.20	23.60	74.50	25.70	78.20	19.90	67.90	0	0.00	0	0.00	10.00	6.00	19.50	31.40	0.00
721	2	2024-07-23 00:00:00	2024-07-23 00:00:00	1721710800	19.90	67.90	0	Mist	2.20	3.60	63.00	ENE	1015.00	29.98	0.00	0.00	0.00	94.00	12.00	19.90	67.90	19.90	67.90	20.00	68.00	18.90	66.00	0	0.00	0	0.00	2.00	1.00	4.70	7.60	0.00
722	2	2024-07-23 00:00:00	2024-07-23 01:00:00	1721714400	19.70	67.40	0	Mist	2.20	3.60	56.00	ENE	1015.00	29.98	0.00	0.00	0.00	95.00	19.00	19.70	67.40	19.70	67.40	19.70	67.50	18.90	65.90	0	0.00	0	0.00	2.00	1.00	4.70	7.60	0.00
723	2	2024-07-23 00:00:00	2024-07-23 02:00:00	1721718000	19.50	67.00	0	Mist	2.50	4.00	39.00	NE	1015.00	29.98	0.00	0.00	0.00	96.00	9.00	19.50	67.00	19.50	67.00	19.50	67.10	18.70	65.70	0	0.00	0	0.00	2.00	1.00	5.10	8.20	0.00
724	2	2024-07-23 00:00:00	2024-07-23 03:00:00	1721721600	19.30	66.70	0	Mist	1.60	2.50	37.00	NE	1015.00	29.97	0.00	0.00	0.00	96.00	11.00	19.30	66.70	19.30	66.70	19.30	66.70	18.50	65.40	0	0.00	0	0.00	2.00	1.00	3.20	5.20	0.00
725	2	2024-07-23 00:00:00	2024-07-23 04:00:00	1721725200	19.10	66.30	0	Mist	1.30	2.20	54.00	NE	1015.00	29.99	0.00	0.00	0.00	96.00	14.00	19.10	66.30	19.10	66.30	19.10	66.30	18.40	65.00	0	0.00	0	0.00	2.00	1.00	2.80	4.40	0.00
726	2	2024-07-23 00:00:00	2024-07-23 05:00:00	1721728800	18.80	65.90	0	Mist	1.30	2.20	75.00	ENE	1016.00	29.99	0.00	0.00	0.00	96.00	20.00	18.80	65.90	18.80	65.90	18.90	65.90	18.20	64.80	0	0.00	0	0.00	2.00	1.00	2.70	4.40	0.00
727	2	2024-07-23 00:00:00	2024-07-23 06:00:00	1721732400	19.00	66.10	0	Mist	1.80	2.90	88.00	E	1016.00	30.00	0.00	0.00	0.00	97.00	25.00	19.00	66.10	19.00	66.10	19.00	66.10	18.10	64.50	0	0.00	0	0.00	2.00	1.00	3.60	5.70	0.00
728	2	2024-07-23 00:00:00	2024-07-23 07:00:00	1721736000	19.90	67.80	1	Mist	0.90	1.40	64.00	ENE	1017.00	30.02	0.00	0.00	0.00	96.00	32.00	19.90	67.80	19.90	67.80	19.90	67.80	18.50	65.30	0	0.00	0	0.00	2.00	1.00	1.60	2.60	4.00
729	2	2024-07-23 00:00:00	2024-07-23 08:00:00	1721739600	21.30	70.40	1	Partly Cloudy 	0.70	1.10	52.00	NE	1017.00	30.04	0.00	0.00	0.00	93.00	33.00	21.30	70.40	21.30	70.40	22.40	72.40	19.60	67.20	0	0.00	0	0.00	10.00	6.00	1.00	1.50	6.00
730	2	2024-07-23 00:00:00	2024-07-23 09:00:00	1721743200	22.90	73.20	1	Patchy rain nearby	1.60	2.50	117.00	ESE	1018.00	30.05	0.06	0.00	0.00	86.00	72.00	24.40	75.90	22.90	73.20	24.40	75.90	20.30	68.50	1	100.00	0	0.00	10.00	6.00	1.80	2.90	5.00
731	2	2024-07-23 00:00:00	2024-07-23 10:00:00	1721746800	24.70	76.40	1	Patchy rain nearby	2.50	4.00	156.00	SSE	1018.00	30.05	0.68	0.03	0.00	79.00	82.00	26.50	79.70	24.70	76.40	26.50	79.70	20.60	69.00	1	100.00	0	0.00	9.00	5.00	2.90	4.70	5.00
732	2	2024-07-23 00:00:00	2024-07-23 11:00:00	1721750400	26.50	79.60	1	Patchy rain nearby	1.60	2.50	184.00	S	1017.00	30.04	0.39	0.02	0.00	73.00	89.00	28.50	83.30	26.50	79.60	28.50	83.30	21.10	70.00	1	100.00	0	0.00	9.00	5.00	2.10	3.30	6.00
733	2	2024-07-23 00:00:00	2024-07-23 12:00:00	1721754000	27.90	82.30	1	Patchy rain nearby	0.70	1.10	332.00	NNW	1017.00	30.03	0.18	0.01	0.00	63.00	71.00	29.80	85.70	27.90	82.30	29.80	85.70	20.60	69.10	1	100.00	0	0.00	9.00	5.00	0.90	1.50	6.00
734	2	2024-07-23 00:00:00	2024-07-23 13:00:00	1721757600	29.10	84.40	1	Patchy rain nearby	1.30	2.20	154.00	SSE	1017.00	30.02	0.04	0.00	0.00	54.00	52.00	30.80	87.40	29.10	84.40	30.80	87.40	19.20	66.60	1	82.00	0	0.00	10.00	6.00	1.90	3.00	6.00
735	2	2024-07-23 00:00:00	2024-07-23 14:00:00	1721761200	29.80	85.70	1	Patchy rain nearby	2.50	4.00	196.00	SSW	1016.00	30.00	0.06	0.00	0.00	48.00	76.00	31.20	88.10	29.80	85.70	31.20	88.10	18.10	64.50	1	100.00	0	0.00	10.00	6.00	2.80	4.60	7.00
736	2	2024-07-23 00:00:00	2024-07-23 15:00:00	1721764800	29.80	85.70	1	Patchy rain nearby	2.20	3.60	229.00	SW	1016.00	29.99	0.02	0.00	0.00	45.00	65.00	31.00	87.70	29.80	85.70	31.00	87.70	17.40	63.30	0	61.00	0	0.00	10.00	6.00	2.60	4.10	7.00
737	2	2024-07-23 00:00:00	2024-07-23 16:00:00	1721768400	29.10	84.30	1	Patchy rain nearby	2.00	3.20	299.00	WNW	1015.00	29.98	0.01	0.00	0.00	47.00	79.00	30.20	86.40	29.10	84.30	30.20	86.40	17.20	63.00	1	74.00	0	0.00	10.00	6.00	2.70	4.40	6.00
738	2	2024-07-23 00:00:00	2024-07-23 17:00:00	1721772000	28.30	82.90	1	Patchy rain nearby	2.70	4.30	331.00	NNW	1015.00	29.98	0.01	0.00	0.00	53.00	74.00	29.50	85.00	28.20	82.80	29.50	85.00	18.00	64.30	1	80.00	0	0.00	10.00	6.00	4.40	7.10	6.00
739	2	2024-07-23 00:00:00	2024-07-23 18:00:00	1721775600	27.40	81.30	1	Sunny	1.30	2.20	21.00	NNE	1015.00	29.97	0.00	0.00	0.00	58.00	24.00	28.70	83.70	27.40	81.30	28.70	83.70	18.40	65.10	0	0.00	0	0.00	10.00	6.00	2.40	3.90	7.00
740	2	2024-07-23 00:00:00	2024-07-23 19:00:00	1721779200	26.30	79.30	1	Sunny	1.60	2.50	80.00	E	1015.00	29.98	0.00	0.00	0.00	63.00	19.00	27.70	81.80	26.30	79.30	27.70	81.80	19.00	66.10	0	0.00	0	0.00	10.00	6.00	3.10	4.90	7.00
741	2	2024-07-23 00:00:00	2024-07-23 20:00:00	1721782800	24.90	76.90	1	Sunny	2.50	4.00	100.00	E	1015.00	29.98	0.00	0.00	0.00	67.00	16.00	26.50	79.70	24.90	76.90	26.50	79.70	18.60	65.50	0	0.00	0	0.00	10.00	6.00	5.20	8.30	7.00
742	2	2024-07-23 00:00:00	2024-07-23 21:00:00	1721786400	24.00	75.30	0	Clear 	2.90	4.70	82.00	E	1016.00	30.00	0.00	0.00	0.00	70.00	17.00	25.80	78.50	24.00	75.30	25.80	78.50	17.80	64.10	0	0.00	0	0.00	10.00	6.00	6.10	9.80	0.00
743	2	2024-07-23 00:00:00	2024-07-23 22:00:00	1721790000	23.40	74.20	0	Clear 	3.40	5.40	54.00	NE	1017.00	30.03	0.00	0.00	0.00	74.00	19.00	25.40	77.70	23.40	74.20	25.40	77.70	18.30	65.00	0	0.00	0	0.00	10.00	6.00	7.00	11.30	0.00
744	2	2024-07-23 00:00:00	2024-07-23 23:00:00	1721793600	22.80	73.10	0	Clear 	3.10	5.00	54.00	NE	1017.00	30.04	0.00	0.00	0.00	77.00	18.00	25.00	77.00	22.80	73.10	25.00	77.00	18.60	65.60	0	0.00	0	0.00	10.00	6.00	6.60	10.60	0.00
745	2	2024-07-24 00:00:00	2024-07-24 00:00:00	1721797200	22.30	72.20	0	Clear 	3.10	5.00	61.00	ENE	1017.00	30.05	0.00	0.00	0.00	80.00	16.00	24.70	76.50	22.30	72.20	24.70	76.50	18.70	65.70	0	0.00	0	0.00	10.00	6.00	6.50	10.50	0.00
746	2	2024-07-24 00:00:00	2024-07-24 01:00:00	1721800800	21.80	71.30	0	Clear 	2.90	4.70	78.00	ENE	1017.00	30.05	0.00	0.00	0.00	83.00	16.00	21.80	71.30	21.80	71.30	24.50	76.10	18.70	65.70	0	0.00	0	0.00	10.00	6.00	5.90	9.40	0.00
747	2	2024-07-24 00:00:00	2024-07-24 02:00:00	1721804400	21.40	70.50	0	Clear 	2.70	4.30	86.00	E	1017.00	30.04	0.00	0.00	0.00	86.00	18.00	21.40	70.50	21.40	70.50	24.30	75.80	18.80	65.90	0	0.00	0	0.00	10.00	6.00	5.20	8.40	0.00
748	2	2024-07-24 00:00:00	2024-07-24 03:00:00	1721808000	21.30	70.40	0	Clear 	2.70	4.30	79.00	E	1017.00	30.05	0.00	0.00	0.00	88.00	18.00	21.30	70.40	21.30	70.40	24.30	75.70	18.90	66.10	0	0.00	0	0.00	10.00	6.00	5.10	8.20	0.00
749	2	2024-07-24 00:00:00	2024-07-24 04:00:00	1721811600	21.30	70.40	0	Partly Cloudy 	2.50	4.00	78.00	ENE	1018.00	30.05	0.00	0.00	0.00	87.00	26.00	21.40	70.40	21.40	70.40	24.30	75.70	19.00	66.20	0	0.00	0	0.00	10.00	6.00	4.30	7.00	0.00
750	2	2024-07-24 00:00:00	2024-07-24 05:00:00	1721815200	21.30	70.40	0	Partly Cloudy 	2.00	3.20	82.00	E	1018.00	30.05	0.00	0.00	0.00	87.00	33.00	21.30	70.40	21.30	70.40	24.30	75.70	19.10	66.30	0	0.00	0	0.00	10.00	6.00	3.40	5.40	0.00
751	2	2024-07-24 00:00:00	2024-07-24 06:00:00	1721818800	21.50	70.60	0	Partly Cloudy 	1.60	2.50	88.00	E	1018.00	30.06	0.00	0.00	0.00	87.00	36.00	21.50	70.60	21.50	70.60	24.30	75.70	19.10	66.30	0	0.00	0	0.00	10.00	6.00	2.60	4.20	0.00
752	2	2024-07-24 00:00:00	2024-07-24 07:00:00	1721822400	22.10	71.70	1	Partly Cloudy 	0.90	1.40	60.00	ENE	1019.00	30.08	0.00	0.00	0.00	87.00	37.00	24.60	76.20	22.10	71.70	24.60	76.20	19.30	66.70	0	0.00	0	0.00	10.00	6.00	1.40	2.30	6.00
753	2	2024-07-24 00:00:00	2024-07-24 08:00:00	1721826000	23.30	73.90	1	Partly Cloudy 	0.90	1.40	49.00	NE	1020.00	30.11	0.00	0.00	0.00	83.00	29.00	25.40	77.80	23.30	73.90	25.40	77.80	19.60	67.30	0	0.00	0	0.00	10.00	6.00	1.20	2.00	6.00
754	2	2024-07-24 00:00:00	2024-07-24 09:00:00	1721829600	24.80	76.60	1	Sunny	0.20	0.40	134.00	SE	1020.00	30.11	0.00	0.00	0.00	76.00	20.00	26.70	80.10	24.80	76.60	26.70	80.10	19.90	67.80	0	0.00	0	0.00	10.00	6.00	0.30	0.40	6.00
755	2	2024-07-24 00:00:00	2024-07-24 10:00:00	1721833200	26.60	79.90	1	Sunny	1.60	2.50	194.00	SSW	1020.00	30.11	0.00	0.00	0.00	70.00	9.00	28.70	83.70	26.60	79.90	28.70	83.70	20.20	68.40	0	0.00	0	0.00	10.00	6.00	1.80	2.90	7.00
756	2	2024-07-24 00:00:00	2024-07-24 11:00:00	1721836800	28.50	83.20	1	Sunny	2.00	3.20	210.00	SSW	1019.00	30.10	0.00	0.00	0.00	62.00	16.00	30.60	87.10	28.50	83.20	30.60	87.10	20.50	68.80	0	0.00	0	0.00	10.00	6.00	2.30	3.70	7.00
757	2	2024-07-24 00:00:00	2024-07-24 12:00:00	1721840400	29.90	85.80	1	Sunny	1.80	2.90	201.00	SSW	1019.00	30.09	0.00	0.00	0.00	53.00	11.00	31.70	89.10	29.90	85.80	31.70	89.10	19.70	67.40	0	0.00	0	0.00	10.00	6.00	2.10	3.30	8.00
758	2	2024-07-24 00:00:00	2024-07-24 13:00:00	1721844000	31.10	87.90	1	Sunny	2.00	3.20	170.00	S	1018.00	30.07	0.00	0.00	0.00	46.00	22.00	32.50	90.50	31.10	87.90	32.50	90.50	18.20	64.80	0	0.00	0	0.00	10.00	6.00	2.30	3.70	8.00
759	2	2024-07-24 00:00:00	2024-07-24 14:00:00	1721847600	31.90	89.50	1	Partly Cloudy 	4.00	6.50	169.00	S	1018.00	30.05	0.00	0.00	0.00	40.00	28.00	33.00	91.40	31.90	89.50	33.00	91.40	17.00	62.60	0	0.00	0	0.00	10.00	6.00	4.60	7.50	8.00
760	2	2024-07-24 00:00:00	2024-07-24 15:00:00	1721851200	32.00	89.50	1	Sunny	5.10	8.30	165.00	SSE	1017.00	30.03	0.00	0.00	0.00	37.00	22.00	32.80	91.00	32.00	89.50	32.80	91.00	16.10	60.90	0	0.00	0	0.00	10.00	6.00	5.90	9.50	8.00
761	2	2024-07-24 00:00:00	2024-07-24 16:00:00	1721854800	30.90	87.60	1	Sunny	4.70	7.60	152.00	SSE	1017.00	30.02	0.00	0.00	0.00	39.00	21.00	31.80	89.20	30.90	87.60	31.80	89.20	16.10	61.00	0	0.00	0	0.00	10.00	6.00	6.50	10.50	8.00
762	2	2024-07-24 00:00:00	2024-07-24 17:00:00	1721858400	29.30	84.70	1	Partly Cloudy 	2.90	4.70	109.00	ESE	1017.00	30.02	0.00	0.00	0.00	47.00	30.00	30.30	86.60	29.30	84.70	30.30	86.60	17.40	63.20	0	0.00	0	0.00	10.00	6.00	5.20	8.30	7.00
763	2	2024-07-24 00:00:00	2024-07-24 18:00:00	1721862000	28.10	82.50	1	Partly Cloudy 	2.70	4.30	73.00	ENE	1017.00	30.03	0.00	0.00	0.00	56.00	46.00	29.20	84.60	28.10	82.50	29.20	84.60	18.00	64.40	0	0.00	0	0.00	10.00	6.00	5.60	9.10	7.00
764	2	2024-07-24 00:00:00	2024-07-24 19:00:00	1721865600	27.10	80.80	1	Partly Cloudy 	1.80	2.90	81.00	E	1017.00	30.03	0.00	0.00	0.00	59.00	43.00	28.30	82.90	27.10	80.80	28.30	82.90	18.30	64.90	0	0.00	0	0.00	10.00	6.00	3.80	6.00	7.00
765	2	2024-07-24 00:00:00	2024-07-24 20:00:00	1721869200	25.80	78.40	1	Sunny	2.50	4.00	93.00	E	1017.00	30.03	0.00	0.00	0.00	61.00	11.00	27.10	80.80	25.80	78.40	27.10	80.80	18.00	64.40	0	0.00	0	0.00	10.00	6.00	5.20	8.30	7.00
766	2	2024-07-24 00:00:00	2024-07-24 21:00:00	1721872800	24.40	76.00	0	Clear 	3.60	5.80	81.00	E	1017.00	30.05	0.00	0.00	0.00	66.00	9.00	26.10	79.00	24.40	76.00	26.10	79.00	17.80	64.00	0	0.00	0	0.00	10.00	6.00	7.50	12.10	0.00
767	2	2024-07-24 00:00:00	2024-07-24 22:00:00	1721876400	24.10	75.30	0	Clear 	3.40	5.40	72.00	ENE	1018.00	30.06	0.00	0.00	0.00	73.00	9.00	25.80	78.50	24.10	75.30	25.80	78.50	17.90	64.20	0	0.00	0	0.00	10.00	6.00	7.00	11.30	0.00
768	2	2024-07-24 00:00:00	2024-07-24 23:00:00	1721880000	23.60	74.50	0	Clear 	3.40	5.40	76.00	ENE	1018.00	30.07	0.00	0.00	0.00	75.00	11.00	25.50	77.90	23.60	74.50	25.50	77.90	19.00	66.30	0	0.00	0	0.00	10.00	6.00	7.00	11.30	0.00
769	2	2024-07-25 00:00:00	2024-07-25 00:00:00	1721883600	22.80	73.10	0	Clear 	3.60	5.80	83.00	E	1018.00	30.07	0.00	0.00	0.00	79.00	13.00	25.00	77.00	22.80	73.10	25.00	77.00	19.40	66.90	0	0.00	0	0.00	10.00	6.00	7.30	11.70	0.00
770	2	2024-07-25 00:00:00	2024-07-25 01:00:00	1721887200	22.20	71.90	0	Clear 	3.40	5.40	78.00	ENE	1018.00	30.07	0.00	0.00	0.00	86.00	13.00	24.70	76.40	22.20	71.90	24.70	76.40	19.60	67.30	0	0.00	0	0.00	10.00	6.00	7.00	11.30	0.00
771	2	2024-07-25 00:00:00	2024-07-25 02:00:00	1721890800	21.60	70.80	0	Clear 	3.60	5.80	89.00	E	1018.00	30.07	0.00	0.00	0.00	90.00	12.00	21.60	70.80	21.60	70.80	22.80	73.10	19.80	67.60	0	0.00	0	0.00	10.00	6.00	7.50	12.10	0.00
772	2	2024-07-25 00:00:00	2024-07-25 03:00:00	1721894400	21.10	69.90	0	Clear 	3.10	5.00	98.00	E	1018.00	30.07	0.00	0.00	0.00	93.00	13.00	21.10	69.90	21.10	69.90	21.70	71.00	19.80	67.70	0	0.00	0	0.00	10.00	6.00	6.40	10.30	0.00
773	2	2024-07-25 00:00:00	2024-07-25 04:00:00	1721898000	20.70	69.20	0	Mist	2.70	4.30	74.00	ENE	1019.00	30.08	0.00	0.00	0.00	95.00	9.00	20.70	69.20	20.70	69.20	21.00	69.80	19.70	67.50	0	0.00	0	0.00	2.00	1.00	5.50	8.80	0.00
774	2	2024-07-25 00:00:00	2024-07-25 05:00:00	1721901600	20.40	68.80	0	Mist	2.50	4.00	57.00	ENE	1019.00	30.09	0.00	0.00	0.00	96.00	14.00	20.40	68.80	20.40	68.80	20.60	69.10	19.70	67.40	0	0.00	0	0.00	2.00	1.00	5.00	8.10	0.00
775	2	2024-07-25 00:00:00	2024-07-25 06:00:00	1721905200	20.60	69.20	0	Mist	2.70	4.30	43.00	NE	1019.00	30.09	0.00	0.00	0.00	96.00	16.00	20.60	69.20	20.60	69.20	20.70	69.30	19.60	67.30	0	0.00	0	0.00	2.00	1.00	5.40	8.70	0.00
776	2	2024-07-25 00:00:00	2024-07-25 07:00:00	1721908800	21.90	71.50	1	Mist	2.00	3.20	76.00	ENE	1020.00	30.11	0.00	0.00	0.00	94.00	19.00	21.90	71.50	21.90	71.50	23.00	73.40	19.90	67.70	0	0.00	0	0.00	2.00	1.00	3.60	5.90	5.00
777	2	2024-07-25 00:00:00	2024-07-25 08:00:00	1721912400	23.80	74.80	1	Sunny	2.00	3.20	84.00	E	1020.00	30.12	0.00	0.00	0.00	84.00	18.00	25.30	77.50	23.80	74.80	25.30	77.50	20.40	68.70	0	0.00	0	0.00	10.00	6.00	2.50	4.10	6.00
778	2	2024-07-25 00:00:00	2024-07-25 09:00:00	1721916000	25.90	78.60	1	Sunny	2.00	3.20	102.00	ESE	1020.00	30.12	0.00	0.00	0.00	74.00	20.00	27.70	81.90	25.90	78.60	27.70	81.90	20.60	69.00	0	0.00	0	0.00	10.00	6.00	2.30	3.70	7.00
779	2	2024-07-25 00:00:00	2024-07-25 10:00:00	1721919600	27.90	82.20	1	Sunny	2.70	4.30	111.00	ESE	1020.00	30.12	0.00	0.00	0.00	64.00	17.00	30.00	86.00	27.90	82.20	30.00	86.00	20.60	69.10	0	0.00	0	0.00	10.00	6.00	3.10	5.00	7.00
780	2	2024-07-25 00:00:00	2024-07-25 11:00:00	1721923200	29.10	84.50	1	Sunny	3.80	6.10	111.00	ESE	1020.00	30.11	0.00	0.00	0.00	56.00	21.00	31.10	87.90	29.10	84.50	31.10	87.90	20.30	68.60	0	0.00	0	0.00	10.00	6.00	4.40	7.10	7.00
781	2	2024-07-25 00:00:00	2024-07-25 12:00:00	1721926800	30.40	86.70	1	Patchy rain nearby	5.40	8.60	111.00	ESE	1019.00	30.10	0.02	0.00	0.00	50.00	88.00	32.10	89.70	30.40	86.70	32.10	89.70	18.80	65.90	1	86.00	0	0.00	10.00	6.00	6.20	9.90	7.00
782	2	2024-07-25 00:00:00	2024-07-25 13:00:00	1721930400	31.30	88.40	1	Patchy rain nearby	6.30	10.10	113.00	ESE	1019.00	30.09	0.01	0.00	0.00	44.00	52.00	32.80	91.00	31.30	88.40	32.80	91.00	18.00	64.50	0	64.00	0	0.00	10.00	6.00	7.20	11.60	7.00
783	2	2024-07-25 00:00:00	2024-07-25 14:00:00	1721934000	31.70	89.00	1	Patchy rain nearby	7.60	12.20	118.00	ESE	1018.00	30.07	0.01	0.00	0.00	41.00	83.00	33.00	91.50	31.70	89.00	33.00	91.50	17.30	63.10	0	69.00	0	0.00	10.00	6.00	8.80	14.10	7.00
784	2	2024-07-25 00:00:00	2024-07-25 15:00:00	1721937600	31.20	88.20	1	Partly Cloudy 	8.70	14.00	122.00	ESE	1018.00	30.05	0.00	0.00	0.00	42.00	44.00	32.60	90.60	31.20	88.20	32.60	90.60	17.50	63.40	0	0.00	0	0.00	10.00	6.00	11.00	17.70	8.00
785	2	2024-07-25 00:00:00	2024-07-25 16:00:00	1721941200	30.20	86.30	1	Patchy rain nearby	8.10	13.00	122.00	ESE	1018.00	30.05	0.01	0.00	0.00	47.00	70.00	31.60	88.90	30.20	86.30	31.60	88.90	18.00	64.40	1	85.00	0	0.00	10.00	6.00	11.80	19.00	7.00
786	2	2024-07-25 00:00:00	2024-07-25 17:00:00	1721944800	29.30	84.80	1	Patchy rain nearby	5.60	9.00	120.00	ESE	1018.00	30.05	0.05	0.00	0.00	53.00	72.00	30.90	87.60	29.40	84.80	30.90	87.60	18.70	65.70	1	84.00	0	0.00	10.00	6.00	9.60	15.40	6.00
787	2	2024-07-25 00:00:00	2024-07-25 18:00:00	1721948400	28.50	83.30	1	Partly Cloudy 	5.60	9.00	135.00	SE	1017.00	30.03	0.00	0.00	0.00	57.00	40.00	30.20	86.30	28.50	83.30	30.20	86.30	19.20	66.60	0	0.00	0	0.00	10.00	6.00	9.90	15.90	7.00
788	2	2024-07-25 00:00:00	2024-07-25 19:00:00	1721952000	26.90	80.50	1	Partly Cloudy 	8.10	13.00	143.00	SE	1017.00	30.04	0.00	0.00	0.00	63.00	46.00	28.70	83.60	26.90	80.50	28.70	83.60	19.90	67.80	0	0.00	0	0.00	10.00	6.00	13.80	22.20	7.00
789	2	2024-07-25 00:00:00	2024-07-25 20:00:00	1721955600	25.30	77.50	1	Sunny	6.70	10.80	138.00	SE	1017.00	30.04	0.00	0.00	0.00	72.00	13.00	27.10	80.80	25.30	77.50	27.10	80.80	20.00	68.10	0	0.00	0	0.00	10.00	6.00	12.40	20.00	7.00
790	2	2024-07-25 00:00:00	2024-07-25 21:00:00	1721959200	24.00	75.10	0	Clear 	5.40	8.60	134.00	SE	1018.00	30.06	0.00	0.00	0.00	79.00	9.00	26.00	78.80	24.00	75.10	26.00	78.80	19.80	67.70	0	0.00	0	0.00	10.00	6.00	10.60	17.00	0.00
791	2	2024-07-25 00:00:00	2024-07-25 22:00:00	1721962800	23.40	74.20	0	Clear 	5.10	8.30	115.00	ESE	1019.00	30.08	0.00	0.00	0.00	84.00	7.00	25.50	78.00	23.40	74.20	25.50	78.00	19.80	67.60	0	0.00	0	0.00	10.00	6.00	10.30	16.50	0.00
792	2	2024-07-25 00:00:00	2024-07-25 23:00:00	1721966400	22.70	72.90	0	Clear 	4.50	7.20	118.00	ESE	1019.00	30.08	0.00	0.00	0.00	88.00	11.00	25.00	77.10	22.70	72.90	25.00	77.10	20.80	69.40	0	0.00	0	0.00	10.00	6.00	7.90	12.60	0.00
864	1	2024-07-27 00:00:00	2024-07-27 23:00:00	1722139200	23.00	73.40	0	Clear 	13.00	20.90	160.00	SSE	1014.00	29.96	\N	\N	0.00	85.00	8.00	25.20	77.30	23.00	73.40	25.20	77.30	20.20	68.30	0	0.00	0	0.00	10.00	6.00	21.60	34.70	0.00
\.


             3412.dat                                                                                            0000600 0004000 0002000 00000000271 14656737537 0014272 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	72956	Van Buren	Arkansas	USA	35.44	-94.34	America/Chicago	1721761538	2024-07-23 14:05:00
1	75189	Royse City	Texas	USA	32.97	-96.30	America/Chicago	1721921217	2024-07-25 10:26:00
\.


                                                                                                                                                                                                                                                                                                                                       3409.dat                                                                                            0000600 0004000 0002000 00001220157 14656737537 0014310 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	{"current": {"uv": 7, "cloud": 0, "is_day": 1, "temp_c": 30.1, "temp_f": 86.2, "vis_km": 16, "gust_kph": 38.7, "gust_mph": 24.1, "humidity": 43, "wind_dir": "NNW", "wind_kph": 19.1, "wind_mph": 11.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 9, "dewpoint_c": 21.1, "dewpoint_f": 69.9, "feelslike_c": 34.6, "feelslike_f": 94.3, "heatindex_c": 30.1, "heatindex_f": 86.2, "pressure_in": 29.97, "pressure_mb": 1015, "wind_degree": 330, "windchill_c": 27.7, "windchill_f": 81.8, "last_updated": "2024-07-05 18:45", "last_updated_epoch": 1720223100}, "forecast": {"forecastday": [{"day": {"uv": 10, "avgtemp_c": 26.7, "avgtemp_f": 80.1, "avgvis_km": 8.9, "condition": {"code": 1189, "icon": "//cdn.weatherapi.com/weather/64x64/day/302.png", "text": "Moderate rain"}, "maxtemp_c": 31.9, "maxtemp_f": 89.4, "mintemp_c": 22.7, "mintemp_f": 72.8, "avghumidity": 72, "maxwind_kph": 32, "maxwind_mph": 19.9, "avgvis_miles": 5, "totalsnow_cm": 0, "totalprecip_in": 0.61, "totalprecip_mm": 15.58, "daily_will_it_rain": 1, "daily_will_it_snow": 0, "daily_chance_of_rain": 89, "daily_chance_of_snow": 0}, "date": "2024-07-05", "hour": [{"uv": 1, "time": "2024-07-05 00:00", "cloud": 16, "is_day": 0, "temp_c": 28.3, "temp_f": 82.9, "vis_km": 10, "snow_cm": 0, "gust_kph": 25.2, "gust_mph": 15.7, "humidity": 71, "wind_dir": "SSE", "wind_kph": 13, "wind_mph": 8.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 22.4, "dewpoint_f": 72.3, "time_epoch": 1720155600, "feelslike_c": 31.4, "feelslike_f": 88.6, "heatindex_c": 31.4, "heatindex_f": 88.6, "pressure_in": 29.87, "pressure_mb": 1012, "wind_degree": 152, "windchill_c": 28.3, "windchill_f": 82.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-05 01:00", "cloud": 80, "is_day": 0, "temp_c": 27.5, "temp_f": 81.5, "vis_km": 10, "snow_cm": 0, "gust_kph": 19.4, "gust_mph": 12.1, "humidity": 73, "wind_dir": "SSE", "wind_kph": 9.7, "wind_mph": 6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.02, "vis_miles": 6, "dewpoint_c": 22.3, "dewpoint_f": 72.2, "time_epoch": 1720159200, "feelslike_c": 30.4, "feelslike_f": 86.8, "heatindex_c": 30.4, "heatindex_f": 86.8, "pressure_in": 29.89, "pressure_mb": 1012, "wind_degree": 167, "windchill_c": 27.5, "windchill_f": 81.5, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 83, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-05 02:00", "cloud": 88, "is_day": 0, "temp_c": 25.9, "temp_f": 78.6, "vis_km": 9, "snow_cm": 0, "gust_kph": 3.6, "gust_mph": 2.2, "humidity": 76, "wind_dir": "ESE", "wind_kph": 1.8, "wind_mph": 1.1, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.04, "precip_mm": 1.07, "vis_miles": 5, "dewpoint_c": 22.2, "dewpoint_f": 71.9, "time_epoch": 1720162800, "feelslike_c": 28.5, "feelslike_f": 83.3, "heatindex_c": 28.5, "heatindex_f": 83.3, "pressure_in": 29.9, "pressure_mb": 1013, "wind_degree": 116, "windchill_c": 25.9, "windchill_f": 78.6, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-05 03:00", "cloud": 89, "is_day": 0, "temp_c": 25.6, "temp_f": 78.1, "vis_km": 10, "snow_cm": 0, "gust_kph": 34.1, "gust_mph": 21.2, "humidity": 89, "wind_dir": "NE", "wind_kph": 20.5, "wind_mph": 12.8, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.1, "vis_miles": 6, "dewpoint_c": 22.4, "dewpoint_f": 72.2, "time_epoch": 1720166400, "feelslike_c": 28.2, "feelslike_f": 82.7, "heatindex_c": 28.2, "heatindex_f": 82.7, "pressure_in": 29.93, "pressure_mb": 1014, "wind_degree": 39, "windchill_c": 25.6, "windchill_f": 78.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-05 04:00", "cloud": 49, "is_day": 0, "temp_c": 25.2, "temp_f": 77.4, "vis_km": 10, "snow_cm": 0, "gust_kph": 20.6, "gust_mph": 12.8, "humidity": 83, "wind_dir": "NE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 22.3, "dewpoint_f": 72.1, "time_epoch": 1720170000, "feelslike_c": 27.6, "feelslike_f": 81.8, "heatindex_c": 27.6, "heatindex_f": 81.8, "pressure_in": 29.92, "pressure_mb": 1013, "wind_degree": 52, "windchill_c": 25.2, "windchill_f": 77.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-05 05:00", "cloud": 77, "is_day": 0, "temp_c": 24.7, "temp_f": 76.4, "vis_km": 2, "snow_cm": 0, "gust_kph": 24.1, "gust_mph": 15, "humidity": 85, "wind_dir": "ENE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1153, "icon": "//cdn.weatherapi.com/weather/64x64/night/266.png", "text": "Light drizzle"}, "precip_in": 0.02, "precip_mm": 0.41, "vis_miles": 1, "dewpoint_c": 22.2, "dewpoint_f": 72, "time_epoch": 1720173600, "feelslike_c": 27, "feelslike_f": 80.6, "heatindex_c": 27, "heatindex_f": 80.6, "pressure_in": 29.93, "pressure_mb": 1013, "wind_degree": 72, "windchill_c": 24.7, "windchill_f": 76.4, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-05 06:00", "cloud": 72, "is_day": 0, "temp_c": 24.4, "temp_f": 75.9, "vis_km": 9, "snow_cm": 0, "gust_kph": 25.2, "gust_mph": 15.7, "humidity": 88, "wind_dir": "ENE", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.02, "precip_mm": 0.46, "vis_miles": 5, "dewpoint_c": 22, "dewpoint_f": 71.5, "time_epoch": 1720177200, "feelslike_c": 26.7, "feelslike_f": 80, "heatindex_c": 26.7, "heatindex_f": 80, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 73, "windchill_c": 24.4, "windchill_f": 75.9, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-05 07:00", "cloud": 18, "is_day": 1, "temp_c": 25.1, "temp_f": 77.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 22.5, "gust_mph": 14, "humidity": 88, "wind_dir": "ESE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 22, "dewpoint_f": 71.6, "time_epoch": 1720180800, "feelslike_c": 27.6, "feelslike_f": 81.6, "heatindex_c": 27.6, "heatindex_f": 81.6, "pressure_in": 29.93, "pressure_mb": 1014, "wind_degree": 118, "windchill_c": 25.1, "windchill_f": 77.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-05 08:00", "cloud": 88, "is_day": 1, "temp_c": 26.5, "temp_f": 79.8, "vis_km": 9, "snow_cm": 0, "gust_kph": 11.5, "gust_mph": 7.1, "humidity": 81, "wind_dir": "SE", "wind_kph": 7.2, "wind_mph": 4.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.01, "precip_mm": 0.27, "vis_miles": 5, "dewpoint_c": 22.4, "dewpoint_f": 72.4, "time_epoch": 1720184400, "feelslike_c": 29.4, "feelslike_f": 84.9, "heatindex_c": 29.4, "heatindex_f": 84.9, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 135, "windchill_c": 26.5, "windchill_f": 79.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-05 09:00", "cloud": 21, "is_day": 1, "temp_c": 28, "temp_f": 82.4, "vis_km": 10, "snow_cm": 0, "gust_kph": 11.2, "gust_mph": 6.9, "humidity": 73, "wind_dir": "E", "wind_kph": 9, "wind_mph": 5.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 22.7, "dewpoint_f": 72.9, "time_epoch": 1720188000, "feelslike_c": 31.4, "feelslike_f": 88.5, "heatindex_c": 31.4, "heatindex_f": 88.5, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 97, "windchill_c": 28, "windchill_f": 82.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-05 10:00", "cloud": 15, "is_day": 1, "temp_c": 29.3, "temp_f": 84.8, "vis_km": 10, "snow_cm": 0, "gust_kph": 11.3, "gust_mph": 7, "humidity": 67, "wind_dir": "E", "wind_kph": 8.3, "wind_mph": 5.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 22.8, "dewpoint_f": 73.1, "time_epoch": 1720191600, "feelslike_c": 33.1, "feelslike_f": 91.6, "heatindex_c": 33.1, "heatindex_f": 91.6, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 88, "windchill_c": 29.3, "windchill_f": 84.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-05 11:00", "cloud": 72, "is_day": 1, "temp_c": 30.7, "temp_f": 87.2, "vis_km": 9, "snow_cm": 0, "gust_kph": 8.9, "gust_mph": 5.5, "humidity": 62, "wind_dir": "ENE", "wind_kph": 7.6, "wind_mph": 4.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.03, "precip_mm": 0.8, "vis_miles": 5, "dewpoint_c": 22.6, "dewpoint_f": 72.7, "time_epoch": 1720195200, "feelslike_c": 34.7, "feelslike_f": 94.5, "heatindex_c": 34.7, "heatindex_f": 94.5, "pressure_in": 29.93, "pressure_mb": 1014, "wind_degree": 59, "windchill_c": 30.7, "windchill_f": 87.2, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-05 12:00", "cloud": 24, "is_day": 1, "temp_c": 31.3, "temp_f": 88.4, "vis_km": 10, "snow_cm": 0, "gust_kph": 12.8, "gust_mph": 8, "humidity": 56, "wind_dir": "NNE", "wind_kph": 8.3, "wind_mph": 5.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 22.2, "dewpoint_f": 72, "time_epoch": 1720198800, "feelslike_c": 35.4, "feelslike_f": 95.7, "heatindex_c": 35.4, "heatindex_f": 95.7, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 24, "windchill_c": 31.3, "windchill_f": 88.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-05 13:00", "cloud": 82, "is_day": 1, "temp_c": 30.4, "temp_f": 86.7, "vis_km": 9, "snow_cm": 0, "gust_kph": 13.3, "gust_mph": 8.3, "humidity": 56, "wind_dir": "N", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1087, "icon": "//cdn.weatherapi.com/weather/64x64/day/200.png", "text": "Thundery outbreaks in nearby"}, "precip_in": 0, "precip_mm": 0.01, "vis_miles": 5, "dewpoint_c": 22, "dewpoint_f": 71.5, "time_epoch": 1720202400, "feelslike_c": 34.1, "feelslike_f": 93.3, "heatindex_c": 34.1, "heatindex_f": 93.3, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 9, "windchill_c": 30.4, "windchill_f": 86.7, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 89, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-05 14:00", "cloud": 74, "is_day": 1, "temp_c": 29.5, "temp_f": 85, "vis_km": 9, "snow_cm": 0, "gust_kph": 26.2, "gust_mph": 16.3, "humidity": 64, "wind_dir": "N", "wind_kph": 19.8, "wind_mph": 12.3, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.02, "precip_mm": 0.39, "vis_miles": 5, "dewpoint_c": 22, "dewpoint_f": 71.7, "time_epoch": 1720206000, "feelslike_c": 32.8, "feelslike_f": 91, "heatindex_c": 32.8, "heatindex_f": 91, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 0, "windchill_c": 29.5, "windchill_f": 85, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-05 15:00", "cloud": 86, "is_day": 1, "temp_c": 29.6, "temp_f": 85.2, "vis_km": 9, "snow_cm": 0, "gust_kph": 24.7, "gust_mph": 15.3, "humidity": 67, "wind_dir": "N", "wind_kph": 19.8, "wind_mph": 12.3, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.04, "precip_mm": 0.98, "vis_miles": 5, "dewpoint_c": 21.8, "dewpoint_f": 71.2, "time_epoch": 1720209600, "feelslike_c": 32.8, "feelslike_f": 91, "heatindex_c": 32.8, "heatindex_f": 91, "pressure_in": 29.93, "pressure_mb": 1014, "wind_degree": 3, "windchill_c": 29.6, "windchill_f": 85.2, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-05 16:00", "cloud": 15, "is_day": 1, "temp_c": 29.3, "temp_f": 84.7, "vis_km": 10, "snow_cm": 0, "gust_kph": 35.6, "gust_mph": 22.1, "humidity": 62, "wind_dir": "N", "wind_kph": 24.5, "wind_mph": 15.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 21.6, "dewpoint_f": 70.9, "time_epoch": 1720213200, "feelslike_c": 32.3, "feelslike_f": 90.1, "heatindex_c": 32.3, "heatindex_f": 90.1, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 9, "windchill_c": 29.3, "windchill_f": 84.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-05 17:00", "cloud": 77, "is_day": 1, "temp_c": 28.5, "temp_f": 83.3, "vis_km": 10, "snow_cm": 0, "gust_kph": 36.9, "gust_mph": 22.9, "humidity": 64, "wind_dir": "NNE", "wind_kph": 30.2, "wind_mph": 18.8, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.01, "vis_miles": 6, "dewpoint_c": 21.4, "dewpoint_f": 70.5, "time_epoch": 1720216800, "feelslike_c": 31.2, "feelslike_f": 88.1, "heatindex_c": 31.2, "heatindex_f": 88.1, "pressure_in": 29.92, "pressure_mb": 1013, "wind_degree": 18, "windchill_c": 28.5, "windchill_f": 83.3, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 88, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-05 18:00", "cloud": 0, "is_day": 1, "temp_c": 30.1, "temp_f": 86.2, "vis_km": 16, "snow_cm": 0, "gust_kph": 38.7, "gust_mph": 24.1, "humidity": 43, "wind_dir": "NNW", "wind_kph": 19.1, "wind_mph": 11.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 9, "dewpoint_c": 21.1, "dewpoint_f": 69.9, "time_epoch": 1720220400, "feelslike_c": 30.1, "feelslike_f": 86.2, "heatindex_c": 30.1, "heatindex_f": 86.2, "pressure_in": 29.97, "pressure_mb": 1015, "wind_degree": 330, "windchill_c": 27.7, "windchill_f": 81.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-05 19:00", "cloud": 8, "is_day": 1, "temp_c": 26.8, "temp_f": 80.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 31.5, "gust_mph": 19.6, "humidity": 70, "wind_dir": "NE", "wind_kph": 23.4, "wind_mph": 14.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.9, "dewpoint_f": 69.6, "time_epoch": 1720224000, "feelslike_c": 28.9, "feelslike_f": 84, "heatindex_c": 28.9, "heatindex_f": 84, "pressure_in": 29.89, "pressure_mb": 1012, "wind_degree": 40, "windchill_c": 26.8, "windchill_f": 80.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-05 20:00", "cloud": 81, "is_day": 1, "temp_c": 25.8, "temp_f": 78.5, "vis_km": 9, "snow_cm": 0, "gust_kph": 26.7, "gust_mph": 16.6, "humidity": 72, "wind_dir": "NE", "wind_kph": 17.6, "wind_mph": 11, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.02, "precip_mm": 0.4, "vis_miles": 5, "dewpoint_c": 20.5, "dewpoint_f": 68.8, "time_epoch": 1720227600, "feelslike_c": 27.8, "feelslike_f": 82, "heatindex_c": 27.8, "heatindex_f": 82, "pressure_in": 29.93, "pressure_mb": 1014, "wind_degree": 43, "windchill_c": 25.8, "windchill_f": 78.5, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-05 21:00", "cloud": 10, "is_day": 0, "temp_c": 25, "temp_f": 77, "vis_km": 10, "snow_cm": 0, "gust_kph": 26.5, "gust_mph": 16.5, "humidity": 73, "wind_dir": "ENE", "wind_kph": 15.8, "wind_mph": 9.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1720231200, "feelslike_c": 26.9, "feelslike_f": 80.3, "heatindex_c": 26.9, "heatindex_f": 80.3, "pressure_in": 29.9, "pressure_mb": 1013, "wind_degree": 60, "windchill_c": 25, "windchill_f": 77, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-05 22:00", "cloud": 10, "is_day": 0, "temp_c": 24.2, "temp_f": 75.6, "vis_km": 10, "snow_cm": 0, "gust_kph": 20.2, "gust_mph": 12.5, "humidity": 74, "wind_dir": "NE", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19.3, "dewpoint_f": 66.7, "time_epoch": 1720234800, "feelslike_c": 26.1, "feelslike_f": 79, "heatindex_c": 26.1, "heatindex_f": 79, "pressure_in": 29.93, "pressure_mb": 1013, "wind_degree": 53, "windchill_c": 24.2, "windchill_f": 75.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-05 23:00", "cloud": 20, "is_day": 0, "temp_c": 23.5, "temp_f": 74.3, "vis_km": 10, "snow_cm": 0, "gust_kph": 14.2, "gust_mph": 8.8, "humidity": 76, "wind_dir": "NE", "wind_kph": 7.9, "wind_mph": 4.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19, "dewpoint_f": 66.3, "time_epoch": 1720238400, "feelslike_c": 25.5, "feelslike_f": 77.9, "heatindex_c": 25.5, "heatindex_f": 77.9, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 47, "windchill_c": 23.5, "windchill_f": 74.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:37 PM", "moonset": "08:57 PM", "sunrise": "06:22 AM", "moonrise": "05:44 AM", "is_sun_up": 1, "is_moon_up": 1, "moon_phase": "New Moon", "moon_illumination": 1}, "date_epoch": 1720137600}, {"day": {"uv": 11, "avgtemp_c": 26.6, "avgtemp_f": 79.8, "avgvis_km": 10, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "maxtemp_c": 32.8, "maxtemp_f": 91, "mintemp_c": 21.1, "mintemp_f": 70, "avghumidity": 60, "maxwind_kph": 17.3, "maxwind_mph": 10.7, "avgvis_miles": 6, "totalsnow_cm": 0, "totalprecip_in": 0, "totalprecip_mm": 0.02, "daily_will_it_rain": 0, "daily_will_it_snow": 0, "daily_chance_of_rain": 0, "daily_chance_of_snow": 0}, "date": "2024-07-06", "hour": [{"uv": 1, "time": "2024-07-06 00:00", "cloud": 82, "is_day": 0, "temp_c": 23.1, "temp_f": 73.5, "vis_km": 10, "snow_cm": 0, "gust_kph": 16.1, "gust_mph": 10, "humidity": 80, "wind_dir": "N", "wind_kph": 8.6, "wind_mph": 5.4, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.11, "vis_miles": 6, "dewpoint_c": 19.1, "dewpoint_f": 66.3, "time_epoch": 1720242000, "feelslike_c": 25.2, "feelslike_f": 77.3, "heatindex_c": 25.2, "heatindex_f": 77.3, "pressure_in": 29.98, "pressure_mb": 1015, "wind_degree": 0, "windchill_c": 23.1, "windchill_f": 73.5, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-06 01:00", "cloud": 25, "is_day": 0, "temp_c": 22.8, "temp_f": 73.1, "vis_km": 10, "snow_cm": 0, "gust_kph": 20.6, "gust_mph": 12.8, "humidity": 80, "wind_dir": "N", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19, "dewpoint_f": 66.1, "time_epoch": 1720245600, "feelslike_c": 25, "feelslike_f": 77, "heatindex_c": 25, "heatindex_f": 77, "pressure_in": 29.98, "pressure_mb": 1015, "wind_degree": 0, "windchill_c": 22.8, "windchill_f": 73.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-06 02:00", "cloud": 15, "is_day": 0, "temp_c": 22.7, "temp_f": 72.8, "vis_km": 10, "snow_cm": 0, "gust_kph": 18.9, "gust_mph": 11.8, "humidity": 78, "wind_dir": "NNE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 18.5, "dewpoint_f": 65.3, "time_epoch": 1720249200, "feelslike_c": 24.9, "feelslike_f": 76.8, "heatindex_c": 24.9, "heatindex_f": 76.8, "pressure_in": 29.97, "pressure_mb": 1015, "wind_degree": 31, "windchill_c": 22.7, "windchill_f": 72.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-06 03:00", "cloud": 88, "is_day": 0, "temp_c": 22.6, "temp_f": 72.6, "vis_km": 10, "snow_cm": 0, "gust_kph": 18.6, "gust_mph": 11.5, "humidity": 76, "wind_dir": "NNE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.05, "vis_miles": 6, "dewpoint_c": 18.1, "dewpoint_f": 64.5, "time_epoch": 1720252800, "feelslike_c": 24.8, "feelslike_f": 76.7, "heatindex_c": 24.8, "heatindex_f": 76.7, "pressure_in": 29.96, "pressure_mb": 1015, "wind_degree": 19, "windchill_c": 22.6, "windchill_f": 72.6, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-06 04:00", "cloud": 71, "is_day": 0, "temp_c": 22.6, "temp_f": 72.6, "vis_km": 10, "snow_cm": 0, "gust_kph": 14.9, "gust_mph": 9.2, "humidity": 74, "wind_dir": "NE", "wind_kph": 7.9, "wind_mph": 4.9, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.06, "vis_miles": 6, "dewpoint_c": 17.8, "dewpoint_f": 64, "time_epoch": 1720256400, "feelslike_c": 24.8, "feelslike_f": 76.6, "heatindex_c": 24.8, "heatindex_f": 76.6, "pressure_in": 29.96, "pressure_mb": 1015, "wind_degree": 37, "windchill_c": 22.5, "windchill_f": 72.6, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-06 05:00", "cloud": 32, "is_day": 0, "temp_c": 22.4, "temp_f": 72.3, "vis_km": 10, "snow_cm": 0, "gust_kph": 9.2, "gust_mph": 5.7, "humidity": 74, "wind_dir": "NNE", "wind_kph": 5, "wind_mph": 3.1, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 17.6, "dewpoint_f": 63.6, "time_epoch": 1720260000, "feelslike_c": 24.7, "feelslike_f": 76.5, "heatindex_c": 24.7, "heatindex_f": 76.5, "pressure_in": 29.97, "pressure_mb": 1015, "wind_degree": 22, "windchill_c": 22.4, "windchill_f": 72.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-06 06:00", "cloud": 78, "is_day": 0, "temp_c": 22.1, "temp_f": 71.8, "vis_km": 10, "snow_cm": 0, "gust_kph": 14.1, "gust_mph": 8.8, "humidity": 73, "wind_dir": "N", "wind_kph": 7.6, "wind_mph": 4.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.1, "vis_miles": 6, "dewpoint_c": 17.2, "dewpoint_f": 63, "time_epoch": 1720263600, "feelslike_c": 24.6, "feelslike_f": 76.3, "heatindex_c": 24.6, "heatindex_f": 76.3, "pressure_in": 29.98, "pressure_mb": 1015, "wind_degree": 3, "windchill_c": 22.1, "windchill_f": 71.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 5, "time": "2024-07-06 07:00", "cloud": 70, "is_day": 1, "temp_c": 22.6, "temp_f": 72.6, "vis_km": 9, "snow_cm": 0, "gust_kph": 20.4, "gust_mph": 12.7, "humidity": 76, "wind_dir": "NNE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.01, "precip_mm": 0.32, "vis_miles": 5, "dewpoint_c": 17.5, "dewpoint_f": 63.5, "time_epoch": 1720267200, "feelslike_c": 24.8, "feelslike_f": 76.7, "heatindex_c": 24.8, "heatindex_f": 76.7, "pressure_in": 29.99, "pressure_mb": 1015, "wind_degree": 26, "windchill_c": 22.6, "windchill_f": 72.6, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 5, "time": "2024-07-06 08:00", "cloud": 83, "is_day": 1, "temp_c": 23.6, "temp_f": 74.5, "vis_km": 10, "snow_cm": 0, "gust_kph": 19.2, "gust_mph": 11.9, "humidity": 73, "wind_dir": "NNE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.01, "vis_miles": 6, "dewpoint_c": 17.9, "dewpoint_f": 64.3, "time_epoch": 1720270800, "feelslike_c": 25.5, "feelslike_f": 77.8, "heatindex_c": 25.5, "heatindex_f": 77.8, "pressure_in": 29.99, "pressure_mb": 1016, "wind_degree": 32, "windchill_c": 23.6, "windchill_f": 74.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 66, "chance_of_snow": 0}, {"uv": 5, "time": "2024-07-06 09:00", "cloud": 76, "is_day": 1, "temp_c": 24.8, "temp_f": 76.6, "vis_km": 9, "snow_cm": 0, "gust_kph": 16.6, "gust_mph": 10.3, "humidity": 66, "wind_dir": "ENE", "wind_kph": 13, "wind_mph": 8.1, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.01, "precip_mm": 0.17, "vis_miles": 5, "dewpoint_c": 17.8, "dewpoint_f": 64.1, "time_epoch": 1720274400, "feelslike_c": 26.4, "feelslike_f": 79.5, "heatindex_c": 26.4, "heatindex_f": 79.5, "pressure_in": 30, "pressure_mb": 1016, "wind_degree": 63, "windchill_c": 24.8, "windchill_f": 76.6, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-06 10:00", "cloud": 46, "is_day": 1, "temp_c": 25.8, "temp_f": 78.5, "vis_km": 10, "snow_cm": 0, "gust_kph": 18.1, "gust_mph": 11.3, "humidity": 64, "wind_dir": "E", "wind_kph": 15.5, "wind_mph": 9.6, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 18.6, "dewpoint_f": 65.4, "time_epoch": 1720278000, "feelslike_c": 27.5, "feelslike_f": 81.5, "heatindex_c": 27.5, "heatindex_f": 81.5, "pressure_in": 30.01, "pressure_mb": 1016, "wind_degree": 92, "windchill_c": 25.8, "windchill_f": 78.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-06 11:00", "cloud": 65, "is_day": 1, "temp_c": 26.9, "temp_f": 80.4, "vis_km": 10, "snow_cm": 0, "gust_kph": 20.5, "gust_mph": 12.8, "humidity": 65, "wind_dir": "E", "wind_kph": 17.6, "wind_mph": 11, "condition": {"code": 1006, "icon": "//cdn.weatherapi.com/weather/64x64/day/119.png", "text": "Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19.7, "dewpoint_f": 67.5, "time_epoch": 1720281600, "feelslike_c": 28.7, "feelslike_f": 83.7, "heatindex_c": 28.7, "heatindex_f": 83.7, "pressure_in": 30, "pressure_mb": 1016, "wind_degree": 100, "windchill_c": 26.9, "windchill_f": 80.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-06 12:00", "cloud": 65, "is_day": 1, "temp_c": 27.6, "temp_f": 81.6, "vis_km": 10, "snow_cm": 0, "gust_kph": 20.9, "gust_mph": 13, "humidity": 63, "wind_dir": "E", "wind_kph": 18, "wind_mph": 11.2, "condition": {"code": 1006, "icon": "//cdn.weatherapi.com/weather/64x64/day/119.png", "text": "Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1720285200, "feelslike_c": 29.6, "feelslike_f": 85.3, "heatindex_c": 29.6, "heatindex_f": 85.3, "pressure_in": 30, "pressure_mb": 1016, "wind_degree": 91, "windchill_c": 27.6, "windchill_f": 81.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-06 13:00", "cloud": 45, "is_day": 1, "temp_c": 28.3, "temp_f": 82.9, "vis_km": 10, "snow_cm": 0, "gust_kph": 21.3, "gust_mph": 13.3, "humidity": 63, "wind_dir": "E", "wind_kph": 18.4, "wind_mph": 11.4, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.6, "dewpoint_f": 69, "time_epoch": 1720288800, "feelslike_c": 30.5, "feelslike_f": 86.9, "heatindex_c": 30.5, "heatindex_f": 86.9, "pressure_in": 29.98, "pressure_mb": 1015, "wind_degree": 96, "windchill_c": 28.3, "windchill_f": 82.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-06 14:00", "cloud": 36, "is_day": 1, "temp_c": 28.9, "temp_f": 84.1, "vis_km": 10, "snow_cm": 0, "gust_kph": 21.5, "gust_mph": 13.4, "humidity": 61, "wind_dir": "ESE", "wind_kph": 18.7, "wind_mph": 11.6, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.7, "dewpoint_f": 69.2, "time_epoch": 1720292400, "feelslike_c": 31.2, "feelslike_f": 88.2, "heatindex_c": 31.2, "heatindex_f": 88.2, "pressure_in": 29.96, "pressure_mb": 1015, "wind_degree": 103, "windchill_c": 28.9, "windchill_f": 84.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-06 15:00", "cloud": 32, "is_day": 1, "temp_c": 29.5, "temp_f": 85.1, "vis_km": 10, "snow_cm": 0, "gust_kph": 19.9, "gust_mph": 12.3, "humidity": 58, "wind_dir": "ESE", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.3, "dewpoint_f": 68.6, "time_epoch": 1720296000, "feelslike_c": 31.8, "feelslike_f": 89.3, "heatindex_c": 31.8, "heatindex_f": 89.3, "pressure_in": 29.95, "pressure_mb": 1014, "wind_degree": 109, "windchill_c": 29.5, "windchill_f": 85.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-06 16:00", "cloud": 35, "is_day": 1, "temp_c": 29.8, "temp_f": 85.6, "vis_km": 10, "snow_cm": 0, "gust_kph": 19.9, "gust_mph": 12.3, "humidity": 55, "wind_dir": "ESE", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.1, "dewpoint_f": 68.1, "time_epoch": 1720299600, "feelslike_c": 32.1, "feelslike_f": 89.8, "heatindex_c": 32.1, "heatindex_f": 89.8, "pressure_in": 29.93, "pressure_mb": 1013, "wind_degree": 108, "windchill_c": 29.8, "windchill_f": 85.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-06 17:00", "cloud": 29, "is_day": 1, "temp_c": 29.7, "temp_f": 85.4, "vis_km": 10, "snow_cm": 0, "gust_kph": 20.3, "gust_mph": 12.6, "humidity": 56, "wind_dir": "ESE", "wind_kph": 17.6, "wind_mph": 11, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.2, "dewpoint_f": 68.4, "time_epoch": 1720303200, "feelslike_c": 32, "feelslike_f": 89.6, "heatindex_c": 32, "heatindex_f": 89.6, "pressure_in": 29.92, "pressure_mb": 1013, "wind_degree": 113, "windchill_c": 29.7, "windchill_f": 85.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-06 18:00", "cloud": 26, "is_day": 1, "temp_c": 29.1, "temp_f": 84.4, "vis_km": 10, "snow_cm": 0, "gust_kph": 21.6, "gust_mph": 13.4, "humidity": 58, "wind_dir": "ESE", "wind_kph": 18, "wind_mph": 11.2, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.3, "dewpoint_f": 68.6, "time_epoch": 1720306800, "feelslike_c": 31.4, "feelslike_f": 88.5, "heatindex_c": 31.4, "heatindex_f": 88.5, "pressure_in": 29.91, "pressure_mb": 1013, "wind_degree": 105, "windchill_c": 29.1, "windchill_f": 84.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-06 19:00", "cloud": 18, "is_day": 1, "temp_c": 28.1, "temp_f": 82.5, "vis_km": 10, "snow_cm": 0, "gust_kph": 22.7, "gust_mph": 14.1, "humidity": 61, "wind_dir": "ESE", "wind_kph": 16.9, "wind_mph": 10.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1720310400, "feelslike_c": 30.1, "feelslike_f": 86.2, "heatindex_c": 30.1, "heatindex_f": 86.2, "pressure_in": 29.92, "pressure_mb": 1013, "wind_degree": 109, "windchill_c": 28.1, "windchill_f": 82.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-06 20:00", "cloud": 10, "is_day": 1, "temp_c": 26.8, "temp_f": 80.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 21.6, "gust_mph": 13.4, "humidity": 66, "wind_dir": "ESE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.2, "dewpoint_f": 68.4, "time_epoch": 1720314000, "feelslike_c": 28.6, "feelslike_f": 83.5, "heatindex_c": 28.6, "heatindex_f": 83.5, "pressure_in": 29.91, "pressure_mb": 1013, "wind_degree": 107, "windchill_c": 26.8, "windchill_f": 80.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-06 21:00", "cloud": 73, "is_day": 0, "temp_c": 25.8, "temp_f": 78.4, "vis_km": 10, "snow_cm": 0, "gust_kph": 22.3, "gust_mph": 13.9, "humidity": 69, "wind_dir": "E", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.02, "vis_miles": 6, "dewpoint_c": 19.4, "dewpoint_f": 66.9, "time_epoch": 1720317600, "feelslike_c": 27.5, "feelslike_f": 81.5, "heatindex_c": 27.5, "heatindex_f": 81.5, "pressure_in": 29.9, "pressure_mb": 1013, "wind_degree": 96, "windchill_c": 25.8, "windchill_f": 78.4, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 86, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-06 22:00", "cloud": 9, "is_day": 0, "temp_c": 25.1, "temp_f": 77.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 24.6, "gust_mph": 15.3, "humidity": 71, "wind_dir": "ESE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19.1, "dewpoint_f": 66.3, "time_epoch": 1720321200, "feelslike_c": 26.8, "feelslike_f": 80.2, "heatindex_c": 26.8, "heatindex_f": 80.2, "pressure_in": 29.92, "pressure_mb": 1013, "wind_degree": 108, "windchill_c": 25.1, "windchill_f": 77.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-06 23:00", "cloud": 6, "is_day": 0, "temp_c": 24.7, "temp_f": 76.5, "vis_km": 10, "snow_cm": 0, "gust_kph": 23.8, "gust_mph": 14.8, "humidity": 71, "wind_dir": "ESE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19, "dewpoint_f": 66.1, "time_epoch": 1720324800, "feelslike_c": 26.4, "feelslike_f": 79.5, "heatindex_c": 26.4, "heatindex_f": 79.5, "pressure_in": 29.92, "pressure_mb": 1013, "wind_degree": 110, "windchill_c": 24.7, "windchill_f": 76.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:37 PM", "moonset": "09:43 PM", "sunrise": "06:23 AM", "moonrise": "06:46 AM", "is_sun_up": 1, "is_moon_up": 1, "moon_phase": "Waxing Crescent", "moon_illumination": 0}, "date_epoch": 1720224000}, {"day": {"uv": 11, "avgtemp_c": 27.8, "avgtemp_f": 82.1, "avgvis_km": 10, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "maxtemp_c": 33.6, "maxtemp_f": 92.4, "mintemp_c": 22.9, "mintemp_f": 73.3, "avghumidity": 64, "maxwind_kph": 24.8, "maxwind_mph": 15.4, "avgvis_miles": 6, "totalsnow_cm": 0, "totalprecip_in": 0.02, "totalprecip_mm": 0.59, "daily_will_it_rain": 1, "daily_will_it_snow": 0, "daily_chance_of_rain": 75, "daily_chance_of_snow": 0}, "date": "2024-07-07", "hour": [{"uv": 1, "time": "2024-07-07 00:00", "cloud": 8, "is_day": 0, "temp_c": 24.3, "temp_f": 75.7, "vis_km": 10, "snow_cm": 0, "gust_kph": 19.5, "gust_mph": 12.1, "humidity": 72, "wind_dir": "ESE", "wind_kph": 9.7, "wind_mph": 6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 18.9, "dewpoint_f": 66.1, "time_epoch": 1720328400, "feelslike_c": 26, "feelslike_f": 78.9, "heatindex_c": 26, "heatindex_f": 78.9, "pressure_in": 29.94, "pressure_mb": 1014, "wind_degree": 117, "windchill_c": 24.3, "windchill_f": 75.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-07 01:00", "cloud": 7, "is_day": 0, "temp_c": 24, "temp_f": 75.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 18.6, "gust_mph": 11.5, "humidity": 74, "wind_dir": "ESE", "wind_kph": 9, "wind_mph": 5.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19.1, "dewpoint_f": 66.3, "time_epoch": 1720332000, "feelslike_c": 25.8, "feelslike_f": 78.4, "heatindex_c": 25.8, "heatindex_f": 78.4, "pressure_in": 29.93, "pressure_mb": 1014, "wind_degree": 123, "windchill_c": 24, "windchill_f": 75.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-07 02:00", "cloud": 7, "is_day": 0, "temp_c": 23.7, "temp_f": 74.7, "vis_km": 10, "snow_cm": 0, "gust_kph": 20.4, "gust_mph": 12.7, "humidity": 75, "wind_dir": "ESE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19.1, "dewpoint_f": 66.4, "time_epoch": 1720335600, "feelslike_c": 25.6, "feelslike_f": 78, "heatindex_c": 25.6, "heatindex_f": 78, "pressure_in": 29.92, "pressure_mb": 1013, "wind_degree": 120, "windchill_c": 23.7, "windchill_f": 74.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-07 03:00", "cloud": 8, "is_day": 0, "temp_c": 23.4, "temp_f": 74.1, "vis_km": 10, "snow_cm": 0, "gust_kph": 22.9, "gust_mph": 14.2, "humidity": 76, "wind_dir": "SE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19, "dewpoint_f": 66.2, "time_epoch": 1720339200, "feelslike_c": 25.3, "feelslike_f": 77.6, "heatindex_c": 25.3, "heatindex_f": 77.6, "pressure_in": 29.89, "pressure_mb": 1012, "wind_degree": 126, "windchill_c": 23.4, "windchill_f": 74.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-07 04:00", "cloud": 12, "is_day": 0, "temp_c": 23.1, "temp_f": 73.6, "vis_km": 10, "snow_cm": 0, "gust_kph": 20.1, "gust_mph": 12.5, "humidity": 78, "wind_dir": "ESE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 18.9, "dewpoint_f": 66, "time_epoch": 1720342800, "feelslike_c": 25.2, "feelslike_f": 77.3, "heatindex_c": 25.2, "heatindex_f": 77.3, "pressure_in": 29.89, "pressure_mb": 1012, "wind_degree": 121, "windchill_c": 23.1, "windchill_f": 73.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-07 05:00", "cloud": 14, "is_day": 0, "temp_c": 22.9, "temp_f": 73.3, "vis_km": 10, "snow_cm": 0, "gust_kph": 22.2, "gust_mph": 13.8, "humidity": 79, "wind_dir": "SE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19.1, "dewpoint_f": 66.3, "time_epoch": 1720346400, "feelslike_c": 25, "feelslike_f": 77.1, "heatindex_c": 25, "heatindex_f": 77.1, "pressure_in": 29.89, "pressure_mb": 1012, "wind_degree": 128, "windchill_c": 22.9, "windchill_f": 73.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-07 06:00", "cloud": 11, "is_day": 0, "temp_c": 22.8, "temp_f": 73.1, "vis_km": 10, "snow_cm": 0, "gust_kph": 22.7, "gust_mph": 14.1, "humidity": 81, "wind_dir": "SE", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 19.4, "dewpoint_f": 66.8, "time_epoch": 1720350000, "feelslike_c": 25, "feelslike_f": 77, "heatindex_c": 25, "heatindex_f": 77, "pressure_in": 29.89, "pressure_mb": 1012, "wind_degree": 131, "windchill_c": 22.8, "windchill_f": 73.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-07 07:00", "cloud": 12, "is_day": 1, "temp_c": 23.6, "temp_f": 74.5, "vis_km": 10, "snow_cm": 0, "gust_kph": 23.3, "gust_mph": 14.5, "humidity": 85, "wind_dir": "SE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.1, "dewpoint_f": 68.2, "time_epoch": 1720353600, "feelslike_c": 25.8, "feelslike_f": 78.4, "heatindex_c": 25.8, "heatindex_f": 78.4, "pressure_in": 29.91, "pressure_mb": 1013, "wind_degree": 129, "windchill_c": 23.6, "windchill_f": 74.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6, "time": "2024-07-07 08:00", "cloud": 26, "is_day": 1, "temp_c": 25.1, "temp_f": 77.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 21.2, "gust_mph": 13.2, "humidity": 85, "wind_dir": "SE", "wind_kph": 15.5, "wind_mph": 9.6, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 21.8, "dewpoint_f": 71.2, "time_epoch": 1720357200, "feelslike_c": 27.6, "feelslike_f": 81.6, "heatindex_c": 27.6, "heatindex_f": 81.6, "pressure_in": 29.92, "pressure_mb": 1013, "wind_degree": 129, "windchill_c": 25.1, "windchill_f": 77.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-07 09:00", "cloud": 35, "is_day": 1, "temp_c": 26.8, "temp_f": 80.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 17.7, "gust_mph": 11, "humidity": 78, "wind_dir": "SE", "wind_kph": 15.1, "wind_mph": 9.4, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 22.5, "dewpoint_f": 72.5, "time_epoch": 1720360800, "feelslike_c": 29.7, "feelslike_f": 85.4, "heatindex_c": 29.7, "heatindex_f": 85.4, "pressure_in": 29.92, "pressure_mb": 1013, "wind_degree": 136, "windchill_c": 26.8, "windchill_f": 80.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-07 10:00", "cloud": 31, "is_day": 1, "temp_c": 28.4, "temp_f": 83.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 17, "gust_mph": 10.6, "humidity": 70, "wind_dir": "SSE", "wind_kph": 14.8, "wind_mph": 9.2, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 22.5, "dewpoint_f": 72.6, "time_epoch": 1720364400, "feelslike_c": 31.8, "feelslike_f": 89.2, "heatindex_c": 31.8, "heatindex_f": 89.2, "pressure_in": 29.91, "pressure_mb": 1013, "wind_degree": 146, "windchill_c": 28.4, "windchill_f": 83.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-07 11:00", "cloud": 28, "is_day": 1, "temp_c": 30, "temp_f": 86, "vis_km": 10, "snow_cm": 0, "gust_kph": 16.2, "gust_mph": 10, "humidity": 63, "wind_dir": "SSE", "wind_kph": 14, "wind_mph": 8.7, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 22.3, "dewpoint_f": 72.1, "time_epoch": 1720368000, "feelslike_c": 33.6, "feelslike_f": 92.6, "heatindex_c": 33.6, "heatindex_f": 92.6, "pressure_in": 29.91, "pressure_mb": 1013, "wind_degree": 153, "windchill_c": 30, "windchill_f": 86, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-07 12:00", "cloud": 51, "is_day": 1, "temp_c": 31.3, "temp_f": 88.3, "vis_km": 10, "snow_cm": 0, "gust_kph": 16.7, "gust_mph": 10.4, "humidity": 57, "wind_dir": "SSE", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 21.9, "dewpoint_f": 71.5, "time_epoch": 1720371600, "feelslike_c": 35, "feelslike_f": 95, "heatindex_c": 35, "heatindex_f": 95, "pressure_in": 29.91, "pressure_mb": 1013, "wind_degree": 156, "windchill_c": 31.3, "windchill_f": 88.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-07 13:00", "cloud": 74, "is_day": 1, "temp_c": 32.1, "temp_f": 89.9, "vis_km": 10, "snow_cm": 0, "gust_kph": 21.3, "gust_mph": 13.2, "humidity": 52, "wind_dir": "SSE", "wind_kph": 18, "wind_mph": 11.2, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.02, "vis_miles": 6, "dewpoint_c": 21.3, "dewpoint_f": 70.4, "time_epoch": 1720375200, "feelslike_c": 35.7, "feelslike_f": 96.3, "heatindex_c": 35.7, "heatindex_f": 96.3, "pressure_in": 29.91, "pressure_mb": 1013, "wind_degree": 155, "windchill_c": 32.1, "windchill_f": 89.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 65, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-07 14:00", "cloud": 89, "is_day": 1, "temp_c": 32.4, "temp_f": 90.3, "vis_km": 10, "snow_cm": 0, "gust_kph": 27.2, "gust_mph": 16.9, "humidity": 48, "wind_dir": "SSE", "wind_kph": 23.4, "wind_mph": 14.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.01, "vis_miles": 6, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1720378800, "feelslike_c": 35.6, "feelslike_f": 96.2, "heatindex_c": 35.6, "heatindex_f": 96.2, "pressure_in": 29.89, "pressure_mb": 1012, "wind_degree": 159, "windchill_c": 32.4, "windchill_f": 90.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 69, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-07 15:00", "cloud": 18, "is_day": 1, "temp_c": 32.5, "temp_f": 90.5, "vis_km": 10, "snow_cm": 0, "gust_kph": 28, "gust_mph": 17.4, "humidity": 48, "wind_dir": "SSE", "wind_kph": 24.1, "wind_mph": 15, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.2, "dewpoint_f": 68.4, "time_epoch": 1720382400, "feelslike_c": 35.7, "feelslike_f": 96.2, "heatindex_c": 35.7, "heatindex_f": 96.2, "pressure_in": 29.87, "pressure_mb": 1012, "wind_degree": 162, "windchill_c": 32.5, "windchill_f": 90.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-07 16:00", "cloud": 16, "is_day": 1, "temp_c": 32.4, "temp_f": 90.3, "vis_km": 10, "snow_cm": 0, "gust_kph": 24.3, "gust_mph": 15.1, "humidity": 48, "wind_dir": "SSE", "wind_kph": 20.9, "wind_mph": 13, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1720386000, "feelslike_c": 35.6, "feelslike_f": 96, "heatindex_c": 35.6, "heatindex_f": 96, "pressure_in": 29.85, "pressure_mb": 1011, "wind_degree": 161, "windchill_c": 32.4, "windchill_f": 90.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-07 17:00", "cloud": 11, "is_day": 1, "temp_c": 31.9, "temp_f": 89.3, "vis_km": 10, "snow_cm": 0, "gust_kph": 26, "gust_mph": 16.1, "humidity": 50, "wind_dir": "SSE", "wind_kph": 22.3, "wind_mph": 13.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.6, "dewpoint_f": 69.2, "time_epoch": 1720389600, "feelslike_c": 35, "feelslike_f": 94.9, "heatindex_c": 35, "heatindex_f": 94.9, "pressure_in": 29.84, "pressure_mb": 1010, "wind_degree": 156, "windchill_c": 31.9, "windchill_f": 89.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-07 18:00", "cloud": 8, "is_day": 1, "temp_c": 31, "temp_f": 87.8, "vis_km": 10, "snow_cm": 0, "gust_kph": 26.5, "gust_mph": 16.4, "humidity": 54, "wind_dir": "SSE", "wind_kph": 22, "wind_mph": 13.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.8, "dewpoint_f": 69.4, "time_epoch": 1720393200, "feelslike_c": 34, "feelslike_f": 93.1, "heatindex_c": 34, "heatindex_f": 93.1, "pressure_in": 29.83, "pressure_mb": 1010, "wind_degree": 151, "windchill_c": 31, "windchill_f": 87.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8, "time": "2024-07-07 19:00", "cloud": 6, "is_day": 1, "temp_c": 29.6, "temp_f": 85.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 27, "gust_mph": 16.8, "humidity": 58, "wind_dir": "SSE", "wind_kph": 20.5, "wind_mph": 12.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 21, "dewpoint_f": 69.8, "time_epoch": 1720396800, "feelslike_c": 32.3, "feelslike_f": 90.1, "heatindex_c": 32.3, "heatindex_f": 90.1, "pressure_in": 29.84, "pressure_mb": 1011, "wind_degree": 146, "windchill_c": 29.6, "windchill_f": 85.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7, "time": "2024-07-07 20:00", "cloud": 6, "is_day": 1, "temp_c": 27.8, "temp_f": 82.1, "vis_km": 10, "snow_cm": 0, "gust_kph": 26.6, "gust_mph": 16.5, "humidity": 65, "wind_dir": "SE", "wind_kph": 16.9, "wind_mph": 10.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 21, "dewpoint_f": 69.8, "time_epoch": 1720400400, "feelslike_c": 30.2, "feelslike_f": 86.3, "heatindex_c": 30.2, "heatindex_f": 86.3, "pressure_in": 29.85, "pressure_mb": 1011, "wind_degree": 138, "windchill_c": 27.8, "windchill_f": 82.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-07 21:00", "cloud": 8, "is_day": 0, "temp_c": 26.2, "temp_f": 79.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 24.3, "gust_mph": 15.1, "humidity": 72, "wind_dir": "ESE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0, "precip_mm": 0, "vis_miles": 6, "dewpoint_c": 20.7, "dewpoint_f": 69.2, "time_epoch": 1720404000, "feelslike_c": 28.4, "feelslike_f": 83.1, "heatindex_c": 28.4, "heatindex_f": 83.1, "pressure_in": 29.85, "pressure_mb": 1011, "wind_degree": 121, "windchill_c": 26.2, "windchill_f": 79.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-07 22:00", "cloud": 81, "is_day": 0, "temp_c": 25.1, "temp_f": 77.2, "vis_km": 10, "snow_cm": 0, "gust_kph": 30.1, "gust_mph": 18.7, "humidity": 80, "wind_dir": "ESE", "wind_kph": 14.8, "wind_mph": 9.2, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0, "precip_mm": 0.06, "vis_miles": 6, "dewpoint_c": 20.9, "dewpoint_f": 69.7, "time_epoch": 1720407600, "feelslike_c": 27.3, "feelslike_f": 81.1, "heatindex_c": 27.3, "heatindex_f": 81.1, "pressure_in": 29.85, "pressure_mb": 1011, "wind_degree": 115, "windchill_c": 25.1, "windchill_f": 77.2, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 1, "time": "2024-07-07 23:00", "cloud": 86, "is_day": 0, "temp_c": 24.4, "temp_f": 75.9, "vis_km": 9, "snow_cm": 0, "gust_kph": 26.4, "gust_mph": 16.4, "humidity": 86, "wind_dir": "E", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.01, "precip_mm": 0.38, "vis_miles": 5, "dewpoint_c": 21.6, "dewpoint_f": 70.8, "time_epoch": 1720411200, "feelslike_c": 26.6, "feelslike_f": 79.9, "heatindex_c": 26.6, "heatindex_f": 79.9, "pressure_in": 29.88, "pressure_mb": 1012, "wind_degree": 99, "windchill_c": 24.4, "windchill_f": 75.9, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}], "astro": {"sunset": "08:37 PM", "moonset": "10:21 PM", "sunrise": "06:23 AM", "moonrise": "07:50 AM", "is_sun_up": 1, "is_moon_up": 1, "moon_phase": "Waxing Crescent", "moon_illumination": 1}, "date_epoch": 1720310400}]}, "location": {"lat": 32.97, "lon": -96.3, "name": "Royse City", "tz_id": "America/Chicago", "region": "Texas", "country": "USA", "localtime": "2024-07-05 18:52", "localtime_epoch": 1720223558}}	2024-07-06 00:38:00.23759	1	2024-07-08 15:26:54.93509
3	{"current": {"uv": 8.0, "cloud": 50, "is_day": 1, "temp_c": 34.0, "temp_f": 93.2, "vis_km": 16.0, "gust_kph": 20.7, "gust_mph": 12.9, "humidity": 44, "wind_dir": "NNW", "wind_kph": 16.9, "wind_mph": 10.5, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly cloudy"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 9.0, "dewpoint_c": 18.7, "dewpoint_f": 65.7, "feelslike_c": 38.3, "feelslike_f": 100.9, "heatindex_c": 32.7, "heatindex_f": 90.9, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 340, "windchill_c": 30.9, "windchill_f": 87.6, "last_updated": "2024-07-18 15:15", "last_updated_epoch": 1721333700}, "forecast": {"forecastday": [{"day": {"uv": 10.0, "avgtemp_c": 26.7, "avgtemp_f": 80.0, "avgvis_km": 10.0, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "maxtemp_c": 32.5, "maxtemp_f": 90.5, "mintemp_c": 21.9, "mintemp_f": 71.4, "avghumidity": 71, "maxwind_kph": 20.9, "maxwind_mph": 13.0, "avgvis_miles": 6.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.04, "totalprecip_mm": 0.91, "daily_will_it_rain": 1, "daily_will_it_snow": 0, "daily_chance_of_rain": 89, "daily_chance_of_snow": 0}, "date": "2024-07-18", "hour": [{"uv": 0, "time": "2024-07-18 00:00", "cloud": 88, "is_day": 0, "temp_c": 23.2, "temp_f": 73.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.4, "gust_mph": 12.0, "humidity": 91, "wind_dir": "N", "wind_kph": 9.4, "wind_mph": 5.8, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.08, "vis_miles": 6.0, "dewpoint_c": 21.6, "dewpoint_f": 70.8, "time_epoch": 1721278800, "feelslike_c": 25.5, "feelslike_f": 78.0, "heatindex_c": 25.5, "heatindex_f": 78.0, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 4, "windchill_c": 23.2, "windchill_f": 73.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-18 01:00", "cloud": 29, "is_day": 0, "temp_c": 22.8, "temp_f": 73.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.0, "gust_mph": 14.3, "humidity": 92, "wind_dir": "NNE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.4, "dewpoint_f": 70.4, "time_epoch": 1721282400, "feelslike_c": 25.2, "feelslike_f": 77.4, "heatindex_c": 25.2, "heatindex_f": 77.4, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 11, "windchill_c": 22.8, "windchill_f": 73.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-18 02:00", "cloud": 82, "is_day": 0, "temp_c": 22.5, "temp_f": 72.5, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 19.0, "gust_mph": 11.8, "humidity": 92, "wind_dir": "NE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.01, "precip_mm": 0.22, "vis_miles": 5.0, "dewpoint_c": 21.1, "dewpoint_f": 69.9, "time_epoch": 1721286000, "feelslike_c": 24.9, "feelslike_f": 76.9, "heatindex_c": 24.9, "heatindex_f": 76.9, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 42, "windchill_c": 22.5, "windchill_f": 72.5, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-18 03:00", "cloud": 88, "is_day": 0, "temp_c": 22.5, "temp_f": 72.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 13.9, "gust_mph": 8.7, "humidity": 92, "wind_dir": "NE", "wind_kph": 7.9, "wind_mph": 4.9, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.02, "precip_mm": 0.46, "vis_miles": 6.0, "dewpoint_c": 20.9, "dewpoint_f": 69.6, "time_epoch": 1721289600, "feelslike_c": 24.8, "feelslike_f": 76.7, "heatindex_c": 24.8, "heatindex_f": 76.7, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 54, "windchill_c": 22.5, "windchill_f": 72.4, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-18 04:00", "cloud": 9, "is_day": 0, "temp_c": 22.3, "temp_f": 72.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.7, "gust_mph": 7.9, "humidity": 90, "wind_dir": "ENE", "wind_kph": 7.2, "wind_mph": 4.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.7, "dewpoint_f": 69.2, "time_epoch": 1721293200, "feelslike_c": 24.7, "feelslike_f": 76.5, "heatindex_c": 24.7, "heatindex_f": 76.5, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 56, "windchill_c": 22.3, "windchill_f": 72.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-18 05:00", "cloud": 12, "is_day": 0, "temp_c": 22.1, "temp_f": 71.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.1, "gust_mph": 7.5, "humidity": 91, "wind_dir": "NE", "wind_kph": 6.8, "wind_mph": 4.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1721296800, "feelslike_c": 24.6, "feelslike_f": 76.3, "heatindex_c": 24.6, "heatindex_f": 76.3, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 37, "windchill_c": 22.1, "windchill_f": 71.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-18 06:00", "cloud": 11, "is_day": 0, "temp_c": 22.1, "temp_f": 71.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.8, "gust_mph": 7.3, "humidity": 92, "wind_dir": "NNE", "wind_kph": 6.5, "wind_mph": 4.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.5, "dewpoint_f": 68.9, "time_epoch": 1721300400, "feelslike_c": 24.6, "feelslike_f": 76.2, "heatindex_c": 24.6, "heatindex_f": 76.2, "pressure_in": 30.02, "pressure_mb": 1016.0, "wind_degree": 22, "windchill_c": 22.1, "windchill_f": 71.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-18 07:00", "cloud": 12, "is_day": 1, "temp_c": 22.8, "temp_f": 73.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.6, "gust_mph": 9.1, "humidity": 91, "wind_dir": "N", "wind_kph": 8.3, "wind_mph": 5.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.0, "time_epoch": 1721304000, "feelslike_c": 25.1, "feelslike_f": 77.1, "heatindex_c": 25.1, "heatindex_f": 77.1, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 6, "windchill_c": 22.8, "windchill_f": 73.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-18 08:00", "cloud": 15, "is_day": 1, "temp_c": 24.0, "temp_f": 75.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.2, "gust_mph": 7.6, "humidity": 85, "wind_dir": "N", "wind_kph": 8.6, "wind_mph": 5.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.8, "dewpoint_f": 69.4, "time_epoch": 1721307600, "feelslike_c": 26.1, "feelslike_f": 79.1, "heatindex_c": 26.1, "heatindex_f": 79.1, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 8, "windchill_c": 24.0, "windchill_f": 75.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-18 09:00", "cloud": 34, "is_day": 1, "temp_c": 25.6, "temp_f": 78.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.8, "humidity": 77, "wind_dir": "N", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.9, "dewpoint_f": 69.5, "time_epoch": 1721311200, "feelslike_c": 27.7, "feelslike_f": 81.9, "heatindex_c": 27.7, "heatindex_f": 81.9, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 9, "windchill_c": 25.6, "windchill_f": 78.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-18 10:00", "cloud": 21, "is_day": 1, "temp_c": 27.4, "temp_f": 81.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 68, "wind_dir": "NNE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.7, "dewpoint_f": 69.2, "time_epoch": 1721314800, "feelslike_c": 29.6, "feelslike_f": 85.2, "heatindex_c": 29.6, "heatindex_f": 85.2, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 15, "windchill_c": 27.4, "windchill_f": 81.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-18 11:00", "cloud": 21, "is_day": 1, "temp_c": 29.2, "temp_f": 84.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 58, "wind_dir": "NNE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.1, "dewpoint_f": 68.1, "time_epoch": 1721318400, "feelslike_c": 31.3, "feelslike_f": 88.4, "heatindex_c": 31.3, "heatindex_f": 88.4, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 25, "windchill_c": 29.2, "windchill_f": 84.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-18 12:00", "cloud": 53, "is_day": 1, "temp_c": 30.8, "temp_f": 87.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 50, "wind_dir": "NNE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.4, "dewpoint_f": 67.0, "time_epoch": 1721322000, "feelslike_c": 32.9, "feelslike_f": 91.2, "heatindex_c": 32.9, "heatindex_f": 91.2, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 19, "windchill_c": 30.8, "windchill_f": 87.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-18 13:00", "cloud": 100, "is_day": 1, "temp_c": 31.6, "temp_f": 88.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.5, "gust_mph": 9.0, "humidity": 45, "wind_dir": "NNE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.07, "vis_miles": 6.0, "dewpoint_c": 18.8, "dewpoint_f": 65.8, "time_epoch": 1721325600, "feelslike_c": 33.5, "feelslike_f": 92.2, "heatindex_c": 33.5, "heatindex_f": 92.2, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 13, "windchill_c": 31.6, "windchill_f": 88.9, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-18 14:00", "cloud": 63, "is_day": 1, "temp_c": 31.4, "temp_f": 88.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.7, "humidity": 42, "wind_dir": "NNE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.05, "vis_miles": 6.0, "dewpoint_c": 18.0, "dewpoint_f": 64.5, "time_epoch": 1721329200, "feelslike_c": 33.2, "feelslike_f": 91.7, "heatindex_c": 33.2, "heatindex_f": 91.7, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 11, "windchill_c": 31.4, "windchill_f": 88.5, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-18 15:00", "cloud": 50, "is_day": 1, "temp_c": 34.0, "temp_f": 93.2, "vis_km": 16.0, "snow_cm": 0.0, "gust_kph": 20.7, "gust_mph": 12.9, "humidity": 44, "wind_dir": "NNW", "wind_kph": 16.9, "wind_mph": 10.5, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly cloudy"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 9.0, "dewpoint_c": 18.7, "dewpoint_f": 65.7, "time_epoch": 1721332800, "feelslike_c": 32.7, "feelslike_f": 90.9, "heatindex_c": 32.7, "heatindex_f": 90.9, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 340, "windchill_c": 30.9, "windchill_f": 87.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-18 16:00", "cloud": 27, "is_day": 1, "temp_c": 31.7, "temp_f": 89.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.2, "gust_mph": 12.5, "humidity": 51, "wind_dir": "ENE", "wind_kph": 15.1, "wind_mph": 9.4, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.2, "dewpoint_f": 66.6, "time_epoch": 1721336400, "feelslike_c": 33.5, "feelslike_f": 92.3, "heatindex_c": 33.5, "heatindex_f": 92.3, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 62, "windchill_c": 31.7, "windchill_f": 89.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-18 17:00", "cloud": 28, "is_day": 1, "temp_c": 31.9, "temp_f": 89.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 13.2, "gust_mph": 8.2, "humidity": 43, "wind_dir": "ENE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.4, "dewpoint_f": 65.1, "time_epoch": 1721340000, "feelslike_c": 33.8, "feelslike_f": 92.8, "heatindex_c": 33.8, "heatindex_f": 92.8, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 62, "windchill_c": 31.9, "windchill_f": 89.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-18 18:00", "cloud": 46, "is_day": 1, "temp_c": 30.9, "temp_f": 87.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.8, "gust_mph": 14.1, "humidity": 44, "wind_dir": "ENE", "wind_kph": 18.4, "wind_mph": 11.4, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.4, "time_epoch": 1721343600, "feelslike_c": 32.9, "feelslike_f": 91.2, "heatindex_c": 32.9, "heatindex_f": 91.2, "pressure_in": 29.94, "pressure_mb": 1014.0, "wind_degree": 61, "windchill_c": 30.9, "windchill_f": 87.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-18 19:00", "cloud": 21, "is_day": 1, "temp_c": 29.7, "temp_f": 85.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 30.2, "gust_mph": 18.8, "humidity": 54, "wind_dir": "ENE", "wind_kph": 20.9, "wind_mph": 13.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.7, "dewpoint_f": 67.4, "time_epoch": 1721347200, "feelslike_c": 31.8, "feelslike_f": 89.3, "heatindex_c": 31.8, "heatindex_f": 89.3, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 72, "windchill_c": 29.7, "windchill_f": 85.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-18 20:00", "cloud": 10, "is_day": 1, "temp_c": 28.0, "temp_f": 82.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 29.2, "gust_mph": 18.1, "humidity": 63, "wind_dir": "ENE", "wind_kph": 19.8, "wind_mph": 12.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.7, "dewpoint_f": 69.3, "time_epoch": 1721350800, "feelslike_c": 30.2, "feelslike_f": 86.3, "heatindex_c": 30.2, "heatindex_f": 86.3, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 76, "windchill_c": 28.0, "windchill_f": 82.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-18 21:00", "cloud": 89, "is_day": 0, "temp_c": 26.6, "temp_f": 79.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 28.5, "gust_mph": 17.7, "humidity": 73, "wind_dir": "ENE", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.02, "vis_miles": 6.0, "dewpoint_c": 21.2, "dewpoint_f": 70.2, "time_epoch": 1721354400, "feelslike_c": 28.7, "feelslike_f": 83.6, "heatindex_c": 28.7, "heatindex_f": 83.6, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 77, "windchill_c": 26.6, "windchill_f": 79.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 82, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-18 22:00", "cloud": 11, "is_day": 0, "temp_c": 25.3, "temp_f": 77.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.8, "gust_mph": 16.1, "humidity": 80, "wind_dir": "ENE", "wind_kph": 15.1, "wind_mph": 9.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.4, "dewpoint_f": 70.6, "time_epoch": 1721358000, "feelslike_c": 27.5, "feelslike_f": 81.4, "heatindex_c": 27.5, "heatindex_f": 81.4, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 75, "windchill_c": 25.4, "windchill_f": 77.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-18 23:00", "cloud": 9, "is_day": 0, "temp_c": 24.4, "temp_f": 75.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.0, "gust_mph": 13.0, "humidity": 84, "wind_dir": "ENE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.3, "dewpoint_f": 70.4, "time_epoch": 1721361600, "feelslike_c": 26.5, "feelslike_f": 79.7, "heatindex_c": 26.5, "heatindex_f": 79.7, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 61, "windchill_c": 24.4, "windchill_f": 75.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:33 PM", "moonset": "03:20 AM", "sunrise": "06:30 AM", "moonrise": "06:36 PM", "is_sun_up": 1, "is_moon_up": 1, "moon_phase": "Waxing Gibbous", "moon_illumination": 86}, "date_epoch": 1721260800}, {"day": {"uv": 10.0, "avgtemp_c": 26.6, "avgtemp_f": 79.8, "avgvis_km": 9.7, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "maxtemp_c": 32.7, "maxtemp_f": 90.8, "mintemp_c": 21.1, "mintemp_f": 69.9, "avghumidity": 66, "maxwind_kph": 20.2, "maxwind_mph": 12.5, "avgvis_miles": 6.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.0, "totalprecip_mm": 0.02, "daily_will_it_rain": 0, "daily_will_it_snow": 0, "daily_chance_of_rain": 0, "daily_chance_of_snow": 0}, "date": "2024-07-19", "hour": [{"uv": 0, "time": "2024-07-19 00:00", "cloud": 10, "is_day": 0, "temp_c": 23.7, "temp_f": 74.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.4, "gust_mph": 11.4, "humidity": 87, "wind_dir": "ENE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.1, "dewpoint_f": 69.9, "time_epoch": 1721365200, "feelslike_c": 25.8, "feelslike_f": 78.5, "heatindex_c": 25.8, "heatindex_f": 78.5, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 61, "windchill_c": 23.6, "windchill_f": 74.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 01:00", "cloud": 21, "is_day": 0, "temp_c": 23.0, "temp_f": 73.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.9, "gust_mph": 11.1, "humidity": 87, "wind_dir": "NE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.7, "dewpoint_f": 69.3, "time_epoch": 1721368800, "feelslike_c": 25.3, "feelslike_f": 77.5, "heatindex_c": 25.3, "heatindex_f": 77.5, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 53, "windchill_c": 23.0, "windchill_f": 73.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 02:00", "cloud": 33, "is_day": 0, "temp_c": 22.5, "temp_f": 72.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.6, "gust_mph": 11.6, "humidity": 88, "wind_dir": "ENE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.4, "dewpoint_f": 68.7, "time_epoch": 1721372400, "feelslike_c": 24.9, "feelslike_f": 76.8, "heatindex_c": 24.9, "heatindex_f": 76.8, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 68, "windchill_c": 22.5, "windchill_f": 72.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 03:00", "cloud": 18, "is_day": 0, "temp_c": 22.1, "temp_f": 71.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.0, "gust_mph": 11.2, "humidity": 91, "wind_dir": "ENE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.4, "dewpoint_f": 68.7, "time_epoch": 1721376000, "feelslike_c": 24.6, "feelslike_f": 76.3, "heatindex_c": 24.6, "heatindex_f": 76.3, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 60, "windchill_c": 22.1, "windchill_f": 71.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 04:00", "cloud": 24, "is_day": 0, "temp_c": 21.7, "temp_f": 71.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.1, "gust_mph": 12.5, "humidity": 93, "wind_dir": "NE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.4, "dewpoint_f": 68.8, "time_epoch": 1721379600, "feelslike_c": 21.7, "feelslike_f": 71.1, "heatindex_c": 24.4, "heatindex_f": 76.0, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 49, "windchill_c": 21.7, "windchill_f": 71.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 05:00", "cloud": 32, "is_day": 0, "temp_c": 21.4, "temp_f": 70.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.7, "gust_mph": 13.5, "humidity": 94, "wind_dir": "NE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.4, "dewpoint_f": 68.6, "time_epoch": 1721383200, "feelslike_c": 21.4, "feelslike_f": 70.5, "heatindex_c": 24.3, "heatindex_f": 75.7, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 48, "windchill_c": 21.4, "windchill_f": 70.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 06:00", "cloud": 33, "is_day": 0, "temp_c": 21.2, "temp_f": 70.2, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 20.2, "gust_mph": 12.5, "humidity": 95, "wind_dir": "NE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 20.2, "dewpoint_f": 68.4, "time_epoch": 1721386800, "feelslike_c": 21.2, "feelslike_f": 70.2, "heatindex_c": 24.2, "heatindex_f": 75.6, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 55, "windchill_c": 21.2, "windchill_f": 70.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-19 07:00", "cloud": 26, "is_day": 1, "temp_c": 22.1, "temp_f": 71.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.9, "gust_mph": 11.1, "humidity": 93, "wind_dir": "ENE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.0, "dewpoint_f": 67.9, "time_epoch": 1721390400, "feelslike_c": 24.6, "feelslike_f": 76.3, "heatindex_c": 24.6, "heatindex_f": 76.3, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 58, "windchill_c": 22.1, "windchill_f": 71.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-19 08:00", "cloud": 15, "is_day": 1, "temp_c": 23.5, "temp_f": 74.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.5, "gust_mph": 11.5, "humidity": 83, "wind_dir": "ENE", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1721394000, "feelslike_c": 25.7, "feelslike_f": 78.2, "heatindex_c": 25.7, "heatindex_f": 78.2, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 67, "windchill_c": 23.5, "windchill_f": 74.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 09:00", "cloud": 19, "is_day": 1, "temp_c": 25.2, "temp_f": 77.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.6, "gust_mph": 11.0, "humidity": 73, "wind_dir": "ENE", "wind_kph": 15.1, "wind_mph": 9.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.7, "dewpoint_f": 67.5, "time_epoch": 1721397600, "feelslike_c": 27.1, "feelslike_f": 80.8, "heatindex_c": 27.1, "heatindex_f": 80.8, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 72, "windchill_c": 25.2, "windchill_f": 77.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 10:00", "cloud": 25, "is_day": 1, "temp_c": 26.9, "temp_f": 80.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.2, "gust_mph": 10.0, "humidity": 64, "wind_dir": "ENE", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.5, "dewpoint_f": 67.0, "time_epoch": 1721401200, "feelslike_c": 28.7, "feelslike_f": 83.6, "heatindex_c": 28.7, "heatindex_f": 83.6, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 76, "windchill_c": 26.9, "windchill_f": 80.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 11:00", "cloud": 34, "is_day": 1, "temp_c": 28.5, "temp_f": 83.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.6, "gust_mph": 10.3, "humidity": 57, "wind_dir": "ENE", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.2, "dewpoint_f": 66.5, "time_epoch": 1721404800, "feelslike_c": 30.2, "feelslike_f": 86.4, "heatindex_c": 30.2, "heatindex_f": 86.4, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 76, "windchill_c": 28.5, "windchill_f": 83.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 12:00", "cloud": 73, "is_day": 1, "temp_c": 29.8, "temp_f": 85.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.6, "gust_mph": 11.6, "humidity": 52, "wind_dir": "ENE", "wind_kph": 16.2, "wind_mph": 10.1, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.01, "vis_miles": 6.0, "dewpoint_c": 19.0, "dewpoint_f": 66.2, "time_epoch": 1721408400, "feelslike_c": 31.6, "feelslike_f": 88.8, "heatindex_c": 31.6, "heatindex_f": 88.8, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 78, "windchill_c": 29.8, "windchill_f": 85.7, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 80, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 13:00", "cloud": 35, "is_day": 1, "temp_c": 31.0, "temp_f": 87.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.9, "gust_mph": 12.3, "humidity": 47, "wind_dir": "E", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.4, "time_epoch": 1721412000, "feelslike_c": 32.6, "feelslike_f": 90.6, "heatindex_c": 32.6, "heatindex_f": 90.6, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 80, "windchill_c": 31.0, "windchill_f": 87.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 14:00", "cloud": 38, "is_day": 1, "temp_c": 31.8, "temp_f": 89.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.3, "gust_mph": 12.6, "humidity": 42, "wind_dir": "E", "wind_kph": 17.6, "wind_mph": 11.0, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.7, "dewpoint_f": 63.9, "time_epoch": 1721415600, "feelslike_c": 33.0, "feelslike_f": 91.4, "heatindex_c": 33.0, "heatindex_f": 91.4, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 81, "windchill_c": 31.8, "windchill_f": 89.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 15:00", "cloud": 29, "is_day": 1, "temp_c": 32.2, "temp_f": 90.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.1, "gust_mph": 13.1, "humidity": 39, "wind_dir": "E", "wind_kph": 18.4, "wind_mph": 11.4, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.7, "dewpoint_f": 62.0, "time_epoch": 1721419200, "feelslike_c": 33.2, "feelslike_f": 91.7, "heatindex_c": 33.2, "heatindex_f": 91.7, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 81, "windchill_c": 32.2, "windchill_f": 90.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 16:00", "cloud": 25, "is_day": 1, "temp_c": 32.4, "temp_f": 90.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.0, "gust_mph": 13.6, "humidity": 37, "wind_dir": "E", "wind_kph": 19.1, "wind_mph": 11.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.1, "dewpoint_f": 60.9, "time_epoch": 1721422800, "feelslike_c": 33.2, "feelslike_f": 91.7, "heatindex_c": 33.2, "heatindex_f": 91.7, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 84, "windchill_c": 32.4, "windchill_f": 90.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 17:00", "cloud": 25, "is_day": 1, "temp_c": 32.1, "temp_f": 89.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.8, "gust_mph": 14.2, "humidity": 37, "wind_dir": "E", "wind_kph": 19.8, "wind_mph": 12.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.0, "dewpoint_f": 60.8, "time_epoch": 1721426400, "feelslike_c": 32.8, "feelslike_f": 91.1, "heatindex_c": 32.8, "heatindex_f": 91.1, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 88, "windchill_c": 32.1, "windchill_f": 89.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 18:00", "cloud": 21, "is_day": 1, "temp_c": 31.3, "temp_f": 88.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.4, "gust_mph": 14.5, "humidity": 39, "wind_dir": "E", "wind_kph": 20.2, "wind_mph": 12.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.3, "dewpoint_f": 61.4, "time_epoch": 1721430000, "feelslike_c": 32.1, "feelslike_f": 89.9, "heatindex_c": 32.1, "heatindex_f": 89.9, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 91, "windchill_c": 31.3, "windchill_f": 88.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 19:00", "cloud": 8, "is_day": 1, "temp_c": 29.8, "temp_f": 85.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 26.3, "gust_mph": 16.3, "humidity": 45, "wind_dir": "E", "wind_kph": 20.2, "wind_mph": 12.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.2, "dewpoint_f": 62.9, "time_epoch": 1721433600, "feelslike_c": 30.9, "feelslike_f": 87.6, "heatindex_c": 30.9, "heatindex_f": 87.6, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 94, "windchill_c": 29.8, "windchill_f": 85.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 20:00", "cloud": 4, "is_day": 1, "temp_c": 28.0, "temp_f": 82.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.4, "gust_mph": 15.8, "humidity": 54, "wind_dir": "ESE", "wind_kph": 15.8, "wind_mph": 9.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.3, "dewpoint_f": 64.9, "time_epoch": 1721437200, "feelslike_c": 29.2, "feelslike_f": 84.6, "heatindex_c": 29.2, "heatindex_f": 84.6, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 101, "windchill_c": 28.0, "windchill_f": 82.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 21:00", "cloud": 2, "is_day": 0, "temp_c": 26.6, "temp_f": 79.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.5, "gust_mph": 15.9, "humidity": 63, "wind_dir": "ESE", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.4, "time_epoch": 1721440800, "feelslike_c": 28.0, "feelslike_f": 82.4, "heatindex_c": 28.0, "heatindex_f": 82.4, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 107, "windchill_c": 26.6, "windchill_f": 79.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 22:00", "cloud": 13, "is_day": 0, "temp_c": 25.6, "temp_f": 78.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 24.9, "gust_mph": 15.5, "humidity": 66, "wind_dir": "ESE", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.4, "time_epoch": 1721444400, "feelslike_c": 27.1, "feelslike_f": 80.8, "heatindex_c": 27.1, "heatindex_f": 80.8, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 113, "windchill_c": 25.6, "windchill_f": 78.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 23:00", "cloud": 14, "is_day": 0, "temp_c": 24.8, "temp_f": 76.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.7, "gust_mph": 16.0, "humidity": 69, "wind_dir": "ESE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.5, "dewpoint_f": 65.3, "time_epoch": 1721448000, "feelslike_c": 26.4, "feelslike_f": 79.4, "heatindex_c": 26.4, "heatindex_f": 79.4, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 122, "windchill_c": 24.8, "windchill_f": 76.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:32 PM", "moonset": "04:14 AM", "sunrise": "06:30 AM", "moonrise": "07:37 PM", "is_sun_up": 1, "is_moon_up": 1, "moon_phase": "Waxing Gibbous", "moon_illumination": 92}, "date_epoch": 1721347200}, {"day": {"uv": 9.0, "avgtemp_c": 28.2, "avgtemp_f": 82.7, "avgvis_km": 10.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "maxtemp_c": 35.4, "maxtemp_f": 95.7, "mintemp_c": 21.8, "mintemp_f": 71.2, "avghumidity": 60, "maxwind_kph": 22.7, "maxwind_mph": 14.1, "avgvis_miles": 6.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.0, "totalprecip_mm": 0.0, "daily_will_it_rain": 0, "daily_will_it_snow": 0, "daily_chance_of_rain": 0, "daily_chance_of_snow": 0}, "date": "2024-07-20", "hour": [{"uv": 0, "time": "2024-07-20 00:00", "cloud": 3, "is_day": 0, "temp_c": 24.0, "temp_f": 75.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 26.0, "gust_mph": 16.2, "humidity": 73, "wind_dir": "ESE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.7, "dewpoint_f": 65.7, "time_epoch": 1721451600, "feelslike_c": 25.8, "feelslike_f": 78.4, "heatindex_c": 25.8, "heatindex_f": 78.4, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 120, "windchill_c": 24.0, "windchill_f": 75.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 01:00", "cloud": 3, "is_day": 0, "temp_c": 23.4, "temp_f": 74.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.2, "gust_mph": 15.7, "humidity": 76, "wind_dir": "ESE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.8, "dewpoint_f": 65.8, "time_epoch": 1721455200, "feelslike_c": 25.4, "feelslike_f": 77.7, "heatindex_c": 25.4, "heatindex_f": 77.7, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 119, "windchill_c": 23.4, "windchill_f": 74.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 02:00", "cloud": 4, "is_day": 0, "temp_c": 23.0, "temp_f": 73.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.9, "gust_mph": 14.8, "humidity": 77, "wind_dir": "SE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.5, "dewpoint_f": 65.4, "time_epoch": 1721458800, "feelslike_c": 25.1, "feelslike_f": 77.2, "heatindex_c": 25.1, "heatindex_f": 77.2, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 125, "windchill_c": 23.0, "windchill_f": 73.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 03:00", "cloud": 3, "is_day": 0, "temp_c": 22.6, "temp_f": 72.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.1, "gust_mph": 13.7, "humidity": 78, "wind_dir": "SE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.5, "dewpoint_f": 65.2, "time_epoch": 1721462400, "feelslike_c": 24.9, "feelslike_f": 76.7, "heatindex_c": 24.9, "heatindex_f": 76.7, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 142, "windchill_c": 22.6, "windchill_f": 72.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 04:00", "cloud": 3, "is_day": 0, "temp_c": 22.4, "temp_f": 72.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.5, "gust_mph": 12.7, "humidity": 80, "wind_dir": "SE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.4, "time_epoch": 1721466000, "feelslike_c": 24.7, "feelslike_f": 76.5, "heatindex_c": 24.7, "heatindex_f": 76.5, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 134, "windchill_c": 22.4, "windchill_f": 72.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 05:00", "cloud": 6, "is_day": 0, "temp_c": 22.1, "temp_f": 71.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.5, "gust_mph": 14.0, "humidity": 82, "wind_dir": "SE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.8, "dewpoint_f": 65.8, "time_epoch": 1721469600, "feelslike_c": 24.6, "feelslike_f": 76.2, "heatindex_c": 24.6, "heatindex_f": 76.2, "pressure_in": 29.99, "pressure_mb": 1015.0, "wind_degree": 133, "windchill_c": 22.1, "windchill_f": 71.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 06:00", "cloud": 6, "is_day": 0, "temp_c": 21.9, "temp_f": 71.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.5, "gust_mph": 13.4, "humidity": 85, "wind_dir": "SE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.1, "dewpoint_f": 66.3, "time_epoch": 1721473200, "feelslike_c": 21.9, "feelslike_f": 71.4, "heatindex_c": 24.5, "heatindex_f": 76.1, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 129, "windchill_c": 21.9, "windchill_f": 71.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-20 07:00", "cloud": 4, "is_day": 1, "temp_c": 22.7, "temp_f": 72.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.4, "gust_mph": 11.4, "humidity": 86, "wind_dir": "SE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.3, "dewpoint_f": 66.7, "time_epoch": 1721476800, "feelslike_c": 25.0, "feelslike_f": 77.0, "heatindex_c": 25.0, "heatindex_f": 77.0, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 133, "windchill_c": 22.7, "windchill_f": 72.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-20 08:00", "cloud": 3, "is_day": 1, "temp_c": 24.2, "temp_f": 75.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.7, "gust_mph": 9.8, "humidity": 80, "wind_dir": "ESE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1721480400, "feelslike_c": 26.3, "feelslike_f": 79.3, "heatindex_c": 26.3, "heatindex_f": 79.3, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 116, "windchill_c": 24.2, "windchill_f": 75.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 09:00", "cloud": 2, "is_day": 1, "temp_c": 26.1, "temp_f": 79.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.5, "gust_mph": 9.0, "humidity": 72, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.4, "dewpoint_f": 68.7, "time_epoch": 1721484000, "feelslike_c": 28.2, "feelslike_f": 82.8, "heatindex_c": 28.2, "heatindex_f": 82.8, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 125, "windchill_c": 26.1, "windchill_f": 79.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 10:00", "cloud": 5, "is_day": 1, "temp_c": 27.9, "temp_f": 82.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.9, "gust_mph": 9.3, "humidity": 64, "wind_dir": "SE", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.0, "time_epoch": 1721487600, "feelslike_c": 30.2, "feelslike_f": 86.4, "heatindex_c": 30.2, "heatindex_f": 86.4, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 125, "windchill_c": 27.9, "windchill_f": 82.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 11:00", "cloud": 15, "is_day": 1, "temp_c": 29.6, "temp_f": 85.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 13.7, "gust_mph": 8.5, "humidity": 57, "wind_dir": "SE", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.3, "dewpoint_f": 68.6, "time_epoch": 1721491200, "feelslike_c": 31.9, "feelslike_f": 89.4, "heatindex_c": 31.9, "heatindex_f": 89.4, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 127, "windchill_c": 29.6, "windchill_f": 85.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 12:00", "cloud": 12, "is_day": 1, "temp_c": 31.2, "temp_f": 88.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.7, "humidity": 50, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.6, "dewpoint_f": 67.2, "time_epoch": 1721494800, "feelslike_c": 33.3, "feelslike_f": 92.0, "heatindex_c": 33.3, "heatindex_f": 92.0, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 137, "windchill_c": 31.2, "windchill_f": 88.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 13:00", "cloud": 9, "is_day": 1, "temp_c": 32.6, "temp_f": 90.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 43, "wind_dir": "SE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.5, "dewpoint_f": 65.2, "time_epoch": 1721498400, "feelslike_c": 34.4, "feelslike_f": 93.9, "heatindex_c": 34.4, "heatindex_f": 93.9, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 140, "windchill_c": 32.6, "windchill_f": 90.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 14:00", "cloud": 22, "is_day": 1, "temp_c": 33.7, "temp_f": 92.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.7, "gust_mph": 9.8, "humidity": 38, "wind_dir": "SSE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.6, "dewpoint_f": 63.6, "time_epoch": 1721502000, "feelslike_c": 35.3, "feelslike_f": 95.6, "heatindex_c": 35.3, "heatindex_f": 95.6, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 147, "windchill_c": 33.7, "windchill_f": 92.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 15:00", "cloud": 17, "is_day": 1, "temp_c": 34.5, "temp_f": 94.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.4, "gust_mph": 10.8, "humidity": 35, "wind_dir": "SE", "wind_kph": 15.1, "wind_mph": 9.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.1, "dewpoint_f": 62.7, "time_epoch": 1721505600, "feelslike_c": 35.9, "feelslike_f": 96.7, "heatindex_c": 35.9, "heatindex_f": 96.7, "pressure_in": 29.94, "pressure_mb": 1014.0, "wind_degree": 143, "windchill_c": 34.5, "windchill_f": 94.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 9.0, "time": "2024-07-20 16:00", "cloud": 17, "is_day": 1, "temp_c": 35.0, "temp_f": 94.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.2, "gust_mph": 10.0, "humidity": 33, "wind_dir": "SE", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.6, "dewpoint_f": 61.8, "time_epoch": 1721509200, "feelslike_c": 36.2, "feelslike_f": 97.2, "heatindex_c": 36.2, "heatindex_f": 97.2, "pressure_in": 29.92, "pressure_mb": 1013.0, "wind_degree": 137, "windchill_c": 35.0, "windchill_f": 94.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 9.0, "time": "2024-07-20 17:00", "cloud": 16, "is_day": 1, "temp_c": 35.0, "temp_f": 95.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.5, "gust_mph": 9.0, "humidity": 32, "wind_dir": "SE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.3, "dewpoint_f": 61.3, "time_epoch": 1721512800, "feelslike_c": 36.2, "feelslike_f": 97.1, "heatindex_c": 36.2, "heatindex_f": 97.1, "pressure_in": 29.9, "pressure_mb": 1013.0, "wind_degree": 132, "windchill_c": 35.0, "windchill_f": 95.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 9.0, "time": "2024-07-20 18:00", "cloud": 16, "is_day": 1, "temp_c": 34.6, "temp_f": 94.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.9, "gust_mph": 9.9, "humidity": 33, "wind_dir": "SE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.3, "dewpoint_f": 61.3, "time_epoch": 1721516400, "feelslike_c": 35.8, "feelslike_f": 96.5, "heatindex_c": 35.8, "heatindex_f": 96.5, "pressure_in": 29.89, "pressure_mb": 1012.0, "wind_degree": 124, "windchill_c": 34.6, "windchill_f": 94.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 19:00", "cloud": 16, "is_day": 1, "temp_c": 33.0, "temp_f": 91.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.1, "gust_mph": 13.1, "humidity": 36, "wind_dir": "ESE", "wind_kph": 16.2, "wind_mph": 10.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.0, "dewpoint_f": 62.7, "time_epoch": 1721520000, "feelslike_c": 34.5, "feelslike_f": 94.2, "heatindex_c": 34.5, "heatindex_f": 94.2, "pressure_in": 29.88, "pressure_mb": 1012.0, "wind_degree": 114, "windchill_c": 33.0, "windchill_f": 91.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 20:00", "cloud": 16, "is_day": 1, "temp_c": 31.0, "temp_f": 87.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 29.2, "gust_mph": 18.2, "humidity": 47, "wind_dir": "ESE", "wind_kph": 18.4, "wind_mph": 11.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.7, "dewpoint_f": 65.6, "time_epoch": 1721523600, "feelslike_c": 32.7, "feelslike_f": 90.9, "heatindex_c": 32.7, "heatindex_f": 90.9, "pressure_in": 29.91, "pressure_mb": 1013.0, "wind_degree": 117, "windchill_c": 31.0, "windchill_f": 87.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 21:00", "cloud": 7, "is_day": 0, "temp_c": 29.5, "temp_f": 85.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 39.7, "gust_mph": 24.7, "humidity": 57, "wind_dir": "SE", "wind_kph": 22.7, "wind_mph": 14.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.7, "dewpoint_f": 67.4, "time_epoch": 1721527200, "feelslike_c": 31.3, "feelslike_f": 88.3, "heatindex_c": 31.3, "heatindex_f": 88.3, "pressure_in": 29.91, "pressure_mb": 1013.0, "wind_degree": 128, "windchill_c": 29.5, "windchill_f": 85.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 22:00", "cloud": 9, "is_day": 0, "temp_c": 28.4, "temp_f": 83.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 35.7, "gust_mph": 22.2, "humidity": 61, "wind_dir": "SE", "wind_kph": 19.8, "wind_mph": 12.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.7, "dewpoint_f": 67.5, "time_epoch": 1721530800, "feelslike_c": 30.2, "feelslike_f": 86.3, "heatindex_c": 30.2, "heatindex_f": 86.3, "pressure_in": 29.93, "pressure_mb": 1014.0, "wind_degree": 136, "windchill_c": 28.4, "windchill_f": 83.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 23:00", "cloud": 14, "is_day": 0, "temp_c": 27.6, "temp_f": 81.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 28.5, "gust_mph": 17.7, "humidity": 64, "wind_dir": "SE", "wind_kph": 15.1, "wind_mph": 9.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.0, "dewpoint_f": 68.0, "time_epoch": 1721534400, "feelslike_c": 29.4, "feelslike_f": 84.9, "heatindex_c": 29.4, "heatindex_f": 84.9, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 143, "windchill_c": 27.6, "windchill_f": 81.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:32 PM", "moonset": "05:18 AM", "sunrise": "06:31 AM", "moonrise": "08:30 PM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Waxing Gibbous", "moon_illumination": 97}, "date_epoch": 1721433600}]}, "location": {"lat": 32.97, "lon": -96.3, "name": "Royse City", "tz_id": "America/Chicago", "region": "Texas", "country": "USA", "localtime": "2024-07-18 15:20", "localtime_epoch": 1721334043}}	2024-07-18 20:27:40.958747	1	2024-07-19 12:48:16.621825
4	{"current": {"uv": 6.0, "cloud": 0, "is_day": 1, "temp_c": 22.1, "temp_f": 71.8, "vis_km": 11.0, "gust_kph": 18.9, "gust_mph": 11.8, "humidity": 94, "wind_dir": "N", "wind_kph": 3.6, "wind_mph": 2.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.9, "dewpoint_f": 65.9, "feelslike_c": 24.6, "feelslike_f": 76.2, "heatindex_c": 24.8, "heatindex_f": 76.6, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 10, "windchill_c": 23.0, "windchill_f": 73.4, "last_updated": "2024-07-19 08:00", "last_updated_epoch": 1721394000}, "forecast": {"forecastday": [{"day": {"uv": 10.0, "avgtemp_c": 26.5, "avgtemp_f": 79.7, "avgvis_km": 10.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "maxtemp_c": 33.0, "maxtemp_f": 91.4, "mintemp_c": 20.8, "mintemp_f": 69.4, "avghumidity": 62, "maxwind_kph": 19.4, "maxwind_mph": 12.1, "avgvis_miles": 6.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.0, "totalprecip_mm": 0.0, "daily_will_it_rain": 0, "daily_will_it_snow": 0, "daily_chance_of_rain": 0, "daily_chance_of_snow": 0}, "date": "2024-07-19", "hour": [{"uv": 0, "time": "2024-07-19 00:00", "cloud": 20, "is_day": 0, "temp_c": 23.8, "temp_f": 74.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.1, "gust_mph": 13.8, "humidity": 87, "wind_dir": "E", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.4, "dewpoint_f": 70.5, "time_epoch": 1721365200, "feelslike_c": 25.9, "feelslike_f": 78.7, "heatindex_c": 25.9, "heatindex_f": 78.7, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 86, "windchill_c": 23.8, "windchill_f": 74.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 01:00", "cloud": 19, "is_day": 0, "temp_c": 23.3, "temp_f": 73.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.6, "gust_mph": 12.8, "humidity": 88, "wind_dir": "E", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.1, "dewpoint_f": 70.1, "time_epoch": 1721368800, "feelslike_c": 25.5, "feelslike_f": 77.9, "heatindex_c": 25.5, "heatindex_f": 77.9, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 80, "windchill_c": 23.3, "windchill_f": 73.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 02:00", "cloud": 17, "is_day": 0, "temp_c": 22.9, "temp_f": 73.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.7, "gust_mph": 12.2, "humidity": 89, "wind_dir": "ENE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.9, "dewpoint_f": 69.7, "time_epoch": 1721372400, "feelslike_c": 25.1, "feelslike_f": 77.3, "heatindex_c": 25.1, "heatindex_f": 77.3, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 75, "windchill_c": 22.9, "windchill_f": 73.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 03:00", "cloud": 17, "is_day": 0, "temp_c": 22.5, "temp_f": 72.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.8, "gust_mph": 11.1, "humidity": 89, "wind_dir": "ENE", "wind_kph": 9.4, "wind_mph": 5.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1721376000, "feelslike_c": 24.9, "feelslike_f": 76.8, "heatindex_c": 24.9, "heatindex_f": 76.8, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 73, "windchill_c": 22.5, "windchill_f": 72.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 04:00", "cloud": 16, "is_day": 0, "temp_c": 22.1, "temp_f": 71.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.0, "gust_mph": 11.8, "humidity": 89, "wind_dir": "ENE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1721379600, "feelslike_c": 24.6, "feelslike_f": 76.3, "heatindex_c": 24.6, "heatindex_f": 76.3, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 60, "windchill_c": 22.1, "windchill_f": 71.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 05:00", "cloud": 13, "is_day": 0, "temp_c": 21.6, "temp_f": 70.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.5, "gust_mph": 12.8, "humidity": 89, "wind_dir": "ENE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.9, "dewpoint_f": 67.8, "time_epoch": 1721383200, "feelslike_c": 21.6, "feelslike_f": 70.9, "heatindex_c": 24.4, "heatindex_f": 75.9, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 58, "windchill_c": 21.6, "windchill_f": 70.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 06:00", "cloud": 7, "is_day": 0, "temp_c": 21.2, "temp_f": 70.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.6, "gust_mph": 13.4, "humidity": 90, "wind_dir": "ENE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.3, "dewpoint_f": 66.8, "time_epoch": 1721386800, "feelslike_c": 21.2, "feelslike_f": 70.2, "heatindex_c": 22.6, "heatindex_f": 72.7, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 67, "windchill_c": 21.2, "windchill_f": 70.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-19 07:00", "cloud": 5, "is_day": 1, "temp_c": 21.7, "temp_f": 71.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.9, "gust_mph": 13.6, "humidity": 89, "wind_dir": "ENE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.9, "dewpoint_f": 66.0, "time_epoch": 1721390400, "feelslike_c": 21.7, "feelslike_f": 71.1, "heatindex_c": 23.6, "heatindex_f": 74.5, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 66, "windchill_c": 21.7, "windchill_f": 71.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-19 08:00", "cloud": 0, "is_day": 1, "temp_c": 22.1, "temp_f": 71.8, "vis_km": 11.0, "snow_cm": 0.0, "gust_kph": 18.9, "gust_mph": 11.8, "humidity": 94, "wind_dir": "N", "wind_kph": 3.6, "wind_mph": 2.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.9, "dewpoint_f": 65.9, "time_epoch": 1721394000, "feelslike_c": 24.8, "feelslike_f": 76.6, "heatindex_c": 24.8, "heatindex_f": 76.6, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 10, "windchill_c": 23.0, "windchill_f": 73.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-19 09:00", "cloud": 2, "is_day": 1, "temp_c": 24.7, "temp_f": 76.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.8, "gust_mph": 10.4, "humidity": 71, "wind_dir": "ENE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.8, "dewpoint_f": 65.8, "time_epoch": 1721397600, "feelslike_c": 26.2, "feelslike_f": 79.2, "heatindex_c": 26.2, "heatindex_f": 79.2, "pressure_in": 30.09, "pressure_mb": 1019.0, "wind_degree": 72, "windchill_c": 24.7, "windchill_f": 76.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 10:00", "cloud": 0, "is_day": 1, "temp_c": 26.5, "temp_f": 79.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.7, "gust_mph": 9.8, "humidity": 61, "wind_dir": "ENE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.3, "dewpoint_f": 64.9, "time_epoch": 1721401200, "feelslike_c": 27.7, "feelslike_f": 81.8, "heatindex_c": 27.7, "heatindex_f": 81.8, "pressure_in": 30.08, "pressure_mb": 1019.0, "wind_degree": 78, "windchill_c": 26.5, "windchill_f": 79.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 11:00", "cloud": 0, "is_day": 1, "temp_c": 28.0, "temp_f": 82.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.9, "gust_mph": 9.3, "humidity": 51, "wind_dir": "E", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.3, "dewpoint_f": 63.1, "time_epoch": 1721404800, "feelslike_c": 28.9, "feelslike_f": 84.1, "heatindex_c": 28.9, "heatindex_f": 84.1, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 83, "windchill_c": 28.0, "windchill_f": 82.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 12:00", "cloud": 3, "is_day": 1, "temp_c": 29.4, "temp_f": 84.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.9, "gust_mph": 8.0, "humidity": 45, "wind_dir": "ENE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.5, "dewpoint_f": 61.6, "time_epoch": 1721408400, "feelslike_c": 30.0, "feelslike_f": 86.0, "heatindex_c": 30.0, "heatindex_f": 86.0, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 72, "windchill_c": 29.4, "windchill_f": 84.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 13:00", "cloud": 21, "is_day": 1, "temp_c": 30.7, "temp_f": 87.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.0, "gust_mph": 7.5, "humidity": 39, "wind_dir": "ENE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.4, "dewpoint_f": 59.6, "time_epoch": 1721412000, "feelslike_c": 31.0, "feelslike_f": 87.8, "heatindex_c": 31.0, "heatindex_f": 87.8, "pressure_in": 30.05, "pressure_mb": 1017.0, "wind_degree": 64, "windchill_c": 30.7, "windchill_f": 87.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 14:00", "cloud": 22, "is_day": 1, "temp_c": 31.7, "temp_f": 89.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.9, "gust_mph": 8.0, "humidity": 35, "wind_dir": "ENE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.5, "dewpoint_f": 58.0, "time_epoch": 1721415600, "feelslike_c": 31.8, "feelslike_f": 89.2, "heatindex_c": 31.8, "heatindex_f": 89.2, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 71, "windchill_c": 31.7, "windchill_f": 89.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 15:00", "cloud": 16, "is_day": 1, "temp_c": 32.4, "temp_f": 90.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.4, "gust_mph": 7.7, "humidity": 32, "wind_dir": "E", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.0, "dewpoint_f": 57.3, "time_epoch": 1721419200, "feelslike_c": 32.3, "feelslike_f": 90.1, "heatindex_c": 32.3, "heatindex_f": 90.1, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 80, "windchill_c": 32.4, "windchill_f": 90.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 16:00", "cloud": 14, "is_day": 1, "temp_c": 32.6, "temp_f": 90.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.9, "gust_mph": 8.0, "humidity": 31, "wind_dir": "E", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 13.8, "dewpoint_f": 56.9, "time_epoch": 1721422800, "feelslike_c": 32.5, "feelslike_f": 90.4, "heatindex_c": 32.5, "heatindex_f": 90.4, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 80, "windchill_c": 32.6, "windchill_f": 90.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 17:00", "cloud": 12, "is_day": 1, "temp_c": 32.4, "temp_f": 90.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.5, "gust_mph": 9.0, "humidity": 32, "wind_dir": "E", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 13.9, "dewpoint_f": 57.0, "time_epoch": 1721426400, "feelslike_c": 32.3, "feelslike_f": 90.1, "heatindex_c": 32.3, "heatindex_f": 90.1, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 84, "windchill_c": 32.4, "windchill_f": 90.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 18:00", "cloud": 11, "is_day": 1, "temp_c": 31.5, "temp_f": 88.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.9, "gust_mph": 11.7, "humidity": 34, "wind_dir": "E", "wind_kph": 15.8, "wind_mph": 9.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.5, "dewpoint_f": 58.2, "time_epoch": 1721430000, "feelslike_c": 31.6, "feelslike_f": 89.0, "heatindex_c": 31.6, "heatindex_f": 89.0, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 95, "windchill_c": 31.5, "windchill_f": 88.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 19:00", "cloud": 9, "is_day": 1, "temp_c": 29.7, "temp_f": 85.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.7, "gust_mph": 16.0, "humidity": 40, "wind_dir": "ESE", "wind_kph": 19.4, "wind_mph": 12.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.7, "dewpoint_f": 60.2, "time_epoch": 1721433600, "feelslike_c": 30.2, "feelslike_f": 86.3, "heatindex_c": 30.2, "heatindex_f": 86.3, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 106, "windchill_c": 29.7, "windchill_f": 85.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 20:00", "cloud": 7, "is_day": 1, "temp_c": 27.7, "temp_f": 81.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 28.5, "gust_mph": 17.7, "humidity": 50, "wind_dir": "ESE", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.7, "dewpoint_f": 62.0, "time_epoch": 1721437200, "feelslike_c": 28.4, "feelslike_f": 83.1, "heatindex_c": 28.4, "heatindex_f": 83.1, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 113, "windchill_c": 27.7, "windchill_f": 81.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 21:00", "cloud": 7, "is_day": 0, "temp_c": 26.3, "temp_f": 79.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 29.0, "gust_mph": 18.0, "humidity": 57, "wind_dir": "ESE", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.5, "dewpoint_f": 61.8, "time_epoch": 1721440800, "feelslike_c": 27.2, "feelslike_f": 81.0, "heatindex_c": 27.2, "heatindex_f": 81.0, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 118, "windchill_c": 26.3, "windchill_f": 79.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 22:00", "cloud": 7, "is_day": 0, "temp_c": 25.3, "temp_f": 77.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.7, "gust_mph": 16.0, "humidity": 58, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.1, "dewpoint_f": 61.0, "time_epoch": 1721444400, "feelslike_c": 26.4, "feelslike_f": 79.6, "heatindex_c": 26.4, "heatindex_f": 79.6, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 129, "windchill_c": 25.3, "windchill_f": 77.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 23:00", "cloud": 6, "is_day": 0, "temp_c": 24.6, "temp_f": 76.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 24.2, "gust_mph": 15.0, "humidity": 58, "wind_dir": "SE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.6, "dewpoint_f": 60.0, "time_epoch": 1721448000, "feelslike_c": 25.9, "feelslike_f": 78.6, "heatindex_c": 25.9, "heatindex_f": 78.6, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 135, "windchill_c": 24.6, "windchill_f": 76.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:32 PM", "moonset": "04:14 AM", "sunrise": "06:30 AM", "moonrise": "07:37 PM", "is_sun_up": 1, "is_moon_up": 1, "moon_phase": "Waxing Gibbous", "moon_illumination": 92}, "date_epoch": 1721347200}, {"day": {"uv": 10.0, "avgtemp_c": 27.5, "avgtemp_f": 81.5, "avgvis_km": 10.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "maxtemp_c": 34.3, "maxtemp_f": 93.7, "mintemp_c": 21.1, "mintemp_f": 70.0, "avghumidity": 53, "maxwind_kph": 19.4, "maxwind_mph": 12.1, "avgvis_miles": 6.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.0, "totalprecip_mm": 0.0, "daily_will_it_rain": 0, "daily_will_it_snow": 0, "daily_chance_of_rain": 0, "daily_chance_of_snow": 0}, "date": "2024-07-20", "hour": [{"uv": 0, "time": "2024-07-20 00:00", "cloud": 6, "is_day": 0, "temp_c": 24.0, "temp_f": 75.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.4, "gust_mph": 14.6, "humidity": 58, "wind_dir": "SSE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.2, "dewpoint_f": 59.3, "time_epoch": 1721451600, "feelslike_c": 25.5, "feelslike_f": 77.9, "heatindex_c": 25.5, "heatindex_f": 77.9, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 148, "windchill_c": 24.0, "windchill_f": 75.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 01:00", "cloud": 6, "is_day": 0, "temp_c": 23.5, "temp_f": 74.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.4, "gust_mph": 12.7, "humidity": 59, "wind_dir": "SSE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.9, "dewpoint_f": 58.8, "time_epoch": 1721455200, "feelslike_c": 25.2, "feelslike_f": 77.4, "heatindex_c": 25.2, "heatindex_f": 77.4, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 153, "windchill_c": 23.5, "windchill_f": 74.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 02:00", "cloud": 5, "is_day": 0, "temp_c": 22.9, "temp_f": 73.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.9, "gust_mph": 11.7, "humidity": 60, "wind_dir": "SE", "wind_kph": 9.0, "wind_mph": 5.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.8, "dewpoint_f": 58.7, "time_epoch": 1721458800, "feelslike_c": 24.9, "feelslike_f": 76.9, "heatindex_c": 24.9, "heatindex_f": 76.9, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 134, "windchill_c": 22.9, "windchill_f": 73.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 03:00", "cloud": 3, "is_day": 0, "temp_c": 22.3, "temp_f": 72.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 24.9, "gust_mph": 15.5, "humidity": 63, "wind_dir": "SE", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.9, "dewpoint_f": 58.8, "time_epoch": 1721462400, "feelslike_c": 24.7, "feelslike_f": 76.5, "heatindex_c": 24.7, "heatindex_f": 76.5, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 125, "windchill_c": 22.3, "windchill_f": 72.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 04:00", "cloud": 3, "is_day": 0, "temp_c": 21.9, "temp_f": 71.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.9, "gust_mph": 13.6, "humidity": 67, "wind_dir": "SE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.3, "dewpoint_f": 59.6, "time_epoch": 1721466000, "feelslike_c": 21.9, "feelslike_f": 71.4, "heatindex_c": 24.6, "heatindex_f": 76.2, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 124, "windchill_c": 21.9, "windchill_f": 71.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 05:00", "cloud": 3, "is_day": 0, "temp_c": 21.5, "temp_f": 70.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.4, "gust_mph": 14.6, "humidity": 71, "wind_dir": "SE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.0, "dewpoint_f": 60.7, "time_epoch": 1721469600, "feelslike_c": 21.5, "feelslike_f": 70.8, "heatindex_c": 24.5, "heatindex_f": 76.0, "pressure_in": 29.99, "pressure_mb": 1015.0, "wind_degree": 143, "windchill_c": 21.5, "windchill_f": 70.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 06:00", "cloud": 3, "is_day": 0, "temp_c": 21.3, "temp_f": 70.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.7, "gust_mph": 14.1, "humidity": 75, "wind_dir": "SE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.6, "dewpoint_f": 61.9, "time_epoch": 1721473200, "feelslike_c": 21.3, "feelslike_f": 70.4, "heatindex_c": 24.4, "heatindex_f": 75.9, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 144, "windchill_c": 21.3, "windchill_f": 70.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-20 07:00", "cloud": 2, "is_day": 1, "temp_c": 22.1, "temp_f": 71.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.8, "gust_mph": 14.1, "humidity": 78, "wind_dir": "SE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.2, "dewpoint_f": 62.9, "time_epoch": 1721476800, "feelslike_c": 24.7, "feelslike_f": 76.4, "heatindex_c": 24.7, "heatindex_f": 76.4, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 129, "windchill_c": 22.1, "windchill_f": 71.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-20 08:00", "cloud": 1, "is_day": 1, "temp_c": 23.7, "temp_f": 74.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.5, "gust_mph": 9.6, "humidity": 73, "wind_dir": "SE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.8, "dewpoint_f": 64.1, "time_epoch": 1721480400, "feelslike_c": 25.6, "feelslike_f": 78.2, "heatindex_c": 25.6, "heatindex_f": 78.2, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 138, "windchill_c": 23.7, "windchill_f": 74.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 09:00", "cloud": 3, "is_day": 1, "temp_c": 25.5, "temp_f": 78.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 10.5, "gust_mph": 6.6, "humidity": 65, "wind_dir": "SSE", "wind_kph": 8.6, "wind_mph": 5.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.2, "dewpoint_f": 64.8, "time_epoch": 1721484000, "feelslike_c": 27.2, "feelslike_f": 80.9, "heatindex_c": 27.2, "heatindex_f": 80.9, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 151, "windchill_c": 25.5, "windchill_f": 77.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 10:00", "cloud": 2, "is_day": 1, "temp_c": 27.5, "temp_f": 81.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.0, "gust_mph": 7.5, "humidity": 58, "wind_dir": "SSE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.4, "dewpoint_f": 65.2, "time_epoch": 1721487600, "feelslike_c": 29.0, "feelslike_f": 84.1, "heatindex_c": 29.0, "heatindex_f": 84.1, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 150, "windchill_c": 27.5, "windchill_f": 81.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 11:00", "cloud": 0, "is_day": 1, "temp_c": 29.2, "temp_f": 84.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 13.2, "gust_mph": 8.2, "humidity": 51, "wind_dir": "SSE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.3, "dewpoint_f": 64.9, "time_epoch": 1721491200, "feelslike_c": 30.6, "feelslike_f": 87.1, "heatindex_c": 30.6, "heatindex_f": 87.1, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 147, "windchill_c": 29.2, "windchill_f": 84.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 12:00", "cloud": 0, "is_day": 1, "temp_c": 30.8, "temp_f": 87.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.7, "humidity": 44, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.5, "dewpoint_f": 63.6, "time_epoch": 1721494800, "feelslike_c": 32.0, "feelslike_f": 89.5, "heatindex_c": 32.0, "heatindex_f": 89.5, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 136, "windchill_c": 30.8, "windchill_f": 87.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 13:00", "cloud": 11, "is_day": 1, "temp_c": 32.2, "temp_f": 89.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 39, "wind_dir": "SE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.6, "dewpoint_f": 61.9, "time_epoch": 1721498400, "feelslike_c": 33.0, "feelslike_f": 91.5, "heatindex_c": 33.0, "heatindex_f": 91.5, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 129, "windchill_c": 32.2, "windchill_f": 89.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 14:00", "cloud": 19, "is_day": 1, "temp_c": 33.1, "temp_f": 91.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.0, "gust_mph": 10.6, "humidity": 35, "wind_dir": "SE", "wind_kph": 14.8, "wind_mph": 9.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.8, "dewpoint_f": 60.5, "time_epoch": 1721502000, "feelslike_c": 33.8, "feelslike_f": 92.8, "heatindex_c": 33.8, "heatindex_f": 92.8, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 128, "windchill_c": 33.1, "windchill_f": 91.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 15:00", "cloud": 15, "is_day": 1, "temp_c": 33.7, "temp_f": 92.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.0, "gust_mph": 10.6, "humidity": 33, "wind_dir": "SE", "wind_kph": 14.8, "wind_mph": 9.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.3, "dewpoint_f": 59.6, "time_epoch": 1721505600, "feelslike_c": 34.2, "feelslike_f": 93.5, "heatindex_c": 34.2, "heatindex_f": 93.5, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 128, "windchill_c": 33.7, "windchill_f": 92.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 16:00", "cloud": 13, "is_day": 1, "temp_c": 34.0, "temp_f": 93.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 31, "wind_dir": "SE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.9, "dewpoint_f": 58.7, "time_epoch": 1721509200, "feelslike_c": 34.3, "feelslike_f": 93.7, "heatindex_c": 34.3, "heatindex_f": 93.7, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 125, "windchill_c": 34.0, "windchill_f": 93.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 17:00", "cloud": 12, "is_day": 1, "temp_c": 33.8, "temp_f": 92.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 31, "wind_dir": "ESE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.6, "dewpoint_f": 58.3, "time_epoch": 1721512800, "feelslike_c": 34.1, "feelslike_f": 93.3, "heatindex_c": 34.1, "heatindex_f": 93.3, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 121, "windchill_c": 33.8, "windchill_f": 92.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 18:00", "cloud": 12, "is_day": 1, "temp_c": 33.2, "temp_f": 91.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.0, "gust_mph": 10.6, "humidity": 32, "wind_dir": "ESE", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.7, "dewpoint_f": 58.4, "time_epoch": 1721516400, "feelslike_c": 33.5, "feelslike_f": 92.3, "heatindex_c": 33.5, "heatindex_f": 92.3, "pressure_in": 29.93, "pressure_mb": 1014.0, "wind_degree": 113, "windchill_c": 33.2, "windchill_f": 91.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 19:00", "cloud": 9, "is_day": 1, "temp_c": 31.6, "temp_f": 88.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 24.7, "gust_mph": 15.4, "humidity": 36, "wind_dir": "ESE", "wind_kph": 18.4, "wind_mph": 11.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.5, "dewpoint_f": 59.8, "time_epoch": 1721520000, "feelslike_c": 32.2, "feelslike_f": 89.9, "heatindex_c": 32.2, "heatindex_f": 89.9, "pressure_in": 29.92, "pressure_mb": 1013.0, "wind_degree": 108, "windchill_c": 31.6, "windchill_f": 88.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 20:00", "cloud": 4, "is_day": 1, "temp_c": 29.7, "temp_f": 85.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 32.4, "gust_mph": 20.1, "humidity": 45, "wind_dir": "ESE", "wind_kph": 19.4, "wind_mph": 12.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.9, "dewpoint_f": 62.4, "time_epoch": 1721523600, "feelslike_c": 30.4, "feelslike_f": 86.8, "heatindex_c": 30.4, "heatindex_f": 86.8, "pressure_in": 29.92, "pressure_mb": 1013.0, "wind_degree": 106, "windchill_c": 29.7, "windchill_f": 85.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 21:00", "cloud": 7, "is_day": 0, "temp_c": 28.3, "temp_f": 83.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 26.5, "gust_mph": 16.5, "humidity": 54, "wind_dir": "ESE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.4, "dewpoint_f": 63.4, "time_epoch": 1721527200, "feelslike_c": 29.3, "feelslike_f": 84.7, "heatindex_c": 29.3, "heatindex_f": 84.7, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 114, "windchill_c": 28.3, "windchill_f": 83.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 22:00", "cloud": 6, "is_day": 0, "temp_c": 27.3, "temp_f": 81.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 27.3, "gust_mph": 16.9, "humidity": 57, "wind_dir": "SE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.7, "dewpoint_f": 63.9, "time_epoch": 1721530800, "feelslike_c": 28.5, "feelslike_f": 83.2, "heatindex_c": 28.5, "heatindex_f": 83.2, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 136, "windchill_c": 27.3, "windchill_f": 81.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 23:00", "cloud": 4, "is_day": 0, "temp_c": 26.5, "temp_f": 79.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.9, "gust_mph": 16.1, "humidity": 62, "wind_dir": "SE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.4, "dewpoint_f": 65.0, "time_epoch": 1721534400, "feelslike_c": 27.8, "feelslike_f": 82.0, "heatindex_c": 27.8, "heatindex_f": 82.0, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 132, "windchill_c": 26.5, "windchill_f": 79.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:32 PM", "moonset": "05:18 AM", "sunrise": "06:31 AM", "moonrise": "08:30 PM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Waxing Gibbous", "moon_illumination": 97}, "date_epoch": 1721433600}, {"day": {"uv": 6.0, "avgtemp_c": 27.6, "avgtemp_f": 81.7, "avgvis_km": 9.4, "condition": {"code": 1189, "icon": "//cdn.weatherapi.com/weather/64x64/day/302.png", "text": "Moderate rain"}, "maxtemp_c": 35.9, "maxtemp_f": 96.6, "mintemp_c": 21.9, "mintemp_f": 71.4, "avghumidity": 65, "maxwind_kph": 24.5, "maxwind_mph": 15.2, "avgvis_miles": 5.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.56, "totalprecip_mm": 14.32, "daily_will_it_rain": 1, "daily_will_it_snow": 0, "daily_chance_of_rain": 78, "daily_chance_of_snow": 0}, "date": "2024-07-21", "hour": [{"uv": 0, "time": "2024-07-21 00:00", "cloud": 6, "is_day": 0, "temp_c": 25.9, "temp_f": 78.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.7, "gust_mph": 16.0, "humidity": 65, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.4, "time_epoch": 1721538000, "feelslike_c": 27.3, "feelslike_f": 81.1, "heatindex_c": 27.3, "heatindex_f": 81.1, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 131, "windchill_c": 25.9, "windchill_f": 78.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 01:00", "cloud": 5, "is_day": 0, "temp_c": 25.7, "temp_f": 78.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.8, "gust_mph": 14.8, "humidity": 66, "wind_dir": "SE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.5, "time_epoch": 1721541600, "feelslike_c": 27.1, "feelslike_f": 80.9, "heatindex_c": 27.1, "heatindex_f": 80.9, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 140, "windchill_c": 25.7, "windchill_f": 78.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 02:00", "cloud": 8, "is_day": 0, "temp_c": 25.7, "temp_f": 78.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.0, "gust_mph": 13.6, "humidity": 67, "wind_dir": "SSE", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.9, "dewpoint_f": 66.0, "time_epoch": 1721545200, "feelslike_c": 27.2, "feelslike_f": 81.0, "heatindex_c": 27.2, "heatindex_f": 81.0, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 157, "windchill_c": 25.7, "windchill_f": 78.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 03:00", "cloud": 15, "is_day": 0, "temp_c": 25.2, "temp_f": 77.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.7, "gust_mph": 12.2, "humidity": 68, "wind_dir": "SSE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.3, "dewpoint_f": 66.7, "time_epoch": 1721548800, "feelslike_c": 26.8, "feelslike_f": 80.2, "heatindex_c": 26.8, "heatindex_f": 80.2, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 152, "windchill_c": 25.2, "windchill_f": 77.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 04:00", "cloud": 17, "is_day": 0, "temp_c": 24.6, "temp_f": 76.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.5, "gust_mph": 11.5, "humidity": 74, "wind_dir": "SSE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.6, "dewpoint_f": 67.3, "time_epoch": 1721552400, "feelslike_c": 26.3, "feelslike_f": 79.4, "heatindex_c": 26.3, "heatindex_f": 79.4, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 150, "windchill_c": 24.6, "windchill_f": 76.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 05:00", "cloud": 73, "is_day": 0, "temp_c": 24.1, "temp_f": 75.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.0, "gust_mph": 12.4, "humidity": 77, "wind_dir": "SSE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.05, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.6, "time_epoch": 1721556000, "feelslike_c": 26.0, "feelslike_f": 78.8, "heatindex_c": 26.0, "heatindex_f": 78.8, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 155, "windchill_c": 24.1, "windchill_f": 75.5, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 78, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 06:00", "cloud": 31, "is_day": 0, "temp_c": 24.0, "temp_f": 75.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.5, "gust_mph": 12.1, "humidity": 80, "wind_dir": "S", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.1, "dewpoint_f": 68.2, "time_epoch": 1721559600, "feelslike_c": 25.9, "feelslike_f": 78.6, "heatindex_c": 25.9, "heatindex_f": 78.6, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 173, "windchill_c": 24.0, "windchill_f": 75.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-21 07:00", "cloud": 30, "is_day": 1, "temp_c": 24.8, "temp_f": 76.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.9, "gust_mph": 12.3, "humidity": 81, "wind_dir": "SSE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.3, "dewpoint_f": 68.6, "time_epoch": 1721563200, "feelslike_c": 26.7, "feelslike_f": 80.0, "heatindex_c": 26.7, "heatindex_f": 80.0, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 168, "windchill_c": 24.8, "windchill_f": 76.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 08:00", "cloud": 31, "is_day": 1, "temp_c": 26.3, "temp_f": 79.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.6, "gust_mph": 10.3, "humidity": 75, "wind_dir": "S", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.8, "dewpoint_f": 69.4, "time_epoch": 1721566800, "feelslike_c": 28.3, "feelslike_f": 83.0, "heatindex_c": 28.3, "heatindex_f": 83.0, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 178, "windchill_c": 26.3, "windchill_f": 79.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 09:00", "cloud": 24, "is_day": 1, "temp_c": 28.1, "temp_f": 82.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.7, "gust_mph": 10.4, "humidity": 65, "wind_dir": "SSW", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.7, "dewpoint_f": 69.2, "time_epoch": 1721570400, "feelslike_c": 30.4, "feelslike_f": 86.7, "heatindex_c": 30.4, "heatindex_f": 86.7, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 195, "windchill_c": 28.1, "windchill_f": 82.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 10:00", "cloud": 20, "is_day": 1, "temp_c": 29.8, "temp_f": 85.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.0, "gust_mph": 10.6, "humidity": 57, "wind_dir": "SSW", "wind_kph": 14.8, "wind_mph": 9.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.0, "time_epoch": 1721574000, "feelslike_c": 32.3, "feelslike_f": 90.2, "heatindex_c": 32.3, "heatindex_f": 90.2, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 200, "windchill_c": 29.8, "windchill_f": 85.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 11:00", "cloud": 25, "is_day": 1, "temp_c": 31.1, "temp_f": 88.1, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 16.6, "gust_mph": 10.3, "humidity": 51, "wind_dir": "SSW", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1087, "icon": "//cdn.weatherapi.com/weather/64x64/day/200.png", "text": "Thundery outbreaks in nearby"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 5.0, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1721577600, "feelslike_c": 33.8, "feelslike_f": 92.8, "heatindex_c": 33.8, "heatindex_f": 92.8, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 213, "windchill_c": 31.1, "windchill_f": 88.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-21 12:00", "cloud": 21, "is_day": 1, "temp_c": 32.4, "temp_f": 90.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.2, "gust_mph": 10.0, "humidity": 47, "wind_dir": "SSW", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1721581200, "feelslike_c": 35.0, "feelslike_f": 94.9, "heatindex_c": 35.0, "heatindex_f": 94.9, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 212, "windchill_c": 32.4, "windchill_f": 90.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-21 13:00", "cloud": 20, "is_day": 1, "temp_c": 33.7, "temp_f": 92.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.7, "humidity": 43, "wind_dir": "SSW", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.2, "dewpoint_f": 66.5, "time_epoch": 1721584800, "feelslike_c": 36.1, "feelslike_f": 97.0, "heatindex_c": 36.1, "heatindex_f": 97.0, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 194, "windchill_c": 33.7, "windchill_f": 92.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 14:00", "cloud": 33, "is_day": 1, "temp_c": 34.8, "temp_f": 94.6, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 13.7, "gust_mph": 8.5, "humidity": 38, "wind_dir": "S", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1087, "icon": "//cdn.weatherapi.com/weather/64x64/day/200.png", "text": "Thundery outbreaks in nearby"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 5.0, "dewpoint_c": 18.4, "dewpoint_f": 65.1, "time_epoch": 1721588400, "feelslike_c": 37.0, "feelslike_f": 98.7, "heatindex_c": 37.0, "heatindex_f": 98.7, "pressure_in": 29.93, "pressure_mb": 1014.0, "wind_degree": 181, "windchill_c": 34.8, "windchill_f": 94.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-21 15:00", "cloud": 45, "is_day": 1, "temp_c": 35.1, "temp_f": 95.2, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 14.9, "gust_mph": 9.3, "humidity": 34, "wind_dir": "SSW", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1087, "icon": "//cdn.weatherapi.com/weather/64x64/day/200.png", "text": "Thundery outbreaks in nearby"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 5.0, "dewpoint_c": 17.7, "dewpoint_f": 63.9, "time_epoch": 1721592000, "feelslike_c": 37.1, "feelslike_f": 98.8, "heatindex_c": 37.1, "heatindex_f": 98.8, "pressure_in": 29.9, "pressure_mb": 1013.0, "wind_degree": 195, "windchill_c": 35.1, "windchill_f": 95.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 9.0, "time": "2024-07-21 16:00", "cloud": 30, "is_day": 1, "temp_c": 35.0, "temp_f": 95.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.6, "gust_mph": 10.3, "humidity": 35, "wind_dir": "SSW", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.6, "dewpoint_f": 63.6, "time_epoch": 1721595600, "feelslike_c": 37.0, "feelslike_f": 98.7, "heatindex_c": 37.0, "heatindex_f": 98.7, "pressure_in": 29.88, "pressure_mb": 1012.0, "wind_degree": 200, "windchill_c": 35.0, "windchill_f": 95.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 17:00", "cloud": 48, "is_day": 1, "temp_c": 31.5, "temp_f": 88.8, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 12.1, "gust_mph": 7.5, "humidity": 37, "wind_dir": "S", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1087, "icon": "//cdn.weatherapi.com/weather/64x64/day/200.png", "text": "Thundery outbreaks in nearby"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 5.0, "dewpoint_c": 18.0, "dewpoint_f": 64.3, "time_epoch": 1721599200, "feelslike_c": 33.4, "feelslike_f": 92.0, "heatindex_c": 33.4, "heatindex_f": 92.0, "pressure_in": 29.87, "pressure_mb": 1012.0, "wind_degree": 177, "windchill_c": 31.5, "windchill_f": 88.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-21 18:00", "cloud": 81, "is_day": 1, "temp_c": 27.9, "temp_f": 82.2, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 18.4, "gust_mph": 11.5, "humidity": 59, "wind_dir": "WSW", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.05, "precip_mm": 1.27, "vis_miles": 5.0, "dewpoint_c": 19.2, "dewpoint_f": 66.6, "time_epoch": 1721602800, "feelslike_c": 29.7, "feelslike_f": 85.4, "heatindex_c": 29.7, "heatindex_f": 85.4, "pressure_in": 29.87, "pressure_mb": 1011.0, "wind_degree": 253, "windchill_c": 27.9, "windchill_f": 82.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-21 19:00", "cloud": 85, "is_day": 1, "temp_c": 25.3, "temp_f": 77.6, "vis_km": 8.0, "snow_cm": 0.0, "gust_kph": 16.8, "gust_mph": 10.5, "humidity": 75, "wind_dir": "W", "wind_kph": 9.4, "wind_mph": 5.8, "condition": {"code": 1186, "icon": "//cdn.weatherapi.com/weather/64x64/day/299.png", "text": "Moderate rain at times"}, "precip_in": 0.18, "precip_mm": 4.45, "vis_miles": 4.0, "dewpoint_c": 19.5, "dewpoint_f": 67.2, "time_epoch": 1721606400, "feelslike_c": 27.3, "feelslike_f": 81.2, "heatindex_c": 27.3, "heatindex_f": 81.2, "pressure_in": 29.91, "pressure_mb": 1013.0, "wind_degree": 262, "windchill_c": 25.3, "windchill_f": 77.6, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-21 20:00", "cloud": 88, "is_day": 1, "temp_c": 23.8, "temp_f": 74.8, "vis_km": 7.0, "snow_cm": 0.0, "gust_kph": 18.0, "gust_mph": 11.2, "humidity": 85, "wind_dir": "ENE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1243, "icon": "//cdn.weatherapi.com/weather/64x64/day/356.png", "text": "Moderate or heavy rain shower"}, "precip_in": 0.11, "precip_mm": 2.69, "vis_miles": 4.0, "dewpoint_c": 20.1, "dewpoint_f": 68.2, "time_epoch": 1721610000, "feelslike_c": 26.0, "feelslike_f": 78.8, "heatindex_c": 26.0, "heatindex_f": 78.8, "pressure_in": 29.93, "pressure_mb": 1013.0, "wind_degree": 75, "windchill_c": 23.8, "windchill_f": 74.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 21:00", "cloud": 88, "is_day": 0, "temp_c": 22.8, "temp_f": 73.1, "vis_km": 7.0, "snow_cm": 0.0, "gust_kph": 32.2, "gust_mph": 20.0, "humidity": 91, "wind_dir": "ENE", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1243, "icon": "//cdn.weatherapi.com/weather/64x64/night/356.png", "text": "Moderate or heavy rain shower"}, "precip_in": 0.15, "precip_mm": 3.69, "vis_miles": 4.0, "dewpoint_c": 20.7, "dewpoint_f": 69.3, "time_epoch": 1721613600, "feelslike_c": 25.2, "feelslike_f": 77.4, "heatindex_c": 25.2, "heatindex_f": 77.4, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 57, "windchill_c": 22.8, "windchill_f": 73.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 22:00", "cloud": 51, "is_day": 0, "temp_c": 22.8, "temp_f": 73.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 47.7, "gust_mph": 29.6, "humidity": 95, "wind_dir": "E", "wind_kph": 23.4, "wind_mph": 14.5, "condition": {"code": 1240, "icon": "//cdn.weatherapi.com/weather/64x64/night/353.png", "text": "Light rain shower"}, "precip_in": 0.07, "precip_mm": 1.9, "vis_miles": 6.0, "dewpoint_c": 21.1, "dewpoint_f": 70.0, "time_epoch": 1721617200, "feelslike_c": 25.2, "feelslike_f": 77.3, "heatindex_c": 25.2, "heatindex_f": 77.3, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 79, "windchill_c": 22.8, "windchill_f": 73.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 23:00", "cloud": 86, "is_day": 0, "temp_c": 22.8, "temp_f": 73.0, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 50.0, "gust_mph": 31.1, "humidity": 91, "wind_dir": "E", "wind_kph": 24.5, "wind_mph": 15.2, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.01, "precip_mm": 0.28, "vis_miles": 5.0, "dewpoint_c": 21.3, "dewpoint_f": 70.4, "time_epoch": 1721620800, "feelslike_c": 25.1, "feelslike_f": 77.2, "heatindex_c": 25.1, "heatindex_f": 77.2, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 99, "windchill_c": 22.8, "windchill_f": 73.0, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}], "astro": {"sunset": "08:31 PM", "moonset": "06:28 AM", "sunrise": "06:32 AM", "moonrise": "09:16 PM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Full Moon", "moon_illumination": 100}, "date_epoch": 1721520000}]}, "location": {"lat": 32.97, "lon": -96.3, "name": "Royse City", "tz_id": "America/Chicago", "region": "Texas", "country": "USA", "localtime": "2024-07-19 8:12", "localtime_epoch": 1721394754}}	2024-07-19 13:13:50.271109	1	2024-07-19 13:19:59.56633
5	{"current": {"uv": 6.0, "cloud": 0, "is_day": 1, "temp_c": 22.4, "temp_f": 72.3, "vis_km": 16.0, "gust_kph": 18.9, "gust_mph": 11.8, "humidity": 96, "wind_dir": "N", "wind_kph": 3.6, "wind_mph": 2.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 9.0, "dewpoint_c": 18.9, "dewpoint_f": 65.9, "feelslike_c": 24.7, "feelslike_f": 76.5, "heatindex_c": 24.8, "heatindex_f": 76.6, "pressure_in": 30.11, "pressure_mb": 1020.0, "wind_degree": 10, "windchill_c": 23.0, "windchill_f": 73.4, "last_updated": "2024-07-19 08:15", "last_updated_epoch": 1721394900}, "forecast": {"forecastday": [{"day": {"uv": 10.0, "avgtemp_c": 26.5, "avgtemp_f": 79.7, "avgvis_km": 10.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "maxtemp_c": 33.0, "maxtemp_f": 91.4, "mintemp_c": 20.8, "mintemp_f": 69.4, "avghumidity": 62, "maxwind_kph": 19.4, "maxwind_mph": 12.1, "avgvis_miles": 6.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.0, "totalprecip_mm": 0.0, "daily_will_it_rain": 0, "daily_will_it_snow": 0, "daily_chance_of_rain": 0, "daily_chance_of_snow": 0}, "date": "2024-07-19", "hour": [{"uv": 0, "time": "2024-07-19 00:00", "cloud": 20, "is_day": 0, "temp_c": 23.8, "temp_f": 74.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.1, "gust_mph": 13.8, "humidity": 87, "wind_dir": "E", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.4, "dewpoint_f": 70.5, "time_epoch": 1721365200, "feelslike_c": 25.9, "feelslike_f": 78.7, "heatindex_c": 25.9, "heatindex_f": 78.7, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 86, "windchill_c": 23.8, "windchill_f": 74.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 01:00", "cloud": 19, "is_day": 0, "temp_c": 23.3, "temp_f": 73.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.6, "gust_mph": 12.8, "humidity": 88, "wind_dir": "E", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.1, "dewpoint_f": 70.1, "time_epoch": 1721368800, "feelslike_c": 25.5, "feelslike_f": 77.9, "heatindex_c": 25.5, "heatindex_f": 77.9, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 80, "windchill_c": 23.3, "windchill_f": 73.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 02:00", "cloud": 17, "is_day": 0, "temp_c": 22.9, "temp_f": 73.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.7, "gust_mph": 12.2, "humidity": 89, "wind_dir": "ENE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.9, "dewpoint_f": 69.7, "time_epoch": 1721372400, "feelslike_c": 25.1, "feelslike_f": 77.3, "heatindex_c": 25.1, "heatindex_f": 77.3, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 75, "windchill_c": 22.9, "windchill_f": 73.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 03:00", "cloud": 17, "is_day": 0, "temp_c": 22.5, "temp_f": 72.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.8, "gust_mph": 11.1, "humidity": 89, "wind_dir": "ENE", "wind_kph": 9.4, "wind_mph": 5.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1721376000, "feelslike_c": 24.9, "feelslike_f": 76.8, "heatindex_c": 24.9, "heatindex_f": 76.8, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 73, "windchill_c": 22.5, "windchill_f": 72.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 04:00", "cloud": 16, "is_day": 0, "temp_c": 22.1, "temp_f": 71.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.0, "gust_mph": 11.8, "humidity": 89, "wind_dir": "ENE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1721379600, "feelslike_c": 24.6, "feelslike_f": 76.3, "heatindex_c": 24.6, "heatindex_f": 76.3, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 60, "windchill_c": 22.1, "windchill_f": 71.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 05:00", "cloud": 13, "is_day": 0, "temp_c": 21.6, "temp_f": 70.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.5, "gust_mph": 12.8, "humidity": 89, "wind_dir": "ENE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.9, "dewpoint_f": 67.8, "time_epoch": 1721383200, "feelslike_c": 21.6, "feelslike_f": 70.9, "heatindex_c": 24.4, "heatindex_f": 75.9, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 58, "windchill_c": 21.6, "windchill_f": 70.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 06:00", "cloud": 7, "is_day": 0, "temp_c": 21.2, "temp_f": 70.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.6, "gust_mph": 13.4, "humidity": 90, "wind_dir": "ENE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.3, "dewpoint_f": 66.8, "time_epoch": 1721386800, "feelslike_c": 21.2, "feelslike_f": 70.2, "heatindex_c": 22.6, "heatindex_f": 72.7, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 67, "windchill_c": 21.2, "windchill_f": 70.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-19 07:00", "cloud": 5, "is_day": 1, "temp_c": 21.7, "temp_f": 71.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.9, "gust_mph": 13.6, "humidity": 89, "wind_dir": "ENE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.9, "dewpoint_f": 66.0, "time_epoch": 1721390400, "feelslike_c": 21.7, "feelslike_f": 71.1, "heatindex_c": 23.6, "heatindex_f": 74.5, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 66, "windchill_c": 21.7, "windchill_f": 71.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-19 08:00", "cloud": 0, "is_day": 1, "temp_c": 22.4, "temp_f": 72.3, "vis_km": 16.0, "snow_cm": 0.0, "gust_kph": 18.9, "gust_mph": 11.8, "humidity": 96, "wind_dir": "N", "wind_kph": 3.6, "wind_mph": 2.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 9.0, "dewpoint_c": 18.9, "dewpoint_f": 65.9, "time_epoch": 1721394000, "feelslike_c": 24.8, "feelslike_f": 76.6, "heatindex_c": 24.8, "heatindex_f": 76.6, "pressure_in": 30.11, "pressure_mb": 1020.0, "wind_degree": 10, "windchill_c": 23.0, "windchill_f": 73.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-19 09:00", "cloud": 2, "is_day": 1, "temp_c": 24.7, "temp_f": 76.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.8, "gust_mph": 10.4, "humidity": 71, "wind_dir": "ENE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.8, "dewpoint_f": 65.8, "time_epoch": 1721397600, "feelslike_c": 26.2, "feelslike_f": 79.2, "heatindex_c": 26.2, "heatindex_f": 79.2, "pressure_in": 30.09, "pressure_mb": 1019.0, "wind_degree": 72, "windchill_c": 24.7, "windchill_f": 76.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 10:00", "cloud": 0, "is_day": 1, "temp_c": 26.5, "temp_f": 79.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.7, "gust_mph": 9.8, "humidity": 61, "wind_dir": "ENE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.3, "dewpoint_f": 64.9, "time_epoch": 1721401200, "feelslike_c": 27.7, "feelslike_f": 81.8, "heatindex_c": 27.7, "heatindex_f": 81.8, "pressure_in": 30.08, "pressure_mb": 1019.0, "wind_degree": 78, "windchill_c": 26.5, "windchill_f": 79.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 11:00", "cloud": 0, "is_day": 1, "temp_c": 28.0, "temp_f": 82.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.9, "gust_mph": 9.3, "humidity": 51, "wind_dir": "E", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.3, "dewpoint_f": 63.1, "time_epoch": 1721404800, "feelslike_c": 28.9, "feelslike_f": 84.1, "heatindex_c": 28.9, "heatindex_f": 84.1, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 83, "windchill_c": 28.0, "windchill_f": 82.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 12:00", "cloud": 3, "is_day": 1, "temp_c": 29.4, "temp_f": 84.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.9, "gust_mph": 8.0, "humidity": 45, "wind_dir": "ENE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.5, "dewpoint_f": 61.6, "time_epoch": 1721408400, "feelslike_c": 30.0, "feelslike_f": 86.0, "heatindex_c": 30.0, "heatindex_f": 86.0, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 72, "windchill_c": 29.4, "windchill_f": 84.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 13:00", "cloud": 21, "is_day": 1, "temp_c": 30.7, "temp_f": 87.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.0, "gust_mph": 7.5, "humidity": 39, "wind_dir": "ENE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.4, "dewpoint_f": 59.6, "time_epoch": 1721412000, "feelslike_c": 31.0, "feelslike_f": 87.8, "heatindex_c": 31.0, "heatindex_f": 87.8, "pressure_in": 30.05, "pressure_mb": 1017.0, "wind_degree": 64, "windchill_c": 30.7, "windchill_f": 87.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 14:00", "cloud": 22, "is_day": 1, "temp_c": 31.7, "temp_f": 89.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.9, "gust_mph": 8.0, "humidity": 35, "wind_dir": "ENE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.5, "dewpoint_f": 58.0, "time_epoch": 1721415600, "feelslike_c": 31.8, "feelslike_f": 89.2, "heatindex_c": 31.8, "heatindex_f": 89.2, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 71, "windchill_c": 31.7, "windchill_f": 89.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 15:00", "cloud": 16, "is_day": 1, "temp_c": 32.4, "temp_f": 90.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.4, "gust_mph": 7.7, "humidity": 32, "wind_dir": "E", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.0, "dewpoint_f": 57.3, "time_epoch": 1721419200, "feelslike_c": 32.3, "feelslike_f": 90.1, "heatindex_c": 32.3, "heatindex_f": 90.1, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 80, "windchill_c": 32.4, "windchill_f": 90.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 16:00", "cloud": 14, "is_day": 1, "temp_c": 32.6, "temp_f": 90.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.9, "gust_mph": 8.0, "humidity": 31, "wind_dir": "E", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 13.8, "dewpoint_f": 56.9, "time_epoch": 1721422800, "feelslike_c": 32.5, "feelslike_f": 90.4, "heatindex_c": 32.5, "heatindex_f": 90.4, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 80, "windchill_c": 32.6, "windchill_f": 90.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 17:00", "cloud": 12, "is_day": 1, "temp_c": 32.4, "temp_f": 90.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.5, "gust_mph": 9.0, "humidity": 32, "wind_dir": "E", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 13.9, "dewpoint_f": 57.0, "time_epoch": 1721426400, "feelslike_c": 32.3, "feelslike_f": 90.1, "heatindex_c": 32.3, "heatindex_f": 90.1, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 84, "windchill_c": 32.4, "windchill_f": 90.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 18:00", "cloud": 11, "is_day": 1, "temp_c": 31.5, "temp_f": 88.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.9, "gust_mph": 11.7, "humidity": 34, "wind_dir": "E", "wind_kph": 15.8, "wind_mph": 9.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.5, "dewpoint_f": 58.2, "time_epoch": 1721430000, "feelslike_c": 31.6, "feelslike_f": 89.0, "heatindex_c": 31.6, "heatindex_f": 89.0, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 95, "windchill_c": 31.5, "windchill_f": 88.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-19 19:00", "cloud": 9, "is_day": 1, "temp_c": 29.7, "temp_f": 85.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.7, "gust_mph": 16.0, "humidity": 40, "wind_dir": "ESE", "wind_kph": 19.4, "wind_mph": 12.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.7, "dewpoint_f": 60.2, "time_epoch": 1721433600, "feelslike_c": 30.2, "feelslike_f": 86.3, "heatindex_c": 30.2, "heatindex_f": 86.3, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 106, "windchill_c": 29.7, "windchill_f": 85.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-19 20:00", "cloud": 7, "is_day": 1, "temp_c": 27.7, "temp_f": 81.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 28.5, "gust_mph": 17.7, "humidity": 50, "wind_dir": "ESE", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.7, "dewpoint_f": 62.0, "time_epoch": 1721437200, "feelslike_c": 28.4, "feelslike_f": 83.1, "heatindex_c": 28.4, "heatindex_f": 83.1, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 113, "windchill_c": 27.7, "windchill_f": 81.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 21:00", "cloud": 7, "is_day": 0, "temp_c": 26.3, "temp_f": 79.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 29.0, "gust_mph": 18.0, "humidity": 57, "wind_dir": "ESE", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.5, "dewpoint_f": 61.8, "time_epoch": 1721440800, "feelslike_c": 27.2, "feelslike_f": 81.0, "heatindex_c": 27.2, "heatindex_f": 81.0, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 118, "windchill_c": 26.3, "windchill_f": 79.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 22:00", "cloud": 7, "is_day": 0, "temp_c": 25.3, "temp_f": 77.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.7, "gust_mph": 16.0, "humidity": 58, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.1, "dewpoint_f": 61.0, "time_epoch": 1721444400, "feelslike_c": 26.4, "feelslike_f": 79.6, "heatindex_c": 26.4, "heatindex_f": 79.6, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 129, "windchill_c": 25.3, "windchill_f": 77.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-19 23:00", "cloud": 6, "is_day": 0, "temp_c": 24.6, "temp_f": 76.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 24.2, "gust_mph": 15.0, "humidity": 58, "wind_dir": "SE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.6, "dewpoint_f": 60.0, "time_epoch": 1721448000, "feelslike_c": 25.9, "feelslike_f": 78.6, "heatindex_c": 25.9, "heatindex_f": 78.6, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 135, "windchill_c": 24.6, "windchill_f": 76.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:32 PM", "moonset": "04:14 AM", "sunrise": "06:30 AM", "moonrise": "07:37 PM", "is_sun_up": 1, "is_moon_up": 1, "moon_phase": "Waxing Gibbous", "moon_illumination": 92}, "date_epoch": 1721347200}, {"day": {"uv": 10.0, "avgtemp_c": 27.5, "avgtemp_f": 81.5, "avgvis_km": 10.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "maxtemp_c": 34.3, "maxtemp_f": 93.7, "mintemp_c": 21.1, "mintemp_f": 70.0, "avghumidity": 53, "maxwind_kph": 19.4, "maxwind_mph": 12.1, "avgvis_miles": 6.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.0, "totalprecip_mm": 0.0, "daily_will_it_rain": 0, "daily_will_it_snow": 0, "daily_chance_of_rain": 0, "daily_chance_of_snow": 0}, "date": "2024-07-20", "hour": [{"uv": 0, "time": "2024-07-20 00:00", "cloud": 6, "is_day": 0, "temp_c": 24.0, "temp_f": 75.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.4, "gust_mph": 14.6, "humidity": 58, "wind_dir": "SSE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.2, "dewpoint_f": 59.3, "time_epoch": 1721451600, "feelslike_c": 25.5, "feelslike_f": 77.9, "heatindex_c": 25.5, "heatindex_f": 77.9, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 148, "windchill_c": 24.0, "windchill_f": 75.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 01:00", "cloud": 6, "is_day": 0, "temp_c": 23.5, "temp_f": 74.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.4, "gust_mph": 12.7, "humidity": 59, "wind_dir": "SSE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.9, "dewpoint_f": 58.8, "time_epoch": 1721455200, "feelslike_c": 25.2, "feelslike_f": 77.4, "heatindex_c": 25.2, "heatindex_f": 77.4, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 153, "windchill_c": 23.5, "windchill_f": 74.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 02:00", "cloud": 5, "is_day": 0, "temp_c": 22.9, "temp_f": 73.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.9, "gust_mph": 11.7, "humidity": 60, "wind_dir": "SE", "wind_kph": 9.0, "wind_mph": 5.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.8, "dewpoint_f": 58.7, "time_epoch": 1721458800, "feelslike_c": 24.9, "feelslike_f": 76.9, "heatindex_c": 24.9, "heatindex_f": 76.9, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 134, "windchill_c": 22.9, "windchill_f": 73.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 03:00", "cloud": 3, "is_day": 0, "temp_c": 22.3, "temp_f": 72.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 24.9, "gust_mph": 15.5, "humidity": 63, "wind_dir": "SE", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.9, "dewpoint_f": 58.8, "time_epoch": 1721462400, "feelslike_c": 24.7, "feelslike_f": 76.5, "heatindex_c": 24.7, "heatindex_f": 76.5, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 125, "windchill_c": 22.3, "windchill_f": 72.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 04:00", "cloud": 3, "is_day": 0, "temp_c": 21.9, "temp_f": 71.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.9, "gust_mph": 13.6, "humidity": 67, "wind_dir": "SE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.3, "dewpoint_f": 59.6, "time_epoch": 1721466000, "feelslike_c": 21.9, "feelslike_f": 71.4, "heatindex_c": 24.6, "heatindex_f": 76.2, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 124, "windchill_c": 21.9, "windchill_f": 71.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 05:00", "cloud": 3, "is_day": 0, "temp_c": 21.5, "temp_f": 70.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.4, "gust_mph": 14.6, "humidity": 71, "wind_dir": "SE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.0, "dewpoint_f": 60.7, "time_epoch": 1721469600, "feelslike_c": 21.5, "feelslike_f": 70.8, "heatindex_c": 24.5, "heatindex_f": 76.0, "pressure_in": 29.99, "pressure_mb": 1015.0, "wind_degree": 143, "windchill_c": 21.5, "windchill_f": 70.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 06:00", "cloud": 3, "is_day": 0, "temp_c": 21.3, "temp_f": 70.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.7, "gust_mph": 14.1, "humidity": 75, "wind_dir": "SE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.6, "dewpoint_f": 61.9, "time_epoch": 1721473200, "feelslike_c": 21.3, "feelslike_f": 70.4, "heatindex_c": 24.4, "heatindex_f": 75.9, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 144, "windchill_c": 21.3, "windchill_f": 70.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-20 07:00", "cloud": 2, "is_day": 1, "temp_c": 22.1, "temp_f": 71.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.8, "gust_mph": 14.1, "humidity": 78, "wind_dir": "SE", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.2, "dewpoint_f": 62.9, "time_epoch": 1721476800, "feelslike_c": 24.7, "feelslike_f": 76.4, "heatindex_c": 24.7, "heatindex_f": 76.4, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 129, "windchill_c": 22.1, "windchill_f": 71.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-20 08:00", "cloud": 1, "is_day": 1, "temp_c": 23.7, "temp_f": 74.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.5, "gust_mph": 9.6, "humidity": 73, "wind_dir": "SE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.8, "dewpoint_f": 64.1, "time_epoch": 1721480400, "feelslike_c": 25.6, "feelslike_f": 78.2, "heatindex_c": 25.6, "heatindex_f": 78.2, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 138, "windchill_c": 23.7, "windchill_f": 74.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 09:00", "cloud": 3, "is_day": 1, "temp_c": 25.5, "temp_f": 78.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 10.5, "gust_mph": 6.6, "humidity": 65, "wind_dir": "SSE", "wind_kph": 8.6, "wind_mph": 5.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.2, "dewpoint_f": 64.8, "time_epoch": 1721484000, "feelslike_c": 27.2, "feelslike_f": 80.9, "heatindex_c": 27.2, "heatindex_f": 80.9, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 151, "windchill_c": 25.5, "windchill_f": 77.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 10:00", "cloud": 2, "is_day": 1, "temp_c": 27.5, "temp_f": 81.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.0, "gust_mph": 7.5, "humidity": 58, "wind_dir": "SSE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.4, "dewpoint_f": 65.2, "time_epoch": 1721487600, "feelslike_c": 29.0, "feelslike_f": 84.1, "heatindex_c": 29.0, "heatindex_f": 84.1, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 150, "windchill_c": 27.5, "windchill_f": 81.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 11:00", "cloud": 0, "is_day": 1, "temp_c": 29.2, "temp_f": 84.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 13.2, "gust_mph": 8.2, "humidity": 51, "wind_dir": "SSE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.3, "dewpoint_f": 64.9, "time_epoch": 1721491200, "feelslike_c": 30.6, "feelslike_f": 87.1, "heatindex_c": 30.6, "heatindex_f": 87.1, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 147, "windchill_c": 29.2, "windchill_f": 84.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 12:00", "cloud": 0, "is_day": 1, "temp_c": 30.8, "temp_f": 87.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.7, "humidity": 44, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.5, "dewpoint_f": 63.6, "time_epoch": 1721494800, "feelslike_c": 32.0, "feelslike_f": 89.5, "heatindex_c": 32.0, "heatindex_f": 89.5, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 136, "windchill_c": 30.8, "windchill_f": 87.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 13:00", "cloud": 11, "is_day": 1, "temp_c": 32.2, "temp_f": 89.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 39, "wind_dir": "SE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.6, "dewpoint_f": 61.9, "time_epoch": 1721498400, "feelslike_c": 33.0, "feelslike_f": 91.5, "heatindex_c": 33.0, "heatindex_f": 91.5, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 129, "windchill_c": 32.2, "windchill_f": 89.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 14:00", "cloud": 19, "is_day": 1, "temp_c": 33.1, "temp_f": 91.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.0, "gust_mph": 10.6, "humidity": 35, "wind_dir": "SE", "wind_kph": 14.8, "wind_mph": 9.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.8, "dewpoint_f": 60.5, "time_epoch": 1721502000, "feelslike_c": 33.8, "feelslike_f": 92.8, "heatindex_c": 33.8, "heatindex_f": 92.8, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 128, "windchill_c": 33.1, "windchill_f": 91.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 15:00", "cloud": 15, "is_day": 1, "temp_c": 33.7, "temp_f": 92.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.0, "gust_mph": 10.6, "humidity": 33, "wind_dir": "SE", "wind_kph": 14.8, "wind_mph": 9.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.3, "dewpoint_f": 59.6, "time_epoch": 1721505600, "feelslike_c": 34.2, "feelslike_f": 93.5, "heatindex_c": 34.2, "heatindex_f": 93.5, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 128, "windchill_c": 33.7, "windchill_f": 92.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 16:00", "cloud": 13, "is_day": 1, "temp_c": 34.0, "temp_f": 93.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 31, "wind_dir": "SE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.9, "dewpoint_f": 58.7, "time_epoch": 1721509200, "feelslike_c": 34.3, "feelslike_f": 93.7, "heatindex_c": 34.3, "heatindex_f": 93.7, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 125, "windchill_c": 34.0, "windchill_f": 93.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 17:00", "cloud": 12, "is_day": 1, "temp_c": 33.8, "temp_f": 92.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 31, "wind_dir": "ESE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.6, "dewpoint_f": 58.3, "time_epoch": 1721512800, "feelslike_c": 34.1, "feelslike_f": 93.3, "heatindex_c": 34.1, "heatindex_f": 93.3, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 121, "windchill_c": 33.8, "windchill_f": 92.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 18:00", "cloud": 12, "is_day": 1, "temp_c": 33.2, "temp_f": 91.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.0, "gust_mph": 10.6, "humidity": 32, "wind_dir": "ESE", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 14.7, "dewpoint_f": 58.4, "time_epoch": 1721516400, "feelslike_c": 33.5, "feelslike_f": 92.3, "heatindex_c": 33.5, "heatindex_f": 92.3, "pressure_in": 29.93, "pressure_mb": 1014.0, "wind_degree": 113, "windchill_c": 33.2, "windchill_f": 91.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-20 19:00", "cloud": 9, "is_day": 1, "temp_c": 31.6, "temp_f": 88.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 24.7, "gust_mph": 15.4, "humidity": 36, "wind_dir": "ESE", "wind_kph": 18.4, "wind_mph": 11.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 15.5, "dewpoint_f": 59.8, "time_epoch": 1721520000, "feelslike_c": 32.2, "feelslike_f": 89.9, "heatindex_c": 32.2, "heatindex_f": 89.9, "pressure_in": 29.92, "pressure_mb": 1013.0, "wind_degree": 108, "windchill_c": 31.6, "windchill_f": 88.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-20 20:00", "cloud": 4, "is_day": 1, "temp_c": 29.7, "temp_f": 85.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 32.4, "gust_mph": 20.1, "humidity": 45, "wind_dir": "ESE", "wind_kph": 19.4, "wind_mph": 12.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.9, "dewpoint_f": 62.4, "time_epoch": 1721523600, "feelslike_c": 30.4, "feelslike_f": 86.8, "heatindex_c": 30.4, "heatindex_f": 86.8, "pressure_in": 29.92, "pressure_mb": 1013.0, "wind_degree": 106, "windchill_c": 29.7, "windchill_f": 85.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 21:00", "cloud": 7, "is_day": 0, "temp_c": 28.3, "temp_f": 83.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 26.5, "gust_mph": 16.5, "humidity": 54, "wind_dir": "ESE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.4, "dewpoint_f": 63.4, "time_epoch": 1721527200, "feelslike_c": 29.3, "feelslike_f": 84.7, "heatindex_c": 29.3, "heatindex_f": 84.7, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 114, "windchill_c": 28.3, "windchill_f": 83.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 22:00", "cloud": 6, "is_day": 0, "temp_c": 27.3, "temp_f": 81.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 27.3, "gust_mph": 16.9, "humidity": 57, "wind_dir": "SE", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.7, "dewpoint_f": 63.9, "time_epoch": 1721530800, "feelslike_c": 28.5, "feelslike_f": 83.2, "heatindex_c": 28.5, "heatindex_f": 83.2, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 136, "windchill_c": 27.3, "windchill_f": 81.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-20 23:00", "cloud": 4, "is_day": 0, "temp_c": 26.5, "temp_f": 79.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.9, "gust_mph": 16.1, "humidity": 62, "wind_dir": "SE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.4, "dewpoint_f": 65.0, "time_epoch": 1721534400, "feelslike_c": 27.8, "feelslike_f": 82.0, "heatindex_c": 27.8, "heatindex_f": 82.0, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 132, "windchill_c": 26.5, "windchill_f": 79.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:32 PM", "moonset": "05:18 AM", "sunrise": "06:31 AM", "moonrise": "08:30 PM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Waxing Gibbous", "moon_illumination": 97}, "date_epoch": 1721433600}, {"day": {"uv": 6.0, "avgtemp_c": 27.6, "avgtemp_f": 81.7, "avgvis_km": 9.4, "condition": {"code": 1189, "icon": "//cdn.weatherapi.com/weather/64x64/day/302.png", "text": "Moderate rain"}, "maxtemp_c": 35.9, "maxtemp_f": 96.6, "mintemp_c": 21.9, "mintemp_f": 71.4, "avghumidity": 65, "maxwind_kph": 24.5, "maxwind_mph": 15.2, "avgvis_miles": 5.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.56, "totalprecip_mm": 14.32, "daily_will_it_rain": 1, "daily_will_it_snow": 0, "daily_chance_of_rain": 78, "daily_chance_of_snow": 0}, "date": "2024-07-21", "hour": [{"uv": 0, "time": "2024-07-21 00:00", "cloud": 6, "is_day": 0, "temp_c": 25.9, "temp_f": 78.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.7, "gust_mph": 16.0, "humidity": 65, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.4, "time_epoch": 1721538000, "feelslike_c": 27.3, "feelslike_f": 81.1, "heatindex_c": 27.3, "heatindex_f": 81.1, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 131, "windchill_c": 25.9, "windchill_f": 78.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 01:00", "cloud": 5, "is_day": 0, "temp_c": 25.7, "temp_f": 78.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.8, "gust_mph": 14.8, "humidity": 66, "wind_dir": "SE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.5, "time_epoch": 1721541600, "feelslike_c": 27.1, "feelslike_f": 80.9, "heatindex_c": 27.1, "heatindex_f": 80.9, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 140, "windchill_c": 25.7, "windchill_f": 78.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 02:00", "cloud": 8, "is_day": 0, "temp_c": 25.7, "temp_f": 78.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.0, "gust_mph": 13.6, "humidity": 67, "wind_dir": "SSE", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.9, "dewpoint_f": 66.0, "time_epoch": 1721545200, "feelslike_c": 27.2, "feelslike_f": 81.0, "heatindex_c": 27.2, "heatindex_f": 81.0, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 157, "windchill_c": 25.7, "windchill_f": 78.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 03:00", "cloud": 15, "is_day": 0, "temp_c": 25.2, "temp_f": 77.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.7, "gust_mph": 12.2, "humidity": 68, "wind_dir": "SSE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.3, "dewpoint_f": 66.7, "time_epoch": 1721548800, "feelslike_c": 26.8, "feelslike_f": 80.2, "heatindex_c": 26.8, "heatindex_f": 80.2, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 152, "windchill_c": 25.2, "windchill_f": 77.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 04:00", "cloud": 17, "is_day": 0, "temp_c": 24.6, "temp_f": 76.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.5, "gust_mph": 11.5, "humidity": 74, "wind_dir": "SSE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.6, "dewpoint_f": 67.3, "time_epoch": 1721552400, "feelslike_c": 26.3, "feelslike_f": 79.4, "heatindex_c": 26.3, "heatindex_f": 79.4, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 150, "windchill_c": 24.6, "windchill_f": 76.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 05:00", "cloud": 73, "is_day": 0, "temp_c": 24.1, "temp_f": 75.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.0, "gust_mph": 12.4, "humidity": 77, "wind_dir": "SSE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.05, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.6, "time_epoch": 1721556000, "feelslike_c": 26.0, "feelslike_f": 78.8, "heatindex_c": 26.0, "heatindex_f": 78.8, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 155, "windchill_c": 24.1, "windchill_f": 75.5, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 78, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 06:00", "cloud": 31, "is_day": 0, "temp_c": 24.0, "temp_f": 75.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.5, "gust_mph": 12.1, "humidity": 80, "wind_dir": "S", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.1, "dewpoint_f": 68.2, "time_epoch": 1721559600, "feelslike_c": 25.9, "feelslike_f": 78.6, "heatindex_c": 25.9, "heatindex_f": 78.6, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 173, "windchill_c": 24.0, "windchill_f": 75.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-21 07:00", "cloud": 30, "is_day": 1, "temp_c": 24.8, "temp_f": 76.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.9, "gust_mph": 12.3, "humidity": 81, "wind_dir": "SSE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.3, "dewpoint_f": 68.6, "time_epoch": 1721563200, "feelslike_c": 26.7, "feelslike_f": 80.0, "heatindex_c": 26.7, "heatindex_f": 80.0, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 168, "windchill_c": 24.8, "windchill_f": 76.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 08:00", "cloud": 31, "is_day": 1, "temp_c": 26.3, "temp_f": 79.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.6, "gust_mph": 10.3, "humidity": 75, "wind_dir": "S", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.8, "dewpoint_f": 69.4, "time_epoch": 1721566800, "feelslike_c": 28.3, "feelslike_f": 83.0, "heatindex_c": 28.3, "heatindex_f": 83.0, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 178, "windchill_c": 26.3, "windchill_f": 79.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 09:00", "cloud": 24, "is_day": 1, "temp_c": 28.1, "temp_f": 82.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.7, "gust_mph": 10.4, "humidity": 65, "wind_dir": "SSW", "wind_kph": 13.7, "wind_mph": 8.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.7, "dewpoint_f": 69.2, "time_epoch": 1721570400, "feelslike_c": 30.4, "feelslike_f": 86.7, "heatindex_c": 30.4, "heatindex_f": 86.7, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 195, "windchill_c": 28.1, "windchill_f": 82.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 10:00", "cloud": 20, "is_day": 1, "temp_c": 29.8, "temp_f": 85.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.0, "gust_mph": 10.6, "humidity": 57, "wind_dir": "SSW", "wind_kph": 14.8, "wind_mph": 9.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.0, "time_epoch": 1721574000, "feelslike_c": 32.3, "feelslike_f": 90.2, "heatindex_c": 32.3, "heatindex_f": 90.2, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 200, "windchill_c": 29.8, "windchill_f": 85.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 11:00", "cloud": 25, "is_day": 1, "temp_c": 31.1, "temp_f": 88.1, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 16.6, "gust_mph": 10.3, "humidity": 51, "wind_dir": "SSW", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1087, "icon": "//cdn.weatherapi.com/weather/64x64/day/200.png", "text": "Thundery outbreaks in nearby"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 5.0, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1721577600, "feelslike_c": 33.8, "feelslike_f": 92.8, "heatindex_c": 33.8, "heatindex_f": 92.8, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 213, "windchill_c": 31.1, "windchill_f": 88.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-21 12:00", "cloud": 21, "is_day": 1, "temp_c": 32.4, "temp_f": 90.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.2, "gust_mph": 10.0, "humidity": 47, "wind_dir": "SSW", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1721581200, "feelslike_c": 35.0, "feelslike_f": 94.9, "heatindex_c": 35.0, "heatindex_f": 94.9, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 212, "windchill_c": 32.4, "windchill_f": 90.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-21 13:00", "cloud": 20, "is_day": 1, "temp_c": 33.7, "temp_f": 92.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.7, "humidity": 43, "wind_dir": "SSW", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.2, "dewpoint_f": 66.5, "time_epoch": 1721584800, "feelslike_c": 36.1, "feelslike_f": 97.0, "heatindex_c": 36.1, "heatindex_f": 97.0, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 194, "windchill_c": 33.7, "windchill_f": 92.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 14:00", "cloud": 33, "is_day": 1, "temp_c": 34.8, "temp_f": 94.6, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 13.7, "gust_mph": 8.5, "humidity": 38, "wind_dir": "S", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1087, "icon": "//cdn.weatherapi.com/weather/64x64/day/200.png", "text": "Thundery outbreaks in nearby"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 5.0, "dewpoint_c": 18.4, "dewpoint_f": 65.1, "time_epoch": 1721588400, "feelslike_c": 37.0, "feelslike_f": 98.7, "heatindex_c": 37.0, "heatindex_f": 98.7, "pressure_in": 29.93, "pressure_mb": 1014.0, "wind_degree": 181, "windchill_c": 34.8, "windchill_f": 94.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-21 15:00", "cloud": 45, "is_day": 1, "temp_c": 35.1, "temp_f": 95.2, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 14.9, "gust_mph": 9.3, "humidity": 34, "wind_dir": "SSW", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1087, "icon": "//cdn.weatherapi.com/weather/64x64/day/200.png", "text": "Thundery outbreaks in nearby"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 5.0, "dewpoint_c": 17.7, "dewpoint_f": 63.9, "time_epoch": 1721592000, "feelslike_c": 37.1, "feelslike_f": 98.8, "heatindex_c": 37.1, "heatindex_f": 98.8, "pressure_in": 29.9, "pressure_mb": 1013.0, "wind_degree": 195, "windchill_c": 35.1, "windchill_f": 95.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 9.0, "time": "2024-07-21 16:00", "cloud": 30, "is_day": 1, "temp_c": 35.0, "temp_f": 95.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.6, "gust_mph": 10.3, "humidity": 35, "wind_dir": "SSW", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.6, "dewpoint_f": 63.6, "time_epoch": 1721595600, "feelslike_c": 37.0, "feelslike_f": 98.7, "heatindex_c": 37.0, "heatindex_f": 98.7, "pressure_in": 29.88, "pressure_mb": 1012.0, "wind_degree": 200, "windchill_c": 35.0, "windchill_f": 95.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-21 17:00", "cloud": 48, "is_day": 1, "temp_c": 31.5, "temp_f": 88.8, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 12.1, "gust_mph": 7.5, "humidity": 37, "wind_dir": "S", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1087, "icon": "//cdn.weatherapi.com/weather/64x64/day/200.png", "text": "Thundery outbreaks in nearby"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 5.0, "dewpoint_c": 18.0, "dewpoint_f": 64.3, "time_epoch": 1721599200, "feelslike_c": 33.4, "feelslike_f": 92.0, "heatindex_c": 33.4, "heatindex_f": 92.0, "pressure_in": 29.87, "pressure_mb": 1012.0, "wind_degree": 177, "windchill_c": 31.5, "windchill_f": 88.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-21 18:00", "cloud": 81, "is_day": 1, "temp_c": 27.9, "temp_f": 82.2, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 18.4, "gust_mph": 11.5, "humidity": 59, "wind_dir": "WSW", "wind_kph": 11.2, "wind_mph": 6.9, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.05, "precip_mm": 1.27, "vis_miles": 5.0, "dewpoint_c": 19.2, "dewpoint_f": 66.6, "time_epoch": 1721602800, "feelslike_c": 29.7, "feelslike_f": 85.4, "heatindex_c": 29.7, "heatindex_f": 85.4, "pressure_in": 29.87, "pressure_mb": 1011.0, "wind_degree": 253, "windchill_c": 27.9, "windchill_f": 82.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-21 19:00", "cloud": 85, "is_day": 1, "temp_c": 25.3, "temp_f": 77.6, "vis_km": 8.0, "snow_cm": 0.0, "gust_kph": 16.8, "gust_mph": 10.5, "humidity": 75, "wind_dir": "W", "wind_kph": 9.4, "wind_mph": 5.8, "condition": {"code": 1186, "icon": "//cdn.weatherapi.com/weather/64x64/day/299.png", "text": "Moderate rain at times"}, "precip_in": 0.18, "precip_mm": 4.45, "vis_miles": 4.0, "dewpoint_c": 19.5, "dewpoint_f": 67.2, "time_epoch": 1721606400, "feelslike_c": 27.3, "feelslike_f": 81.2, "heatindex_c": 27.3, "heatindex_f": 81.2, "pressure_in": 29.91, "pressure_mb": 1013.0, "wind_degree": 262, "windchill_c": 25.3, "windchill_f": 77.6, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-21 20:00", "cloud": 88, "is_day": 1, "temp_c": 23.8, "temp_f": 74.8, "vis_km": 7.0, "snow_cm": 0.0, "gust_kph": 18.0, "gust_mph": 11.2, "humidity": 85, "wind_dir": "ENE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1243, "icon": "//cdn.weatherapi.com/weather/64x64/day/356.png", "text": "Moderate or heavy rain shower"}, "precip_in": 0.11, "precip_mm": 2.69, "vis_miles": 4.0, "dewpoint_c": 20.1, "dewpoint_f": 68.2, "time_epoch": 1721610000, "feelslike_c": 26.0, "feelslike_f": 78.8, "heatindex_c": 26.0, "heatindex_f": 78.8, "pressure_in": 29.93, "pressure_mb": 1013.0, "wind_degree": 75, "windchill_c": 23.8, "windchill_f": 74.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 21:00", "cloud": 88, "is_day": 0, "temp_c": 22.8, "temp_f": 73.1, "vis_km": 7.0, "snow_cm": 0.0, "gust_kph": 32.2, "gust_mph": 20.0, "humidity": 91, "wind_dir": "ENE", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1243, "icon": "//cdn.weatherapi.com/weather/64x64/night/356.png", "text": "Moderate or heavy rain shower"}, "precip_in": 0.15, "precip_mm": 3.69, "vis_miles": 4.0, "dewpoint_c": 20.7, "dewpoint_f": 69.3, "time_epoch": 1721613600, "feelslike_c": 25.2, "feelslike_f": 77.4, "heatindex_c": 25.2, "heatindex_f": 77.4, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 57, "windchill_c": 22.8, "windchill_f": 73.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 22:00", "cloud": 51, "is_day": 0, "temp_c": 22.8, "temp_f": 73.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 47.7, "gust_mph": 29.6, "humidity": 95, "wind_dir": "E", "wind_kph": 23.4, "wind_mph": 14.5, "condition": {"code": 1240, "icon": "//cdn.weatherapi.com/weather/64x64/night/353.png", "text": "Light rain shower"}, "precip_in": 0.07, "precip_mm": 1.9, "vis_miles": 6.0, "dewpoint_c": 21.1, "dewpoint_f": 70.0, "time_epoch": 1721617200, "feelslike_c": 25.2, "feelslike_f": 77.3, "heatindex_c": 25.2, "heatindex_f": 77.3, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 79, "windchill_c": 22.8, "windchill_f": 73.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-21 23:00", "cloud": 86, "is_day": 0, "temp_c": 22.8, "temp_f": 73.0, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 50.0, "gust_mph": 31.1, "humidity": 91, "wind_dir": "E", "wind_kph": 24.5, "wind_mph": 15.2, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.01, "precip_mm": 0.28, "vis_miles": 5.0, "dewpoint_c": 21.3, "dewpoint_f": 70.4, "time_epoch": 1721620800, "feelslike_c": 25.1, "feelslike_f": 77.2, "heatindex_c": 25.1, "heatindex_f": 77.2, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 99, "windchill_c": 22.8, "windchill_f": 73.0, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}], "astro": {"sunset": "08:31 PM", "moonset": "06:28 AM", "sunrise": "06:32 AM", "moonrise": "09:16 PM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Full Moon", "moon_illumination": 100}, "date_epoch": 1721520000}]}, "location": {"lat": 32.97, "lon": -96.3, "name": "Royse City", "tz_id": "America/Chicago", "region": "Texas", "country": "USA", "localtime": "2024-07-19 8:19", "localtime_epoch": 1721395172}}	2024-07-19 13:20:48.628347	1	2024-07-23 19:05:23.337798
6	{"current": {"uv": 7.0, "cloud": 76, "is_day": 1, "temp_c": 29.8, "temp_f": 85.7, "vis_km": 10.0, "gust_kph": 4.6, "gust_mph": 2.8, "humidity": 48, "wind_dir": "SSW", "wind_kph": 4.0, "wind_mph": 2.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.06, "vis_miles": 6.0, "dewpoint_c": 18.1, "dewpoint_f": 64.5, "feelslike_c": 31.2, "feelslike_f": 88.1, "heatindex_c": 31.2, "heatindex_f": 88.1, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 196, "windchill_c": 29.8, "windchill_f": 85.7, "last_updated": "2024-07-23 14:00", "last_updated_epoch": 1721761200}, "forecast": {"forecastday": [{"day": {"uv": 9.0, "avgtemp_c": 23.9, "avgtemp_f": 75.0, "avgvis_km": 7.2, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "maxtemp_c": 30.5, "maxtemp_f": 86.9, "mintemp_c": 18.6, "mintemp_f": 65.6, "avghumidity": 76, "maxwind_kph": 5.4, "maxwind_mph": 3.4, "avgvis_miles": 4.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.06, "totalprecip_mm": 1.43, "daily_will_it_rain": 1, "daily_will_it_snow": 0, "daily_chance_of_rain": 89, "daily_chance_of_snow": 0}, "date": "2024-07-23", "hour": [{"uv": 0, "time": "2024-07-23 00:00", "cloud": 12, "is_day": 0, "temp_c": 19.9, "temp_f": 67.9, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 7.6, "gust_mph": 4.7, "humidity": 94, "wind_dir": "ENE", "wind_kph": 3.6, "wind_mph": 2.2, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 18.9, "dewpoint_f": 66.0, "time_epoch": 1721710800, "feelslike_c": 19.9, "feelslike_f": 67.9, "heatindex_c": 20.0, "heatindex_f": 68.0, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 63, "windchill_c": 19.9, "windchill_f": 67.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-23 01:00", "cloud": 19, "is_day": 0, "temp_c": 19.7, "temp_f": 67.4, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 7.6, "gust_mph": 4.7, "humidity": 95, "wind_dir": "ENE", "wind_kph": 3.6, "wind_mph": 2.2, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 18.9, "dewpoint_f": 65.9, "time_epoch": 1721714400, "feelslike_c": 19.7, "feelslike_f": 67.4, "heatindex_c": 19.7, "heatindex_f": 67.5, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 56, "windchill_c": 19.7, "windchill_f": 67.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-23 02:00", "cloud": 9, "is_day": 0, "temp_c": 19.5, "temp_f": 67.0, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 8.2, "gust_mph": 5.1, "humidity": 96, "wind_dir": "NE", "wind_kph": 4.0, "wind_mph": 2.5, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 18.7, "dewpoint_f": 65.7, "time_epoch": 1721718000, "feelslike_c": 19.5, "feelslike_f": 67.0, "heatindex_c": 19.5, "heatindex_f": 67.1, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 39, "windchill_c": 19.5, "windchill_f": 67.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-23 03:00", "cloud": 11, "is_day": 0, "temp_c": 19.3, "temp_f": 66.7, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 5.2, "gust_mph": 3.2, "humidity": 96, "wind_dir": "NE", "wind_kph": 2.5, "wind_mph": 1.6, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 18.5, "dewpoint_f": 65.4, "time_epoch": 1721721600, "feelslike_c": 19.3, "feelslike_f": 66.7, "heatindex_c": 19.3, "heatindex_f": 66.7, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 37, "windchill_c": 19.3, "windchill_f": 66.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-23 04:00", "cloud": 14, "is_day": 0, "temp_c": 19.1, "temp_f": 66.3, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 4.4, "gust_mph": 2.8, "humidity": 96, "wind_dir": "NE", "wind_kph": 2.2, "wind_mph": 1.3, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 18.4, "dewpoint_f": 65.0, "time_epoch": 1721725200, "feelslike_c": 19.1, "feelslike_f": 66.3, "heatindex_c": 19.1, "heatindex_f": 66.3, "pressure_in": 29.99, "pressure_mb": 1015.0, "wind_degree": 54, "windchill_c": 19.1, "windchill_f": 66.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-23 05:00", "cloud": 20, "is_day": 0, "temp_c": 18.8, "temp_f": 65.9, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 4.4, "gust_mph": 2.7, "humidity": 96, "wind_dir": "ENE", "wind_kph": 2.2, "wind_mph": 1.3, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 18.2, "dewpoint_f": 64.8, "time_epoch": 1721728800, "feelslike_c": 18.8, "feelslike_f": 65.9, "heatindex_c": 18.9, "heatindex_f": 65.9, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 75, "windchill_c": 18.8, "windchill_f": 65.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-23 06:00", "cloud": 25, "is_day": 0, "temp_c": 19.0, "temp_f": 66.1, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 5.7, "gust_mph": 3.6, "humidity": 97, "wind_dir": "E", "wind_kph": 2.9, "wind_mph": 1.8, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 18.1, "dewpoint_f": 64.5, "time_epoch": 1721732400, "feelslike_c": 19.0, "feelslike_f": 66.1, "heatindex_c": 19.0, "heatindex_f": 66.1, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 88, "windchill_c": 19.0, "windchill_f": 66.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 4.0, "time": "2024-07-23 07:00", "cloud": 32, "is_day": 1, "temp_c": 19.9, "temp_f": 67.8, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 2.6, "gust_mph": 1.6, "humidity": 96, "wind_dir": "ENE", "wind_kph": 1.4, "wind_mph": 0.9, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/day/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 18.5, "dewpoint_f": 65.3, "time_epoch": 1721736000, "feelslike_c": 19.9, "feelslike_f": 67.8, "heatindex_c": 19.9, "heatindex_f": 67.8, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 64, "windchill_c": 19.9, "windchill_f": 67.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-23 08:00", "cloud": 33, "is_day": 1, "temp_c": 21.3, "temp_f": 70.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 1.5, "gust_mph": 1.0, "humidity": 93, "wind_dir": "NE", "wind_kph": 1.1, "wind_mph": 0.7, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.6, "dewpoint_f": 67.2, "time_epoch": 1721739600, "feelslike_c": 21.3, "feelslike_f": 70.4, "heatindex_c": 22.4, "heatindex_f": 72.4, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 52, "windchill_c": 21.3, "windchill_f": 70.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-23 09:00", "cloud": 72, "is_day": 1, "temp_c": 22.9, "temp_f": 73.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 2.9, "gust_mph": 1.8, "humidity": 86, "wind_dir": "ESE", "wind_kph": 2.5, "wind_mph": 1.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.06, "vis_miles": 6.0, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1721743200, "feelslike_c": 24.4, "feelslike_f": 75.9, "heatindex_c": 24.4, "heatindex_f": 75.9, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 117, "windchill_c": 22.9, "windchill_f": 73.2, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-23 10:00", "cloud": 82, "is_day": 1, "temp_c": 24.7, "temp_f": 76.4, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 4.7, "gust_mph": 2.9, "humidity": 79, "wind_dir": "SSE", "wind_kph": 4.0, "wind_mph": 2.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.03, "precip_mm": 0.68, "vis_miles": 5.0, "dewpoint_c": 20.6, "dewpoint_f": 69.0, "time_epoch": 1721746800, "feelslike_c": 26.5, "feelslike_f": 79.7, "heatindex_c": 26.5, "heatindex_f": 79.7, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 156, "windchill_c": 24.7, "windchill_f": 76.4, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-23 11:00", "cloud": 89, "is_day": 1, "temp_c": 26.5, "temp_f": 79.6, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 3.3, "gust_mph": 2.1, "humidity": 73, "wind_dir": "S", "wind_kph": 2.5, "wind_mph": 1.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.02, "precip_mm": 0.39, "vis_miles": 5.0, "dewpoint_c": 21.1, "dewpoint_f": 70.0, "time_epoch": 1721750400, "feelslike_c": 28.5, "feelslike_f": 83.3, "heatindex_c": 28.5, "heatindex_f": 83.3, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 184, "windchill_c": 26.5, "windchill_f": 79.6, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-23 12:00", "cloud": 71, "is_day": 1, "temp_c": 27.9, "temp_f": 82.3, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 1.5, "gust_mph": 0.9, "humidity": 63, "wind_dir": "NNW", "wind_kph": 1.1, "wind_mph": 0.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.01, "precip_mm": 0.18, "vis_miles": 5.0, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1721754000, "feelslike_c": 29.8, "feelslike_f": 85.7, "heatindex_c": 29.8, "heatindex_f": 85.7, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 332, "windchill_c": 27.9, "windchill_f": 82.3, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-23 13:00", "cloud": 52, "is_day": 1, "temp_c": 29.1, "temp_f": 84.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 3.0, "gust_mph": 1.9, "humidity": 54, "wind_dir": "SSE", "wind_kph": 2.2, "wind_mph": 1.3, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.04, "vis_miles": 6.0, "dewpoint_c": 19.2, "dewpoint_f": 66.6, "time_epoch": 1721757600, "feelslike_c": 30.8, "feelslike_f": 87.4, "heatindex_c": 30.8, "heatindex_f": 87.4, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 154, "windchill_c": 29.1, "windchill_f": 84.4, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 82, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-23 14:00", "cloud": 76, "is_day": 1, "temp_c": 29.8, "temp_f": 85.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 4.6, "gust_mph": 2.8, "humidity": 48, "wind_dir": "SSW", "wind_kph": 4.0, "wind_mph": 2.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.06, "vis_miles": 6.0, "dewpoint_c": 18.1, "dewpoint_f": 64.5, "time_epoch": 1721761200, "feelslike_c": 31.2, "feelslike_f": 88.1, "heatindex_c": 31.2, "heatindex_f": 88.1, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 196, "windchill_c": 29.8, "windchill_f": 85.7, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-23 15:00", "cloud": 65, "is_day": 1, "temp_c": 29.8, "temp_f": 85.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 4.1, "gust_mph": 2.6, "humidity": 45, "wind_dir": "SW", "wind_kph": 3.6, "wind_mph": 2.2, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.02, "vis_miles": 6.0, "dewpoint_c": 17.4, "dewpoint_f": 63.3, "time_epoch": 1721764800, "feelslike_c": 31.0, "feelslike_f": 87.7, "heatindex_c": 31.0, "heatindex_f": 87.7, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 229, "windchill_c": 29.8, "windchill_f": 85.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 61, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-23 16:00", "cloud": 79, "is_day": 1, "temp_c": 29.1, "temp_f": 84.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 4.4, "gust_mph": 2.7, "humidity": 47, "wind_dir": "WNW", "wind_kph": 3.2, "wind_mph": 2.0, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.01, "vis_miles": 6.0, "dewpoint_c": 17.2, "dewpoint_f": 63.0, "time_epoch": 1721768400, "feelslike_c": 30.2, "feelslike_f": 86.4, "heatindex_c": 30.2, "heatindex_f": 86.4, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 299, "windchill_c": 29.1, "windchill_f": 84.3, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 74, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-23 17:00", "cloud": 74, "is_day": 1, "temp_c": 28.3, "temp_f": 82.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 7.1, "gust_mph": 4.4, "humidity": 53, "wind_dir": "NNW", "wind_kph": 4.3, "wind_mph": 2.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.01, "vis_miles": 6.0, "dewpoint_c": 18.0, "dewpoint_f": 64.3, "time_epoch": 1721772000, "feelslike_c": 29.5, "feelslike_f": 85.0, "heatindex_c": 29.5, "heatindex_f": 85.0, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 331, "windchill_c": 28.2, "windchill_f": 82.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 80, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-23 18:00", "cloud": 24, "is_day": 1, "temp_c": 27.4, "temp_f": 81.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 3.9, "gust_mph": 2.4, "humidity": 58, "wind_dir": "NNE", "wind_kph": 2.2, "wind_mph": 1.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.4, "dewpoint_f": 65.1, "time_epoch": 1721775600, "feelslike_c": 28.7, "feelslike_f": 83.7, "heatindex_c": 28.7, "heatindex_f": 83.7, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 21, "windchill_c": 27.4, "windchill_f": 81.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-23 19:00", "cloud": 19, "is_day": 1, "temp_c": 26.3, "temp_f": 79.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 4.9, "gust_mph": 3.1, "humidity": 63, "wind_dir": "E", "wind_kph": 2.5, "wind_mph": 1.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.0, "dewpoint_f": 66.1, "time_epoch": 1721779200, "feelslike_c": 27.7, "feelslike_f": 81.8, "heatindex_c": 27.7, "heatindex_f": 81.8, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 80, "windchill_c": 26.3, "windchill_f": 79.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-23 20:00", "cloud": 16, "is_day": 1, "temp_c": 24.9, "temp_f": 76.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 8.3, "gust_mph": 5.2, "humidity": 67, "wind_dir": "E", "wind_kph": 4.0, "wind_mph": 2.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.5, "time_epoch": 1721782800, "feelslike_c": 26.5, "feelslike_f": 79.7, "heatindex_c": 26.5, "heatindex_f": 79.7, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 100, "windchill_c": 24.9, "windchill_f": 76.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-23 21:00", "cloud": 17, "is_day": 0, "temp_c": 24.0, "temp_f": 75.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 9.8, "gust_mph": 6.1, "humidity": 70, "wind_dir": "E", "wind_kph": 4.7, "wind_mph": 2.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.8, "dewpoint_f": 64.1, "time_epoch": 1721786400, "feelslike_c": 25.8, "feelslike_f": 78.5, "heatindex_c": 25.8, "heatindex_f": 78.5, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 82, "windchill_c": 24.0, "windchill_f": 75.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-23 22:00", "cloud": 19, "is_day": 0, "temp_c": 23.4, "temp_f": 74.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.3, "gust_mph": 7.0, "humidity": 74, "wind_dir": "NE", "wind_kph": 5.4, "wind_mph": 3.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.3, "dewpoint_f": 65.0, "time_epoch": 1721790000, "feelslike_c": 25.4, "feelslike_f": 77.7, "heatindex_c": 25.4, "heatindex_f": 77.7, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 54, "windchill_c": 23.4, "windchill_f": 74.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-23 23:00", "cloud": 18, "is_day": 0, "temp_c": 22.8, "temp_f": 73.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 10.6, "gust_mph": 6.6, "humidity": 77, "wind_dir": "NE", "wind_kph": 5.0, "wind_mph": 3.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.6, "dewpoint_f": 65.6, "time_epoch": 1721793600, "feelslike_c": 25.0, "feelslike_f": 77.0, "heatindex_c": 25.0, "heatindex_f": 77.0, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 54, "windchill_c": 22.8, "windchill_f": 73.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:28 PM", "moonset": "08:41 AM", "sunrise": "06:19 AM", "moonrise": "10:24 PM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Waning Gibbous", "moon_illumination": 97}, "date_epoch": 1721692800}, {"day": {"uv": 9.0, "avgtemp_c": 25.6, "avgtemp_f": 78.1, "avgvis_km": 10.0, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "maxtemp_c": 32.8, "maxtemp_f": 91.1, "mintemp_c": 21.0, "mintemp_f": 69.8, "avghumidity": 68, "maxwind_kph": 8.3, "maxwind_mph": 5.1, "avgvis_miles": 6.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.0, "totalprecip_mm": 0.0, "daily_will_it_rain": 0, "daily_will_it_snow": 0, "daily_chance_of_rain": 0, "daily_chance_of_snow": 0}, "date": "2024-07-24", "hour": [{"uv": 0, "time": "2024-07-24 00:00", "cloud": 16, "is_day": 0, "temp_c": 22.3, "temp_f": 72.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 10.5, "gust_mph": 6.5, "humidity": 80, "wind_dir": "ENE", "wind_kph": 5.0, "wind_mph": 3.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.7, "dewpoint_f": 65.7, "time_epoch": 1721797200, "feelslike_c": 24.7, "feelslike_f": 76.5, "heatindex_c": 24.7, "heatindex_f": 76.5, "pressure_in": 30.05, "pressure_mb": 1017.0, "wind_degree": 61, "windchill_c": 22.3, "windchill_f": 72.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-24 01:00", "cloud": 16, "is_day": 0, "temp_c": 21.8, "temp_f": 71.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 9.4, "gust_mph": 5.9, "humidity": 83, "wind_dir": "ENE", "wind_kph": 4.7, "wind_mph": 2.9, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.7, "dewpoint_f": 65.7, "time_epoch": 1721800800, "feelslike_c": 21.8, "feelslike_f": 71.3, "heatindex_c": 24.5, "heatindex_f": 76.1, "pressure_in": 30.05, "pressure_mb": 1017.0, "wind_degree": 78, "windchill_c": 21.8, "windchill_f": 71.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-24 02:00", "cloud": 18, "is_day": 0, "temp_c": 21.4, "temp_f": 70.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 8.4, "gust_mph": 5.2, "humidity": 86, "wind_dir": "E", "wind_kph": 4.3, "wind_mph": 2.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.8, "dewpoint_f": 65.9, "time_epoch": 1721804400, "feelslike_c": 21.4, "feelslike_f": 70.5, "heatindex_c": 24.3, "heatindex_f": 75.8, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 86, "windchill_c": 21.4, "windchill_f": 70.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-24 03:00", "cloud": 18, "is_day": 0, "temp_c": 21.3, "temp_f": 70.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 8.2, "gust_mph": 5.1, "humidity": 88, "wind_dir": "E", "wind_kph": 4.3, "wind_mph": 2.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.9, "dewpoint_f": 66.1, "time_epoch": 1721808000, "feelslike_c": 21.3, "feelslike_f": 70.4, "heatindex_c": 24.3, "heatindex_f": 75.7, "pressure_in": 30.05, "pressure_mb": 1017.0, "wind_degree": 79, "windchill_c": 21.3, "windchill_f": 70.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-24 04:00", "cloud": 26, "is_day": 0, "temp_c": 21.3, "temp_f": 70.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 7.0, "gust_mph": 4.3, "humidity": 87, "wind_dir": "ENE", "wind_kph": 4.0, "wind_mph": 2.5, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.0, "dewpoint_f": 66.2, "time_epoch": 1721811600, "feelslike_c": 21.4, "feelslike_f": 70.4, "heatindex_c": 24.3, "heatindex_f": 75.7, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 78, "windchill_c": 21.4, "windchill_f": 70.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-24 05:00", "cloud": 33, "is_day": 0, "temp_c": 21.3, "temp_f": 70.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 5.4, "gust_mph": 3.4, "humidity": 87, "wind_dir": "E", "wind_kph": 3.2, "wind_mph": 2.0, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.1, "dewpoint_f": 66.3, "time_epoch": 1721815200, "feelslike_c": 21.3, "feelslike_f": 70.4, "heatindex_c": 24.3, "heatindex_f": 75.7, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 82, "windchill_c": 21.3, "windchill_f": 70.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-24 06:00", "cloud": 36, "is_day": 0, "temp_c": 21.5, "temp_f": 70.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 4.2, "gust_mph": 2.6, "humidity": 87, "wind_dir": "E", "wind_kph": 2.5, "wind_mph": 1.6, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.1, "dewpoint_f": 66.3, "time_epoch": 1721818800, "feelslike_c": 21.5, "feelslike_f": 70.6, "heatindex_c": 24.3, "heatindex_f": 75.7, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 88, "windchill_c": 21.5, "windchill_f": 70.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-24 07:00", "cloud": 37, "is_day": 1, "temp_c": 22.1, "temp_f": 71.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 2.3, "gust_mph": 1.4, "humidity": 87, "wind_dir": "ENE", "wind_kph": 1.4, "wind_mph": 0.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.3, "dewpoint_f": 66.7, "time_epoch": 1721822400, "feelslike_c": 24.6, "feelslike_f": 76.2, "heatindex_c": 24.6, "heatindex_f": 76.2, "pressure_in": 30.08, "pressure_mb": 1019.0, "wind_degree": 60, "windchill_c": 22.1, "windchill_f": 71.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-24 08:00", "cloud": 29, "is_day": 1, "temp_c": 23.3, "temp_f": 73.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 2.0, "gust_mph": 1.2, "humidity": 83, "wind_dir": "NE", "wind_kph": 1.4, "wind_mph": 0.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.6, "dewpoint_f": 67.3, "time_epoch": 1721826000, "feelslike_c": 25.4, "feelslike_f": 77.8, "heatindex_c": 25.4, "heatindex_f": 77.8, "pressure_in": 30.11, "pressure_mb": 1020.0, "wind_degree": 49, "windchill_c": 23.3, "windchill_f": 73.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-24 09:00", "cloud": 20, "is_day": 1, "temp_c": 24.8, "temp_f": 76.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 0.4, "gust_mph": 0.3, "humidity": 76, "wind_dir": "SE", "wind_kph": 0.4, "wind_mph": 0.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.9, "dewpoint_f": 67.8, "time_epoch": 1721829600, "feelslike_c": 26.7, "feelslike_f": 80.1, "heatindex_c": 26.7, "heatindex_f": 80.1, "pressure_in": 30.11, "pressure_mb": 1020.0, "wind_degree": 134, "windchill_c": 24.8, "windchill_f": 76.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-24 10:00", "cloud": 9, "is_day": 1, "temp_c": 26.6, "temp_f": 79.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 2.9, "gust_mph": 1.8, "humidity": 70, "wind_dir": "SSW", "wind_kph": 2.5, "wind_mph": 1.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.2, "dewpoint_f": 68.4, "time_epoch": 1721833200, "feelslike_c": 28.7, "feelslike_f": 83.7, "heatindex_c": 28.7, "heatindex_f": 83.7, "pressure_in": 30.11, "pressure_mb": 1020.0, "wind_degree": 194, "windchill_c": 26.6, "windchill_f": 79.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-24 11:00", "cloud": 16, "is_day": 1, "temp_c": 28.5, "temp_f": 83.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 3.7, "gust_mph": 2.3, "humidity": 62, "wind_dir": "SSW", "wind_kph": 3.2, "wind_mph": 2.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.5, "dewpoint_f": 68.8, "time_epoch": 1721836800, "feelslike_c": 30.6, "feelslike_f": 87.1, "heatindex_c": 30.6, "heatindex_f": 87.1, "pressure_in": 30.1, "pressure_mb": 1019.0, "wind_degree": 210, "windchill_c": 28.5, "windchill_f": 83.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-24 12:00", "cloud": 11, "is_day": 1, "temp_c": 29.9, "temp_f": 85.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 3.3, "gust_mph": 2.1, "humidity": 53, "wind_dir": "SSW", "wind_kph": 2.9, "wind_mph": 1.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.7, "dewpoint_f": 67.4, "time_epoch": 1721840400, "feelslike_c": 31.7, "feelslike_f": 89.1, "heatindex_c": 31.7, "heatindex_f": 89.1, "pressure_in": 30.09, "pressure_mb": 1019.0, "wind_degree": 201, "windchill_c": 29.9, "windchill_f": 85.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-24 13:00", "cloud": 22, "is_day": 1, "temp_c": 31.1, "temp_f": 87.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 3.7, "gust_mph": 2.3, "humidity": 46, "wind_dir": "S", "wind_kph": 3.2, "wind_mph": 2.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.2, "dewpoint_f": 64.8, "time_epoch": 1721844000, "feelslike_c": 32.5, "feelslike_f": 90.5, "heatindex_c": 32.5, "heatindex_f": 90.5, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 170, "windchill_c": 31.1, "windchill_f": 87.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-24 14:00", "cloud": 28, "is_day": 1, "temp_c": 31.9, "temp_f": 89.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 7.5, "gust_mph": 4.6, "humidity": 40, "wind_dir": "S", "wind_kph": 6.5, "wind_mph": 4.0, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.0, "dewpoint_f": 62.6, "time_epoch": 1721847600, "feelslike_c": 33.0, "feelslike_f": 91.4, "heatindex_c": 33.0, "heatindex_f": 91.4, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 169, "windchill_c": 31.9, "windchill_f": 89.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-24 15:00", "cloud": 22, "is_day": 1, "temp_c": 32.0, "temp_f": 89.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 9.5, "gust_mph": 5.9, "humidity": 37, "wind_dir": "SSE", "wind_kph": 8.3, "wind_mph": 5.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.1, "dewpoint_f": 60.9, "time_epoch": 1721851200, "feelslike_c": 32.8, "feelslike_f": 91.0, "heatindex_c": 32.8, "heatindex_f": 91.0, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 165, "windchill_c": 32.0, "windchill_f": 89.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-24 16:00", "cloud": 21, "is_day": 1, "temp_c": 30.9, "temp_f": 87.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 10.5, "gust_mph": 6.5, "humidity": 39, "wind_dir": "SSE", "wind_kph": 7.6, "wind_mph": 4.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 16.1, "dewpoint_f": 61.0, "time_epoch": 1721854800, "feelslike_c": 31.8, "feelslike_f": 89.2, "heatindex_c": 31.8, "heatindex_f": 89.2, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 152, "windchill_c": 30.9, "windchill_f": 87.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-24 17:00", "cloud": 30, "is_day": 1, "temp_c": 29.3, "temp_f": 84.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 8.3, "gust_mph": 5.2, "humidity": 47, "wind_dir": "ESE", "wind_kph": 4.7, "wind_mph": 2.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.4, "dewpoint_f": 63.2, "time_epoch": 1721858400, "feelslike_c": 30.3, "feelslike_f": 86.6, "heatindex_c": 30.3, "heatindex_f": 86.6, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 109, "windchill_c": 29.3, "windchill_f": 84.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-24 18:00", "cloud": 46, "is_day": 1, "temp_c": 28.1, "temp_f": 82.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 9.1, "gust_mph": 5.6, "humidity": 56, "wind_dir": "ENE", "wind_kph": 4.3, "wind_mph": 2.7, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.0, "dewpoint_f": 64.4, "time_epoch": 1721862000, "feelslike_c": 29.2, "feelslike_f": 84.6, "heatindex_c": 29.2, "heatindex_f": 84.6, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 73, "windchill_c": 28.1, "windchill_f": 82.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-24 19:00", "cloud": 43, "is_day": 1, "temp_c": 27.1, "temp_f": 80.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 6.0, "gust_mph": 3.8, "humidity": 59, "wind_dir": "E", "wind_kph": 2.9, "wind_mph": 1.8, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.3, "dewpoint_f": 64.9, "time_epoch": 1721865600, "feelslike_c": 28.3, "feelslike_f": 82.9, "heatindex_c": 28.3, "heatindex_f": 82.9, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 81, "windchill_c": 27.1, "windchill_f": 80.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-24 20:00", "cloud": 11, "is_day": 1, "temp_c": 25.8, "temp_f": 78.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 8.3, "gust_mph": 5.2, "humidity": 61, "wind_dir": "E", "wind_kph": 4.0, "wind_mph": 2.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 18.0, "dewpoint_f": 64.4, "time_epoch": 1721869200, "feelslike_c": 27.1, "feelslike_f": 80.8, "heatindex_c": 27.1, "heatindex_f": 80.8, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 93, "windchill_c": 25.8, "windchill_f": 78.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-24 21:00", "cloud": 9, "is_day": 0, "temp_c": 24.4, "temp_f": 76.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.1, "gust_mph": 7.5, "humidity": 66, "wind_dir": "E", "wind_kph": 5.8, "wind_mph": 3.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.8, "dewpoint_f": 64.0, "time_epoch": 1721872800, "feelslike_c": 26.1, "feelslike_f": 79.0, "heatindex_c": 26.1, "heatindex_f": 79.0, "pressure_in": 30.05, "pressure_mb": 1017.0, "wind_degree": 81, "windchill_c": 24.4, "windchill_f": 76.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-24 22:00", "cloud": 9, "is_day": 0, "temp_c": 24.1, "temp_f": 75.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.3, "gust_mph": 7.0, "humidity": 73, "wind_dir": "ENE", "wind_kph": 5.4, "wind_mph": 3.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.9, "dewpoint_f": 64.2, "time_epoch": 1721876400, "feelslike_c": 25.8, "feelslike_f": 78.5, "heatindex_c": 25.8, "heatindex_f": 78.5, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 72, "windchill_c": 24.1, "windchill_f": 75.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-24 23:00", "cloud": 11, "is_day": 0, "temp_c": 23.6, "temp_f": 74.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.3, "gust_mph": 7.0, "humidity": 75, "wind_dir": "ENE", "wind_kph": 5.4, "wind_mph": 3.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.0, "dewpoint_f": 66.3, "time_epoch": 1721880000, "feelslike_c": 25.5, "feelslike_f": 77.9, "heatindex_c": 25.5, "heatindex_f": 77.9, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 76, "windchill_c": 23.6, "windchill_f": 74.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:27 PM", "moonset": "09:53 AM", "sunrise": "06:20 AM", "moonrise": "10:53 PM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Waning Gibbous", "moon_illumination": 91}, "date_epoch": 1721779200}, {"day": {"uv": 10.0, "avgtemp_c": 25.6, "avgtemp_f": 78.0, "avgvis_km": 8.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "maxtemp_c": 32.3, "maxtemp_f": 90.1, "mintemp_c": 20.2, "mintemp_f": 68.3, "avghumidity": 72, "maxwind_kph": 14.0, "maxwind_mph": 8.7, "avgvis_miles": 5.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.0, "totalprecip_mm": 0.09, "daily_will_it_rain": 0, "daily_will_it_snow": 0, "daily_chance_of_rain": 0, "daily_chance_of_snow": 0}, "date": "2024-07-25", "hour": [{"uv": 0, "time": "2024-07-25 00:00", "cloud": 13, "is_day": 0, "temp_c": 22.8, "temp_f": 73.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.7, "gust_mph": 7.3, "humidity": 79, "wind_dir": "E", "wind_kph": 5.8, "wind_mph": 3.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.4, "dewpoint_f": 66.9, "time_epoch": 1721883600, "feelslike_c": 25.0, "feelslike_f": 77.0, "heatindex_c": 25.0, "heatindex_f": 77.0, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 83, "windchill_c": 22.8, "windchill_f": 73.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 01:00", "cloud": 13, "is_day": 0, "temp_c": 22.2, "temp_f": 71.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.3, "gust_mph": 7.0, "humidity": 86, "wind_dir": "ENE", "wind_kph": 5.4, "wind_mph": 3.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.6, "dewpoint_f": 67.3, "time_epoch": 1721887200, "feelslike_c": 24.7, "feelslike_f": 76.4, "heatindex_c": 24.7, "heatindex_f": 76.4, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 78, "windchill_c": 22.2, "windchill_f": 71.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 02:00", "cloud": 12, "is_day": 0, "temp_c": 21.6, "temp_f": 70.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.1, "gust_mph": 7.5, "humidity": 90, "wind_dir": "E", "wind_kph": 5.8, "wind_mph": 3.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.6, "time_epoch": 1721890800, "feelslike_c": 21.6, "feelslike_f": 70.8, "heatindex_c": 22.8, "heatindex_f": 73.1, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 89, "windchill_c": 21.6, "windchill_f": 70.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 03:00", "cloud": 13, "is_day": 0, "temp_c": 21.1, "temp_f": 69.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 10.3, "gust_mph": 6.4, "humidity": 93, "wind_dir": "E", "wind_kph": 5.0, "wind_mph": 3.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1721894400, "feelslike_c": 21.1, "feelslike_f": 69.9, "heatindex_c": 21.7, "heatindex_f": 71.0, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 98, "windchill_c": 21.1, "windchill_f": 69.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 04:00", "cloud": 9, "is_day": 0, "temp_c": 20.7, "temp_f": 69.2, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 8.8, "gust_mph": 5.5, "humidity": 95, "wind_dir": "ENE", "wind_kph": 4.3, "wind_mph": 2.7, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 19.7, "dewpoint_f": 67.5, "time_epoch": 1721898000, "feelslike_c": 20.7, "feelslike_f": 69.2, "heatindex_c": 21.0, "heatindex_f": 69.8, "pressure_in": 30.08, "pressure_mb": 1019.0, "wind_degree": 74, "windchill_c": 20.7, "windchill_f": 69.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 05:00", "cloud": 14, "is_day": 0, "temp_c": 20.4, "temp_f": 68.8, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 8.1, "gust_mph": 5.0, "humidity": 96, "wind_dir": "ENE", "wind_kph": 4.0, "wind_mph": 2.5, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 19.7, "dewpoint_f": 67.4, "time_epoch": 1721901600, "feelslike_c": 20.4, "feelslike_f": 68.8, "heatindex_c": 20.6, "heatindex_f": 69.1, "pressure_in": 30.09, "pressure_mb": 1019.0, "wind_degree": 57, "windchill_c": 20.4, "windchill_f": 68.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 06:00", "cloud": 16, "is_day": 0, "temp_c": 20.6, "temp_f": 69.2, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 8.7, "gust_mph": 5.4, "humidity": 96, "wind_dir": "NE", "wind_kph": 4.3, "wind_mph": 2.7, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 19.6, "dewpoint_f": 67.3, "time_epoch": 1721905200, "feelslike_c": 20.6, "feelslike_f": 69.2, "heatindex_c": 20.7, "heatindex_f": 69.3, "pressure_in": 30.09, "pressure_mb": 1019.0, "wind_degree": 43, "windchill_c": 20.6, "windchill_f": 69.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-25 07:00", "cloud": 19, "is_day": 1, "temp_c": 21.9, "temp_f": 71.5, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 5.9, "gust_mph": 3.6, "humidity": 94, "wind_dir": "ENE", "wind_kph": 3.2, "wind_mph": 2.0, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/day/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 19.9, "dewpoint_f": 67.7, "time_epoch": 1721908800, "feelslike_c": 21.9, "feelslike_f": 71.5, "heatindex_c": 23.0, "heatindex_f": 73.4, "pressure_in": 30.11, "pressure_mb": 1020.0, "wind_degree": 76, "windchill_c": 21.9, "windchill_f": 71.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-25 08:00", "cloud": 18, "is_day": 1, "temp_c": 23.8, "temp_f": 74.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 4.1, "gust_mph": 2.5, "humidity": 84, "wind_dir": "E", "wind_kph": 3.2, "wind_mph": 2.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.4, "dewpoint_f": 68.7, "time_epoch": 1721912400, "feelslike_c": 25.3, "feelslike_f": 77.5, "heatindex_c": 25.3, "heatindex_f": 77.5, "pressure_in": 30.12, "pressure_mb": 1020.0, "wind_degree": 84, "windchill_c": 23.8, "windchill_f": 74.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 09:00", "cloud": 20, "is_day": 1, "temp_c": 25.9, "temp_f": 78.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 3.7, "gust_mph": 2.3, "humidity": 74, "wind_dir": "ESE", "wind_kph": 3.2, "wind_mph": 2.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.0, "time_epoch": 1721916000, "feelslike_c": 27.7, "feelslike_f": 81.9, "heatindex_c": 27.7, "heatindex_f": 81.9, "pressure_in": 30.12, "pressure_mb": 1020.0, "wind_degree": 102, "windchill_c": 25.9, "windchill_f": 78.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 10:00", "cloud": 17, "is_day": 1, "temp_c": 27.9, "temp_f": 82.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 5.0, "gust_mph": 3.1, "humidity": 64, "wind_dir": "ESE", "wind_kph": 4.3, "wind_mph": 2.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1721919600, "feelslike_c": 30.0, "feelslike_f": 86.0, "heatindex_c": 30.0, "heatindex_f": 86.0, "pressure_in": 30.12, "pressure_mb": 1020.0, "wind_degree": 111, "windchill_c": 27.9, "windchill_f": 82.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 11:00", "cloud": 21, "is_day": 1, "temp_c": 29.1, "temp_f": 84.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 7.1, "gust_mph": 4.4, "humidity": 56, "wind_dir": "ESE", "wind_kph": 6.1, "wind_mph": 3.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.3, "dewpoint_f": 68.6, "time_epoch": 1721923200, "feelslike_c": 31.1, "feelslike_f": 87.9, "heatindex_c": 31.1, "heatindex_f": 87.9, "pressure_in": 30.11, "pressure_mb": 1020.0, "wind_degree": 111, "windchill_c": 29.1, "windchill_f": 84.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 12:00", "cloud": 88, "is_day": 1, "temp_c": 30.4, "temp_f": 86.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 9.9, "gust_mph": 6.2, "humidity": 50, "wind_dir": "ESE", "wind_kph": 8.6, "wind_mph": 5.4, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.02, "vis_miles": 6.0, "dewpoint_c": 18.8, "dewpoint_f": 65.9, "time_epoch": 1721926800, "feelslike_c": 32.1, "feelslike_f": 89.7, "heatindex_c": 32.1, "heatindex_f": 89.7, "pressure_in": 30.1, "pressure_mb": 1019.0, "wind_degree": 111, "windchill_c": 30.4, "windchill_f": 86.7, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 86, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 13:00", "cloud": 52, "is_day": 1, "temp_c": 31.3, "temp_f": 88.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.6, "gust_mph": 7.2, "humidity": 44, "wind_dir": "ESE", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.01, "vis_miles": 6.0, "dewpoint_c": 18.0, "dewpoint_f": 64.5, "time_epoch": 1721930400, "feelslike_c": 32.8, "feelslike_f": 91.0, "heatindex_c": 32.8, "heatindex_f": 91.0, "pressure_in": 30.09, "pressure_mb": 1019.0, "wind_degree": 113, "windchill_c": 31.3, "windchill_f": 88.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 64, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 14:00", "cloud": 83, "is_day": 1, "temp_c": 31.7, "temp_f": 89.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.8, "humidity": 41, "wind_dir": "ESE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.01, "vis_miles": 6.0, "dewpoint_c": 17.3, "dewpoint_f": 63.1, "time_epoch": 1721934000, "feelslike_c": 33.0, "feelslike_f": 91.5, "heatindex_c": 33.0, "heatindex_f": 91.5, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 118, "windchill_c": 31.7, "windchill_f": 89.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 69, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-25 15:00", "cloud": 44, "is_day": 1, "temp_c": 31.2, "temp_f": 88.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.7, "gust_mph": 11.0, "humidity": 42, "wind_dir": "ESE", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 17.5, "dewpoint_f": 63.4, "time_epoch": 1721937600, "feelslike_c": 32.6, "feelslike_f": 90.6, "heatindex_c": 32.6, "heatindex_f": 90.6, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 122, "windchill_c": 31.2, "windchill_f": 88.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 16:00", "cloud": 70, "is_day": 1, "temp_c": 30.2, "temp_f": 86.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.0, "gust_mph": 11.8, "humidity": 47, "wind_dir": "ESE", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.01, "vis_miles": 6.0, "dewpoint_c": 18.0, "dewpoint_f": 64.4, "time_epoch": 1721941200, "feelslike_c": 31.6, "feelslike_f": 88.9, "heatindex_c": 31.6, "heatindex_f": 88.9, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 122, "windchill_c": 30.2, "windchill_f": 86.3, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 85, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-25 17:00", "cloud": 72, "is_day": 1, "temp_c": 29.3, "temp_f": 84.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.4, "gust_mph": 9.6, "humidity": 53, "wind_dir": "ESE", "wind_kph": 9.0, "wind_mph": 5.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.05, "vis_miles": 6.0, "dewpoint_c": 18.7, "dewpoint_f": 65.7, "time_epoch": 1721944800, "feelslike_c": 30.9, "feelslike_f": 87.6, "heatindex_c": 30.9, "heatindex_f": 87.6, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 120, "windchill_c": 29.4, "windchill_f": 84.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 84, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 18:00", "cloud": 40, "is_day": 1, "temp_c": 28.5, "temp_f": 83.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.9, "gust_mph": 9.9, "humidity": 57, "wind_dir": "SE", "wind_kph": 9.0, "wind_mph": 5.6, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.2, "dewpoint_f": 66.6, "time_epoch": 1721948400, "feelslike_c": 30.2, "feelslike_f": 86.3, "heatindex_c": 30.2, "heatindex_f": 86.3, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 135, "windchill_c": 28.5, "windchill_f": 83.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 19:00", "cloud": 46, "is_day": 1, "temp_c": 26.9, "temp_f": 80.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.2, "gust_mph": 13.8, "humidity": 63, "wind_dir": "SE", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.9, "dewpoint_f": 67.8, "time_epoch": 1721952000, "feelslike_c": 28.7, "feelslike_f": 83.6, "heatindex_c": 28.7, "heatindex_f": 83.6, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 143, "windchill_c": 26.9, "windchill_f": 80.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 20:00", "cloud": 13, "is_day": 1, "temp_c": 25.3, "temp_f": 77.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.0, "gust_mph": 12.4, "humidity": 72, "wind_dir": "SE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.0, "dewpoint_f": 68.1, "time_epoch": 1721955600, "feelslike_c": 27.1, "feelslike_f": 80.8, "heatindex_c": 27.1, "heatindex_f": 80.8, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 138, "windchill_c": 25.3, "windchill_f": 77.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 21:00", "cloud": 9, "is_day": 0, "temp_c": 24.0, "temp_f": 75.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.0, "gust_mph": 10.6, "humidity": 79, "wind_dir": "SE", "wind_kph": 8.6, "wind_mph": 5.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1721959200, "feelslike_c": 26.0, "feelslike_f": 78.8, "heatindex_c": 26.0, "heatindex_f": 78.8, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 134, "windchill_c": 24.0, "windchill_f": 75.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 22:00", "cloud": 7, "is_day": 0, "temp_c": 23.4, "temp_f": 74.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.5, "gust_mph": 10.3, "humidity": 84, "wind_dir": "ESE", "wind_kph": 8.3, "wind_mph": 5.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.6, "time_epoch": 1721962800, "feelslike_c": 25.5, "feelslike_f": 78.0, "heatindex_c": 25.5, "heatindex_f": 78.0, "pressure_in": 30.08, "pressure_mb": 1019.0, "wind_degree": 115, "windchill_c": 23.4, "windchill_f": 74.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 23:00", "cloud": 11, "is_day": 0, "temp_c": 22.7, "temp_f": 72.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.6, "gust_mph": 7.9, "humidity": 88, "wind_dir": "ESE", "wind_kph": 7.2, "wind_mph": 4.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.8, "dewpoint_f": 69.4, "time_epoch": 1721966400, "feelslike_c": 25.0, "feelslike_f": 77.1, "heatindex_c": 25.0, "heatindex_f": 77.1, "pressure_in": 30.08, "pressure_mb": 1019.0, "wind_degree": 118, "windchill_c": 22.7, "windchill_f": 72.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:26 PM", "moonset": "11:04 AM", "sunrise": "06:21 AM", "moonrise": "11:22 PM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Waning Gibbous", "moon_illumination": 83}, "date_epoch": 1721865600}]}, "location": {"lat": 35.44, "lon": -94.34, "name": "Van Buren", "tz_id": "America/Chicago", "region": "Arkansas", "country": "USA", "localtime": "2024-07-23 14:05", "localtime_epoch": 1721761538}}	2024-07-23 19:07:00.507693	1	2024-07-25 15:26:13.155448
7	{"current": {"uv": 6.0, "cloud": 71, "is_day": 1, "temp_c": 27.4, "temp_f": 81.3, "vis_km": 10.0, "gust_kph": 16.2, "gust_mph": 10.0, "humidity": 67, "wind_dir": "ENE", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.03, "vis_miles": 6.0, "dewpoint_c": 20.8, "dewpoint_f": 69.5, "feelslike_c": 29.7, "feelslike_f": 85.4, "heatindex_c": 29.7, "heatindex_f": 85.4, "pressure_in": 30.1, "pressure_mb": 1019.0, "wind_degree": 71, "windchill_c": 27.4, "windchill_f": 81.3, "last_updated": "2024-07-25 10:15", "last_updated_epoch": 1721920500}, "forecast": {"forecastday": [{"day": {"uv": 8.0, "avgtemp_c": 26.6, "avgtemp_f": 79.8, "avgvis_km": 9.5, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "maxtemp_c": 31.9, "maxtemp_f": 89.5, "mintemp_c": 22.3, "mintemp_f": 72.1, "avghumidity": 72, "maxwind_kph": 21.2, "maxwind_mph": 13.2, "avgvis_miles": 5.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.06, "totalprecip_mm": 1.44, "daily_will_it_rain": 1, "daily_will_it_snow": 0, "daily_chance_of_rain": 94, "daily_chance_of_snow": 0}, "date": "2024-07-25", "hour": [{"uv": 0, "time": "2024-07-25 00:00", "cloud": 13, "is_day": 0, "temp_c": 24.5, "temp_f": 76.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.4, "gust_mph": 12.7, "humidity": 79, "wind_dir": "E", "wind_kph": 10.1, "wind_mph": 6.3, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1721883600, "feelslike_c": 26.5, "feelslike_f": 79.7, "heatindex_c": 26.5, "heatindex_f": 79.7, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 92, "windchill_c": 24.5, "windchill_f": 76.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 01:00", "cloud": 14, "is_day": 0, "temp_c": 24.0, "temp_f": 75.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.4, "gust_mph": 12.0, "humidity": 82, "wind_dir": "E", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.7, "dewpoint_f": 69.3, "time_epoch": 1721887200, "feelslike_c": 26.0, "feelslike_f": 78.8, "heatindex_c": 26.0, "heatindex_f": 78.8, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 93, "windchill_c": 24.0, "windchill_f": 75.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 02:00", "cloud": 16, "is_day": 0, "temp_c": 23.5, "temp_f": 74.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.5, "gust_mph": 10.9, "humidity": 85, "wind_dir": "E", "wind_kph": 9.0, "wind_mph": 5.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.8, "dewpoint_f": 69.5, "time_epoch": 1721890800, "feelslike_c": 25.6, "feelslike_f": 78.1, "heatindex_c": 25.6, "heatindex_f": 78.1, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 89, "windchill_c": 23.5, "windchill_f": 74.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 03:00", "cloud": 16, "is_day": 0, "temp_c": 23.1, "temp_f": 73.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 13.8, "gust_mph": 8.5, "humidity": 87, "wind_dir": "E", "wind_kph": 7.2, "wind_mph": 4.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.9, "dewpoint_f": 69.5, "time_epoch": 1721894400, "feelslike_c": 25.3, "feelslike_f": 77.6, "heatindex_c": 25.3, "heatindex_f": 77.6, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 89, "windchill_c": 23.1, "windchill_f": 73.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 04:00", "cloud": 20, "is_day": 0, "temp_c": 22.8, "temp_f": 73.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.6, "gust_mph": 7.2, "humidity": 89, "wind_dir": "E", "wind_kph": 6.1, "wind_mph": 3.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.8, "dewpoint_f": 69.4, "time_epoch": 1721898000, "feelslike_c": 25.0, "feelslike_f": 77.1, "heatindex_c": 25.0, "heatindex_f": 77.1, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 95, "windchill_c": 22.8, "windchill_f": 73.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 05:00", "cloud": 26, "is_day": 0, "temp_c": 22.5, "temp_f": 72.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.0, "gust_mph": 6.8, "humidity": 90, "wind_dir": "E", "wind_kph": 5.8, "wind_mph": 3.6, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1721901600, "feelslike_c": 24.9, "feelslike_f": 76.8, "heatindex_c": 24.9, "heatindex_f": 76.8, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 90, "windchill_c": 22.5, "windchill_f": 72.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 06:00", "cloud": 28, "is_day": 0, "temp_c": 22.4, "temp_f": 72.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.5, "gust_mph": 7.2, "humidity": 90, "wind_dir": "ENE", "wind_kph": 6.1, "wind_mph": 3.8, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1721905200, "feelslike_c": 24.8, "feelslike_f": 76.6, "heatindex_c": 24.8, "heatindex_f": 76.6, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 75, "windchill_c": 22.4, "windchill_f": 72.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-25 07:00", "cloud": 15, "is_day": 1, "temp_c": 23.2, "temp_f": 73.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.9, "gust_mph": 9.3, "humidity": 90, "wind_dir": "ENE", "wind_kph": 8.3, "wind_mph": 5.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.1, "time_epoch": 1721908800, "feelslike_c": 25.4, "feelslike_f": 77.7, "heatindex_c": 25.4, "heatindex_f": 77.7, "pressure_in": 30.08, "pressure_mb": 1019.0, "wind_degree": 63, "windchill_c": 23.2, "windchill_f": 73.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-25 08:00", "cloud": 17, "is_day": 1, "temp_c": 24.5, "temp_f": 76.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 13.2, "gust_mph": 8.2, "humidity": 83, "wind_dir": "ENE", "wind_kph": 9.4, "wind_mph": 5.8, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.9, "dewpoint_f": 69.5, "time_epoch": 1721912400, "feelslike_c": 26.6, "feelslike_f": 79.9, "heatindex_c": 26.6, "heatindex_f": 79.9, "pressure_in": 30.1, "pressure_mb": 1019.0, "wind_degree": 69, "windchill_c": 24.5, "windchill_f": 76.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 09:00", "cloud": 41, "is_day": 1, "temp_c": 26.0, "temp_f": 78.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.3, "gust_mph": 8.9, "humidity": 75, "wind_dir": "ENE", "wind_kph": 11.9, "wind_mph": 7.4, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.9, "dewpoint_f": 69.7, "time_epoch": 1721916000, "feelslike_c": 28.2, "feelslike_f": 82.7, "heatindex_c": 28.2, "heatindex_f": 82.7, "pressure_in": 30.11, "pressure_mb": 1020.0, "wind_degree": 72, "windchill_c": 26.0, "windchill_f": 78.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-25 10:00", "cloud": 71, "is_day": 1, "temp_c": 27.4, "temp_f": 81.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.2, "gust_mph": 10.0, "humidity": 67, "wind_dir": "ENE", "wind_kph": 14.0, "wind_mph": 8.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.03, "vis_miles": 6.0, "dewpoint_c": 20.8, "dewpoint_f": 69.5, "time_epoch": 1721919600, "feelslike_c": 29.7, "feelslike_f": 85.4, "heatindex_c": 29.7, "heatindex_f": 85.4, "pressure_in": 30.1, "pressure_mb": 1019.0, "wind_degree": 71, "windchill_c": 27.4, "windchill_f": 81.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 64, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 11:00", "cloud": 41, "is_day": 1, "temp_c": 28.8, "temp_f": 83.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 17.8, "gust_mph": 11.1, "humidity": 61, "wind_dir": "ENE", "wind_kph": 15.5, "wind_mph": 9.6, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.0, "time_epoch": 1721923200, "feelslike_c": 31.2, "feelslike_f": 88.1, "heatindex_c": 31.2, "heatindex_f": 88.1, "pressure_in": 30.1, "pressure_mb": 1019.0, "wind_degree": 66, "windchill_c": 28.8, "windchill_f": 83.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 12:00", "cloud": 78, "is_day": 1, "temp_c": 30.0, "temp_f": 86.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.6, "gust_mph": 11.6, "humidity": 55, "wind_dir": "ENE", "wind_kph": 16.2, "wind_mph": 10.1, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.06, "vis_miles": 6.0, "dewpoint_c": 20.2, "dewpoint_f": 68.4, "time_epoch": 1721926800, "feelslike_c": 32.4, "feelslike_f": 90.4, "heatindex_c": 32.4, "heatindex_f": 90.4, "pressure_in": 30.09, "pressure_mb": 1019.0, "wind_degree": 75, "windchill_c": 30.0, "windchill_f": 86.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 13:00", "cloud": 73, "is_day": 1, "temp_c": 31.0, "temp_f": 87.8, "vis_km": 5.0, "snow_cm": 0.0, "gust_kph": 19.5, "gust_mph": 12.1, "humidity": 51, "wind_dir": "E", "wind_kph": 16.9, "wind_mph": 10.5, "condition": {"code": 1150, "icon": "//cdn.weatherapi.com/weather/64x64/day/263.png", "text": "Patchy light drizzle"}, "precip_in": 0.01, "precip_mm": 0.19, "vis_miles": 3.0, "dewpoint_c": 19.9, "dewpoint_f": 67.7, "time_epoch": 1721930400, "feelslike_c": 33.4, "feelslike_f": 92.2, "heatindex_c": 33.4, "heatindex_f": 92.2, "pressure_in": 30.07, "pressure_mb": 1018.0, "wind_degree": 84, "windchill_c": 31.0, "windchill_f": 87.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 14:00", "cloud": 87, "is_day": 1, "temp_c": 31.4, "temp_f": 88.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.9, "gust_mph": 12.3, "humidity": 48, "wind_dir": "E", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.01, "precip_mm": 0.14, "vis_miles": 6.0, "dewpoint_c": 19.7, "dewpoint_f": 67.5, "time_epoch": 1721934000, "feelslike_c": 33.8, "feelslike_f": 92.9, "heatindex_c": 33.8, "heatindex_f": 92.9, "pressure_in": 30.05, "pressure_mb": 1017.0, "wind_degree": 87, "windchill_c": 31.4, "windchill_f": 88.5, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-25 15:00", "cloud": 36, "is_day": 1, "temp_c": 31.4, "temp_f": 88.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.7, "gust_mph": 12.9, "humidity": 49, "wind_dir": "E", "wind_kph": 18.0, "wind_mph": 11.2, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.7, "dewpoint_f": 67.4, "time_epoch": 1721937600, "feelslike_c": 33.8, "feelslike_f": 92.8, "heatindex_c": 33.8, "heatindex_f": 92.8, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 93, "windchill_c": 31.4, "windchill_f": 88.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 16:00", "cloud": 87, "is_day": 1, "temp_c": 31.4, "temp_f": 88.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.4, "gust_mph": 12.7, "humidity": 50, "wind_dir": "E", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.06, "vis_miles": 6.0, "dewpoint_c": 19.6, "dewpoint_f": 67.3, "time_epoch": 1721941200, "feelslike_c": 33.8, "feelslike_f": 92.8, "heatindex_c": 33.8, "heatindex_f": 92.8, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 98, "windchill_c": 31.4, "windchill_f": 88.4, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-25 17:00", "cloud": 32, "is_day": 1, "temp_c": 30.7, "temp_f": 87.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.5, "gust_mph": 14.6, "humidity": 51, "wind_dir": "ESE", "wind_kph": 20.2, "wind_mph": 12.5, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1721944800, "feelslike_c": 33.2, "feelslike_f": 91.7, "heatindex_c": 33.2, "heatindex_f": 91.7, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 102, "windchill_c": 30.7, "windchill_f": 87.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 8.0, "time": "2024-07-25 18:00", "cloud": 37, "is_day": 1, "temp_c": 29.9, "temp_f": 85.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 26.0, "gust_mph": 16.2, "humidity": 56, "wind_dir": "ESE", "wind_kph": 21.2, "wind_mph": 13.2, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.4, "dewpoint_f": 68.8, "time_epoch": 1721948400, "feelslike_c": 32.4, "feelslike_f": 90.4, "heatindex_c": 32.4, "heatindex_f": 90.4, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 112, "windchill_c": 29.9, "windchill_f": 85.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 19:00", "cloud": 44, "is_day": 1, "temp_c": 28.6, "temp_f": 83.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 26.2, "gust_mph": 16.3, "humidity": 61, "wind_dir": "ESE", "wind_kph": 20.5, "wind_mph": 12.8, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.9, "dewpoint_f": 69.7, "time_epoch": 1721952000, "feelslike_c": 31.1, "feelslike_f": 88.0, "heatindex_c": 31.1, "heatindex_f": 88.0, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 116, "windchill_c": 28.6, "windchill_f": 83.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-25 20:00", "cloud": 32, "is_day": 1, "temp_c": 27.0, "temp_f": 80.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.5, "gust_mph": 14.6, "humidity": 70, "wind_dir": "SE", "wind_kph": 16.2, "wind_mph": 10.1, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.5, "dewpoint_f": 70.7, "time_epoch": 1721955600, "feelslike_c": 29.3, "feelslike_f": 84.8, "heatindex_c": 29.3, "heatindex_f": 84.8, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 131, "windchill_c": 27.0, "windchill_f": 80.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 21:00", "cloud": 58, "is_day": 0, "temp_c": 25.6, "temp_f": 78.2, "vis_km": 5.0, "snow_cm": 0.0, "gust_kph": 20.9, "gust_mph": 13.0, "humidity": 79, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1150, "icon": "//cdn.weatherapi.com/weather/64x64/night/263.png", "text": "Patchy light drizzle"}, "precip_in": 0.01, "precip_mm": 0.16, "vis_miles": 3.0, "dewpoint_c": 21.5, "dewpoint_f": 70.8, "time_epoch": 1721959200, "feelslike_c": 27.9, "feelslike_f": 82.2, "heatindex_c": 27.9, "heatindex_f": 82.2, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 126, "windchill_c": 25.6, "windchill_f": 78.2, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 22:00", "cloud": 77, "is_day": 0, "temp_c": 24.3, "temp_f": 75.8, "vis_km": 9.0, "snow_cm": 0.0, "gust_kph": 21.1, "gust_mph": 13.1, "humidity": 86, "wind_dir": "SE", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/night/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.03, "precip_mm": 0.81, "vis_miles": 5.0, "dewpoint_c": 21.8, "dewpoint_f": 71.2, "time_epoch": 1721962800, "feelslike_c": 26.6, "feelslike_f": 79.9, "heatindex_c": 26.6, "heatindex_f": 79.9, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 133, "windchill_c": 24.3, "windchill_f": 75.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-25 23:00", "cloud": 61, "is_day": 0, "temp_c": 23.2, "temp_f": 73.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.6, "gust_mph": 13.4, "humidity": 92, "wind_dir": "SSE", "wind_kph": 14.8, "wind_mph": 9.2, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.7, "dewpoint_f": 71.0, "time_epoch": 1721966400, "feelslike_c": 25.6, "feelslike_f": 78.1, "heatindex_c": 25.6, "heatindex_f": 78.1, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 148, "windchill_c": 23.2, "windchill_f": 73.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:29 PM", "moonset": "11:13 AM", "sunrise": "06:34 AM", "moonrise": "11:31 PM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Waning Gibbous", "moon_illumination": 83}, "date_epoch": 1721865600}, {"day": {"uv": 1.0, "avgtemp_c": 24.4, "avgtemp_f": 75.9, "avgvis_km": 7.3, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "maxtemp_c": 30.1, "maxtemp_f": 86.2, "mintemp_c": 20.6, "mintemp_f": 69.2, "avghumidity": 80, "maxwind_kph": 20.9, "maxwind_mph": 13.0, "avgvis_miles": 4.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.04, "totalprecip_mm": 0.95, "daily_will_it_rain": 1, "daily_will_it_snow": 0, "daily_chance_of_rain": 84, "daily_chance_of_snow": 0}, "date": "2024-07-26", "hour": [{"uv": 0, "time": "2024-07-26 00:00", "cloud": 71, "is_day": 0, "temp_c": 22.4, "temp_f": 72.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 20.8, "gust_mph": 13.0, "humidity": 94, "wind_dir": "SSE", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1006, "icon": "//cdn.weatherapi.com/weather/64x64/night/119.png", "text": "Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.1, "dewpoint_f": 69.9, "time_epoch": 1721970000, "feelslike_c": 25.0, "feelslike_f": 76.9, "heatindex_c": 25.0, "heatindex_f": 76.9, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 153, "windchill_c": 22.4, "windchill_f": 72.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-26 01:00", "cloud": 63, "is_day": 0, "temp_c": 21.7, "temp_f": 71.1, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 17.7, "gust_mph": 11.0, "humidity": 95, "wind_dir": "SSE", "wind_kph": 11.5, "wind_mph": 7.2, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 20.7, "dewpoint_f": 69.2, "time_epoch": 1721973600, "feelslike_c": 21.7, "feelslike_f": 71.1, "heatindex_c": 24.6, "heatindex_f": 76.2, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 160, "windchill_c": 21.7, "windchill_f": 71.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-26 02:00", "cloud": 69, "is_day": 0, "temp_c": 21.3, "temp_f": 70.3, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 96, "wind_dir": "SSE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 20.4, "dewpoint_f": 68.8, "time_epoch": 1721977200, "feelslike_c": 21.3, "feelslike_f": 70.3, "heatindex_c": 22.7, "heatindex_f": 72.9, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 157, "windchill_c": 21.3, "windchill_f": 70.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-26 03:00", "cloud": 79, "is_day": 0, "temp_c": 21.0, "temp_f": 69.8, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 16.3, "gust_mph": 10.1, "humidity": 97, "wind_dir": "SSE", "wind_kph": 10.4, "wind_mph": 6.5, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1721980800, "feelslike_c": 21.0, "feelslike_f": 69.8, "heatindex_c": 21.7, "heatindex_f": 71.0, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 157, "windchill_c": 21.0, "windchill_f": 69.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-26 04:00", "cloud": 86, "is_day": 0, "temp_c": 20.8, "temp_f": 69.5, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 14.3, "gust_mph": 8.9, "humidity": 97, "wind_dir": "SSE", "wind_kph": 9.0, "wind_mph": 5.6, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 20.1, "dewpoint_f": 68.2, "time_epoch": 1721984400, "feelslike_c": 20.8, "feelslike_f": 69.5, "heatindex_c": 21.2, "heatindex_f": 70.1, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 154, "windchill_c": 20.8, "windchill_f": 69.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-26 05:00", "cloud": 95, "is_day": 0, "temp_c": 20.9, "temp_f": 69.5, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 14.2, "gust_mph": 8.8, "humidity": 97, "wind_dir": "SSE", "wind_kph": 9.0, "wind_mph": 5.6, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 20.1, "dewpoint_f": 68.2, "time_epoch": 1721988000, "feelslike_c": 20.8, "feelslike_f": 69.5, "heatindex_c": 21.0, "heatindex_f": 69.8, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 160, "windchill_c": 20.8, "windchill_f": 69.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-26 06:00", "cloud": 94, "is_day": 0, "temp_c": 20.8, "temp_f": 69.5, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 14.9, "gust_mph": 9.3, "humidity": 95, "wind_dir": "SSE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 20.1, "dewpoint_f": 68.2, "time_epoch": 1721991600, "feelslike_c": 20.8, "feelslike_f": 69.5, "heatindex_c": 20.9, "heatindex_f": 69.6, "pressure_in": 30.03, "pressure_mb": 1017.0, "wind_degree": 161, "windchill_c": 20.8, "windchill_f": 69.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-26 07:00", "cloud": 93, "is_day": 1, "temp_c": 21.4, "temp_f": 70.5, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 13.8, "gust_mph": 8.6, "humidity": 95, "wind_dir": "SSE", "wind_kph": 9.0, "wind_mph": 5.6, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/day/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 20.0, "dewpoint_f": 68.0, "time_epoch": 1721995200, "feelslike_c": 21.4, "feelslike_f": 70.5, "heatindex_c": 22.7, "heatindex_f": 72.9, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 152, "windchill_c": 21.4, "windchill_f": 70.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-26 08:00", "cloud": 80, "is_day": 1, "temp_c": 22.4, "temp_f": 72.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 11.0, "gust_mph": 6.8, "humidity": 89, "wind_dir": "SSE", "wind_kph": 8.3, "wind_mph": 5.1, "condition": {"code": 1006, "icon": "//cdn.weatherapi.com/weather/64x64/day/119.png", "text": "Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.1, "dewpoint_f": 68.1, "time_epoch": 1721998800, "feelslike_c": 24.1, "feelslike_f": 75.4, "heatindex_c": 24.1, "heatindex_f": 75.4, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 161, "windchill_c": 22.4, "windchill_f": 72.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-26 09:00", "cloud": 96, "is_day": 1, "temp_c": 23.7, "temp_f": 74.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 9.3, "gust_mph": 5.8, "humidity": 82, "wind_dir": "SSE", "wind_kph": 7.6, "wind_mph": 4.7, "condition": {"code": 1009, "icon": "//cdn.weatherapi.com/weather/64x64/day/122.png", "text": "Overcast "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.2, "dewpoint_f": 68.4, "time_epoch": 1722002400, "feelslike_c": 25.5, "feelslike_f": 77.9, "heatindex_c": 25.5, "heatindex_f": 77.9, "pressure_in": 30.06, "pressure_mb": 1018.0, "wind_degree": 154, "windchill_c": 23.7, "windchill_f": 74.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-26 10:00", "cloud": 100, "is_day": 1, "temp_c": 25.0, "temp_f": 77.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 9.6, "gust_mph": 6.0, "humidity": 75, "wind_dir": "SE", "wind_kph": 8.3, "wind_mph": 5.1, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.02, "vis_miles": 6.0, "dewpoint_c": 20.4, "dewpoint_f": 68.7, "time_epoch": 1722006000, "feelslike_c": 26.8, "feelslike_f": 80.3, "heatindex_c": 26.8, "heatindex_f": 80.3, "pressure_in": 30.05, "pressure_mb": 1018.0, "wind_degree": 138, "windchill_c": 25.0, "windchill_f": 77.0, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 84, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-26 11:00", "cloud": 98, "is_day": 1, "temp_c": 26.2, "temp_f": 79.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 10.4, "gust_mph": 6.4, "humidity": 69, "wind_dir": "SE", "wind_kph": 9.0, "wind_mph": 5.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.03, "vis_miles": 6.0, "dewpoint_c": 20.2, "dewpoint_f": 68.3, "time_epoch": 1722009600, "feelslike_c": 28.0, "feelslike_f": 82.4, "heatindex_c": 28.0, "heatindex_f": 82.4, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 128, "windchill_c": 26.2, "windchill_f": 79.2, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 80, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-26 12:00", "cloud": 95, "is_day": 1, "temp_c": 27.0, "temp_f": 80.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 12.4, "gust_mph": 7.7, "humidity": 64, "wind_dir": "SE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.05, "vis_miles": 6.0, "dewpoint_c": 20.0, "dewpoint_f": 68.0, "time_epoch": 1722013200, "feelslike_c": 28.8, "feelslike_f": 83.9, "heatindex_c": 28.8, "heatindex_f": 83.9, "pressure_in": 30.04, "pressure_mb": 1017.0, "wind_degree": 138, "windchill_c": 27.0, "windchill_f": 80.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 67, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-26 13:00", "cloud": 74, "is_day": 1, "temp_c": 27.6, "temp_f": 81.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.7, "humidity": 62, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.04, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1722016800, "feelslike_c": 29.4, "feelslike_f": 84.9, "heatindex_c": 29.4, "heatindex_f": 84.9, "pressure_in": 30.02, "pressure_mb": 1017.0, "wind_degree": 142, "windchill_c": 27.6, "windchill_f": 81.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 69, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-26 14:00", "cloud": 67, "is_day": 1, "temp_c": 28.4, "temp_f": 83.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.1, "gust_mph": 8.7, "humidity": 60, "wind_dir": "SE", "wind_kph": 12.2, "wind_mph": 7.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.03, "vis_miles": 6.0, "dewpoint_c": 19.7, "dewpoint_f": 67.5, "time_epoch": 1722020400, "feelslike_c": 30.3, "feelslike_f": 86.5, "heatindex_c": 30.3, "heatindex_f": 86.5, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 133, "windchill_c": 28.4, "windchill_f": 83.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 79, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-26 15:00", "cloud": 89, "is_day": 1, "temp_c": 29.3, "temp_f": 84.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.5, "gust_mph": 9.0, "humidity": 56, "wind_dir": "SE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.02, "vis_miles": 6.0, "dewpoint_c": 19.6, "dewpoint_f": 67.2, "time_epoch": 1722024000, "feelslike_c": 31.2, "feelslike_f": 88.1, "heatindex_c": 31.2, "heatindex_f": 88.1, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 137, "windchill_c": 29.3, "windchill_f": 84.7, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 83, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-26 16:00", "cloud": 89, "is_day": 1, "temp_c": 29.2, "temp_f": 84.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.3, "gust_mph": 9.5, "humidity": 53, "wind_dir": "ESE", "wind_kph": 13.3, "wind_mph": 8.3, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.03, "vis_miles": 6.0, "dewpoint_c": 19.4, "dewpoint_f": 66.9, "time_epoch": 1722027600, "feelslike_c": 31.3, "feelslike_f": 88.3, "heatindex_c": 31.3, "heatindex_f": 88.3, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 119, "windchill_c": 29.2, "windchill_f": 84.6, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 64, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-26 17:00", "cloud": 92, "is_day": 1, "temp_c": 28.2, "temp_f": 82.8, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 23.3, "gust_mph": 14.5, "humidity": 58, "wind_dir": "SE", "wind_kph": 20.2, "wind_mph": 12.5, "condition": {"code": 1153, "icon": "//cdn.weatherapi.com/weather/64x64/day/266.png", "text": "Light drizzle"}, "precip_in": 0.03, "precip_mm": 0.67, "vis_miles": 1.0, "dewpoint_c": 20.2, "dewpoint_f": 68.3, "time_epoch": 1722031200, "feelslike_c": 30.4, "feelslike_f": 86.7, "heatindex_c": 30.4, "heatindex_f": 86.7, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 126, "windchill_c": 28.2, "windchill_f": 82.8, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-26 18:00", "cloud": 76, "is_day": 1, "temp_c": 27.3, "temp_f": 81.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 27.6, "gust_mph": 17.2, "humidity": 69, "wind_dir": "SE", "wind_kph": 20.9, "wind_mph": 13.0, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.06, "vis_miles": 6.0, "dewpoint_c": 21.0, "dewpoint_f": 69.7, "time_epoch": 1722034800, "feelslike_c": 29.4, "feelslike_f": 85.0, "heatindex_c": 29.4, "heatindex_f": 85.0, "pressure_in": 29.94, "pressure_mb": 1014.0, "wind_degree": 135, "windchill_c": 27.3, "windchill_f": 81.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-26 19:00", "cloud": 84, "is_day": 1, "temp_c": 26.3, "temp_f": 79.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.1, "gust_mph": 15.6, "humidity": 73, "wind_dir": "SE", "wind_kph": 18.4, "wind_mph": 11.4, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.01, "vis_miles": 6.0, "dewpoint_c": 21.1, "dewpoint_f": 70.1, "time_epoch": 1722038400, "feelslike_c": 28.4, "feelslike_f": 83.1, "heatindex_c": 28.4, "heatindex_f": 83.1, "pressure_in": 29.94, "pressure_mb": 1014.0, "wind_degree": 143, "windchill_c": 26.3, "windchill_f": 79.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 60, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-26 20:00", "cloud": 32, "is_day": 1, "temp_c": 25.1, "temp_f": 77.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.5, "gust_mph": 15.9, "humidity": 78, "wind_dir": "SE", "wind_kph": 17.6, "wind_mph": 11.0, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 21.2, "dewpoint_f": 70.2, "time_epoch": 1722042000, "feelslike_c": 27.2, "feelslike_f": 80.9, "heatindex_c": 27.2, "heatindex_f": 80.9, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 141, "windchill_c": 25.1, "windchill_f": 77.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-26 21:00", "cloud": 18, "is_day": 0, "temp_c": 24.1, "temp_f": 75.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 26.4, "gust_mph": 16.4, "humidity": 83, "wind_dir": "SE", "wind_kph": 16.9, "wind_mph": 10.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.9, "dewpoint_f": 69.6, "time_epoch": 1722045600, "feelslike_c": 26.2, "feelslike_f": 79.2, "heatindex_c": 26.2, "heatindex_f": 79.2, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 141, "windchill_c": 24.1, "windchill_f": 75.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-26 22:00", "cloud": 16, "is_day": 0, "temp_c": 23.3, "temp_f": 74.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.0, "gust_mph": 15.5, "humidity": 85, "wind_dir": "SE", "wind_kph": 16.2, "wind_mph": 10.1, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.0, "time_epoch": 1722049200, "feelslike_c": 25.5, "feelslike_f": 78.0, "heatindex_c": 25.5, "heatindex_f": 78.0, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 143, "windchill_c": 23.3, "windchill_f": 74.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-26 23:00", "cloud": 25, "is_day": 0, "temp_c": 22.8, "temp_f": 73.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 23.6, "gust_mph": 14.7, "humidity": 88, "wind_dir": "SSE", "wind_kph": 15.1, "wind_mph": 9.4, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.4, "dewpoint_f": 68.7, "time_epoch": 1722052800, "feelslike_c": 25.1, "feelslike_f": 77.1, "heatindex_c": 25.1, "heatindex_f": 77.1, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 146, "windchill_c": 22.8, "windchill_f": 73.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:28 PM", "moonset": "12:20 PM", "sunrise": "06:35 AM", "moonrise": "No moonrise", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Waning Gibbous", "moon_illumination": 74}, "date_epoch": 1721952000}, {"day": {"uv": 11.0, "avgtemp_c": 24.0, "avgtemp_f": 75.1, "avgvis_km": 8.3, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "maxtemp_c": 28.4, "maxtemp_f": 83.2, "mintemp_c": 20.4, "mintemp_f": 68.6, "avghumidity": 81, "maxwind_kph": 20.9, "maxwind_mph": 13.0, "avgvis_miles": 5.0, "totalsnow_cm": 0.0, "totalprecip_in": 0.01, "totalprecip_mm": 0.38, "daily_will_it_rain": 1, "daily_will_it_snow": 0, "daily_chance_of_rain": 86, "daily_chance_of_snow": 0}, "date": "2024-07-27", "hour": [{"uv": 0, "time": "2024-07-27 00:00", "cloud": 34, "is_day": 0, "temp_c": 22.3, "temp_f": 72.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.2, "gust_mph": 13.8, "humidity": 89, "wind_dir": "SE", "wind_kph": 14.4, "wind_mph": 8.9, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.3, "dewpoint_f": 68.5, "time_epoch": 1722056400, "feelslike_c": 24.7, "feelslike_f": 76.5, "heatindex_c": 24.7, "heatindex_f": 76.5, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 142, "windchill_c": 22.3, "windchill_f": 72.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-27 01:00", "cloud": 38, "is_day": 0, "temp_c": 21.8, "temp_f": 71.2, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.4, "gust_mph": 12.1, "humidity": 91, "wind_dir": "SE", "wind_kph": 12.6, "wind_mph": 7.8, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.2, "dewpoint_f": 68.4, "time_epoch": 1722060000, "feelslike_c": 21.8, "feelslike_f": 71.2, "heatindex_c": 24.5, "heatindex_f": 76.1, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 142, "windchill_c": 21.8, "windchill_f": 71.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-27 02:00", "cloud": 40, "is_day": 0, "temp_c": 21.3, "temp_f": 70.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 15.7, "gust_mph": 9.8, "humidity": 93, "wind_dir": "SE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1003, "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png", "text": "Partly Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.1, "dewpoint_f": 68.1, "time_epoch": 1722063600, "feelslike_c": 21.3, "feelslike_f": 70.3, "heatindex_c": 22.6, "heatindex_f": 72.7, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 135, "windchill_c": 21.3, "windchill_f": 70.3, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-27 03:00", "cloud": 46, "is_day": 0, "temp_c": 20.9, "temp_f": 69.7, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 15.7, "gust_mph": 9.7, "humidity": 95, "wind_dir": "SSE", "wind_kph": 9.4, "wind_mph": 5.8, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 19.9, "dewpoint_f": 67.8, "time_epoch": 1722067200, "feelslike_c": 20.9, "feelslike_f": 69.7, "heatindex_c": 21.6, "heatindex_f": 70.9, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 148, "windchill_c": 20.9, "windchill_f": 69.7, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-27 04:00", "cloud": 49, "is_day": 0, "temp_c": 20.7, "temp_f": 69.2, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 18.0, "gust_mph": 11.2, "humidity": 95, "wind_dir": "SSE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 19.8, "dewpoint_f": 67.6, "time_epoch": 1722070800, "feelslike_c": 20.7, "feelslike_f": 69.2, "heatindex_c": 21.0, "heatindex_f": 69.8, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 148, "windchill_c": 20.7, "windchill_f": 69.2, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-27 05:00", "cloud": 56, "is_day": 0, "temp_c": 20.5, "temp_f": 69.0, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 16.6, "gust_mph": 10.3, "humidity": 96, "wind_dir": "SE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 19.7, "dewpoint_f": 67.5, "time_epoch": 1722074400, "feelslike_c": 20.5, "feelslike_f": 69.0, "heatindex_c": 20.7, "heatindex_f": 69.3, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 144, "windchill_c": 20.5, "windchill_f": 69.0, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-27 06:00", "cloud": 67, "is_day": 0, "temp_c": 20.6, "temp_f": 69.1, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 16.2, "gust_mph": 10.0, "humidity": 96, "wind_dir": "SE", "wind_kph": 9.7, "wind_mph": 6.0, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/night/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1722078000, "feelslike_c": 20.6, "feelslike_f": 69.1, "heatindex_c": 20.7, "heatindex_f": 69.2, "pressure_in": 29.97, "pressure_mb": 1015.0, "wind_degree": 143, "windchill_c": 20.6, "windchill_f": 69.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-27 07:00", "cloud": 71, "is_day": 1, "temp_c": 21.2, "temp_f": 70.1, "vis_km": 2.0, "snow_cm": 0.0, "gust_kph": 15.1, "gust_mph": 9.4, "humidity": 96, "wind_dir": "SE", "wind_kph": 9.4, "wind_mph": 5.8, "condition": {"code": 1030, "icon": "//cdn.weatherapi.com/weather/64x64/day/143.png", "text": "Mist"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 1.0, "dewpoint_c": 19.9, "dewpoint_f": 67.8, "time_epoch": 1722081600, "feelslike_c": 21.2, "feelslike_f": 70.1, "heatindex_c": 22.5, "heatindex_f": 72.6, "pressure_in": 29.98, "pressure_mb": 1015.0, "wind_degree": 137, "windchill_c": 21.2, "windchill_f": 70.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-27 08:00", "cloud": 69, "is_day": 1, "temp_c": 22.1, "temp_f": 71.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 14.9, "gust_mph": 9.3, "humidity": 91, "wind_dir": "SE", "wind_kph": 10.8, "wind_mph": 6.7, "condition": {"code": 1006, "icon": "//cdn.weatherapi.com/weather/64x64/day/119.png", "text": "Cloudy "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.2, "dewpoint_f": 68.3, "time_epoch": 1722085200, "feelslike_c": 23.9, "feelslike_f": 75.0, "heatindex_c": 23.9, "heatindex_f": 75.0, "pressure_in": 29.99, "pressure_mb": 1016.0, "wind_degree": 144, "windchill_c": 22.1, "windchill_f": 71.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-27 09:00", "cloud": 100, "is_day": 1, "temp_c": 23.1, "temp_f": 73.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 16.0, "gust_mph": 9.9, "humidity": 85, "wind_dir": "SSE", "wind_kph": 13.0, "wind_mph": 8.1, "condition": {"code": 1009, "icon": "//cdn.weatherapi.com/weather/64x64/day/122.png", "text": "Overcast "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.5, "dewpoint_f": 68.9, "time_epoch": 1722088800, "feelslike_c": 25.0, "feelslike_f": 76.9, "heatindex_c": 25.0, "heatindex_f": 76.9, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 148, "windchill_c": 23.1, "windchill_f": 73.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-27 10:00", "cloud": 100, "is_day": 1, "temp_c": 23.7, "temp_f": 74.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 18.3, "gust_mph": 11.4, "humidity": 82, "wind_dir": "SSE", "wind_kph": 15.5, "wind_mph": 9.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.02, "vis_miles": 6.0, "dewpoint_c": 20.8, "dewpoint_f": 69.5, "time_epoch": 1722092400, "feelslike_c": 25.7, "feelslike_f": 78.3, "heatindex_c": 25.7, "heatindex_f": 78.3, "pressure_in": 30.01, "pressure_mb": 1016.0, "wind_degree": 157, "windchill_c": 23.7, "windchill_f": 74.7, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 86, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-27 11:00", "cloud": 100, "is_day": 1, "temp_c": 24.1, "temp_f": 75.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 19.5, "gust_mph": 12.1, "humidity": 82, "wind_dir": "SSE", "wind_kph": 16.2, "wind_mph": 10.1, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.07, "vis_miles": 6.0, "dewpoint_c": 21.2, "dewpoint_f": 70.1, "time_epoch": 1722096000, "feelslike_c": 26.1, "feelslike_f": 79.0, "heatindex_c": 26.1, "heatindex_f": 79.0, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 160, "windchill_c": 24.1, "windchill_f": 75.4, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 5.0, "time": "2024-07-27 12:00", "cloud": 100, "is_day": 1, "temp_c": 24.8, "temp_f": 76.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.6, "gust_mph": 13.4, "humidity": 82, "wind_dir": "SSE", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.07, "vis_miles": 6.0, "dewpoint_c": 21.2, "dewpoint_f": 70.1, "time_epoch": 1722099600, "feelslike_c": 26.9, "feelslike_f": 80.3, "heatindex_c": 26.9, "heatindex_f": 80.3, "pressure_in": 30.0, "pressure_mb": 1016.0, "wind_degree": 165, "windchill_c": 24.8, "windchill_f": 76.7, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-27 13:00", "cloud": 94, "is_day": 1, "temp_c": 26.3, "temp_f": 79.3, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.0, "gust_mph": 13.0, "humidity": 76, "wind_dir": "S", "wind_kph": 17.3, "wind_mph": 10.7, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.07, "vis_miles": 6.0, "dewpoint_c": 21.1, "dewpoint_f": 69.9, "time_epoch": 1722103200, "feelslike_c": 28.4, "feelslike_f": 83.1, "heatindex_c": 28.4, "heatindex_f": 83.1, "pressure_in": 29.99, "pressure_mb": 1015.0, "wind_degree": 170, "windchill_c": 26.3, "windchill_f": 79.3, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-27 14:00", "cloud": 100, "is_day": 1, "temp_c": 27.0, "temp_f": 80.7, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 21.1, "gust_mph": 13.1, "humidity": 65, "wind_dir": "S", "wind_kph": 18.4, "wind_mph": 11.4, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.1, "vis_miles": 6.0, "dewpoint_c": 20.6, "dewpoint_f": 69.2, "time_epoch": 1722106800, "feelslike_c": 29.1, "feelslike_f": 84.3, "heatindex_c": 29.1, "heatindex_f": 84.3, "pressure_in": 29.96, "pressure_mb": 1015.0, "wind_degree": 185, "windchill_c": 27.0, "windchill_f": 80.7, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 100, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-27 15:00", "cloud": 80, "is_day": 1, "temp_c": 27.4, "temp_f": 81.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 24.4, "gust_mph": 15.1, "humidity": 63, "wind_dir": "SSW", "wind_kph": 20.9, "wind_mph": 13.0, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.02, "vis_miles": 6.0, "dewpoint_c": 20.2, "dewpoint_f": 68.3, "time_epoch": 1722110400, "feelslike_c": 29.4, "feelslike_f": 84.9, "heatindex_c": 29.4, "heatindex_f": 84.9, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 193, "windchill_c": 27.4, "windchill_f": 81.4, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 76, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-27 16:00", "cloud": 80, "is_day": 1, "temp_c": 27.8, "temp_f": 82.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 25.4, "gust_mph": 15.8, "humidity": 62, "wind_dir": "SSW", "wind_kph": 20.9, "wind_mph": 13.0, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.02, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.7, "time_epoch": 1722114000, "feelslike_c": 29.7, "feelslike_f": 85.5, "heatindex_c": 29.7, "heatindex_f": 85.5, "pressure_in": 29.94, "pressure_mb": 1014.0, "wind_degree": 195, "windchill_c": 27.8, "windchill_f": 82.1, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 82, "chance_of_snow": 0}, {"uv": 6.0, "time": "2024-07-27 17:00", "cloud": 81, "is_day": 1, "temp_c": 28.1, "temp_f": 82.6, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.5, "gust_mph": 14.0, "humidity": 60, "wind_dir": "SSW", "wind_kph": 18.7, "wind_mph": 11.6, "condition": {"code": 1063, "icon": "//cdn.weatherapi.com/weather/64x64/day/176.png", "text": "Patchy rain nearby"}, "precip_in": 0.0, "precip_mm": 0.01, "vis_miles": 6.0, "dewpoint_c": 19.7, "dewpoint_f": 67.4, "time_epoch": 1722117600, "feelslike_c": 29.9, "feelslike_f": 85.9, "heatindex_c": 29.9, "heatindex_f": 85.9, "pressure_in": 29.93, "pressure_mb": 1013.0, "wind_degree": 198, "windchill_c": 28.1, "windchill_f": 82.6, "will_it_rain": 1, "will_it_snow": 0, "chance_of_rain": 78, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-27 18:00", "cloud": 21, "is_day": 1, "temp_c": 27.7, "temp_f": 81.8, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.2, "gust_mph": 13.8, "humidity": 58, "wind_dir": "SSW", "wind_kph": 18.0, "wind_mph": 11.2, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.5, "dewpoint_f": 67.0, "time_epoch": 1722121200, "feelslike_c": 29.4, "feelslike_f": 85.0, "heatindex_c": 29.4, "heatindex_f": 85.0, "pressure_in": 29.92, "pressure_mb": 1013.0, "wind_degree": 197, "windchill_c": 27.7, "windchill_f": 81.8, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-27 19:00", "cloud": 13, "is_day": 1, "temp_c": 26.7, "temp_f": 80.1, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 22.4, "gust_mph": 13.9, "humidity": 64, "wind_dir": "S", "wind_kph": 15.5, "wind_mph": 9.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.8, "dewpoint_f": 67.6, "time_epoch": 1722124800, "feelslike_c": 28.5, "feelslike_f": 83.3, "heatindex_c": 28.5, "heatindex_f": 83.3, "pressure_in": 29.92, "pressure_mb": 1013.0, "wind_degree": 175, "windchill_c": 26.7, "windchill_f": 80.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 7.0, "time": "2024-07-27 20:00", "cloud": 12, "is_day": 1, "temp_c": 25.5, "temp_f": 77.9, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 30.2, "gust_mph": 18.8, "humidity": 71, "wind_dir": "SSE", "wind_kph": 20.2, "wind_mph": 12.5, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png", "text": "Sunny"}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.2, "dewpoint_f": 68.4, "time_epoch": 1722128400, "feelslike_c": 27.3, "feelslike_f": 81.1, "heatindex_c": 27.3, "heatindex_f": 81.1, "pressure_in": 29.93, "pressure_mb": 1013.0, "wind_degree": 155, "windchill_c": 25.5, "windchill_f": 77.9, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-27 21:00", "cloud": 6, "is_day": 0, "temp_c": 24.5, "temp_f": 76.0, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 32.2, "gust_mph": 20.0, "humidity": 77, "wind_dir": "SSE", "wind_kph": 18.7, "wind_mph": 11.6, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.0, "dewpoint_f": 68.0, "time_epoch": 1722132000, "feelslike_c": 26.4, "feelslike_f": 79.5, "heatindex_c": 26.4, "heatindex_f": 79.5, "pressure_in": 29.93, "pressure_mb": 1014.0, "wind_degree": 164, "windchill_c": 24.5, "windchill_f": 76.1, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-27 22:00", "cloud": 5, "is_day": 0, "temp_c": 23.6, "temp_f": 74.5, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 31.4, "gust_mph": 19.5, "humidity": 81, "wind_dir": "SSE", "wind_kph": 17.6, "wind_mph": 11.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 19.9, "dewpoint_f": 67.9, "time_epoch": 1722135600, "feelslike_c": 25.7, "feelslike_f": 78.2, "heatindex_c": 25.7, "heatindex_f": 78.2, "pressure_in": 29.95, "pressure_mb": 1014.0, "wind_degree": 167, "windchill_c": 23.6, "windchill_f": 74.5, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}, {"uv": 0, "time": "2024-07-27 23:00", "cloud": 8, "is_day": 0, "temp_c": 23.0, "temp_f": 73.4, "vis_km": 10.0, "snow_cm": 0.0, "gust_kph": 34.7, "gust_mph": 21.6, "humidity": 85, "wind_dir": "SSE", "wind_kph": 20.9, "wind_mph": 13.0, "condition": {"code": 1000, "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png", "text": "Clear "}, "precip_in": 0.0, "precip_mm": 0.0, "vis_miles": 6.0, "dewpoint_c": 20.2, "dewpoint_f": 68.3, "time_epoch": 1722139200, "feelslike_c": 25.2, "feelslike_f": 77.3, "heatindex_c": 25.2, "heatindex_f": 77.3, "pressure_in": 29.96, "pressure_mb": 1014.0, "wind_degree": 160, "windchill_c": 23.0, "windchill_f": 73.4, "will_it_rain": 0, "will_it_snow": 0, "chance_of_rain": 0, "chance_of_snow": 0}], "astro": {"sunset": "08:27 PM", "moonset": "01:28 PM", "sunrise": "06:36 AM", "moonrise": "12:01 AM", "is_sun_up": 1, "is_moon_up": 0, "moon_phase": "Waning Gibbous", "moon_illumination": 63}, "date_epoch": 1722038400}]}, "location": {"lat": 32.97, "lon": -96.3, "name": "Royse City", "tz_id": "America/Chicago", "region": "Texas", "country": "USA", "localtime": "2024-07-25 10:26", "localtime_epoch": 1721921217}}	2024-07-25 15:28:19.194208	0	\N
\.


                                                                                                                                                                                                                                                                                                                                                                                                                 restore.sql                                                                                         0000600 0004000 0002000 00000125535 14656737537 0015426 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "Weather_v2";
--
-- Name: Weather_v2; Type: DATABASE; Schema: -; Owner: python
--

CREATE DATABASE "Weather_v2" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE "Weather_v2" OWNER TO python;

\connect "Weather_v2"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: copy_payload_to_table(); Type: PROCEDURE; Schema: public; Owner: python
--

CREATE PROCEDURE public.copy_payload_to_table()
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.copy_payload_to_table();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/

BEGIN
    COPY public.weatherjsonload (jsondata) FROM '/datashare/file.txt';
END;

$$;


ALTER PROCEDURE public.copy_payload_to_table() OWNER TO python;

--
-- Name: insert_current_conditions(); Type: PROCEDURE; Schema: public; Owner: python
--

CREATE PROCEDURE public.insert_current_conditions()
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
 *  Object Type:	    Stored Procedure
 *  Function:        
 *  Created By:      
 *  Create Date:     
 *  Maintenance Log:
 *  Execution:       call public.insert_current_conditions();  --Do not remove parentheses
 *
 *  Date          Modified By             Description
 *  ----------    --------------------    ---------------------------------------------------------
 **************************************************************************************************/
DECLARE v_message TEXT;
        v_sqlstate TEXT;
        _countofrows int;
BEGIN
    DROP TABLE IF EXISTS _current_conditions;

    CREATE TEMP TABLE _current_conditions AS 
    SELECT l.locationid,
           CAST(jsondata -> 'current' ->> 'last_updated_epoch' AS int8) AS last_updated_epoch,
           CAST(jsondata -> 'current' ->> 'last_updated' AS timestamp) AS last_updated,
           CAST(jsondata -> 'current' ->> 'temp_c' AS float8) AS temp_c,
           CAST(jsondata -> 'current' ->> 'temp_f' AS float8) AS temp_f,
           CAST(jsondata -> 'current' ->> 'is_day' AS bit) AS isday,
           jsondata -> 'current' -> 'condition' ->> 'text' AS current_condition,
           CAST(jsondata -> 'current' ->> 'wind_mph' AS float8) AS wind_mph,
           CAST(jsondata -> 'current' ->> 'wind_kph' AS float8) AS wind_kph,
           CAST(jsondata -> 'current' ->> 'wind_degree' AS float8) AS wind_degree,
           jsondata -> 'current' ->> 'wind_dir' AS wind_direction,
           CAST(jsondata -> 'current' ->> 'pressure_mb' AS float8) AS pressure_mb,
           CAST(jsondata -> 'current' ->> 'pressure_in' AS float8) AS pressure_in,
           CAST(jsondata -> 'current' ->> 'precip_mm' AS float8) AS precip_mm,
           CAST(jsondata -> 'current' ->> 'precip_in' AS float8) AS precip_in,
           CAST(jsondata -> 'current' ->> 'humidity' AS float8) AS humidity,
           CAST(jsondata -> 'current' ->> 'cloud' AS float8) AS cloud,
           CAST(jsondata -> 'current' ->> 'feelslike_c' AS float8) AS feelslike_c,
           CAST(jsondata -> 'current' ->> 'feelslike_f' AS float8) AS feelslike_f,
           CAST(jsondata -> 'current' ->> 'windchill_c' AS float8) AS windchill_c,
           CAST(jsondata -> 'current' ->> 'windchill_f' AS float8) AS windchill_f,
           CAST(jsondata -> 'current' ->> 'heatindex_c' AS float8) AS heatindex_c,
           CAST(jsondata -> 'current' ->> 'heatindex_f' AS float8) AS heatindex_f,
           CAST(jsondata -> 'current' ->> 'dewpoint_c' AS float8) AS dewpoint_c,
           CAST(jsondata -> 'current' ->> 'dewpoint_f' AS float8) AS dewpoint_f,
           CAST(jsondata -> 'current' ->> 'vis_km' AS float8) AS vis_km,
           CAST(jsondata -> 'current' ->> 'vis_miles' AS float8) AS vis_miles,
           CAST(jsondata -> 'current' ->> 'uv' AS float8) AS uv,
           CAST(jsondata -> 'current' ->> 'gust_mph' AS float8) AS gust_mph,
           CAST(jsondata -> 'current' ->> 'gust_kph' AS float8) AS gust_kph 
    FROM weatherjsonload wjl
    INNER JOIN public.location l ON jsondata -> 'location' ->> 'name' = l."name"
    WHERE wjl.processed = 0;

    GET DIAGNOSTICS _countofrows = ROW_COUNT;
	RAISE NOTICE 'Temp table count: %', _countofrows;

	
    MERGE INTO public.currentconditions AS t 

    USING _current_conditions AS s 
    ON s.locationid = t.locationid 
    AND s.last_updated_epoch = t.last_updated_epoch

    WHEN MATCHED THEN
    UPDATE SET temp_c = s.temp_c,
               temp_f = s.temp_f,
               isday = s.isday, 
               current_conditions = s.current_condition,
               wind_mph = s.wind_mph,
               wind_kph = s.wind_kph,
               wind_degree = s.wind_degree,
               wind_direction = s.wind_direction,
               pressure_mb = s.pressure_mb,
               pressure_in = s.pressure_in,
               precip_mm = s.precip_mm,
               precip_in = s.precip_in,
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
               vis_km = s.vis_km,
               vis_miles = s.vis_miles,
               uv = s.uv,
               gust_mph = s.gust_mph,
               gust_kph = s.gust_kph

    WHEN NOT MATCHED THEN 
    INSERT (locationid,
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
            gust_kph)
    VALUES (s.locationid,
            s.last_updated_epoch,
            s.last_updated,
            s.temp_c,
            s.temp_f,
            s.isday,
            s.current_condition,
            s.wind_mph,
            s.wind_kph,
            s.wind_degree,
            s.wind_direction,
            s.pressure_mb,
            s.pressure_in,
			s.precip_mm,
			s.precip_in, 
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
            s.vis_km,
            s.vis_miles,
            s.uv,
            s.gust_mph,
            s.gust_kph
            );

    EXCEPTION WHEN OTHERS THEN 
        GET STACKED DIAGNOSTICS v_message = message_text,
                                v_sqlstate = returned_sqlstate;

        INSERT INTO public.ErrorLog(tablename, errornumber, errormessage)
        VALUES('CurrentConditions', v_sqlstate, v_message);

END;

$$;


ALTER PROCEDURE public.insert_current_conditions() OWNER TO python;

--
-- Name: insert_daily_forecast(); Type: PROCEDURE; Schema: public; Owner: python
--

CREATE PROCEDURE public.insert_daily_forecast()
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER PROCEDURE public.insert_daily_forecast() OWNER TO python;

--
-- Name: insert_hourlyforecast(); Type: PROCEDURE; Schema: public; Owner: python
--

CREATE PROCEDURE public.insert_hourlyforecast()
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER PROCEDURE public.insert_hourlyforecast() OWNER TO python;

--
-- Name: insert_location(); Type: PROCEDURE; Schema: public; Owner: python
--

CREATE PROCEDURE public.insert_location()
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.insert_location();
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/

BEGIN
    MERGE INTO public.location t

    USING (SELECT DISTINCT jsondata -> 'location' ->> 'name' AS name,
                    jsondata -> 'location' ->> 'region' AS Region,
                    jsondata -> 'location' ->> 'country' AS Country,
                    cast(jsondata -> 'location' ->> 'lat' AS numeric(9,2)) AS Latitude,
                    cast(jsondata -> 'location' ->> 'lon' AS numeric(9,2)) AS Longitude,
                    jsondata -> 'location' ->> 'tz_id' AS TimeZone,
                    cast(jsondata -> 'location' ->> 'localtime_epoch' AS int) AS LocalTime_Epoch,
                    cast(jsondata -> 'location' ->> 'localtime' AS timestamp) AS local_time
            from weatherjsonload
            where processed = 0) AS s

    ON s.name = t.name
    AND s.region = t.region
    --AND s.localtime = t.local_time

    WHEN MATCHED THEN
    UPDATE SET 
                name = s.name,
                region = s.region,
                country = s.country, 
                latitude = s.latitude,
                longitude = s.longitude,
                timezone = s.timezone,
                localtime_epoch = s.localtime_epoch,
                local_time = s.local_time

    WHEN NOT MATCHED THEN
    INSERT (name, region, country, latitude, longitude, timezone, localtime_epoch, local_time)
    VALUES (s.name, s.region, s.country, s.latitude, s.longitude, s.timezone, s.localtime_epoch, s.local_time)
    ;
	
	UPDATE public.weatherjsonload
	SET processed = 1,
	   processed_date = now()
    WHERE processed = 0;

    RAISE NOTICE 'Finished procedure insert_location';
	
	DELETE FROM public.location
	WHERE name IS NULL;
	    
END;

$$;


ALTER PROCEDURE public.insert_location() OWNER TO python;

--
-- Name: insert_location(character varying); Type: PROCEDURE; Schema: public; Owner: python
--

CREATE PROCEDURE public.insert_location(IN inpostalcode character varying)
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.insert_location();
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE v_message TEXT;
        v_sqlstate TEXT;
BEGIN
    MERGE INTO public.location t

    USING (SELECT DISTINCT jsondata -> 'location' ->> 'name' AS name,
                    jsondata -> 'location' ->> 'region' AS Region,
                    jsondata -> 'location' ->> 'country' AS Country,
                    cast(jsondata -> 'location' ->> 'lat' AS numeric(9,2)) AS Latitude,
                    cast(jsondata -> 'location' ->> 'lon' AS numeric(9,2)) AS Longitude,
                    jsondata -> 'location' ->> 'tz_id' AS TimeZone,
                    cast(jsondata -> 'location' ->> 'localtime_epoch' AS int) AS LocalTime_Epoch,
                    cast(jsondata -> 'location' ->> 'localtime' AS timestamp) AS local_time
            from weatherjsonload
            where processed = 0) AS s

    ON s.name = t.name
    AND s.region = t.region
    --AND s.localtime = t.local_time

    WHEN MATCHED THEN
    UPDATE SET 
	            postalcode = inPostalcode, 
                name = s.name,
                region = s.region,
                country = s.country, 
                latitude = s.latitude,
                longitude = s.longitude,
                timezone = s.timezone,
                local_time_epoch = s.localtime_epoch,
                local_time = s.local_time

    WHEN NOT MATCHED THEN
    INSERT (postalcode, name, region, country, latitude, longitude, timezone, local_time_epoch, local_time)
    VALUES (inPostalCode, s.name, s.region, s.country, s.latitude, s.longitude, s.timezone, s.localtime_epoch, s.local_time);
    EXCEPTION WHEN OTHERS THEN 
        GET STACKED DIAGNOSTICS v_message = message_text,
                                v_sqlstate = returned_sqlstate;

        INSERT INTO public.ErrorLog(tablename, errornumber, errormessage)
        VALUES('Location', v_sqlstate, v_message);
	
    RAISE NOTICE 'Finished procedure insert_location';
	
	DELETE FROM public.location
	WHERE name IS NULL;
	    
END;

$$;


ALTER PROCEDURE public.insert_location(IN inpostalcode character varying) OWNER TO python;

--
-- Name: insert_weatherjsonload(jsonb); Type: PROCEDURE; Schema: public; Owner: python
--

CREATE PROCEDURE public.insert_weatherjsonload(IN in_wj jsonb)
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.<proc name>();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE wj jsonb;
BEGIN

    wj := in_wj;

	INSERT INTO public.weatherjsonload(jsondata)
	VALUES (wj);
END;

$$;


ALTER PROCEDURE public.insert_weatherjsonload(IN in_wj jsonb) OWNER TO python;

--
-- Name: insert_weatherjsonload(text); Type: PROCEDURE; Schema: public; Owner: python
--

CREATE PROCEDURE public.insert_weatherjsonload(IN in_wj text)
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.<proc name>();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE wj jsonb;
BEGIN

    wj := in_wj;

	INSERT INTO public.weatherjsonload(jsondata)
	VALUES (wj);

END;

$$;


ALTER PROCEDURE public.insert_weatherjsonload(IN in_wj text) OWNER TO python;

--
-- Name: update_json_to_processed(); Type: PROCEDURE; Schema: public; Owner: python
--

CREATE PROCEDURE public.update_json_to_processed()
    LANGUAGE plpgsql
    AS $$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.update_json_to_processed();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/

BEGIN
	UPDATE public.weatherjsonload
	SET processed = 1,
	   processed_date = now()
    WHERE processed = 0;
END;

$$;


ALTER PROCEDURE public.update_json_to_processed() OWNER TO python;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: currentconditions; Type: TABLE; Schema: public; Owner: python
--

CREATE TABLE public.currentconditions (
    currentconditionid bigint NOT NULL,
    locationid bigint,
    last_updated_epoch bigint,
    last_updated timestamp without time zone,
    temp_c numeric(6,2),
    temp_f numeric(6,2),
    isday bit(1),
    current_conditions character varying(50),
    wind_mph numeric(6,2),
    wind_kph numeric(6,2),
    wind_degree numeric(6,2),
    wind_direction character varying(255),
    pressure_mb numeric(6,2),
    pressure_in numeric(6,2),
    precip_mm numeric(6,2),
    precip_in numeric(6,2),
    humidity numeric(6,2),
    cloud numeric(6,2),
    feelslike_c numeric(6,2),
    feelslike_f numeric(6,2),
    windchill_c numeric(6,2),
    windchill_f numeric(6,2),
    heatindex_c numeric(6,2),
    heatindex_f numeric(6,2),
    dewpoint_c numeric(6,2),
    dewpoint_f numeric(6,2),
    vis_km numeric(6,2),
    vis_miles numeric(6,2),
    uv numeric(6,2),
    gust_mph numeric(6,2),
    gust_kph numeric(6,2)
);


ALTER TABLE public.currentconditions OWNER TO python;

--
-- Name: currentconditions_currentconditionid_seq; Type: SEQUENCE; Schema: public; Owner: python
--

ALTER TABLE public.currentconditions ALTER COLUMN currentconditionid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.currentconditions_currentconditionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: dailyforecast; Type: TABLE; Schema: public; Owner: python
--

CREATE TABLE public.dailyforecast (
    dailyforecastid integer NOT NULL,
    locationid bigint,
    forecast_date timestamp without time zone,
    forecast_date_epoch bigint,
    maxtemp_c numeric(6,2),
    maxtemp_f numeric(6,2),
    mintemp_c numeric(6,2),
    mintemp_f numeric(6,2),
    avgtemp_c numeric(6,2),
    avgtemp_f numeric(6,2),
    maxwind_mph numeric(6,2),
    maxwind_kph numeric(6,2),
    totalprecip_mm numeric(6,2),
    totalprecip_in numeric(6,2),
    totalsnow_cm numeric(6,2),
    avgvis_km numeric(6,2),
    avgvis_miles numeric(6,2),
    avghumidity numeric(6,2),
    daily_will_it_rain bit(1),
    daily_chance_of_rain numeric(6,2),
    daily_will_it_snow bit(1),
    daily_chance_of_snow numeric(6,2),
    conditions character varying(50),
    uv numeric(6,2)
);


ALTER TABLE public.dailyforecast OWNER TO python;

--
-- Name: dailyforecast_dailyforecastid_seq; Type: SEQUENCE; Schema: public; Owner: python
--

ALTER TABLE public.dailyforecast ALTER COLUMN dailyforecastid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dailyforecast_dailyforecastid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: errorlog; Type: TABLE; Schema: public; Owner: python
--

CREATE TABLE public.errorlog (
    errorlogid integer NOT NULL,
    logdate timestamp without time zone DEFAULT now(),
    tablename character varying(30),
    errornumber integer,
    errormessage character varying(500)
);


ALTER TABLE public.errorlog OWNER TO python;

--
-- Name: errorlog_errorlogid_seq; Type: SEQUENCE; Schema: public; Owner: python
--

ALTER TABLE public.errorlog ALTER COLUMN errorlogid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.errorlog_errorlogid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hourlyforecast; Type: TABLE; Schema: public; Owner: python
--

CREATE TABLE public.hourlyforecast (
    hourlyforecastid integer NOT NULL,
    locationid bigint,
    forecast_date timestamp without time zone,
    forecast_hour timestamp without time zone,
    forecast_time_epoch bigint,
    temp_c numeric(6,2),
    temp_f numeric(6,2),
    is_day bit(1),
    forecast_condition character varying(50),
    wind_mph numeric(6,2),
    wind_kph numeric(6,2),
    wind_degree numeric(6,2),
    wind_dir character varying(255),
    pressure_mb numeric(6,2),
    pressure_in numeric(6,2),
    precip_mm numeric(6,2),
    precip_in numeric(6,2),
    snow_cm numeric(6,2),
    humidity numeric(6,2),
    cloud numeric(6,2),
    feelslike_c numeric(6,2),
    feelslike_f numeric(6,2),
    windchill_c numeric(6,2),
    windchill_f numeric(6,2),
    heatindex_c numeric(6,2),
    heatindex_f numeric(6,2),
    dewpoint_c numeric(6,2),
    dewpoint_f numeric(6,2),
    will_it_rain bit(1),
    chance_of_rain numeric(6,2),
    will_it_snow bit(1),
    chance_of_snow numeric(6,2),
    vis_km numeric(6,2),
    vis_miles numeric(6,2),
    gust_mph numeric(6,2),
    gust_kph numeric(6,2),
    uv numeric(6,2)
);


ALTER TABLE public.hourlyforecast OWNER TO python;

--
-- Name: hourlyforecast_hourlyforecastid_seq; Type: SEQUENCE; Schema: public; Owner: python
--

ALTER TABLE public.hourlyforecast ALTER COLUMN hourlyforecastid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.hourlyforecast_hourlyforecastid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: location; Type: TABLE; Schema: public; Owner: python
--

CREATE TABLE public.location (
    locationid integer NOT NULL,
    postalcode character varying(25),
    name character varying(50),
    region character varying(50),
    country character varying(50),
    latitude numeric(6,2),
    longitude numeric(6,2),
    timezone character varying(50),
    local_time_epoch integer,
    local_time timestamp without time zone
);


ALTER TABLE public.location OWNER TO python;

--
-- Name: location_locationid_seq; Type: SEQUENCE; Schema: public; Owner: python
--

ALTER TABLE public.location ALTER COLUMN locationid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.location_locationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: weatherjsonload; Type: TABLE; Schema: public; Owner: python
--

CREATE TABLE public.weatherjsonload (
    wjl_id integer NOT NULL,
    jsondata jsonb,
    createdate timestamp without time zone DEFAULT now(),
    processed smallint DEFAULT 0,
    processed_date timestamp without time zone
);


ALTER TABLE public.weatherjsonload OWNER TO python;

--
-- Name: weatherjsonload_wjl_id_seq; Type: SEQUENCE; Schema: public; Owner: python
--

CREATE SEQUENCE public.weatherjsonload_wjl_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.weatherjsonload_wjl_id_seq OWNER TO python;

--
-- Name: weatherjsonload_wjl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: python
--

ALTER SEQUENCE public.weatherjsonload_wjl_id_seq OWNED BY public.weatherjsonload.wjl_id;


--
-- Name: weatherjsonload wjl_id; Type: DEFAULT; Schema: public; Owner: python
--

ALTER TABLE ONLY public.weatherjsonload ALTER COLUMN wjl_id SET DEFAULT nextval('public.weatherjsonload_wjl_id_seq'::regclass);


--
-- Data for Name: currentconditions; Type: TABLE DATA; Schema: public; Owner: python
--

COPY public.currentconditions (currentconditionid, locationid, last_updated_epoch, last_updated, temp_c, temp_f, isday, current_conditions, wind_mph, wind_kph, wind_degree, wind_direction, pressure_mb, pressure_in, precip_mm, precip_in, humidity, cloud, feelslike_c, feelslike_f, windchill_c, windchill_f, heatindex_c, heatindex_f, dewpoint_c, dewpoint_f, vis_km, vis_miles, uv, gust_mph, gust_kph) FROM stdin;
\.
COPY public.currentconditions (currentconditionid, locationid, last_updated_epoch, last_updated, temp_c, temp_f, isday, current_conditions, wind_mph, wind_kph, wind_degree, wind_direction, pressure_mb, pressure_in, precip_mm, precip_in, humidity, cloud, feelslike_c, feelslike_f, windchill_c, windchill_f, heatindex_c, heatindex_f, dewpoint_c, dewpoint_f, vis_km, vis_miles, uv, gust_mph, gust_kph) FROM '$$PATH$$/3416.dat';

--
-- Data for Name: dailyforecast; Type: TABLE DATA; Schema: public; Owner: python
--

COPY public.dailyforecast (dailyforecastid, locationid, forecast_date, forecast_date_epoch, maxtemp_c, maxtemp_f, mintemp_c, mintemp_f, avgtemp_c, avgtemp_f, maxwind_mph, maxwind_kph, totalprecip_mm, totalprecip_in, totalsnow_cm, avgvis_km, avgvis_miles, avghumidity, daily_will_it_rain, daily_chance_of_rain, daily_will_it_snow, daily_chance_of_snow, conditions, uv) FROM stdin;
\.
COPY public.dailyforecast (dailyforecastid, locationid, forecast_date, forecast_date_epoch, maxtemp_c, maxtemp_f, mintemp_c, mintemp_f, avgtemp_c, avgtemp_f, maxwind_mph, maxwind_kph, totalprecip_mm, totalprecip_in, totalsnow_cm, avgvis_km, avgvis_miles, avghumidity, daily_will_it_rain, daily_chance_of_rain, daily_will_it_snow, daily_chance_of_snow, conditions, uv) FROM '$$PATH$$/3418.dat';

--
-- Data for Name: errorlog; Type: TABLE DATA; Schema: public; Owner: python
--

COPY public.errorlog (errorlogid, logdate, tablename, errornumber, errormessage) FROM stdin;
\.
COPY public.errorlog (errorlogid, logdate, tablename, errornumber, errormessage) FROM '$$PATH$$/3420.dat';

--
-- Data for Name: hourlyforecast; Type: TABLE DATA; Schema: public; Owner: python
--

COPY public.hourlyforecast (hourlyforecastid, locationid, forecast_date, forecast_hour, forecast_time_epoch, temp_c, temp_f, is_day, forecast_condition, wind_mph, wind_kph, wind_degree, wind_dir, pressure_mb, pressure_in, precip_mm, precip_in, snow_cm, humidity, cloud, feelslike_c, feelslike_f, windchill_c, windchill_f, heatindex_c, heatindex_f, dewpoint_c, dewpoint_f, will_it_rain, chance_of_rain, will_it_snow, chance_of_snow, vis_km, vis_miles, gust_mph, gust_kph, uv) FROM stdin;
\.
COPY public.hourlyforecast (hourlyforecastid, locationid, forecast_date, forecast_hour, forecast_time_epoch, temp_c, temp_f, is_day, forecast_condition, wind_mph, wind_kph, wind_degree, wind_dir, pressure_mb, pressure_in, precip_mm, precip_in, snow_cm, humidity, cloud, feelslike_c, feelslike_f, windchill_c, windchill_f, heatindex_c, heatindex_f, dewpoint_c, dewpoint_f, will_it_rain, chance_of_rain, will_it_snow, chance_of_snow, vis_km, vis_miles, gust_mph, gust_kph, uv) FROM '$$PATH$$/3414.dat';

--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: python
--

COPY public.location (locationid, postalcode, name, region, country, latitude, longitude, timezone, local_time_epoch, local_time) FROM stdin;
\.
COPY public.location (locationid, postalcode, name, region, country, latitude, longitude, timezone, local_time_epoch, local_time) FROM '$$PATH$$/3412.dat';

--
-- Data for Name: weatherjsonload; Type: TABLE DATA; Schema: public; Owner: python
--

COPY public.weatherjsonload (wjl_id, jsondata, createdate, processed, processed_date) FROM stdin;
\.
COPY public.weatherjsonload (wjl_id, jsondata, createdate, processed, processed_date) FROM '$$PATH$$/3409.dat';

--
-- Name: currentconditions_currentconditionid_seq; Type: SEQUENCE SET; Schema: public; Owner: python
--

SELECT pg_catalog.setval('public.currentconditions_currentconditionid_seq', 3, true);


--
-- Name: dailyforecast_dailyforecastid_seq; Type: SEQUENCE SET; Schema: public; Owner: python
--

SELECT pg_catalog.setval('public.dailyforecast_dailyforecastid_seq', 3, true);


--
-- Name: errorlog_errorlogid_seq; Type: SEQUENCE SET; Schema: public; Owner: python
--

SELECT pg_catalog.setval('public.errorlog_errorlogid_seq', 1, false);


--
-- Name: hourlyforecast_hourlyforecastid_seq; Type: SEQUENCE SET; Schema: public; Owner: python
--

SELECT pg_catalog.setval('public.hourlyforecast_hourlyforecastid_seq', 864, true);


--
-- Name: location_locationid_seq; Type: SEQUENCE SET; Schema: public; Owner: python
--

SELECT pg_catalog.setval('public.location_locationid_seq', 2, true);


--
-- Name: weatherjsonload_wjl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: python
--

SELECT pg_catalog.setval('public.weatherjsonload_wjl_id_seq', 7, true);


--
-- Name: currentconditions currentconditions_pkey; Type: CONSTRAINT; Schema: public; Owner: python
--

ALTER TABLE ONLY public.currentconditions
    ADD CONSTRAINT currentconditions_pkey PRIMARY KEY (currentconditionid);


--
-- Name: dailyforecast dailyforecast_pkey; Type: CONSTRAINT; Schema: public; Owner: python
--

ALTER TABLE ONLY public.dailyforecast
    ADD CONSTRAINT dailyforecast_pkey PRIMARY KEY (dailyforecastid);


--
-- Name: hourlyforecast hourlyforecast_pkey; Type: CONSTRAINT; Schema: public; Owner: python
--

ALTER TABLE ONLY public.hourlyforecast
    ADD CONSTRAINT hourlyforecast_pkey PRIMARY KEY (hourlyforecastid);


--
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: python
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (locationid);


--
-- Name: errorlog pk_errorlog; Type: CONSTRAINT; Schema: public; Owner: python
--

ALTER TABLE ONLY public.errorlog
    ADD CONSTRAINT pk_errorlog PRIMARY KEY (errorlogid);


--
-- Name: weatherjsonload weatherjsonload_pkey; Type: CONSTRAINT; Schema: public; Owner: python
--

ALTER TABLE ONLY public.weatherjsonload
    ADD CONSTRAINT weatherjsonload_pkey PRIMARY KEY (wjl_id);


--
-- Name: ix_errorlog_logdate; Type: INDEX; Schema: public; Owner: python
--

CREATE INDEX ix_errorlog_logdate ON public.errorlog USING btree (logdate);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   