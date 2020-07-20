* Written by R;
*  foreign::write.foreign(df = teaTime, datafile = here("data",  ;

DATA  rlearners ;
INFILE  "C:/Users/Natalie/Documents/Rlearners/data/sas-data.txt" 
     DSD 
     LRECL= 17 ;
INPUT
 var1
 age
 gender
 income
 toast
 tea
 scone
;
RUN;
