SELECT * FROM shopping

USE [E-commerce]

--- 1. What is number of customers who bought only once in this store?

SELECT COUNT(*) as unique_customers_number
FROM (
    SELECT CustomerID, COUNT(*) as number_of_CustomerID
    FROM shopping
    GROUP BY CustomerID
    HAVING COUNT(*) = 1
) AS subquery

--- 2. Which customer ordered the most quantity of products?

SELECT TOP 1 CustomerID, MAX(Quantity) as max_quantity
FROM shopping
GROUP BY CustomerID
ORDER BY MAX(Quantity) DESC

--- 3. Which customer ordered least of quantity of products?

SELECT TOP 1 CustomerID, MIN(Quantity) as min_quantity
FROM shopping
GROUP BY CustomerID
ORDER BY MIN(Quantity) ASC

--- 4. How much the company made between 2010 and 2011?

SELECT ROUND(SUM(Quantity * UnitPrice), 2) as total
FROM shopping

--- 5. From which countries were customers who spent the most?

WITH aaa AS (
            SELECT Country, ROUND(SUM(Quantity * UnitPrice), 2) as total
			FROM shopping
			GROUP BY Country),
	 bbb AS (
	        SELECT *, RANK() OVER (ORDER BY total  DESC) as rankk
			FROM aaa)
	SELECT * FROM bbb
	WHERE rankk BETWEEN 1 AND 10
	
--- 6. The most buy items

SELECT TOP 10
  CASE
    WHEN DESCRIPTION = '' THEN 'N/A'
    ELSE DESCRIPTION
  END as Description,
  COUNT(*) as no_of_item
FROM shopping
WHERE DESCRIPTION <> ''
GROUP BY
  CASE
    WHEN DESCRIPTION = '' THEN 'N/A'
    ELSE DESCRIPTION
  END
ORDER BY no_of_item DESC

--- 7. From what countries were customers the most? (TOP 10)

SELECT TOP 10 country,  
COUNT(DISTINCT CustomerID) as number_of_customers
FROM shopping
GROUP BY country
ORDER BY number_of_customers DESC

--- 8. What was number of orders by country? (TOP 10)

SELECT TOP 10 country,  
COUNT(DISTINCT InvoiceNo) as number_of_orders
FROM shopping
GROUP BY country
ORDER BY number_of_orders DESC

--- 9. How much the company made per day?

SELECT ROUND(SUM(Quantity * UnitPrice), 2) / 365 as total
FROM shopping

--- 10. How much money was left by every customer (on average)?

SELECT ROUND(SUM(Quantity * UnitPrice), 2) / COUNT(DISTINCT CustomerID) as avg_by_cust
FROM shopping

--- 11. Percentage of countries outside the UK

SELECT 
     (COUNT(DISTINCT CASE WHEN country <> 'United Kingdom' THEN CustomerID END) * 100.0 /
      COUNT(DISTINCT CustomerID)) AS percentage
FROM shopping

--- 12. TOP 10 customers who bought the most often

SELECT TOP 10
  CASE
    WHEN CustomerID = '' THEN 'N/A'
    ELSE CustomerId
  END as CustomerId,
  COUNT(DISTINCT InvoiceNo) as no_of_purchase
FROM shopping
WHERE CustomerId <> ''
GROUP BY
  CASE
    WHEN CustomerId = '' THEN 'N/A'
    ELSE CustomerId
  END
ORDER BY no_of_purchase DESC









