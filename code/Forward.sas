*--------------------------------------------------------*
* Import train.csv		  	 							 *
*--------------------------------------------------------*;

* FILENAME REFFILE '/home/mwolfe0/train.csv';
FILENAME REFFILE '/folders/myfolders/MSDS6371/GroupProject/Datasets/train.csv';


PROC IMPORT DATAFILE=REFFILE DBMS=CSV REPLACE OUT=HOMES;
	GETNAMES=YES;
RUN;

*--------------------------------------------------------*
| Code for forward selection 							 |
| Set seed to a constant for model comparison            |
| Class variable input with split option to allow 	 	 |
|       classification variable to be able to enter or   |
|       leave the model independently                    |
| Stop=CV specifies the model will stop when the         |
|       predicted residual sum of square is reached with |
|       k-fold cross validation                          |
| CVMethod specifies how subsets ar formed for           |
|       cross validation                                 |   
*--------------------------------------------------------*;

PROC GLMSELECT DATA=HOMES SEED=71669132;
CLASS MSSubClass MSZoning   Street  
		  Alley  LotShape  LandContour 
		  Utilities  LotConfig LandSlope
		  Neighborhood  Condition1  Condition2 
		  BldgType  HouseStyle  OverallQual
		  OverallCond  RoofMatl Exterior1st 
		  Exterior2nd  MasVnrArea  ExterQual 
		  ExterCond  Foundation  BsmtQual 
		  BsmtExposure  BsmtFinType1  BsmtFinType2 
		  Heating  HeatingQC  CentralAir 
		  Electrical KitchenQual  Functional 
		  FireplaceQu  GarageType  GarageFinish 
		  GarageQual  GarageCond  PavedDrive 
		  PoolQC  Fence  MiscFeature 
		  SaleType  SaleCondition  LotFrontage 
		  / split;
MODEL SalePrice = LotArea YearBuilt YearRemodAdd 
				  BsmtFinSF1 BsmtFinSF2 BsmtUnfSF 
				  TotalBsmtSF _1stFlrSF _2ndFlrSF 
				  LowQualFinSF GrLivArea BsmtFullBath 
				  BsmtHalfBath FullBath HalfBath 
				  BedroomAbvGr KitchenAbvGr TotRmsAbvGrd 
				  Fireplaces GarageYrBlt GarageCars 
				  GarageArea WoodDeckSF OpenPorchSF 
				  EnclosedPorch _3SsnPorch ScreenPorch 
				  PoolArea MiscVal MoSold YrSold 
				  MSSubClass MSZoning Street 
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
				  / selection =forward(stop=CV) cvmethod=random(5)
				  stats=all;
RUN;

	
		  
		 
