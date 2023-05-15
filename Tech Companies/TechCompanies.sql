SELECT * FROM Companies
USE [Tech Company]

---1. What was the the annual revenue for every company?

SELECT Company_Name, Annual_Revenue FROM Companies

---2. How many workers do every company have?

SELECT Company_Name, Employee_Size FROM Companies

---3. What is a number of employees of all companies together?

SELECT  SUM(Employee_Size) as suma_pracownikow_wszystkich_firm FROM Companies 

---4. What is average number of employees in all companies together? 

SELECT AVG(Employee_Size) as srednia_liczba_pracownikow_w_firmach FROM Companies

---5. How many sectors do the companies operate on?

SELECT COUNT(DISTINCT Sector) as liczba_sektorow_obslugiwana_przez_firmy FROM Companies

---6. In what sectors are the companies in?

SELECT Company_name, Sector FROM Companies

---7. What is the annual income tax for every company?

SELECT Company_name, Annual_Income_Tax FROM Companies

---8. How many companies was founded after 2000?

SELECT COUNT(Company_name) as firmy_zalozone_po_2000roku FROM Companies WHERE Founding_year > 2000

---9. What companies was founded after 2000?

SELECT Company_name FROM Companies WHERE Founding_year > 2000

---10. What is a name of every company on the stock market?

SELECT Company_name, Stock_name FROM Companies 

---11. What is the total amount of income taxes paid by companies based in Texas?

SELECT SUM(Annual_Income_Tax) as podatki_w_teksasie FROM Companies WHERE HQ_State = 'Texas'  


---12. By what percentage did Amazon have more annual revenue than Apple?       

SELECT ROUND((MAX(Annual_Revenue) - MIN(Annual_Revenue)) / MIN(Annual_Revenue) * 100, 2) as procent
FROM Companies
WHERE Company_Name IN ('Amazon', 'Apple Inc.')

---13. Which companies have more employees than the average number of employees for all companies in the table?  

SELECT Company_name, Employee_Size
FROM Companies
WHERE Employee_Size > 
(SELECT AVG(Employee_Size) AS avg_size
FROM Companies)
ORDER BY Employee_Size DESC





