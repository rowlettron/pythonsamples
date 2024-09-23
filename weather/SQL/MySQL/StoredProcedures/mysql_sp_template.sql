use <schema>;

DROP PROCEDURE IF EXISTS <proc name>;

delimiter //

CREATE PROCEDURE <proc name> (param1 datatype,
                              OUT param2 datatype
                              ...)
BEGIN
    DECLARE var1 INT,
            var2 INT
    
    < procedure statements>
    
END;
//

delimiter ;
