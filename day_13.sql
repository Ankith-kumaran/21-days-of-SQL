-- 21 days of SQL - Day 13

/* Tables
tracks_added(interaction_id, user_id, track_id, added_date, is_recommended)
users(user_id, user_name)
*/

-- # Q1 How many unique users have added at least one recommended track to their playlists in October 2024?

select count(distinct u.user_id)
from users u
join tracks_added t on u.user_id = t.user_id
where t.added_date between "2024-10-01" and "2024-10-31"
and t.is_recommended = 1;

-- # Q2 Among the users who added recommended tracks in October 2024, what is the average number of recommended tracks added to their playlists? Please round this to 1 decimal place for better readability.

SELECT 
  ROUND(
    CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT user_id), 
    1
  ) AS avg_recommended_tracks_per_user
FROM tracks_added
WHERE added_date BETWEEN '2024-10-01' AND '2024-10-31'
  AND is_recommended = 1;


-- # Q3 Can you give us the name(s) of users who added a non-recommended track to their playlist on October 2nd, 2024?

 select u.user_name
from tracks_added t
join users u on t.user_id = u.user_id
where t.added_date = "2024-10-02"
and t.is_recommended = 0;