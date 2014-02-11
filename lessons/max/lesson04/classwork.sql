/*-Questions

--Let's walk through a few examples:

--1) Retrieve all Customers from Madrid

--SELECT * FROM Customers WHERE City='Madrid'
--2) What is the most common city for customers?

--SELECT City, COUNT(*) FROM Customers GROUP BY City
--3) What category has the most products?

--SELECT CategoryName, COUNT(*) FROM Categories
--JOIN Products on (Categories.CategoryID = Products.CategoryID)
GROUP BY CategoryName
Classwork
*/
--What customers are from the UK

SELECT * FROM CUSTOMERS WHERE COUNTRY = 'UK';


--What is the name of the customer who has the most orders?

SELECT * FROM 
(SELECT T1.CUSTOMERID, CUSTOMERNAME,COUNT(1) COUNT FROM ORDERS T1,CUSTOMERS T2
WHERE T1.CUSTOMERID = T2.CUSTOMERID GROUP BY T1.CUSTOMERID)
WHERE COUNT = 
(
SELECT MAX(COUNT) FROM (
SELECT T1.CUSTOMERID, CUSTOMERNAME,COUNT(1) COUNT FROM ORDERS T1,CUSTOMERS T2
WHERE T1.CUSTOMERID = T2.CUSTOMERID GROUP BY T1.CUSTOMERID
) 
)

--What supplier has the highest average product price?

SELECT * FROM (
SELECT T1.SUPPLIERID,SUPPLIERNAME,AVG(PRICE) AVGPRICE FROM [PRODUCTS] T1 ,SUPPLIERS T2 WHERE T1.SUPPLIERID = T2.SUPPLIERID GROUP BY T1.SUPPLIERID)
WHERE AVGPRICE = 
(
SELECT MAX(AVGPRICE ) FROM (
SELECT T1.SUPPLIERID,AVG(PRICE) AVGPRICE FROM [PRODUCTS] T1,SUPPLIERS T2 WHERE T1.SUPPLIERID = T2.SUPPLIERID GROUP BY T1.SUPPLIERID
) 
)

--What category has the most orders?

SELECT * FROM PRODUCTS T1, CATEGORIES T3
WHERE T1.CATEGORYID = T3.CATEGORYID
AND T1.PRODUCTID IN
(
SELECT PRODUCTID FROM (
(SELECT PRODUCTID, COUNT(1) COUNT FROM [ORDERDETAILS] GROUP BY PRODUCTID)
)
WHERE COUNT = 
(
SELECT MAX(COUNT ) FROM
(SELECT PRODUCTID, COUNT(1) COUNT FROM [ORDERDETAILS] GROUP BY PRODUCTID)
) 
)




--What employee made the most sales (by number of sales)?

SELECT * FROM EMPLOYEES T1
WHERE T1.EMPLOYEEID IN
(
SELECT EMPLOYEEID FROM (
(SELECT EMPLOYEEID,COUNT(1) COUNT FROM [ORDERS] T1, ORDERDETAILS T2
WHERE T1.ORDERID = T2.ORDERID GROUP BY EMPLOYEEID)
)
WHERE COUNT = 
(
SELECT MAX(COUNT) FROM (
SELECT EMPLOYEEID,COUNT(1) COUNT FROM [ORDERS] T1, ORDERDETAILS T2
WHERE T1.ORDERID = T2.ORDERID GROUP BY EMPLOYEEID)
) 
)


--What employee made the most sales (by value of sales)?

SELECT * FROM EMPLOYEES T1
WHERE T1.EMPLOYEEID IN
(
SELECT EMPLOYEEID FROM (
(SELECT EMPLOYEEID,SUM(PRICE*QUANTITY) SUM_PRICE FROM [ORDERS] T1, ORDERDETAILS T2, PRODUCTS T3
WHERE T1.ORDERID = T2.ORDERID 
AND T2.PRODUCTID = T3.PRODUCTID
GROUP BY EMPLOYEEID)
)
WHERE SUM_PRICE = 
(
SELECT MAX(SUM_PRICE) FROM (
SELECT EMPLOYEEID,SUM(PRICE*QUANTITY) SUM_PRICE FROM [ORDERS] T1, ORDERDETAILS T2, PRODUCTS T3
WHERE T1.ORDERID = T2.ORDERID 
AND T2.PRODUCTID = T3.PRODUCTID
GROUP BY EMPLOYEEID)
) 
)


--What employees have BS degrees? (Hint: Look at LIKE operator)

SELECT * FROM [EMPLOYEES] WHERE NOTES LIKE '%BS%'

--What supplier has the highest average product price assuming they have at least 2 products (Hint: Look at the HAVING operator)

SELECT * FROM (
SELECT T1.SUPPLIERID,SUPPLIERNAME,AVG(PRICE) AVGPRICE FROM PRODUCTS T1 ,SUPPLIERS T2 WHERE T1.SUPPLIERID = T2.SUPPLIERID GROUP BY T1.SUPPLIERID)
WHERE AVGPRICE = 
(
SELECT MAX(AVGPRICE ) FROM (
SELECT T1.SUPPLIERID,AVG(PRICE) AVGPRICE FROM PRODUCTS T1,SUPPLIERS T2 WHERE T1.SUPPLIERID = T2.SUPPLIERID GROUP BY T1.SUPPLIERID
) 
)
AND SUPPLIERID IN 
(SELECT SUPPLIERID FROM (SELECT SUPPLIERID,COUNT(1) COUNT FROM PRODUCTS GROUP BY SUPPLIERID) WHERE COUNT >= 2)