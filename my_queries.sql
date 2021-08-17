-- SELECT DISTINCT removes duplicates from a result set

USE database_sample
SELECT employee_id, first_name + ' ' + last_name, salary, hire_date,
	DATEDIFF(year, hire_date, '2016-01-01') YoS
FROM employees
ORDER BY first_name ASC, hire_date DESC; -- ters sýralama

-- LIMIT OFFSET clause in MSSQL Server
--SELECT * FROM 
--(
--    SELECT TOP #{OFFSET+ROW_COUNT} *, 
--		ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rnum 
--    FROM table
--) table1
--WHERE rnum > OFFSET

USE database_sample
SELECT * FROM 
(
    SELECT TOP 10 *, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rnum 
    FROM employees
) table1
WHERE rnum > 5 -- shows results between 6-10
ORDER BY salary desc

-- OFFSET FETCH clause shows the next results amount of fetch number after offset number

USE database_sample
SELECT employee_id, first_name, last_name,salary
FROM employees ORDER BY salary DESC
OFFSET 2 ROWS FETCH NEXT 4 ROWS ONLY;

-- !!!!!!!!!!! 'WHERE phone_number = NULL' won't work. Must be '... IS NULL'

USE database_sample
SELECT first_name, last_name FROM employees e
WHERE EXISTS( SELECT 1 FROM dependents d
        WHERE d.employee_id = e.employee_id);

-- LIKE expression. '_' stands for 1 char. '%' stands for none or more chars.

USE database_sample
SELECT employee_id, first_name, last_name
FROM employees WHERE first_name LIKE '%are_';

-- JOIN iþlemleri

USE database_sample
SELECT first_name, last_name, job_title, department_name
FROM employees e
INNER JOIN departments d ON d.department_id = e.department_id
INNER JOIN jobs j ON j.job_id = e.job_id
WHERE e.department_id IN (1, 2, 3);

USE database_sample
SELECT c.country_name, c.country_id, l.country_id, l.street_address, l.city
FROM countries c
LEFT JOIN locations l ON l.country_id = c.country_id
WHERE c.country_id IN ('US', 'UK', 'CN');

-- The query below finds the countries which has no record in locations table

USE database_sample
SELECT country_name FROM countries c
LEFT JOIN locations l ON l.country_id = c.country_id
WHERE l.location_id IS NULL
ORDER BY country_name;

SELECT r.region_name, c.country_name, l.street_address, l.city
FROM regions r
LEFT JOIN countries c ON c.region_id = r.region_id
LEFT JOIN locations l ON l.country_id = c.country_id
WHERE c.country_id IN ('US', 'UK', 'CN');

-- SELF JOIN 
-- shows results like employee & manager relationship using the same table

SELECT e.first_name + ' ' + e.last_name AS employee,
	m.first_name + ' ' + m.last_name AS manager
FROM employees e
LEFT JOIN employees m ON m.employee_id = e.manager_id
ORDER BY manager;

-- CROSS JOIN
-- finds the all possible sales channels that a sales organization can have

SELECT sales_org, channel
FROM sales_organization
CROSS JOIN sales_channel;

-- GROUP BY -- search for ROLLUP and CUBE !!

SELECT e.department_id, department_name, COUNT(employee_id) headcount
FROM employees e
INNER JOIN departments d on d.department_id = e.department_id
GROUP BY e.department_id, department_name
HAVING COUNT(employee_id) > 4 -- usage of WHERE in GROUP BY clause
ORDER BY headcount DESC;

SELECT e.department_id, department_name,
    MIN(salary) min_salary, MAX(salary) max_salary,
    ROUND(AVG(salary), 2) average_salary,
	SUM(salary) total_salary
FROM employees e
INNER JOIN departments d ON d.department_id = e.department_id
GROUP BY e.department_id, department_name;

SELECT e.department_id, department_name, e.job_id, job_title, COUNT(employee_id)
FROM employees e
INNER JOIN departments d ON d.department_id = e.department_id
INNER JOIN jobs j ON j.job_id = e.job_id
GROUP BY e.department_id, department_name, e.job_id, job_title;

SELECT e.department_id, department_name, MIN(salary)
FROM employees e
INNER JOIN departments d ON d.department_id = e.department_id
GROUP BY e.department_id, department_name
HAVING MIN(salary) >= 10000
ORDER BY MIN(salary);

SELECT warehouse, product, SUM (quantity) quantity
FROM inventory
GROUP BY warehouse, product;

-- GROUPING SETS

SELECT warehouse, product, SUM (quantity) qty
FROM inventory
GROUP BY GROUPING SETS(
			(warehouse,product),
			(warehouse),
			(product),
			()
		);

-- SUBQUERY

SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees); 

SELECT ROUND(AVG(average_salary), 0)
FROM (SELECT  AVG(salary) average_salary FROM employees
    GROUP BY department_id) department_salary;

SELECT  employee_id, first_name, last_name, salary,
    (SELECT  ROUND(AVG(salary), 0) FROM employees) average_salary,
    salary - (SELECT ROUND(AVG(salary), 0) FROM employees) difference
FROM employees
ORDER BY first_name , last_name;