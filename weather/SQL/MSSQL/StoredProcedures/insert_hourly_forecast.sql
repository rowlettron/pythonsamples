/*
 * DROP PROC dbo.insert_hourlyforecast
 */
IF EXISTS (
        SELECT *
        FROM sys.procedures
        WHERE object_id = OBJECT_ID('[dbo].insert_hourlyforecast')
        )
BEGIN
    DROP PROC dbo.insert_hourlyforecast

    PRINT '<<< DROPPED PROC dbo.insert_hourlyforecast IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
GO

CREATE PROC dbo.insert_hourlyforecast
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
    SELECT l.LocationID,
        a.name,
        b.forecast_date,
        c.forecast_hour,
        c.time_epoch,
        c.temp_c,
        c.temp_f,
        c.is_day,
        c.condition,
        c.wind_mph,
        c.wind_kph,
        c.wind_degree,
        c.wind_dir,
        c.pressure_mb,
        c.pressure_in,
        c.precip_mm,
        c.precip_in,
        c.snow_cm,
        c.humidity,
        c.cloud,
        c.feelslike_c,
        c.feelslike_f,
        c.windchill_c,
        c.windchill_f,
        c.heatindex_c,
        c.heatindex_f,
        c.dewpoint_c,
        c.dewpoint_f,
        c.will_it_rain,
        c.chance_of_rain,
        c.will_it_snow,
        c.chance_of_snow,
        c.vis_km,
        c.vis_miles,
        c.gust_mph,
        c.gust_kph,
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
            hour NVARCHAR(max) '$.hour' AS json
            ) AS b
    CROSS APPLY openjson(b.[hour]) WITH (
            forecast_hour DATETIME '$.time',
            time_epoch INT '$.time_epoch',
            temp_c FLOAT '$.temp_c',
            temp_f FLOAT '$.temp_f',
            is_day BIT '$.is_day',
            condition VARCHAR(255) '$.condition.text',
            wind_mph FLOAT '$.wind_mph',
            wind_kph FLOAT '$.wind_kph',
            wind_degree INT '$.wind_degree',
            wind_dir VARCHAR(255) '$.wind_dir',
            pressure_mb FLOAT '$.pressure_mb',
            pressure_in FLOAT '$.pressure_in',
            precip_mm FLOAT '$.precip_mm',
            precip_in FLOAT '$.precip_in',
            snow_cm FLOAT '$.snow_cm',
            humidity FLOAT '$.humidity',
            cloud FLOAT '$.cloud',
            feelslike_c FLOAT '$.feelslike_c',
            feelslike_f FLOAT '$.feelslike_f',
            windchill_c FLOAT '$.windchill_c',
            windchill_f FLOAT '$.windchill_f',
            heatindex_c FLOAT '$.heatindex_c',
            heatindex_f FLOAT '$.heatindex_f',
            dewpoint_c FLOAT '$.dewpoint_c',
            dewpoint_f FLOAT '$.dewpoint_f',
            will_it_rain BIT '$.will_it_rain',
            chance_of_rain FLOAT '$.chance_of_rain',
            will_it_snow BIT '$.will_it_snow',
            chance_of_snow FLOAT '$.chance_of_snow',
            vis_km FLOAT '$.vis_km',
            vis_miles FLOAT '$.vis_miles',
            gust_mph FLOAT '$.gust_mph',
            gust_kph FLOAT '$.gust_kph',
            uv FLOAT '$.uv'
            ) AS c
    INNER JOIN dbo.Location l
        ON a.name = l.name
    WHERE lvl1.Processed = 0;

    BEGIN TRY
        MERGE dbo.HourlyForecast AS t
        USING #source AS s
            ON s.LocationID = t.LocationID
                AND s.time_epoch = t.forecast_time_epoch
        WHEN MATCHED
            THEN
                UPDATE
                SET temp_c = s.temp_c,
                    temp_f = s.temp_f,
                    is_day = s.is_day,
                    condition = s.condition,
                    wind_mph = s.wind_mph,
                    wind_kph = s.wind_kph,
                    wind_degree = s.wind_degree,
                    wind_dir = s.wind_dir,
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
                    will_it_rain = s.will_it_rain,
                    chance_of_rain = s.chance_of_rain,
                    will_it_snow = s.will_it_snow,
                    chance_of_snow = s.chance_of_snow,
                    vis_km = s.vis_km,
                    vis_miles = s.vis_miles,
                    gust_mph = s.gust_mph,
                    gust_kph = s.gust_kph,
                    uv = s.uv
        WHEN NOT MATCHED
            THEN
                INSERT (
                    LocationID,
                    forecast_date,
                    forecast_hour,
                    forecast_time_epoch,
                    temp_c,
                    temp_f,
                    is_day,
                    condition,
                    wind_mph,
                    wind_kph,
                    wind_degree,
                    wind_dir,
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
                    will_it_rain,
                    chance_of_rain,
                    will_it_snow,
                    chance_of_snow,
                    vis_km,
                    vis_miles,
                    gust_mph,
                    gust_kph,
                    uv
                    )
                VALUES (
                    s.LocationID,
                    s.forecast_date,
                    s.forecast_hour,
                    s.time_epoch,
                    s.temp_c,
                    s.temp_f,
                    s.is_day,
                    s.condition,
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
                    s.will_it_rain,
                    s.chance_of_rain,
                    s.will_it_snow,
                    s.chance_of_snow,
                    s.vis_km,
                    s.vis_miles,
                    s.gust_mph,
                    s.gust_kph,
                    s.uv
                    ); 
    END TRY

    BEGIN CATCH
        INSERT INTO dbo.Errorlog (
            TableName,
            ErrorNumber,
            ErrorMessage
            )
        VALUES (
            'HourlyForecast',
            ERROR_NUMBER(),
            ERROR_MESSAGE()
            );
    END CATCH;
END
GO

IF EXISTS (
        SELECT *
        FROM sys.procedures
        WHERE object_id = OBJECT_ID('[dbo].insert_hourlyforecast')
        )
BEGIN
    PRINT '<<< CREATED PROC dbo.insert_hourlyforecast IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.insert_hourlyforecast IN ' + db_name() + ' ON ' + @@servername + '  >>>'
GO


