--21 days of SQL - Day 2

/* Tables
fct_file_sharing(file_id, file_name, organization_id, shared_date, co_editing_user_id)
dim_organization(organization_id, organization_name, segment)
*/
-- Q1 # What is the average length of the file names shared for each organizational segment in January 2024?

SELECT 
    d.segment,
    AVG(LENGTH(f.file_name)) AS avg_file_name_length
FROM 
    fct_file_sharing f
JOIN 
    dim_organization d
    ON f.organization_id = d.organization_id
WHERE 
    f.shared_date between "2024-01-01" and "2024-01-31"
GROUP BY 
    d.segment
ORDER BY 
    d.segment;

-- Q2 # How many files were shared with names that start with the same prefix as the organization name, concatenated with a hyphen, in February 2024?

select count(f.file_name)
from fct_file_sharing f
join dim_organization d on f.organization_id = d.organization_id
where f.shared_date between "2024-02-01" and "2024-02-28"
and f.file_name like concat(d.organization_name, "-%");

 -- Q3 # Identify the top 3 organizational segments with the highest number of files shared where the co-editing user is NULL, indicating a potential security risk, during the first quarter of 2024.

select d.segment, count(*) as num_shared
from fct_file_sharing f 
join dim_organization d on f.organization_id = d.organization_id
where f.shared_date between "2024-01-01" and "2024-03-31"
and f.co_editing_user_id IS NULL
group by d.segment
order by num_shared desc
limit 3;
