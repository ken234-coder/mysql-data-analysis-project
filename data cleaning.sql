SELECT *
FROM employee_demographics;

SELECT first_name, 
last_name, 
birth_date,
age,
(age+10)*10+10
FROM employee_demographics;

#PEMDAS
SELECT DISTINCT first_name, gender
FROM employee_demographics;

# WHERE CLAUSE

SELECT *
FROM employee_salary
WHERE first_name='leslie';

SELECT *
FROM employee_salary
WHERE salary<=50000;

SELECT *
FROM employee_demographics
WHERE gender!='Female';


# AND OR NOT-- logical operators

SELECT *
FROM employee_demographics
WHERE birth_date>'1985-01-01'
OR NOT gender='Male';

SELECT *
FROM employee_demographics
WHERE (first_name='leslie' AND age=44) OR age>55;

#like statement
-- % AND _
SELECT *
FROM employee_demographics
WHERE first_name LIKE '%er%'; 

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a%'; 

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a__'; 

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a___'; 

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a___%'; 

SELECT *
FROM employee_demographics
WHERE birth_date LIKE '1989%'; 

-- GROUP BY

SELECT  gender , AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;



SELECT  occupation, salary
FROM employee_salary
GROUP BY occupation;

-- ORDER BY 

SELECT *
FROM employee_demographics
ORDER BY gender,  age;

-- having and where

SELECT  gender , AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age)>40;

SELECT  occupation , AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary)>75000;

-- LIMIT & Aliasing

SELECT  *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2,1;

-- Aliasing 


SELECT  gender , AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING AVG(age)>40;

-- JOINS


SELECT *
FROM employee_demographics
INNER JOIN employee_salary
	ON employee_demographics.employee_id=employee_salary.employee_id;
    
-- JOINING MULTIPLE TABLES

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id=sal.employee_id
INNER JOIN parks_departments pd
	ON sal.dept_id=pd.department_id;
    
SELECT*
FROM parks_departments;

-- unions

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;

-- USE CASE

SELECT first_name, last_name, 'old man' AS Label
FROM employee_demographics
WHERE age>40 AND gender='Male'
UNION
SELECT first_name, last_name, 'old lady' AS Label
FROM employee_demographics
WHERE age>40 AND gender='Female'
UNION
SELECT first_name, last_name, 'Highly paid Employee' AS Label
FROM employee_salary
WHERE salary>70000
ORDER BY first_name, last_name;

-- string functions

SELECT LENGTH('skyfall');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT LTRIM('        SKY        ')
ORDER BY 2;

SELECT UPPER ('sky');

SELECT first_name, 
LEFT(first_name,4),
RIGHT(first_name,4),
SUBSTRING(first_name,3,2),
birth_date,
SUBSTRING(birth_date,6,2) AS birth_month
FROM employee_demographics;

-- REPLACE

SELECT first_name, REPLACE(first_name,'a','z')
FROM employee_demographics;

-- locate

SELECT LOCATE('x','Alexander');

SELECT first_name, LOCATE('An',first_name)
FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name, ' ',last_name) AS full_name
FROM employee_demographics;

-- case statements

SELECT first_name, last_name, age,
CASE
	WHEN age<=30 THEN 'Young'
    WHEN age BETWEEN 31 and 50 THEN 'old'
    WHEN age>=50 THEN "on Death's Door"
END AS Age_Bracket
FROM employee_demographics;

-- PAY INCREASE AND BONUS
-- <50000= 5%
-- >50000= 7%
-- Finance= 10% bonus

SELECT first_name, last_name,salary,
CASE
	WHEN salary < 50000 THEN salary*1.05
    WHEN salary > 50000 THEN salary*1.07
END AS New_salary,
CASE
	WHEN dept_id=6 THEN salary*.10
END AS Bonus
FROM employee_salary;

SELECT *
FROM employee_salary;

SELECT *
FROM parks_departments;

SELECT *
FROM employee_salary;

-- subquery

SELECT *
FROM employee_demographics
WHERE employee_id IN( SELECT employee_id
					FROM employee_salary
                    WHERE dept_id=1);
                    
SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary;

SELECT  gender, AVG(age), max(age), min(age), count(age)
FROM employee_demographics
GROUP BY gender;

select gender, AVG(`max(age)`)
FROM
(SELECT gender, AVG(age), max(age),min(age), count(age)
FROM employee_demographics
GROUP BY gender) AS Agg_table
GROUP BY gender;

-- WINDOW FUNCTIONS

SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id
GROUP BY gender;


SELECT dem.first_name, dem.last_name, gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id
GROUP BY dem.first_name, dem.last_name, gender;

SELECT dem.first_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id

SELECT dem.first_name, dem.last_name, gender, salary,
ROW NUMBER() OVER()
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id;

SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(partition by gender ORDER BY salary DESC),
RANK() OVER(partition by gender ORDER BY salary DESC) rank_num,
DENSE_RANK () OVER(partition by gender ORDER BY salary DESC) dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id;
    
-- CTES (COMMON TABLES EXPRESSION)

WITH CTE_Example AS 
(
SELECT gender, AVG(salary) avg_sal,MAX(salary) max_sal,MIN(salary)min_sal,COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example
;

-- temporary tables
CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary;

SELECT *
FROM salary_over_50k;

-- stored procedures

CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary>=50000;

CALL large_salaries();

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary>=50000;
	SELECT *
	FROM employee_salary
	WHERE salary>=10000;
END $$

CALL large_salaries2();

-- parameter


DELIMITER $$
CREATE PROCEDURE large_salaries3(employee_id INT)
BEGIN
	SELECT *
	FROM employee_salary
	WHERE employee_id=employee_id;
END $$

CALL large_salaries3(1);


-- TRIGGERS AND EVENTS

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name,last_name)
    VALUES (NEW.employee_id,NEW.first_name,NEW.last_name);
END$$

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES ( 13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);

-- EVENTS

SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees2
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	SELECT *
    FROM employee_demographics
    WHERE AGE>=60;
END$$

SHOW VARIABLES LIKE 'event%';

-- data cleaning

SELECT *
FROM layoffs;

-- 1. remove duplicates
-- 2. stardadize the data
-- 3. null values or blank values
-- 4. remove any columns

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, industry, percentage_laid_off, total_laid_off, `date`) AS row_num
FROM layoffs_staging;

SELECT COUNT(*) AS total_rows
FROM layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

SELECT COUNT(*) AS total_rows
FROM layoffs_staging;

SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, industry, percentage_laid_off, total_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, percentage_laid_off, total_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, percentage_laid_off, total_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num>1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;
