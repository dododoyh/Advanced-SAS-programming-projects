/* Hui Yuan*/
/*I certify that this submission contains only my own work.*/


/*1 Creating Macro Variables with the SYMPUTX Routine */
libname orion "/courses/d0f434e5ba27fe300/mac1";
%macro emporders(idnum=121044);
   proc print data=orion.orders noobs;
      var Order_ID Order_Type Order_Date Delivery_Date;
      where Employee_ID=&idnum;
      title "Orders Received by Employee &idnum";
   run;
%mend emporders;

%emporders()


/*1b,1c,1d Modify the macro to include a DATA step; Modify the TITLE statement to display the name of the employee instead of the employee’s ID; Call the macro again with a parameter value of 121066*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%macro emporders(idnum=121044);
data _null_;
	set orion.employee_addresses;
	where Employee_ID=&idnum;
	call symputx('name',Employee_Name);
run;
   
proc print data=orion.orders noobs;
     var Order_ID Order_Type Order_Date Delivery_Date;
     where Employee_ID=&idnum;
     title "Orders Received by Employee &name";
run;
%mend emporders;

%emporders()
title;

%emporders(idnum=121066)
title;


/*2 Creating Macro Variables with the SYMPUTX Routine */
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc means data=orion.order_fact nway noprint; 
   var Total_Retail_Price;
   class Customer_ID;
   output out=customer_sum sum=CustTotalPurchase;
run;

proc sort data=customer_sum; 
   by descending CustTotalPurchase;
run;

proc print data=customer_sum(drop=_type_);
run;



/*2b,2c Create a macro variable named TOP that contains the ID number for the top customer; Modify the program to print the customer’s name instead of the customer’s ID */
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc means data=orion.order_fact nway noprint; 
   var Total_Retail_Price;
   class Customer_ID;
   output out=customer_sum sum=CustTotalPurchase;
run;

proc sort data=customer_sum; 
   by descending CustTotalPurchase;
run;

data _null_;
set customer_sum (obs=1);
call symputx('TOP',Customer_ID);
run;

data _null_;
set orion.customer_dim;
where Customer_Id in (&TOP);
call symputx('name',Customer_Name);
run;

proc print data=orion.customer_dim;
     var Customer_ID Customer_Name Customer_Type;
     where Customer_Id in (&TOP);
     title "Top customer: &name";
run;
title;


/*3 Creating Macro Variables with the SYMPUTX Routine */
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc means data=orion.order_fact nway noprint; 
   var Total_Retail_Price;
   class Customer_ID;
   output out=customer_sum sum=CustTotalPurchase;
run;

proc sort data=customer_sum ;
   by descending CustTotalPurchase;
run;

proc print data=customer_sum(drop=_type_);
run;




/*3b,3c Using the customer_sum data set, create a single macro variable, TOP3, that contains the customer IDs of the top three customers by revenue; Using the orion.customer_dim data set, print a listing of the top three customers*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc means data=orion.order_fact nway noprint; 
   var Total_Retail_Price;
   class Customer_ID;
   output out=customer_sum sum=CustTotalPurchase;
run;

proc sort data=customer_sum ;
   by descending CustTotalPurchase;
run;

data _null_;
set customer_sum (obs=3) end=last;
length top_3 $10.;
retain top_3;
top_3=catx(',',top_3,trim(Customer_ID));
if last then call symputx('TOP3',top_3);
run;

proc print data=orion.customer_dim;
     var Customer_ID Customer_Name Customer_Type;
     where Customer_Id in (&TOP3);
run;



/*4 Creating Multiple Macro Variables with the SYMPUTX Routine*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%macro memberlist(id=1020);
   %put _user_;
   title "A List of &id";
   proc print data=orion.customer;
      var Customer_Name Customer_ID Gender;
      where Customer_Type_ID=&id;
   run;
%mend memberlist;

%memberlist()


/*4b,4c,4d Modify the macro to include a DATA step to create a series of macro variables; Modify the TITLE statement so that it displays the appropriate customer type; Call the macro again, but with a parameter value of 2030*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%macro memberlist(id=1020);
data _null_;
set orion.customer_type;
call symputx('type'||left(Customer_Type_ID), Customer_Type);
run;
%put _user_;
title "A List of &&type&id";
   
proc print data=orion.customer;
     var Customer_Name Customer_ID Gender;
     where Customer_Type_ID=&id;
run;
%mend memberlist;

%memberlist();

%memberlist(id=2030);



/*5 Using Indirect References in a Macro Call;Create a macro variable named NUM with the value of  2010*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
data _null_;
set orion.customer_type;
call symputx('type'||left(Customer_Type_ID), Customer_Type);
run;

%put _user_;

%let num=2010;

%macro memberlist(custtype=&&type&num);
proc print data=orion.customer_dim;
     var Customer_Name Customer_ID Customer_Age_Group;
     where Customer_Type="&custtype";
     title "A List of &custtype";
run;
%mend memberlist;

%memberlist();


/*6 Using a Table Lookup Application */
libname orion "/courses/d0f434e5ba27fe300/mac1";
data _null_;
set orion.country;
call symputx(''||Country,Country_Name);
run;

