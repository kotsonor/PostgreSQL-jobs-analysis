SELECT 
    job_title_short AS "Job Title",
    job_location AS "Location",
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS "Posted Date",
    EXTRACT(MONTH FROM job_posted_date) AS "Posted Month",
    EXTRACT(YEAR FROM job_posted_date) AS "Posted Year"
FROM job_postings_fact
LIMIT 100; 

SELECT 
    COUNT(job_id) AS job_posted_count,  
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY month 
ORDER BY job_posted_count DESC;

SELECT * FROM job_postings_fact LIMIT 5;

SELECT
    job_schedule_type,
    avg(salary_year_avg) AS average_salary, 
    avg(salary_hour_avg) AS average_hourly_salary 
FROM job_postings_fact
WHERE job_posted_date >= '2023-06-01'
GROUP BY job_schedule_type;

WITH YearlyData AS (
    SELECT
        job_id,
        EXTRACT(MONTH from job_posted_date) AS month,
        EXTRACT(YEAR from job_posted_date) AS year  -- Alias jest tworzony w tym podzapytaniu
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
)
SELECT 
    COUNT(job_id) AS job_count,
    month,
    year
FROM YearlyData
WHERE year = 2023  -- Tutaj alias 'year' jest już dostępny
GROUP BY month, year;



SELECT 
    j.company_id,
    companies.name,
    EXTRACT(QUARTER FROM j.job_posted_date) AS posted_quarter
FROM job_postings_fact j
LEFT JOIN company_dim companies ON j.company_id = companies.company_id
WHERE EXTRACT(QUARTER FROM j.job_posted_date) = 3;
 

CREATE TABLE january_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1; 

CREATE TABLE february_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2; 


CREATE TABLE march_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3; 

CREATE TABLE april_jobs AS
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4;  

CREATE TABLE may_jobs AS
    SELECT * 
    FROM job_postings_fact         
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

CREATE TABLE june_jobs AS
    SELECT * 
    FROM job_postings_fact         
    WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

CREATE TABLE july_jobs AS
    SELECT * 
    FROM job_postings_fact         
    WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

CREATE TABLE august_jobs AS
    SELECT * 
    FROM job_postings_fact         
    WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

CREATE TABLE september_jobs AS
    SELECT * 
    FROM job_postings_fact         
    WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

CREATE TABLE october_jobs AS
    SELECT * 
    FROM job_postings_fact         
    WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

CREATE TABLE november_jobs AS
    SELECT * 
    FROM job_postings_fact         
    WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

CREATE TABLE december_jobs AS
    SELECT * 
    FROM job_postings_fact         
    WHERE EXTRACT(MONTH FROM job_posted_date) = 12;


SELECT 
    job_location,

    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
LIMIT 50;


WITH january_jobs AS (
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT * FROM january_jobs LIMIT 50;  

WITH company_job_counts AS (
    SELECT 
        company_id, 
        COUNT(job_id) AS job_count
    FROM job_postings_fact
    GROUP BY company_id
)

SELECT 
    cjc.company_id,
    cd.name AS company_name,
    cjc.job_count
FROM company_job_counts cjc
LEFT JOIN company_dim cd ON cjc.company_id = cd.company_id
ORDER BY cjc.job_count DESC
LIMIT 100; 



WITH skill_count AS (
    SELECT 
        skill_id, 
        COUNT(*) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY skill_count DESC
)
SELECT 
    sc.skill_id, 
    sd.skills,
    sc.skill_count
FROM skill_count sc
LEFT JOIN skills_dim sd ON sc.skill_id = sd.skill_id;


SELECT 
    company_id,
    number_of_jobs,
    CASE 
        WHEN number_of_jobs < 10 THEN 'SMALL'
        WHEN number_of_jobs BETWEEN 10 AND 20 THEN 'MID'
        ELSE 'BIG'
    END AS typee
FROM 
    (
        SELECT 
            company_id,
            COUNT(*) as number_of_jobs
        FROM job_postings_fact
        GROUP BY company_id
    )
LIMIT 50; 


WITH remote_job_skills AS (
    SELECT 
        skill_id,
        count(*) AS skill_count
    FROM skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_posts ON skills_to_job.job_id = job_posts.job_id
    WHERE 
        job_posts.job_work_from_home = True AND
        job_posts.job_title_short = 'Data Analyst'
    GROUP BY skills_to_job.skill_id
)

SELECT 
    skills.skill_id,
    skills.skills,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;


SELECT 
    job_id,
    company_id, 
    job_title_short
FROM january_jobs

UNION ALL

SELECT 
    job_id, 
    company_id, 
    job_title_short
FROM february_jobs

UNION ALL 

SELECT 
    job_id, 
    company_id, 
    job_title_short
FROM march_jobs;



SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    sjd.skill_id,
    sd.skills,
    sd.type
FROM
    job_postings_fact jpf
LEFT JOIN
    skills_job_dim sjd ON jpf.job_id = sjd.job_id
LEFT JOIN
    skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    -- Użycie EXTRACT(QUARTER) do filtrowania dla Q1
    EXTRACT(QUARTER FROM jpf.job_posted_date) = 1
    AND jpf.salary_year_avg > 70000
ORDER BY
    jpf.job_id,
    sd.skills;



SELECT 
    job_id, 
    job_title_short,
    salary_year_avg,
    job_posted_date
FROM january_jobs
WHERE salary_year_avg > 70000

UNION

SELECT 
    job_id, 
    job_title_short,
    salary_year_avg,
    job_posted_date
FROM february_jobs
WHERE salary_year_avg > 70000

UNION

SELECT 
    job_id, 
    job_title_short,
    salary_year_avg,
    job_posted_date
FROM march_jobs
WHERE salary_year_avg > 70000


SELECT * 
FROM (
    SELECT 
    job_id, 
    job_title_short,
    salary_year_avg,
    job_posted_date
    FROM january_jobs

    UNION

    SELECT 
        job_id, 
        job_title_short,
        salary_year_avg,
        job_posted_date
    FROM february_jobs

    UNION

    SELECT 
        job_id, 
        job_title_short,
        salary_year_avg,
        job_posted_date
    FROM march_jobs
    ) AS Q1_jobs
WHERE salary_year_avg > 70000;
 

SELECT 
    q1_jobs.job_title_short,
    q1_jobs.job_location, 
    q1_jobs.job_posted_date::DATE,
    q1_jobs.salary_year_avg
FROM (
    SELECT * 
    FROM january_jobs
    UNION ALL
    SELECT * 
    FROM february_jobs
    UNION ALL
    SELECT * 
    FROM march_jobs
    ) AS q1_jobs 
WHERE 
    q1_jobs.salary_year_avg > 70000 AND
    q1_jobs.job_title_short = 'Data Analyst'
ORDER BY q1_jobs.job_posted_date