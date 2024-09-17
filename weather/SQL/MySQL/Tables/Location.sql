USE Weather_v2;

DROP TABLE IF EXISTS dbo.Location;

CREATE TABLE Location(
    LocationID int AUTO_INCREMENT,
    PostalCode varchar(25) NULL, 
    name varchar(50) NULL,
    region varchar(50) NULL,
    country varchar(50) NULL,
    latitude numeric(6,2) NULL,
    longitude numeric(6,2) NULL,
    timezone varchar(50) NULL,
    local_time_epoch int NULL,
    local_time datetime NULL,
 CONSTRAINT PK_Location PRIMARY KEY (LocationID ASC)
);

