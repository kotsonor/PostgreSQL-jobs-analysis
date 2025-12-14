-- "Data Scientist Job"

SELECT *
FROM job_postings_fact 
WHERE job_title LIKE '%Data%Scientist%';

-- Hightest salary

SELECT 
    job_title_short,
    job_location,
    salary_year_avg
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

-- Unique schedule type jobs
SELECT DISTINCT
    job_schedule_type
FROM job_postings_fact;


-- JOB ID and name
SELECT 
    j.company_id,
    c.name, 
    c.link,
    j.salary_year_avg
FROM job_postings_fact j
LEFT JOIN company_dim AS c ON j.company_id = c.company_id
WHERE j.salary_year_avg IS NOT NULL
LIMIT 10;

SELECT * FROM job_postings_fact LIMIT 5


-- all skills for certain job 31361

SELECT 
    j.job_title,
    j.company_id, 
    c.name,
    skills.skills
FROM job_postings_fact j 
LEFT JOIN skills_job_dim AS job_to_skill ON j.job_id = job_to_skill.job_id
LEFT JOIN skills_dim AS skills ON job_to_skill.skill_id = skills.skill_id
LEFT JOIN company_dim AS c ON j.company_id = c.company_id
WHERE j.job_id = 31361
