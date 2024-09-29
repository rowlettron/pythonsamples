USE Weather_v2
GO

/****** Object:  Table dbo.DailyForecast    Script Date: 7/3/2024 10:56:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS dbo.DailyForecast;
GO

CREATE TABLE dbo.DailyForecast (
    DailyForecastID INT IDENTITY(1, 1) NOT NULL,
    LocationID INT NULL,
    --location_name nvarchar(255) NULL,
    forecast_date DATETIME NULL,
    forecast_date_epoch INT NULL,
    maxtemp_c NUMERIC(6, 2) NULL,
    maxtemp_f NUMERIC(6, 2) NULL,
    mintemp_c NUMERIC(6, 2) NULL,
    mintemp_f NUMERIC(6, 2) NULL,
    avgtemp_c NUMERIC(6, 2) NULL,
    avgtemp_f NUMERIC(6, 2) NULL,
    maxwind_mph NUMERIC(6, 2) NULL,
    maxwind_kph NUMERIC(6, 2) NULL,
    totalprecip_mm NUMERIC(6, 2) NULL,
    totalprecip_in NUMERIC(6, 2) NULL,
    totalsnow_cm NUMERIC(6, 2) NULL,
    avgvis_km NUMERIC(6, 2) NULL,
    avgvis_miles NVARCHAR(255) NULL,
    avghumidity NUMERIC(6, 2) NULL,
    daily_will_it_rain BIT NULL,
    daily_chance_of_rain NUMERIC(6, 2) NULL,
    daily_will_it_snow BIT NULL,
    daily_chance_of_snow NUMERIC(6, 2) NULL,
    conditions VARCHAR(50) NULL,
    avgmis_miles NUMERIC(6, 2) NULL,
    uv NUMERIC(6,2) NULL, 
    CONSTRAINT PK_DailyForecast PRIMARY KEY CLUSTERED (DailyForecastID ASC)
    )
GO


