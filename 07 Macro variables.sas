/* Hui Yuan*/
/*I certify that this submission contains only my own work.*/


/*1.Displaying Automatic Macro Variables  */
libname orion "/courses/d0f434e5ba27fe300/mac1";
%put _automatic_;

/*2a. Sort the data set orion.continent by Continent_Name*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc sort data=orion.continent out=cont1;
    by Continent_Name;
run;

/*2b. Print the most recently created data set and display the data set name in the title */
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc print data=&syslast;
title "Dataset &syslast";
run;
title;


/*3a. The automatic macro variable SYSLAST is 'work.new'.*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
data new;
   set orion.continent;
run;
%put &syslast;

/*3b. The automatic macro variable SYSLAST is 'work.new'.*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
title 'Problem 3b';
proc print data=orion.continent;
run;
%put &syslast;
title;

/*4a Run the following the program*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
title 'Problem 4a';
proc print data=orion.employee_payroll;
   format Birth_Date Employee_Hire_Date date9.;
run;
title;


/*4b Subsets the data to return only the employees hired between 
January 1, 2007, and today*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
title 'Problem 4b';
proc print data=orion.employee_payroll;
     format Birth_Date Employee_Hire_Date date9.;
     where Employee_Hire_Date	between "01jan2007"d and "&sysdate9"d;
run;
title;


/*5a Submit the program and examine the output*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc print data=orion.customer_dim;
   var Customer_Name Customer_Gender Customer_Age;
   where Customer_Group contains 'Gold';
   title 'Gold Customers';
run;



/*5bcde Defining and Using Macro Variables for Character Substitution*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
options symbolgen;
%let type=Gold; 
proc print data=orion.customer_dim;
     var Customer_Name Customer_Gender Customer_Age;
     where Customer_Group contains "&type";
     title "&type Customers";
run;
title;

%let type=Internet; 
proc print data=orion.customer_dim;
     var Customer_Name Customer_Gender Customer_Age;
     where Customer_Group contains "&type";
     title "&type Customers";
run;
options nosymbolgen;
title;


/*6 Defining and Using Macro Variables for Numeric Substitution  */
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let type=Gold;
proc print data=orion.customer_dim;
   var Customer_Name Customer_Gender Customer_Age;
   where Customer_Group contains "&type" and Customer_Age between 30 and 45;
   title "&type Customers between 30 and 45";
run;
 
libname orion "/courses/d0f434e5ba27fe300/mac1";
options symbolgen;
%let type=Gold;
%let AGE1=30;
%let AGE2=45;
proc print data=orion.customer_dim;
     var Customer_Name Customer_Gender Customer_Age;
     where Customer_Group contains "&type" and 
     Customer_Age between &AGE1 and &AGE2;
     title "&type Customers between &AGE1 and &AGE2";
run;

%let type=Gold;
%let AGE1=25;
%let AGE2=40;
proc print data=orion.customer_dim;
     var Customer_Name Customer_Gender Customer_Age;
     where Customer_Group contains "&type" 
     and Customer_Age between &AGE1 and &AGE2;
     title "&type Customers between &AGE1 and &AGE2";
run;
options nosymbolgen;
title;


/*7 Deleting Macro Variables */
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let pet1=Paisley;
%let pet2=Sitka;
%symdel pet1 pet2;
%put _user_;

/*8 Consecutive Macro Variables References*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let MONTH=AUG;
%let YEAR=2006;
proc print data=orion.organization_dim;
     where Employee_Hire_Date="01&MONTH&YEAR"d;
     id Employee_ID;
     var Employee_Name Employee_Country Employee_Hire_Date;
     title "Personal Information for Employees Hired in &MONTH &YEAR";
run;

%let MONTH=JUL;
%let YEAR=2003;
proc print data=orion.organization_dim;
     where Employee_Hire_Date="01&MONTH&YEAR"d;
     id Employee_ID;
     var Employee_Name Employee_Country Employee_Hire_Date;
     title "Personal Information for Employees Hired in &MONTH &YEAR";
run;
title;


/*9 Macro Variable References with Delimiters */
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let DSN=Organization;
%let VAR=Employee;
proc print data=orion.&DSN._dim;
     id &VAR._ID; 
     var &VAR._Name &VAR._Country &VAR._Gender;
     title "Listing of All &VAR.s From orion.&DSN._Dim";
run;

%let DSN=Customer;
%let VAR=Customer;
proc print data=orion.&DSN._dim;
     id &VAR._ID;
     var &VAR._Name &VAR._Country &VAR._Gender;
     title "Listing of All &VAR.s From orion.&DSN._Dim";
run;


/*10 Macro Variable References with Multiple Delimiters */
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let a=First;
proc sort data=orion.staff out=staffhires;
   by Job_Title Emp_Hire_Date;
run;
data &a.Hired;   
   set staffhires;
   by Job_Title;
   if &a..Job_Title;  
run;
proc print data=&a.Hired;
   id Job_Title;
   var Employee_ID Emp_Hire_Date;
   title "&a Employee Hired within Each Job Title";  
run;

%let a=Last;
proc sort data=orion.staff out=staffhires;
   by Job_Title Emp_Hire_Date;
run;
data &a.Hired;   
   set staffhires;
   by Job_Title;
   if &a..Job_Title;  
run;
proc print data=&a.Hired;
   id Job_Title;
   var Employee_ID Emp_Hire_Date;
   title "&a Employee Hired within Each Job Title";  
run;


/*11 Using the %SUBSTR and %SCAN Functions*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let FULLNAME=Anthony Miller;
%let NAME=%substr(&FULLNAME,1,1). %scan(&FULLNAME,-1,' ');
%put Name is &NAME;



/*12 Using the %SYSFUNC Function*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let date1=%sysfunc(today(),mmddyyp10.);
%let time1=%sysfunc(time(),timeampm.);
%put The current date is &date1 ;
%put The current time is &time1;

/*13 Protecting Special Characters */
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc print data=orion.product_dim;
   where Product_Name contains "Jacket";
   var Product_Name Product_ID Supplier_Name;
   title "Product Names Containing 'Jacket'";
run;

/*13b assign the value R&D to a macro variable named PRODUCT*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let product=%nrstr(R&D);
proc print data=orion.product_dim;
     where Product_Name contains "&product";
     var Product_Name Product_ID Supplier_Name;
     title "Product Names Containing '&product'";
run;
title;

/*13c Add the current date and time to a title*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let product=%nrstr(R&D);
proc print data=orion.product_dim;
     where Product_Name contains "&product";
     var Product_Name Product_ID Supplier_Name;
     title1 "Product Names Containing '&product'";
     title2 "Report generated at %sysfunc(time(),timeampm.)";
     title3 "on %sysfunc(today(),mmddyyp10.)";
run;
title;




/*14 Verifying a Data Set Name */
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let DSN=work.test;
%let FIRST=%upcase(%substr(%scan(&DSN,2,.),1,1));
%let a=ABCDEFGHIJKLMNOPQRSTUVWXYZ_;
%let b=%verify(&first,&a);
%put The value of ckbegin=&b;
