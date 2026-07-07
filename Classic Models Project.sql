use classicmodels;
select*from customers;

#1.List the customers in the United States with a credit limit higher than \$1000.
select *from customerS where COUNTRY="USA" AND CREDITLIMIT>1000;

#2.List the employee codes for sales representatives of customers in Spain, France and Italy. Make another query to list the names and email addresses of those employees.
select employeeNumber,firstName,email from employees where employeeNumber in
(select salesRepEmployeeNumber from customers where country in("Spain", "France", "Italy"));
#OR
#using joins
select distinct(employeenumber),firstname,email from customers c
inner join employees e
on c.salesrepemployeenumber=e.employeenumber
where c.country in ("Spain", "France", "Italy");

#3.Change the job title "Sales Rep" to "Sales Representative"
update employees set jobtitle="Sales representative" where jobtitle="Sales rep";

#4.Delete the entries for Sales Representatives working in London.
SELECT e.employeeNumber, e.firstName, e.lastName, e.jobTitle, o.city
FROM Employees e
JOIN Offices o
ON e.officeCode = o.officeCode
WHERE e.jobTitle = "Sales Representative" AND o.city = "London";
    
DELETE FROM Employees WHERE jobTitle = "Sales Representative"
AND officeCode IN (SELECT officeCode FROM Offices WHERE city = "London");

#5.Show a list of employees who are not sales representatives
select*from employees where jobtitle<>"sales representative";

#6.Show a list of customers with "Toys" in their name
select*from customers where customername like "%toys%";

#7.Prepare a list of offices sorted by country, state, city.
SELECT*FROM OFFICES 
ORDER BY COUNTRY,STATE,CITY;

#8.How many employees are there in the company?
SELECT COUNT(*) AS EMPLOYEES_COUNT 
FROM EMPLOYEES;

#9.What is the total of payments received?
SELECT sum(payments.amount) As "Total Payments"
FROM payments;

#10.List the product lines that contain "Cars"
SELECT*FROM PRODUCTS WHERE PRODUCTLINE LIKE "%CARS%";

#11.Report the total number of payments received before October 28, 2004.
SELECT COUNT(*)AS "TOTAL NO. OF PAYMENTS" FROM payments WHERE paymentDate<"2004-10-28";

#12.Report those payments greater than \$100,000
select*from payments where amount>100000;

#13.List the products in each product line
select productline,productname from products order by productline;

#14.How many products in each product line?
SELECT productLine,count(*) As "Count_Of_Products"
FROM products
GROUP BY productLine
ORDER BY count(*) DESC;

#15.What is the minimum payment received?
select min(amount) as "minimum payment" from payments;

#16.list all the payments greater than twice the average amount ?
SELECT * FROM payments
WHERE amount > 2 * (SELECT AVG(amount) FROM payments);

#17.what is the average percentage markup of the MSRP on buyPrice ?
select avg((msrp-buyprice)/msrp)*100 as "avg percentage markup" from products;

#18. How many distinct products does classicmodels sell?
select count(distinct productname) as "count of distinct products" from products;

#19.Report the name and city of customers who don"t have sales representatives
select customername,city 
from customers 
where salesRepEmployeeNumber IS NULL;

#20.what are the names of executives with VP or Manager in their title ? Use
-- the CONCAT function to combine the employees firstname and lastname
-- into a single field for reporting ?
select concat(firstname,"",lastname) as full_name,jobtitle from employees
where jobtitle like "%vp%" or jobtitle like "%manager%";

#21.which orders have a value greater than $5,000
SELECT orderNumber,sum(priceEach*quantityOrdered) from orderdetails
group by orderNumber
having sum(priceEach*quantityOrdered) > 5000
order by sum(priceEach*quantityOrdered);

#22.Report the total number of payments received before October 28,2004
Select count(*) from payments where paymentdate<"2004-10-28";

#23.Retrieve the list of customer numbers for customer who have made a payment before October 28, 2004.
SELECT DISTINCT customerNumber FROM payments WHERE paymentDate<"2004-10-28";

