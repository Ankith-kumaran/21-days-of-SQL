-- 21 days of SQL - Day 12

/* Tables
ar_filter_engagements(engagement_id, filter_id, interaction_count, engagement_date)
ar_filters(filter_id, filter_name)
*/

-- # Q1 Which AR filters have generated user interactions in July 2024? List the filters by name.

select distinct a.filter_name
from ar_filters a
join ar_filter_engagements e
on a.filter_id = e.filter_id
where e.engagement_date between "2024-07-01" and "2024-07-31";

-- # Q2 How many total interactions did each AR filter receive in August 2024? Return only filter names that received over 1000 interactions, and their respective interaction counts.

 select a.filter_name, sum(e.interaction_count) as total_count
from ar_filter_engagements e
join ar_filters a
where e.engagement_date between "2024-08-01" and "2024-08-31"
group by a.filter_name
having total_count > 1000
order by total_count desc;

-- # Q3 What are the top 3 AR filters with the highest number of interactions in September 2024, and how many interactions did each receive?

select a.filter_name, sum(e.interaction_count) as total_count
from ar_filter_engagements e
join ar_filters a on e.filter_id = a.filter_id
where e.engagement_date between "2024-09-01" and "2024-09-30"
group by a.filter_name
order by total_count desc
limit 3;


