
SELECT 
    s.skills, 
    ROUND(AVG(j.salary_year_avg), 2) AS average_salary
FROM job_postings_fact j 
INNER JOIN skills_job_dim AS job_to_skill ON job_to_skill.job_id = j.job_id
INNER JOIN skills_dim AS s ON s.skill_id = job_to_skill.skill_id
WHERE 
    j.salary_year_avg IS NOT NULL AND
    1 = 1 
    {condition}
GROUP BY s.skills
ORDER BY average_salary DESC
LIMIT 10;



