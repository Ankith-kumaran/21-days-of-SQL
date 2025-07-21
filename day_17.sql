-- 21 days of SQL - Day 17

/* Tables
fct_orders(order_id, delivery_partner_id, delivery_partner_name, expected_delivery_time, actual_delivery_time, order_date)
*/

-- # Q1 What is the percentage of orders delivered on time in January 2024? Consider an order on time if its actual_delivery_time is less than or equal to its expected_delivery_time. This will help us assess overall tracking precision.

WITH on_time AS (
  SELECT COUNT(*) AS on_timedel
  FROM fct_orders
  WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
    AND actual_delivery_time <= expected_delivery_time
),
total_orders AS (
  SELECT COUNT(*) AS total_del
  FROM fct_orders
  WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
)
SELECT 
  ROUND(100.0 * on_timedel / total_del, 2) AS pct_on_time_deliveries
FROM on_time, total_orders;


-- # Q2 List the top 5 delivery partners in January 2024 ranked by the highest percentage of on-time deliveries. Use the delivery_partner_name field from the records. This will help us identify which partners perform best.

WITH on_time AS (
  SELECT 
    delivery_partner_id, 
    COUNT(*) AS on_timedel
  FROM fct_orders
  WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
    AND actual_delivery_time <= expected_delivery_time
  GROUP BY delivery_partner_id
),
total_orders AS (
  SELECT 
    delivery_partner_id, 
    COUNT(*) AS total_del,
    MIN(delivery_partner_name) AS delivery_partner_name
  FROM fct_orders
  WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
  GROUP BY delivery_partner_id
)
SELECT 
  t.delivery_partner_name,
  ROUND(100.0 * COALESCE(o.on_timedel, 0) / t.total_del, 2) AS pct_on_time_deliveries
FROM total_orders t
LEFT JOIN on_time o ON t.delivery_partner_id = o.delivery_partner_id
ORDER BY pct_on_time_deliveries DESC
LIMIT 5;


-- # Q3 Identify the delivery partner(s) in January 2024 whose on-time delivery percentage is below 50%. Return their partner names in uppercase. We need to work with these delivery partners to improve their on-time delivery rates.

 WITH on_time AS (
  SELECT 
    delivery_partner_id, 
    COUNT(*) AS on_timedel
  FROM fct_orders
  WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
    AND actual_delivery_time <= expected_delivery_time
  GROUP BY delivery_partner_id
),
total_orders AS (
  SELECT 
    delivery_partner_id, 
    COUNT(*) AS total_del,
    MIN(delivery_partner_name) AS delivery_partner_name
  FROM fct_orders
  WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
  GROUP BY delivery_partner_id
)
SELECT 
  UPPER(t.delivery_partner_name) AS partner_name_uppercase
FROM total_orders t
LEFT JOIN on_time o ON t.delivery_partner_id = o.delivery_partner_id
WHERE COALESCE(o.on_timedel, 0) * 100.0 / t.total_del < 50
ORDER BY partner_name_uppercase;
