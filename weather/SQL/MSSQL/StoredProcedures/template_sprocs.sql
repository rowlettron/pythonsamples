/*
 * DROP PROC dbo.<proc_name>
 */

IF  EXISTS (SELECT *
            FROM sys.procedures
            WHERE object_id = OBJECT_ID('[dbo].<proc_name>') )
BEGIN
    DROP PROC dbo.<proc_name>
    PRINT '<<< DROPPED PROC dbo.<proc_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
go

CREATE PROC dbo.<proc_name>
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
            WHERE object_id = OBJECT_ID('[dbo].<proc_name>') )
BEGIN
    PRINT '<<< CREATED PROC dbo.<proc_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
END
ELSE
    PRINT '<<< FAILED CREATING PROC dbo.<proc_name> IN ' + db_name() + ' ON ' + @@servername + '  >>>'
go
