-- 21 days of SQL - day 8

/* Tables
fct_queries(query_id, user_id, complexity_level, response_time_seconds, query_date)
fct_user_engagement(query_id, satisfaction_score)
*/

-- # Q1 What is the average response time for each query complexity level in January 2024?

select complexity_level, avg(response_time_seconds) as avg_time
from fct_queries
where query_date between "2024-01-01" and "2024-01-31"
group by complexity_level
order by avg_time desc;

-- # Q2 For each query complexity level, what is the average user satisfaction score for queries that took more than 2 seconds to respond in January 2024?

SELECT f.complexity_level, avg(u.satisfaction_score) as avg_score
from fct_queries f
join fct_user_engagement u 
on f.query_id = u.query_id
where f.query_date between "2024-01-01" and "2024-01-31"
and f.response_time_seconds > 2
group by f.complexity_level
order by avg_score desc;


-- # Q3 We want to identify the complexity level that optimizes both user engagement and system efficiency. Rank average user satisfaction (high to low) and average response time (low to high) across different complexity levels in January 2024. Which level has the best average satisfaction & response time ranking?

select f.complexity_level, avg(u.satisfaction_score) as avg_score, avg(f.response_time_seconds) as avg_response
from fct_queries f
join fct_user_engagement u
on f.query_id = u.query_id
where f.query_date between "2024-01-01" and "2024-01-31"
group by f.complexity_level
order by avg_score desc, avg_response asc;