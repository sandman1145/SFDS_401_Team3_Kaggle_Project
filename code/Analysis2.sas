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
		  BldgType (param=ref split) HouseStyle (param=ref split) OverallQual (param=ordinal order=data)
		  OverallCond (param=ordinal order=data) RoofMatl (param=ref split) Exterior1st (param=ref split)
		  Exterior2nd (param=ref split) MasVnrArea (param=ref split) ExterQual (param=ordinal order=data)
		  ExterCond (param=ordinal order=data) Foundation (param=ref split) BsmtQual (param=ordinal order=data)
		  BsmtExposure (param=ref split) BsmtFinType1 (param=ref split) BsmtFinType2 (param=ref split)
		  Heating (param=ref split) HeatingQC (param=ordinal order=data) CentralAir (param=ordinal order=data)
		  Electrical (param=ref split) KitchenQual (param=ordinal order=data) Functional (param=ordinal order=data)
		  FireplaceQu (param=ordinal order=data) GarageType (param=ref split) GarageFinish (param=ref split)
		  GarageQual (param=ordinal order=data) GarageCond (param=ordinal order=data) PavedDrive (param=ref split)
		  PoolQC (param=ordinal order=data) Fence (param=ordinal order=data) MiscFeature (param=ordinal order=data)
		  SaleType (param=ref split) SaleCondition (param=ref split) LotFrontage (param=ordinal order=data)
		  / delimiter = ',' showcoding; 
MODEL SalePrice = LotArea YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF
				  _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath 
				  BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars GarageArea WoodDeckSF
				  OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold
/ selection =Forward(stop=CV) cvmethod=random(5) stats=adjrsq;
RUN;

PROC GLMSELECT DATA=HOMES;
	CLASS MSSubClass (param=ref split) MSZoning (param=ref split)   Street (param=ref split) 
		  Alley (param=ref split) LotShape (param=ref split) LandContour (param=ref split)
		  Utilities (param=ref split) LotConfig (param=ref split) LandSlope (param=ref split)
		  Neighborhood (param=ref split) Condition1 (param=ref split) Condition2 (param=ref split)
		  BldgType (param=ref split) HouseStyle (param=ref split) OverallQual (param=ordinal order=data)
		  OverallCond (param=ordinal order=data) RoofMatl (param=ref split) Exterior1st (param=ref split)
		  Exterior2nd (param=ref split) MasVnrArea (param=ref split) ExterQual (param=ordinal order=data)
		  ExterCond (param=ordinal order=data) Foundation (param=ref split) BsmtQual (param=ordinal order=data)
		  BsmtExposure (param=ref split) BsmtFinType1 (param=ref split) BsmtFinType2 (param=ref split)
		  Heating (param=ref split) HeatingQC (param=ordinal order=data) CentralAir (param=ordinal order=data)
		  Electrical (param=ref split) KitchenQual (param=ordinal order=data) Functional (param=ordinal order=data)
		  FireplaceQu (param=ordinal order=data) GarageType (param=ref split) GarageFinish (param=ref split)
		  GarageQual (param=ordinal order=data) GarageCond (param=ordinal order=data) PavedDrive (param=ref split)
		  PoolQC (param=ordinal order=data) Fence (param=ordinal order=data) MiscFeature (param=ordinal order=data)
		  SaleType (param=ref split) SaleCondition (param=ref split) LotFrontage (param=ordinal order=data)
		  / delimiter = ',' showcoding; 
MODEL SalePrice = LotArea YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF
				  _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath 
				  BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars GarageArea WoodDeckSF
				  OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold
/ selection =Backward(stop=CV) cvmethod=random(5) stats=adjrsq;
RUN;

PROC GLMSELECT DATA=HOMES;
	CLASS MSSubClass (param=ref split) MSZoning (param=ref split)   Street (param=ref split) 
		  Alley (param=ref split) LotShape (param=ref split) LandContour (param=ref split)
		  Utilities (param=ref split) LotConfig (param=ref split) LandSlope (param=ref split)
		  Neighborhood (param=ref split) Condition1 (param=ref split) Condition2 (param=ref split)
		  BldgType (param=ref split) HouseStyle (param=ref split) OverallQual (param=ordinal order=data)
		  OverallCond (param=ordinal order=data) RoofMatl (param=ref split) Exterior1st (param=ref split)
		  Exterior2nd (param=ref split) MasVnrArea (param=ref split) ExterQual (param=ordinal order=data)
		  ExterCond (param=ordinal order=data) Foundation (param=ref split) BsmtQual (param=ordinal order=data)
		  BsmtExposure (param=ref split) BsmtFinType1 (param=ref split) BsmtFinType2 (param=ref split)
		  Heating (param=ref split) HeatingQC (param=ordinal order=data) CentralAir (param=ordinal order=data)
		  Electrical (param=ref split) KitchenQual (param=ordinal order=data) Functional (param=ordinal order=data)
		  FireplaceQu (param=ordinal order=data) GarageType (param=ref split) GarageFinish (param=ref split)
		  GarageQual (param=ordinal order=data) GarageCond (param=ordinal order=data) PavedDrive (param=ref split)
		  PoolQC (param=ordinal order=data) Fence (param=ordinal order=data) MiscFeature (param=ordinal order=data)
		  SaleType (param=ref split) SaleCondition (param=ref split) LotFrontage (param=ordinal order=data)
		  / delimiter = ',' showcoding; 
MODEL SalePrice = LotArea YearBuilt YearRemodAdd BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF
				  _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath 
				  BedroomAbvGr KitchenAbvGr TotRmsAbvGrd Fireplaces GarageYrBlt GarageCars GarageArea WoodDeckSF
				  OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal MoSold YrSold
/ selection =Stepwise(stop=CV) cvmethod=random(5) stats=adjrsq;
RUN;
