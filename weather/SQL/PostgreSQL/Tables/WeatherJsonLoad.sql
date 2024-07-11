CREATE TABLE WeatherJsonLoad (
    WJL_ID serial NOT NULL PRIMARY KEY,
    JsonData jsonb NULL,
    CreateDate TIMESTAMP NULL
);

ALTER TABLE WeatherJsonLoad ALTER COLUMN CreateDate SET DEFAULT now();