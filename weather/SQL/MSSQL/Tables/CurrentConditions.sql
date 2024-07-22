USE Weather_v2
GO

/****** Object:  Table dbo.CurrentConditions    Script Date: 7/3/2024 10:54:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS dbo.CurrentConditions;

CREATE TABLE dbo.CurrentConditions(
    CurrentConditionID int IDENTITY(1,1) NOT NULL,
    LocationID INT NULL,
    --location varchar(50) NULL,
    last_updated_epoch INT NULL,
    last_updated datetime NULL,
    temp_c numeric(6,2) NULL,
    temp_f numeric(6,2) NULL,
    isday bit NULL,
    current_conditions varchar(50) NULL,
    wind_mph numeric(6,2) NULL,
    wind_kph numeric(6,2) NULL,
    wind_degree numeric(6,2) NULL,
    wind_direction varchar(50) NULL,
    pressure_mb numeric(6,2) NULL,
    pressure_in numeric(6,2) NULL,
    precip_mm numeric(6,2) NULL,
    precip_in numeric(6,2) NULL,
    humidity numeric(6,2) NULL,
    cloud numeric(6,2) NULL,
    feelslike_c numeric(6,2) NULL,
    feelslike_f numeric(6,2) NULL,
    windchill_c numeric(6,2) NULL,
    windchill_f numeric(6,2) NULL,
    heatindex_c numeric(6,2) NULL,
    heatindex_f numeric(6,2) NULL,
    dewpoint_c numeric(6,2) NULL,
    dewpoint_f numeric(6,2) NULL,
    vis_km numeric(6,2) NULL,
    vis_miles numeric(6,2) NULL,
    uv numeric(6,2) NULL,
    gust_mph numeric(6,2) NULL,
    gust_kph numeric(6,2) NULL,
 CONSTRAINT PK_CurrentConditions PRIMARY KEY CLUSTERED 
(
    CurrentConditionID ASC
)
) 
GO


