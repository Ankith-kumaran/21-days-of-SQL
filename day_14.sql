-- 21 days of SQL - day 14

/* Tables
fct_photo_gift_sales(transaction_id, customer_id, product_id, purchase_date, quantity)
*/

-- # Q1 For each personalized photo gift product, what is the total quantity purchased in April 2024? This result will provide a clear measure of product performance for our inventory strategies.

SELECT product_id, SUM(quantity) AS total_quantity
FROM fct_photo_gift_sales
WHERE purchase_date BETWEEN '2024-04-01' AND '2024-04-30'
GROUP BY product_id
ORDER BY total_quantity DESC;

-- # Q2 What is the maximum number of personalized photo gifts purchased in a single transaction during April 2024? This information will highlight peak purchasing behavior for individual transactions.

SELECT MAX(total_quantity) AS max_quantity_in_transaction
FROM (
  SELECT transaction_id, SUM(quantity) AS total_quantity
  FROM fct_photo_gift_sales
  WHERE purchase_date BETWEEN '2024-04-01' AND '2024-04-30'
  GROUP BY transaction_id
) t;


-- # Q3 What is the overall average number of personalized photo gifts purchased per customer during April 2024? That is, for each customer, calculate the total number of personalized photo gifts they purchased in April 2024 — then return the average of those values across all customer.

SELECT ROUND(AVG(total_quantity), 2) AS avg_gifts_per_customer
FROM (
  SELECT customer_id, SUM(quantity) AS total_quantity
  FROM fct_photo_gift_sales
  WHERE purchase_date BETWEEN '2024-04-01' AND '2024-04-30'
  GROUP BY customer_id
) t;
