function [U, T, exactError, stepperInfo] = Scalar1D(stepper, order, tol, prb, UEXACT, dataFile)
% File: Scalar1D.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date:
% Purpose: Integrate 1D Scalar PDE equation until FinalTime using an WENO scheme choice of RK
% at prescribed tolerance Atol = Rtol = tol

addpath('utils','methods','controllerAlgorithms','problems');
time         = 0;
cfl_stepSize = 0;
max_stepSize = 0;

Q = prb.Q;

U            = Q;
T            = time;
stepSizeInfo = [];
plotSolution = false;

% make sure to set the final time
prb.FinalTime;


if plotSolution
    u_line = plot(prb.x, Q, '-r', 'LineWidth',2);
    plt_title = title(sprintf('time = %4.3f, t-step = %d', time, tstep));
    pause(0.1);
end

% define WENO5 parameters
% Initialize reconstrcution weights
m    = 3;
Crec = initReconstructionWeights(m);
dw   = LinearWeights(m, 0);% Initialize linear weights
beta = computeSmoothnessIndicator(m);% compute smoothness indicator matrices

% Initialize Scalar RHS Evaluator
ScalarWENOrhs1D(Q, [], [], prb.x, prb.h, m, Crec, prb.flux, dw, beta);

% Set timestep
maxvel = prb.maxvel(Q);
k = prb.CFL*prb.h/maxvel;

% get the optimal starting step-size
[dt, nfcn_starting] = startingStepSize(Q, k, maxvel, @ScalarWENOrhs1D,tol, tol, order);

format long;

%integrate scheme
try
    % Start Integration
    while (time < prb.FinalTime)

        max_stepSize = prb.FinalTime - time;
        cfl_stepSize = prb.CFL*prb.h/maxvel;

        if prb.FinalTime < (time + k)
            k = max_stepSize;
        else % also enforce the CFL condition
            max_stepSize = max_stepSize;
        end

        old_k = k;

        % Update solution ( call the stepper )
        [time, Q, k, stepStatus] = stepper(@ScalarWENOrhs1D, Q, time, k,maxvel, max_stepSize);
        single_info             = [time old_k stepStatus];
        stepSizeInfo            = [stepSizeInfo; single_info];
        [k time]

        if stepStatus
            U = [U Q];
            T = [T; time];
        end

        if plotSolution
            set(u_line, 'ydata', Q(:,1));
            set(plt_title, 'string', sprintf('time = %4.3f, t-step = %d', time, tstep));
            drawnow;
            pause(0.1);
        end

        maxvel = prb.maxvel(Q);
    end
catch err
    [~, ~,Nfcn, Nstep, Naccpt, Nrejct] = stepSizeControl([], [], [],  [], [], [], [], [], [], true);
    stepperInfo.nfcn   = Nfcn + nfcn_starting;
    stepperInfo.Nstep  = Nstep;
    stepperInfo.Naccpt = Naccpt;
    stepperInfo.Nrejct = Nrejct;
    exactError         = nan;
    return
end

assert(abs(time - prb.FinalTime) < eps(1e-14),...
    'Final Time is not correct');

exactError = norm(Q(:) - UEXACT(:),2);
[~, ~,Nfcn, Nstep, Naccpt, Nrejct] = stepSizeControl([], [], [],  [], [], [], [], [], [], true);
stepperInfo.nfcn   = Nfcn + nfcn_starting;
stepperInfo.Nstep  = Nstep;
stepperInfo.Naccpt = Naccpt;
stepperInfo.Nrejct = Nrejct;

save(dataFile);
end
