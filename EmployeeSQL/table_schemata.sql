-- Author: F. Murillo
-- Date: May 25, 2019
-- Title: SQL Homework - Employee Database (Pewlett Hackard)

-- Part I:
-- List employee number, last name, first name, gender, and salary
SELECT e.emp_no as "Employee #", 
	   e.last_name as "Last Name",
	   e.first_name as "First Name",
	   e.gender as "Gender",
	   s.salary as "Salary"
FROM employees as e
JOIN salaries as s
ON e.emp_no = s.emp_no;