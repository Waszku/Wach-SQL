USE  [Video Games]
SELECT * FROM GamesSale

1. Najlepsze wyniki sprzedazy (mln) we wszystkich regionach 

SELECT SUM(NA_Sales) as NA,  SUM(EU_Sales) as EU, SUM(JP_Sales) as JP, SUM(Other_Sales) as Other, SUM(Global_Sales) as Global
FROM GamesSale 

2. 3 platformy, na ktore sprzedano najwiecej gier

SELECT TOP 3 Platform,  MAX(Global_Sales) as maks 
FROM GamesSale GROUP BY Platform ORDER BY maks DESC

3. Ile na tych 3 platformach sprzedano gier w ka¿dym z regionow?

SELECT Platform, SUM(NA_Sales) as NA,  SUM(EU_Sales) as EU, SUM(JP_Sales) as JP, SUM(Other_Sales) as Other, SUM(Global_Sales) as Global
FROM GamesSale WHERE Platform = 'Wii' OR Platform = 'NES' OR Platform = 'GB' GROUP BY Platform ORDER BY Global DESC

4. TOP 10 najlepiej sprzedajacych sie gier

SELECT TOP 10 Name, Global_Sales FROM GamesSale

5. Najlepsze gry w kazdym regionie

SELECT TOP 1 Name, NA_Sales  FROM GamesSale  ORDER BY NA_Sales DESC 
SELECT TOP 1 Name, EU_Sales FROM GamesSale ORder BY EU_Sales DESC
SELECT TOP 1 Name, JP_Sales FROM GamesSale ORder By JP_Sales DESC
SELECT TOP 1 Name, Other_Sales FROM GamesSale ORder by Other_sales DESC

6. Ktore gry wydane przed 2000 osiagaja sprzedaz globalna powy¿ej 15 mln?

SELECT Name, Global_sales FROM GamesSale WHERE YEAR < 2000 AND Global_Sales > 15

7. Jakich gatunkow gier najwiecej sprzedano?

SELECT Genre, MAX(Global_Sales) as maks FROM GamesSale GROUP BY Genre ORDER BY maks DESC

8. Wydawcy gier z najwieksza sprzedana iloscia w kazdym z regionow 

SELECT Publisher, MAX(NA_Sales) as maks FROM GamesSale GROUP BY Publisher ORDER BY maks DESC
SELECT Publisher, MAX(EU_Sales) as maks FROM GamesSale GROUP BY Publisher ORDER BY maks DESC
SELECT Publisher, MAX(JP_Sales) as maks FROM GamesSale GROUP BY Publisher ORDER BY maks DESC
SELECT Publisher, MAX(Other_Sales) as maks FROM GamesSale GROUP BY Publisher ORDER BY maks DESC

 
 


