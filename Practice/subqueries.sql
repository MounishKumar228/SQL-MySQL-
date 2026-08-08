/*Employee Table
| emp_id | emp_name | department | salary | manager_id |
| ------ | -------- | ---------- | ------ | ---------- |
| 1      | John     | HR         | 50000  | NULL       |
| 2      | Alice    | IT         | 70000  | 5          |
| 3      | Bob      | IT         | 65000  | 5          |
| 4      | David    | Finance    | 60000  | 6          |
| 5      | Emma     | IT         | 90000  | NULL       |
| 6      | Sophia   | Finance    | 95000  | NULL       |
| 7      | Mike     | HR         | 45000  | 1          |
| 8      | Sara     | Finance    | 75000  | 6          |
| 9      | Tom      | IT         | 70000  | 5          |
| 10     | Chris    | HR         | 55000  | 1          |

Department:
| dept_id | department |
| ------- | ---------- |
| 1       | HR         |
| 2       | IT         |
| 3       | Finance    |
*/
/*
Difficulty Levels
Level 1 — Single Row Subqueries
Salary comparisons
MAX/MIN
Average salary
Department filters

Level 2 — Multi Row Subqueries
IN
ANY
ALL
EXISTS

Level 3 — Correlated Subqueries
Employee earning above department average
Highest salary per department
Duplicate records
Manager queries

Level 4 — Nested Subqueries
Multiple levels
EXISTS + IN
Scalar + Correlated
Derived Tables
*/
-- 1. Find employees who earn more than the average salary of all employees.
/*
What type of subquery is this?
It is a single-row (scalar) subquery because the inner query returns only one value (AVG(salary)).
*/
select emp_name, salary
from Employee
where salary>(select avg(salary) from Employee)
-- Alternative (less efficient)
SELECT emp_name, salary
FROM Employee
HAVING salary > (
    SELECT AVG(salary)
    FROM Employee
);

-- 2. Find the employee(s) who earn the highest salary.
/*
select emp_name, salary
from Employee
where salary = exists(select max(salary) from Employee);

It checks only whether the employees are there i.e. TRUE or FALSE 
*/
select emp_name, salary
from Employee
where salary in(select  max(salary)from Employee);

-- Write a query to find employees who earn the highest salary in their department. 
SELECT emp_name, dept_id, salary
FROM Employee e1
WHERE salary = (
    SELECT MAX(salary)
    FROM Employee e2
    WHERE e1.dept_id = e2.dept_id
);

SELECT d.dept_id, d.department
FROM Department d
WHERE EXISTS (
    SELECT 1
    FROM Employees e
    WHERE e.dept_id = d.dept_id
      AND e.salary > 70000
);
/*
This is why it's called a scalar subquery—the inner query returns one value, and the outer query compares against that value
*/
SELECT emp_name, salary
FROM Employee
WHERE salary > (
    SELECT salary
    FROM Employee
    WHERE emp_name = 'John'
);
/*
-- If multiple employee exists with same name ex: John
SELECT emp_name, salary
FROM Employee
WHERE salary > ANY (
    SELECT salary
    FROM Employee
    WHERE emp_name = 'John'
);

SELECT emp_name, salary
FROM Employee
WHERE salary > ALL (
    SELECT salary
    FROM Employee
    WHERE emp_name = 'John'
);
*/
SELECT emp_name, salary
FROM Employee
WHERE salary < ANY (
    SELECT salary
    FROM Employee
    WHERE emp_name = 'Emma'
);
/*
| Situation                           | Preferred Operator            |
| ----------------------------------- | ----------------------------- |
| Subquery returns exactly one value  | `=` `>` `<` with `(subquery)` |
| Subquery may return multiple values | `IN`, `ANY`, `ALL`, `EXISTS`  |
*/
-- Aggregate value in subquery
SELECT emp_name, salary
FROM Employee
WHERE salary = (
    SELECT AVG(salary)
    FROM Employee
    WHERE department = 'IT'
);
/*
Many candidates incorrectly expect:
	-Alice (70000)
	-Tom (70000)
But the question is equal to the average, not greater than or closest to the average.
Always read the requirement carefully.
*/
/*
A scalar subquery can return:
	-MAX()
	-MIN()
	-AVG()
	-COUNT()
A single column value
The outer query compares against that single value.
*/
SELECT emp_name, salary
FROM Employee
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
    WHERE department = 'HR'
);
/*
Notice that John (salary = 50,000) is not included because the condition is:
salary > AVG(...)
not
salary >= AVG(...)
Interviewers often test whether you pay attention to operators like >, >=, <, and <=.
*/
SELECT emp_name, salary
FROM Employee
WHERE salary < (
    SELECT AVG(salary)
    FROM Employee
    WHERE department = 'Finance'
);
SELECT emp_name, salary
FROM Employee
WHERE salary = (
    SELECT MIN(salary)
    FROM Employee
    WHERE department = 'HR'
);
/*
When using aggregates:
MIN() → returns one value
MAX() → returns one value
AVG() → returns one value
COUNT() → returns one value
So always compare them using operators like:
=, >, <, >=, <=, >
Don't use IN or ANY unless the subquery can return multiple rows.
*/
SELECT emp_name, salary
FROM Employee
WHERE salary = (
    SELECT MAX(salary)
    FROM Employee
    WHERE department = 'IT'
);
SELECT emp_name, salary
FROM Employee
WHERE salary BETWEEN (
    SELECT MIN(salary)
    FROM Employee
    WHERE department = 'IT'
)
AND (
    SELECT MAX(salary)
    FROM Employee
    WHERE department = 'IT'
);
/*
BETWEEN uses >= and <= not > and <
*/
SELECT emp_name, salary
FROM Employee
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
)
AND salary < (
    SELECT MAX(salary)
    FROM Employee
    WHERE department = 'Finance'
);
SELECT emp_name, salary
FROM Employee
WHERE salary = (
    SELECT MIN(salary)
    FROM Employee
);
SELECT emp_name
FROM salary
WHERE COUNT(*) > (
    SELECT COUNT(*)
    FROM employee
    WHERE COUNT(*) > 8
); -- WRONG
/*
COUNT(*) cannot be placed directly in the WHERE clause.
SELECT emp_name
FROM Employee
WHERE (
    SELECT COUNT(*)
    FROM Employee
) > 8;
*/
SELECT emp_name, salary
FROM Employee
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
)
AND salary < (
    SELECT MAX(salary)
    FROM Employee
);

