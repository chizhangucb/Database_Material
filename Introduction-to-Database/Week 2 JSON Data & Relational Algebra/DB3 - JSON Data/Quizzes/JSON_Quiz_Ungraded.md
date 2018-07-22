JSON Quiz 
===============

Question 1
--------------------
You're creating a database to contain information about students in a class (name and ID), and class projects done in pairs (two students and a project title). Should you use the relational model or JSON?

* Relational
* JSON
* Either one is appropriate
* Neither is appropriate"

**Answer:** 
Relational
**Explanation:** 
The database has a fixed structure that lends itself to tables (one table for student information and one for project information) and convenient queries in a relational language.


Question 2
------------------------
You're creating a database to contain information about students in a class (name and ID), and class projects. Projects may include any combination of students; they have a title and optional additional information such as materials, approvals, and milestones. Should you use the relational model or JSON?

* Relational
* JSON
* Either one is appropriate
* Neither is appropriate"

**Answer:** 
JSON
**Explanation:** 
The database has a complex, irregular, and possibly dynamic structure, so the flexibility of JSON is warranted.


Question 3
--------------------
You're creating a database to contain a set of sensor measurements from a two-dimensional grid. Each measurement is a time-sequence of readings, and each reading contains ten labeled values. Should you use the relational model or JSON?

* Relational
* JSON
* Either one is appropriate
* Neither is appropriate"

**Answer:** 
Either one is appropriate
**Explanation:** 
The database has a fixed structure suggesting relational, but its nested array, list, and label-value structure suggests JSON. Either may be suitable.