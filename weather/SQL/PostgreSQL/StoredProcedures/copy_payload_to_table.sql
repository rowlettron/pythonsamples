
CREATE OR REPLACE PROCEDURE public.copy_payload_to_table() --Do not remove parentheses
LANGUAGE plpgsql
AS
$$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.copy_payload_to_table();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/

BEGIN
    COPY public.weatherjsonload (jsondata) FROM '/datashare/file.txt';
END;

$$
