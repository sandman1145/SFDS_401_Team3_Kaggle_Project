*--------------------------------------------------------*
| Import train.csv                                       |
| Import test.csv                                        |
| Set REFFILE for train.csv                              |
| Set REFFILE2 for test.csv                              |
*--------------------------------------------------------*;
 FILENAME REFFILE
 '/folders/myfolders/MSDS6371/GroupProject/Datasets/train.csv'; 

/* FILENAME REFFILE */
/* "C:\Users\cwale\OneDrive\Desktop\SMU\Winter18\StatsFoundation\
Case_Study\Data\train.csv"; */

/*FILENAME REFFILE2 */
/* "C:\Users\cwale\OneDrive\Desktop\SMU\Winter18\StatsFoundation\
Case_Study\Data\test.csv" */

FILENAME REFFILE2
'/folders/myfolders/MSDS6371/GroupProject/Datasets/test.csv';


PROC IMPORT OUT= WORK.train
            DATAFILE= REFFILE
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= WORK.test
            DATAFILE= REFFILE2 
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
| Code for custom GLM model                              |
| NOTE: SAS online "_1st" will not run must change to    |
|       first same for _2nd                              |
| Code works as is in SAS University Edition             |   
*--------------------------------------------------------*;
ods graphics on;
PROC GLM DATA=HOMES PLOTS=ALL;
	CLASS BsmtQual OverallQual OverallQual OverallCond 
	Neighborhood BldgType SaleCondition HouseStyle;
	MODEL SalePrice = GrLivArea _1stFlrSF _2ndFlrSF Age 
	Neighborhood BldgType SaleCondition RemodFactor 
	OverallQual OverallCond HouseStyle/ p clparm
		TOLERANCE SOLUTION;
	OUTPUT OUT=RESULTS P=PREDICT;
	RUN;
ods graphics off;
/* .148 - GrLivArea _1stFlrSF _2ndFlrSF Age Neighborhood 
BldgType SaleCondition LotArea RemodFactor OverallQual 
OverallCond HouseStyle */


DATA RESULTS_CUST;
	SET RESULTS;

	IF PREDICT > 0 THEN
		SalePrice=Predict;

	IF PREDICT < 0 THEN
		SalePrice=10000;
	KEEP id SalePrice;
	WHERE id > 1460;
RUN;

FILENAME REFFILE3 
'/folders/myfolders/MSDS6371/GroupProject/Datasets/results_cust.csv';
/* FILENAME REFFILE3
C:\Users\cwale\OneDrive\Desktop\results_cust.csv */

PROC EXPORT DATA=RESULTS_CUST FILE=REFFILE3 DBMS=CSV 
		REPLACE;
RUN;