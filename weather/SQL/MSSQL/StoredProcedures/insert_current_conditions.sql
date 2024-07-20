USE Weather_v2;
GO 

/*
 * DROP PROC dbo.insert_current_conditions
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].insert_current_conditions') )
BEGIN
    DROP PROC dbo.insert_current_conditions
    PRINT '<<< DROPPED PROC dbo.insert_current_conditions IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
go

CREATE PROC dbo.insert_current_conditions
AS

/*****************************************************************************
*  Object Type:	    Stored Procedure
*  Function:
*  Created By:
*  Create Date:
*  Input:
*  Output:
*  Maintenance Log:
*  Date          Modified By             Description
*  ----------    --------------------    -------------------------------------
******************************************************************************/
BEGIN
    DROP TABLE IF EXISTS #source;

    SELECT l.LocationID,
        a.name,
        a.last_updated_epoch,
        a.last_updated,
        a.temp_c,
        a.temp_f,
        a.isday,
        a.current_conditions,
        a.wind_mph,
        a.wind_kph,
        a.wind_degree,
        a.wind_dir,
        a.pressure_mb,
        a.pressure_in,
        a.precip_mm,
        a.precip_in,
        a.humidity,
        a.cloud,
        a.feelslike_c,
        a.feelslike_f,
        a.windchill_c,
        a.windchill_f,
        a.heatindex_c,
        a.heatindex_f,
        a.dewpoint_c,
        a.dewpoint_f,
        a.vis_km,
        a.vis_miles,
        a.uv,
        a.gust_mph,
        a.gust_kph
    INTO #source
    FROM dbo.WeatherJsonLoad lvl1
    CROSS APPLY openjson(lvl1.JsonData) WITH (
            name VARCHAR(50) '$.location.name',
            last_updated_epoch INT '$.current.last_updated_epoch',
            last_updated DATETIME '$.current.last_updated',
            temp_c NUMERIC(6, 2) '$.current.temp_c',
            temp_f NUMERIC(6, 2) '$.current.temp_f',
            isday BIT '$.current.is_day',
            current_conditions VARCHAR(50) '$.current.condition.text',
            wind_mph NUMERIC(6, 2) '$.current.wind_mph',
            wind_kph NUMERIC(6, 2) '$.current.wind_kph',
            wind_degree NUMERIC(6, 2) '$.current.wind_degree',
            wind_dir VARCHAR(25) '$.current.wind_dir',
            pressure_mb NUMERIC(6, 2) '$.current.pressure_mb',
            pressure_in NUMERIC(6, 2) '$.current.pressure_in',
            precip_mm NUMERIC(6, 2) '$.current.precip_mm',
            precip_in NUMERIC(6, 2) '$.current.precip_in',
            humidity NUMERIC(6, 2) '$.current.humidity',
            cloud NUMERIC(6, 2) '$.current.cloud',
            feelslike_c NUMERIC(6, 2) '$.current.feelslike_c',
            feelslike_f NUMERIC(6, 2) '$.current.feelslike_f',
            windchill_c NUMERIC(6, 2) '$.current.windchill_c',
            windchill_f NUMERIC(6, 2) '$.current.windchill_f',
            heatindex_c NUMERIC(6, 2) '$.current.heatindex_c',
            heatindex_f NUMERIC(6, 2) '$.current.heatindex_f',
            dewpoint_c NUMERIC(6, 2) '$.current.dewpoint_c',
            dewpoint_f NUMERIC(6, 2) '$.current.dewpoint_f',
            vis_km NUMERIC(6, 2) '$.current.vis_km',
            vis_miles NUMERIC(6, 2) '$.current.vis_miles',
            uv NUMERIC(6, 2) '$.current.uv',
            gust_mph NUMERIC(6, 2) '$.current.gust_mph',
            gust_kph NUMERIC(6, 2) '$.current.gust_kph'
            ) AS a
    INNER JOIN dbo.Location l
        ON l.name = a.name
    WHERE lvl1.Processed = 0;

    BEGIN TRY 
        MERGE dbo.CurrentConditions AS t

        USING #source AS s ON s.LocationID = t.LocationID 
                          AND s.last_updated_epoch = t.last_updated_epoch

        WHEN MATCHED THEN

        UPDATE 
        SET last_updated_epoch = s.last_updated_epoch,
            last_updated = s.last_updated,
            temp_c = s.temp_c,
            temp_f = s.temp_f,
            isday = s.isday,
            current_conditions = s.current_conditions,
            wind_mph = s.wind_mph,
            wind_kph = s.wind_kph,
            wind_degree = s.wind_degree,
            wind_direction = s.wind_dir,
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

        INSERT (LocationID, last_updated_epoch, last_updated, temp_c, temp_f, isday, current_conditions, wind_mph, wind_kph, wind_degree, wind_direction,
                pressure_mb, pressure_in, precip_mm, precip_in, humidity, cloud, feelslike_c, feelslike_f, windchill_c, windchill_f, heatindex_c, heatindex_f,
                dewpoint_c, dewpoint_f, vis_km, vis_miles, uv, gust_mph, gust_kph)
        VALUES (
                 s.LocationID, 
                 s.last_updated_epoch,
                 s.last_updated,
                 s.temp_c,
                 s.temp_f,
                 s.isday,
                 s.current_conditions, 
                 s.wind_mph,
                 s.wind_kph, 
                 s.wind_degree,
                 s.wind_dir,
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
            
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.Errorlog(TableName, ErrorNumber, ErrorMessage)
        VALUES ('CurrentConditions', ERROR_NUMBER(), ERROR_MESSAGE());
    END CATCH;
END 
GO 

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].insert_current_conditions') )
BEGIN
    PRINT '<<< CREATED PROC dbo.insert_current_conditions IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.insert_current_conditions IN ' + db_name() + ' ON ' + @@servername + '  >>>'

GO
    