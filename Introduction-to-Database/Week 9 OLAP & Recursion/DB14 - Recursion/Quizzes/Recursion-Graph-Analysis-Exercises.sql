/************************************************************** 
  Change the working directory to the directory where the
  rating.sql file is stored. Run the following code in SQLite
  .cd ~/Introduction-to-Database/Week 9 OLAP & Recursion/DB14/Quizzes
/**************************************************************/

/***************************************************************
  Q1. Find all node pairs n1,n2 that are both red and there's a 
  path of length one or more from n1 to n2.
***************************************************************/

WITH RECURSIVE
 Nodes(n1, n2, len) AS 
 (SELECT n1, n2, 1 FROM Edge
  UNION
  SELECT Nodes.n1, Edge.n2, len + 1 AS len FROM Nodes, Edge
  WHERE Nodes.n2 = Edge.n1)
SELECT DISTINCT n1, n2 FROM Nodes, Node N1, Node n2
WHERE N1.nid = Nodes.n1 AND N2.nid = Nodes.n2 AND len >= 1
      AND N1.color = 'red' AND N2.color = 'red';  


/***************************************************************
  Q2. If your solution to problem 1 first generates all node 
  pairs with a path between them and then selects the red pairs, 
  formulate a more efficient query that incorporates "red" into 
  the recursively-defined relation in some fashion.
***************************************************************/

WITH RECURSIVE
 StartRed(n1, n2, len) AS 
 (SELECT n1, n2, 1 FROM Edge, Node N1
  WHERE N1.nid = Edge.n1 AND N1.color = 'red'
  UNION
  SELECT StartRed.n1, Edge.n2, len + 1 AS len FROM StartRed, Edge
  WHERE StartRed.n2 = Edge.n1)
SELECT DISTINCT n1, n2 FROM StartRed, Node n2
WHERE N2.nid = StartRed.n2 AND len >= 1 AND N2.color = 'red'
Order by n1; 


/***************************************************************
  Q3. If your solution to problem 2 incorporates the "red" 
  condition in the recursion by constraining the start node to 
  be red, modify your solution to constrain the end node in the 
  recursion instead. Conversely, if your solution to problem 2 
  incorporates the "red" condition in the recursion by 
  constraining the end node to be red, modify your solution to 
  constrain the start node in the recursion instead.
***************************************************************/

WITH RECURSIVE
 EndRed(n1, n2, len) AS 
 (SELECT n1, n2, 1 FROM Edge, Node n2 
  WHERE N2.nid = Edge.n2 AND N2.color = 'red'
  UNION
  SELECT Edge.n1, EndRed.n2, len + 1 AS len FROM EndRed, Edge
  WHERE Edge.n2 = EndRed.n1)
SELECT DISTINCT n1, n2 FROM EndRed, Node N1
WHERE N1.nid = EndRed.n1 AND len >= 1 AND N1.color = 'red'
Order by n1; 


/***************************************************************
  Q4. Modify one of your previous solutions to also return the 
  lengths of the shortest and longest paths between each pair 
  of nodes. Your result should have four columns: the two 
  nodeID's, the shortest path, and the longest path.
***************************************************************/

WITH RECURSIVE
 Nodes(n1, n2, len) AS 
 (SELECT n1, n2, 1 FROM Edge
  UNION
  SELECT Nodes.n1, Edge.n2, len + 1 AS len FROM Nodes, Edge
  WHERE Nodes.n2 = Edge.n1)
SELECT n1, n2, MIN(len) AS min, MAX(len) AS max FROM Nodes, Node N1, Node n2
WHERE N1.nid = Nodes.n1 AND N2.nid = Nodes.n2 
  AND N1.color = 'red' AND N2.color = 'red'
GROUP BY n1, n2;  


/***************************************************************
  Q5. Modify your solution to problem 3 to also return 
  (n1,n2,0,0) for every pair of nodes (n1≠n2) that are both red 
  but there's no path from n1 to n2.
***************************************************************/

DROP TABLE IF EXISTS StartRed;

CREATE TABLE StartRed AS 
(WITH RECURSIVE
  StartRed(n1, n2, len) AS 
  (SELECT n1, n2, 1 FROM Edge, Node N1, Node n2 
   WHERE N1.nid = Edge.n1 AND N2.nid = Edge.n2 AND N1.color = 'red'
   UNION
   SELECT StartRed.n1, Edge.n2, len + 1 AS len FROM StartRed, Edge
   WHERE StartRed.n2 = Edge.n1)
 SELECT n1, n2, MIN(len) AS minL, MAX(len) AS maxL FROM StartRed, Node N2 
 WHERE N2.nid = StartRed.n2 AND N2.color = 'red'
 GROUP BY n1, n2);

SELECT A.n1, A.n2, A.minL, A.maxL FROM
 (SELECT N1.nid AS n1, N2.nid AS n2, 0 AS minL, 0 AS maxL FROM Node N1, Node n2 
  WHERE N1.color = 'red' AND N2.color = 'red' AND N1.nid <> N2.nid) A
LEFT JOIN StartRed B 
ON A.n1 = B.n1 AND A.n2 = B.n2
WHERE B.n1 IS NULL AND B.n2 IS NULL
UNION (SELECT * FROM StartRed)
ORDER BY n1, n2;

DROP TABLE IF EXISTS StartRed;


