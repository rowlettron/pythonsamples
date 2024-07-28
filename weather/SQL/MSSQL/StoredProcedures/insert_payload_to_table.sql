USE Weather_v2;
GO

/*
 * DROP PROC dbo.insert_payload_to_table
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].insert_payload_to_table') )
BEGIN
    DROP PROC dbo.insert_payload_to_table
    PRINT '<<< DROPPED PROC dbo.insert_payload_to_table IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
go

CREATE PROC dbo.insert_payload_to_table @inPayload NVARCHAR(MAX)
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
    INSERT INTO dbo.WeatherJsonLoad(JsonData)
    VALUES (@inPayload);
    
END
go

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].insert_payload_to_table') )
BEGIN
    PRINT '<<< CREATED PROC dbo.insert_payload_to_table IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.insert_payload_to_table IN ' + db_name() + ' ON ' + @@servername + '  >>>'
go
