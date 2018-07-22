/************************************************************** 
  Change the working directory to the directory where the
  rating.sql file is stored. Run the following code in SQLite
  .cd Desktop/Introduction-to-Database/Quizzes/SQL
/**************************************************************/

/***************************************************************
  Q1. Find the names of all reviewers who rated Gone with the Wind. 
***************************************************************/

SELECT DISTINCT name
FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie
WHERE title = "Gone with the Wind";

/***************************************************************
  Q2. For any rating where the reviewer is the same as 
  the director of the movie, return the reviewer name, 
  movie title, and number of stars. 
***************************************************************/

SELECT name, title, stars
FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie
WHERE director = name;

/***************************************************************
  Q3. Return all reviewer names and movie names together in a 
  single list, alphabetized. (Sorting by the first name of 
  the reviewer and first word in the title is fine; no need 
  for special processing on last names or removing "The".) 
***************************************************************/

SELECT name FROM Reviewer
UNION 
SELECT title FROM Movie
ORDER BY name;

/***************************************************************
  Q4. Find the titles of all movies not reviewed by Chris Jackson. 
***************************************************************/

SELECT DISTINCT title FROM Movie
WHERE mID not in 
   (SELECT mID
    FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie
    WHERE name = "Chris Jackson");

/***************************************************************
  Q5. For all pairs of reviewers such that both reviewers gave 
  a rating to the same movie, return the names of both reviewers. 
  Eliminate duplicates, don't pair reviewers with themselves, 
  and include each pair only once. For each pair, return the 
  names in the pair in alphabetical order. 
***************************************************************/


SELECT DISTINCT Joint1.name, Joint2.name
FROM (Reviewer NATURAL JOIN Rating NATURAL JOIN Movie) as Joint1,
     (Reviewer NATURAL JOIN Rating NATURAL JOIN Movie) as Joint2
WHERE Joint1.mID = Joint2.mID AND Joint1.name < Joint2.name
ORDER BY Joint1.name;

/***************************************************************
  Q6. For each rating that is the lowest (fewest stars) 
  currently in the database, return the reviewer name, 
  movie title, and number of stars. 
***************************************************************/

SELECT name, title, stars
FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie
WHERE stars = (SELECT MIN(stars) FROM Rating);

/***************************************************************
  Q7. List movie titles and average ratings, from highest-rated 
  to lowest-rated. If two or more movies have the same average 
  rating, list them in alphabetical order. 
***************************************************************/

SELECT title, AVG(stars) AS avgStar
FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie
GROUP BY title
ORDER BY avgStar DESC, title;

/***************************************************************
  Q8. Find the names of all reviewers who have contributed three 
  or more ratings. (As an extra challenge, try writing the query 
  without HAVING or without COUNT.) 
***************************************************************/

SELECT name
FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie
GROUP BY rID
HAVING COUNT(*) >= 3;

/*** without HAVING ***/

SELECT name 
FROM (SELECT name, COUNT(*) >=3 AS ifover3
      FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie
      GROUP BY rID)
WHERE ifover3 = 1;

/***************************************************************
  Q9. Some directors directed more than one movie. For all such 
  directors, return the titles of all movies directed by them, 
  along with the director name. Sort by director name, then 
  movie title. (As an extra challenge, try writing the query 
  both with and without COUNT.) 
***************************************************************/

/*** witH COUNT ***/

SELECT title, director FROM Movie
WHERE director IN (SELECT director FROM Movie
                   WHERE director IS NOT NULL
                   GROUP BY director 
                   HAVING COUNT(distinct title) > 1)
ORDER BY director, title;

/*** without COUNT ***/

SELECT title, director FROM Movie
WHERE director IN (SELECT M1.director
                   FROM Movie M1, Movie M2
                   WHERE M1.director = M2.director AND M1.title < M2. title)
ORDER BY director, title;

/***************************************************************
  Q10. Find the movie(s) with the highest average rating. 
  Return the movie title(s) and average rating. 
  (Hint: This query is more difficult to write in SQLite than 
  other systems; you might think of it as finding the highest 
  average rating and then choosing the movie(s) with 
  that average rating.) 
***************************************************************/

/*** This one didn't work on the website back-end SQLite ***/

SELECT title, MAX(avgStars)
FROM (SELECT title, AVG(stars) as avgStars 
      FROM Rating NATURAL JOIN Movie
      GROUP BY mID);

/*** Alternative, more general command ***/

SELECT * 
FROM (SELECT title, AVG(stars) as avgStars 
      FROM Rating NATURAL JOIN Movie
      GROUP BY mID) 
WHERE avgStars = (SELECT MAX(avgStars) 
                  FROM (SELECT title, AVG(stars) as avgStars 
                        FROM Rating NATURAL JOIN Movie
                        GROUP BY mID));

/***************************************************************
  Q11. Find the movie(s) with the lowest average rating. 
  Return the movie title(s) and average rating. 
  (Hint: This query may be more difficult to write in SQLite 
  than other systems; you might think of it as finding the 
  lowest average rating and then choosing the movie(s) with 
  that average rating.) 
***************************************************************/
      
SELECT * 
FROM (SELECT title, AVG(stars) as avgStars 
      FROM Rating NATURAL JOIN Movie
      GROUP BY mID) 
WHERE avgStars = (SELECT MIN(avgStars) 
                  FROM (SELECT title, AVG(stars) as avgStars 
                        FROM Rating NATURAL JOIN Movie
                        GROUP BY mID));

/***************************************************************
  Q12. For each director, return the director's name together 
  with the title(s) of the movie(s) they directed that received 
  the highest rating among all of their movies, and the value 
  of that rating. Ignore movies whose director is NULL. 
***************************************************************/
 
SELECT director, title, MAX(stars)
FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie
WHERE director IS NOT NULL
GROUP BY director