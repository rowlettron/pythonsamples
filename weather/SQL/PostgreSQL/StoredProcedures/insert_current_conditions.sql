CREATE OR REPLACE PROCEDURE public.insert_current_conditions() --Do not remove parentheses
LANGUAGE plpgsql AS $$
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
DECLARE dummyvariable varchar(50);
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

END;

$$
