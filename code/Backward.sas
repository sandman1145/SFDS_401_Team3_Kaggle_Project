*--------------------------------------------------------*
| Import train.csv                                       |
| Import test.csv                                        |
| Set REFFILE for train.csv                              |
| Set REFFILE2 for test.csv                              |
*--------------------------------------------------------*;

*FILENAME REFFILE '/home/mwolfe0/train.csv';
*FILENAME REFFILE2 '/home/mwolfe0/test.csv';
FILENAME REFFILE 
'/folders/myfolders/MSDS6371/GroupProject/Datasets/train.csv';
FILENAME REFFILE2 
'/folders/myfolders/MSDS6371/GroupProject/Datasets/test.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV REPLACE OUT=TRAIN;
	GETNAMES=YES;
RUN;

PROC IMPORT DATAFILE=REFFILE2 DBMS=CSV REPLACE OUT=TEST;
	GETNAMES=YES;
RUN;

*--------------------------------------------------------*
| Combine train and test into one datafile HOMES         |
*--------------------------------------------------------*;

DATA HOMES;
	SET TRAIN TEST;
RUN;

*--------------------------------------------------------*
| Code for backward selection                            |
| Set seed to a constant for model comparison            |
| Class variable input with split option to allow        |
|       classification variable to be able to enter or   |
|       leave the model independently                    |
| Stop=10 specifies the model will stop selection at the |
|       first step for which the selected model has 10   |
|       effects                                          |
| CVMethod specifies how subsets ar formed for           |
|       cross validation                                 |
| OUTPUT Dataset to RESULTS with the predicted variable  |
|        based on the final model                        |   
*--------------------------------------------------------*;

PROC GLMSELECT DATA=HOMES SEED=71669132;
	CLASS MSSubClass MSZoning Street Alley LotShape LandContour 
		  Utilities LotConfig LandSlope Neighborhood Condition1 
		  Condition2 BldgType HouseStyle OverallQual OverallCond 
		  RoofMatl Exterior1st Exterior2nd MasVnrArea ExterQual 
		  ExterCond Foundation BsmtQual BsmtExposure BsmtFinType1 
		  BsmtFinType2 Heating HeatingQC CentralAir Electrical 
		  KitchenQual Functional FireplaceQu GarageType 
		  GarageFinish GarageQual GarageCond PavedDrive PoolQC 
		  Fence MiscFeature SaleType SaleCondition LotFrontage 
		  / split;
	MODEL SalePrice=LotArea YearBuilt YearRemodAdd BsmtFinSF1 
		  BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF _2ndFlrSF 
		  LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath 
		  FullBath HalfBath BedroomAbvGr KitchenAbvGr 
		  TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars 
		  GarageArea WoodDeckSF OpenPorchSF EnclosedPorch 
		  _3SsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
		  MSSubClass MSZoning Street Alley LotShape LandContour 
		  Utilities LotConfig LandSlope Neighborhood Condition1 
		  Condition2 BldgType HouseStyle OverallQual OverallCond 
		  RoofMatl Exterior1st Exterior2nd MasVnrArea ExterQual 
		  ExterCond Foundation BsmtQual BsmtExposure BsmtFinType1 
		  BsmtFinType2 Heating HeatingQC CentralAir Electrical 
		  KitchenQual Functional FireplaceQu GarageType 
		  GarageFinish GarageQual GarageCond PavedDrive PoolQC 
		  Fence MiscFeature SaleType SaleCondition LotFrontage
	/ selection =backward(stop=10) cvmethod=random(5) 
	             stats=ADJRSQ stats=PRESS;
	OUTPUT OUT=RESULTS P=PREDICT;
RUN;

*--------------------------------------------------------*
| Create a datafile RESULTS_BW of predicted values for   |
| SalePrice for house id greater than 1460 which         |
| is where the Kaggle test set data begins.              |
*--------------------------------------------------------*;

DATA RESULTS_BW;
	SET RESULTS;

	IF PREDICT > 0 THEN
		SalePrice=Predict;

	IF PREDICT < 0 THEN
		SalePrice=10000;
	KEEP id SalePrice;
	WHERE id > 1460;
RUN;

*--------------------------------------------------------*
| Export a datafile for predicted values for             |
| SalePrice for house id greater than 1460 which         |
| is where the Kaggle test set data begins.              |
*--------------------------------------------------------*;

*FILENAME REFFILE3 '/home/mwolfe0/results_bw.csv';
FILENAME REFFILE3 
'/folders/myfolders/MSDS6371/GroupProject/Datasets/results_bw.csv';

PROC EXPORT DATA=RESULTS_BW FILE=REFFILE3 DBMS=CSV REPLACE;
RUN;