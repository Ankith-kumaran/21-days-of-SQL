-- 21 days of SQL - day 3

/* Tables
fct_chat_interactions(user_id, message_id, feature_used, interaction_date)
users(id, name, department, created_at)
*/

--  Q1 # To assess the popularity of promotions among Prime members, how many Prime members purchased deals in January 2024? What is the average number of deals purchased per member?

select count(DISTINCT member_id), avg(deal_count) as avg_deals
from
(
  select member_id, count(deal_id) as deal_count

from fct_prime_deals
where purchase_date between "2024-01-01" and "2024-01-31"
group by member_id
  );


-- Q2 # To gain insights into purchase patterns, what is the distribution of members based on the number of deals purchased in February 2024? Group the members into the following categories: 1-2 deals, 3-5 deals, and more than 5 deals.

SELECT 
    CASE 
        WHEN deal_count BETWEEN 1 AND 2 THEN '1-2 deals'
        WHEN deal_count BETWEEN 3 AND 5 THEN '3-5 deals'
        WHEN deal_count > 5 THEN '>5 deals'
    END AS deal_bucket,
    COUNT(*) AS num_members
FROM (
    SELECT 
        member_id,
        COUNT(deal_id) AS deal_count
    FROM 
        fct_prime_deals
    WHERE 
        purchase_date between "2024-02-01" and "2024-02-28"
    GROUP BY member_id
) sub
GROUP BY deal_bucket
ORDER BY deal_bucket;

-- Q3 # To target highly engaged members for tailored promotions, can we identify Prime members who purchased more than 5 exclusive deals between January 1st and March 31st, 2024? How many such members are there and what is their average total spend on these deals?

SELECT 
    COUNT(*) AS num_members,
    AVG(total_spend) AS avg_total_spend
FROM (
    SELECT 
        member_id,
        COUNT(deal_id) AS deal_count,
        SUM(purchase_amount) AS total_spend
    FROM 
        fct_prime_deals
    WHERE 
        purchase_date between "2024-01-01" and "2024-03-31"
    GROUP BY 
        member_id
    HAVING 
        COUNT(deal_id) > 5
) sub;

