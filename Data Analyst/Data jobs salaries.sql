USE [Data Jobs Salaries]
SELECT * FROM salary

--- GENERAL QUESTIONS

--- 1. Top 10 the best paid profession monthly in 2020, 2021, 2022 and 2023

WITH aaa AS (
	SELECT job_title, salary_in_usd, work_year
	FROM salary
	WHERE work_year IN (2020, 2021, 2022, 2023)
),
	 bbb AS (
	SELECT *, RANK() OVER (ORDER BY salary_in_usd DESC) as rankk
	FROM aaa)
	SELECT job_title, ROUND((salary_in_usd /12), 0) as paid_monthly, work_year FROM bbb
	WHERE rankk BETWEEN 1 AND 10 

--- 2. How much Data Analyst makes in USA average per month?

SELECT 
	job_title, ROUND((AVG(salary_in_usd) / 12), 0) as avg_payment_monthly
	FROM salary
	WHERE company_location = 'US' and job_title = 'Data Analyst'
	GROUP BY job_title

--- 3. Which position has had the most salary changes in the last two years?

WITH aaa AS (
	SELECT 
	job_title,
		MAX(CASE WHEN work_year = 2023 THEN salary_in_usd END) - MAX(CASE WHEN work_year = 2021 THEN salary_in_usd END) as salary_diff
	FROM salary
	WHERE work_year IN (2021, 2023)
	GROUP BY job_title
),
bbb AS (
	SELECT *, DENSE_RANK() OVER (ORDER BY salary_diff DESC) as rankk
	FROM aaa
)
	SELECT job_title, salary_diff 
	FROM bbb
	WHERE rankk = 1

--- Analyse according to location

--- 1. What is the difference of monthly average payment for Data Analyst between USA and Canada? 

SELECT 
     job_title,
	 MAX(CASE WHEN company_location = 'US' THEN avg_month END) - MAX(CASE WHEN company_location = 'CA' THEN avg_month END) as diff
	 FROM (
	       SELECT 
				job_title, company_location, ROUND((AVG(salary_in_usd)/12), 0) as avg_month
				FROM salary
				WHERE company_location IN ('CA', 'US') 
				AND job_title = 'Data Analyst'
				GROUP BY job_title, company_location) sbq
				WHERE company_location IN ('US', 'CA')
				GROUP BY job_title

--- 2. What is it the percentage difference in salary for Data Analyst between the largest and the lowest payment in the world?


SELECT
	ROUND(((sbq1.salary_in_usd - sbq2.salary_in_usd) / sbq2.salary_in_usd) * 100, 0) AS percent_difference
	FROM (
		SELECT TOP 1 salary_in_usd
		FROM salary
		WHERE job_title = 'Data Analyst'
		ORDER BY salary_in_usd DESC
		) sbq1
JOIN (
		SELECT TOP 1 salary_in_usd
		FROM salary
		WHERE job_title = 'Data Analyst'
		ORDER BY salary_in_usd ASC
		) sbq2
ON 1 = 1

--- 3. How many persons work remotely compared to persons who work stationary?

SELECT
COUNT(CASE WHEN remote_ratio = 100 THEN 0 END) as number_remote_work,
COUNT(CASE WHEN remote_ratio = 0 THEN 0 END) as number_stationary_work
FROM salary

--- Analyse according to experience

--- 1. What is the highest and the lowest salary for Data Analyst in the world for SE (Senior level)?

SELECT
	MAX(CASE WHEN experience_level = 'SE' THEN salary_in_usd END) as the_highest_salary_SE,
	MIN(CASE WHEN experience_level = 'SE' THEN salary_in_usd END) as the_lowest_salary_SE
	FROM salary
	WHERE job_title = 'Data Analyst'

--- 2. What is average salary for Expert Data Analyst per year?

SELECT ROUND(AVG(salary_in_usd),0) as avg_salary
FROM salary
WHERE experience_level = 'EX'

--- Analyse according to employment type

--- 1. What is the average salary for full-time workers compared to part-time workers for a Data Analyst position?

SELECT
	ROUND(AVG(CASE WHEN employment_type = 'FT' THEN salary_in_usd END), 0) as avg_salary_FT,
	ROUND(AVG(CASE WHEN employment_type = 'PT' THEN salary_in_usd END), 0) as avg_salary_PT
	FROM salary
	WHERE job_title = 'Data Analyst'

--- 2. What is the percentage difference in the highest salaries for Data Analyst working full time and part time?

SELECT 
		ROUND(((salary_ft - salary_pt) / salary_pt) * 100, 0)  as percentage_difference
FROM (
		SELECT
		MAX(CASE WHEN employment_type = 'FT' THEN salary_in_usd END) as salary_ft,
		MAX(CASE WHEN employment_type = 'PT' THEN salary_in_usd END) as salary_pt
		FROM salary
		WHERE job_title = 'Data Analyst') sbq

--- Trends in time

--- 1. By what percentage has the average salary for Data Analyst changed from 2021 to 2023?

SELECT 
		ROUND(((avg2023 - avg2021) / avg2021) * 100, 0) as percentagee
FROM (
		SELECT AVG(salary_in_usd) as avg2023
		FROM salary
		WHERE job_title = 'Data Analyst' AND work_year = 2023 
		) sbq1
JOIN (
		SELECT AVG(salary_in_usd) as avg2021
		FROM salary
		WHERE job_title = 'Data Analyst' AND work_year = 2021 
		) sbq2
		ON 1 = 1

--- 2. How has the ratio of remote to on-site employees changed over the last three years?

SELECT work_year, 
       SUM(CASE WHEN remote_ratio = 100 THEN 1 ELSE 0 END) AS remote_employees,
       SUM(CASE WHEN remote_ratio = 0 THEN 1 ELSE 0 END) AS on_site_employees,
       SUM(CASE WHEN remote_ratio = 100 THEN 1 ELSE 0 END) * 1.0 / SUM(CASE WHEN remote_ratio = 0 THEN 1 ELSE 0 END) AS remote_to_on_site_ratio
FROM salary
WHERE work_year BETWEEN YEAR(GETDATE()) - 2 AND YEAR(GETDATE()) 
GROUP BY work_year
ORDER BY work_year