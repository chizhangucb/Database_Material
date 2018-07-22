/************************************************************** 
  Change the working directory to the directory where the
  rating.sql file is stored. Run the following code in SQLite
  .cd ~/Introduction-to-Database/Week 8 Views and Authorization/Quizzes
/**************************************************************/

/***************************************************************
  Q1. Write an instead-of trigger that enables updates to the 
  title attribute of view LateRating. 

  Policy: Updates to attribute title in LateRating should update 
  Movie.title for the corresponding movie. (You may assume 
  attribute mID is a key for table Movie.) Make sure the mID 
  attribute of view LateRating has not also been updated -- 
  if it has been updated, don't make any changes. 
  Don't worry about updates to stars or ratingDate.
***************************************************************/

CREATE TRIGGER titleupdate
INSTEAD OF UPDATE OF title ON LateRating
FOR EACH ROW 
WHEN New.mID = Old.mID AND New.title <> Old.title
BEGIN
  UPDATE Movie
  SET title = New.title
  WHERE mID = New.mID;
END;

/*** Verified by 
update LateRating set title = 'Late Favorite' where stars > 2; 
update LateRating set mID = 100, title = 'Don't change';
select * from LateRating;
select * from Movie order by mID;
***/


/***************************************************************
  Q2. Write an instead-of trigger that enables updates to the 
  stars attribute of view LateRating. 

  Policy: Updates to attribute stars in LateRating should update 
  Rating.stars for the corresponding movie rating. (You may assume 
  attributes [mID,ratingDate] together are a key for table Rating.) 
  Make sure the mID and ratingDate attributes of view LateRating 
  have not also been updated -- if either one has been updated, 
  don't make any changes. Don't worry about updates to title.
***************************************************************/

CREATE TRIGGER starsupdate
INSTEAD OF UPDATE OF stars ON LateRating
FOR EACH ROW 
WHEN New.mID = Old.mID AND New.ratingDate = Old.ratingDate AND New.stars <> Old.stars
BEGIN
  UPDATE Rating
  SET stars = New.stars
  WHERE mID = New.mID AND ratingDate = New.ratingDate;
END;

/*** Verified by 
update LateRating set stars = stars - 2 where stars > 2; 
update LateRating set mID = 100, stars = stars + 2; 
update LateRating set ratingDate = null, stars = stars + 2. 
select * from LateRating;
select * from Rating order by mID, stars;
***/


/***************************************************************
  Q3. Write an instead-of trigger that enables updates to the 
  mID attribute of view LateRating. 

  Policy: Updates to attribute mID in LateRating should update 
  Movie.mID and Rating.mID for the corresponding movie. Update 
  all Rating tuples with the old mID, not just the ones contributing 
  to the view. Don't worry about updates to title, stars, or ratingDate.
***************************************************************/

CREATE TRIGGER mIDupdate
INSTEAD OF UPDATE OF mID ON LateRating
FOR EACH ROW 
WHEN New.mID <> Old.mID
BEGIN
  UPDATE Movie SET mID = New.mID WHERE mID = Old.mID;
  UPDATE Rating SET mID = New.mID WHERE mID = Old.mID; 
END;

/*** Verified by 
update LateRating set mID = mID+50 where stars = 2;
select * from LateRating;
select M.mID, title, stars from Movie M, Rating R 
where M.mID = R.mID order by M.mID, stars;
***/


/***************************************************************
  Q4. Finally, write a single instead-of trigger that combines 
  all three of the previous triggers to enable simultaneous 
  updates to attributes mID, title, and/or stars in view LateRating. 
  Combine the view-update policies of the three previous problems, 
  with the exception that mID may now be updated. Make sure the 
  ratingDate attribute of view LateRating has not also been updated 
  -- if it has been updated, don't make any changes.
***************************************************************/

CREATE TRIGGER allupdate
INSTEAD OF UPDATE ON LateRating
FOR EACH ROW 
WHEN New.ratingDate = Old.ratingDate
BEGIN
  UPDATE Movie SET title = New.title, mID = New.mID WHERE mID = Old.mID;
  UPDATE Rating SET stars = New.stars WHERE mID = Old.mID AND ratingDate = old.ratingDate; 
  UPDATE Rating SET mID = New.mID WHERE mID = Old.mID; 
END;

