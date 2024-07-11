DROP TABLE IF EXISTS DailyForecast;

CREATE TABLE DailyForecast(
    DailyForecastID int GENERATED ALWAYS AS IDENTITY,
    locationid int8 NULL,
    forecast_date timestamp NULL,
    forecast_date_epoch int8 NULL,
    maxtemp_c float NULL,
    maxtemp_f float NULL,
    mintemp_c float NULL,
    mintemp_f float NULL,
    avgtemp_c float NULL,
    avgtemp_f float NULL,
    maxwind_mph float NULL,
    maxwind_kph float NULL,
    totalprecip_mm float NULL,
    totalprecip_in float NULL,
    totalsnow_cm float NULL,
    avgvis_km float NULL,
    avgvis_miles float NULL,
    avghumidity float NULL,
    daily_will_it_rain bit NULL,
    daily_chance_of_rain float NULL,
    daily_will_it_snow bit NULL,
    daily_chance_of_snow float NULL,
    conditions varchar(255) NULL,
    uv float NULL,
 PRIMARY KEY (DailyForecastID)
) ;