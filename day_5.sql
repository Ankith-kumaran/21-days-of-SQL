-- 21 days of SQL - day 5

/* Tables
fct_user_interactions(interaction_id, user_id, content_type, interaction_duration, interaction_date, category_id)
dim_sports_categories(category_id, category_name)
*/

-- # Q1 What is the average duration of user interactions with live sports commentary during April 2024? Round the result to the nearest whole number.

SELECT round(avg(interaction_duration))
from fct_user_interactions
where interaction_date between "2024-04-01" and "2024-04-30"
and content_type = "live sports commentary";

-- # Q2 For the month of May 2024, determine the total number of users who interacted with live sports commentary and highlights. Ensure to include users who interacted with either or both content types.


 SELECT count(distinct user_id)
from fct_user_interactions
where interaction_date between "2024-05-01" and "2024-05-31"
and content_type in ("live sports commentary","highlights")


-- # Q3 Identify the top 3 performing sports categories for live sports commentary based on user engagement in May 2024. Focus on those with the highest total interaction time.

select d.category_name, sum(f.interaction_duration) as total_time
from fct_user_interactions f
join dim_sports_categories d on f.category_id = d.category_id
where f.interaction_date between "2024-05-01" and "2024-05-31"
and f.content_type = "live sports commentary"
group by d.category_name
order by total_time DESC
limit 3;