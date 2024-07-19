CREATE OR REPLACE PROCEDURE insert_location(inPostalCode varchar(25))
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
	            postalcode = inPostalcode, 
                name = s.name,
                region = s.region,
                country = s.country, 
                latitude = s.latitude,
                longitude = s.longitude,
                timezone = s.timezone,
                localtime_epoch = s.localtime_epoch,
                "localtime" = s.local_time

    WHEN NOT MATCHED THEN
    INSERT (postalcode, name, region, country, latitude, longitude, timezone, localtime_epoch, "localtime")
    VALUES (inPostalCode, s.name, s.region, s.country, s.latitude, s.longitude, s.timezone, s.localtime_epoch, s.local_time)
    ;
	
    RAISE NOTICE 'Finished procedure insert_location';
	
	DELETE FROM public.location
	WHERE name IS NULL;
	    
END;

$$
