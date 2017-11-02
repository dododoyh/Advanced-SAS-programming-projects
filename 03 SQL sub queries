/* Hui Yuan*/
/*I certify that this submission contains only my own work.*/


/*Problem 1a Write a query that displays the average Quantity for all rows in the table*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select avg(Quantity) as MeanQuantity
from orion.Order_Fact
;
quit;


/* Problem 1b Write a query that displays Employee_ID and AVG(Quantity) for those employees whose average exceeds the company average*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Employees whose Average Quantity Items Sold Exceeds the Company’s Average Items Sold';
select Employee_ID, avg(Quantity) as MeanQuantity format=COMMA10.2
from orion.Order_Fact
group by Employee_ID
having avg(Quantity)> (select avg(Quantity) from orion.Order_Fact)
;
quit;
title;


/*Problem 2a Create a query that returns a list of employee IDs for employees with a February anniversary*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Employee IDs for February Anniversaries';
select Employee_ID
from orion.Employee_Payroll
where month(Employee_Hire_Date)=2
;
quit;
title;


/*Problem 2b write a query that displays the employee IDs and names of employees who have February anniversaries*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Employees with February Anniversaries';
select Employee_ID, scan(Employee_Name,2) as FirstName, scan(Employee_Name,1) as LastName
from orion.Employee_Addresses
where Employee_ID in (select Employee_ID
            from orion.Employee_Payroll
            where month(Employee_Hire_Date)=2)
;
quit;
title;



/*Problem 3 Creating Subqueries Using the ALL Keyword*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Level I or II Purchasing Agents Who are older than ALL Purchasing Agent IIIs';
select Employee_ID, Job_Title, Birth_Date, 
       int(('24Nov2007'd-Birth_Date)/365.25) as Age
from orion.Staff
where Job_Title in('Purchasing Agent I','Purchasing Agent II') 
      and calculated Age > all 
	        (select int(('24Nov2007'd-Birth_Date)/365.25) as Age 
		     from orion.Staff
	         where Job_Title='Purchasing Agent III');
quit;
title;



/* Problem 4a Generate a report that shows Employee_ID and calculated Total_Sales from the orion.Order_Fact table*/
libname orion "/courses/d0f434e5ba27fe300/sql";
Proc sql;
title 'Orion Total Sales';
select Employee_ID,sum(Total_retail_price*Quantity) as Total_Sales
from orion.Order_Fact
group by Employee_ID
order by 2
;
quit;
title;


/* Problem 4b Generate another report that displays Employee_ID and Employee_Name of the employee with the highest sales.*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'employee with the highest total sales I';
create table sales as
 select Employee_ID, sum(Total_retail_price*Quantity) as Total_Sales
from orion.Order_Fact
where Employee_ID NE 99999999
group by Employee_ID
having calculated Total_Sales GE all(select sum(Total_retail_price*Quantity) as Total_Sales
from orion.Order_Fact
where Employee_ID NE 99999999
group by Employee_ID)
;
create table bestemployee as
select sales.Employee_ID,Employee_Name
from sales, orion.Employee_Addresses 
where sales.Employee_ID=Employee_Addresses.Employee_ID;
select * from bestemployee;
quit;
title;

/*Problem 4c Write a query that combines the two queries above in order to generate a report that adds the Total_Sales column with Employee_ID and Employee_Name and the calculated Total_Sales column*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'employee with the highest total sales II';
create table sales as
 select Employee_ID, sum(Total_retail_price*Quantity) as Total_Sales
from orion.Order_Fact
where Employee_ID NE 99999999
group by Employee_ID
having calculated Total_Sales GE all(select sum(Total_retail_price*Quantity) as Total_Sales
from orion.Order_Fact
where Employee_ID NE 99999999
group by Employee_ID)
;
create table bestemployee as
select sales.Employee_ID, sales.Total_Sales,Employee_Name
from sales, orion.Employee_Addresses 
where sales.Employee_ID=Employee_Addresses.Employee_ID;
select * from bestemployee;
quit;
title;


/*Probelm 5 Create a report showing Employee_ID and the birth month (calculated as month(Birth_date)) for all Australian employees*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Australian Employees Birth Months';
select Employee_ID, month(Birth_date) as BirthMonth
from orion.Employee_Payroll 
where 'AU'=
(select Country 
 from orion.Employee_Addresses
 where Employee_Payroll.Employee_ID=Employee_Addresses.Employee_ID)
 order by calculated BirthMonth;
quit;
title;



/* Probelm 6 Generate a report that displays Employee_ID, Employee_Gender, and Marital_Status for all employees who donate more than 0.002 of their salary*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Employees With Donations >0.002 of Their Salary';
select employee_ID, Employee_Gender, Marital_Status
from orion.Employee_Payroll 
where Salary*0.002<
(select sum (qtr1, qtr2, qtr3, qtr4)
 from orion.Employee_donations 
 where Employee_donations.Employee_ID=Employee_Payroll.Employee_ID)
;
quit;
