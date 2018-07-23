/************************************************************** 
  Change the working directory to the directory where the
  rating.sql file is stored. Run the following code in SQLite
  .cd ~/Introduction-to-Database/Week 9 OLAP & Recursion/Quizzes
/**************************************************************/

/***************************************************************
  Q1. Find all students who took a class in California from an 
  instructor not in the student's major department and got a 
  score over 80. Return the student name, university, and score.
***************************************************************/

SELECT S.name, C.univ, T.score 
FROM Student S, Instructor I, Class C, Took T
WHERE S.studID = T.studID AND I.instID = T.instID AND C.classID = T.classID
      AND C.region = "CA" AND I.dept <> S.major AND T.score > 80;


/***************************************************************
  Q2. Find average scores grouped by student and instructor 
  for courses taught in Quebec.
***************************************************************/

SELECT studID, instID, AVG(T.score) 
FROM Class C, Took T
WHERE C.classID = T.classID AND C.region = "Quebec"
GROUP BY studID, instID;


/***************************************************************
  Q3. "Roll up" your result from problem 2 so it's grouping by 
  instructor only.
***************************************************************/

SELECT instID, AVG(score) 
FROM Class C, Took T
WHERE C.classID = T.classID AND C.region = "Quebec"
GROUP BY instID;


/***************************************************************
  Q4. Find average scores grouped by student major.
***************************************************************/

SELECT major, AVG(score) 
FROM Student S, Took T
WHERE S.studID = T.studID
GROUP BY major;


/***************************************************************
  Q5. "Drill down" on your result from problem 4 so it's grouping 
  by instructor's department as well as student's major.
***************************************************************/

SELECT dept, major, AVG(score) 
FROM Student S, Instructor I, Took T
WHERE S.studID = T.studID AND I.instID = T.instID 
GROUP BY dept, major;


/***************************************************************
  Q6. Use "WITH ROLLUP" on attributes of table Class to get average 
  scores for all geographical granularities: by country, region, 
  and university, as well as the overall average.
***************************************************************/

SELECT country, region, univ, AVG(score) 
FROM Class C, Took T
WHERE C.classID = T.classID 
GROUP BY country, region, univ WITH ROLLUP;


/***************************************************************
  Q7. Create a table containing the result of your query from 
  problem 6. Then use the table to determine by how much students 
  from USA outperform students from Canada in their average score.
***************************************************************/

DROP TABLE IF EXISTS avgScore;

CREATE TABLE avgScore AS 
SELECT country, region, univ, AVG(score) AS avgS
FROM Class C, Took T
WHERE C.classID = T.classID 
GROUP BY country, region, univ WITH ROLLUP;

SELECT A1.avgS - A2.avgS AS outperformS
FROM avgScore A1, avgScore A2
WHERE A1.country = "USA" AND A1.region IS NULL AND A1.univ IS NULL
  AND A2.country = "Canada" AND A2.region IS NULL AND A2.univ IS NULL;


/***************************************************************
  Q8. Verify your result for problem 7 by writing the same 
  query over the original tables without using "WITH ROLLUP".
***************************************************************/

SELECT A1.avgS - A2.avgS AS outperformS
FROM (SELECT country, AVG(score) AS avgS
      FROM Class C, Took T
      WHERE C.classID = T.classID AND country = "USA"
      GROUP BY country) A1,
     (SELECT country, AVG(score) AS avgS
      FROM Class C, Took T
      WHERE C.classID = T.classID AND country = "Canada"
      GROUP BY country) A2;


/***************************************************************
  Q9. Create the following table that simulates the unsupported 
      "WITH CUBE" operator. Using table Cube instead of table Took, 
      and taking advantage of the special tuples with NULLs, find 
      the average score of CS major students taking a course at MIT.
***************************************************************/

DROP TABLE IF EXISTS Cube1;

create table Cube1 as
select studID, instID, classID, avg(score) as s from Took
group by studID, instID, classID with rollup
union
select studID, instID, classID, avg(score) as s from Took
group by instID, classID, studID with rollup
union
select studID, instID, classID, avg(score) as s from Took
group by classID, studID, instID with rollup;      

SELECT * FROM Cube1 LIMIT 20;

SELECT AVG(CU.s)
FROM Cube1 CU, Student S, Class C
WHERE S.studID = CU.studID AND C.classID = CU.classID
  AND univ = "MIT" AND S.major = "CS" AND CU.instID IS NULL;


/***************************************************************
  Q10. Verify your result for problem 9 by writing the same 
  query over the original tables.
***************************************************************/

SELECT AVG(score)
FROM Student S, Class C, Took T
WHERE S.studID = T.studID AND C.classID = T.classID
  AND univ = "MIT" AND major = "CS";


/***************************************************************
  Q11. Whoops! Did you get a different answer for problem 10 than 
  you got for problem 9? What went wrong? Assuming the answer on 
  the original tables is correct, create a slightly different 
  data cube that allows you to get the correct answer using the 
  special NULL tuples in the cube. Hint: Change what dependent 
  value(s) you store in the cells of the cube; no change to the 
  overall structure of the query or the cube is needed.
***************************************************************/

DROP TABLE IF EXISTS Cube2;

create table Cube2 as
select studID, instID, classID, avg(score) AS avgS, count(score) as ctS from Took
group by studID, instID, classID with rollup
union
select studID, instID, classID, avg(score) AS avgS, count(score) as ctS from Took
group by instID, classID, studID with rollup
union
select studID, instID, classID, avg(score) AS avgS, count(score) as ctS from Took
group by classID, studID, instID with rollup;      

SELECT * FROM Cube2 LIMIT 20;

SELECT sum(avgS * ctS) / sum(ctS)
FROM Cube2 CU, Student S, Class C
WHERE S.studID = CU.studID AND C.classID = CU.classID
  AND univ = "MIT" AND S.major = "CS" AND CU.instID IS NULL;
/** The result looks slightly different due to rounding issue, 
    but it should be correct. **/

/***************************************************************
 Cheating way:

create table Cube2 as
select studID, instID, classID, avg(score) as s from Took
group by studID, instID, classID, score with rollup
union
select studID, instID, classID, avg(score) as s from Took
group by instID, classID, studID, score with rollup
union
select studID, instID, classID, avg(score) as s from Took
group by classID, studID, instID, score with rollup;

SELECT AVG(s) 
FROM Cube2 CU, Student S, Class C
WHERE S.studID = CU.studID AND C.classID = CU.classID
  AND univ = "MIT" AND S.major = "CS" AND CU.instID IS NOT NULL;
***************************************************************/


/***************************************************************
  Q12. Continuing with your revised cube from problem 11, compute 
  the same value but this time don't use the NULL tuples (but
  don't use table Took either). Hint: The syntactic change is very 
  small and of course the answer should not change.
***************************************************************/

SELECT sum(avgS * ctS) / sum(ctS)
FROM Cube2 CU, Student S, Class C
WHERE S.studID = CU.studID AND C.classID = CU.classID
  AND univ = "MIT" AND S.major = "CS" AND CU.instID IS NOT NULL;