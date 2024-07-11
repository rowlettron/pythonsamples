DROP PROCEDURE IF EXISTS public.<proc name>(param1 datatype, param2 datatype, ...);

CREATE OR REPLACE PROCEDURE public.<proc name>(param1 datatype, param2 datatype, ...) --Do not remove parentheses
LANGUAGE plpgsql
AS
$$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.<proc name>(param1, param2, ...);  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE var1 datatype,
        var2 datatype,
        var3 datatype,
        ...
BEGIN

END;

$$
