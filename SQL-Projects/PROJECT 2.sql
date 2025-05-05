create database clique_bait;
select * from users;
select * from events;
select * from page_hierarchy;
select * from campaign_identifier;
select * from event_identifier;
#DIGITAL ANALYSIS
#1. How many users are there?
SELECT COUNT(*) FROM USERS;
#2.How many cookies does each user have on average?
SELECT count(cookie_id),user_id FROM USERS 
GROUP BY user_id;
#3.What is the unique number of visits by all users per month?
SELECT distinct(visit_id) FROM EVENTS;
#4.What is the number of events for each event type?
SELECT count(event_type),event_type FROM EVENTS 
GROUP BY event_type;
#5.What is the percentage of visits which have a purchase event?
SELECT event_type,count(*),round(count(*)*100/(SELECT count(*) FROM EVENTS),2) FROM EVENTS
GROUP BY event_type;
#6.What is the percentage of visits which view the checkout page but do not have a purchase event?



