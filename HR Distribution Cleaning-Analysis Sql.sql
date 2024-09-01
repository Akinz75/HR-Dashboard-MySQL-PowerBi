CREATE DATABASE Projects;

USE projects;

-- DATA CLEANING


SELECT * FROM hr;

-- DUPLICATING THE TABLE
CREATE TABLE Hr2
LIKE hr;

INSERT INTO hr2
SELECT *
FROM hr;

SELECT * FROM hr2;

-- STANDIDIZING THE DATA

-- correcting the id column name
ALTER TABLE hr2
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- correcting the date format
SELECT birthdate FROM hr2;

SET SQL_SAFE_UPDATES = 0;

UPDATE hr2
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
	WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr2
MODIFY COLUMN birthdate DATE;

UPDATE hr2
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
	WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr2
MODIFY COLUMN hire_date DATE;

UPDATE hr2
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate !='';

SET SQL_MODE = 'ALLOW_INVALID_DATES';

UPDATE hr2
SET termdate = NULL
WHERE termdate = '';

ALTER TABLE hr2
MODIFY COLUMN termdate DATE;

describe hr2;

-- FINDING OUTLIERS
ALTER TABLE hr2 
ADD COLUMN age INT;

UPDATE hr2
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT 
	MIN(age) AS youngest,
    MAX(age) AS oldest
FROM hr2;

SELECT COUNT(*) 
FROM hr2 
WHERE age < 0;

DELETE 
FROM hr2
WHERE age < 0;

-- CHECKING FOR DUPLICATES

SELECT emp_id, department, COUNT(*)
FROM hr2
GROUP BY emp_id
HAVING COUNT(*) > 1;


SELECT * FROM hr2;


-- EXPLORATORY ANALYSIS

-- BUSINESS QUESTIONS
/*
What is the gender breakdown of employees in the company?
What is the race/ethnicity breakdown of employees in the company?
What is the age distribution of employees in the company?
How many employees work at headquarters versus remote locations?
What is the average length of employment for employees who have been terminated?
How does the gender distribution vary across departments and job titles?
What is the distribution of job titles across the company?
Which department has the highest turnover rate?
What is the distribution of employees across locations by state?
How has the company's employee count changed over time based on hire and term dates?
What is the tenure distribution for each department?
*/


-- 1. What is the gender breakdown of employees in the company?
SELECT gender, count(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, count(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT 
	MIN(age) AS youngest,
    MAX(age) AS oldest
FROM hr2
WHERE age >= 18 AND termdate IS NULL;

SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    count(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group
ORDER BY age_group;

SELECT 
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group, gender,
    count(*) AS count 
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) AS count 
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT
	round(avg(datediff(termdate, hire_date))/365, 0) AS Avg_length_employment
FROM hr2
WHERE termdate <= curdate() AND termdate IS NOT NULL AND age >= 18;


-- 6. How does the gender distribution vary across departments and job titles?
SELECT department, gender, count(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle desc;

-- 8. Which department has the highest turnover rate?
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM(
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr2
    WHERE age >= 18
    GROUP BY department
	) AS subquery
ORDER BY termination_rate desc;

-- 9. What is the distribution of employees across locations by state?
SELECT location_state, count(*) AS count
FROM hr2
WHERE age >= 18 AND termdate IS NULL
GROUP BY location_state
ORDER BY count desc;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT
	year,
    hires,
    terminations,
    hires - terminations AS net_change,
    round((hires - terminations)/hires * 100, 2) AS net_change_percent
FROM(
	SELECT YEAR(hire_date) AS year,
    count(*) AS hires,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
    FROM hr2
    WHERE age >= 18
    GROUP BY year
    ) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT department, round(avg(datediff(termdate, hire_date)/365), 0) AS avg_tenure
FROM hr2
WHERE age >= 18 AND termdate IS NOT NULL AND termdate <= curdate()
GROUP BY department;
