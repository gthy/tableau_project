use employees_mod;
select * from t_dept_emp;

-- TASK 1
-- Create a visualization that provides a breakdown of males and females working in the company each year, starting from 1990. 

select year(de.from_date) as calender_year , e.gender, count(e.emp_no) as employees_count
from t_employees e
join t_dept_emp de on e.emp_no = de.emp_no

group by calender_year, e.gender
having calender_year >= 1990
order by calender_year;

-- TASK 2
-- Compare the number of male managers to the number of female managers from different departments for each year, starting from 1990.

-- select year(dm.from_date) as calender_year, e.gender, count(dm.emp_no) as manager_count, dm.dept_no, d.dept_name
-- from t_dept_manager dm 
-- join t_employees e on e.emp_no = dm.emp_no
-- join d.t_departments d on dm._no = d.emp
-- group by calender_year, e.gender, dm.dept_no
-- order by calender_year,dm.dept_no;

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
        WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1
        ELSE 0
    END AS active
FROM
    (SELECT 
        YEAR(hire_date) AS calendar_year
    FROM
        t_employees
    GROUP BY calendar_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN 
    t_employees ee ON dm.emp_no = ee.emp_no
ORDER BY dm.emp_no, calendar_year;


-- TASK 3
-- Compare the average salary of female versus male employees in the entire company until year 2002, and add a filter allowing you to see that per each department.


SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2),
    YEAR(s.from_date) AS calander_year
FROM
    t_employees e
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no
        JOIN
    t_salaries s ON s.emp_no = e.emp_no
        JOIN
    t_departments d ON de.dept_no = d.dept_no
GROUP BY e.gender , d.dept_name , calander_year
HAVING calander_year <= 2002;

-- TASK 4
--  obtain the average male and female salary per department within a certain salary range. Let this range be defined by 
--  two values the user can insert when calling the procedure

delimiter $$
create procedure p_task_last (IN start_range float , IN  end_range float)

BEGIN 
SELECT e.gender, avg(s.salary) as avg_salary, d.dept_name
from t_salaries s 
join t_employees e on e.emp_no = s.emp_no
join t_dept_emp de on e.emp_no = de.emp_no
join t_departments d on de.dept_no = d.dept_no
where s.salary BETWEEN start_range and end_range
group by e.gender, d.dept_no;

end $$

delimiter ;













