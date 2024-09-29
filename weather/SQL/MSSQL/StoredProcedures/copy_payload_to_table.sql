USE Weather_v2;
GO 

/*
 * DROP PROC dbo.copy_payload_to_table
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].copy_payload_to_table') )
BEGIN
    DROP PROC dbo.copy_payload_to_table
    PRINT '<<< DROPPED PROC dbo.copy_payload_to_table IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
go

CREATE PROC dbo.copy_payload_to_table 
AS

/*****************************************************************************
*  Object Type:	    Stored Procedure
*  Function:
*  Created By:
*  Create Date:
*  Input:
*  Output:
*  Maintenance Log:
*  Date          Modified By             Description
*  ----------    --------------------    -------------------------------------
******************************************************************************/
BEGIN

    DROP TABLE IF EXISTS #alpha;

    CREATE TABLE #alpha (JsonData nvarchar(max));

    IF @@SERVERNAME = 'mssql-db'
    BEGIN 
        BULK INSERT #alpha FROM '/datashare/file.txt';
    END 
    ELSE 
    BEGIN 
        BULK INSERT #alpha FROM 'C:\Containers\PostgreSQL\datashare\file.txt' ;
    END 
    
    INSERT INTO dbo.WeatherJsonLoad(JsonData)
    SELECT JsonData FROM #alpha;

    DROP TABLE #alpha;
    
END
go

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].copy_payload_to_table') )
BEGIN
    PRINT '<<< CREATED PROC dbo.copy_payload_to_table IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.copy_payload_to_table IN ' + db_name() + ' ON ' + @@servername + '  >>>'
go