#24.Retrieve the details all customers who have made a payment before October 28, 2004.
SELECT * FROM customers WHERE customerNumber in 
(SELECT DISTINCT customerNumber FROM payments WHERE paymentDate<"2004-10-28");

#25.Retrieve details of all the customers in the United States who have made payments between April 1st 2003 and March 31st 2004.
#using Joins
SELECT DISTINCT *FROM Customers c
JOIN Payments p
ON c.customerNumber = p.customerNumber
WHERE c.country = "USA" AND p.paymentDate BETWEEN "2003-04-01" AND "2004-03-31";

#26.Determine the total number of units sold for each product
SELECT productCode, SUM(quantityOrdered) AS total_units_sold 
FROM orderdetails
GROUP BY productCode;

#27.Find the total no. of payments and total payment amount for each customer for payments made before October 28, 2004.
SELECT customerNumber, COUNT(*) as numberOfPayments, round(SUM(amount),2) as totalPayment 
FROM payments 
WHERE paymentDate<"2004-10-28" 
GROUP BY customerNumber;

#28.Modify the above query to also show the minimum, maximum and average payment value for each customer.
SELECT customerNumber,MIN(amount) AS min_payment,MAX(amount) AS max_payment,round(AVG(amount),2) AS avg_payment
FROM payments
GROUP BY customerNumber;

#29.Show the full office address and phone number for each employee.
SELECT e.employeeNumber, e.firstName,e.lastName,o.addressLine1,o.addressLine2,o.city,o.state,o.country,o.postalCode,o.phone
FROM employees e
JOIN offices o
ON e.officeCode = o.officeCode;

#30.Show the full order information and product details for order no. 10100.
SELECT o.orderNumber,o.orderDate,o.status,o.customerNumber,p.productCode,p.productName,p.productLine,p.buyPrice,od.quantityOrdered,od.priceEach
FROM orders o
JOIN orderdetails od
ON o.orderNumber = od.orderNumber
JOIN products p
ON od.productCode = p.productCode
WHERE o.orderNumber = 10100;

##31.Report the account representative for each customer.
SELECT c.customerNumber,c.customerName,e.employeeNumber AS account_rep_number,
CONCAT(e.firstName, " ", e.lastName) AS account_rep_name
FROM Customers c
LEFT JOIN Employees e
ON c.salesRepEmployeeNumber = e.employeeNumber;

#32.Report total payments for Atelier graphique.
SELECT c.customerName,SUM(p.amount) AS total_payments
FROM Customers c
JOIN Payments p
ON c.customerNumber = p.customerNumber
WHERE c.customerName = "Atelier graphique"
GROUP BY c.customerName;

#33.Report the total payments by date
SELECT DATE(paymentDate) AS payment_date,SUM(amount) AS total_payments
FROM Payments
GROUP BY DATE(paymentDate)
ORDER BY payment_date;

#34.Report the products that have not been sold.
SELECT p.productCode,p.productName,p.productLine,p.buyPrice,p.quantityInStock
FROM Products p
LEFT JOIN OrderDetails od
ON p.productCode = od.productCode
WHERE od.productCode IS NULL;

#35.List the amount paid by each customer.
SELECT c.customerNumber,c.customerName,SUM(p.amount) AS total_amount_paid
FROM Customers c
JOIN Payments p
ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber, c.customerName
ORDER BY total_amount_paid DESC;

#36.How many orders have been placed by Herkku Gifts?
SELECT c.customerName,COUNT(o.orderNumber) AS total_orders
FROM Customers c
JOIN Orders o
ON c.customerNumber = o.customerNumber
WHERE c.customerName = "Herkku Gifts"
GROUP BY c.customerName;

#37.Who are the employees in Boston?
SELECT e.employeeNumber,CONCAT(e.firstName, " ", e.lastName) AS employee_name,e.jobTitle,o.city
FROM Employees e
JOIN Offices o
ON e.officeCode = o.officeCode
WHERE o.city = "Boston";

#38.Report those payments greater than \$100,000. Sort the report so the customer who made the highest payment appears first.
SELECT p.checkNumber,p.paymentDate,p.amount,c.customeNumber,c.customerName
FROM Payments p
JOIN Customers c
ON p.customerNumber = c.customerNumber
WHERE p.amount > 100000
ORDER BY p.amount DESC;

