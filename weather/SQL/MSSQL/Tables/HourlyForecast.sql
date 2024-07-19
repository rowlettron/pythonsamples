USE [Weather_v2]
GO

/****** Object:  Table [dbo].[HourlyForecast]    Script Date: 7/3/2024 10:57:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[HourlyForecast](
    [HourlyForecastID] [int] IDENTITY(1,1) NOT NULL,
    [location] [nvarchar](255) NULL,
    [forecast_date] [nvarchar](255) NULL,
    [time] [nvarchar](255) NULL,
    [time_epoch] [float] NULL,
    [temp_c] [float] NULL,
    [temp_f] [float] NULL,
    [is_day] [float] NULL,
    [condition] [nvarchar](255) NULL,
    [wind_mph] [float] NULL,
    [wind_kph] [float] NULL,
    [wind_degree] [float] NULL,
    [wind_dir] [nvarchar](255) NULL,
    [pressure_mb] [float] NULL,
    [pressure_in] [float] NULL,
    [precip_mm] [float] NULL,
    [precip_in] [float] NULL,
    [humidity] [float] NULL,
    [cloud] [float] NULL,
    [feelslike_c] [float] NULL,
    [feelslike_f] [float] NULL,
    [windchill_c] [float] NULL,
    [windchill_f] [float] NULL,
    [heatindex_c] [float] NULL,
    [heatindex_f] [float] NULL,
    [dewpoint_c] [float] NULL,
    [dewpoint_f] [float] NULL,
    [will_it_rain] [float] NULL,
    [chance_of_rain] [float] NULL,
    [will_it_snow] [float] NULL,
    [chance_of_snow] [float] NULL,
    [vis_km] [float] NULL,
    [vis_miles] [float] NULL,
    [gust_mph] [float] NULL,
    [gust_kph] [float] NULL,
    [uv] [float] NULL,
 CONSTRAINT [PK_HourlyForecast] PRIMARY KEY CLUSTERED 
(
    [HourlyForecastID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


