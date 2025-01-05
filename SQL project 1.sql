-- SQL Retail sales analysis.
CREATE DATABASE sql_projects_p1

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
            (
			    transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time time,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT 
            );

SELECT * FROM retail_sales
LIMIT 10

- DATA CLEANING
SELECT COUNT(*)
FROM retail_sales

--
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE transactions_id IS NULL or sale_date IS NULL
or sale_time IS NULL or gender IS NULL or quantiy IS NULL or cogs IS NULL
or total_sale IS NULL;

DELETE FROM retail_sales
WHERE transactions_id IS NULL or sale_date IS NULL
or sale_time IS NULL or gender IS NULL or quantiy IS NULL or cogs IS NULL
or total_sale IS NULL;

--DATA EXPLORATION 

--how many sales we have?

SELECT COUNT(*) AS total_sale FROM retail_sales

-- how many customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- how many unique categories do we have?
SELECT COUNT(DISTINCT category)  FROM retail_sales


-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS.
-- WRITE A SQL QUERY TO RETRIEVE ALL COLUMS FOR SALES MADE ON "2022-11-05"

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity 
--sold is more than 4 in the month of Nov-2022?


SELECT * 
FROM retail_sales
WHERE category = 'Clothing' AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' AND quantiy >= 4

-- write a sql query to calculate the total sales(total_sales for each category)

SELECT category, SUM(total_sale) as net_sale, COUNT(*) as total_orders
FROM retail_sales
GROUP by category

-- write a sql query to find the average age of customers who purchased items from the beauty category?

SELECT ROUND(AVG(age), 2)
FROM retail_sales
WHERE category = 'Beauty'


--Write a SQL query to find all transactions where total_sale is greather than 1000

SELECT * 
FROM retail_sales
WHERE total_sale > 1000

--Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category?
SELECT category, gender, count(*) as total_trans
FROM retail_sales
GROUP BY category, gender

--write a sql query to calculate the avergae sale for each month. Find out best selling month in each year?
select year, month, avg_sale FROM
(
	SELECT EXTRACT(YEAR FROM sale_date) as year,  EXTRACT(MONTH FROM sale_date) as month, AVG(total_sale) as Avg_sale, RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales 
	GROUP BY 1, 2
) as t1
WHERE rank = 1
--ORDER BY 1,3 DESC

-- write a sql query to find the top 5 customers based on the highest total sales

SELECT customer_id, sum(total_sale) as total_sales
FROM retail_sales 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Write a SQL query to find the number of unique customers who purchased items from each category.:

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
