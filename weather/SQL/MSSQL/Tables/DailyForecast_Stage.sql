USE [Weather_v2]
GO

/****** Object:  Table [dbo].[DailyForecast]    Script Date: 7/3/2024 10:56:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DailyForecast_Stage](
    [location_name] [nvarchar](255) NULL,
    [date] [nvarchar](255) NULL,
    [date_epoch] [float] NULL,
    [maxtemp_c] [float] NULL,
    [maxtemp_f] [float] NULL,
    [mintemp_c] [float] NULL,
    [mintemp_f] [float] NULL,
    [avgtemp_c] [float] NULL,
    [avgtemp_f] [float] NULL,
    [maxwind_mph] [float] NULL,
    [maxwind_kph] [float] NULL,
    [totalprecip_mm] [float] NULL,
    [totalprecip_in] [float] NULL,
    [totalsnow_cm] [float] NULL,
    [avgvis_km] [float] NULL,
    [avgvis_miles] [nvarchar](255) NULL,
    [avghumidity] [float] NULL,
    [daily_will_it_rain] [float] NULL,
    [daily_chance_of_rain] [float] NULL,
    [daily_will_it_snow] [float] NULL,
    [daily_chance_of_snow] [float] NULL,
    [conditions] [nvarchar](255) NULL,
    [avgmis_miles] [float] NULL) 
GO


