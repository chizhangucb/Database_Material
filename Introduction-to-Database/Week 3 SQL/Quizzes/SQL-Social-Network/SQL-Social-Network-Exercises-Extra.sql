/************************************************************** 
  Change the working directory to the directory where the
  rating.sql file is stored. Run the following code in SQLite
  .cd Desktop/Introduction-to-Database/Quizzes/SQL
/**************************************************************/

/***************************************************************
  Q1. For every situation where student A likes student B, 
  but student B likes a different student C, 
  return the names and grades of A, B, and C. 
***************************************************************/

SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3,
     (SELECT L1.ID1 AS A, L1.ID2 AS B, L2.ID2 AS C
      FROM Likes L1, Likes L2 
      WHERE L1.ID2 = L2.ID1 AND A <> C)
WHERE H1.ID = A AND H2.ID = B AND H3.ID = C;
      
/***************************************************************
  Q2. Find those students for whom all of their friends are in 
  different grades from themselves. 
  Return the students' names and grades. 
***************************************************************/

SELECT name, grade FROM Highschooler
WHERE ID NOT IN (SELECT DISTINCT ID1
                 FROM Highschooler H1, Friend, Highschooler H2
                 WHERE H1.ID = ID1 AND ID2 = H2.ID AND 
                       H1.grade = H2.grade);

/***************************************************************
  Q3. What is the average number of friends per student? 
  (Your result should be just one number.) 
***************************************************************/

SELECT AVG(numF) 
FROM (SELECT COUNT(*) AS numF 
      FROM Friend 
      GROUP BY ID1);

/***************************************************************
  Q4. Find the number of students who are either friends with 
  Cassandra or are friends of friends of Cassandra. Do not count 
  Cassandra, even though technically she is a friend of a friend. 
***************************************************************/

SELECT COUNT(*)
FROM (SELECT ID2 FROM Friend 
      WHERE ID1 = (SELECT ID FROM Highschooler 
                   WHERE name = "Cassandra")
      UNION
      SELECT ID2 FROM Friend 
      WHERE ID1 IN (SELECT ID2 FROM Friend 
                    WHERE ID1 = (SELECT ID FROM Highschooler 
                                 WHERE name = "Cassandra")))
WHERE ID2 <> (SELECT ID FROM Highschooler WHERE name = "Cassandra")

/***************************************************************
  Q5. Find the name and grade of the student(s) with 
  the greatest number of friends.  
***************************************************************/

SELECT name, grade 
FROM Highschooler NATURAL JOIN 
     (SELECT COUNT(*) AS numF, ID1 AS ID FROM Friend  GROUP BY ID1)
WHERE numF = (SELECT MAX(numF) FROM (SELECT COUNT(*) AS numF
                                     FROM Friend GROUP BY ID1));
 