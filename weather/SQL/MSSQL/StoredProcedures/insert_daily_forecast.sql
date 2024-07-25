USE Weather_v2;
GO

/*
 * DROP PROC dbo.insert_daily_forecast
 */
IF EXISTS (
        SELECT *
        FROM sys.procedures
        WHERE object_id = OBJECT_ID('[dbo].insert_daily_forecast')
        )
BEGIN
    DROP PROC dbo.insert_daily_forecast

    PRINT '<<< DROPPED PROC dbo.insert_daily_forecast IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
GO

CREATE PROC dbo.insert_daily_forecast
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
        b.forecast_date,
        b.forecast_date_epoch,
        c.maxtemp_c,
        c.maxtemp_f,
        c.mintemp_c,
        c.mintemp_f,
        c.avgtemp_c,
        c.avgtemp_f,
        c.maxwind_mph,
        c.maxwind_kph,
        c.totalprecip_mm,
        c.totalprecip_in,
        c.totalsnow_cm,
        c.avgvis_km,
        c.avgvis_miles,
        c.avghumidity,
        c.daily_will_it_rain,
        c.daily_chance_of_rain,
        c.daily_will_it_snow,
        c.daily_chance_of_snow,
        c.conditions,
        c.uv
    INTO #source 
    FROM dbo.WeatherJsonLoad lvl1
    CROSS APPLY openjson(lvl1.JsonData) WITH (
            name VARCHAR(50) '$.location.name',
            forecast NVARCHAR(max) '$.forecast.forecastday' AS json
            ) AS a
    CROSS APPLY openjson(a.forecast) WITH (
            forecast_date DATE '$.date',
            forecast_date_epoch INT '$.date_epoch',
            day NVARCHAR(max) '$.day' AS json
            ) AS b
    CROSS APPLY openjson(b.day) WITH (
            maxtemp_c FLOAT '$.maxtemp_c',
            maxtemp_f FLOAT '$.maxtemp_f',
            mintemp_c FLOAT '$.mintemp_c',
            mintemp_f FLOAT '$.mintemp_f',
            avgtemp_c FLOAT '$.avgtemp_c',
            avgtemp_f FLOAT '$.avgtemp_f',
            maxwind_mph FLOAT '$.maxwind_mph',
            maxwind_kph FLOAT '$.maxwind_kph',
            totalprecip_mm FLOAT '$.totalprecip_mm',
            totalprecip_in FLOAT '$.totalprecip_in',
            totalsnow_cm FLOAT '$.totalsnow_cm',
            avgvis_km FLOAT '$.avgvis_km',
            avgvis_miles FLOAT '$.avgvis_miles',
            avghumidity FLOAT '$.avghumidity',
            daily_will_it_rain BIT '$.daily_will_it_rain',
            daily_chance_of_rain FLOAT '$.daily_chance_of_rain',
            daily_will_it_snow BIT '$.daily_will_it_snow',
            daily_chance_of_snow FLOAT '$.daily_chance_of_snow',
            conditions VARCHAR(255) '$.condition.text',
            uv FLOAT '$.uv'
            ) AS c
    INNER JOIN dbo.Location l
        ON a.name = l.name
    WHERE lvl1.Processed = 0;

    BEGIN TRY  
        MERGE dbo.DailyForecast AS t 
        USING #source AS s ON s.LocationID = t.LocationID 
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
                   conditions = s.conditions,
                   uv = s.uv 

        WHEN NOT MATCHED THEN 
        INSERT (LocationID, 
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
        VALUES (s.LocationID,
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
                s.conditions,
                s.uv);
    END TRY

        BEGIN CATCH
        INSERT INTO dbo.Errorlog (
            TableName,
            ErrorNumber,
            ErrorMessage
            )
        VALUES (
            'DailyForecast',
            ERROR_NUMBER(),
            ERROR_MESSAGE()
            );
    END CATCH;
END
GO

IF EXISTS (
        SELECT *
        FROM sys.procedures
        WHERE object_id = OBJECT_ID('[dbo].insert_daily_forecast')
        )
BEGIN
    PRINT '<<< CREATED PROC dbo.insert_daily_forecast IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.insert_daily_forecast IN ' + db_name() + ' ON ' + @@servername + '  >>>'
GO