/*
in the place of subquery we can use avg(salary)
*/
SELECT emp_name
FROM Employee
WHERE (
    SELECT COUNT(*)
    FROM Employee
    WHERE department = 'IT'
) >= 3;
SELECT emp_name, salary
FROM Employee
WHERE salary != (
    SELECT AVG(salary)
    FROM Employee
);
SELECT emp_name, salary
FROM Employee
WHERE salary > (
    SELECT MIN(salary)
    FROM Employee
)
AND salary < (
    SELECT MAX(salary)
    FROM Employee
)
AND salary <> (
    SELECT AVG(salary)
    FROM Employee
);
SELECT emp_name, salary
FROM Employee
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
    WHERE department = 'HR'
)
AND salary < (
    SELECT AVG(salary)
    FROM Employee
    WHERE department = 'Finance'
);
/*
1. Aggregate functions cannot be used directly in the WHERE clause.
2. BETWEEN is inclusive.
3. Use ANY and ALL only when the subquery can return multiple rows.
*/
/*
| Subquery Returns    | Use                                   |
| ------------------- | ------------------------------------- |
| One value           | `=`, `>`, `<`, `>=`, `<=`, `<>`, `!=` |
| Multiple values     | `IN`, `NOT IN`, `ANY`, `SOME`, `ALL`  |
| Check row existence | `EXISTS`, `NOT EXISTS`                |

| Function  | Returns   |
| --------- | --------- |
| `MAX()`   | One value |
| `MIN()`   | One value |
| `AVG()`   | One value |
| `SUM()`   | One value |
| `COUNT()` | One value |
*/
-- =================================
-- Level 2 – Multi-row Subqueries
-- =================================
SELECT emp_name, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    WHERE emp_name = 'Alice'
);
/*
| emp_name | department |
| -------- | ---------- |
| Alice    | IT         |
| Alice    | HR         |
with the same name ALICE there could multiple employees so it is not certain it returns exactly one row. so we use IN 
*/
SELECT emp_name, department
FROM Employee
WHERE department ANY (
    SELECT department
    FROM Employee
    WHERE salary > 80000
); -- WRONG
/*
ANY must always be used with a comparison operator.
salary > ANY (...)
salary = ANY (...)
salary < ANY (...)
SELECT emp_name, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    WHERE salary > 80000
);
*/
/*When do we use ANY?
ANY is for comparing values, not checking membership.
salary > ANY (
    SELECT salary
    FROM Employee
    WHERE department = 'HR'
);
salary = ANY (
    SELECT salary
    FROM Employee
    WHERE department = 'IT'
);
*/
/*Quick Rule
| Requirement                              | Operator |
| ---------------------------------------- | -------- |
| Check if a value exists in a list        | `IN`     |
| Compare with at least one returned value | `ANY`    |
| Compare with every returned value        | `ALL`    |
| Check whether rows exist                 | `EXISTS` |
*/
SELECT emp_name, salary
FROM Employee
WHERE salary > ANY (
    SELECT salary
    FROM Employee
    WHERE department = 'HR'
);
/*
Which is easier to understand?
These two queries are logically equivalent:
WHERE salary > ANY (
    SELECT salary
    FROM Employee
    WHERE department = 'HR'
);
WHERE salary > (
    SELECT MIN(salary)
    FROM Employee
    WHERE department = 'HR'
);
The second is often easier to read, but interviewers may ask for ANY specifically to test your understanding.
*/
/*
| Operator | Equivalent | Memory Trick           |
| -------- | ---------- | ---------------------- |
| `> ANY`  | `> MIN()`  | At least one match     |
| `< ANY`  | `< MAX()`  | At least one match     |
| `> ALL`  | `> MAX()`  | Must beat everyone     |
| `< ALL`  | `< MIN()`  | Must be below everyone |
*/
SELECT emp_name, salary
FROM Employee
WHERE salary > ALL (
    SELECT salary
    FROM Employee
    WHERE department = 'HR'
);
-- or
SELECT emp_name, salary
FROM employee
WHERE salary<(
	SELECT MAX(SALARY)
    FROM Employee
    WHERE department = 'HR'
);
-- ========================================================================================
SELECT emp_name, salary, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING AVG(salary) > 70000
);
-- =========================================================================================

