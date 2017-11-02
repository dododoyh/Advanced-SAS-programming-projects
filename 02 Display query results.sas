/* Hui Yuan*/
/*I certify that this submission contains only my own work.*/



/* 1. Enhancing Output with Titles and Formats*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
 title 'Single Male Employee Salaries';
 select Employee_ID, Salary format=COMMA10.2, Salary/3 as Tax format=COMMA10.2
 from orion.employee_payroll
 where 	Employee_Gender='M' and  marital_status='S' and employee_term_date is not null
 order by 2 desc
 ;
quit;
title;


/*2. Using Formats to Limit the Width of Columns in the Output */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Australian Clothing Products';
 select Supplier_Name label='Supplier', Product_Group label='Group', Product_Name label='Product'
 from orion.Product_dim
 where Product_Category = "Clothes" and Supplier_Country = "AU"
 order by Product_Name
;
quit;
title;


/*3. Enhancing Output with Multiple Techniques*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'US Customers Who are Older Than 50';
create table work.customer as
   select Customer_ID format z12.,
       customer_name,
       Customer_LastName, 
       Customer_FirstName, 
       Gender, 
       int(('31DEC2007'd-Birth_Date)/365.25) as Age
   from orion.Customer
   where country='US' and calculated Age > 50
   order by Age desc, Customer_LastName, Customer_FirstName
;
quit;

proc print data=work.customer label;
run;
title;

/*4. Summarizing Data */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
 title 'Cities Where Employees Live';
  select City, count(*) as count
   from orion.Employee_Addresses
   group by City
   order by City
 ;
quit;


/*5. Using SAS Functions*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
 title 'Age at Employment';
 create table  work.employee_age as
 select Employee_ID label='Employee ID', 
        Birth_Date label='Birth Date' format MMDDYY10., 
		Employee_Hire_Date label='Hire Date' format MMDDYY10., 
       INT((Employee_Hire_Date-Birth_Date)/365.25) as Age
 from orion.Employee_Payroll;
 quit;

proc print data=work.employee_age label;
run;
title;



/*6. Summarizing Data */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Customer Demographics: Gender by Country';
select Country, count(*) as Total_Count,
   sum((find(Gender,"M","i")>0)) as Male_Count,
   sum((find(Gender,"M","i")=0)) as Female_Count,
   calculated Male_Count / calculated Total_Count as Percent_Male
from orion.Customer
group by country
order by calculated Percent_Male
;
quit;
title;


/*7. Summarizing Data in Groups */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Countries with more Female than Male Customers';
 select Country,
        sum((find(Gender,"M","i")>0)) as Male_Count label='Male Customers',
        sum((find(Gender,"M","i")=0)) as Female_Count label='Female Customers'
 from orion.Customer 
 group by Country 
 having calculated Male_Count < calculated Female_Count
 order by Female_Count desc;
quit;
title;


/*8. Advanced Summarizing Data in Groups*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title 'Number of Employees In Each City';
create table work.employee_city as
 select upcase(Country) as Nation, City, count(*) as Countries
 from orion.Employee_Addresses 
 group by Nation, City
;
quit;
proc print data=work.employee_city;
run;
title;



