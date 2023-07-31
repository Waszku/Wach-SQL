USE [Wydatki Czerwiec 2023]
SELECT * FROM Wydatki

Analiza wydatkow
1. Suma wydatkow dla kazdego sklepu.
2. Srednia wartosc wydatkow dla poszczegolnych dni.
3. Sklep, w ktorym zostalo wydane najwiecej pieniedzy.

Trendy zakupowe
1. Suma wydatkow dla kazdego dnia.
2. Sklepy, w ktorych dokonywano najwiekszych zakupow.
3. Procentowy udzial wydatkow w poszczegolnych sklepach.

Analiza daty
1. Dzien tygodnia, w ktorym wydano najwiecej pieniedzy.
2. Srednia wartosc wydatkow dla kazdego dnia tygodnia.

Analiza sklepow 
1. Srednia wartosc zamowienia dla kazdego sklepu.
2. Suma laczna wydatkow w miesiacu czerwiec
3. Liczba wystapien zrobienia zakupow w danym sklepie
4. Ile srednio zostalo wydanych pieniedzy w ciagu dnia

ANALIZA WYDATKOW 01.06 - 30.06

-- 1. Suma wydatkow dla kazdego przeznaczenia kwoty

SELECT Przeznaczenie, SUM(Kwota) as Suma FROM Wydatki
GROUP BY Przeznaczenie
ORDER BY SUM(Kwota) DESC

-- 2. Srednia wartosc wydatkow dla poszczegolnych dni

SELECT Data, ROUND(AVG(Kwota),2) as srednia_poszczegolnych_dni FROM WYdatki
GROUP BY Data

-- 3. Gdzie/Na co zostalo przeznaczone najwiecej pieniedzy (top 3)

WITH aaa AS (
SELECT Przeznaczenie, SUM(Kwota) as suma_kwot
FROM Wydatki
GROUP BY Przeznaczenie
),
bbb AS ( 
SELECT *, RANK() OVER (ORDER BY suma_kwot DESC) as rankk
FROM aaa
)
SELECT bbb.przeznaczenie, bbb.suma_kwot 
FROM bbb 
WHERE rankk between 1 AND 3 

TRENDY ZAKUPOWE 

-- 4. Suma wydatkow kazdego dnia miesiaca czerwiec

SELECT Data, SUM(Kwota) as suma_wydatkow
FROM Wydatki
GROUP BY Data

-- 5. Sklepy gdzie dokonywano najwiekszych zakupow w ciagu miesiaca czerwiec

SELECT Przeznaczenie, SUM(Kwota) as kwota
FROM Wydatki
WHERE Przeznaczenie IN ('Biedronka', 'Lidl', 'Netto', 'Zabka', 'Rossman')
GROUP BY Przeznaczenie
ORDER BY kwota DESC

-- 6. Procentowy udzial wydatkow w poszczegolnych sklepach z calkowitych wydatkow w tych sklepach

 WITH aaa AS (
             SELECT Przeznaczenie, SUM(Kwota) as suma_kwot
FROM Wydatki
WHERE Przeznaczenie IN ('Biedronka', 'Lidl', 'Netto', 'Zabka', 'Rossman')
GROUP BY Przeznaczenie
),
     bbb AS (
            SELECT SUM(suma_kwot) as suma_kwot_kwot
FROM aaa
)
SELECT aaa.Przeznaczenie, 
ROUND(aaa.suma_kwot/bbb.suma_kwot_kwot, 2)*100 as udzial_procentowy
FROM aaa, bbb

ANALIZA DATY 

-- 7. Dzien Tygodnia, w ktorym wydano najwiecej pieniedzy

SELECT TOP 1 Data, MAX(Kwota) as maksymalna_kwota
FROM Wydatki
GROUP BY Data
ORDER BY MAX(Kwota) DESC

-- 8. Srednia wartosc wydatkow dla kazdego tygodnia w miesiacu czerwiec

	SELECT
    Dni_Tygodnia,
    ROUND(AVG(Kwota),2) AS Srednia_Kwota
FROM (
    SELECT
        Data,
        Kwota,
        CASE
            WHEN Data BETWEEN '2023-06-01' AND '2023-06-07' THEN '01-07'
            WHEN Data BETWEEN '2023-06-08' AND '2023-06-14' THEN '08-14'
            WHEN Data BETWEEN '2023-06-15' AND '2023-06-21' THEN '15-21'
            WHEN Data BETWEEN '2023-06-22' AND '2023-06-28' THEN '22-28'
			WHEN Data BETWEEN '2023-06-29' AND '2023-06-30' THEN '29-30'
        END AS Dni_Tygodnia
    FROM Wydatki
) AS Subquery
GROUP BY Dni_Tygodnia;

SZYBKA ANALIZA ZAKUPOW

-- 9. Srednie wydatki w sklepach (Lidl, Biedronka, Netto, Zabka, Rosmman)

SELECT Przeznaczenie, ROUND(AVG(Kwota),2) as srednia_kwota
FROM Wydatki
WHERE Przeznaczenie IN ('Biedronka', 'Lidl', 'Netto', 'Zabka', 'Rossman')
GROUP BY Przeznaczenie

-- 10. Suma wydatkow lacznie

SELECT SUM(Kwota) as suma_laczna_wydatkow
FROM Wydatki

-- 11. Liczba wystapien zrobienia zakupow w danym sklepie

SELECT Przeznaczenie, COUNT(1) as liczba_odwiedzin
FROM Wydatki
WHERE Przeznaczenie IN ('Biedronka', 'Lidl', 'Netto', 'Zabka', 'Rossman')
GROUP BY Przeznaczenie

-- 12. Ile srednio zostalo wydanych pieniedzy w ciagu dnia

SELECT ROUND(AVG(Kwota),2) as srednio_wydano
FROM Wydatki