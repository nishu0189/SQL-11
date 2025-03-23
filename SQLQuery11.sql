
--in aggregation order by is not mandatory 

---------------------------------------------------AGGREGATION IN WINDOW FUNCTION ---------------------------------------------------------------------


select * from emp

select e_id, dept_id, salary,
avg(salary) over(partition by dept_id) as avg_salary ,
max(salary) over(partition by dept_id) as max_salary,
count(e_id) over(partition by dept_id) as EmpInEachDept
from emp;

------------------------------------------------ --Sum of salary is same in each dept---------------------------------------------------------------
select * ,
sum(Salary) over (partition by dept_id) as totalSum 
from emp;

------------------------------------------------1. RUNNING SALARY------------------------------------------------------------------ -----
select * ,
sum(Salary) over (partition by dept_id order by age) as sumOfSalary1after1  --sum of salary of curr row is  curr_salary + nxt_salary
from emp;

-----------------------------------------------------------------------------------------------------------------------------------------------------
select * ,
sum(Salary) over (partition by dept_id) as totalSum ,          --Sum of salary is same in each dept
sum(Salary) over (partition by dept_id order by age) as sumOfSalary1after1  --sum of salary of curr row is  curr_salary + nxt_salary
from emp;


-----------------------------------------------------------------------------------------------------------------------------------------------------

select *,
max(salary) over (partition by dept_id ) as m1,
max(salary) over (partition by dept_id order by e_id asc ) as m2,
max(salary) over (partition by dept_id order by e_id desc) as m3
from emp;

-----------------------------------------------------------------------------------------------------------------------------------------------------
select name,dept_id,salary,
max(salary) over (order by salary asc) as desc_m1 -- salary in asc order
from emp;



select name,dept_id,salary,
max(salary) over (order by salary asc) as desc_m1, -- salary in asc order
max(salary) over (order by salary desc) as _m2 -- highest salary to all
from emp;

------------------------------------------------------------2. DUPLICATE VALUE----------------------------------------------------------------------------------
--duplicate value of salary assign the same aggregated sum value 
select dept_id,salary ,
sum(Salary) over (order by salary) as duplicate,
sum(Salary) over (order by salary,e_id) as RESOLVE1, -- duplication resolve by taking the unique value with order by salary 
sum(Salary) over (order by salary rows between unbounded preceding and current row) as RESOLVE2 --unbounded -> sums all salaries from the first row up to the current row.
from emp;

-------sum of salary of curr row is sum of previous + curr_salary -------------------------------------------------------------
--(but sum2 is each through out the dept_id bcz if the diff row having same dept_id and man_id give the same sum
select * ,    
sum(Salary) over (partition by dept_id order by manager_id) as sum2 
from emp;

-----------------------------------------------------------------------------------------------------------------------------------------------------
Select * ,
count(*) over (partition by dept_id order by e_id)
from emp

----------------------------------------------------------3. ROLLING SUM-------------------------------------------------------------------------------------------
--sum of previous 2 row and curr row  salary  
Select e_id, salary,
sum(salary) over (order by e_id) as RUNNING , -- RUNNING SUM
sum(salary) over (order by e_id rows between 2 preceding and current row ) as ROLLING  -- ROLLING SUM  (sum of previous 2 and curr salary)
from emp;

---------------------------------------------------------2 PREVIOUS ROW + 1 CURR ROW--------------------------------------------------------------------------------------------
Select e_id, salary,
sum(salary) over (order by e_id rows between 1 preceding and current row ) as running1 ,--sum of previous 1  and curr one  salary 
sum(salary) over (order by e_id rows between 2 preceding and current row ) as running2  --sum of previous 2 row and curr row  salary 
from emp;

--------------------------------------------------------1 PREVIOUS ROW + 1 CURR ROW + 1 NEXT ROW------------------------------------------------------------------------------------------
Select e_id, salary,
sum(salary) over (order by e_id rows between 1 preceding and 1 following) as following
from emp;

--------------------------------------------------------- 2 following and 4 following--------------------------------------------------------------------------------------------

-- row falls between 2rd after the curr row and 4rd after the curr
--1. for e_id 1:- id2 to id4 = 60000+55000+ 75000=  190000
--2. for e_id 2:- id4 to id6 = 75000 + 52000 +61000=  188000

Select e_id, salary,
sum(salary) over (order by e_id rows between 2 following and 4 following) as following
from emp;
----------------------------------------------------------------PARTITION AND PRECEDING N FOLLOWING-------------------------------------------------------------------------------------
Select e_id, dept_id,salary,
sum(salary) over (partition by dept_id order by e_id rows between 1 preceding and 1 following )
from emp;
------------------------------------------------------UNBOUNDED (all the previous row than curr row)-------------------------------------------------------------------------------------------
--sum1 == sum2
--UNBOUNDED mean no boundation in row . it take all the row
Select e_id, dept_id,salary,
sum(salary) over (order by e_id ) as sum1,
sum(salary) over (order by e_id rows between unbounded preceding and  current row) as sum2, --UNBOUNDED PRECEDING
sum(salary) over (order by e_id rows between unbounded preceding and  UNBOUNDED FOLLOWING) as sum3 --UNBOUNDED PRECEDING N FOLLOWING
from emp;


------------------------------------------------------FIRST_VALUE N LAST_VALUE-----------------------------------------------------------------------------------------------

--LAST_VALUE :- is not work as our expectation as it should give the last(75000) value to all the row
--this is bcz it only look the previous n curr row XXXXX

--FIRST_VALUE:- it work but it not look for whole table , this also look the previous n curr row

--RESOLVE :- resolve by the following and unbounded

--ANOTHER WAY OF GETTING LAST VALUE:- FIRST_VALUE with desc order by 

Select e_id,salary,
FIRST_VALUE(salary) over (order by salary)  as FIRST_salary, -- give the first salary to all row
LAST_VALUE(salary)  over (order by salary)  as LAST_salary, -- PROMBLE
LAST_VALUE(salary)  over (order by salary rows between CURRENT ROW and unbounded following) as RESOLVE1 , --RESOLVE
LAST_VALUE(salary)  over (order by salary rows between unbounded preceding and  CURRENT ROW ) as RESOLVE1 , --RESOLVE

FIRST_VALUE(salary) over (order by salary desc)  as RESOLVE2
from emp;

-----------------------------------------------------------------------------------------------------------------------------------------------------
--rolling 3 month sale

select * from orders

with cte1 as(
select datepart(year,or_date) as  year_or , datepart(month, or_date) as month_or, 
sum(sales) as total_Sale
from orders
group by datepart(year,or_date) , datepart(month,or_date) 
) --order by year_or, month_or;

select *,
sum(total_Sale) over (order by year_or, month_or rows between  2 preceding  and current row) as rolling_3_mnth_sale
from cte1;


-----------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------------------------------------