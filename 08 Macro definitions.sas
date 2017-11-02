/* Hui Yuan*/
/*I certify that this submission contains only my own work.*/


/*1. Defining and Calling a Macro*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc print data=orion.customer_dim;
   var Customer_Group Customer_Name Customer_Gender Customer_Age;
   where Customer_Group contains 'Gold';
   title 'Gold Customers';
run;

/*1b the two occurrences of Gold are replaced by references to the macro variable TYPE/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let TYPE=Gold;
proc print data=orion.customer_dim;
   var Customer_Group Customer_Name Customer_Gender Customer_Age;
   where Customer_Group contains "&TYPE";
   title "&TYPE Customers";
run;
title;

/*1c Convert the program into a macro named CUSTOMERS*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
options mcompilenote=all;
%macro CUSTOMERS;
  proc print data=orion.customer_dim;
   var Customer_Group Customer_Name Customer_Gender Customer_Age;
   where Customer_Group contains "&TYPE";
   title "&TYPE Customers";
  run;
  title;
%mend CUSTOMERS;
options mcompilenote=none;

/*1d assign the value Gold to the macro variable TYPE*/
%let TYPE=Gold;
%customers

/*1e Change the value of TYPE to Internet*/
%let TYPE=Internet;
%customers

/*1f Display source code received by the SAS compiler*/
options mprint;
%customers
options nomprint;



/*2 Controlling Case-Sensitivity in a Macro */
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc means data=orion.staff sum mean;
   var Salary;
   class Job_Title;
   where Job_Title contains "Sales";
   title "Summary Statistics for the Sales Group";
run;


/*2b Convert the program into a macro named SUMSTATS*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%macro SUMSTATS;
proc means data=orion.staff sum mean;
   var Salary;
   class Job_Title;
   where upcase(Job_Title) contains "%upcase(&TYPE)";
   title "Summary Statistics for the &TYPE Group";
run;
%mend SUMSTATS;

%let TYPE=sales;
%SUMSTATS

/*2c Alter the macro variable reference in the TITLE statement */
%macro SUMSTATS;
proc means data=orion.staff sum mean;
   var Salary;
   class Job_Title;
   where upcase(Job_Title) contains "%upcase(&TYPE)";
   title "Summary Statistics for the %sysfunc(propcase(&TYPE)) Group";
run;
%mend SUMSTATS;

%let TYPE=sales;
%SUMSTATS

/*3 Calling a Macro in a TITLE Statement */
libname orion "/courses/d0f434e5ba27fe300/mac1";
%macro FUTURE;
%let DAYMON=%substr(&sysdate9,1,5);
%let YEAR=%eval(%substr(&sysdate9,6,4)+1);
%let FUTUREDATE=%sysfunc(catx( ,&DAYMON,&year));
&sysdate9 and &FUTUREDATE;
%mend FUTURE;

/*3b call the macro in the TITLE statement*/
proc print data=orion.customer_dim(obs=10);
   var Customer_Name Customer_Group;
   title "Date range of %FUTURE";
run;

/*4a Identifying Current Autocall Settings*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc options group=macro;
run;

/*4b The value of the SASAUTOS= option*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%put %sysfunc(pathname(sasautos));   


/*5 Creating an Autocall Macro*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
options mautosource sasautos=('s:\workshop');
%macro autocust;
   proc print data=orion.customer_dim;
      var customer_name customer_gender customer_age;
      title "Customers Listing as of &systime";      
   run;
%mend autocust;
options mautosource sasautos=('s:\workshop');
%autocust

/*6 Identifying the Location for Autocall Macros */
/*The CUSTOMERLIST autocall macro is not defined.*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
options mautolocdisplay=1;
%CUSTOMERLIST



/*6c The lacation of the source code is '/pbr/sfw/sas/940/SASFoundation/9.4/sasautos/lowcase.sas'*/
 libname orion "/courses/d0f434e5ba27fe300/mac1";
options mautolocdisplay=1;
%LOWCASE



/*7 Defining and Using Macro Parameters*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%macro customer;
proc print data=orion.customer_dim;
   var Customer_Name Customer_Gender Customer_Age;
   where Customer_Group contains "&type";
   title "&type Customers";
run;
%mend customer;

OPTIONS MCOMPILENOTE=ALL; 
%macro customer(type);
proc print data=orion.customer_dim;
   var Customer_Name Customer_Gender Customer_Age;
   where Customer_Group contains "&type";
   title "&type Customers";
run;
%mend customer;
OPTIONS MCOMPILENOTE=NONE;

/*7c Call the macro defined in the previous step with a value of Gold for the parameter*/
%customer(Gold)

/*7d Call the macro again, but with a parameter value of Catalog*/
%customer(Catalog)

/*7e Change the positional parameter to a keyword parameter with a default value of Club. */
%macro customer(type=Club);
proc print data=orion.customer_dim;
   var Customer_Name Customer_Gender Customer_Age;
   where Customer_Group contains "&type";
   title "&type Customers";
run;
%mend customer;

/*7f Call the macro defined in the previous step with a value of Internet for the keyword parameter*/
%customer(type=Internet)

/*7g Call the macro and allow the macro to use its default parameter value*/
%customer


/*8 Using a Macro to Generate SAS/GRAPH Code*/
libname orion "/courses/d0f434e5ba27fe300/mac1/";
proc sgplot data=orion.customer_dim;
   vbar Customer_Age_Group/
   fillattrs=( color=red transparency=.25);
run;

/*8b Create a macro with keyword parameters*/
%macro barchart(orientation=vbar, color=red, transparency=0.25);
proc sgplot data=orion.customer_dim;
   &orientation Customer_Age_Group/
   fillattrs=( color=&color transparency=&transparency);
run;
%mend;

/*8c Execute the macro using the default parameter values*/
%barchart

/*8d Call the macro and override all of the default parameter values */
%barchart(orientation=hbar, color=pink, transparency=.5)

/* 8e Call the macro again, but override the default parameter values except for the bar orientation and color */
%barchart(transparency=.5)


/*9 Using Parameters That Contain Special Characters */
libname orion "/courses/d0f434e5ba27fe300/mac1";
%macro specialchars(name);
   proc print data=orion.employee_addresses;
        where upcase(Employee_Name)="%upcase(&name)";
        var Employee_ID Street_Number Street_Name City State Postal_Code;
        title "Data for &name";
   run;
%mend specialchars;

/*9b Execute the macro with a value of Abbott, Ray for the parameter*/
%specialchars(%str(Abbott, Ray))

