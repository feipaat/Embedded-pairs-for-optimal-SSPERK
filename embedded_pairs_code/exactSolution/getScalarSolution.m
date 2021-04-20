%getODESolution.m
% Purpose: get the solution of the ODE at Tfinal (for comparison purpose)


clear all; clc; close all;
addpath('../problems','../utils');

problem = 'burgersShort'; %advection/burgers
logPath = 'exactSolution';

NonlinearEps = 1e-14;
discretizer = 'WENO';   % ENO/WENO
% order of the method ( spatial )
m = 3;

if strcmpi(problem, 'burgers')
    % set problem parameters
    L = 1;
    problemType = 'square';  % sin/square
    FinalTime = 0.5;
    N = 501;
    CFL = 0.90;
    [x, h, Q] = initBurgers(problemType, L, N);
    
    flux = @(u) 0.5*u.^2;
    maxvel = max(abs(Q));
elseif strcmpi(problem, 'buckleyleverett')
    % set problem parameters
    FinalTime = 0.20;
    L = 1;
    problemType = 'square';  % sin/square
    N = 256;
    CFL = 0.90;
    [x, h, Q] = initBurgers(problemType, L, N);

    flux = @(u) u.^2./(u.^2 + 1.0/3.0*(1-u).^2);;
    maxvel = max(abs(Q));

    
elseif strcmpi(problem, 'advection')
    % set problem parameters
    FinalTime = 1;
    N = 256;
    CFL = 0.90;
    [x, h, Q] = initAdvection(N);
    
    flux = @(u) u;
    maxvel = max(abs(Q));
elseif strcmpi(problem, 'advectionShort')
    % set problem parameters
    FinalTime = 0.20;
    N = 256;
    CFL = 0.90;
    [x, h, Q] = initAdvection(N);
    
    flux = @(u) u;
    maxvel = max(abs(Q));
elseif strcmpi(problem, 'burgersShort')
    L = 1;
    problemType = 'square';  % sin/square
    FinalTime = 0.2;
    N = 256;
    CFL = 0.90;
    [x, h, Q] = initBurgers(problemType, L, N);
    
    flux = @(u) 0.5*u.^2;
    maxvel = max(abs(Q));
end

keyboard
% Initialize reconstrcution weights
Crec = initReconstructionWeights(m);

% Initialize linear weights
dw = LinearWeights(m, 0);

% compute smoothness indicator matrices
beta = computeSmoothnessIndicator(m);

ScalarWENOrhs1D(Q, [], [], x, h, m, Crec, flux, dw, beta);

Scalarflux = @(t, Q) ScalarWENOrhs1D(Q, t, maxvel);


ode45_options = odeset('RelTol',NonlinearEps,'AbsTol',NonlinearEps);
warning('off');

odefunc = @(t,u) Scalarflux(t,u);

[T,SOL] = ode45(@(t,y) odefunc(t, y),[0 FinalTime],...
    Q,ode45_options);

assert(abs(T(end) - FinalTime) < eps(1e-14),...
    'Final Time is not correct');

sol = SOL(end,:); sol = sol(:);
referenceSolution = sol;

fileName = sprintf('%s_exactSolution.mat',problem);
save(fileName);

plot(x, sol, '-r')
