This is Yelp  real-time recommending System project.

First I downloaded the Yelp history data from the Kaggle website. This datasets are json files. 

The project is based on the Lambda Architecture.

Json file for this project:

Data format:
Business

{
  'type': 'business',
  'business_id': (encrypted business id),
  'name': (business name),
  'neighborhoods': [(hood names)],
  'full_address': (localized address),
  'city': (city),
  'state': (state),
  'latitude': latitude,
  'longitude': longitude,
  'stars': (star rating, rounded to half-stars),
  'review_count': review count,
  'categories': [(localized category names)]
  'open': True / False (corresponds to permanently closed, not business hours),
}

Review

{
  'type': 'review',
  'business_id': (encrypted business id),
  'user_id': (encrypted user id),
  'stars': (star rating),
  'text': (review text),
  'date': (date, formatted like '2012-03-14', %Y-%m-%d in strptime notation),
  'votes': {'useful': (count), 'funny': (count), 'cool': (count)}
}

User

Some user profiles are omitted from the data because they have elected not to have public profiles. Their reviews may still be in the data set if they are still visible on Yelp.

{
  'type': 'user',
  'user_id': (encrypted user id),
  'name': (first name),
  'review_count': (review count),
  'average_stars': (floating point average, like 4.31),
  'votes': {'useful': (count), 'funny': (count), 'cool': (count)}
}

Checkin

If there are no checkins for a business, the entire record will be omitted.

{
  'type': 'checkin',
  'business_id': (encrypted business id),
  'checkin_info': {
        '0-0': (number of checkins from 00:00 to 01:00 on all Sundays),
        '1-0': (number of checkins from 01:00 to 02:00 on all Sundays), 
        ... 
        '14-4': (number of checkins from 14:00 to 15:00 on all Thursdays),
        ...
        '23-6': (number of checkins from 23:00 to 00:00 on all Saturdays)
  } # if there was no checkin for an hour-day block it will not be in the dict
}

###### Batch Layer ######
At first, what I just focus on is loading all the information to Hive, then to Hbase. But there is a problem I didnot realize at first. There are some complex format in the Json file like map, struct. After I loaded review file to Hive, then Hbase, I suddenly realized that I cannot go on the subsequent query with the map and struct format. So I convert the complex format to simple format using regular expression.
In this part, I loaded the data in two way: Hive  and Pig. Since the data is not that large, there is almost no difference for these two method. 
 
 

###### Speed Layer ######

1. Load data to Kafka.

I researched the Yelp's Api, but its rest Api was not able to return a lot of reviews based on a certain business name or id. Also I looked at its RSS feed, but it only returns 20 new reviews every 2 hour, and most of the records doesn't match the business name in my own business table(because my data was only a fraction of the business in Arizona). So crawling some data from Yelp website. 

2. process the Data using Kafka and Storm

YelpKafkaHBase is a maven project to process the records in Kafka using Storm, it contains a KafkaSpout, a SplitFieldsBolt and a UpdateReviewToHbaseBolt.

KafkaSpout simply retrieve the records from kafka. And the data Kafka processes is the data just crawled.

SplitFieldsBolt split the records into different fields, like review_id, review_text, etc.

####### Serving Layer ######

Usually people who makes more reviews are considered more reliable. So I think of counting the review made only by these active users

the steps are:
(1)filter the users who are active from the history data

(2) join the new business able (speed layer) with the active_user table
So I filered the TOP 10 restaurants.  


