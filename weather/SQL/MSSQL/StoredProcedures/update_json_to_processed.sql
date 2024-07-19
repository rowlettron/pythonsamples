/*
 * DROP PROC dbo.update_json_to_processed
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].update_json_to_processed') )
BEGIN
    DROP PROC dbo.update_json_to_processed
    PRINT '<<< DROPPED PROC dbo.update_json_to_processed IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
go

CREATE PROC dbo.update_json_to_processed
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
	UPDATE dbo.WeatherJsonLoad
	SET processed = 1,
	   processed_date = GETDATE()
    WHERE processed = 0;
END
go

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].update_json_to_processed') )
BEGIN
    PRINT '<<< CREATED PROC dbo.update_json_to_processed IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.update_json_to_processed IN ' + db_name() + ' ON ' + @@servername + '  >>>'
go
