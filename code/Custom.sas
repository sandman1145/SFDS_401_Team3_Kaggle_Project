*--------------------------------------------------------*
* Import train.csv		  	 							 *

	*--------------------------------------------------------*;
FILENAME REFFILE '/home/mwolfe0/train.csv';
FILENAME REFFILE2 '/home/mwolfe0/test.csv';
*FILENAME REFFILE '/folders/myfolders/MSDS6371/GroupProject/Datasets/train.csv';
*FILENAME REFFILE2 '/folders/myfolders/MSDS6371/GroupProject/Datasets/test.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV REPLACE OUT=TRAIN;
	GETNAMES=YES;
RUN;

PROC IMPORT DATAFILE=REFFILE2 DBMS=CSV REPLACE OUT=TEST;
	GETNAMES=YES;
RUN;

DATA HOMES;
	SET TRAIN TEST;
	Age=2019-YearBuilt;
	Impression=OverallQual + OverallCond/2;
RUN;

*--------------------------------------------------------*
| Code for custom GLM model 							 |
| Draft for now, needs finalizing			             |   

	*--------------------------------------------------------*;

PROC GLM DATA=HOMES PLOTS=ALL;
	CLASS BsmtQual OverallQual RoofMatl;
	MODEL SalePrice=GrLivArea TotalBsmtSF FirstFlrSF SecondFlrSF Age Impression / 
		TOLERANCE SOLUTION;
	OUTPUT OUT=RESULTS P=PREDICT;
	RUN;

DATA RESULTS_CUST;
	SET RESULTS;

	IF PREDICT > 0 THEN
		SalePrice=Predict;

	IF PREDICT < 0 THEN
		SalePrice=10000;
	KEEP id SalePrice;
	WHERE id > 1460;
RUN;

PROC EXPORT DATA=RESULTS_BW FILE='/home/mwolfe0/results_cust.csv' DBMS=CSV 
		REPLACE;
RUN;