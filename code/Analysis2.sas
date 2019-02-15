/* Dummy Code File for Group Project */

data crabs;
	infile '/folders/myfolders/MSDS6371/HW12/Datasets/Crab17.csv' 
	missover delimiter=',' firstobs=2;
	input Force Height Species $;
	logForce = log(Force);
	logHeight = log(Height);
	sqrtForce = sqrt(Force);
	sqrtHeight = sqrt(Height);
	invForce = 1/Force;
	invHeight = 1/Height;
run;

PROC REG DATA=crabs;
	model Force = Height;
	model logForce = Height;
	model Force = logHeight;
	model logForce = logHeight;
	model sqrtForce = Height;
	model Force = sqrtHeight;
	model sqrtForce = sqrtHeight;
	model invForce = Height;
	model Force = invHeight;
	model invForce = invHeight;
RUN;