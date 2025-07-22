-- 21 days of SQL - Day 18

/* Tables
fct_loans(loan_id, business_id, loan_amount, loan_issued_date, loan_repaid)
dim_businesses(business_id, monthly_revenue, revenue_variability, business_size)
*/

-- # Q1 What is the average monthly revenue for small businesses that received a loan versus those that did not receive a loan during January 2024? Use the ''business_size'' field to filter for small businesses.

WITH loans_in_jan AS (
  SELECT DISTINCT business_id
  FROM fct_loans
  WHERE loan_issued_date BETWEEN '2024-01-01' AND '2024-01-31'
),

small_businesses AS (
  SELECT business_id, monthly_revenue
  FROM dim_businesses
  WHERE business_size = 'small'
),

classified_businesses AS (
  SELECT 
    sb.business_id,
    sb.monthly_revenue,
    CASE 
      WHEN lj.business_id IS NOT NULL THEN 'Received Loan'
      ELSE 'No Loan'
    END AS loan_status
  FROM small_businesses sb
  LEFT JOIN loans_in_jan lj ON sb.business_id = lj.business_id
)

SELECT 
  loan_status,
  ROUND(AVG(monthly_revenue), 2) AS avg_monthly_revenue
FROM classified_businesses
GROUP BY loan_status;

/* # Q2 For loans issued to small businesses in January 2024, what percentage were successfully repaid? Categorize these loans based on the borrowing business’s revenue variability (low, medium, or high) using these values
- Low: <0.1
- Medium: 0.1 - 0.3 inclusive
- High: >0.3
*/

WITH jan_small_loans AS (
  SELECT 
    f.loan_id,
    f.business_id,
    f.loan_repaid,
    d.revenue_variability,
    CASE 
      WHEN d.revenue_variability < 0.1 THEN 'Low'
      WHEN d.revenue_variability <= 0.3 THEN 'Medium'
      ELSE 'High'
    END AS variability_category
  FROM fct_loans f
  JOIN dim_businesses d ON f.business_id = d.business_id
  WHERE f.loan_issued_date BETWEEN '2024-01-01' AND '2024-01-31'
    AND d.business_size = 'small'
),

repayment_stats AS (
  SELECT 
    variability_category,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_repaid = 1 THEN 1 ELSE 0 END) AS repaid_loans
  FROM jan_small_loans
  GROUP BY variability_category
)

SELECT 
  variability_category,
  ROUND(100.0 * repaid_loans / total_loans, 2) AS pct_repaid
FROM repayment_stats
ORDER BY variability_category;

-- # Q3 For small businesses during January 2024, what is the loan repayment success rate for each revenue variability category? Order the results from the highest to the lowest success rate to assess the correlation between revenue variability and repayment reliability.

 WITH jan_small_loans AS (
  SELECT 
    f.loan_id,
    f.loan_repaid,
    CASE 
      WHEN d.revenue_variability < 0.1 THEN 'Low'
      WHEN d.revenue_variability <= 0.3 THEN 'Medium'
      ELSE 'High'
    END AS variability_category
  FROM fct_loans f
  JOIN dim_businesses d ON f.business_id = d.business_id
  WHERE f.loan_issued_date BETWEEN '2024-01-01' AND '2024-01-31'
    AND d.business_size = 'small'
),

repayment_stats AS (
  SELECT 
    variability_category,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_repaid = 1 THEN 1 ELSE 0 END) AS repaid_loans
  FROM jan_small_loans
  GROUP BY variability_category
)

SELECT 
  variability_category,
  ROUND(100.0 * repaid_loans / total_loans, 2) AS repayment_success_rate
FROM repayment_stats
ORDER BY repayment_success_rate DESC;



