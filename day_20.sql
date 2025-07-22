--21 days of SQL - Day 20

/* Tables
fct_transactions(transaction_id, merchant_category, transaction_status, transaction_date)
*/

-- # Q1 For January 2024, what are the total counts of successful and failed transactions in each merchant category? This analysis will help the Google Pay security team identify potential friction points in payment processing.

SELECT 
  merchant_category, 
  transaction_status, 
  COUNT(*) AS transaction_count
FROM fct_transactions
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY merchant_category, transaction_status
ORDER BY merchant_category, transaction_status;


-- # Q2 For the first quarter of 2024, which merchant categories recorded a transaction success rate below 90%? This insight will guide our prioritization of security enhancements to improve payment reliability.


WITH success AS (
  SELECT merchant_category, COUNT(*) AS t_success
  FROM fct_transactions
  WHERE transaction_date BETWEEN '2024-01-01' AND '2024-03-31'
    AND transaction_status = 'SUCCESS'
  GROUP BY merchant_category
),
failed AS (
  SELECT merchant_category, COUNT(*) AS t_failed
  FROM fct_transactions
  WHERE transaction_date BETWEEN '2024-01-01' AND '2024-03-31'
    AND transaction_status = 'FAILED'
  GROUP BY merchant_category
)
SELECT 
  COALESCE(s.merchant_category, f.merchant_category) AS merchant_category,
  ROUND(100.0 * COALESCE(s.t_success, 0) / (COALESCE(s.t_success, 0) + COALESCE(f.t_failed, 0)), 2) AS success_rate
FROM success s
FULL OUTER JOIN failed f
  ON s.merchant_category = f.merchant_category
WHERE (COALESCE(s.t_success, 0) + COALESCE(f.t_failed, 0)) > 0
  AND (1.0 * COALESCE(s.t_success, 0)) / (COALESCE(s.t_success, 0) + COALESCE(f.t_failed, 0)) < 0.9
ORDER BY success_rate ASC;

-- # Q3 From January 1st to March 31st, 2024, can you generate a list of merchant categories with their concatenated counts for successful and failed transactions? Then, rank the categories by total transaction volume. This ranking will support our assessment of areas where mixed transaction outcomes may affect user experience.

SELECT 
  merchant_category,
  COUNT(CASE WHEN transaction_status = 'SUCCESS' THEN 1 END) AS success_count,
  COUNT(CASE WHEN transaction_status = 'FAILED' THEN 1 END) AS failed_count,
  COUNT(*) AS total_transactions,
  CONCAT(
    COUNT(CASE WHEN transaction_status = 'SUCCESS' THEN 1 END),
    ' SUCCESS / ',
    COUNT(CASE WHEN transaction_status = 'FAILED' THEN 1 END),
    ' FAILED'
  ) AS outcome_summary
FROM fct_transactions
WHERE transaction_date BETWEEN '2024-01-01' AND '2024-03-31'
GROUP BY merchant_category
ORDER BY total_transactions DESC;
