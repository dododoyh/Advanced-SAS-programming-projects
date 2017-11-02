/* Hui Yuan*/
/*I certify that this submission contains only my own work.*/


/*1.Inner Joins */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title1 'Employees With More Than 30 Years of Service';
title2 'As of December 31,2007';
select Employee_Name  'Employee Name',
       int(('31DEC2007'd-Employee_Hire_Date)/365.25) as YOS 'Year of Service'
   from orion.Employee_Payroll
        inner join
        orion.Employee_Addresses
        on Employee_Payroll.Employee_ID=
           Employee_Addresses.Employee_ID
   where calculated YOS>30
  ;
title;
quit;

/*2. Outer Joins */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select Employee_Name 'Name', City, Job_Title
from orion.Employee_Addresses as one left join orion.Sales as two
     on one.Employee_ID =two.Employee_ID 
	 order by City, Job_Title, Employee_Name;
quit;

/* 3.Joining Multiple Tables*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'US and Australian Internet Customers Purchasing Foreign Manufactured Products';
select Customer_Name as Name, Count(*) as Purchases
from orion.Product_Dim as p, orion.Order_Fact as o, orion.Customer  as c
where p.Product_ID=o.Product_ID 
     and o.Customer_ID=c.Customer_ID 
     and o.Employee_ID = 99999999 
     and p.Supplier_Country ne c.Country
     and c.Country in ('US','AU')
group by Customer_Name
order by  calculated Purchases desc , Customer_Name;
title;
quit;

/*4. Joining Multiple Tables*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title1 'Employees With More Than 30 Years of Service';
title2 'As of December 31, 2007';
select distinct Employee_Name  'Employee Name',
       int(('31DEC2007'd-Employee_Hire_Date)/365.25) as YOS 'Year of Service',
	   Manager_Name 'Manager Name'
   from orion.Employee_Payroll as ep,
        orion.Employee_Addresses as ea,
        orion.Employee_Organization as eo,
        (select Manager_ID, ea.Employee_Name  as  Manager_Name
          from orion.Employee_Addresses  as ea
          inner join orion.Employee_Organization as eo
          on ea.Employee_ID=eo.Manager_ID) as manager	
   where ep.Employee_ID=ea.Employee_ID and ep.Employee_ID=eo.Employee_ID and eo.Manager_ID=manager.Manager_ID
   and calculated YOS>30
  order by Manager_Name;
title;
quit;

/*5a. Using In-Line Views*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title1 '2007 Sales Force Sales Statistics';
title2 'For Employees With 200.00 or More In Sales';
select Country, First_Name, Last_Name, 
      sum(Total_Retail_Price) as Value_Sold format=w16.2, Count(*) as Orders,
      calculated value_sold / calculated orders as Avg_Order format=16.2
from orion.Order_Fact as of inner join orion.Sales as sa 
	  on of.Employee_ID=sa.Employee_ID
	  where Year(Order_Date)=2007
group by Country, First_Name, Last_Name
having calculated Value_Sold >= 200
order by Country, calculated Value_Sold desc, calculated Orders desc
;
title;
quit;




/*Problem 5b*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title'2007 Sales Summary by Country';
select Country, max(Value_Sold) as Max_Sold format=16.2, Sum(Orders) as Orders, Avg(Avg_Order) as Avg_Order format=16.2 , min(Avg_Order) as Min_Avg format=16.2
from (select Country, First_Name, Last_Name, 
      sum(Total_Retail_Price) as Value_Sold format=w16.2, Count(*) as Orders,
      calculated value_sold / calculated orders as Avg_Order format=16.2
     from orion.Order_Fact as of inner join orion.Sales as sa 
	  on of.Employee_ID=sa.Employee_ID
	  where Year(Order_Date)=2007
     group by Country, First_Name, Last_Name
     having calculated Value_Sold >= 200) as stat
group by Country;
title;
quit;


/* Problem 6a*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
Select distinct department ,sum(Salary) as Dept_Salary_Total
from (select Department, Salary 
      from orion.Employee_Payroll as ep 
	  inner join orion.Employee_Organization as eo
	  on ep.Employee_ID=eo.Employee_ID) as es
group by Department
order by Department
;
quit;

/* Problem 6b*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
select ea.Employee_ID, Employee_Name, Department
from orion.Employee_Addresses as ea
    inner join orion.Employee_Organization as eo
    on ea.Employee_ID =eo.Employee_ID
order by Employee_Name;
quit;


/* Problem 6c*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Employee Salaries as a Percent of Department Total';
select one.Department, Employee_Name, Salary format=comma16.2, Salary/Dept_Salary_Total as Percent format=percent10.1
from (Select distinct department ,sum(Salary) as Dept_Salary_Total
      from (select Department, Salary 
      from orion.Employee_Payroll as ep 
	  inner join orion.Employee_Organization as eo
	  on ep.Employee_ID=eo.Employee_ID) as es
      group by Department) as one,
	  (select ea.Employee_ID, Employee_Name, Department
      from orion.Employee_Addresses as ea
       inner join orion.Employee_Organization as eo
      on ea.Employee_ID =eo.Employee_ID) as two,
	  orion.Employee_Payroll  as three
where one.Department=two.Department and two.Employee_ID=three.Employee_ID
order by one.Department, calculated Percent desc
;
title;
quit;


/*7. Building a Complex Query Using a Multi-Way Join*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title ' 2007 Total Sales Figures ';
select catx(' ', scan(Manager_Name, 2, ','),scan(Manager_Name, 1, ','))  as Manager, 
       catx(' ', scan(Employee_Name, 2, ','),scan(Employee_Name, 1, ','))  as Employee, Total_Sales format=16.2
from (select Manager_ID, eo.Employee_ID, ea.Employee_Name  as  Manager_Name
          from orion.Employee_Addresses  as ea
          inner join orion.Employee_Organization as eo
          on ea.Employee_ID=eo.Manager_ID) as one,
		orion.Employee_Addresses as two,
		(select Employee_ID, sum(Total_Retail_Price) as Total_Sales
		 from orion.Order_Fact as of
		 where year(Order_Date)=2007
		 group by Employee_ID) as three
where one.Employee_ID=two.Employee_ID and one.Employee_ID=three.Employee_ID
order by Country, Manager_Name, Total_Sales desc
;
title;
quit;





