SELECT * FROM Choco
USE Choco

1. --- Which country sold the most product, what month was that and what is this product name?

SELECT TOP 1 Country, Product, Units_Sold, Month_name  FROM 
(
SELECT *,
DENSE_RANK() OVER (Partition by Product ORDER BY Units_Sold DESC) as rankk
FROM Choco
) as subquery
WHERE rankk = 1


2. --- Total profit for all countries in every month.

SELECT  MONTH_name, SUM(Profit) as total_profit FROM Choco
GROUP BY  Month_Name
ORDER BY total_profit DESC

3. --- Total profit for every country.

SELECT Country, SUM(Profit) as total_profit FROM Choco
GROUP BY Country
ORDER BY total_profit DESC
 
4. --- Total Units Sold For Every Country.

SELECT Country, SUM(Units_Sold) as total_units_sold FROM Choco
GROUP BY Country
ORDER BY total_units_sold DESC

5. --- Units Sold For Every Cookie in Every Country.

SELECT Country, Product, SUM(Units_Sold) total_units_sold FROM Choco
GROUP BY Country, Product
ORDER BY Product

6. --- Total Cost and Profit In Every Month

SELECT SUM(Cost) as total_cost, SUM(Profit) as total_profit, Month_name
FROM Choco
GROUP BY Month_Name

7. --- Units Sold For All Cookies in Every Month

SELECT Month_name, SUM(Units_Sold) as total_units_sold FROM Choco
GROUP BY Month_name
ORDER BY total_units_sold ASC