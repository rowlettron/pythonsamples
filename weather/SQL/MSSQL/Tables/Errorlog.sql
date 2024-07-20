USE Weather_v2;
GO 

DROP TABLE IF EXISTS dbo.Errorlog;

CREATE TABLE dbo.Errorlog (ErrorlogID INT IDENTITY,
                           LogDate DATETIME DEFAULT GETDATE(),
                           TableName VARCHAR(30) NULL,
                           ErrorNumber INT NULL,
                           ErrorMessage VARCHAR(500),
                           CONSTRAINT PK_Errorlog PRIMARY KEY CLUSTERED (ErrorlogID));

CREATE INDEX IX_Errorlog_LogDate ON dbo.Errorlog(LogDate);
