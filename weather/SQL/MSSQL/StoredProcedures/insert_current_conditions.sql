/*
 * DROP PROC dbo.insert_current_conditions
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].insert_current_conditions') )
BEGIN
    DROP PROC dbo.insert_current_conditions
    PRINT '<<< DROPPED PROC dbo.insert_current_conditions IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
go

CREATE PROC dbo.insert_current_conditions
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
SQL_statements
END
go

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].insert_current_conditions') )
BEGIN
    PRINT '<<< CREATED PROC dbo.insert_current_conditions IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.insert_current_conditions IN ' + db_name() + ' ON ' + @@servername + '  >>>'
go
