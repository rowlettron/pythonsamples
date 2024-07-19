
CREATE OR REPLACE PROCEDURE public.update_json_to_processed() --Do not remove parentheses
LANGUAGE plpgsql
AS
$$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.update_json_to_processed();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/

BEGIN
	UPDATE public.weatherjsonload
	SET processed = 1,
	   processed_date = now()
    WHERE processed = 0;
END;

$$
