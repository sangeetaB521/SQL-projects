select * from employees;
use employees;
select * from employees;
CREATE TABLE department_dups (
    dept_no VARCHAR(20),
    dept_name CHAR(40) null
);
insert into department_dups (dept_no, dept_name)
select * from departments;
insert into department_dups(dept_name)
values ("Public Relations");
insert into department_dups 
values ("d110","Human resources");
delete from department_dups where dept_no="d002";
alter table department_dups modify dept_no varchar(4) null;
update department_dups set dept_no="d01" where dept_name= "Public relations";
delete from department_dups where dept_name="Public relations";
create table Department_manager_dups( emp_no int(10) not null, dept_no varchar(4), from_date date, to_date date);
insert into department_manager_dups(emp_no, dept_no, from_date, to_date) select * from dept_manager;
insert into department_manager_dups(emp_no,from_date) values  (999904, '2017-01-01'),

                                (999905, '2017-01-01'),

                               (999906, '2017-01-01'),

                               (999907, '2017-01-01');
SELECT 
    e.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
FROM
    employees e
        LEFT JOIN
    dept_manager d ON e.emp_no = d.emp_no
WHERE
    e.last_name = 'Markovitch'
ORDER BY d.dept_no DESC , e.emp_no;
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');
select e.emp_no, e.first_name,e.last_name,e.hire_date,t.title
from employees e
join titles t on e.emp_no=t.emp_no where e.first_name="Margareta" && e.last_name="Markovitch"; 
select dm.*, d.*
from dept_manager dm
cross join departments d
where d.dept_no="d009"
order by dm.emp_no;
select e.*,d.*
from employees e
cross join departments d where e.emp_no<10011 order by e.emp_no;
select dm.*,d.*
from dept_manager dm
cross join departments d where d.dept_no="d006"
order by dm.emp_no;
use employees;
select e.first_name, e.last_name, e.hire_date, dm.from_date, d.dept_name
from employees e 
join dept_manager dm on e.emp_no=dm.emp_no
join departments d on d.dept_no=dm.dept_no;
SELECT 
    e.gender, count(dm.emp_no)
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;
select * from (
select e.emp_no, e.first_name, e.last_name, NULL AS dept_no, NULL AS from_date
from employees e 
where last_name = 'denis' 
UNION ALL 
select NULL AS emp_no, NULL AS first_name, NULL AS last_name, dm.dept_no, dm.from_date
from dept_manager dm) as a
order by -a.emp_no desc;
use employees;
select * from dept_manager where emp_no IN (SELECT emp_no from employees where hire_date between '1990-01-01' and '1995-01-01');
select * from employees e where exists (select * from titles t where t.emp_no=e.emp_no AND title="Assistant Engineer");
DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (

   emp_no INT(11) NOT NULL,

   dept_no CHAR(4) NULL,

   manager_no INT(11) NOT NULL

);
use employees;
select A.* from 
( select e.emp_no as employee_ID, min(de.dept_no) as department_code, ( select emp_no from dept_manager where emp_no= 110022 ) as manager_ID from employees e
join dept_emp as de on e.emp_no=de.emp_no where emp_no<=10020
group by emp_no
order by emp_no) as A;
select * from dept_manager where emp_no='110022';
use employees;
delimiter $$
drop procedure emp_number_give;
create procedure emp_number_give(IN p_first_name varchar(30), IN p_last_name varchar(30), OUT p_emp_no integer)
begin 
select e.emp_no 
into p_emp_no from employees e 
where e.first_name=p_first_name AND e.last_name=p_last_name;
END$$
delimiter ;
DELIMITER $$

CREATE PROCEDURE emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)

BEGIN

                SELECT

                                e.emp_no

                INTO p_emp_no FROM

                                employees e

                WHERE

                                e.first_name = p_first_name

                                                AND e.last_name = p_last_name;

END$$

DELIMITER ;
delimiter $$
create procedure return_avg_salary1(out p_avg_salary decimal(10,2),IN p_emp_no integer)
BEGIN 
SELECT avg(salary) into p_avg_salary from salaries s where p_emp_no=s.emp_no;
END $$
DELIMITER ;

set @v_emp_no=0;
CALL employees.emp_info('Aruna','Journel',@v_emp_no);
SELECT @v_emp_no;

delimiter $$
create function f_emp_avg_salary(p_emp_no integer) returns decimal(10,2)
deterministicf_emp_avg_salary
begin
declare v_avg_salary decimal(10,2);
select 
avg(s.salary) into v_avg_salary from employees e join salaries s on e.emp_no=s.emp_no;
return v_avg_salary;
end $$
delimiter ;

delimiter $$
create function f_emp_salary(p_first_name varchar(30), p_last_name varchar(30)) returns integer
deterministic
begin
declare v_emp_salary integer;
select s.salary into v_emp_salary from employees e join salaries s on e.emp_no=s.emp_no where e.first_name=p_first_name AND e.last_name=p_last_name;
return v_emp_salary;
end $$
delimiter ;
select emp_no,dept_no,
row_number()over(order by emp_no) as row_num
from dept_manager;
select emp_no,first_name,last_name, 
row_number()over(partition by first_name order by last_name desc)as row_num
from employees;


