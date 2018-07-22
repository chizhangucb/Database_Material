/************************************************************** 
  Change the working directory to the directory where the
  rating.sql file is stored. Run the following code in SQLite
  .cd Desktop/Introduction-to-Database/Quizzes/DB11
/**************************************************************/

/***************************************************************
  Q1. Write a trigger that makes new students named 'Friendly' 
  automatically like everyone else in their grade. That is, 
  after the trigger runs, we should have ('Friendly', A) in the 
  Likes table for every other Highschooler A in the same grade 
  as 'Friendly'.
***************************************************************/

create trigger R1
after insert on Highschooler 
for each row
when New.name = 'Friendly'
begin 
  insert into Likes select New.ID, ID from Highschooler where grade = New.grade;
end;
  
/*** Verified by 
insert into Highschooler values (1000, 'Friendly', 9);
insert into Highschooler values (2000, 'Friendly', 11);
insert into Highschooler values (3000, 'Unfriendly', 10);  
***/


/***************************************************************
  Q2. Write one or more triggers to manage the grade attribute of 
  new Highschoolers. If the inserted tuple has a value less than 
  9 or greater than 12, change the value to NULL. On the other hand, 
  if the inserted tuple has a null value for grade, change it to 9. 
***************************************************************/

CREATE TRIGGER R2
AFTER INSERT ON Highschooler
FOR EACH ROW
WHEN New.grade < 9 OR New.grade > 12 OR New.grade IS NULL
BEGIN 
  UPDATE Highschooler SET grade = NULL WHERE ID = New.ID AND New.grade IS NOT NULL;
  UPDATE Highschooler SET grade = 9 WHERE ID = New.ID AND New.grade IS NULL;
END;

/*** Verified by
insert into Highschooler values (2121, 'Caitlin', null);
insert into Highschooler values (2122, 'Don', null);
insert into Highschooler values (2123, 'Elaine', 7);
insert into Highschooler values (2124, 'Frank', 20);
insert into Highschooler values (2125, 'Gale', 10);
***/


/***************************************************************
  Q3. Write one or more triggers to maintain symmetry in friend 
  relationships. Specifically, if (A,B) is deleted from Friend, 
  then (B,A) should be deleted too. If (A,B) is inserted into 
  Friend then (B,A) should be inserted too. 
  Don't worry about updates to the Friend table. 
***************************************************************/

CREATE TRIGGER R3
AFTER INSERT ON Friend 
FOR EACH ROW
BEGIN 
  INSERT INTO Friend VALUES (New.ID2, New.ID1);
END; | 

CREATE TRIGGER R4
AFTER DELETE ON Friend 
FOR EACH ROW
BEGIN 
  DELETE FROM Friend WHERE ID1 = Old.ID2 AND ID2 = Old.ID1;
END;

/*** Verified by
delete from Friend where ID1 = 1641 and ID2 = 1468;
delete from Friend where ID1 = 1247 and ID2 = 1911;
insert into Friend values (1510, 1934);
insert into Friend values (1101, 1709);
***/


/***************************************************************
  Q4. Write a trigger that automatically deletes students when 
  they graduate, i.e., when their grade is updated to exceed 12. 
***************************************************************/

CREATE TRIGGER R5
AFTER UPDATE OF grade on Highschooler 
FOR EACH ROW
WHEN New.grade > 12
BEGIN 
  DELETE FROM Highschooler WHERE ID = New.ID;
END; 

/*** Verified by
update Highschooler set grade = grade + 1 
where name = 'Austin' or name = 'Kyle' or name = 'Logan'. 
***/


/***************************************************************
  Q5. Write a trigger that automatically deletes students when 
  they graduate, i.e., when their grade is updated to exceed 12 
  (same as Question 4). In addition, write a trigger so when a 
  student is moved ahead one grade, then so are all of 
  his or her friends. 
***************************************************************/

CREATE TRIGGER R6
AFTER UPDATE OF grade on Highschooler 
FOR EACH ROW
WHEN New.grade > 12
BEGIN 
  DELETE FROM Highschooler WHERE ID = New.ID;
END; | 

CREATE TRIGGER R7
AFTER UPDATE OF grade on Highschooler 
FOR EACH ROW
BEGIN 
  UPDATE Highschooler
  SET grade = grade + 1
  WHERE ID IN (SELECT ID2 FROM Friend WHERE ID1 = New.ID);
END; 

/*** Verified by
update Highschooler set grade = grade + 1
where name = 'Austin' or name = 'Kyle' or name = 'Logan';
***/


/***************************************************************
  Q6. Write a trigger to enforce the following behavior: 
  If A liked B but is updated to A liking C instead, 
  and B and C were friends, make B and C no longer friends. 
  Don't forget to delete the friendship in both directions, 
  and make sure the trigger only runs when the "liked" (ID2) 
  person is changed but the "liking" (ID1) person is not changed. 
***************************************************************/

CREATE TRIGGER R8
AFTER UPDATE OF ID2 ON Likes 
FOR EACH ROW 
WHEN EXISTS (SELECT * FROM Friend WHERE ID1 = New.ID2 AND ID2 = Old.ID2)
     AND New.ID1 = Old.ID1 AND New.ID2 <> Old.ID2
BEGIN 
  DELETE FROM Friend WHERE ID1 = New.ID2 AND ID2 = Old.ID2;
  DELETE FROM Friend WHERE ID1 = Old.ID2 AND ID2 = New.ID2;
END;

/*** Verified by
update Likes set ID2 = 1501 where ID1 = 1911; 
pdate Likes set ID2 = 1316 where ID1 = 1501; 
update Likes set ID2 = 1304 where ID1 = 1934; 
update Likes set ID1 = 1661, ID2 = 1641 where ID1 = 1025; 
Supdate Likes set ID2 = 1468 where ID1 = 1247. 
***/