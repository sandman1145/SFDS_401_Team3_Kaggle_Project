*--------------------------------------------------------*
* Import train.csv		  	 							 *
*--------------------------------------------------------*;
PROC IMPORT OUT= WORK.train
            DATAFILE= "C:\Users\cwale\OneDrive\Desktop\SMU\Winter18\StatsFoundation\Case_Study\Data\train.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= WORK.test
            DATAFILE= "C:\Users\cwale\OneDrive\Desktop\SMU\Winter18\StatsFoundation\Case_Study\Data\test.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;


/*PROC IMPORT DATAFILE=REFFILE DBMS=CSV REPLACE OUT=TRAIN;*/
/*	GETNAMES=YES;*/
/*RUN;*/
/**/
/*PROC IMPORT DATAFILE=REFFILE2 DBMS=CSV REPLACE OUT=TEST;*/
/*	GETNAMES=YES;*/
/*RUN;*/

DATA HOMES;
	SET TRAIN TEST;
	Age=2019-YearBuilt;
	RemodFactor = YearRemodAdd - YearBuilt;
	Impression=OverallQual + OverallCond/2;
RUN;









*--------------------------------------------------------*
| Code for custom GLM model 							 |
| Draft for now, needs finalizing			             |   
*--------------------------------------------------------*;

PROC GLM DATA=HOMES PLOTS=ALL;
	CLASS BsmtQual OverallQual OverallQual OverallCond Neighborhood BldgType SaleCondition HouseStyle;
	MODEL SalePrice = GrLivArea _1stFlrSF _2ndFlrSF Age Neighborhood BldgType SaleCondition RemodFactor OverallQual OverallCond HouseStyle/ 
		TOLERANCE SOLUTION;
	OUTPUT OUT=RESULTS P=PREDICT;
	RUN;

/* .148 - GrLivArea _1stFlrSF _2ndFlrSF Age Neighborhood BldgType SaleCondition LotArea RemodFactor OverallQual OverallCond HouseStyle */


DATA RESULTS_CUST;
	SET RESULTS;

	IF PREDICT > 0 THEN
		SalePrice=Predict;

	IF PREDICT < 0 THEN
		SalePrice=10000;
	KEEP id SalePrice;
	WHERE id > 1460;
RUN;

PROC EXPORT DATA=RESULTS_CUST FILE='"C:\Users\cwale\OneDrive\Desktop\results_cust.csv' DBMS=CSV 
		REPLACE;
RUN;
