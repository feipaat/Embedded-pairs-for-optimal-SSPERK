function [probObj] = initODE(problemType)
% File: initODE.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Initialize ODE problem


if strcmpi(problemType, 'vdp')
    y0         = [2; -0.6654321];
    t          = 0;
    ep         = 1e-1;
    f          = @(t, u) [u(2);(1/ep)*(-u(1) + (1 - u(1)^2)*u(2))];
    probObj.y0 = y0;
    probObj.ep = 0.1;
    probObj.f  = f;
    probObj.t  = t;
elseif strcmpi(problemType, 'mathiew')
    y0         = [1; 0];
    t          = 0;
    a          = 1;
    b          = 2;
    f          = @(t, u) [u(2); -(a - b*cos(2*t))*u(1)];
    probObj.y0 = y0;
    probObj.f  = f;
    probObj.t  = t;
elseif strcmpi(problemType, 'curtiss-hirschfelder')
    y0            = 1;
    t             = 0;
    f             = @(t, u) -50*(u - cos(t));
    exact         = @(t,u) (2500/2501)*cos(t) + (50/2501)*sin(t) + (1/2501)*exp(-50*t);
    probObj.y0    = y0;
    probObj.f     = f;
    probObj.t     = t;
    probObj.exact = exact;
elseif strcmpi(problemType, 'brusselator')
    probObj.t  = 0;
    probObj.y0 = [1.01; 3];
    probObj.f  = @(t, u) [ 1 + u(2)*u(1)^2 - 4*u(1);
                            3*u(1) - u(2)*u(1)^2];
end
end
