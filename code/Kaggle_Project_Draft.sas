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
RUN;


/* d1 = NAmes, d2 = BrkSide, Control = Edwards */
DATA HOMESP1b;
SET HOMESP1a;
		if Neighborhood = 'NAmes' then d1 = 1; else d1=0;
		if Neighborhood = 'BrkSide' then d2 = 1; else d2=0;
		int1 = d1*GrLivArea; int2 = d2*GrLivArea;
RUN;

/* Model to examine if there is a difference between the three neighborhoods */
PROC REG DATA=HOMESP1b; /*Dummy Variables*/
	model SalePrice = GrLivArea d1 d2 int1 int2/VIF;
	title 'Regression of Sale Price on Gross Living Area with Interaction Terms';
	RUN;