/*** Verified by 
update LateRating set mID = mID+50, title = 'Worth seeing', stars = 5 where stars >= 3; 
update LateRating set title = 'Mediocre', ratingDate = null where stars = 2;
select * from LateRating;
select M.mID, title, stars from Movie M, Rating R where M.mID = R.mID order by M.mID, stars;
***/


/***************************************************************
  Q5. Write an instead-of trigger that enables deletions from 
  view HighlyRated. 

  Policy: Deletions from view HighlyRated should delete all 
  ratings for the corresponding movie that have stars > 3.
***************************************************************/

CREATE TRIGGER deletehigh
INSTEAD OF DELETE ON HighlyRated
FOR EACH ROW 
BEGIN
  DELETE FROM Rating
  WHERE mID = Old.mID AND stars > 3;
END;

/*** Verified by 
delete from HighlyRated where mID > 106; 
select * from HighlyRated;
select * from Rating order by mID desc;
***/


/***************************************************************
  Q6. Write an instead-of trigger that enables deletions from 
  view HighlyRated. 

  Policy: Deletions from view HighlyRated should update all ratings 
  for the corresponding movie that have stars > 3 so they have stars = 3.
***************************************************************/

CREATE TRIGGER udpatehigh
INSTEAD OF DELETE ON HighlyRated
FOR EACH ROW 
BEGIN
  UPDATE Rating
  SET stars = 3
  WHERE mID = Old.mID AND stars > 3;
END;

/*** Verified by 
delete from HighlyRated where mID > 106; 
select * from HighlyRated;
select * from Rating order by mID desc;
***/


/***************************************************************
  Q7. Write an instead-of trigger that enables insertions into 
  view HighlyRated. 

  Policy: An insertion should be accepted only when the (mID,title) 
  pair already exists in the Movie table. (Otherwise, do nothing.) 
  Insertions into view HighlyRated should add a new rating for 
  the inserted movie with rID = 201, stars = 5, and NULL ratingDate.
***************************************************************/

CREATE TRIGGER inserthigh
INSTEAD OF INSERT ON HighlyRated
FOR EACH ROW 
WHEN EXISTS (SELECT * FROM Movie WHERE mID = New.mID AND title = New.title)
BEGIN
  INSERT INTO Rating VALUES (201, New.mID, 5, NULL);
END;

/*** Verified by 
Insert into HighlyRated values (104, 'E.T.'); 
insert into HighlyRated values (105, 'Titanic 2');
select * from HighlyRated;
select * from Rating order by stars desc, mID;
***/


/***************************************************************
  Q8. Write an instead-of trigger that enables insertions into 
  view NoRating. 

  Policy: An insertion should be accepted only when the (mID,title) 
  pair already exists in the Movie table. (Otherwise, do nothing.) 
  Insertions into view NoRating should delete all ratings for 
  the corresponding movie.
***************************************************************/

CREATE TRIGGER insertno
INSTEAD OF INSERT ON NoRating
FOR EACH ROW 
WHEN EXISTS (SELECT * FROM Movie WHERE mID = New.mID AND title = New.title)
BEGIN
  DELETE FROM Rating WHERE mID = New.mID;
END;

/*** Verified by 
Insert into NoRating values (104, 'E.T.'); 
insert into NoRating values (110, 'Avatar'). 
select * from NoRating;
select * from Rating order by mID;
***/


/***************************************************************
  Q9. Write an instead-of trigger that enables deletions from 
  view NoRating. 

  Policy: Deletions from view NoRating should delete the 
  corresponding movie from the Movie table.
***************************************************************/

CREATE TRIGGER deleteno_movie
INSTEAD OF DELETE ON NoRating
FOR EACH ROW 
WHEN EXISTS (SELECT * FROM Movie WHERE mID = Old.mID AND title = Old.title)
BEGIN
  DELETE FROM Movie WHERE title = Old.title AND title = Old.title;
END;

/*** Verified by 
delete from NoRating where title = 'Titanic';
select * from NoRating;
select * from Movie order by title;
***/


/***************************************************************
  Q10. Write an instead-of trigger that enables deletions from 
  view NoRating. 

  Policy: Deletions from view NoRating should add a new rating for 
  the deleted movie with rID = 201, stars = 1, and NULL ratingDate.
***************************************************************/

CREATE TRIGGER deleteno_rating
INSTEAD OF DELETE ON NoRating
FOR EACH ROW 
WHEN EXISTS (SELECT * FROM Movie WHERE mID = Old.mID AND title = Old.title)
BEGIN
  INSERT INTO Rating VALUES (201, Old.mID, 1, NULL);
END;