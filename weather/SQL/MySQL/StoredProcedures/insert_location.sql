use Weather_v2;

DROP PROCEDURE IF EXISTS insert_location;

delimiter //

CREATE PROCEDURE insert_location (_inPostalCode VARCHAR(25))
BEGIN
    DECLARE _postalCode VARCHAR(25);
    
    SET _postalCode = _inPostalCode;
    
    CREATE TEMPORARY TABLE source AS (
    SELECT DISTINCT _postalCode AS PostalCode,
       jsondata ->> '$.location.name' as location_name,
       jsondata ->> '$.location.region' as region,
       jsondata ->> '$.location.country' as country,
       jsondata -> '$.location.lat' as latitude,
       jsondata -> '$.location.lon' as longitude,
       jsondata ->> '$.location.tz_id' as timezone,
       jsondata -> '$.location.localtime_epoch' as local_time_epoch,
       jsondata ->> '$.location.localtime' as local_time
    FROM Weather_v2.weatherjsonload AS a
    WHERE processed = 0);

    INSERT INTO Weather_v2.Location(PostalCode, name, region, country, latitude, longitude, timezone, local_time_epoch, local_time)
    SELECT DISTINCT _postalCode AS PostalCode,
		   location_name,
		   region,
		   country,
		   latitude,
		   longitude,
		   timezone,
		   local_time_epoch,
		   local_time
    FROM source AS a
    ON DUPLICATE KEY UPDATE name = location_name,
                            region = a.region,
                            country = a.country,
                            latitude = a.latitude,
                            longitude = a.longitude,
                            timezone = a.timezone,
                            local_time_epoch = a.local_time_epoch,
                            local_time = a.local_time;
    
END;
//

delimiter ;
