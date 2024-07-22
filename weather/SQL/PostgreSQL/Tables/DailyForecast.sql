DROP TABLE DailyForecast;

CREATE TABLE DailyForecast(
    DailyForecastID int GENERATED ALWAYS AS IDENTITY,
    locationid int8 NULL,
    forecast_date timestamp NULL,
    forecast_date_epoch int8 NULL,
    maxtemp_c numeric(6,2) NULL,
    maxtemp_f numeric(6,2) NULL,
    mintemp_c numeric(6,2) NULL,
    mintemp_f numeric(6,2) NULL,
    avgtemp_c numeric(6,2) NULL,
    avgtemp_f numeric(6,2) NULL,
    maxwind_mph numeric(6,2) NULL,
    maxwind_kph numeric(6,2) NULL,
    totalprecip_mm numeric(6,2) NULL,
    totalprecip_in numeric(6,2) NULL,
    totalsnow_cm numeric(6,2) NULL,
    avgvis_km numeric(6,2) NULL,
    avgvis_miles numeric(6,2) NULL,
    avghumidity numeric(6,2) NULL,
    daily_will_it_rain bit NULL,
    daily_chance_of_rain numeric(6,2) NULL,
    daily_will_it_snow bit NULL,
    daily_chance_of_snow numeric(6,2) NULL,
    conditions varchar(50) NULL,
    uv numeric(6,2) NULL,
 PRIMARY KEY (DailyForecastID)
) ;