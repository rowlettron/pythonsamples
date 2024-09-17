use Weather_v2;

DROP PROCEDURE insert_location;

delimiter //

CREATE PROCEDURE insert_location (_inPostalCode VARCHAR(25))
BEGIN
    DECLARE _postalCode VARCHAR(25);
    
    SET _postalCode = inPostalCode;
    
END;
//

delimiter ;
