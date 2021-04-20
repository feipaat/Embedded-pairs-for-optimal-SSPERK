function [U, T, exactError, stepperInfo] = Euler1D(stepper, order, tol, prb, UEXACT, dataFile)
% File: Euler1D.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date:
% Purpose: Integrate 1D Euler equation until FinalTime using an WENO scheme choice of RK
% at prescribed tolerance Atol = Rtol = tol

addpath('utils','methods','controllerAlgorithms','problems');
time         = 0;
cfl_stepSize = 0;
plotSolution = false;
stepSizeInfo = [];

Q = prb.Q;
U = Q(:);
T = time;

if plotSolution
    figure('Position',[100 100 1200 400])
    subplot(3,1,1); rho_line = plot(prb.x, Q(:,1), '-r'); ylabel('density');
    subplot(3,1,2); vel_line = plot(prb.x, Q(:,2), '-k'); ylabel('velocity');
    subplot(3,1,3); p_line = plot(prb.x, Q(:,3), '-b'); ylabel('pressure');
    %t_ts = title(sprintf('time = %4.3f, t-step = %d', time, tstep));
    pause(0.1);
end

% define WENO5 parameters
% Initialize reconstrcution weights
m    = 3;
Crec = initReconstructionWeights(m);
dw   = LinearWeights(m, 0);% Initialize linear weights
beta = computeSmoothnessIndicator(m);% compute smoothness indicator matrices

% Initialize Euler RHS evaluator
EulerWENOcharrhs(Q, [], [], prb.x, prb.h, m, Crec, [], dw, beta, prb.gamma);

% Set timestep
[~, ~, maxvel] = EulerClosure_IdealGas(Q, prb.gamma);
k              = prb.CFL*prb.h/maxvel;

% get the optimal starting step-size
[dt, nfcn_starting] = startingStepSize(Q, k, maxvel, @EulerWENOcharrhs,tol, tol, order);
k                   = min(k, dt);

format long;
disp('running...')
try
    % Start Integration
    while (time < prb.FinalTime)

        max_stepSize = prb.FinalTime - time;
        cfl_stepSize = prb.CFL*prb.h/maxvel;

        if prb.FinalTime < (time + k)
            k = max_stepSize;
        else % also enforce the CFL condition
            max_stepSize = min(max_stepSize,cfl_stepSize);
        end
        
        old_k = k;
        % take step
        [time, Q, k, stepStatus] = stepper(@EulerWENOcharrhs, Q, time, k,maxvel, max_stepSize);
        single_info              = [time old_k stepStatus];
        stepSizeInfo             = [stepSizeInfo; single_info];
        [k time]
        
        if stepStatus
            U = [U Q(:)];
            T = [T; time];
        end
        
        if plotSolution
            %time = time + k; tstep = tstep + 1;
            set(rho_line, 'ydata', Q(:,1));
            set(vel_line, 'ydata', Q(:,2));
            set(p_line, 'ydata', Q(:,3));
            %set(t_ts, 'string', sprintf('time = %4.3f, t-step = %d', time, tstep));
            drawnow; pause(0.001);
        end
        
        [~, ~, maxvel] = EulerClosure_IdealGas(Q, prb.gamma);
    end
catch err
    [~, ~,Nfcn, Nstep, Naccpt, Nrejct] = stepSizeControl([], [], [],  [], [], [], [], [], [], true);
    stepperInfo.nfcn = Nfcn + nfcn_starting;
    stepperInfo.Nstep = Nstep;
    stepperInfo.Naccpt = Naccpt;
    stepperInfo.Nrejct = Nrejct;
    exactError = nan;
    return
end

assert(abs(time - prb.FinalTime) < eps(1e-14),...
    'Final Time is not correct');

disp('done...')
exactError = norm(Q(:) - UEXACT(:),2);
[~, ~,Nfcn, Nstep, Naccpt, Nrejct] = stepSizeControl([], [], [],  [], [], [], [], [], [], true);
stepperInfo.nfcn   = Nfcn + nfcn_starting;
stepperInfo.Nstep  = Nstep;
stepperInfo.Naccpt = Naccpt;
stepperInfo.Nrejct = Nrejct;

save(dataFile);
end
