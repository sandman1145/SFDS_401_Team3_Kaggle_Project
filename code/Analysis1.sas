*--------------------------------------------------------*
| Import train.csv                                       |
| Set REFFILE for train.csv                              |
*--------------------------------------------------------*;

* FILENAME REFFILE '/home/mwolfe0/train.csv';
FILENAME REFFILE 
'/folders/myfolders/MSDS6371/GroupProject/Datasets/train.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV REPLACE OUT=TRAIN;
	GETNAMES=YES;
RUN;

*--------------------------------------------------------*
| Subset the data to only include homes sold in the      |
| neighborhoods of interest - NAmes, BrkSide, and Edwards|
| Round the gross living area to the nearest 100 SF      |
| Keep only the variables of Neighboorhood, GrLivArea,   |
| and SalePrice in the dataset                           |
*--------------------------------------------------------*;

DATA HOMES1;
SET TRAIN (KEEP=Neighborhood GrLivArea SalePrice);
IF Neighborhood EQ "NAmes" | 
   Neighborhood EQ "BrkSide" | 
   Neighborhood EQ "Edwards";
GrLivArea100 = ROUND(GrLivArea, 100); /*FLOOR(GrLivArea);*/
RUN;

*--------------------------------------------------------*
| Descriptive statistics on the HOMES1 dataset for       |
| GrLivArea and SalePrice                                |
*--------------------------------------------------------*;

PROC UNIVARIATE DATA=HOMES1;
	CLASS Neighborhood;
	VAR GrLivArea SalePrice;
RUN;

*--------------------------------------------------------*
| Scatter plot of sale prices in the three neighborhoods |
| vs Gross Living Area                                   |
*--------------------------------------------------------*;

PROC SGPLOT DATA=HOMES1;
	SCATTER X=GrLivArea Y=SalePrice/GROUP=Neighborhood;
RUN;

*--------------------------------------------------------*
| Regression model of homes in the three neighborhoods   |
| combined for Sale Price based on Gross Living Area     |
| to check assumptions on the data in these three        |
| neighborhoods                                          |
*--------------------------------------------------------*;

PROC REG DATA=HOMES1 PLOTS=ALL;
	MODEL SalePrice=GrLivArea / CLB;
	RUN;

*--------------------------------------------------------*
| Regression model of homes in the three neighborhoods   |
| using an equal slope model                             |
*--------------------------------------------------------*;

PROC GLM DATA=HOMES1;
	CLASS Neighborhood;
	MODEL SalePrice=GrLivArea Neighborhood / CLPARM;
	RUN;

*--------------------------------------------------------*
| Regression model of homes in the three neighborhoods   |
| using an equal intercept model (slopes differ)         |
*--------------------------------------------------------*;

PROC GLM DATA=HOMES1;
	CLASS Neighborhood;
	MODEL SalePrice=GrLivArea*Neighborhood / CLPARM;
	RUN;

*--------------------------------------------------------*
| Regression model of homes in the three neighborhoods   |
| using a model that allows slopes and intercepts to     |
| vary                                                   |
*--------------------------------------------------------*;

PROC GLM DATA=HOMES1;
	CLASS Neighborhood;
	MODEL SalePrice=Neighborhood GrLivArea*Neighborhood / CLPARM;
	RUN;
	
*--------------------------------------------------------*
| Remove Outliers:                                       |
| SaleCondition is not normal (confounding effect on     |
| prices)                                                |
| SalePrice is greater than 300,000 since they are not   |
| representative of the overall population in these      |
| three neighborhoods.                                   |
| Keep only the variables of Neighboorhood, GrLivArea,   |
| and SalePrice in the dataset                           |
*--------------------------------------------------------*;

DATA HOMES2;
SET TRAIN (KEEP=Neighborhood GrLivArea SalePrice SaleCondition);
IF Neighborhood EQ "NAmes" | 
   Neighborhood EQ "BrkSide" | 
   Neighborhood EQ "Edwards";
IF SalePrice LT 300000;
IF SaleCondition EQ "Normal";
GrLivArea100 = ROUND(GrLivArea, 100);
RUN;

*--------------------------------------------------------*
| Descriptive statistics on the HOMES1 dataset for       |
| GrLivArea and SalePrice                                |
*--------------------------------------------------------*;

PROC UNIVARIATE DATA=HOMES2;
	CLASS Neighborhood;
	VAR GrLivArea SalePrice;
RUN;

*--------------------------------------------------------*
| Scatter plot of sale prices in the three neighborhoods |
| vs Gross Living Area                                   |
*--------------------------------------------------------*;

PROC SGPLOT DATA=HOMES2;
	SCATTER X=GrLivArea Y=SalePrice;
	REG X=GrLivArea Y=SalePrice;
RUN;

PROC SGPLOT DATA=HOMES2;
	SCATTER X=GrLivArea Y=SalePrice/GROUP=Neighborhood;
