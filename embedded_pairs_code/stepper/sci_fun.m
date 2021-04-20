function sk = sci_fun(relTol, absTol, y, yhat)
% File: sci_fun.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: 

sk = absTol + relTol * max(abs(y), abs(yhat));
end
