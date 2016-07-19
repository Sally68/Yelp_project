ADD JAR /home/sally01/hive_jar/hive-serdes-1.0-SNAPSHOT.jar;

CREATE EXTERNAL TABLE User_hive(
    type STRING,
    user_id STRING,
    name STRING, 
    review_count INT,
    average_stars DOUBLE,
    votes STRUCT<
                 useful:INT,  
                 funny:INT, 
                 cool:INT 
                >
)
ROW FORMAT SERDE 'com.cloudera.hive.serde.JSONSerDe';

LOAD DATA LOCAL INPATH ‘/home/sally01/data/yelp_training_set_user.json’ overwrite into table User_hive;
