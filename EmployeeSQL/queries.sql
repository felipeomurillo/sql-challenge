-- Author: F. Murillo
-- Date: May 25, 2019
-- Title: SQL-Challenge: Employee Database (Pewlett Hackard) PART I
-- Description: Each section header describes the desired SQL query to be performed
-- 


-----
-- #1: List employee number, last name, first name, gender, and salary
-----
SELECT e.emp_no as "Employee #", 
	   e.last_name as "Last Name",
	   e.first_name as "First Name",
	   e.gender as "Gender",
	   s.salary as "Salary"
FROM employees as e
JOIN salaries as s
ON e.emp_no = s.emp_no
ORDER BY e.emp_no ASC;


-----
-- #2: List employees who were hired in 1986
-----
SELECT emp_no as "Employee #", 
	   last_name as "Last Name",
	   first_name as "First Name",
	   hire_date as "Hiring Date"
FROM employees
WHERE hire_date LIKE '1986-%'
-- Order by hiring date, then by employee #
ORDER BY hire_date, emp_no ASC;

-----
-- #3a: List HISTORICAL managers of each department with the following information: 
-- department number, department name, the manager's employee number, 
-- last name, first name, and start and end employment dates
-- *Assumption: end employment date is last date in dept_emp for a particular employee
-----
SELECT dm.dept_no as "Dept. #",
	   dept.dept_name as "Dept. Name",
	   dm.emp_no as "Employee #",
	   e.last_name as "Last Name",
	   e.first_name as "First Name",
	   e.hire_date as "Hiring Date",
	   j.latest_date as "End of Employment"
FROM dept_manager as dm
JOIN departments as dept
ON dm.dept_no = dept.dept_no
JOIN employees as e
ON dm.emp_no = e.emp_no
-- Grab the latest date listed in dept_emp table for each employee
INNER JOIN (
	SELECT emp_no, max(to_date) as latest_date
	FROM dept_emp as de
	GROUP BY emp_no) as j
	ON j.emp_no = dm.emp_no
ORDER BY dm.dept_no ASC;

-----
-- #3b: List the CURRENT manager of each department with the following information: 
-- department number, department name, the manager's employee number, 
-- last name, first name, and start and end employment dates
-----
SELECT dm.dept_no as "Dept. #",
	   dept.dept_name as "Dept. Name",
	   dm.emp_no as "Mng Employee #",
	   e.last_name as "Last Name",
	   e.first_name as "First Name",
	   e.hire_date as "Employment Start Date",
	   dm.to_date as "Employment End Date"
FROM dept_manager as dm
JOIN departments as dept
ON dm.dept_no = dept.dept_no
JOIN employees as e
ON dm.emp_no = e.emp_no
WHERE dm.to_date LIKE '9999%';


-----
-- #4: List the department where each employee was before leaving or where
-- each employee is currently assigned, along with the following information: 
-- employee number, last name, first name, and department name
-----
SELECT de.emp_no as "Employee #",
	   e.last_name as "Last Name",
	   e.first_name as "First Name",
	   d.dept_name as "Dept. Name"
FROM dept_emp as de
-- This section selects the latest department that the employee was in
-- as a function of the latest "to_date" in the dept_emp table
INNER JOIN (
	SELECT emp_no, max(to_date) as latest_date
	FROM dept_emp as de
	GROUP BY emp_no) as j
	ON j.emp_no = de.emp_no AND j.latest_date = de.to_date
-- Join with other tables to gather desired info
JOIN employees as e
ON de.emp_no = e.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
-- Order query by employee number (smallest to greatest)
ORDER BY de.emp_no ASC;


-----
-- #5: List all employees whose first name is "Hercules" and last names begin with "B"
-----
SELECT emp_no as "Employee #",
	   first_name as "First Name",
	   last_name as "Last Name"
FROM employees
WHERE first_name LIKE 'Hercules' AND last_name LIKE 'B%'
-- Order query by last name
ORDER BY last_name ASC;

-----
-- #6a: List all employees CURRENTLY in the Sales department or were last in the
-- Sales department prior to leaving the company: 
-- include their employee number, last name, first name, and department name.
-----
SELECT de.emp_no as "Employee #",
	   e.last_name as "Last Name",
	   e.first_name as "First Name",
	   d.dept_name as "Dept. Name"
FROM dept_emp as de
-- This section selects the latest department that the employee was in
-- as a function of the latest "to_date" in the dept_emp table
INNER JOIN (
	SELECT emp_no, max(to_date) as latest_date
	FROM dept_emp as de
	GROUP BY emp_no) as j
	ON j.emp_no = de.emp_no AND j.latest_date = de.to_date
JOIN employees as e
ON de.emp_no = e.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
ORDER BY de.emp_no ASC;

-----
-- #6b: List all employees CURRENTLY in the Sales department 
-- include their employee number, last name, first name, and department name.
-----
SELECT de.emp_no as "Employee #",
	   e.last_name as "Last Name",
	   e.first_name as "First Name",
	   d.dept_name as "Dept. Name"
FROM dept_emp as de
-- This section selects the latest department that the employee was in
-- as a function of the latest "to_date" in the dept_emp table
INNER JOIN (
	SELECT emp_no, max(to_date) as latest_date
	FROM dept_emp as de
	GROUP BY emp_no) as j
	ON j.emp_no = de.emp_no AND j.latest_date = de.to_date
JOIN employees as e
ON de.emp_no = e.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' AND j.latest_date LIKE '9999-%'
ORDER BY de.emp_no ASC;


-----
-- #7: List all employees CURRENTLY in the Sales and Development departments, 
-- including their employee number, last name, first name, and department name
-----
SELECT de.emp_no as "Employee #",
	   e.last_name as "Last Name",
	   e.first_name as "First Name",
	   d.dept_name as "Dept. Name"
FROM dept_emp as de
-- This section selects the latest department that the employee was in
-- as a function of the latest "to_date" in the dept_emp table
INNER JOIN (
	SELECT emp_no, max(to_date) as latest_date
	FROM dept_emp as de
	GROUP BY emp_no) as j
	ON j.emp_no = de.emp_no AND j.latest_date = de.to_date
JOIN employees as e
ON de.emp_no = e.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development' AND j.latest_date LIKE '9999-%'
ORDER BY de.emp_no ASC;


-----
-- #8: In descending order, list the frequency count of employee last names, 
-- i.e., how many employees share each last name.
-----
SELECT last_name as "Employee Last Name", COUNT(last_name) as "Frequency Count"
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;


-----
-- Epilogue: Who am I? Answer: April Foolsday!
-----
SELECT *
FROM employees
WHERE emp_no = 499942;