a= load '/home/sally01/data/yelp_training_set_checkin.json' as (str:chararray);

b= FOREACH a GENERATE 
  REGEX_EXTRACT(str, '\\"business_id\\"\\:\\s\\"(.*?)\\"', 1) AS business_id, 
  REGEX_EXTRACT(str, '\\"checkin_info\\"\\:\\s\\{(.*)\\},',1) AS check_info,
  REGEX_EXTRACT(str,'\\"type\\"\\:\\s\\"(.*?)\\",',1) AS type;
   
STORE b INTO 'hbase://checkin_test' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'checkin:check_info
 checkin:type'
);   
