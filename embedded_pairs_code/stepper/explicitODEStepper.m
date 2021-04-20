function [t, y,dt, stepStatus, controller] = explicitODEStepper(Q, t, k, dtMax, varargin)
% File: explicitODEStepper.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: RK stepper for the ODEs

persistent rk tol prb
persistent Fvec sysSize stepController

if ~isempty(varargin)
    rk         = varargin{1};
    controller = varargin{2};
    tol        = varargin{3};
    prb        = varargin{4};
    n          = length(Q(:));
    Fvec       = zeros(n, rk.s);

    if strcmpi(controller, 'IController');
        stepController = @iController;
   elseif strcmpi(controller, 'PIController');
       stepController = @piController;
   elseif strcmpi(controller, 'PIDController');
       stepController = @pidController;
   elseif strcmpi(controller, 'ExplicitGustafsson');
       stepController = @explicitGustafssonController;
    end
   return
end

odeFlux    = prb.odeObj.f;
controller = stepController;
sysSize    = size(Q,2);
u0         = Q(:);
fluxFnc    = prb.odeObj.f;
rhs        = fluxFnc(0, u0);
Fvec(:,1)  = rhs(:);

% intermediate stage value
for i = 2:rk.s
    temp = u0;
    for j = 1:i-1
        temp = temp + k*rk.A(i,j)*Fvec(:, j);
    end
    temp = reshape(temp,[],sysSize);
    rhs = fluxFnc(0, temp);
    Fvec(:, i) = rhs(:);
end

% combine
Q = u0 + k*Fvec*rk.b(:);

% combine for the embedded solution
Qhat = u0 + k*Fvec*rk.bt(:);

% get the optimal step-size and current status
[dt, stepStatus] = stepSizeControl(min(rk.p, rk.phat), dtMax, ...
    k,  Q, Qhat, stepController, tol, tol, rk.s);

if ~stepStatus; 
    Q = u0;
else
    t = t + k;
end

%FIXME: is this really needed?
y = reshape(Q, [], sysSize);
end
