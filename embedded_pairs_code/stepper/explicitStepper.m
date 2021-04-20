function [time, y,dt, stepStatus, controller] = explicitStepper(fluxFnc, Q, time, k, maxvel, dtMax, varargin)
% File: explicitStepper.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: RK Stepper for PDEs


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

controller = stepController;
sysSize    = size(Q,2);
u0         = Q(:);
rhs        = fluxFnc(Q, k, maxvel);
Fvec(:,1)  = rhs(:);

% intermediate stage value
for i = 2:rk.s
    temp = u0;
    for j = 1:i-1
        temp = temp + k*rk.A(i,j)*Fvec(:, j);
    end
    temp = reshape(temp,[],sysSize);
    rhs = fluxFnc(temp,  k, maxvel);
    Fvec(:, i) = rhs(:);
end

% combine
Q = u0 + k*Fvec*rk.b(:);

% combine for the embedded solution
Qhat = u0 + k*Fvec*rk.bt(:);

% get the optimal step-size and current status
[dt, stepStatus] = stepSizeControl(min(rk.p, rk.phat), dtMax,...
    k,  Q, Qhat, stepController, tol, tol, rk.s);

if ~stepStatus
    Q = u0;
else
    time = time + k;
end

y = reshape(Q, [], sysSize);
end
