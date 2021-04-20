function [U, T, exactError, stepperInfo] = SimpleODE1D(stepper, order, tol, prb, UEXACT, dataFile)
% File: SimpleODE1D.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date:
% Purpose: Run the ODE problems (VDP/Brusselator)

addpath('utils','methods','controllerAlgorithms','problems');

time  = 0;
tstep = 0;
y     = prb.odeObj.y0(:);

% store it as a column vector
U            = y;
T            = time;
odeFlux      = prb.odeObj.f;
stepSizeInfo = [];

% Get the "optimal" starting-step size for the problem
[k, nfcn_starting] = startingStepSize_ODE(1e-5, y, odeFlux, tol, tol, order);

format long

try
    % Integrate problem to FinalTime
    while (time < prb.FinalTime)

        if prb.FinalTime < (time + k)
            k = prb.FinalTime - time;
            max_stepSize = k;
        else
            max_stepSize = prb.FinalTime - time;
        end

        old_k = k;

        % Update solution ( call the stepper )
        [time,y, k, stepStatus] = stepper(y, time, k, max_stepSize);
        single_info             = [time old_k stepStatus];
        stepSizeInfo            = [stepSizeInfo; single_info];
        [k time]

        if stepStatus
            U = [U y];
            T = [T; time];
        end
    end

catch err
    if strcmpi(err.message, 'Step-Size too small')
        [~, ~,Nfcn, Nstep, Naccpt, Nrejct] = stepSizeControl([], [], [],  [], [], [], [], [], [], true);
        stepperInfo.nfcn                   = Nfcn + nfcn_starting;
        stepperInfo.Nstep                  = Nstep;
        stepperInfo.Naccpt                 = Naccpt;
        stepperInfo.Nrejct                 = Nrejct;
        exactError                         = nan;
        return
    end
end

try
    % make sure we are computing the error at the same time
    assert(abs(time - prb.FinalTime) < eps(1e-14),...
    'Final Time is not correct');
catch err2
    % something went wrong???
    keyboard 
end

% the global error
exactError = norm(y(:) - UEXACT(:),2);

[~, ~,Nfcn, Nstep, Naccpt, Nrejct] = stepSizeControl([], [], [],  [], [], [], [], [], [], true);
stepperInfo.nfcn                   = Nfcn + nfcn_starting;
stepperInfo.Nstep                  = Nstep;
stepperInfo.Naccpt                 = Naccpt;
stepperInfo.Nrejct                 = Nrejct;

% save the results and all other metadata data so its easier for me to restart the run (if needed)
save(dataFile);
end