#39.List the value of "On Hold" orders.
SELECT o.orderNumber,SUM(od.quantityOrdered * od.priceEach) AS order_value
FROM Orders o
JOIN OrderDetails od
ON o.orderNumber = od.orderNumber
WHERE o.status = "On Hold"
GROUP BY o.orderNumber;

#40.Report the number of orders "On Hold" for each customer.
SELECT c.customerNumber,c.customerName,COUNT(o.orderNumber) AS on_hold_orders
FROM Customers c
JOIN Orders o
ON c.customerNumber = o.customerNumber
WHERE o.status = "On Hold"
GROUP BY c.customerNumber, c.customerName
ORDER BY on_hold_orders DESC;

##41.List products sold by order date.
SELECT o.orderDate,o.orderNumber,p.productCode,p.productName,od.quantityOrdered,od.priceEach
FROM Orders o
JOIN OrderDetails od
ON o.orderNumber = od.orderNumber
JOIN Products p
ON od.productCode = p.productCode
ORDER BY o.orderDate;

##42.List the order dates in descending order for orders for the 1940 Ford Pickup Truck
SELECT DISTINCT o.orderDate
FROM Orders o
JOIN OrderDetails od
ON o.orderNumber = od.orderNumber
JOIN Products p
ON od.productCode = p.productCode
WHERE p.productName = "1940 Ford Pickup Truck"
ORDER BY o.orderDate DESC;

#43.List the names of customers and their corresponding order number where a particular order from that customer has a 13. value greater than $25,000?
SELECT c.customerName,o.orderNumber,SUM(od.quantityOrdered * od.priceEach) AS order_value
FROM Customers c
JOIN Orders o
ON c.customerNumber = o.customerNumber
JOIN OrderDetails od
ON o.orderNumber = od.orderNumber
GROUP BY c.customerName, o.orderNumber
HAVING SUM(od.quantityOrdered * od.priceEach) > 25000;

#44.Are there any products that appear on all orders?
SELECT p.productCode,p.productName
FROM Products p
JOIN OrderDetails od
ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
HAVING COUNT(DISTINCT od.orderNumber) = (SELECT COUNT(*) FROM Orders);

#45.List the names of products sold at less than 80% of the MSRP.
SELECT DISTINCT p.productName
FROM Products p
JOIN OrderDetails od
ON p.productCode = od.productCode
WHERE od.priceEach < 0.8 * p.MSRP;

#46.Reports those products that have been sold with a markup of 100% or more (i.e the priceEach is at least twice the buyPrice)
SELECT DISTINCT p.productCode,p.productName,p.buyPrice,od.priceEach
FROM Products p
JOIN OrderDetails od
ON p.productCode = od.productCode
WHERE od.priceEach >= 2 * p.buyPrice;

#47.List the products ordered on a Monday.
SELECT DISTINCT p.productCode,p.productName
FROM Orders o
JOIN OrderDetails od
ON o.orderNumber = od.orderNumber
JOIN Products p
ON od.productCode = p.productCode
WHERE DAYNAME(o.orderDate) = "Monday";

#48.What is the quantity on hand for products listed on "On Hold" orders?
SELECT DISTINCT p.productCode,p.productName,p.quantityInStock AS quantity_on_hand
FROM Orders o
JOIN OrderDetails od
ON o.orderNumber = od.orderNumber
JOIN Products p
ON od.productCode = p.productCode
WHERE o.status = "On Hold";

#49.Display the full name of point of contact each customer in the United States in upper case, 
#along with their phone number, sorted by alphabetical order of customer name.
SELECT customerName, CONCAT(UCASE(contactFirstName), " ", UCASE(contactLastName)) AS contact, phone 
FROM customers 
WHERE country="USA" 
ORDER BY customerName;

#50. List the largest single payment done by every customer in the year 2004, 
#ordered by the transaction value (highest to lowest).
SELECT customerNumber, MAX(amount) AS largestPayment 
FROM payments 
WHERE YEAR(paymentDate)=2004 
GROUP BY customerNumber 
ORDER BY largestPayment DESC;