RUN;

*--------------------------------------------------------*
| Regression model of homes in the three neighborhoods   |
| using a model that allows slopes and intercepts to     |
| vary                                                   |
| Output 95% confidence limit for parameter estimates    |
*--------------------------------------------------------*;

PROC REG DATA=HOMES2 PLOTS=ALL;
	MODEL SalePrice=GrLivArea / CLB;
	RUN;

*--------------------------------------------------------*
| Regression model of homes in the three neighborhoods   |
| using an equal slope model                             |
*--------------------------------------------------------*;

PROC GLM DATA=HOMES2;
	CLASS Neighborhood;
	MODEL SalePrice=GrLivArea Neighborhood / CLPARM;
	RUN;

*--------------------------------------------------------*
| Regression model of homes in the three neighborhoods   |
| using an equal intercept model (slopes differ)         |
*--------------------------------------------------------*;

PROC GLM DATA=HOMES2;
	CLASS Neighborhood;
	MODEL SalePrice=GrLivArea*Neighborhood / CLPARM;
	RUN;

*--------------------------------------------------------*
| Regression model of homes in the three neighborhoods   |
| using a model that allows slopes and intercepts to     |
| vary                                                   |
*--------------------------------------------------------*;

PROC GLM DATA=HOMES2;
	CLASS Neighborhood;
	MODEL SalePrice=Neighborhood GrLivArea*Neighborhood / CLPARM;
	RUN;


*--------------------------------------------------------*
| Alternate Method with interaction terms                |
|                                                        |
| Keep only the variables of Neighboorhood, GrLivArea,   |
| and SalePrice in the dataset                           |
| d1 = NAmes, d2 = BrkSide, Control = Edwards            |
*--------------------------------------------------------*;

DATA HOMES3;
SET TRAIN (KEEP=Neighborhood GrLivArea SalePrice SaleCondition);
IF Neighborhood EQ "NAmes" | 
   Neighborhood EQ "BrkSide" | 
   Neighborhood EQ "Edwards";
IF SalePrice LT 300000;
IF SaleCondition EQ "Normal";
GrLivArea100 = ROUND(GrLivArea, 100);
  IF Neighborhood = 'NAmes' THEN d1 = 1; ELSE d1=0;
  IF Neighborhood = 'BrkSide' THEN d2 = 1; ELSE d2=0;
		int1 = d1*GrLivArea100; int2 = d2*GrLivArea100;
RUN;

*--------------------------------------------------------*
| Plots to check assumptions                             |
| d1 = NAmes, d2 = BrkSide, Control = Edwards            |
*--------------------------------------------------------*;

PROC SGPLOT DATA=HOMES3;
HISTOGRAM GrLivArea100;
DENSITY GrLivArea100/TYPE=NORMAL;
TITLE "Histogram of Gross Living Area in NAmes, BrkSide, and Edwards";
RUN;

PROC SGPLOT DATA=HOMES3;
SCATTER X=GrLivArea100 Y=SalePrice;
TITLE "Gross Living Area vs Sale Price in NAmes, BrkSide, and Edwards";
RUN;

PROC REG DATA=HOMES3 PLOT=ALL;
model SalePrice = GrLivArea100/CLB;
RUN;

*--------------------------------------------------------*
| Run regression model with interaction terms using dummy|
| variables                                              |
| d1 = NAmes, d2 = BrkSide, Control = Edwards            |
| Output 95% confidence limit for parameter estimates    |
*--------------------------------------------------------*;
PROC REG DATA=HOMES3;
	model SalePrice = GrLivArea100 d1 d2 int1 int2/VIF CLB;
	title 
	'Regression of Sale Price on Gross Living Area 
	with Interaction Terms';
	RUN;

*--------------------------------------------------------*
| center the interaction terms based on the means of     |
| GrLivArea100 and d1 and d2 to correct for the          |
| inflated VIF                                           |
*--------------------------------------------------------*;

PROC MEANS DATA=HOMES3;
var GrLivArea100 d1 d2;
run;

DATA center;
set HOMES3;
cent1 = (GrLivArea100 - 1280.72)*(d1-0.593);
cent2 = (GrLivArea100 - 1280.72)*(d2-0.164);
RUN;

PROC REG DATA=center PLOTS=ALL;
model SalePrice = GrLivArea100 d1 d2 cent1 cent2/VIF CLB;
title 
	'Regression of Sale Price on Gross Living Area 
	with Interaction Terms';
RUN;

PROC GLM DATA=HOMES3 PLOT=ALL;
CLASS Neighborhood;
model SalePrice=GrLivArea100|Neighborhood/solution CLPARM;
RUN;

PROC GLMSELECT DATA=HOMES3;
CLASS Neighborhood;
MODEL SalePrice = GrLivArea Neighborhood 
/ cvmethod=random(5) stats=all;
RUN;