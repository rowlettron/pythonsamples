USE Weather_v2; 

DROP TABLE IF EXISTS DailyForecast;

CREATE TABLE DailyForecast (
    DailyForecastID INT AUTO_INCREMENT,
    LocationID INT NULL,
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
    CONSTRAINT PK_DailyForecast PRIMARY KEY (DailyForecastID ASC),
    UNIQUE KEY (LocationID, forecast_date_epoch)
    ); 