/***************************************************************
  Q6. Find all node pairs n1,n2 that are both red and there's a 
  path of length one or more from n1 to n2 that passes through 
  exclusively red nodes. 
***************************************************************/

WITH RECURSIVE
 OnlyRed(n1, n2) AS 
 (SELECT n1, n2 FROM Edge, Node N1
  WHERE N1.nid = Edge.n1 AND N1.color = 'red'
  UNION
  SELECT OnlyRed.n1, Edge.n2 FROM OnlyRed, Edge, Node N2
  WHERE OnlyRed.n2 = Edge.n1 AND OnlyRed.n2 = N2.nid AND N2.color = 'red')
SELECT n1, n2 FROM OnlyRed, Node N2
WHERE OnlyRed.n2 = N2.nid AND N2.color = 'red'
Order by n1, n2; 


/***************************************************************
  Q7. Find all node pairs n1,n2 such that n1 is yellow and there 
  is a path of length one or more from n1 to n2 that alternates 
  yellow and blue nodes.
***************************************************************/

WITH RECURSIVE
 StartYellow(n1, n2, len) AS 
 (SELECT n1, n2, 1 FROM Edge, Node N1, Node N2
  WHERE N1.nid = Edge.n1 AND N2.nid = Edge.n2 
    AND N1.color = 'yellow' AND N2.color <> 'yellow'
  UNION
  SELECT StartYellow.n1, Edge.n2, len + 1 as len FROM StartYellow, Edge, Node N1, Node N2
  WHERE StartYellow.n2 = Edge.n1 AND StartYellow.n1 = N1.nid AND Edge.n1 = N2.nid
    AND ((len % 2 = 1 AND N1.color = 'yellow' AND N2.color = 'blue')
         OR (len % 2 = 0 AND N1.color = 'blue' AND N2.color = 'yellow'))) 
SELECT n1, n2 FROM StartYellow, Node N3
WHERE n1 < n2 AND StartYellow.n2 = N3.nid AND (N3.color = 'yellow' OR N3.color = 'blue')
Order by n1, n2; 

/************************************************************************
Be careful about this question, the following query is missing 
the two cases (E,L) and (H,L):

WITH RECURSIVE
 StartYellow(n1, n2) AS 
 (SELECT n1, n2 FROM Edge, Node N1, Node N2
  WHERE N1.nid = Edge.n1 AND N2.nid = Edge.n2 
    AND N1.color = 'yellow' AND N2.color <> 'yellow'
  UNION
  SELECT StartYellow.n1, Edge.n2 FROM StartYellow, Edge, Node N1, Node N2, Node N3
  WHERE StartYellow.n2 = Edge.n1 AND StartYellow.n1 = N1.nid AND Edge.n1 = N2.nid
    AND Edge.n2 = N3.nid 
    AND ((N1.color = 'yellow' AND N2.color = 'blue' AND N3.color = 'yellow')
         OR (N1.color = 'blue' AND N2.color = 'yellow' AND N3.color = 'blue'))) 
SELECT * FROM StartYellow
WHERE n1 < n2
Order by n1, n2; 
************************************************************************/


/***************************************************************
  Q8. Find the highest-weight path(s) in the graph. Return 
  start node, end node, length of path, and total weight.
***************************************************************/

WITH RECURSIVE
 Nodes(n1, n2, len, sumW) AS 
 (SELECT n1, n2, 1, weight as sumW FROM Edge
  UNION
  SELECT Nodes.n1, Edge.n2, len + 1 AS len, sumW + weight as sumW FROM Nodes, Edge
  WHERE Nodes.n2 = Edge.n1)
SELECT n1, n2, len, sumW FROM Nodes
WHERE sumW = (SELECT MAX(sumW) FROM Nodes);


/***************************************************************
  Q9. Add one more edge to the graph: 
  "insert into Edge values ('L','C',5);"
  Your solution to problem 7 probably runs indefinitely now. 
  Modify the query to find the highest-weight path(s) in the 
  graph with total weight under 100. Return the number of such 
  paths, the minimum length, maximum length, and total weight.
***************************************************************/

INSERT INTO Edge VALUES ('L','C',5);

WITH RECURSIVE
  Nodes(n1, n2, len, sumW) AS 
  (SELECT n1, n2, 1, weight as sumW FROM Edge
   UNION
   SELECT Nodes.n1, Edge.n2, len + 1 AS len, sumW + weight as sumW FROM Nodes, Edge
   WHERE Nodes.n2 = Edge.n1 AND sumW < 100)
 SELECT COUNT(*), MIN(len) AS minL, MAX(len) AS maxL, MAX(sumW) FROM Nodes
 WHERE sumW = (SELECT MAX(sumW) FROM Nodes WHERE sumW < 100);


/***************************************************************
  Q10.  Continuing with the additional edge present, find all 
  paths of length exactly 12. Return the number of such paths 
  and their minimum and maximum total weights.
***************************************************************/

WITH RECURSIVE
  Nodes(n1, n2, len, sumW) AS 
  (SELECT n1, n2, 1, weight as sumW FROM Edge
   UNION
   SELECT Nodes.n1, Edge.n2, len + 1 AS len, sumW + weight as sumW FROM Nodes, Edge
   WHERE Nodes.n2 = Edge.n1 AND sumW < 100)
SELECT COUNT(*), MIN(sumW) AS minSW, MAX(sumW) AS maxSW FROM Nodes
WHERE len = 12;