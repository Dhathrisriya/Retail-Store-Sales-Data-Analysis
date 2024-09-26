 -- Stores Table :
 CREATE TABLE Stores (
 Store_ID NUMBER PRIMARY KEY,
 Store_Name VARCHAR2(50),
 Region VARCHAR2(50)
 );
 -- Products Table:
 CREATE TABLE Products (
 Product_ID NUMBER PRIMARY KEY,
 Product_Name VARCHAR2(100),
 Category VARCHAR2(50) 
);

 -- Sales Table:
 CREATE TABLE Sales (  
Sale_ID NUMBER PRIMARY KEY,   
Store_ID NUMBER, 
Product_ID NUMBER, 
Sale_Date DATE, 
Quantity NUMBER, 
Total_Sale_Amount NUMBER(10, 2),   
CONSTRAINT fk_store FOREIGN KEY (Store_ID) REFERENCES 
Stores(Store_ID), 
CONSTRAINT fk_product FOREIGN KEY (Product_ID) REFERENCES 
Products(Product_ID)
 );
 
 -- INSERTING SAMPLE DATA
  -- Insert Data into the Stores Table:
 INSERT INTO Stores (Store_ID, Store_Name, Region) VALUES (1, 'RetailMart Downtown', 'North');
 INSERT INTO Stores (Store_ID, Store_Name, Region) VALUES (2, 'RetailMart Suburb', 'West');
 INSERT INTO Stores (Store_ID, Store_Name, Region) VALUES (3, 'RetailMart Eastside', 'East');

-- Insert Data into the Products Table:
 INSERT INTO Products (Product_ID, Product_Name, Category) VALUES (1, 'Laptop', 'Electronics');
 INSERT INTO Products (Product_ID, Product_Name, Category) VALUES (2, 'Smartphone', 'Electronics');
 INSERT INTO Products (Product_ID, Product_Name, Category) VALUES (3, 'Jeans', 'Clothing');
 INSERT INTO Products (Product_ID, Product_Name, Category) VALUES (4, 'Shirt', 'Clothing');
 INSERT INTO Products (Product_ID, Product_Name, Category) VALUES (5, 'Blender', 'Appliances');

-- Insert Data into the Sales Table:
 INSERT INTO Sales (Sale_ID, Store_ID, Product_ID, Sale_Date, Quantity, Total_Sale_Amount) 
VALUES (1, 1, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 5, 2500.00);
 INSERT INTO Sales (Sale_ID, Store_ID, Product_ID, Sale_Date, Quantity, Total_Sale_Amount) 
VALUES (5, 4, 5, TO_DATE('2024-10-05', 'YYYY-MM-DD'), 7, 1400.00);
 VALUES (2, 2, 2, TO_DATE('2024-07-02', 'YYYY-MM-DD'), 10, 5000.00);
 INSERT INTO Sales (Sale_ID, Store_ID, Product_ID, Sale_Date, Quantity, Total_Sale_Amount) 
VALUES (3, 3, 3, TO_DATE('2024-08-03', 'YYYY-MM-DD'), 20, 800.00);
 INSERT INTO Sales (Sale_ID, Store_ID, Product_ID, Sale_Date, Quantity, Total_Sale_Amount) 
VALUES (4, 1, 4, TO_DATE('2024-09-04', 'YYYY-MM-DD'), 15, 450.00);
 INSERT INTO Sales (Sale_ID, Store_ID, Product_ID, Sale_Date, Quantity, Total_Sale_Amount) 

ALTER TABLE Products ADD Price NUMBER(10, 2);
UPDATE Products SET Price = 10000 WHERE Product_ID = 1;
UPDATE Products SET Price = 5000 WHERE Product_ID = 2; 
UPDATE Products SET Price = 1300 WHERE Product_ID = 3; 
UPDATE Products SET Price = 1900 WHERE Product_ID = 4; 
UPDATE Products SET Price = 2000 WHERE Product_ID = 5;

