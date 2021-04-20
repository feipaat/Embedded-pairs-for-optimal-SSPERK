function [x, h, Q] = initBurgers(problemType, L, N)
% File: initBurgers.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Initialize Burgers

x = linspace(0, 0.25, N)';
h = x(2) - x(1);

if strcmpi(problemType, 'sin')
    y0 = @(x,t) sin(2*pi*x);
elseif strcmpi(problemType, 'square')
    t = 0;
    y0 = @(x, t) 1*double( x(:) >= 0.1 & x(:) <= 0.15) + 0.5*double(x(:) > 0.15 & x(:) <= 0.2);
end
Q = y0(x,0);
end
