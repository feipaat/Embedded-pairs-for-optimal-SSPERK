function [hnew, stepSizeControlStatus,Nfcn, Nstep, Naccpt, Nrejct] = stepSizeControl(order, maxStepSize, dt,  y, yhat, stepController, relTol, absTol, s, varargin)
% File: stepSizeControl.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: 
% Automatic Step Size Control
% Hairer. Solving ODE I. pg. 167

persistent dtMax nfcn stepSize
persistent facMin fac facMax MAXFAC
persistent nstep naccpt nrejct
persistent lte Controllerstatus lastStepRejected

if isempty(nstep)
    nstep            = 0; naccpt = 0; nrejct = 0; nfcn = 0;
    Controllerstatus = true;
    lastStepRejected = false;
    fac              = 0.9; facMin = 0.1; facMax = 5; MAXFAC = facMax;
    dtMax            = maxStepSize;
    lte              = []; stepSize = [];
end

if ~isempty(varargin) && varargin{1}
    hnew                  = dt;
    stepSizeControlStatus = true;
    Nstep                 = nstep; Naccpt = naccpt; Nrejct = nrejct; Nfcn = nfcn;
    return
end

dtMax = max(dtMax, maxStepSize);
nstep = nstep + 1; % mark that a step has been taken

%INFO: this is for explicit method
nfcn = nfcn + (s -1);

stepSize = [stepSize; dt];
lte_     = abs(y - yhat); lte = [lte; norm(lte_, 2)];
sk       = sci_fun(relTol, absTol, y, yhat);
err      = norm(lte_./sk,inf);

% call choice of step-control algorithm here
beta  = stepController(order, nstep, err, dt);
alpha = max(facMin, fac * beta); alpha = min(facMax, alpha);
hnew  = dt*alpha;

if (err - 1) < eps(16) % accept the solution
    Controllerstatus = [Controllerstatus; true]; naccpt = naccpt + 1; %oldT = t;

    if (lastStepRejected) %if last step was rejected
        hnew = min(hnew, dt);
    else
        facMax = MAXFAC;
    end
    lastStepRejected = false;
else % reject the solution
    Controllerstatus = [Controllerstatus; false]; lastStepRejected = true; facMax = 0.9;
    if (naccpt > 0); nrejct = nrejct + 1; end
end

hnew = min(hnew, dtMax);
%should the step-size be too small
if abs(hnew) < 1e-14; error('Step-Size too small'); end
stepSizeControlStatus = ~lastStepRejected;
Nstep = nstep; Naccpt = naccpt; Nrejct = nrejct; Nfcn = nfcn;
end
