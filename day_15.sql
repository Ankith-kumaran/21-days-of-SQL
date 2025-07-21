-- 21 days of SQL - day 15

/* Tables
fct_transactions(transaction_id, customer_id, service_tier_code, transaction_date)
*/

-- # Q1 We want to evaluate early premium service adoption among enterprise customers. How many unique customers with service tier codes starting with ''PREM'' completed transactions from April 1st to April 30th, 2024?

select count(DISTINCT customer_id)
from fct_transactions
where transaction_date between "2024-04-01" and "2024-04-30"
and service_tier_code like "PREM%";

-- # Q2 We need to understand usage trends for different service tiers in order to refine our service packages. Which service tier codes were used most frequently by customers for transactions in May 2024, ranked from most to least frequent?

SELECT 
  service_tier_code,
  COUNT(*) AS transaction_count,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS tier_rank
FROM fct_transactions
WHERE transaction_date BETWEEN '2024-05-01' AND '2024-05-31'
GROUP BY service_tier_code;


-- # Q3 We want to pinpoint the most active service tiers to inform pricing adjustments for enterprise cloud offerings. For transactions between June 1st and June 30th, 2024, what are the top three service tier codes based on transaction volume and how many transactions were recorded for each?
 SELECT service_tier_code,
   count(*) as service_count
from fct_transactions
where transaction_date between "2024-06-01" and "2024-06-30"
group by service_tier_code
order by service_count DESC
limit 3;
