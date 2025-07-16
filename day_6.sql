-- 21 days of SQL - day 6
/* Tables
fct_photo_sharing(photo_id, user_id, shared_date)
dim_user(user_id, age, country)
*/

-- # Q1 How many photos were shared by users who are either under 18 years old or over 50 years old during July 2024? This metric will help us understand if these age segments are engaging with the photo sharing feature.

select count(f.photo_id)
from fct_photo_sharing f
join dim_user d on f.user_id = d.user_id
where f.shared_date between "2024-07-01" and "2024-07-31"
and (d.age < 18 or d.age > 50)

-- # Q2 What are the user IDs and the total number of photos shared by users who are not from the United States during August 2024? This analysis will help us identify engagement patterns among international users.

 select f.user_id, count(f.photo_id) as total_photos
from fct_photo_sharing f
join dim_user d on f.user_id = d.user_id
where f.shared_date between "2024-08-01" and "2024-08-31"
and d.country <> 'United States'
group by f.user_id
order by total_photos desc;

-- # Q3 What is the total number of photos shared by users who are either under 18 years old or over 50 years old and who are not from the United States during the third quarter of 2024? This measure will inform us if there are significant differences in usage across these age and geographic segments.

select count(f.photo_id) as total_photos
from fct_photo_sharing f
join dim_user d on f.user_id = d.user_id
where f.shared_date between "2024-07-01" and "2024-09-30"
and (d.age < 18 or d.age > 50)
and d.country <> 'United States';

