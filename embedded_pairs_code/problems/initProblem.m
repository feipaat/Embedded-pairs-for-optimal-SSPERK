function [prb] = initProblem(problem)
% File: initProblem.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Initialize the problem

addpath('problems');

if strcmpi(problem, 'euler')
    prb.problemType = 'sod';
    prb.L           = 1;
    prb.FinalTime   = 0.2;
    prb.N           = 512;
    prb.CFL         = 0.90;
    prb.gamma       = 1.4;
    [x, h, Q]       = initEuler(prb.problemType, prb.gamma, prb.L, prb.N);
    prb.x           = x;
    prb.h           = h;
    prb.Q           = Q;
elseif strcmpi(problem, 'eulerShort')
    prb.problemType = 'sod';
    prb.L           = 1;
    prb.FinalTime   = 0.15;
    prb.N           = 256;
    prb.CFL         = 0.90;
    prb.gamma       = 1.4;
    [x, h, Q]       = initEuler(prb.problemType, prb.gamma, prb.L, prb.N);
    prb.x           = x;
    prb.h           = h;
    prb.Q           = Q;
elseif strcmpi(problem, 'burgers')
    prb.L           = 1;
    prb.problemType = 'square';  % sin/square
    prb.FinalTime   = 0.5;
    prb.N           = 501;
    prb.CFL         = 0.90;
    [x, h, Q]       = initBurgers(prb.problemType, prb.L, prb.N);
    prb.x           = x;
    prb.h           = h;
    prb.Q           = Q;
    prb.flux        = @(u) 0.5*u.^2;
    prb.maxvel      = @(q) max(abs(q));
elseif strcmpi(problem, 'burgersShort')
    prb.L           = 1;
    prb.problemType = 'square';  % sin/square
    prb.FinalTime   = 0.2;
    prb.N           = 256;
    prb.CFL         = 0.90;
    [x, h, Q]       = initBurgers(prb.problemType, prb.L, prb.N);
    prb.x           = x;
    prb.h           = h;
    prb.Q           = Q;
    prb.flux        = @(u) 0.5*u.^2;
    prb.maxvel      = @(q) max(abs(q));
elseif strcmpi(problem, 'advection')
    prb.FinalTime = 1;
    prb.N         = 256;
    prb.CFL       = 0.90;
    [x, h, Q]     = initAdvection(prb.N);
    prb.x         = x;
    prb.h         = h;
    prb.Q         = Q;
    prb.flux      = @(u) u;
    prb.maxvel    = @(q) max(abs(q));
elseif strcmpi(problem, 'advectionShort')
    prb.FinalTime = 0.20;
    prb.N         = 256;
    prb.CFL       = 0.90;
    [x, h, Q]     = initAdvection(prb.N);
    prb.x         = x;
    prb.h         = h;
    prb.Q         = Q;
    prb.flux      = @(u) u;
    prb.maxvel    = @(q) max(abs(q));
elseif strcmpi(problem, 'buckleyleverett')
    prb.FinalTime = 0.20;
    prb.N         = 256;
    prb.CFL       = 0.90;
    [x, h, Q]     = initBurgers(prb.problemType, prb.L, prb.N);
    prb.x         = x;
    prb.h         = h;
    prb.Q         = Q;
    prb.flux      = @(u) u.^2./(u.^2 + 1.0/3.0*(1-u).^2);;
    prb.maxvel    = @(q) max(abs(q));
elseif strcmpi(problem, 'vdp')
    prb.FinalTime = 2.0;
    prb.odeObj    = initODE(problem);
elseif strcmpi(problem, 'brusselator')
    prb.FinalTime = 20.0;
    prb.odeObj    = initODE(problem);
else
    error('problem choice not recognized');
end

end
