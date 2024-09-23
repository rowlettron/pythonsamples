use Weather_v2;

DROP TABLE IF EXISTS Weather_v2.weatherjsonload;

CREATE TABLE Weather_v2.weatherjsonload(
    wjl_id INT AUTO_INCREMENT,
    jsondata JSON NULL,
    createdate DATETIME DEFAULT NOW(),
    processed TINYINT DEFAULT 0,
    processed_date DATETIME NULL,
    CONSTRAINT PK_weatherjson PRIMARY KEY (wjl_id)
);