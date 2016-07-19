
ADD JAR /home/sally01/hive_jar/hive-serdes-1.0-SNAPSHOT.jar;

CREATE EXTERNAL TABLE Checkin_hive(
    type STRING,
    business_id STRING,
    checkin_info MAP<STRING, INT>
)
ROW FORMAT SERDE 'com.cloudera.hive.serde.JSONSerDe';

LOAD DATA LOCAL INPATH ‘/home/sally01/data/yelp_training_set_checkin.json’ overwrite into table Checkin_hive;
