DROP TABLE public.Location;

CREATE TABLE Location(
    LocationID int GENERATED ALWAYS AS IDENTITY,
    PostalCode varchar(25) NULL, 
    name varchar(50) NULL,
    region varchar(50) NULL,
    country varchar(50) NULL,
    latitude numeric(6,2) NULL,
    longitude numeric(6,2) NULL,
    timezone varchar(50) NULL,
    localtime_epoch int NULL,
    "localtime" varchar(255) NULL,
  PRIMARY KEY (LocationID)
  ) ;