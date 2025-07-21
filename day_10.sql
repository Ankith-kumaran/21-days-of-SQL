--21 days of SQL - day 10

/* Tables
fct_zone_daily_rides(zone_name, ride_date, total_requests, accepted_requests, declined_requests, acceptance_rate)
*/

-- # Q1 For each geographic zone, what is the minimum acceptance rate observed during Quarter 2 2024? This information will help assess the worst-case driver acceptance performance by zone.

select zone_name, min(acceptance_rate)
from fct_zone_daily_rides
where ride_date between "2024-04-01" and "2024-06-30"
group by zone_name;

-- # Q2 List the distinct geographic zones that had at least one day in Quarter 2 2024 with an acceptance rate below 50%. This list will be used to identify zones where drivers are generally more reluctant to accept rides.

 select DISTINCT zone_name
from fct_zone_daily_rides
where ride_date between "2024-04-01" and "2024-06-30"
and acceptance_rate < 0.5;

-- # Q3 Which geographic zone had the lowest ride acceptance rate on a single day in Q2 2024, while also having at least 10 declined ride requests on that same day? Recall that each row in the table represents data for a single data in a single geographic region.

 select zone_name, min(acceptance_rate) as minrate
from fct_zone_daily_rides
where ride_date between "2024-04-01" and "2024-06-30"
and declined_requests >= 10
group by zone_name
order by minrate ASC
   limit 1;