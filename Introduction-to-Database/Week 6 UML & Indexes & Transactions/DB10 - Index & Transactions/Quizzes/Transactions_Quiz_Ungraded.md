Transaction Quiz Ungraded
=======================

Question 1
--------------------
Suppose client C1 issues transactions T1;T2 and client C2 concurrently issues transactions T3;T4. How many different "equivalent sequential orders" are there for these four transactions?

* 2
* 4
* 6
* 24

**Answer:** 
* 6

**Explanation:** 
T1,T2,T3,T4; T1,T3,T2,T4; T1,T3,T4,T2; T3,T1,T2,T4; T3,T1,T4,T2; T3,T4,T1,T2


Question 2
-------------------
Consider a relation R(A) containing {(5),(6)} and two transactions: T1: Update R set A = A+1; T2: Update R set A = 2*A. Suppose both transactions are submitted under the isolation and atomicity properties. Which of the following is NOT a possible final state of R?

* {(10,12)}
* {(11,13)}
* {(11,12)}
* {(12,14)}

**Answer:** 
* {(11,12)}

**Explanation:** 
Answer 1 occurs if T1 does not complete. Answer 2 occurs if T2 precedes T1. Answer 4 occurs if T1 precedes T2. Answer 3 would require all of T2 and half of T1.


Question 3
-------------------
Consider a table R(A) containing {(1),(2)}. Suppose transaction T1 is "update R set A = 2*A" and transaction T2 is "select avg(A) from R". If transaction T2 executes using "read uncommitted", what are the possible values it returns?

* 1.5, 2, 2.5, 3 
* 1.5, 2, 3
* 1.5, 2.5, 3
* 1.5, 3

**Answer:** 
* 1.5, 2, 2.5, 3 

**Explanation:** 
The update command in T1 can update the values in either order, and the select command in T2 can compute the average at any point before, between, or after the updates.

 
Question 4
-------------------
Consider tables R(A) and S(B), both containing {(1),(2)}. Suppose transaction T1 is "update R set A = 2*A; update S set B = 2*B" and transaction T2 is "select avg(A) from R; select avg(B) from S". If transaction T2 executes using "read committed", is it possible for T2 to return two different values?

* Yes
* No

**Answer:** 
* Yes

**Explanation:** 
T2 could return avg(A) computed before T1 and avg(B) computed after T1.

 
Question 5
-------------------
Consider tables R(A) and S(B), both containing {(1),(2)}. Suppose transaction T1 is "update R set A = 2*A; update S set B = 2*B" and transaction T2 is "select avg(A) from R; select avg(B) from S". If transaction T2 executes using "read committed", is it possible for T2 to return a smaller avg(B) than avg(A)?

* Yes
* No

**Answer:** 
* No

**Explanation:** 
avg(A) > avg(B) would require the two statements of T2 to execute between the two statements of T1, not permitted by "read committed".


Question 6
-------------------
Consider table R(A) containing {(1),(2)}. Suppose transaction T1 is "update T set A=2*A; insert into R values (6)" and transaction T2 is "select avg(A) from R; select avg(A) from R". If transaction T2 executes using "repeatable read", what are the possible values returned by its SECOND statement?

* 1.5, 4
* 1.5, 2, 4
* 1.4, 3, 4
* 1.5, 2, 3, 4

**Answer:** 
* 1.5, 4

**Explanation:** 
T2 must (appear to) execute entirely before or after T1. You might think T2 could (appear to) execute between T1's two statements since the second statement is an insert, but that would be allowing dirty reads.