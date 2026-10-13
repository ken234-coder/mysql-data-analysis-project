SELECT*
FROM employee_demographics;

SELECT first_name
FROM employee_demographics;

SELECT first_name, last_name, birth_date, age, (age+10)*10
FROM employee_demographics;

#PEMDAS -- PARENTHESIS

SELECT distinct first_name,gender
FROM employee_demographics;