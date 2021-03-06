-- AGGREGATIONS OVER WINDOWS
SELECT order_id, order_date,customer_name, city, order_amount , SUM(order_amount) OVER (PARTITION BY city) as grand_total from dbo.orders

SELECT order_id, order_date,customer_name, city, order_amount , AVG(order_amount) OVER (PARTITION BY city, DAY(order_Date)) as avg_order_month from dbo.orders

SELECT MONTH(order_Date) FROM dbo.Orders

-- RANK FUNCTIONS OVER WINDOWS
SELECT order_id, order_date,customer_name, city, order_amount , RANK() OVER (ORDER BY order_amount DESC) as rank_order from dbo.orders

-- ROW_NUMBER() WITHOUT PARTITIONS AND WITH
SELECT order_id, order_date,customer_name, city, order_amount , ROW_NUMBER() OVER (ORDER BY order_id DESC) as rank_order from dbo.orders

SELECT order_id, order_date,customer_name, city, order_amount , ROW_NUMBER() OVER (PARTITION BY city ORDER BY order_amount DESC) as rank_order from dbo.orders

-- NTILE PERCENTILE
SELECT order_id, order_date,customer_name, city, order_amount , NTILE(4) OVER (ORDER BY order_amount DESC) as rank_order from dbo.orders

-- LEAD AND LAG
SELECT order_id, customer_name, city, order_amount , order_date,LEAD(order_date,1) OVER (ORDER BY order_date) as prox_compra from dbo.orders

-- LEAD AND LAG
SELECT order_id, customer_name, city, order_amount , order_date,LAG(order_date,1) OVER (ORDER BY order_date) as compra_anterior from dbo.orders

-- LEAD AND LAG PARTITION BY CITY
SELECT order_id, customer_name, city, order_amount , order_date,LAG(order_date,1) OVER (PARTITION BY city ORDER BY order_date ASC) as compra_anterior from dbo.orders



USE window_functions;

truncate table dbo.Orders

CREATE TABLE dbo.Orders
(
	order_id INT,
	order_date DATE,
	customer_name VARCHAR(250),
	city VARCHAR(100),	
	order_amount MONEY
)
 
INSERT INTO dbo.Orders
SELECT '1001', format(cast('04/01/2017' as date),'dd/MM/yyyy'),'David Smith','GuildFord',10000
UNION ALL	  
SELECT '1002',format(cast('04/02/2017' as date),'dd/MM/yyyy'),'David Jones','Arlington',20000
UNION ALL	  
SELECT '1003',format(cast('04/03/2017' as date),'dd/MM/yyyy'),'John Smith','Shalford',5000
UNION ALL	  
SELECT '1004',format(cast('04/04/2017' as date),'dd/MM/yyyy'),'Michael Smith','GuildFord',15000
UNION ALL	  
SELECT '1005',format(cast('04/05/2017' as date),'dd/MM/yyyy'),'David Williams','Shalford',7000
UNION ALL	  
SELECT '1006',format(cast('04/06/2017' as date),'dd/MM/yyyy'),'Paum Smith','GuildFord',25000
UNION ALL	 
SELECT '1007',format(cast('04/07/2017' as date),'dd/MM/yyyy'),'Andrew Smith','Arlington',15000
UNION ALL	  
SELECT '1008',format(cast('04/08/2017' as date),'dd/MM/yyyy'),'David Brown','Arlington',2000
UNION ALL	  
SELECT '1009',format(cast('04/09/2017' as date),'dd/MM/yyyy'),'Robert Smith','Shalford',1000
UNION ALL	  
SELECT '1010',format(cast('04/10/2017' as date),'dd/MM/yyyy'),'Peter Smith','GuildFord',500