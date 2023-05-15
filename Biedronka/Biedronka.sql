USE PIS
SELECT * FROM Biedronka2015
SELECT * FROM Biedronka2023

----- Laczenie dwoch tabeli produktow z cenami z 2015 i 2023 roku oraz wyliczenie procentowego wzrostu cen dla kazdego produktu, dodatkowo
---posortowane rosnaco.

SELECT Biedronka2015.produkt, ROUND(((MAX(Biedronka2023.cena) - MIN(Biedronka2015.cena)) / MIN(Biedronka2015.cena))* 100, 2) as wzrost_procentowy
FROM Biedronka2015
JOIN Biedronka2023 ON Biedronka2015.produkt_id=Biedronka2023.Produkt_id
GROUP BY Biedronka2015.produkt
ORDER BY wzrost_procentowy ASC

--- Roznica cen produktow 2015-2023 wraz ze wzrostem procentowym

WITH aaa AS (
SELECT produkt, cena 
FROM Biedronka2015
),
bbb AS (
SELECT produkt, cena
FROM Biedronka2023
)
SELECT aaa.produkt, aaa.cena as cena2015, bbb.cena as cena2023, SUM(bbb.Cena - aaa.cena) as roznica_cen,
ROUND(((MAX(bbb.cena) - MIN(aaa.cena)) / MIN(aaa.cena))* 100, 2) as wzrost_procentowy 
FROM aaa
JOIN bbb ON aaa.produkt=bbb.produkt
GROUP BY aaa.cena, bbb.cena, aaa.produkt, bbb.produkt







