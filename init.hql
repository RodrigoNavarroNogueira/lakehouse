CREATE DATABASE bronze;
USE bronze;


CREATE TABLE pokemon (
    name STRING,
    url STRING
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE;


LOAD DATA INPATH '/user/root/pokemon/pokemon_edit.json' INTO TABLE pokemon;


SELECT * FROM pokemon;