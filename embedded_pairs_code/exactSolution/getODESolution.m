%getODESolution.m
% Purpose: get the solution of the ODE at Tfinal (for comparison purpose)


clear all; clc; close all;

problem = 'vdp'; %brusselator/vdp
logPath = 'exactSolution';

NonlinearEps = 1e-14;

if strcmpi(problem, 'vdp')
    FinalTime = 2.0;
    odeObj = initODE(problem);
    
elseif strcmpi(problem, 'brusselator')
    FinalTime = 20.0;
    odeObj = initODE(problem);
    
end

ode45_options = odeset('RelTol',NonlinearEps,'AbsTol',NonlinearEps);
warning('off');

odefunc = @(t,u) odeObj.f(t,u);

[T,SOL] = ode45(@(t,y) odefunc(t, y),[0 FinalTime],...
    odeObj.y0,ode45_options);

assert(abs(T(end) - FinalTime) < eps(1e-14),...
    'Final Time is not correct');

sol = SOL(end,:); sol = sol(:);
referenceSolution = sol;

fileName = sprintf('%s/%s_exactSolution.mat',logPath,problem);
save(fileName);

plot(T, SOL(:,1), '-r')
hold on
plot(T, SOL(:,2), '-k')