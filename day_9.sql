-- 21 days of SQL - Day 9

/* Tables
fct_transactions(transaction_id, user_id, transaction_date, amount)
fct_social_shares(share_id, user_id, share_date)
*/

-- # Q1 What is the floor value of the average number of transactions per user made between October 1st, 2024 and December 31st, 2024? This helps establish a baseline for user engagement on Venmo.

with t_count as 
(select count(transaction_id) as trans_count, user_id
  from fct_transactions
  where transaction_date between "2024-10-01" and "2024-12-31"
group by user_id)
select floor(avg(trans_count)) as floor_t_count
from t_count;

-- # Q2 How many distinct users executed at least one social share between October 1st, 2024 and December 31st, 2024? This helps assess the prevalence of social sharing among active users.

SELECT 
  COUNT(DISTINCT user_id) AS social_users
FROM 
  fct_social_shares
WHERE 
  share_date BETWEEN "2024-10-01" AND "2024-12-31";

  -- # Q3 What is the average difference in days between a user's first and last transactions from October 1st, 2024 to December 31st, 2024, for users who made 2 transactions vs. 3+ transactions?

  WITH user_txns AS (
  SELECT
    user_id,
    COUNT(transaction_id) AS txn_count,
    MIN(transaction_date) AS first_txn_date,
    MAX(transaction_date) AS last_txn_date
  FROM
    fct_transactions
  WHERE
    transaction_date BETWEEN '2024-10-01' AND '2024-12-31'
  GROUP BY
    user_id
),
user_diff AS (
  SELECT
    user_id,
    txn_count,
    CAST(julianday(last_txn_date) - julianday(first_txn_date) AS INTEGER) AS days_diff
  FROM
    user_txns
  WHERE
    txn_count >= 2
)
SELECT
  CASE 
    WHEN txn_count = 2 THEN '2 transactions'
    WHEN txn_count >= 3 THEN '3+ transactions'
  END AS transaction_group,
  AVG(days_diff) AS avg_days_difference
FROM
  user_diff
GROUP BY
  transaction_group;
