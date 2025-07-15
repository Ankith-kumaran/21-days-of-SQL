--21 days of SQL - Day 4

/* Tables
fct_messages(message_id, user_id, message_sent_date)
*/

-- # Q1 What is the total number of messages sent during April 2024? This information will help us quantify overall engagement as a baseline for targeted product enhancements.

select count(message_id)
from fct_messages
where message_sent_date between "2024-04-01" and "2024-04-30";

-- # Q2 What is the average number of messages sent per user during April 2024? Round your result to the nearest whole number. This metric provides insight into individual engagement levels for refining our communication features.

with user_message AS
(
  select distinct user_id, count(message_id) as user_count
  from fct_messages
  where message_sent_date between "2024-04-01" and "2024-04-30"
  group by user_id
)
select round (avg(user_count)) as avg_messages
from user_message;

-- # Q3 What percentage of users sent more than 50 messages during April 2024? This calculation will help identify highly engaged users and support recommendations for enhancing messaging interactions.

WITH user_message AS (
  SELECT 
    user_id, 
    COUNT(message_id) AS message_count
  FROM fct_messages
  WHERE message_sent_date BETWEEN '2024-04-01' AND '2024-04-30'
  GROUP BY user_id
),
total_users AS (
  SELECT COUNT(*) AS total_count FROM user_message
),
users_above_50 AS (
  SELECT COUNT(*) AS above_50_count FROM user_message WHERE message_count > 50
)
SELECT 
  ROUND((above_50_count * 100.0) / total_count, 2) AS percent_above_50
FROM 
  users_above_50, total_users;