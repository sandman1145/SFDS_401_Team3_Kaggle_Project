/* FILENAME REFFILE '/home/mwolfe0/train.csv'; */
FILENAME REFFILE '/folders/myfolders/MSDS6371/GroupProject/Datasets/train.csv';


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

PROC GLMSELECT DATA=HOMES;
	CLASS MSSubClass (param=ref split) MSZoning (param=ref split)   Street (param=ref split) 
		  Alley (param=ref split) LotShape (param=ref split) LandContour (param=ref split)
		  Utilities (param=ref split) LotConfig (param=ref split) LandSlope (param=ref split)
		  Neighborhood (param=ref split) Condition1 (param=ref split) Condition2 (param=ref split)
		  BldgType (param=ref split) HouseStyle (param=ref split) OverallQual (param=ref split)
		  OverallCond (param=ref split) RoofMatl (param=ref split) Exterior1st (param=ref split)
		  Exterior2nd (param=ref split) MasVnrArea (param=ref split) ExterQual (param=ref split)
		  ExterCond (param=ref split) Foundation (param=ref split) BsmtQual (param=ref split)
		  BsmtExposure (param=ref split) BsmtFinType1 (param=ref split) BsmtFinType2 (param=ref split)
		  Heating (param=ref split) HeatingQC (param=ref split) CentralAir (param=ref split)
		  Electrical (param=ref split) KitchenQual (param=ref split) Functional (param=ref split)
		  FireplaceQu (param=ref split) GarageType (param=ref split) GarageFinish (param=ref split)
		  GarageQual (param=ref split) GarageCond (param=ref split) PavedDrive (param=ref split)
		  PoolQC (param=ref split) Fence (param=ref split) MiscFeature (param=ref split)
		  SaleType (param=ref split) SaleCondition (param=ref split) LotFrontage (param=ref split)
		  / delimiter = ',' ; 
MODEL SalePrice = LotArea YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF
				  _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath 
				  BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars GarageArea WoodDeckSF
				  OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
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
/ selection =Forward(stop=CV) cvmethod=random(5) stats=ADJRSQ;
RUN;

PROC GLMSELECT DATA=HOMES;
	CLASS MSSubClass MSZoning Street  
		  Alley LotShape LandContour 
		  Utilities LotConfig LandSlope 
		  Neighborhood Condition1 Condition2 
		  BldgType HouseStyle OverallQual
		  OverallCond RoofMatl Exterior1st
		  Exterior2nd MasVnrArea ExterQual
		  ExterCond Foundation BsmtQual
		  BsmtExposure BsmtFinType1 BsmtFinType2
		  Heating HeatingQC CentralAir 
		  Electrical KitchenQual Functional 
		  FireplaceQu GarageType GarageFinish 
		  GarageQual GarageCond PavedDrive
		  PoolQC Fence MiscFeature
		  SaleType SaleCondition LotFrontage; 
MODEL SalePrice = LotArea YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF
				  _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath 
				  BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars GarageArea WoodDeckSF
				  OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
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
/ selection =Backward(stop=CV) cvmethod=random(5) stats=ADJRSQ;
RUN;

PROC GLMSELECT DATA=HOMES;
	CLASS MSSubClass (param=ref split) MSZoning (param=ref split)   Street (param=ref split) 
		  Alley (param=ref split) LotShape (param=ref split) LandContour (param=ref split)
		  Utilities (param=ref split) LotConfig (param=ref split) LandSlope (param=ref split)
		  Neighborhood (param=ref split) Condition1 (param=ref split) Condition2 (param=ref split)
		  BldgType (param=ref split) HouseStyle (param=ref split) OverallQual (param=ref split)
		  OverallCond (param=ref split) RoofMatl (param=ref split) Exterior1st (param=ref split)
		  Exterior2nd (param=ref split) MasVnrArea (param=ref split) ExterQual (param=ref split)
		  ExterCond (param=ref split) Foundation (param=ref split) BsmtQual (param=ref split)
		  BsmtExposure (param=ref split) BsmtFinType1 (param=ref split) BsmtFinType2 (param=ref split)
		  Heating (param=ref split) HeatingQC (param=ref split) CentralAir (param=ref split)
		  Electrical (param=ref split) KitchenQual (param=ref split) Functional (param=ref split)
		  FireplaceQu (param=ref split) GarageType (param=ref split) GarageFinish (param=ref split)
		  GarageQual (param=ref split) GarageCond (param=ref split) PavedDrive (param=ref split)
		  PoolQC (param=ref split) Fence (param=ref split) MiscFeature (param=ref split)
		  SaleType (param=ref split) SaleCondition (param=ref split) LotFrontage (param=ref split)
		  / delimiter = ',' ; 
MODEL SalePrice = LotArea YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF
				  _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath 
				  BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars GarageArea WoodDeckSF
				  OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold 
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
/ selection =Stepwise(stop=CV) cvmethod=random(5) stats=ADJRSQ;*/
RUN;
