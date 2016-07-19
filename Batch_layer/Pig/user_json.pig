
a =load '/home/sally01/test/yelp_training_set_user.json' as (str:chararray);
b= foreach a generate REGEX_EXTRACT(str,'\\"votes\\"\\:\\s\\{(.*?)\\},',1) as votes;

a = load '/home/sally01/test/test3.json' using JsonLoader('votes:(useful:int,funny:int,cool:int),user_id:chararray,name:chararray,average_stars:float,review_count:int,type:chararray');
b = foreach a generate FLATTEN(votes),type,user_id,name,review_count,average_stars;
c= foreach b generate user_id,name,review_count,average_stars,type,$0 as votes_funny,$1 as votes_useful,$2 as votes_cool;

STORE c INTO 'hbase://user_test' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'user:name
 user:review_count
 user:average_stars
 user:type
 user:votes_funny
 user:votes_useful
 user:votes_cool'
);
