options nonumber nodate formdlim='-';

*Example 8.2; 

Data eightpttwo;
 
Input A B C D E Y;  

AB = A*B;
AC = A*C; 
AD = A*D; 
AE = A*E; 
BC = B*C; 
BD = B*D; 
BE = B*E; 
CD = C*D; 
CE = C*E;  
DE = D*E; 

datalines;  

 
-1 -1 -1 -1 -1 7.78
-1 -1 -1 -1 -1 7.78
-1 -1 -1 -1 -1 7.81
+1 -1 -1 +1 -1 8.15		
+1 -1 -1 +1 -1 8.18
+1 -1 -1 +1 -1 7.88
-1 +1 -1 +1 -1 7.50
-1 +1 -1 +1 -1 7.56
-1 +1 -1 +1 -1 7.50
+1 +1 -1 -1 -1 7.59
+1 +1 -1 -1 -1 7.56
+1 +1 -1 -1 -1 7.75
-1 -1 +1 +1 -1 7.54	
-1 -1 +1 +1 -1 8.00
-1 -1 +1 +1 -1 7.88	
+1 -1 +1 -1 -1 7.69
+1 -1 +1 -1 -1 8.09
+1 -1 +1 -1 -1 8.06
-1 +1 +1 -1 -1 7.56
-1 +1 +1 -1 -1 7.52 
-1 +1 +1 -1 -1 7.44
+1 +1 +1 +1 -1 7.56
+1 +1 +1 +1 -1 7.81
+1 +1 +1 +1 -1 7.69
-1 -1 -1 -1 +1 7.50
-1 -1 -1 -1 +1 7.25
-1 -1 -1 -1 +1 7.12
+1 -1 -1 +1 +1 7.88
+1 -1 -1 +1 +1 7.88
+1 -1 -1 +1 +1 7.44
-1 +1 -1 +1 +1 7.50
-1 +1 -1 +1 +1 7.56
-1 +1 -1 +1 +1 7.50
+1 +1 -1 -1 +1 7.63
+1 +1 -1 -1 +1 7.75
+1 +1 -1 -1 +1 7.56
-1 -1 +1 +1 +1 7.32
-1 -1 +1 +1 +1 7.44
-1 -1 +1 +1 +1 7.44
+1 -1 +1 -1 +1 7.56
+1 -1 +1 -1 +1 7.69
+1 -1 +1 -1 +1 7.62
-1 +1 +1 -1 +1 7.18
-1 +1 +1 -1 +1 7.18
-1 +1 +1 -1 +1 7.25
+1 +1 +1 +1 +1 7.81
+1 +1 +1 +1 +1 7.50
+1 +1 +1 +1 +1 7.59

;
run;

ods rtf;
/***Full model******/
proc glm data=eightpttwo;
class A B C D E; 
model Y=A B C D E AB AC AD AE BE CE DE; 
run;

/****reduced model***/
ods graphics on; 
proc glm data=eightpttwo; 
class A B D E;
model Y=A B D E BE;
 
means A B D E/ tukey; 
output out= yield p=fitted_values r=residuals; 
title " Yield Output ANOVA"; 
run; 
quit; 
ods graphics off;

goptions csymbol = black htext = 2; 
symbol1 value = dot i = non color = black;

proc gplot data=yield;
plot residuals*fitted_values; 
title "Residuals Analysis: Residuals vs. fitted values"; 
run;

proc gplot data=yield; 
plot residuals*A; 
title "Residuals Analysis: Residuals vs. Aperture"; 
run;

proc gplot data=yield; 
plot residuals*B; 
title "Residuals Analysis: Residuals vs. Exposure Time"; 
run;

proc gplot data=yield; 
plot residuals*D; 
title "Residuals Analysis: Residuals vs. Hold Down Time"; 
run;

proc gplot data=yield; 
plot residuals*D; 
title "Residuals Analysis: Residuals vs. Quench Oil Temperature"; 
run;

proc univariate data= yield normal;  
var residuals; 
probplot residuals / normal; 
title "Residuals Analysis: Normality Plot of Residuals"; 
run;
 
proc reg data=eightpttwo;  
model Y= A B C D E AB AC BC AD AE BD BE CD CE DE; 
run;

/**Regression Analysis***/ 
proc reg data=eightpttwo;   
model Y= A B C D E AB AC AD AE BE CE DE; 
title "Yield Output Regression";
run;

ods rtf close;