Indexes Quiz 
=======================

Question 1
--------------------
Consider the following relational schema: 
```SQL
   Course(courseName unique, department, instrID)
   Instructor(instrID unique, office)
   Student(studentID unique, major)
   Enroll(studentID, courseName, unique (studentID,courseName))
```
Suppose there are five types of queries commonly asked on this schema: 
*	Given a course name, find the department offering that course.
*	List all studentIDs together with all of the departments they are taking courses in.
*	Given a studentID, find the names of all courses the student is enrolled in.
*	List the offices of instructors teaching at least one course.
*	Given a major, return the studentIDs of students in that major.

Which of the following indexes could NOT be useful in speeding up execution of one or more of the above queries? 

* Index on Student.major
* Index on Instructor.instrID
* Index on Course.courseName
* Index on Course.department

**Answer:** 
* Index on Course.department

**Other possible answers:**
* Index on Student.studentID

**Explanation:** 
An index on an attribute R.A may be useful whenever a query has a selection condition on R.A, or does a join involving R.A.


Question 2
-------------------
Consider a table storing temperature readings taken by sensors: 
```SQL
   Temps(sensorID, time, temp)
```
Assume the pair of attributes [sensorID,time] is a key. Consider the following query: 
```SQL
   select * from Temps
   where sensorID = 'sensor541'
   and time = '05:11:02'
```
Consider the following scenarios:
* A - No index is present on any attribute of Temps
* B - An index is present on attribute sensorID only
* C - An index is present on attribute time only
* D - Separate indexes are present on attributes sensorID and time
* E - A multi-attribute index is present on (sensorID,time)

Suppose table Temps has 50 unique sensorIDs and each sensorID has exactly 20 readings. Furthermore there are exactly 10 readings for every unique time in Temps.

For each scenario A-E, determine the maximum number of tuples that might be accessed to answer the query, assuming one "best" index is used whenever possible. (Don't count the number of index accesses.) Which of the following combinations of values is correct? 

* A:1000, C:10, E:1
* C:1000, D:20, E:1
* A:1000, B:20, E:10
* B:1000, C:10, D:10

**Answer:** 
* A:1000, C:10, E:1

**Other possible answers:**
* B:20, D:10, E:1