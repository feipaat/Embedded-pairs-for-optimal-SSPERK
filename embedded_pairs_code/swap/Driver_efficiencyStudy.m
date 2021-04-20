% Driver script for solving the 1D Euler equations using WENO scheme
clear all; close all; clc
addpath('utils/');
addpath('methods');

global rk discretizer problem erk enforceCFL;

%INFO: some rejected step counts are unaccounted for.
%   where did they go??
% this is because I only start counting rejected steps only after a first
% successful/accepted step has been taken. So in the case when the step are
% rejected right away, those rejections are not recorded. Is this the right
% thing to do?????

% method

rk = literatureMethods('merson45');
%rk = loadMyMethods(3, 2);
%rk = imre_second_order(2, 2, 'b1');
%rk = imre_third_order(4, 3, 'b2')
name = rk.name;

% choice of problem
% euler/maxwell  OR
% advection/burgers  OR
% vdp/brusselator
problem = 'vdp';

%logFile = sprintf('logs/%s_%s.log',problem,name);
logFile = 'testing-merson45.log';
fid = fopen(logFile,'w');

% Controler Options
controller = 'I'; % I/ExplicitGustafsson

for tol = 1e-4;%[1e-2 1e-4 1e-5 1e-7]
    
    
    erk = EmbeddedRK('RungeKutta',rk, 'RelativeTolerance',tol,...
        'AbsoluteTolerance',tol,'Name',name, 'Controller',controller);
    
    
    % step-size should be bounded by CFL restriction also;
    enforceCFL = false;
    
    % spatial discretization method
    discretizer = 'WENO';   % ENO/WENO
    
    
    % order of the method ( spatial )
    m = 3;
    
    if strcmpi(problem, 'euler')
        % Set Problem paramters
        problemType = 'sod';
        L = 1;
        FinalTime = 0.2;
        N = 512;
        CFL = 0.90;
        gamma = 1.4;
        [x, h, Q] = initEuler(problemType, gamma, L, N);
        
        % Solve Problem
        [r, ru, E] = Euler1D(x, Q, h, m, CFL, gamma, FinalTime);
    elseif strcmpi(problem, 'maxwell')
        % set problem parameters
        L = 2;
        FinalTime = 1.5;
        N = 256;
        ep = [1.0 2.25];
        mu = [1.0 1.0];
        CFL = 0.90;
        [x, h, EM, ep, mu] = initMaxwell(ep, mu, L, N);
        
        % Solver Problem
        [Ef, Hf] = Maxwell1D(x, EM, ep, mu, h, m, CFL, FinalTime);
    elseif strcmpi(problem, 'burgers')
        % set problem parameters
        L = 1;
        problemType = 'square';  % sin/square
        FinalTime = 0.5;
        N = 501;
        CFL = 0.90;
        [x, h, Q] = initBurgers(problemType, L, N);
        
        flux = @(u) 0.5*u.^2;
        % Solver Problem
        [u] = Scalar1D(x, Q, h, m, CFL, FinalTime, flux);
    elseif strcmpi(problem, 'advection')
        % set problem parameters
        FinalTime = 1;
        N = 256;
        CFL = 0.90;
        [x, h, Q] = initAdvection(N);
        
        flux = @(u) u;
        
        % Solver Problem
        [u] = Scalar1D(x, Q, h, m, CFL, FinalTime, flux);
        
    elseif strcmpi(problem, 'vdp')
        FinalTime = 2.0;
        odeObj = initODE(problem);
        
        [u] = SimpleODE1D(odeObj.y0, odeObj, FinalTime);
        
    elseif strcmpi(problem, 'mathiew')
        FinalTime = 2.0;
        odeObj = initODE(problem);
        
        [u] = SimpleODE1D(odeObj.y0, odeObj, FinalTime);
    elseif strcmpi(problem, 'brusselator')
        FinalTime = 20.0;
        odeObj = initODE(problem);
        
        [u] = SimpleODE1D(odeObj.y0, odeObj, FinalTime);
    end
    
    erk.summary(fid);
end

fclose(fid);
%plotEmbeddedStepSize;