-- Show all customer records
SELECT * FROM customers;

------------------------------------------------------------------
-- Show total number of customers
SELECT COUNT(*) AS total_customers FROM customers;

------------------------------------------------------------------
-- Show transactions for Chennai market (market code for Chennai is Mark001)
SELECT * FROM transactions
WHERE market_code = 'Mark001';

------------------------------------------------------------------
-- Show distinct product codes that were sold in Chennai.
SELECT DISTINCT product_code
FROM transactions
WHERE market_code = 'Mark001';

------------------------------------------------------------------
-- Show transactions where currency is US dollars.
SELECT * FROM transactions
WHERE currency = 'USD';

------------------------------------------------------------------
-- Show transactions in 2020 join by date table.
SELECT transactions.*, date.*
FROM transactions
INNER JOIN date ON transactions.order_date = date.date
WHERE date.year = 2020;

------------------------------------------------------------------
-- Show total revenue in the year 2020.
SELECT SUM(transactions.sales_amount) AS total_revenue_2020
FROM transactions
INNER JOIN date ON transactions.order_date = date.date
WHERE date.year = 2020
AND (transactions.currency = 'INR' OR transactions.currency = 'USD');

------------------------------------------------------------------
-- Show total revenue in the year 2020, January Month.
SELECT SUM(transactions.sales_amount) AS total_revenue_jan_2020
FROM transactions
INNER JOIN date ON transactions.order_date = date.date
WHERE date.year = 2020
AND date.month_name = 'January'
AND (transactions.currency = 'INR' OR transactions.currency = 'USD');

------------------------------------------------------------------
-- Find the rrecords for which business is done outside India
SELECT * 
FROM transactions 
WHERE market_code IN ('Mark097','Mark999');

-----------------------------------------------------------------
-- Find transactions that occurred in 2020
SELECT * FROM sales.transactions 
WHERE order_date LIKE '2020%';

-- OR use inner join
SELECT t.*, d.* 
FROM sales.transactions AS t 
INNER JOIN sales.date AS d 
ON t.order_date=d.date
WHERE d.year=2020;

------------------------------------------------------------------
-- Find Transaction from chennai only
SELECT * FROM sales.transactions AS t 
INNER JOIN sales.markets AS m 
ON t.market_code = m.markets_code
WHERE m.markets_name = 'chennai';
-- OR
SELECT * FROM sales.transactions WHERE market_code='Mark001';

-----------------------------------------------------------------
-- Find total revenue generated in chennai in the year 2020
SELECT SUM(sales_amount) 
FROM sales.transactions 
WHERE market_code='Mark001' 
AND order_date LIKE '2020%';

-----------------------------------------------------------------
-- Find total revenue in each year
SELECT d.year, SUM(sales_amount) AS Revenue 
FROM sales.transactions AS t
INNER JOIN date as d
ON t.order_date = d.date
GROUP BY year
ORDER BY revenue DESC;
-- Among the 4 years of business largest revenue was generated in 2018

------------------------------------------------------------------
-- Find the markets name, amount of sales where transaction were done in USD
select m.markets_name, t.currency, t.sales_amount
from markets as m 
inner join transactions as t 
on m.markets_code = t.market_code
where t.currency = 'USD';
-- USD transactions took place in Delhi NCR 

------------------------------------------------------------------
-- Find the revenue generated by each market over the span of 4 years in descending order
SELECT m.markets_name,sum(sales_amount) AS 'Revenue genrated'
FROM markets AS m 
INNER JOIN transactions AS t 
ON m.markets_code = t.market_code
GROUP BY m.markets_name
ORDER BY sum(sales_amount) desc; 
-- Top 3 cities which generated largest revenue over the 4 years of business are Delhi NCR, Mumbai, Ahmedabad

------------------------------------------------------------------
-- Find the name of customer, customer_type, sales_amount, profit_margin_percentage of top 5 customers w.r.t revenue generated
SELECT c.customer_name, c.customer_type, SUM(t.sales_amount) AS revenue, 
ROUND(AVG(t.gross_profit_margin),2) AS 'average gross profit margin',
ROUND(((SUM(t.sales_amount)-SUM(t.cost_price))/SUM(t.sales_amount))*100,2) AS 'Gross profit margin (%)'
FROM transactions AS t
INNER JOIN customers AS c 
ON c.customer_code = t.customer_code
GROUP BY c.customer_name, c.customer_type
ORDER BY revenue DESC limit 5;
-- Electricalsara stores is observed to be the most profitable customer, followed by Electricalslytica and Excel Stores

------------------------------------------------------------------
-- Find the name of customer, customer_type, sales_amount, profit_margin_percentage of bottom 5 customers w.r.t revenue generated
SELECT c.customer_name, c.customer_type, SUM(t.sales_amount) AS revenue, 
ROUND(AVG(t.gross_profit_margin),2) AS 'avg gross profit margin %',
ROUND(((SUM(t.sales_amount)-SUM(t.cost_price))/SUM(t.sales_amount))*100,2) AS 'Gross profit margin (%)'
FROM transactions AS t
INNER JOIN customers AS c 
ON c.customer_code = t.customer_code
GROUP BY c.customer_name, c.customer_type
ORDER BY revenue ASC limit 5;

------------------------------------------------------------------
-- Find market name wise total sales quantity over the span of 4 years
SELECT m.markets_name, SUM(t.sales_qty) AS Total_qty
FROM markets AS m 
INNER JOIN transactions AS t
ON m.markets_code = t.market_code
GROUP BY m.markets_name
ORDER BY Total_qty DESC;

------------------------------------------------------------------
-- Find Top 5 customer name and the cities they belong to according to their average gross profit margin 
SELECT c.customer_name, m.markets_name, AVG(t.gross_profit_margin) AS avg_gross_profit_margin
FROM customers AS c
INNER JOIN
transactions AS t 
ON c.customer_code = t.customer_code
INNER JOIN
markets AS m 
ON t.market_code = m.markets_code
GROUP BY m.markets_name, c.customer_name
ORDER BY avg_gross_profit_margin DESC limit 5;

------------------------------------------------------------------
-- Take an overview of business in Bengaluru
SELECT 
(SELECT markets_name FROM markets WHERE markets_name='Bengaluru') AS City_name,
d.year, 
SUM(sales_amount) AS Revenue, SUM(sales_qty) AS Total_qty, 
AVG(gross_profit_margin) , AVG(gross_profit)
FROM transactions AS t
INNER JOIN date AS d
ON t.order_date = d.date
WHERE market_code = ( SELECT markets_code FROM markets WHERE markets_name='Bengaluru')
GROUP BY d.year;
