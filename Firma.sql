USE Firma
SELECT * FROM Pracownicy
CREATE TABLE Pracownicy (

ID INT PRIMARY KEY NOT NULL, 
Imie VARCHAR (255),
Rola VARCHAR (255),
Pensja INT,
Data_zatrudnienia DATE
);

INSERT INTO Pracownicy VALUES (1, 'Jacek', 'Sprzedaz', 4520, '2012-07-02')
INSERT INTO Pracownicy VALUES (2, 'Maria', 'Marketing', 5000, '2011-02-17')
INSERT INTO Pracownicy VALUES (3, 'Tomasz', 'Inzynier', 6300, '2015-09-22')
INSERT INTO Pracownicy VALUES (4, 'Artur', 'Sprzedaz', 3900, '2017-05-30')
INSERT INTO Pracownicy VALUES (5, 'Karolina', 'Inzynier', 6000, '2014-08-12')
INSERT INTO Pracownicy VALUES (6, 'Piotr', 'Marketing', 3500, '2018-12-10')
INSERT INTO Pracownicy VALUES (7, 'Sandra', 'Sprzedaz', 4000, '2019-10-11')
INSERT INTO Pracownicy VALUES (8, 'Wojciech', 'Inzynier', 7000, '2016-04-07')
INSERT INTO Pracownicy VALUES (9, 'Bozena', 'Marketing', 2800, '2020-03-03')
INSERT INTO Pracownicy VALUES (10, 'Liza', 'Sekretarka', 2500, '2021-06-01')
INSERT INTO Pracownicy VALUES (11, 'Maciej', 'Technolog', 8000, '2015-01-19')
INSERT INTO Pracownicy VALUES (12, 'Bartek', 'Technolog', 2400, '2022-11-22')
INSERT INTO Pracownicy VALUES (13, 'Maja', 'Sekretarka', 2800, '2023-03-23')

1. Ile wynosi suma pensji wszystkich pracowników Firmy?

SELECT SUM(Pensja) as SumaPensjiPracownikow FROM Pracownicy

2. Jakie jest œrednie wynagrodzenie pracowników dla kazdej roli w firmie?

SELECT Rola, AVG(Pensja) as SredniaPensja FROM Pracownicy GROUP BY Rola

3. Ilu pracowników zosta³o zatrudnionych miêdzy 2012 a 2018 rokiem i na jak¹ pozycjê?

SELECT COUNT(rola) as liczba_zatrudnionych, Rola FROM Pracownicy WHERE Data_zatrudnienia BETWEEN '2012-01-01' AND '2017-12-31' 
GROUP BY rola

4. Jakie jest najwy¿sze a jakie najni¿sze wynagrodzenie w firmie?

SELECT MAX(Pensja) najwy¿sza_pensja, MIN(Pensja) as najni¿sza_pensja FROM Pracownicy 


5. Który pracownik ma najwy¿sze wynagrodzenie w firmie, a który najni¿sze?

SELECT imie, pensja FROM Pracownicy 
WHERE pensja =(SELECT MAX(Pensja) FROM Pracownicy)  
OR pensja = (SELECT MIN(Pensja)  FROM Pracownicy) 

6. Ilu pracowników jest zatrudnionych d³u¿ej ni¿ 5 lat?

SELECT COUNT(*) as pracownik_dluzej_niz_5_lat FROM Pracownicy 
WHERE data_zatrudnienia <  DATEADD(Year, -5, GETDATE()) 

7. Jakie jest œrednie wynagrodzenie dla pracowników zatrudnionych od 2017 roku?

SELECT AVG(Pensja) as srednia_pensja_od2017 FROM Pracownicy 
WHERE data_zatrudnienia >='2017-01-01'

8. Trzech najbardziej op³acanych pracowników firmy 

SELECT TOP 3 ROW_NUMBER () OVER (ORDER BY Pensja DESC) As nr, imie, Rola, Pensja FROM Pracownicy 

9. Dodawanie kolejnej kolumny "Plec" do tabeli 

ALTER TABLE Pracownicy 
ADD "Plec" VARCHAR (10)

10. Dodawanie plci dla danego pracownika

