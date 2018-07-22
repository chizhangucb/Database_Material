/************************************************************** 
  Change the working directory to the directory where the
  rating.sql file is stored. Run the following code in SQLite
  .cd Desktop/Introduction-to-Database/Quizzes/SQL
/**************************************************************/

/***************************************************************
  Q1. Find the titles of all movies directed by Steven Spielberg
***************************************************************/

SELECT title FROM Movie
WHERE director = "Steven Spielberg";

/***************************************************************
  Q2. Find all years that have a movie that received 
  a rating of 4 or 5, and sort them in increasing order
***************************************************************/

SELECT year FROM Movie
WHERE mID in (SELECT DISTINCT mID FROM Rating
              WHERE stars = 4.0 OR stars = 5.0)
ORDER BY year;

/***************************************************************
  Q3. Find the titles of all movies that have no ratings. 
***************************************************************/

SELECT title FROM Movie
where mID NOT In (SELECT DISTINCT mID FROM Rating);

/***************************************************************
  Q4. Some reviewers didn't provide a date with their rating. 
  Find the names of all reviewers who have ratings with 
  a NULL value for the date. 
***************************************************************/

SELECT name FROM Reviewer
WHERE rID in (SELECT DISTINCT rID FROM Rating
              WHERE ratingDate IS NULL);

/***************************************************************
  Q5. Write a query to return the ratings data in a more readable 
  format: reviewer name, movie title, stars, and ratingDate. 
  Also, sort the data, first by reviewer name, 
  then by movie title, and lastly by number of stars. 
***************************************************************/

SELECT name, title, stars, ratingDate
FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie
ORDER BY name, title, stars;

/***************************************************************
  Q6. For all cases where the same reviewer rated the same movie 
  twice and gave it a higher rating the second time, 
  return the reviewer's name and the title of the movie. 
***************************************************************/

SELECT name, title
FROM Reviewer NATURAL JOIN Rating NATURAL JOIN Movie NATURAL JOIN
     (SELECT rID, mID FROM Rating 
      WHERE ratingDate IS NOT NULL 
      GROUP BY rID, mID
      HAVING count(*) = 2)
GROUP BY Reviewer.rID
HAVING ratingDate = max(ratingDate) AND stars = max(stars);

/***************************************************************
  Q7. For each movie that has at least one rating, 
  find the highest number of stars that movie received. 
  Return the movie title and number of stars. Sort by movie title. 
***************************************************************/

SELECT title, MAX(stars)
FROM Movie NATURAL JOIN Rating
GROUP BY title
ORDER BY title;

/***************************************************************
  Q8. For each movie, return the title and the 'rating spread', 
  that is, the difference between highest and lowest ratings 
  given to that movie. Sort by rating spread from 
  highest to lowest, then by movie title. 
***************************************************************/

SELECT title, (MAX(stars) - MIN(stars)) as "rating spread"
FROM Movie NATURAL JOIN Rating
GROUP BY title
ORDER BY "rating spread" DESC, title;

/***************************************************************
  Q9. Find the difference between the average rating of movies 
  released before 1980 and the average rating of movies released 
  after 1980. (Make sure to calculate the average rating for 
  each movie, then the average of those averages for movies 
  before 1980 and movies after. Don't just calculate the 
  overall average rating before and after 1980.) 
***************************************************************/
SELECT Before1980.avgStars - After1980.avgStars
FROM (SELECT AVG(avgPerMovie) as avgStars
      FROM (SELECT *, AVG(stars) as avgPerMovie 
            FROM Rating 
            WHERE mID IN (SELECT mID  FROM Movie WHERE year < 1980) 
            GROUP BY mID)) AS Before1980, 
     (SELECT AVG(avgPerMovie) as avgStars
      FROM (SELECT *, AVG(stars) as avgPerMovie 
            FROM Rating 
            WHERE mID IN (SELECT mID  FROM Movie WHERE year >= 1980) 
            GROUP BY mID)) AS After1980;