% Driver script for solving the 1D Euler equations using WENO scheme
clear all; close all; clc
addpath('utils/');
addpath('methods');

global rk discretizer problem erk enforceCFL;

% method
rk = literatureMethods('heuneuler21');

% Controler Options
controller = 'I'; % I/ExplicitGustafsson

erk = EmbeddedRK('RungeKutta',rk, 'RelativeTolerance',1e-4,...
'AbsoluteTolerance',1e-4,'Name','Merson45', 'Controller',controller);

% step-size should be bounded by CFL restriction also;
enforceCFL = false;

% spatial discretization method
discretizer = 'WENO';   % ENO/WENO
problem = 'advection';

% order of the method ( spatial )
m = 3;

% set problem parameters
FinalTime = 1;
N = 10;
CFL = 0.90;
[x, h, Q] = initAdvection(N);

flux = @(u) u;
maxvel = @(q) max(abs(q));

% Solver Problem
[u] = Scalar1D(x, Q, h, m, CFL, FinalTime, flux, maxvel, []);




erk.summary
plotEmbeddedStepSize;
