use Weather_v2;

DROP PROCEDURE IF EXISTS update_json_to_processed;

delimiter //

CREATE PROCEDURE update_json_to_processed ()
BEGIN
    UPDATE Weather_v2.weatherjsonload 
    SET processed = 1,
        processed_date = NOW()
    WHERE processed = 0;
    
END;
//

delimiter ;
