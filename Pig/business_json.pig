bt= LOAD '/home/sally01/data/yelp_training_set_business.json' USING JsonLoader ('business_id:chararray,full_address:chararray,open:chararray,categories:{t:(category:chararray)},city:chararray,review_count:int,name:chararray,neighborhoods:{t:(neighborhood:chararray)},longitude:float,state:chararray,stars:float,latitude:float,type:chararray');
d= foreach bt generate business_id,REPLACE(full_address,'\n','') AS full_address,open,categories,city,review_count,name,longitude,state,stars,latitude,type;
 
 STORE d INTO 'hbase://busi1' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'business:full_address
 business:open
 business:categories
 business:city
 business:review_count
 business:name
 business:longitude
 business:state
 business:stars
 business:latitude
 business:type'
);


—- Or use the regular expression to parse the business.json



a= load '/home/sally01/test/yelp_training_set_business.json' as(str:chararray);
b = FOREACH a GENERATE REPLACE(str, '\\"neighborhoods\\"\\:\\s\\[\\],\\s','') AS str;
c = FOREACH b GENERATE  REPLACE(REPLACE(REGEX_EXTRACT(str, '\\"categories\\"\\:\\s\\[(.*?)\\]', 1), '\\"', ''),',','#') AS categories , REPLACE(str, '\\"categories\\"\\:\\s\\[(.*?)\\],', '') AS str;


business_yelp = FOREACH c GENERATE 
    REGEX_EXTRACT(str, '\\"business_id\\"\\:\\s\\"(.*?)\\"', 1) AS business_id, 
    REGEX_EXTRACT(str, '\\"name\\"\\:\\s\\"(.*?)\\"', 1) AS name, 
    categories, 
    REGEX_EXTRACT(str, '\\"review_count\\"\\:\\s(.*?),', 1) AS review_count, 
    REGEX_EXTRACT(str, '\\"stars\\"\\:\\s(.*?),', 1) AS stars,
    REGEX_EXTRACT(str, '\\"open\\"\\:\\s(.*?),', 1) AS open,
    REPLACE(REPLACE(REGEX_EXTRACT(str, '\\"full_address\\"\\:\\s\\"(.*?)\\"', 1),'\\\\n','*'),'\\\\r','*') AS full_address,
    REGEX_EXTRACT(str, '\\"city\\"\\:\\s\\"(.*?)\\"', 1) AS city,
    REGEX_EXTRACT(str, '\\"state\\"\\:\\s\\"(.*?)\\"', 1) AS state,
    REGEX_EXTRACT(str, '\\"longitude\\"\\:\\s(.*?),', 1) AS longitude,
    REGEX_EXTRACT(str, '\\"latitude\\"\\:\\s(.*?),', 1) AS latitude;
    
  STORE business_yelp INTO 'hbase://business_test' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage(
'business:name 
 business:categories 
 business:review_count
 business:stars
 business:open
 business:full_address
 business:city
 business:state
 business:longitude
 business:latitude'
);

-- Sample data
-- {"business_id": "rncjoVoEFUJGCUoC1JgnUA", "full_address": "8466 W Peoria Ave\nSte 6\nPeoria, AZ 85345", "open": true, 
-- "categories": ["Accountants", "Professional Services", "Tax Services", "Financial Services"], "city": "Peoria", "review_count": 3, 
-- "name": "Peoria Income Tax Service", "neighborhoods": [], "longitude": -112.241596, "state": "AZ", "stars": 5.0, "latitude": 33.581867000000003, 
-- "type": "business"}