%let code=AU;
proc print data=orion.Employee_Addresses;
     var Employee_Name City;
     where Country="&code";
     title "A List of &&&code Employees";
run;


/*7 Resolving Macro Variables with the SYMGET Function*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
data _null_;
   set orion.customer_type;
   call symputx('type'||left(Customer_Type_ID), Customer_Type);
run;

%put _user_;

data us;
   set orion.customer;
   where Country="US";
   keep Customer_ID Customer_Name Customer_Type_ID;
run;

proc print data=us noobs;
   title "US Customers";
run;
title;

/*7b Modify the second DATA step to create a new variable named CustType that contains the value of the macro variable TYPExxxx*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
data _null_;
   set orion.customer_type;
   call symputx('type'||left(Customer_Type_ID), Customer_Type);
run;

%put _user_;

data us;
   set orion.customer;
   where Country="US";
   length CustType $40;
   CustType=symget('type'||left(Customer_Type_ID));

   keep Customer_ID Customer_Name Customer_Type_ID CustType;
run;

proc print data=us noobs;
   title "US Customers";
run;
title;


/*8 Investigating Macro Variable Storage and Resolution*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let var1=cat;
%let var2=3;
data test;
   length s1 s4 s5 $ 3;
   call symputx('var3','dog');
   r1="&var1";
   r2=&var2;
   r3="&var3";
   s1=symget('var1');
   s2=symget('var2');
   s3=input(symget('var2'),2.);
   s4=symget('var3');
   s5=symget('var'||left(r2));
run;

proc print data=test;
run;
/*Name	Type	Lenth	Value 
  r1	Char	3		cat 
  r2	Num		8		3 
  r3	Char	3		dog 
  s1	Char	3		cat 
  s2	char	200		3 
  s3	Num		8		3 
  s4	Char	3		dog 
  s5	Char	3		dog*/



/*9 Creating Macro Variables Using SQL*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let start=01Jan2007;
%let stop=31Dec2007;
proc means data=orion.order_fact;
   var Total_Retail_Price;
   output out=stats n=count mean=avg;
   run;
data _null_;
   set stats;
   call symputx('orders',count);
   call symputx('average',avg);
run;

proc gchart data=orion.order_fact;
   vbar3d Order_Type 
      / patternid=midpoint cframe=w shape=c discrete
        sumvar=Total_Retail_Price type=mean ref=&average;
   format Total_Retail_Price dollar4.;
   label Total_Retail_Price='Average Order';
   title1 h=1 "Report from &start to &stop";
   title2 h=1 f=swiss "Orders this period: " c=b "&orders";
   footnote1 h=1 f=swiss "Overall Average: " c=b 
      "%sysfunc(putn(&average,dollar4.))";
run;
quit;
title;
footnote;

/*Replace the PROC MEANS step and the DATA step with a PROC SQL step*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
%let start=01Jan2007;
%let stop=31Dec2007;
proc sql;
	select count(*) as n label="orders",
		   mean(Total_Retail_Price) as mean label="average",
		   std(Total_Retail_Price) as Std_Dev,
		   Min(Total_Retail_Price) as Minimum,
		   Max(Total_Retail_Price) as Maximum
	from orion.order_fact;
run;
%let FMTAVG=%sysfunc(putn(&average,dollar4.));
proc gchart data=orion.order_fact;
   vbar3d Order_Type 
      / patternid=midpoint cframe=w shape=c discrete
        sumvar=Total_Retail_Price type=mean ref=&average;
   format Total_Retail_Price dollar4.;
   label Total_Retail_Price='Average Order';
   title1 h=1 "Report from &start to &stop";
   title2 h=1 f=swiss "Orders this period: " c=b "&orders";
   footnote1 h=1 f=swiss "Overall Average: " c=b 
      "&FMTAVG";
run;
quit;



/*10 Creating a List of Values in a Macro Variable Using SQL*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc sql outobs=3;
select customer_id into:TOP3 separated by ', '
from orion.order_fact
group by Customer_ID
order by Total_Retail_Price descending;
quit;

%put &TOP3;



/*11 Creating Multiple Macro Variables Using SQL*/
libname orion "/courses/d0f434e5ba27fe300/mac1";
proc sql noprint;
select count(*) into: nrow
from orion.customer_type;
quit;

proc sql;
select Customer_Type 
into: CTYPE1 - : %sysfunc(catx( ,CTYPE,&nrow))
from orion.customer_type;
quit;

proc sql;
select name, value
from dictionary.macros
where name like "CTYPE%";
quit;


