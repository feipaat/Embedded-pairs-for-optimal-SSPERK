%getODESolution.m
% Purpose: get the solution of the ODE at Tfinal (for comparison purpose)


clear all; clc; close all;

problem = 'eulerShort'; %advection/burgers
logPath = 'exactSolution';

NonlinearEps = 1e-14;
discretizer = 'WENO';   % ENO/WENO
% order of the method ( spatial )
m = 3;

% Set Problem paramters
problemType = 'sod';
L = 1;
FinalTime = 0.2;
N = 256;
CFL = 0.90;
gamma = 1.4;
[x, h, Q] = initEuler(problemType, gamma, L, N);

% Initialize linear weights
dw = LinearWeights(m, 0);
Crec = initReconstructionWeights(m);

% compute smoothness indicator matrices
beta = computeSmoothnessIndicator(m);

Eulerflux = @( t, Q) EulerWENOcharrhs(Q, [], [], x, h, m, Crec, [], dw, beta, gamma);


ode45_options = odeset('RelTol',NonlinearEps,'AbsTol',NonlinearEps);
warning('off');

odefunc = @(t,u) Eulerflux(t,u);

[T,SOL] = ode45(@(t,y) odefunc(t, y),[0 FinalTime],...
    Q,ode45_options);

assert(abs(T(end) - FinalTime) < eps(1e-14),...
    'Final Time is not correct');

sol = SOL(end,:); sol = sol(:);
referenceSolution = sol;

fileName = sprintf('%s/%s_exactSolution.mat',logPath,problem);
save(fileName);

Q = sol;
Q = reshape(Q,[], 3);

subplot(3,1,1); rho_line = plot(x, Q(:,1), '-r'); ylabel('density');
subplot(3,1,2); vel_line = plot(x, Q(:,2), '-k'); ylabel('velocity');
subplot(3,1,3); p_line = plot(x, Q(:,3), '-b'); ylabel('pressure');
