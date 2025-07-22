-- 21 days of SQL - Day 19

/* Tables
fct_consultations(consultation_id, pharmacy_name, consultation_date, consultation_room_type, privacy_level_score)
*/

-- # Q1 What are the names of the 3 pharmacies that conducted the fewest number of consultations in July 2024? This will help us identify locations with potentially less crowded consultation spaces.

SELECT pharmacy_name, count(*) as visits
from fct_consultations
where consultation_date between "2024-07-01" and "2024-07-31"
group by pharmacy_name
order by visits ASC
limit 3;

-- # Q2 For the pharmacies identified in the previous question (ie. the 3 pharmacies with a fewest consultations in July 2024), what is the uppercase version of the consultation room types available? Understanding the room types can provide insights into the privacy features offered.

WITH bottom_3_pharmacies AS (
  SELECT pharmacy_name
  FROM fct_consultations
  WHERE consultation_date BETWEEN '2024-07-01' AND '2024-07-31'
  GROUP BY pharmacy_name
  ORDER BY COUNT(*) ASC
  LIMIT 3
)
SELECT DISTINCT 
  UPPER(c.consultation_room_type) AS room_type
FROM fct_consultations c
JOIN bottom_3_pharmacies b 
  ON c.pharmacy_name = b.pharmacy_name
WHERE c.consultation_date BETWEEN '2024-07-01' AND '2024-07-31';


-- # Q3 So far, we have identified the 3 pharmacies with a fewest consultations in July 2024. Among these 3 pharmacies, what is the minimum privacy level score for each consultation room type in July 2024?

 WITH bottom_3_pharmacies AS (
  SELECT pharmacy_name
  FROM fct_consultations
  WHERE consultation_date BETWEEN '2024-07-01' AND '2024-07-31'
  GROUP BY pharmacy_name
  ORDER BY COUNT(*) ASC
  LIMIT 3
)
SELECT 
  c.consultation_room_type AS room_type, min(c.privacy_level_score)
FROM fct_consultations c
JOIN bottom_3_pharmacies b 
  ON c.pharmacy_name = b.pharmacy_name
WHERE c.consultation_date BETWEEN '2024-07-01' AND '2024-07-31'
   group by room_type;