-- 1Q.The management Wants to Know the total sales in each region.
-- QUERY :
SELECT 
s.Region,
 SUM(sa.Total_sale_Amount) AS Total_sales
 FROM Sales sa
 JOIN Stores s ON sa.Store_ID =  s.Store_ID
 GROUP BY  s.Region
 ORDER BY Total_Sales;

/*2Q.  Identify the top 5 best-selling products in terms of sales 
volume across all stores.*/

-- Query: 
SELECT
 p.Category,
 SUM(sa.Total_Sale_Amount) AS Total_Sales,
 AVG(sa.Total_Sale_Amount) AS Average_Sales_Per_Transaction
 FROM
 Sales sa
 JOIN
 Products p ON sa.Product_ID = p.Product_ID
 GROUP BY
 p.Category
 ORDER BY
 Total_Sales DESC;
 
 -- 3Q.Category-Wise Sales: Get a breakdown of sales by product category.
 -- QUERY:
SELECT
 P.CATEGORY,
 SUM(S.TOTAL_SALE_AMOUNT) TOTAL_SALES
 FROM SALES S
 JOIN PRODUCTS P ON S.PRODUCT_ID=P.PRODUCT_ID
 GROUP BY P.CATEGORY
 ORDER BY TOTAL_SALES DESC;
 
 -- 4. Monthly Sales Growth: Calculate the monthly sales growth for the current year
 
-- QUERY:
 SELECT
 current.Month,
 current.Total_Monthly_Sales,
 previous.Total_Monthly_Sales AS Previous_Month_Sales,
 CASE
 WHEN previous.Total_Monthly_Sales IS NULL THEN 0
 END AS Monthly_Growth_Percentage
 FROM (
 SELECT
 TO_CHAR(Sale_Date, 'YYYY-MM') AS Month,
 ELSE ROUND(((current.Total_Monthly_Sales - previous.Total_Monthly_Sales) / previous.Total_Monthly_Sales) * 100, 2)
 SUM(Total_Sale_Amount) AS Total_Monthly_Sales
 FROM Sales
 GROUP BY
 TO_CHAR(Sale_Date, 'YYYY-MM')
 ORDER BY Month
 ) current
 LEFT JOIN
(
 SELECT
 TO_CHAR(Sale_Date, 'YYYY-MM') AS Month,
 SUM(Total_Sale_Amount) AS Total_Monthly_Sales
 FROM Sales
 GROUP BY TO_CHAR(Sale_Date, 'YYYY-MM')
 ORDER BY Month
 ) previous ON
 current.Month = TO_CHAR(ADD_MONTHS(TO_DATE(previous.Month, 'YYYY-MM'), 1), 'YYYY
MM');

-- 5.Determine the performance of each store by comparing sales volumes
-- QUERY:
 SELECT
 s.Store_Name, 
SUM(sa.Total_Sale_Amount) AS Total_Sales
 FROM 
Sales sa
 JOIN 
Stores s ON sa.Store_ID = s.Store_ID
 GROUP BY 
s.Store_Name
 ORDER BY 
Total_Sales DESC;

-- 6.Product Category Insights: Offer discounts or promotions based on category-wise sales trends.

 -- QUERY:
 SELECT 
Product_ID,
 Product_Name, 
Category,
 Price,
 CASE 
WHEN Price > 3000 THEN Price * 0.2        
ELSE Price * 1
 END AS DISCOUNT
 FROM Products
 
 -- 7.Regional Trends: Analyze trends over time by region to inform marketing strategies
 
-- QUERY
 SELECT
 TO_CHAR(s.Sale_Date, 'YYYY-MM') AS Month,
 st.Region,
 SUM(s.Total_Sale_Amount) AS Total_Sales 
FROM Sales s
 JOIN Stores st ON s.Store_ID = st.Store_ID   
GROUP BY
 TO_CHAR(s.Sale_Date, 'YYYY-MM'),
 st.Region  
ORDER BY
 Month, 
st.Region; 