UPDATE Pracownicy
SET Plec =
CASE WHEN Imie IN ('Jacek', 'Tomasz', 'Artur', 'Piotr', 'Wojciech', 'Maciej', 'Bartek') THEN 'Mezczyzna'
ELSE 'Kobieta'
END

11. Dodanie nowej kolumny "podwyzki" 

ALTER TABLE Pracownicy
ADD "Podwyzki" INT 

12. Ka¿dy z pracowników zatrudnionych minimum 7 lat dostanie 1000 z³ podwy¿ki, reszta 420 z³

UPDATE Pracownicy 
SET Podwyzki =
CASE WHEN data_zatrudnienia <= DATEADD (Year, -7, GETDATE() ) THEN 1000 
ELSE 420
END

13. Ile wynosi pensja pracowników po podwy¿kach

SELECT imie, SUM(Pensja+podwyzki) as pensja_po_podwyzce
FROM (
SELECT imie, pensja, podwyzki  FROM Pracownicy
) sum
GROUP BY imie

14. Jakie jest nowe wynagrodzenie po podwy¿kach pracowników i o ile procent wzros³o wzglêdem starego?

WITH aaa AS (
SELECT imie, pensja, podwyzki
FROM Pracownicy
)
SELECT
aaa.imie,
SUM(pensja) as pensja_przed_podwyzka,
SUM(Pensja+podwyzki) as pensja_po_podwyzce,
ROUND(((MAX(pensja+podwyzki) - MIN(pensja)) / MIN(pensja)) * 100, 2)
as wzrost_procentowy from aaa
GROUP BY aaa.imie

15. Którzy pracownicy odnotowali wzrost podwy¿ki powy¿ej 20%?

WITH aaa AS (
SELECT imie, pensja, podwyzki
FROM Pracownicy
)
SELECT
aaa.imie,
SUM(pensja) as pensja_przed_podwyzka,
SUM(Pensja+podwyzki) as pensja_po_podwyzce,
ROUND(((MAX(pensja+podwyzki) - MIN(pensja)) / MIN(pensja)) * 100, 2) as wzrost_procentowy
FROM aaa
GROUP BY aaa.imie
HAVING ROUND(((MAX(pensja+podwyzki) - MIN(pensja)) / MIN(pensja)) * 100, 2) > 20

16. Wzrost Procentowy po podwy¿kach od najwiêkszego do najmniejszego

 WITH 
 aaa AS (
 SELECT imie, pensja, podwyzki,
 ROUND(((MAX(pensja+podwyzki) - MIN(pensja)) / MIN(pensja)) * 100, 2) as wzrost_procentowy
 FROM Pracownicy 
 GROUP by imie, pensja, podwyzki
 )
 SELECT 
 aaa.imie, 
 SUM(pensja+podwyzki) as pensja_po_podwyzce, aaa.wzrost_procentowy,
 ROW_NUMBER() OVER (ORDER BY aaa.wzrost_procentowy DESC) as rn
 FROM aaa
 GROUP BY aaa.imie, aaa.wzrost_procentowy
 
 17. Która kobieta ma najd³u¿szy sta¿ pracy w firmie?

 SELECT TOP 1 imie, DATEDIFF(Year, data_zatrudnienia, GETDATE()) AS Lata_pracy
 FROM Pracownicy
 WHERE plec = 'Kobieta'

18. Dodawanie kolumny "data podwyzki" 

ALTER TABLE Pracownicy
ADD "Data_podwyzki" DATE 

19. Ddawanie danych do kolumny "Data_podwyzki" 

UPDATE Pracownicy 
SET Data_podwyzki = '2023-03-29'
WHERE ID =13

20. Ilu pracowników otrzyma³o podwy¿kê w ci¹gu ostatnich 3 lat?

WITH 
aaa AS (
SELECT imie, Max(data_podwyzki) as podwyzki 
FROM Pracownicy
WHERE data_podwyzki > DATEADD(Year, -3, GETDATE()) 
GROUP BY  imie 
)
SELECT  COUNT(*) as liczba_pracownikow_z_podwyzka_w_przeciagu_ostatnich_3_lat
FROM aaa

