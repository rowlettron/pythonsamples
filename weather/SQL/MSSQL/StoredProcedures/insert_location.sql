USE Weather_v2;
GO

/*
 * DROP PROC dbo.insert_location
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].insert_location') )
BEGIN
    DROP PROC dbo.insert_location
    PRINT '<<< DROPPED PROC dbo.insert_location IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
go

CREATE PROC dbo.insert_location @inPostalCode VARCHAR(25) 
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
    DECLARE @PostalCode VARCHAR(25) = @inPostalCode;

    DROP TABLE IF EXISTS #source;
    
    SELECT a.name,
           a.region,
           a.country,
           a.latitude,
           a.longitude,
           a.timezone,
           a.localtime_epoch,
           a.localtime
    INTO #source
    FROM dbo.WeatherJsonLoad AS lvl1
    CROSS APPLY OPENJSON(lvl1.JsonData) WITH (
        name VARCHAR(50) '$.location.name',
        region VARCHAR(50) '$.location.region',
        country VARCHAR(50) '$.location.country',
        latitude NUMERiC(6,2) '$.location.lat',
        longitude NUMERIC(6,2) '$.location.lon',
        timezone VARCHAR(50) '$.location.tz_id',
        localtime_epoch INT '$.location.localtime_epoch',
        localtime DATETIME '$.location.localtime'
    ) AS a
    WHERE Processed = 0;

    BEGIN TRY
        MERGE dbo.Location AS t

        USING #source AS s ON s.name = t.name 

        WHEN MATCHED THEN 
        UPDATE SET PostalCode = @PostalCode,
                   region = s.region,
                   country = s.country,
                   latitude = s.latitude,
                   longitude = s.longitude,
                   timezone = s.timezone,
                   localtime_epoch = s.localtime_epoch,
                   localtime = s.localtime 

        WHEN NOT MATCHED THEN 
        INSERT (PostalCode, name, region, country, latitude, longitude, timezone, localtime_epoch, localtime)
        VALUES (@PostalCode,
                s.name,
                s.region,
                s.country,
                s.latitude,
                s.longitude,
                s.timezone,
                s.localtime_epoch,
                s.localtime); 
    END TRY
    BEGIN CATCH
        INSERT INTO dbo.Errorlog(TableName, ErrorNumber, ErrorMessage)
        VALUES ('Location', ERROR_NUMBER(), ERROR_MESSAGE());
    END CATCH;
END
go

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].insert_location') )
BEGIN
    PRINT '<<< CREATED PROC dbo.insert_location IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.insert_location IN ' + db_name() + ' ON ' + @@servername + '  >>>'
go
