use Weather_v2;

DROP PROCEDURE IF EXISTS insert_location;

delimiter //

CREATE PROCEDURE insert_location (_inPostalCode VARCHAR(25))
BEGIN
    DECLARE _postalCode VARCHAR(25);
    
    SET _postalCode = _inPostalCode;
    
    CREATE TEMPORARY TABLE source AS (
    SELECT DISTINCT _postalCode AS PostalCode,
       jsondata ->> '$.location.name' as name,
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
		   name,
		   region,
		   country,
		   latitude,
		   longitude,
		   timezone,
		   local_time_epoch,
		   local_time
    FROM source
    ON DUPLICATE KEY UPDATE name = name,
                            region = region,
                            country = country,
                            latitude = latitude,
                            longitude = longitude,
                            timezone = timezone,
                            local_time_epoch = local_time_epoch,
                            local_time = local_time;
    
END;
//

delimiter ;
