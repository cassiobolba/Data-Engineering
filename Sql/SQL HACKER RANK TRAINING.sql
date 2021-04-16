# QUERY TO GET VALUES WHERE A NUMBER IS EVEN
SELECT DISTINCT CITY FROM STATION WHERE ID%2 = 0

# TOTAL NUMBER - TOTAL DISTINCT
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION

# GET SHORTEST NAME AND LONGEST, ALONG WITH NAME, LENGHT, ORDERED ALPHABETICALLY
SELECT TOP 1 CITY,MIN(LEN(CITY)) FROM STATION GROUP BY CITY ORDER BY MIN(LEN(CITY)),CITY ASC;
SELECT TOP 1 CITY,MAX(LEN(CITY)) FROM STATION GROUP BY CITY ORDER BY MAX(LEN(CITY)) DESC,CITY ASC

# LIST OF CITIES ENDING WITH VOWELS
SELECT DISTINCT CITY FROM STATION WHERE CITY LIKE '%[a,e,i,o,u]'

# ORDER BY LAST 3 DIGITS IN A STRING
SELECT NAME FROM STUDENTS WHERE MARKS > 75 ORDER BY RIGHT(NAME,3), ID ASC

# ROUND THE LOWEST AND CLOSEST INTERGER
SELECT FLOOR(AVG(POPULATION)) FROM CITY

# QUERY A LIST OF NAME WHOSE FRIEND MAKE A GREATER SALARY THAN THEM, ORDERED BY FRIEND SALARY
SELECT 
     A.NAME
--    ,C.SALARY
--    ,D.SALARY
FROM STUDENTS A
JOIN FRIENDS B
ON A.ID = B.ID
JOIN PACKAGES C
ON A.ID = C.ID
JOIN PACKAGES D
ON D.ID = B.FRIEND_ID
WHERE D.SALARY > C.SALARY
ORDER BY D.SALARY

# A CASHIER WAS WITH 0 KEYBOARD BROKEN AND CALCULATED ALL WITHOUT ZERO
# YOU MUST THE DIFFERENCE OF CORRECT RESULT AND CASHIER RESULT 
# MUST REPLACE THE ZEROS FOR CASHIER CALCULATION
# REPLACE VALUES, CONVERT TO FLOAT IN CASE OF AVG
SELECT CAST(CEILING((AVG(CAST(Salary AS Float)) 
        - AVG(CAST(REPLACE(Salary, 0, '')AS Float)))) AS INT)
FROM EMPLOYEES;

# SYMETRIC PAIRS
## right solution
;WITH CTE_Functions
AS
(
    SELECT X, Y, ROW_NUMBER() OVER (PARTITION BY (X + Y), ABS(X-Y) ORDER BY X DESC) AS RowNumber
    FROM Functions WITH (NOLOCK)    
)
SELECT DISTINCT X, Y
FROM CTE_Functions
WHERE RowNumber > 1
AND X <= Y

## other solution
SELECT f1.X, f1.Y FROM Functions f1
INNER JOIN Functions f2 ON f1.X=f2.Y AND f1.Y=f2.X
GROUP BY f1.X, f1.Y
HAVING COUNT(f1.X)>1 or f1.X<f1.Y
ORDER BY f1.X 

"The criteria in the having clause allows us to prevent duplication in our output while 
still achieving our goal of finding mirrored pairs. We have to treat our pairs 
where f1.x = f1.y and f1.x <> f1.y differently to capture both. The first criteria
 handles pairs where f1.x = f1.y and the 2nd criteria handles pairs where f1.x <> f1.y,
  which is why the or operator is used.
The first part captures records where f1.x = f1.y. The 'count(f1.x) > 1' requires there 
to be at least two records of a mirrored pair to be pulled through. Without this 
a pair would simply match with itself (since it's already it's own mirrored pair) 
and be pulled through incorrectly when you join the table on itself. The 2nd part matches 
the remaining mirrored pairs. It's important to note that for this challenge, 
the mirrored match of (f1.x,f1.y) is considered a duplicate and excluded from 
the final output. You can see this in the sample output where (20, 21) is outputted, 
but not (21,20). The 'or f1.x < f1.y' criteria allows us to pull all those pairs 
where f1.x does not equal f1.y, but where f1.x is also less than f1.y so we don't 
end up with the mirrored paired duplicate.
"
## my solution 
WITH A AS (
SELECT
     X
    ,Y
    ,LAG(X,1) OVER (ORDER BY X ASC) AS X2
    ,LAG(Y,1) OVER (ORDER BY X ASC) AS Y2
FROM FUNCTIONS 
)
SELECT X,Y FROM A
WHERE X = Y2 AND X2 = Y
AND X <= Y

# BYNARY TREE NODES - LEAF, ROOT OR INNER
## MY SOLUTION 
WITH C AS (
SELECT 
     A.N AS N
    ,A.P AS P
    ,B.P AS FLAG
FROM BST A 
LEFT JOIN BST B
ON A.N = B.P )
SELECT DISTINCT
    N
    , CASE WHEN P IS NULL THEN "Root"
      WHEN FLAG IS NULL THEN "Leaf"
      ELSE "Inner" END AS label
FROM C