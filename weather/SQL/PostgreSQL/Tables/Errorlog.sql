DROP TABLE IF EXISTS public.Errorlog;

CREATE TABLE public.Errorlog (ErrorlogID int GENERATED ALWAYS AS IDENTITY,
                           LogDate TIMESTAMP NULL,
                           TableName VARCHAR(30) NULL,
                           ErrorNumber INT NULL,
                           ErrorMessage VARCHAR(500),
                           CONSTRAINT PK_Errorlog PRIMARY KEY (ErrorlogID));

CREATE INDEX IX_Errorlog_LogDate ON public.Errorlog(LogDate);

ALTER TABLE public.Errorlog ALTER COLUMN LogDate SET DEFAULT NOW();