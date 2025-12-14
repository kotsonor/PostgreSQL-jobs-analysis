
SELECT 
    s.skills, 
    COUNT(*) AS skill_count
FROM job_postings_fact j 
INNER JOIN skills_job_dim AS job_to_skill ON job_to_skill.job_id = j.job_id
INNER JOIN skills_dim AS s ON s.skill_id = job_to_skill.skill_id
WHERE
    1 = 1
    {condition}
GROUP BY s.skills
ORDER BY skill_count DESC
LIMIT 10;



