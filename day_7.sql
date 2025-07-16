-- 21 days of SQL - day 7

/* Tables
fct_guest_inquiries(inquiry_id, host_id, guest_id, inquiry_date, response_time_hours)
*/

-- # Q1 What is the minimum host response time in hours for guest inquiries in January 2024? This metric will help identify if any hosts are setting an exceptionally quick response standard.

select min(response_time_hours)
from fct_guest_inquiries
where inquiry_date between "2024-01-01" and "2024-01-31";

-- # Q2 For guest inquiries made in January 2024, what is the average host response time rounded to the nearest hour? This average will provide insight into overall host responsiveness.

select round(avg(response_time_hours)) as avg_response
from fct_guest_inquiries
where inquiry_date between "2024-01-01" and "2024-01-31";

-- # Q3 List the inquiry_id and response_time_hours for guest inquiries made between January 16th and January 31st, 2024 that took longer than 2 hours to respond. This breakdown will help pinpoint hosts with slower response times.

select inquiry_id, response_time_hours
from fct_guest_inquiries
where inquiry_date between "2024-01-16" and "2024-01-31"
and response_time_hours > 2;