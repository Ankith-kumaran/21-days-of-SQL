-- 21 days of SQL - Day 21

/* Tables
fct_creator_content(content_id, creator_id, published_date, content_type, impressions_count, likes_count, comments_count, shares_count, new_followers_count)
dim_creator(creator_id, creator_name, category)
*/

-- # Q1 For content published in May 2024, which creator IDs show the highest new follower growth within each content type? If a creator published multiple of the same content type, we want to look at the total new follower growth from that content type.

WITH creator_growth AS (
  SELECT 
    creator_id,
    content_type,
    SUM(new_followers_count) AS total_new_followers
  FROM fct_creator_content
  WHERE published_date BETWEEN '2024-05-01' AND '2024-05-31'
  GROUP BY creator_id, content_type
),
ranked_creators AS (
  SELECT *,
         RANK() OVER (PARTITION BY content_type ORDER BY total_new_followers DESC) AS rank_within_type
  FROM creator_growth
)
SELECT creator_id, content_type, total_new_followers
FROM ranked_creators
WHERE rank_within_type = 1;


-- # Q2 Your Product Manager requests a report that shows impressions, likes, comments, and shares for each content type between April 8 and 21, 2024. She specifically requests that engagement metrics are unpivoted into a single 'metric type' column.

 SELECT content_type, 'impressions' AS metric_type, impressions_count AS metric_value
FROM fct_creator_content
WHERE published_date BETWEEN '2024-04-08' AND '2024-04-21'

UNION ALL

SELECT content_type, 'likes' AS metric_type, likes_count AS metric_value
FROM fct_creator_content
WHERE published_date BETWEEN '2024-04-08' AND '2024-04-21'

UNION ALL

SELECT content_type, 'comments' AS metric_type, comments_count AS metric_value
FROM fct_creator_content
WHERE published_date BETWEEN '2024-04-08' AND '2024-04-21'

UNION ALL

SELECT content_type, 'shares' AS metric_type, shares_count AS metric_value
FROM fct_creator_content
WHERE published_date BETWEEN '2024-04-08' AND '2024-04-21';

-- # Q3 For content published between April and June 2024, can you calculate for each creator, what % of their new followers came from each content type?

 WITH content_followers AS (
  SELECT 
    creator_id, 
    content_type, 
    SUM(new_followers_count) AS followers_by_type
  FROM fct_creator_content
  WHERE published_date BETWEEN '2024-04-01' AND '2024-06-30'
  GROUP BY creator_id, content_type
),

total_followers AS (
  SELECT 
    creator_id, 
    SUM(new_followers_count) AS total_followers
  FROM fct_creator_content
  WHERE published_date BETWEEN '2024-04-01' AND '2024-06-30'
  GROUP BY creator_id
)

SELECT 
  c.creator_id,
  c.content_type,
  ROUND(100.0 * c.followers_by_type / t.total_followers, 2) AS pct_new_followers
FROM content_followers c
JOIN total_followers t
  ON c.creator_id = t.creator_id
ORDER BY c.creator_id, pct_new_followers DESC;
