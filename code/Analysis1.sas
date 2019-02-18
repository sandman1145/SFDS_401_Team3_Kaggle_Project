/* FILENAME REFFILE '/home/mwolfe0/train.csv'; */
FILENAME REFFILE '/folders/myfolders/MSDS6371/GroupProject/Datasets/train.csv';


PROC IMPORT DATAFILE=REFFILE DBMS=CSV REPLACE OUT=HOMES;
	GETNAMES=YES;
RUN;

PROC UNIVARIATE DATA=HOMES;
	VAR GrLIvArea SalePrice;
RUN;

PROC SGPLOT DATA=HOMES;
	SCATTER X=GrLIvArea Y=SalePrice;
	REG X=GrLIvArea Y=SalePrice;
RUN;

PROC REG DATA=HOMES;
	MODEL SalePrice=GrLIvArea;
	RUN;

PROC GLM DATA=HOMES;
	CLASS=Neighborhood;
	MODEL SalePrice=GrLIvArea;
	RUN;

/* Subset for homes in the neighborhoods of interest */
/* Subset the data to include only the neighborhoods of interest */
DATA HOMESP1a;
SET HOMES;
IF Neighborhood EQ "NAmes" | Neighborhood EQ "BrkSide" | Neighborhood EQ "Edwards";
/*IF GrLivArea LT 4000;*/
IF SalePrice LT 300000;
IF SaleCondition EQ "Normal";
GrLivArea100 = ROUND(GrLivArea, 100); /*FLOOR(GrLivArea);*/
logGrLivArea100 = log(GrLivArea100);
logSalePrice = log(SalePrice);
RUN;

/* d1 = NAmes, d2 = BrkSide, Control = Edwards */
DATA HOMESP1b;
SET HOMESP1a;
		if Neighborhood = 'NAmes' then d1 = 1; else d1=0;
		if Neighborhood = 'BrkSide' then d2 = 1; else d2=0;
		int1 = d1*GrLivArea100; int2 = d2*GrLivArea100;
RUN;

PROC SGPLOT DATA=HOMESP1b;
HISTOGRAM logGrLivArea100;
DENSITY logGrLivArea100/TYPE=NORMAL;
TITLE "Histogram of Gross Living Area in NAmes, BrkSide, and Edwards"
RUN;

PROC SGPLOT DATA=homesp1b;
SCATTER X=GrLivArea100 Y=SalePrice;
TITLE "Gross Living Area vs Sale Price in NAmes, BrkSide, and Edwards"
RUN;

PROC REG DATA=homesp1a;
model SalePrice = GrLivArea100;
model logSalePrice = GrLivArea100;
model SalePrice = logGrLivArea100;
model logSalePrice = logGrLivArea100;
RUN;

PROC SGPLOT DATA=homesp1b;
SCATTER X=GrLivArea Y=SalePrice;
TITLE "Gross Living Area vs Sale Price in NAmes, BrkSide, and Edwards";
RUN;

/* Model to examine if there is a difference between the three neighborhoods */
PROC REG DATA=HOMESP1b; /*Dummy Variables*/
	model SalePrice = GrLivArea100 d1 d2 int1 int2/VIF;
	title 'Regression of Sale Price on Gross Living Area with Interaction Terms';
	RUN;

PROC MEANS DATA=homesp1b;
var GrLivArea100 d1 d2;
run;

/* With GrLivArea > 4000 included AND SalePrice >300000 INCLUDED*/
DATA center;
set Homesp1b;
cent1 = (GrLivArea100 - 1303.4)*(d1-0.588);
cent2 = (GrLivArea100 - 1303.4)*(d2-0.151);
RUN;


/* With GrLivArea > 4000 REMOVED
DATA center;
set Homesp1b;
cent1 = (GrLivArea100 - 1283.2)*(d1-0.591);
cent2 = (GrLivArea100 - 1283.2)*(d2-0.152);
RUN;
 */

/* With GrLivArea > 4000 AND SalePrice > 300000 REMOVED
DATA center;
set Homesp1b;
cent1 = (GrLivArea100 - 1278.36)*(d1-0.591);
cent2 = (GrLivArea100 - 1278.36)*(d2-0.360);
RUN;
 */

PROC REG DATA=center;
model SalePrice = GrLivArea100 d1 d2 cent1 cent2/VIF;
RUN;

PROC GLM DATA=homesp1a PLOT=ALL;
CLASS Neighborhood;
model SalePrice=GrLivArea100|Neighborhood/solution;
RUN;