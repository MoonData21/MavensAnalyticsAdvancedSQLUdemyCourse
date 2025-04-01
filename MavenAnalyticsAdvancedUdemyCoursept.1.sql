-- Connect to database (MySQL)
USE maven_advanced_sql;

-- Joins
select hs.year, hs.country, hs.happiness_score, cs.continent
from happiness_scores hs
	join country_stats cs
    on hs.country = cs.country; 
-- Inner returns records that exist in BOTH tables, and excludes unmatched records from either table (most common)
-- Returns All records from the LEFT table, and any matching records from the RIGHT table (most common)
-- Returns ALL records from the RIGHT table, and any matching from the LEFT table
-- Returns ALL records from BOTH tables, including non-matching records (MySQL does not support support full outer joins).alter

-- Inner Join
select hs.year, js.country, hs.happiness_score, cs.country, cs.continent
from happiness_scores hs
	join country_stars cs
    on hs.country = cs.country;

-- Left Join
select hs.year, js.country, hs.happiness_score, cs.country, cs.continent
from happiness_scores hs
	left join country_stars cs
    on hs.country = cs.country;
    
select distinct hs.country
from happiness_scores hs
	left join country_stars cs
    on hs.country = cs.country;

-- Right Join 
select hs.year, js.country, hs.happiness_score, cs.country, cs.continent
from happiness_scores hs
	right join country_stars cs
    on hs.country = cs.country;
    
select hs.country
from happiness_scores hs
	right join country_stars cs
    on hs.country = cs.country;
    
-- View the orders and product tables
select * from orders;
select * from products;

-- Join the tables using various join types & note the number of rows in the output
select count(*) 
from orders o
left join products p
on o.product_id = p.product_id; -- 8549

select count(*) 
from orders o
right join products p
on o.product_id = p.product_id; -- 8552

-- View the products that exist in one table, but not the other
select * 
from orders o
left join products p
on o.product_id = p.product_id
where p.product_id IS NULL;

select * 
from orders o
	right join products p
	on o.product_id = p.product_id
where o.product_id IS NULL; -- Customers haven't ordered these products

-- Use a LEFT JOIN to join products and orders
SELECT	p.product_id, p.product_name,
		o.product_id AS product_id_in_orders
FROM	products p 
LEFT JOIN orders o
		ON p.product_id = o.product_id
WHERE	o.product_id IS NULL;

-- 3 Joining on multiple columns
select * 
from happiness_scores hs
	join inflation_rates ir
		on hs.country = ir.country_name and hs.year = ir.year;

-- 4. Joining multiple tables
-- You can join more than two tables as long as you specify the columns that link the tables together
select hs.year, hs.country, cs.continent, ir.inflation_rate
from happiness_scores hs
	left join country_stats cs
		on hs.country = cs.country
	left join inflation_rates ir
		on hs.year = ir.year AND hs.country = ir.country_name;

-- A self join lets you join a table with itself, and typically involves two steps:
-- 1. Combine a table with itself based on a matching column
-- 2. Filter on the resulting rows based o the same criteria

-- Find Employees with the same salary
select e1.employee_id, e1.employee_name, e1.salary,
	e2.employee_id, e2.employee_name, e2.salary
from employees e1
	join employees e2
    on e1.salary = e2.salary
where e1.employee_name <> e2.employee_name
	and e1.employee_id > e2.employee_id;
    
-- Find Employees that have a greater salary
select e1.employee_id, e1.employee_name, e1.salary,
	e2.employee_id, e2.employee_name, e2.salary
from employees e1
	join employees e2
    on e1.salary > e2.salary
order by e1.employee_id;

-- Employees and their managers
select e1.employee_id, e1.employee_name, e1.manager_id,
	e2.employee_name as manager_name
from employees e1
	left join employees e2
    on e1.manager_id = e2.employee_id;

-- ASSIGNMENT 2: Self Joins
-- Which products are within 25 cents of each other in terms of unit price?

-- View the products table
SELECT * FROM products;

-- Join the products table with itself so each candy is paired with a different candy
SELECT	p1.product_name, p1.unit_price,
		p2.product_name, p2.unit_price
FROM products p1 
	INNER JOIN products p2
		ON p1.product_id <> p2.product_id;
        
-- Calculate the price difference, do a self join, and then return only price differences under 25 cents
SELECT	p1.product_name, p1.unit_price,
		p2.product_name, p2.unit_price,
        p1.unit_price - p2.unit_price AS price_diff
FROM products p1 
	INNER JOIN products p2
		ON p1.product_id <> p2.product_id
WHERE ABS(p1.unit_price - p2.unit_price) < 0.25
		AND p1.product_name < p2.product_name
ORDER BY price_diff DESC;

-- Or with a Cross Join
SELECT	p1.product_name, p1.unit_price,
		p2.product_name, p2.unit_price,
        p1.unit_price - p2.unit_price AS price_diff
FROM products p1 
	CROSS JOIN products p2
WHERE ABS(p1.unit_price - p2.unit_price) < 0.25
		AND p1.product_name < p2.product_name
ORDER BY price_diff DESC;

-- Cross Joins
-- A cross join returns all combinations of rows within two or more tables
select *
from tops
	cross join sizes;

-- Use a UNION to stack multiple tables or queries on top of one another
-- UNION removes duplicate values, while UNION ALL retains them
-- If there are no duplicate values, a UNION ALL will run much faster than a UNION

select year, country, happiness_score from happiness_scores
UNION
select 2024, country, ladder_score from happiness_scores_current;
-- the data types just have to match, the specific column names don't have to match
-- instead of year, you can just put the acutal year 2024 and the results will show up for just the year 2024 only 
		
-- A Subquery is a query nested within a main query, and is typically used for solving a problem in multiple steps.
-- The code in the subquery is run first before the main query
-- Subqueries can occur in multiple places within a query:
	-- Calculations in the SELECT clause
	-- As part of a JOIN in the FROM clause
    -- Filtering in the WHERE and HAVING clauses

select year, country, happiness_score
from happiness_scores
where happiness_score > (select avg(happiness_score)
							from  happiness_scores);

select * from happiness_scores;    

select avg(happiness_score) from happiness_scores;

-- Happiness score deviation from the average
select year, country, happiness_score,
		(select avg(happiness_score) from happiness_scores) as avg_hs
from happiness_scores;

-- Happiness score deviation from the average
select year, country, happiness_score,
	(select avg(happiness_score) from happiness_scores) as avg_hs,
	happiness_score - (select avg(happiness_score) from happiness_scores) as diff_from_avg
from happiness_scores;



