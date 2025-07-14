--21 days of SQL - Day 1

/* Tables
ad_campaigns(campaign_id, campaign_name, start_date, conversions, revenue, ad_type)
*/
-- Q1 # What are the top 5 ad campaign IDs with the highest number of conversions, that started in April 2024?

Select campaign_id
from ad_campaigns
where start_date between "2024-04-01" and "2024-04-31"
order by conversions DESC
limit 5;

-- Q2 # Identify the distinct ad types with more than 100 conversions that started in May 2024.

select DISTINCT ad_type
from ad_campaigns
where conversions > 100 and (start_date between "2024-05-01" and "2024-05-31")
order by ad_type;

 -- Q3 # Of the campaigns that started in June 2024, find the ones that did not generate any revenue. Please list the campaign names and start dates.

SELECT campaign_name, start_date
from ad_campaigns
where (start_date between "2024-06-01" and "2024-06-30") and revenue = 0
order by start_date;
