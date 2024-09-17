use Weather_v2;

delimiter //

CREATE PROCEDURE copy_payload_to_table ()
BEGIN
    
    DROP TABLE IF EXISTS _location;
    
    CREATE TEMPORARY TABLE _location (jsondata JSON);
    
    LOAD DATA INFILE '/datashare/file.txt'
    INTO TABLE _location;
    
    DROP TABLE _location;
    
END;
//

delimiter ;