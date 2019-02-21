FILENAME REFFILE '/home/mwolfe0/train.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV REPLACE OUT=HOMES;
	GETNAMES=YES;
RUN;

PROC CORR DATA=HOMES;
RUN;

symbol c=blue v=dot;

PROC SGSCATTER DATA=HOMES;
MATRIX SalePrice GrLivArea LotArea OverallQual;
RUN;

PROC REG DATA=HOMES;
MODEL SalePrice = GrLivArea LotArea OverallQual/VIF;
RUN;

/*PROC GLMSELECT DATA=HOMES;
	CLASS MSSubClass  MSZoning    Street  
		  Alley  LotShape  LandContour 
		  Utilities  LotConfig  LandSlope 
		  Neighborhood  Condition1  Condition2 
		  BldgType  HouseStyle  OverallQual 
		  OverallCond  RoofMatl  Exterior1st 
		  Exterior2nd  MasVnrArea  ExterQual 
		  ExterCond  Foundation  BsmtQual 
		  BsmtExposure  BsmtFinType1  BsmtFinType2 
		  Heating  HeatingQC  CentralAir 
		  Electrical  KitchenQual  Functional 
		  FireplaceQu  GarageType  GarageFinish 
		  GarageQual  GarageCond  PavedDrive 
		  PoolQC  Fence  MiscFeature 
		  SaleType  SaleCondition  LotFrontage 
		  / delimiter = ',' showcoding; 
MODEL SalePrice = LotArea YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF
				  _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath 
				  BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars GarageArea WoodDeckSF
				  OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold
/ selection =Backward(stop=CV) cvmethod=random(5) stats=adjrsq;
RUN;*/

PROC GLMSELECT DATA=HOMES;
	CLASS MSSubClass  MSZoning    Street  
		  Alley  LotShape  LandContour 
		  Utilities  LotConfig  LandSlope 
		  Neighborhood  Condition1  Condition2 
		  BldgType  HouseStyle  OverallQual 
		  OverallCond  RoofMatl  Exterior1st 
		  Exterior2nd  MasVnrArea  ExterQual 
		  ExterCond  Foundation  BsmtQual 
		  BsmtExposure  BsmtFinType1  BsmtFinType2 
		  Heating  HeatingQC  CentralAir 
		  Electrical  KitchenQual  Functional 
		  FireplaceQu  GarageType  GarageFinish 
		  GarageQual  GarageCond  PavedDrive 
		  PoolQC  Fence  MiscFeature 
		  SaleType  SaleCondition  LotFrontage 
		  / delimiter = ',' showcoding; 
MODEL SalePrice = LotArea YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF
				  LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath 
				  BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars GarageArea WoodDeckSF
				  OpenPorchSF EnclosedPorch ScreenPorch PoolArea MiscVal MoSold YrSold
/ selection=backward(select=SL SLS=0.1) stats=adjrsq;
RUN;
