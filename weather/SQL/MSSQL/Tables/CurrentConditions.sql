USE [Weather_v2]
GO

/****** Object:  Table [dbo].[CurrentConditions]    Script Date: 7/3/2024 10:54:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CurrentConditions](
    [CurrentConditionID] [int] IDENTITY(1,1) NOT NULL,
    [location] [nvarchar](255) NULL,
    [last_updated_epoch] [float] NULL,
    [last_updated] [nvarchar](255) NULL,
    [temp_c] [float] NULL,
    [temp_f] [float] NULL,
    [isday] [float] NULL,
    [current_conditions] [nvarchar](255) NULL,
    [wind_mph] [float] NULL,
    [wind_kph] [float] NULL,
    [wind_degree] [float] NULL,
    [wind_direction] [nvarchar](255) NULL,
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
    [vis_km] [float] NULL,
    [vis_miles] [float] NULL,
    [uv] [float] NULL,
    [gust_mph] [float] NULL,
    [gust_kph] [float] NULL,
 CONSTRAINT [PK_CurrentConditions] PRIMARY KEY CLUSTERED 
(
    [CurrentConditionID] ASC
)
) 
GO


