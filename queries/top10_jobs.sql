/* queries/top10_jobs.sql */
SELECT 
    job_title_short,
    job_title,
    c.name AS company_name, 
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE job_location 
    END AS job_location,
    job_schedule_type, 
    salary_year_avg,
    job_posted_date
FROM job_postings_fact j 
INNER JOIN company_dim c ON c.company_id = j.company_id
WHERE 
    salary_year_avg IS NOT NULL
    -- <condition_placeholder> -- for python 
    {condition}
ORDER BY salary_year_avg DESC
LIMIT 10;