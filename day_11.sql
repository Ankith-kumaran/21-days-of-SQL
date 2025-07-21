-- 21 days of SQL - day 11

/* Tables

fct_transactions(transaction_id, business_id, transaction_amount, transaction_date)
dim_businesses(business_id, business_name, industry)

*/

-- # Q1 For each business, what is the total transaction amount in January 2024, and how does its ranking compare to other businesses? This analysis will help establish baseline revenue activity levels for financing eligibility.

select d.business_name, sum(f.transaction_amount) as totalamount,
  RANK() OVER (ORDER BY SUM(f.transaction_amount) DESC) AS revenue_rank
from fct_transactions f
join dim_businesses d on f.business_id = d.business_id
where f.transaction_date  between "2024-01-01" and "2024-01-31"
group by d.business_name
order by revenue_rank;

-- # Q2 For each business, calculate the percentage change in total transaction amount from January 2024 to February 2024. This metric will assist in understanding recent revenue growth trends.

WITH janamount AS (
  SELECT business_id, 
         SUM(transaction_amount) AS jan_total
  FROM fct_transactions
  WHERE transaction_date BETWEEN '2024-01-01' AND '2024-01-31'
  GROUP BY business_id
),
febamount AS (
  SELECT business_id, 
         SUM(transaction_amount) AS feb_total
  FROM fct_transactions
  WHERE transaction_date BETWEEN '2024-02-01' AND '2024-02-29'
  GROUP BY business_id
)
SELECT 
  d.business_name,
  j.business_id,
  j.jan_total,
  f.feb_total,
  ROUND(((f.feb_total - j.jan_total) / NULLIF(j.jan_total, 0)) * 100, 2) AS pct_change
FROM 
  janamount j
JOIN 
  febamount f ON j.business_id = f.business_id
JOIN 
  dim_businesses d ON j.business_id = d.business_id
ORDER BY 
  pct_change DESC;

-- # Q3 For each business, compute the month-over-month growth in total transaction amounts from January 2024 through March 2024. Rank each business based on this average growth (from highest to lowest), and return the rank number along with the business name and average growth.

WITH janamount AS (
  SELECT business_id, 
         SUM(transaction_amount) AS jan_total
  FROM fct_transactions
  WHERE transaction_date BETWEEN '2024-01-01' AND '2024-01-31'
  GROUP BY business_id
),
febamount AS (
  SELECT business_id, 
         SUM(transaction_amount) AS feb_total
  FROM fct_transactions
  WHERE transaction_date BETWEEN '2024-02-01' AND '2024-02-29'
  GROUP BY business_id
),
maramount AS (
  SELECT business_id, 
         SUM(transaction_amount) AS mar_total
  FROM fct_transactions
  WHERE transaction_date BETWEEN '2024-03-01' AND '2024-03-31'
  GROUP BY business_id
)
SELECT 
  d.business_name,
  j.business_id,
  ROUND(((f.feb_total - j.jan_total) / NULLIF(j.jan_total, 0)) * 100, 2) AS jan_to_feb_growth,
  ROUND(((m.mar_total - f.feb_total) / NULLIF(f.feb_total, 0)) * 100, 2) AS feb_to_mar_growth,
  ROUND((
    COALESCE(((f.feb_total - j.jan_total) / NULLIF(j.jan_total, 0)), 0) +
    COALESCE(((m.mar_total - f.feb_total) / NULLIF(f.feb_total, 0)), 0)
  ) / 2 * 100, 2) AS avg_growth_pct,
  RANK() OVER (ORDER BY (
    COALESCE(((f.feb_total - j.jan_total) / NULLIF(j.jan_total, 0)), 0) +
    COALESCE(((m.mar_total - f.feb_total) / NULLIF(f.feb_total, 0)), 0)
  ) / 2 DESC) AS growth_rank
FROM 
  janamount j
JOIN 
  febamount f ON j.business_id = f.business_id
JOIN 
  maramount m ON j.business_id = m.business_id
JOIN 
  dim_businesses d ON j.business_id = d.business_id
ORDER BY 
  growth_rank;

