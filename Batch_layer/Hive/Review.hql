
ADD JAR /home/sally01/hive_jar/hive-serdes-1.0-SNAPSHOT.jar;

CREATE EXTERNAL TABLE Review_hive(
    type STRING,
    business_id STRING,
    user_id STRING,
    stars INT,
    text STRING,
    date STRING,
    votes STRUCT<
                 useful:INT,  
                 funny:INT, 
                 cool:INT 
                >
)
ROW FORMAT SERDE 'com.cloudera.hive.serde.JSONSerDe';

LOAD DATA LOCAL INPATH ‘/home/sally01/data/yelp_training_set_review.json’ overwrite into table Review_hive;
