
CREATE OR REPLACE PROCEDURE public.insert_weatherjsonload(in_wj jsonb) --Do not remove parentheses
LANGUAGE plpgsql
AS
$$
/*************************************************************************************************
*  Object Type:	    Stored Procedure
*  Function:        
*  Created By:      
*  Create Date:     
*  Maintenance Log:
*  Execution:       call public.<proc name>();  --Do not remove parentheses
*
*  Date          Modified By             Description
*  ----------    --------------------    ---------------------------------------------------------
**************************************************************************************************/
DECLARE wj jsonb;
BEGIN

    wj := in_wj;

	INSERT INTO public.weatherjsonload(jsondata)
	VALUES (wj);
END;

$$
