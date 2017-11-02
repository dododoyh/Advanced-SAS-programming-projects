/* Hui Yuan*/
/*I certify that this submission contains only my own work.*/


/* 1a. Querying a Table*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
 select *
  from orion.Employee_Payroll;
quit;


/* 1b. Querying a Table*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
 select Employee_ID, Employee_Gender, Marital_Status, Salary 
  from orion.Employee_Payroll;
quit;


/* 2. Calculating a Column*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql; 
   select Employee_ID, Employee_Gender, Marital_Status,
          Salary, Salary/3 as Tax
      from orion.Employee_Payroll;
quit;


/* 3. Conditional Processing*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
 create table work.staff as
 select Employee_ID, Salary,
   case scan(Job_Title,-1,' ')
     when 'Manager' then 'Manager'
     when 'Director' then 'Director'
     when 'Officer' then 'Executive'
     when 'President' then 'Executive'
   end as Level,
   case 
      when calculated level='Manager' and Salary < 52000  then 'Low'
	  when calculated  level='Manager' and Salary between 52000 and 72000 then 'Medium' 
	  when calculated  level='Manager' and Salary >72000 then 'High'
	  when calculated  level='Director' and Salary < 108000  then 'Low'
	  when calculated  level='Director' and Salary between 108000 and 135000 then 'Medium' 
	  when calculated level='Director' and Salary >135000 then 'High' 
	  when calculated level='Executive' and Salary < 240000  then 'Low'
	  when calculated level='Executive' and Salary between 240000 and 300000 then 'Medium' 
	  when calculated level='Executive' and Salary >300000 then 'High'
   end as Salary_Range
 from orion.Staff
 where calculated level ^=' ';
quit;

proc print data=work.staff;
run;

/* 4. Eliminating Duplicates */
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
 title'Cities Where Employees Live';
 select distinct city
 from orion.Employee_Addresses;
quit;
title;


/* 5. Subsetting Data*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
 title'Donations Exceeding $90.00';
 select Employee_ID, Recipients, sum(Qtr1,Qtr2,Qtr3,Qtr4) as Total
 from orion.Employee_donations
 where calculated Total >90;
quit;
title;

/* 6. Subsetting Data Using the ESCAPE Clause*/
libname orion "/courses/d0f434e5ba27fe300/sql";
proc sql;
title '90% Donations to A Single Company';
create table work.Employee_donations as

 select Employee_ID, Recipients 
 from orion.Employee_donations
 where  Recipients like '%Inc. 90/%' escape '/' ;
 quit;

 proc print data=work.Employee_donations;
 run;
title;



