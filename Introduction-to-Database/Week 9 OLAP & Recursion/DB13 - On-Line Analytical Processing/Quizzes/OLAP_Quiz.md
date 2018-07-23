OLAP Quiz 
============================

Question 1
-----------------
Consider a fact table Sales(saleID, itemID, color, size, qty, unitPrice), and the following three queries:
```SQL
Q1: Select itemID, color, size, Sum(qty*unitPrice)
    From Sales
    Group By itemID, color, size
Q2: Select itemID, size, Sum(qty*unitPrice)
    From Sales
    Group By itemID, size
Q3: Select itemID, size, Sum(qty*unitPrice)
    From Sales
    Where size < 10
    Group By itemID, size 
```
Depending on the order in which we execute two of these queries, the pair of actions may be viewed as an example of roll-up, drill-down or slicing. Which of the following statements is correct?

* Going from Q1 to Q2 is an example of slicing.
* Going from Q2 to Q3 is an example of slicing.
* Going from Q2 to Q1 is an example of roll-up.
* Going from Q2 to Q1 is an example of slicing.

**Answer:**
* Going from Q2 to Q3 is an example of slicing.

**Other possible answers:**
* Going from Q1 to Q2 is an example of roll-up.
* Going from Q2 to Q1 is an example of drill-down.

**Explanation:**
* **Drill-down**: allows the user to navigate among levels of data ranging from the most summarized (up) to the most detailed (down)
* **Roll-up**: involves summarizing the data along a dimension. The summarization rule might be computing totals along a hierarchy or applying a set of formulas such as "profit = sales - expenses".
* **Slicing**: the act of picking a rectangular subset of a cube by choosing a single value for one of its dimensions, creating a new cube with one fewer dimension.
* **Dicing**: produces a subcube by allowing the analyst to pick specific values of multiple dimensions 


Question 2
-----------------------
Consider a fact table Facts(D1,D2,D3,x), and the following three queries:

```SQL
Q1: Select D1,D2,D3,Sum(x)
    From Facts
    Group By D1,D2,D3
Q2: Select D1,D2,D3,Sum(x)
    From Facts
    Group By D1,D2,D3 WITH CUBE
Q3: Select D1,D2,D3,Sum(x)
    From Facts
    Group By D1,D2,D3 WITH ROLLUP
```

Suppose attributes D1, D2, and D3 have n1, n2, and n3 different values respectively, and assume that each possible combination of values appears at least once in table Facts. The number of tuples in the result of each of the three queries above can be specified as an arithmetic formula involving n1, n2, and n3. Pick the one tuple (a,b,c,d,e,f) in the list below such that when n1=a, n2=b, and n3=c, then the result sizes of queries Q1, Q2, and Q3 are d, e, and f respectively. (Hint: It may be helpful to first write formulas describing how d, e, and f depend on a, b, and c. Then find the answer that satisfies your formulas.)

* (2, 2, 2, 6, 18, 8)
* (4, 7, 3, 84, 160, 84)
* (4, 7, 3, 84, 87, 117)
* (2, 2, 2, 8, 27, 15)

**Answer:** 
* (2, 2, 2, 8, 27, 15): If Q1 is 8, it means 2 * 2 * 2 = 8, and `(D1, D2, D3)` is a unique key for `Facts`. Therefore, Q2 will produce 8 + (2 * 2) * 3 + 2 * 3 + 1 = 27, and Q3 will produce 8 + 2  * 2 +  2 + 1 = 15.

**Other possible answers:**
* (4, 7, 3, 84, 160, 117)

**Explanation:**
One way to determine the result size for Q3 is to count the number of possible triples with no NULL values, those that have a NULL value for D3, those that have a NULL value for D2 and D3, those that have a NULL value for all three attributes, and add these terms.

E.g.,
* (4, 7, 3, 84, 160, 84): If Q1 is 84, it means 4 * 7 * 3 = 84, and `(D1, D2, D3)` is a unique key for `Facts`. Therefore, Q2 will produce 84 + 4 * 7 + 4 * 3 + 7 * 3 + 4 + 7 + 3 + 1 = 160, but Q3 will produce 84 + 4  * 7 +  4 + 1 = 117.
* (5, 4, 3, 60, 64, 80): it must be incorrect since e has to be bigger than f
* (4, 7, 3, 84, 87, 117): it must be incorrect since e has to be bigger than f
* (2, 2, 2, 8, 64, 15): It must be incorrect since 2 * 2 * 2 + (2 * 2) * 3 + 2 * 3 + 1 = 27. The biggest number e can have is 27, which is much smaller than 64.
