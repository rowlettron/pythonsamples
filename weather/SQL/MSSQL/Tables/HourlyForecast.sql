USE Weather_v2
GO

/****** Object:  Table dbo.HourlyForecast    Script Date: 7/3/2024 10:57:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS dbo.HourlyForecast;
GO 

CREATE TABLE dbo.HourlyForecast (
    HourlyForecastID INT IDENTITY(1, 1) NOT NULL,
    LocationID INT NULL,
    --location varchar(50) NULL,
    forecast_date DATETIME NULL,
    forecast_hour DATETIME NULL,
    time_epoch INT NULL,
    temp_c NUMERIC(6, 2) NULL,
    temp_f NUMERIC(6, 2) NULL,
    is_day BIT NULL,
    condition VARCHAR(50) NULL,
    wind_mph NUMERIC(6, 2) NULL,
    wind_kph NUMERIC(6, 2) NULL,
    wind_degree NUMERIC(6, 2) NULL,
    wind_dir VARCHAR(50) NULL,
    pressure_mb NUMERIC(6, 2) NULL,
    pressure_in NUMERIC(6, 2) NULL,
    precip_mm NUMERIC(6, 2) NULL,
    precip_in NUMERIC(6, 2) NULL,
    humidity NUMERIC(6, 2) NULL,
    cloud NUMERIC(6, 2) NULL,
    feelslike_c NUMERIC(6, 2) NULL,
    feelslike_f NUMERIC(6, 2) NULL,
    windchill_c NUMERIC(6, 2) NULL,
    windchill_f NUMERIC(6, 2) NULL,
    heatindex_c NUMERIC(6, 2) NULL,
    heatindex_f NUMERIC(6, 2) NULL,
    dewpoint_c NUMERIC(6, 2) NULL,
    dewpoint_f NUMERIC(6, 2) NULL,
    will_it_rain BIT NULL,
    chance_of_rain NUMERIC(6, 2) NULL,
    will_it_snow BIT NULL,
    chance_of_snow NUMERIC(6, 2) NULL,
    vis_km NUMERIC(6, 2) NULL,
    vis_miles NUMERIC(6, 2) NULL,
    gust_mph NUMERIC(6, 2) NULL,
    gust_kph NUMERIC(6, 2) NULL,
    uv NUMERIC(6, 2) NULL,
    CONSTRAINT PK_HourlyForecast PRIMARY KEY CLUSTERED (HourlyForecastID ASC)
    )
GO


