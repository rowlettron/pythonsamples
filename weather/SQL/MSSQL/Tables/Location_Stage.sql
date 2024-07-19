USE [Weather_v2]
GO

/****** Object:  Table [dbo].[Location]    Script Date: 7/3/2024 10:59:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Location_Stage](
    [name] [nvarchar](255) NULL,
    [region] [nvarchar](255) NULL,
    [country] [nvarchar](255) NULL,
    [latitude] [float] NULL,
    [longitude] [float] NULL,
    [timezone] [nvarchar](255) NULL,
    [localtime_epoch] [float] NULL,
    [localtime] [nvarchar](255) NULL) 
GO


