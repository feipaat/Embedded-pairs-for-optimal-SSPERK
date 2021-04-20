function [x, h, Q] = initAdvection(N)
% File: initAdvection.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Initialize Advection problem

x  = linspace(-1, 1, N)';
h  = x(2) - x(1);
y0 = @(x) heaviside(flipud(x) - (ceil((x+1)/2) -1)*2);
Q  = y0(x);
end
