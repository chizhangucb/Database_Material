/************************************************************** 
  Change the working directory to the directory where the
  rating.sql file is stored. Run the following code in SQLite
  .cd Desktop/Introduction-to-Database/Quizzes/SQL
/**************************************************************/

/***************************************************************
  Q1. It's time for the seniors to graduate. 
  Remove all 12th graders from Highschooler. 
***************************************************************/

DELETE FROM Highschooler
WHERE grade = 12;

/***************************************************************
  Q2. If two students A and B are friends, and A likes B but 
  not vice-versa, remove the Likes tuple. 
***************************************************************/

DELETE FROM Likes
WHERE ID1 IN (SELECT ID1 FROM Likes L1
              WHERE NOT EXISTS (SELECT * FROM Likes L2 
                                WHERE L1.ID1 = L2.ID2 AND L1.ID2 = L2.ID1) 
                    AND 
                    EXISTS (SELECT * FROM Friend 
                            WHERE L1.ID1 = Friend.ID1 AND L1.ID2 = Friend.ID2))
      AND 
      ID2 IN (SELECT ID2 FROM Likes L1
              WHERE NOT EXISTS (SELECT * FROM Likes L2 
                                WHERE L1.ID1 = L2.ID2 AND L1.ID2 = L2.ID1) 
                    AND 
                    EXISTS (SELECT * FROM Friend 
                            WHERE L1.ID1 = Friend.ID1 AND L1.ID2 = Friend.ID2));


/*** This one didn't work on the website back-end SQLite ***/
/*** But in general it's correct ***/

DELETE FROM Likes
WHERE (ID1, ID2) IN (SELECT ID1, ID2 FROM Likes L1
                     WHERE NOT EXISTS (SELECT * FROM Likes L2 
                                       WHERE L1.ID1 = L2.ID2 AND L1.ID2 = L2.ID1) 
                           AND 
                           EXISTS (SELECT * FROM Friend 
                                   WHERE L1.ID1 = Friend.ID1 AND L1.ID2 = Friend.ID2));

/*** Alternative, a shorter version ***/                                   
DELETE FROM Likes
where EXISTS (SELECT 1 FROM Friend 
              WHERE Likes.ID1 = Friend.ID1 AND Likes.ID2 = Friend.ID2)
      AND
      NOT EXISTS (SELECT 1 FROM Likes L2 
                  WHERE Likes.ID1 = L2.ID2 AND Likes.ID2 = L2.ID1);

/***************************************************************
  Q3. For all cases where A is friends with B, and 
  B is friends with C, add a new friendship for the pair A and C. 
  Do not add duplicate friendships, friendships that already exist, 
  or friendships with oneself. (This one is a bit challenging; 
  congratulations if you get it right.) 
***************************************************************/

INSERT INTO Friend (id1, id2)
SELECT DISTINCT A, C 
FROM (SELECT F1.ID1 AS A, F1.ID2 AS B, F2.ID2 AS C
      FROM Friend F1 INNER JOIN Friend F2
      ON F1.ID2 = F2.ID1) AS New
WHERE A <> C AND 
      NOT EXISTS (SELECT * FROM Friend WHERE A = ID1 AND C = ID2) AND
      NOT EXISTS (SELECT * FROM Friend WHERE A = ID2 AND C = ID1)