-- ===========================
-- column IN (subquery)
-- "What column is my outer query comparing?"
-- ===========================

SELECT emp_name, salary, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    WHERE salary > 60000
    GROUP BY department
    HAVING COUNT(*) >= 2
);

SELECT emp_name, salary, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING COUNT(*) = 3
);

SELECT emp_name, salary, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING AVG(salary) BETWEEN 60000 AND 80000
);

SELECT emp_name, salary, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING MIN(salary) > 45000
);
SELECT emp_name, salary, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING MAX(salary) BETWEEN 80000 AND 100000
);
SELECT emp_name, salary, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING COUNT(*) > (
        SELECT AVG(emp_count)
        FROM (
            SELECT COUNT(*) AS emp_count
            FROM Employee
            GROUP BY department
        ) AS dept_counts
    )
);
SELECT emp_name, salary, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING MAX(salary) > (
        SELECT AVG(salary)
        FROM Employee
    )
);
SELECT emp_name, department, salary
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING MIN(salary) < (
        SELECT AVG(salary)
        FROM Employee
    )
);
SELECT emp_name, department, salary
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING AVG(salary) > (
        SELECT AVG(salary)
        FROM Employee
        WHERE department = 'HR'
    )
);
SELECT emp_name, department, salary
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING
        SUM(CASE
                WHEN salary > 60000 THEN 1
                ELSE 0
            END) >= COUNT(*) / 2.0
);
SELECT emp_name, department
FROM Employee
WHERE department IN (
    SELECT department
    FROM Employee
    GROUP BY department
    HAVING SUM(
                CASE
                    WHEN salary > 60000 THEN 1
                    ELSE 0
                END
              ) >= 2
);
SELECT emp_name, salary
FROM employee e1
WHERE N - 1 = (
    SELECT COUNT(DISTINCT e2.salary)
    FROM employee e2
    WHERE e2.salary > e1.salary
);
/* ========================================================
Replace N with:

1 → Highest salary
2 → 2nd highest
3 → 3rd highest
10 → 10th highest
*/ =========================================================
SELECT emp_name, salary, department
FROM Employee e1
WHERE salary = (
    SELECT MAX(e2.salary)
    FROM Employee e2
    WHERE e2.department = e1.department
);

SELECT emp_name, salary, department
FROM Employee e1
WHERE salary = (
    SELECT MIN(e2.salary)
    FROM Employee e2
    WHERE e2.department = e1.department
);

SELECT emp_name, salary
FROM Employee e1
WHERE EXISTS (
    SELECT 1
    FROM Employee e2
    WHERE e2.salary = e1.salary
      AND e2.emp_id <> e1.emp_id
);

SELECT emp_name, salary
FROM Employee e1
WHERE salary > ALL (
    SELECT e2.salary
    FROM Employee e2
    WHERE e2.department = e1.department
      AND e2.emp_id <> e1.emp_id
);

SELECT emp_name, salary
FROM Employee e1
WHERE EXISTS (
    SELECT salary
    FROM Employee e2
    WHERE e2.department = e1.department
      AND e2.salary < e1.salary
      AND e2.emp_id <> e1.emp_id
);

SELECT emp_name, salary
FROM Employee e1
WHERE NOT EXISTS (
    SELECT 1
    FROM Employee e2
    WHERE e2.department = e1.department
      AND e2.salary > e1.salary
      AND e2.emp_id <> e1.emp_id
);

SELECT emp_name, salary, department
FROM Employee e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.department = e1.department
)
AND EXISTS (
    SELECT 1
    FROM Employee e3
    WHERE e3.department = e1.department
      AND e3.emp_id <> e1.emp_id
);

SELECT emp_name, salary
FROM Employee e1
WHERE salary < (
    SELECT salary
    FROM Employee e2
    WHERE e2.emp_id = e1.manager_id
);

SELECT emp_name, salary
FROM Employee e1
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM Employee e2
    WHERE e2.manager_id = e1.manager_id
);

SELECT emp_name, salary
FROM Employee e1
WHERE salary > ALL (
    SELECT salary
    FROM Employee e2
    WHERE e2.department = e1.department
      AND e2.emp_id < e1.emp_id
);

SELECT emp_name, salary
FROM Employee e1
WHERE EXISTS (
    SELECT 1
    FROM Employee e2
    WHERE e2.department = e1.department
      AND e2.salary = e1.salary + 10000
);

SELECT emp_name, salary
FROM Employee e1
WHERE NOT EXISTS (
    SELECT 1
    FROM Employee e2
    WHERE e2.department = e1.department
      AND e2.salary = e1.salary
      AND e2.emp_id <> e1.emp_id
);

