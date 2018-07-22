Indexes Quiz Ungraded
=======================

Question 1
--------------------
Consider the following query:
```SQL
   Select * From Apply, College
   Where Apply.cName = College.cName
   And Apply.major = 'CS' and College.enrollment < 5000
```

Which of the following indexes could NOT be useful in speeding up query execution?

* Tree-based index on Apply.cName
* Hash-based index on Apply.major
* Hash-based index on College.enrollment
* Hash-based index on College.cName

**Answer:** 
* Hash-based index on College.enrollment

**Explanation:** 
Hash-based indexes can only be used for equality conditions.


Question 2
-------------------
Consider the following query:
```SQL
   Select * From Student, Apply, College
   Where Student.sID = Apply.sID and Apply.cName = College.cName
   And Student.GPA > 1.5 And College.cName < 'Cornell'
```
Suppose we are allowed to create two indexes, and assume all indexes are tree-based. Which two indexes do you think would be most useful for speeding up query execution?

* Student.sID, College.cName
* Student.sID, Student.GPA
* Apply.cName, College.cName
* Apply.sID, Student.GPA

**Answer:** 
* Student.sID, College.cName

**Explanation:** 
An index on Student.sID can be used for its join condition and an index on College.cName can be used for both its join condition and 'cName < Cornell.' An index on Student.GPA is unlikely to be helpful since most students satisfy GPA > 1.5. Indexing both Apply.cName and College.cName helps with only one join condition.
