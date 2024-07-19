DROP TABLE IF EXISTS public.Location;

CREATE TABLE Location(
    LocationID int GENERATED ALWAYS AS IDENTITY,
    PostalCode varchar(25) NULL, 
    name varchar(255) NULL,
    region varchar(255) NULL,
    country varchar(255) NULL,
    latitude float NULL,
    longitude float NULL,
    timezone varchar(255) NULL,
    localtime_epoch float NULL,
    "localtime" varchar(255) NULL,
  PRIMARY KEY (LocationID)
  ) ;