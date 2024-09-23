USE Weather_v2; 

DROP TABLE IF EXISTS HourlyForecast;

CREATE TABLE HourlyForecast (
    HourlyForecastID INT AUTO_INCREMENT,
    LocationID INT NULL,
    forecast_hour DATETIME NULL,
    forecast_time_epoch INT NULL,
    temp_c NUMERIC(6, 2) NULL,
    temp_f NUMERIC(6, 2) NULL,
    is_day BIT NULL,
    hourlycondition VARCHAR(50) NULL,
    wind_mph NUMERIC(6, 2) NULL,
    wind_kph NUMERIC(6, 2) NULL,
    wind_degree NUMERIC(6, 2) NULL,
    wind_dir VARCHAR(50) NULL,
    pressure_mb NUMERIC(6, 2) NULL,
    pressure_in NUMERIC(6, 2) NULL,
    precip_mm NUMERIC(6, 2) NULL,
    precip_in NUMERIC(6, 2) NULL,
    snow_cm NUMERIC(6,2) NULL, 
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
    CONSTRAINT PK_HourlyForecast PRIMARY KEY (HourlyForecastID ASC), 
    UNIQUE KEY (LocationID, forecast_time_epoch)
    );


