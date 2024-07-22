USE Weather_v2
GO

/****** Object:  Table dbo.Location    Script Date: 7/3/2024 10:59:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS dbo.Location;

CREATE TABLE dbo.Location(
    LocationID int IDENTITY(1,1) NOT NULL,
    PostalCode varchar(25) NULL, 
    name varchar(50) NULL,
    region varchar(50) NULL,
    country varchar(50) NULL,
    latitude numeric(6,2) NULL,
    longitude numeric(6,2) NULL,
    timezone varchar(50) NULL,
    localtime_epoch int NULL,
    localtime datetime NULL,
 CONSTRAINT PK_Location PRIMARY KEY CLUSTERED (LocationID ASC)
) 
GO


