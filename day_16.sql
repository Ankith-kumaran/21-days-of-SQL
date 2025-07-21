-- 21 days of SQL - Day 16

/* Tables
fct_corporate_bookings(booking_id, company_id, employee_id, booking_cost, booking_date, travel_date)
dim_companies(company_id, company_name)
*/

-- # Q1 What is the average booking cost for corporate travelers? For this question, let's look only at trips which were booked in January 2024

select avg(booking_cost)
from fct_corporate_bookings
where booking_date between "2024-01-01" and "2024-01-31";


-- # Q2 Identify the top 5 companies with the highest average booking cost per employee for trips taken during the first quarter of 2024. Note that if an employee takes multiple trips, each booking will show up as a separate row in fct_corporate_bookings.

WITH employee_avg_cost AS (
  SELECT 
    company_id,
    employee_id,
    AVG(booking_cost) AS avg_booking_per_employee
  FROM fct_corporate_bookings
  WHERE travel_date BETWEEN '2024-01-01' AND '2024-03-31'
  GROUP BY company_id, employee_id
)
SELECT
  d.company_name,
  AVG(e.avg_booking_per_employee) AS avg_booking_cost_per_employee
FROM employee_avg_cost e
JOIN dim_companies d ON e.company_id = d.company_id
GROUP BY d.company_name
ORDER BY avg_booking_cost_per_employee DESC
LIMIT 5;

-- # Q3 For bookings made in February 2024, what percentage of bookings were made more than 30 days in advance? Use this to recommend strategies for reducing booking costs.

SELECT
  ROUND(
    100.0 * SUM(CASE WHEN julianday(travel_date) - julianday(booking_date) > 30 THEN 1 ELSE 0 END) 
    / COUNT(*), 
    2
  ) AS pct_advanced_bookings
FROM fct_corporate_bookings
WHERE booking_date BETWEEN '2024-02-01' AND '2024-02-29';
