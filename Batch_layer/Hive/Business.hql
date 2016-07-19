
ADD JAR /home/sally01/hive_jar/hive-serdes-1.0-SNAPSHOT.jar;

CREATE EXTERNAL TABLE Business_hive(
    type STRING,
    business_id STRING,
    name STRING,
    neighborhoods ARRAY<STRING>,
    full_address STRING,
    city STRING,
    state STRING,
    latitude DOUBLE,
    longitude DOUBLE,
    stars DOUBLE,
    review_count INT,
    categories array<STRING>,
    open BOOLEAN
)
ROW FORMAT SERDE 'com.cloudera.hive.serde.JSONSerDe';

LOAD DATA LOCAL INPATH ‘/home/sally01/data/yelp_training_set_business.json’ overwrite into table Business_hive;
