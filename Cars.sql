SELECT * FROM Cars
USE SportCars
1. Jaki jest najdrozszy samochod i ile kosztuje?
 
SELECT TOP 1 Car_Make, Car_Model, Price as Najdrozsze_auto
FROM Cars
ORDER BY Price DESC

2. Jaki samochod rozpedza sie najszybciej do 100 km/h

SELECT Car_Make, Car_Model, Fastest AS 'Od 0 do 100 [s]'
FROM Cars
WHERE Fastest = (SELECT MIN(Fastest) FROM Cars)

3. Jaka jest roznica w cenie miedzy najdrozszym modelem a najtanszym?

SELECT MAX(Price) - MIN(Price) as roznica_w_cenie FROM Cars

4. O ile % drozszy jest Bugatti Chiron z 2021 roku od Audi R8 z 2022 roku?

SELECT ROUND(((MAX(Price) - MIN(Price)) / MIN(PRICE) * 100), 2) as roznica_w_procentach
FROM Cars WHERE (Car_Make = 'Bugatti' AND Car_Model = 'Chiron' AND YEAR = 2021) 
OR (Car_Make = 'Audi' AND Car_Model = 'R8' AND YEAR = 2022)

5. Jaki, przynajmniej 1 model samochodu  ma najwiecej koni (Horsepower)? 

SELECT  TOP 1 Car_Make, Car_Model, Horsepower as Najwiecej_koni
FROM Cars
WHERE Horsepower = (SELECT MAX(Horsepower) FROM Cars) 

6. Samochody z przyspieszeniem do 100 km/h krotszym niz 3 sekundy

SELECT Car_Make, Car_Model, Fastest 
FROM Cars
WHERE Fastest < 3

7. Ile jest samochodow w tabeli wyprodukowanych w 2019, 2020, 2021 i 2022 roku?

 SELECT 
  SUM(CASE WHEN Year = 2019 THEN 1 ELSE 0 END) AS '2019', 
  SUM(CASE WHEN Year = 2020 THEN 1 ELSE 0 END) AS '2020',
  SUM(CASE WHEN Year = 2021 THEN 1 ELSE 0 END) AS '2021',
  SUM(CASE WHEN Year = 2022 THEN 1 ELSE 0 END) AS '2022'
FROM Cars

8. Ktorych 10 producentow ma najwiecej modeli w tabeli?

SELECT TOP 10 Car_Make, COUNT(Car_Make) as liczba_modeli_danego_producenta FROM Cars GROUP BY Car_Make
ORDER BY liczba_modeli_danego_producenta DESC

9. Najdrozszy vs najtanszy samochod z 2022 roku

SELECT Car_Make, Car_Model, Price 
FROM Cars
WHERE Price = (SELECT MAX(Price) FROM Cars) AND Year = 2022 
OR Price = (SELECT MIN(Price) FROM Cars) AND Year = 2022

10. O ile % wiecej kosztuje najdrozszy samochod od najtanszego?

SELECT ROUND(((MAX(Price) - MIN(Price)) / MIN(Price) * 100), 2) as procent FROM Cars 

11. Jakie samochodoy kosztuja wiecej niz srednia cena wszystkich samochodow?

SELECT Car_Make, Car_Model, Price 
FROM Cars
WHERE Price > (SELECT AVG(Price) FROM Cars)

12. Jakie modele samochodow maja najwiekszy moment obrotowy?

SELECT  Car_Make, Car_Model, Torque 
FROM Cars 
WHERE [Torque ] = (SELECT MAX(Torque) FROM Cars)

13. Jaka jest minimalna, maksymalna i srednia cena modelu samochodu dla kazdej marki?

SELECT DISTINCT Car_Make, MIN(Price) as minimalna_cena_modelu_auta, 
MAX(Price) as maksymalna_cena_modelu_auta, 
AVG(Price) as srednia_cena_modelu_auta 
FROM Cars 
GROUP BY Car_Make 

14. Samochody od 100 tys do 1000 0000

SELECT Car_Make, Car_Model, Price FROM Cars
WHERE Price BETWEEN 100 AND 1000
ORDER BY Price

15. Pozycje rankingowe dla 5 (6) modeli samochodu, sortujac wyniki wedlug liczby wystapien modelu
   
 WITH aaa AS (
   SELECT Car_Model, COUNT(*) as cnt
   FROM Cars
   GROUP BY Car_Model
),
     bbb AS (
   SELECT *, RANK() OVER(ORDER BY cnt DESC) as rank
   FROM aaa
)
   SELECT * FROM bbb
   WHERE rank BETWEEN 1 AND 5







 