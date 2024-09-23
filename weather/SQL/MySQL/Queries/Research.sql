
SELECT CONCAT('TRUNCATE TABLE ',table_name,'; ALTER TABLE ',table_name,' DISABLE KEYS;    LOAD DATA INFILE "',table_name,'.txt" INTO TABLE ',table_name,' FIELDS TERMINATED BY "\\t" LINES TERMINATED BY "\\n"; ALTER TABLE ',table_name,' ENABLE KEYS; ')
FROM information_schema.`TABLES` as infs
WHERE infs.`TABLE_SCHEMA`=DATABASE()
AND infs.`TABLE_TYPE`!='VIEW';

