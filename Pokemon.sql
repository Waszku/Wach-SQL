SELECT * FROM Pokemon


--- 1. Number of Pokemons who have only one type 

SELECT COUNT(*) as no_of_pok_1type FROM Pokemon
WHERE NOT Type_2 IS NOT NULL

--- 2. Number of Pokemons who have two types 

SELECT COUNT(*) as no_of_pok_2type FROM Pokemon
WHERE Type_2 IS NOT NULL

--- 3. Which Pokemons have the most Attack and the min Attack in the first generation?

SELECT
    (SELECT TOP 1 Name
     FROM Pokemon
     WHERE Generation = 1
     ORDER BY attack DESC) AS pokemon_with_max_attack,
    (SELECT TOP 1 Name
     FROM Pokemon
     WHERE Generation = 1
     ORDER BY attack ASC) AS pokemon_with_min_attack;

--- 4. Which generation has the most number of Pokemon?

WITH aaa AS (
SELECT Generation, COUNT(*) as maxxno
FROM Pokemon
GROUP BY Generation)
SELECT TOP 1 Generation, MAX(maxxno) as most_no_of_pok FROM aaa
GROUP BY generation
ORDER BY MAX(maxxno) DESC

--- 5. What kind of Type_1 is the most in the table?

WITH aaa AS (
SELECT Type_1, COUNT(*) as themostno
FROM Pokemon
GROUP BY Type_1)
SELECT TOP 1 Type_1, MAX(themostno) as themostnooftyp1
FROM aaa
GROUP BY Type_1
ORDER BY themostnooftyp1 DESC

--- 6. TOP 3 the most kind of Type_1 in the table

WITH aaa AS (
SELECT Type_1, COUNT(*) as themost
FROM Pokemon
GROUP BY Type_1
),
bbb AS (
SELECT *, DENSE_RANK() OVER (ORDER BY themost DESC) as rankk
FROM aaa)
SELECT Type_1, themost FROM bbb
WHERE rankk <= 3
ORDER BY rankk ASC

--- 7. What is number of Legendary Pokemon in the table?

SELECT  COUNT(*) as no_of_legendary_pokemon FROM Pokemon
WHERE Legendary = 1

--- 8. TOP 10 Pokemons with the most 'Total' in the table.

SELECT TOP 10 Name, MAX(Total) FROM POkemon
WHERE Generation = 1
GROUP BY Name
ORDER BY MAX(Total) DESC

--- 9. Which generation is the most powerful (The max number of 'total' of every Pokemon in generation)

WITH aaa AS (
SELECT Generation, SUM(Total) as fullpower
FROM Pokemon
WHERE Generation IN (1, 2, 3, 4, 5, 6)
GROUP BY Generation)
SELECT TOP 1 Generation, fullpower 
FROM aaa
ORDER BY fullpower DESC

--- 10. Classiffication according HP: not good, good, the best - choice.

SELECT *,
      CASE WHEN HP >= 1 AND HP <= 65 THEN 'Not Good'
	       WHEN HP > 65 AND HP <= 180 THEN 'Good'
		   ELSE 'The Best'
	  END as which_one_to_pickHP
FROM Pokemon

--- 11. Which generations have the total defense more than 10000?

SELECT Generation, SUM(Defense) as totalofdense FROM Pokemon
WHERE Generation IN (1,2,3,4,5,6)
GROUP BY Generation
HAVING SUM(Defense) > 10000
ORDER BY totalofdense DESC

--- 12. The % difference between the max 'Total' Pokemon from First Generation and the Pokemon from 6th Generation in 'Total'.

WITH aaa AS (
SELECT MAX(CASE WHEN Generation = 1 THEN Total END) AS max_total_gen1,
       MAX(CASE WHEN Generation = 6 THEN Total END) AS max_total_gen6
FROM Pokemon
WHERE Generation = 1 OR Generation = 6)
SELECT *, ROUND(((max_total_gen1 - max_total_gen6) / max_total_gen6) * 100, 2) AS percentage_growth
FROM aaa;


