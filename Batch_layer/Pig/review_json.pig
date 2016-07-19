a = LOAD '/home/sally01/data/yelp_training_set_review.json' USING JsonLoader('votes:(funny:int, useful:int, cool:int), user_id:chararray, review_id:chararray, stars:int, date:chararray, text:chararray, type:chararray, business_id:chararray');
b= FOREACH a GENERATE FLATTEN(votes),user_id, review_id, stars AS review_stars, date AS review_date, REPLACE(REPLACE(text,'\n','*'),'\r','*') AS review_text, type, business_id;
b= FOREACH a GENERATE FLATTEN(votes),user_id, review_id, stars, date AS, text, type, business_id;
c = FOREACH b GENERATE review_id, business_id, user_id,stars, date, text,$0 AS votes_funny, $1 AS votes_useful, $2 AS votes_cool;
STORE c INTO 'hbase://review_test' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'review:business_id 
 review:user_id
 review:stars
 review:date
 review:test
 review:votes_funny
 review:votes_useful
 review:votes_cool'
);
