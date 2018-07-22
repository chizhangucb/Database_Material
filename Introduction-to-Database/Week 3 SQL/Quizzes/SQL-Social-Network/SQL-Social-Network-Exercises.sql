/************************************************************** 
  Change the working directory to the directory where the
  rating.sql file is stored. Run the following code in SQLite
  .cd Desktop/Introduction-to-Database/Quizzes/SQL
/**************************************************************/

/***************************************************************
  Q1. Find the names of all reviewers who rated Gone with the Wind. 
***************************************************************/

SELECT name FROM Highschooler
WHERE ID IN (SELECT DISTINCT ID2 FROM Friend 
             WHERE ID1 IN (SELECT ID FROM Highschooler 
                           WHERE name = "Gabriel"));

/***************************************************************
  Q2. For every student who likes someone 2 or more grades 
  younger than themselves, return that student's name and grade, 
  and the name and grade of the student they like. 
***************************************************************/

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Likes, Highschooler H2
WHERE H1.ID = ID1 AND ID2 = H2.ID AND H1.grade - H2.grade >= 2;

/***************************************************************
  Q3. For every pair of students who both like each other, 
  return the name and grade of both students. Include each pair 
  only once, with the two names in alphabetical order. 
***************************************************************/

/*** This one didn't work on the website back-end SQLite ***/
/*** It seems (ID2, ID1) is NOT allowed here ***/

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, 
     (SELECT ID1, ID2  
      FROM Likes 
      WHERE (ID2, ID1) IN (SELECT * FROM Likes) AND ID1 < ID2),
     Highschooler H2
WHERE H1.ID = ID1 AND H2.ID = ID2;

/*** Alternative, using EXISTS ***/
/*** Caution: For name alphabetical order, ID1 < ID2 not Working ***/

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2,
     (SELECT ID1, ID2  
      FROM Likes L1
      WHERE EXISTS (SELECT * FROM likes L2
                    WHERE  L1.ID1 = L2.ID2 AND L1.ID2 = L2.ID1))
WHERE H1.ID = ID1 AND H2.ID = ID2 AND H1.name < H2.name;

/***************************************************************
  Q4. Find all students who do not appear in the Likes table 
  (as a student who likes or is liked) and return their names 
  and grades. Sort by grade, then by name within each grade. 
***************************************************************/

SELECT name, grade FROM Highschooler
WHERE ID NOT IN (SELECT ID1 FROM Likes
                 UNION
                 SELECT ID2 FROM Likes)
ORDER BY grade, name;

/***************************************************************
  Q5. For every situation where student A likes student B, 
  but we have no information about whom B likes (that is, 
  B does not appear as an ID1 in the Likes table), 
  return A and B's names and grades. 
***************************************************************/

SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2,
     (SELECT ID1, ID2  
      FROM Likes L1
      WHERE NOT EXISTS (SELECT * FROM likes L2
                        WHERE  L1.ID1 = L2.ID2 AND L1.ID2 = L2.ID1)
            AND L1.ID2 NOT IN (SELECT ID1 FROM Likes))
WHERE H1.ID = ID1 AND H2.ID = ID2;


/***************************************************************
  Q6. Find names and grades of students who only have friends 
  in the same grade. Return the result sorted by grade, 
  then by name within each grade. 
***************************************************************/

SELECT name, grade FROM Highschooler
WHERE ID NOT IN (SELECT DISTINCT ID1
                 FROM Highschooler H1, Friend, Highschooler H2
                 WHERE H1.ID = ID1 AND ID2 = H2.ID AND 
                       H1.grade <> H2.grade)
ORDER BY grade, name;

/***************************************************************
  Q7. For each student A who likes a student B where the two 
  are not friends, find if they have a friend C in common 
  (who can introduce them!). For all such trios, return the 
  name and grade of A, B, and C. 
***************************************************************/

SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3,
     (SELECT Friend.ID1 AS A, Friend.ID2 AS C, New.ID2 AS B 
      FROM Friend JOIN 
           (SELECT * FROM Likes 
            WHERE NOT EXISTS 
                (SELECT * FROM Friend 
                 WHERE Likes.ID1 = Friend.ID1 AND Likes.ID2 = Friend.ID2)) AS New
            USING(ID1) 
            WHERE EXISTS (SELECT * FROM Friend 
                          WHERE B = Friend.ID1 AND C = Friend.ID2))
WHERE H1.ID = A AND H2.ID = B AND H3.ID = C;

/***************************************************************
  Q8. Find the difference between the number of students in 
  the school and the number of different first names. 
***************************************************************/

SELECT COUNT(name) - COUNT(DISTINCT name) 
FROM Highschooler;

/***************************************************************
  Q9. Find the name and grade of all students who are 
  liked by more than one other student. 
***************************************************************/

SELECT name, grade
FROM Highschooler
WHERE ID IN (SELECT ID2 FROM Likes
             GROUP BY ID2
             HAVING COUNT(*) > 1);
