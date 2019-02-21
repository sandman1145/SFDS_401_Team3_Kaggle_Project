FILENAME REFFILE '/home/mwolfe0/train.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV REPLACE OUT=HOMES;
	GETNAMES=YES;
RUN;

PROC CORR DATA=HOMES;
RUN;

SYMBOL C=BLUE V=DOT;

PROC SGSCATTER DATA=HOMES;
	MATRIX SalePrice GrLivArea LotArea OverallQual;
RUN;

PROC REG DATA=HOMES;
	MODEL SalePrice=GrLivArea LotArea OverallQual/VIF;
	RUN;

PROC GLMSELECT DATA=HOMES;
	CLASS MSSubClass MSZoning Street Alley LotShape LandContour Utilities 
		LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle 
		OverallQual OverallCond RoofMatl Exterior1st Exterior2nd MasVnrArea ExterQual 
		ExterCond Foundation BsmtQual BsmtExposure BsmtFinType1 BsmtFinType2 Heating 
		HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType 
		GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature 
		SaleType SaleCondition LotFrontage FirstFlrSF SecondFlrSF ThreeSsnPorch / 
		DELIMITER=',' SHOWCODING;
	MODEL SalePrice=LotArea YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF 
		TotalBsmtSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath 
		HalfBath BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt 
		GarageCars GarageArea WoodDeckSF OpenPorchSF EnclosedPorch ScreenPorch 
		PoolArea MiscVal MoSold YrSold / SELECTION=BACKWARD(STOP=SL SLS=0.05) 
		STATS=ADJRSQ;
RUN;