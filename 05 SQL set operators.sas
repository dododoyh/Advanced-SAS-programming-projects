/* Hui Yuan*/
/*I certify that this submission contains only my own work.*/


/*1.Using the EXCEPT Operator */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select Employee_ID
from orion.Employee_phones
except corr
select Employee_ID
from orion.Employee_Addresses;
quit;


/*2.Using the INTERSECT Operator */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select Customer_ID 
from orion.Order_fact
intersect corr
select Customer_ID
from orion.Customer;
quit;


/*3.Using the EXCEPT Operator to Count Rows*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select count(*) 'No. none_donation_employees'
from (select Employee_ID 
      from orion.Employee_organization 
	  except corr
	  select Employee_ID
	  from orion.Employee_donations)
;
quit;

/*4.Using the INTERSECT Operator to Count Rows */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select count(*) 'No. place_order_customers'
from(select * 
     from orion.Order_fact
     intersect corr
     select *
     from orion.Customer)
;
quit;


/*5.Using the EXCEPT Operator with a Subquery*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql number;
title 'Sales Reps Who Made No Sales in 2007';
select Employee_ID, Employee_Name
from orion.Employee_Addresses 
where Employee_ID in (select Employee_ID from orion.Sales 
      except corr
      select Employee_ID from orion.Order_fact where year(Order_date)=2007)
;
title;
quit;

/*6.Using the INTERSECT Operator with a Subquery*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select Customer_ID, Customer_Name 
from orion.Customer
where Customer_ID in (select Customer_ID from orion.Order_fact
                      intersect corr
                      select Customer_ID from orion.Customer )
;
quit;


/*7.Using the UNION Operator*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Payroll Report for Sales Representatives';
select 'Total Paid to ALL Female Sales Representatives', 
       SUM(Salary) format=comma12. 'Total Salary',
	   count(*) 'Total People'
   from orion.Salesstaff 
   where Gender='F' and Job_Title contains 'Rep'
union 
select 'Total Paid to ALL Male Sales Representatives', 
       SUM(Salary) format=comma12. 'Total Salary',
	   count(*) 'Total People'
   from orion.Salesstaff 
   where Gender='M' and Job_Title contains 'Rep';
title;
quit;


/*8.Using the OUTER UNION Operator with the CORR Keyword*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select * from orion.Qtr1_2007 
outer union corr
select * from orion.Qtr2_2007;
quit;


/*Problem 9a Comparing UNION and OUTER UNION Operators*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select * from orion.Qtr1_2007 
union
select * from orion.Qtr2_2007;
quit;


/*Problem 9b Comparing UNION and OUTER UNION Operators*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select * from orion.Qtr1_2007 
outer union corr
select * from orion.Qtr2_2007;
quit;
