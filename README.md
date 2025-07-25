# SQL-11

📘 SQL Practice: Advanced Window Functions
This notebook demonstrates advanced usage of SQL Window Functions, with real-world scenarios such as running totals, rolling averages, grouped aggregations, and cumulative statistics. Data is queried from two example tables: emp (employee data) and orders (sales data).

✅ Key Concepts Practiced
🔹 Aggregation Without GROUP BY
Use of AVG(), SUM(), MAX(), COUNT() over partitions (e.g., department-wise)

🔹 Partition By
Group-based aggregations using OVER(PARTITION BY dept_id)

🔹 Running Total (Cumulative Sum)
SUM(salary) OVER (PARTITION BY dept_id ORDER BY age)

Running salary across age within departments

🔹 Duplicate Value Resolution
Using ORDER BY salary, e_id to resolve duplication in cumulative aggregates

🔹 Rolling Aggregates
Rolling salary sums:

sql
Copy
Edit
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
Rolling 3-month sales using CTEs and ROWS BETWEEN

🔹 Row Navigation: Preceding and Following
Use of:

ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING

ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

🔹 First & Last Value Functions
Challenges with LAST_VALUE() and fixes using:

ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING

Or using FIRST_VALUE() with descending order

🔹 Date Handling & CTE
DATEPART() used to extract year and month

CTE (WITH) used for grouping monthly sales before rolling calculation

🗃️ Tables Used
emp: Employee records with fields like e_id, dept_id, salary, age, manager_id

orders: Sales data with fields like or_date, sales

📈 Real-world Usage
Department-level analytics

Running or rolling sales reports

Handling duplicate values in metrics

Creating dashboards or data pipelines with time-based trends

