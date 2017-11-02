/* Hui Yuan*/
/*I certify that this submission contains only my own work.*/


/*1 Using PROC SQL Options and Displaying the Contents of a Dictionary Table */
/*1a Write a query that retrieves Memname (table name) and Memlabel (description of the table) from dictionary.Dictionaries*/
proc sql;
title 'Dictionary Tables';
select distinct Memname, Memlabel 
  from dictionary.Dictionaries;
quit;
title;


/* 1b Use the columns memname, type, and length from dictionary.*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Tables containing Customer_ID';
select memname, type, length 
  from dictionary.Columns 
  where libname='ORION'  and upcase(Name)='CUSTOMER_ID';
quit;
title;

/*2 Using PROC SQL Options and Displaying Dictionary Table Information */
/*2a. Produce a report that includes memname (table name), memlabel (table description), and a count of the number of columns in each table*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Dictionary Tables';
select distinct memname, memlabel, count(*) as numcolumns
 from dictionary.Dictionaries
 group by memname;
quit;
title;
 

/*2b. List the table name (memname), number of rows (nobs), number of columns (nvar), file size (filesize), length of the widest column (maxvar), and length of the widest column label (maxlabel) by querying dictionary.Tables*/
proc sql;
title 'Orion Library Tables';
select memname, nobs, nvar, filesize, maxvar, maxlabel
 from dictionary.Tables
 where libname='ORION' and memtype ne 'VIEW'
 order by memname;
quit;
title;


/*4 Creating and Using Macro Variables */
/*4a. Write a query for the Employee_payroll table that returns the highest value of Salary*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'The Highest Value of Salary';
select max(salary) as maxsalary
from  orion.Employee_payroll;
quit;
title; 


/*4b&4c create and assign values to two macro variables and replace each hardcoded (typed) reference to Employee_payroll (once in the title and once in the query) with a reference to the macro variable DataSet*/
%let DataSet = Employee_payroll;
%let VariableName = Salary;
options symbolgen;
proc sql;
title "The Highest Value of &VariableName";
select max(&VariableName) "Max&VariableName"
  into: Maximum
from  orion.&DataSet;
quit;
title;
%put The maximal &VariableName is &Maximum;

/*Problem 4d Use the %LET statements to change the values of your macro variables*/
%let DataSet = Price_List;
%let VariableName = Unit_Sales_Price;
options symbolgen;
proc sql;
title "The Highest Value of &VariableName";
select max(&VariableName) "Max&VariableName"
  into: Maximum
from  orion.&DataSet;
quit;
title;
%put The maximal &VariableName is &Maximum;


/*5Creating a Macro Variable from an SQL Query */
/*5a Produce a report of Country and a new column named Purchases*/ 
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title '2007 Purchases by Country';
select Country, sum(Total_Retail_Price) as Purchases format=dollar12.2
from Orion.Order_fact as o, Orion.Customer as c
where year(Order_date)=2007 and o.Customer_ID=c.Customer_ID
group by country
order by calculated Purchases desc;
quit;
title;

/*Problem 5b. Produce a report of Purchases by Customer_Name for the year 2007*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title1 '2007 US Customer Purchases';
title2 'Total US Purchases: $10,655.97';
select Customer_Name, sum(Total_Retail_Price) as Purchases format=dollar12.2
from Orion.Order_fact as o, Orion.Customer as c
where year(Order_date)=2007 and o.Customer_ID=c.Customer_ID and country='US'
group by Customer_Name
order by calculated Purchases desc;
quit;
title;


/*Problem 5c.Modify the query from step 5.a and 5b*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql noprint outobs=1;
select Country, sum(Total_Retail_Price) as Purchases format=dollar12.2
  into :Country, :Country_Purchases 
  from Orion.Order_fact as o, Orion.Customer as c
  where year(Order_date)=2007 and o.Customer_ID=c.Customer_ID
  group by country
  order by calculated Purchases desc;
  
reset print number;
reset outobs=number;
title1 "2007 &Country Customer Purchases";
title2 "Total &Country Purchases: &Country_Purchases ";
select Customer_Name, sum(Total_Retail_Price) as Purchases format=dollar12.2
from Orion.Order_fact as o, Orion.Customer as c
where year(Order_date)=2007 and o.Customer_ID=c.Customer_ID and country="&Country"
group by Customer_Name
order by calculated Purchases desc;
quit;
title;

/*Problem 5d. Modify the first query so that the country with the lowest total purchases is read into the macro variable instead of the highest*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql noprint outobs=1;
select Country, sum(Total_Retail_Price) as Purchases format=dollar12.2
  into :Country, :Country_Purchases 
  from Orion.Order_fact as o, Orion.Customer as c
  where year(Order_date)=2007 and o.Customer_ID=c.Customer_ID
  group by country
  order by calculated Purchases;
  
reset print number;
reset outobs=number;
title1 "2007 &Country Customer Purchases";
title2 "Total &Country Purchases: &Country_Purchases ";
select Customer_Name, sum(Total_Retail_Price) as Purchases format=dollar12.2
from Orion.Order_fact as o, Orion.Customer as c
where year(Order_date)=2007 and o.Customer_ID=c.Customer_ID and country="&Country"
group by Customer_Name
order by calculated Purchases desc;
quit;
title;

