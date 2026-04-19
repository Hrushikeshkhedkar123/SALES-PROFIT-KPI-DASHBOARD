Create database Task_2;
use Task_2;

create table orders (
Order_ID varchar(50),
Order_Date varchar(50),
Customer_ID varchar(50),
Category varchar(50),
Sales varchar(255),
Quantity varchar(255),
Discount varchar(255),
Profit  varchar(255)
);

UPDATE orders SET 
    Quantity = REGEXP_REPLACE(Quantity, '[^0-9]', ''),
    Profit = REGEXP_REPLACE(Profit, '[^0-9.-]', ''),
    Discount = REGEXP_REPLACE(Discount, '[^0-9.]', '');
ALTER TABLE orders 
MODIFY COLUMN Quantity INT,
MODIFY COLUMN Profit DECIMAL(15, 2),
MODIFY COLUMN Discount DECIMAL(15, 2);

UPDATE orders 
SET Sales = '0' 
WHERE Sales NOT REGEXP '^[0-9]+(\.[0-9]+)?$';

UPDATE orders SET Sales = TRIM(Sales);
UPDATE orders SET Sales = '0' WHERE Sales = '' OR Sales IS NULL;

ALTER TABLE orders
MODIFY COLUMN Sales DECIMAL(15, 2);

UPDATE orders 
SET Order_Date = STR_TO_DATE(Order_Date, '%d-%m-%Y')
WHERE Order_Date LIKE '%-%-%';
ALTER TABLE orders 
MODIFY COLUMN Order_Date DATE;

select *
from orders;

create table Customer (
Customer_ID varchar(50) primary key,
Customer_Name varchar(50),
Region varchar(50),
Segment varchar(50)
); 

SELECT *
FROM Orders o
INNER JOIN Customer c
ON o.Customer_ID = c.Customer_ID;

# Sales by Region
SELECT c.Region,
SUM(o.Sales) AS Total_Sales
FROM Orders o
JOIN Customer c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region;

# Profit Margin
SELECT Category,
SUM(Profit)/SUM(Sales) AS Profit_Margin
FROM Orders
GROUP BY Category;

# Monthly Sales
SELECT MONTH(Order_Date) AS Month,
SUM(Sales) AS Monthly_Sales
FROM Orders
GROUP BY Month
ORDER BY Month;

# Top Customers
SELECT c.Customer_Name,
SUM(o.Sales) AS Revenue
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Name
ORDER BY Revenue DESC
LIMIT 10;

