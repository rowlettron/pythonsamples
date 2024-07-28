-- DROP PROCEDURE IF EXISTS public.insert_payload_to_table(inPayload text);

CREATE OR REPLACE PROCEDURE public.insert_payload_to_table(inPayload jsonb) --Do not remove parentheses
LANGUAGE plpgsql
AS
$$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.insert_payload_to_table();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/

BEGIN
    INSERT INTO public.weatherjsonload(jsondata)
    VALUES (inPayload);
END;

$$
