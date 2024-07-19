USE Weather_v2;
GO

DROP TABLE IF EXISTS dbo.WeatherJsonLoad;

CREATE TABLE dbo.WeatherJsonLoad (
    WJL_ID bigint IDENTITY,
    JsonData NVARCHAR(MAX) NULL,
    CreateDate DATETIME NULL,
    Processed TINYINT NULL DEFAULT (0),
    Processed_Date DATETIME NULL, 
    CONSTRAINT PK_WeatherJsonLoad PRIMARY KEY CLUSTERED (WJL_ID)
);

ALTER TABLE dbo.WeatherJsonLoad ADD CONSTRAINT df_WeatherJsonLoad_CreateDate DEFAULT GETDATE() FOR CreateDate;
GO

