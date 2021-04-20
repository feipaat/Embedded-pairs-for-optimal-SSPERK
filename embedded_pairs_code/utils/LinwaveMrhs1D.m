function [ du ] = LinwaveMrhs1D(x, u, h, k, maxvel, flux)
% LinwaveMrhs1D.m : Definition of right hand side for the linear wave equation

% function [ du ] = LinwaveMrhs1D(x, u, h, k, maxvel)
% Purpose: Evaluate right hand side for linear wave equation 
% using monotone method

N = length(x);
% Periodic boundary conditions
[xe, ue] = extend(x, u, h, 1, 'P', 0, 'P', 0);

% Compute RKS - Change numerical flux here
switch lower(flux)
    case {'lw'}
        du = -(LinwaveLW(ue(2:N+1), ue(3:N+2), k/h, maxvel) - LinwaveLW( ue(1:N), ue(2:N+1), k/h, maxvel))/h;
    case {'lf'}
        du = -(LinwaveLF(ue(2:N+1), ue(3:N+2), k/h, maxvel) - LinwaveLW( ue(1:N), ue(2:N+1), k/h, maxvel))/h;
    case {'roe'}
        du = -(LinwaveRoe(ue(2:N+1), ue(3:N+2), k/h, maxvel) - LinwaveRoe( ue(1:N), ue(2:N+1), k/h, maxvel))/h;
    case {'uw'}
        du = -( LinwaveUW(ue(2:N+1), ue(3:N+2), k/h, maxvel) - LinwaveRoe( ue(1:N), ue(2:N+1), k/h, maxvel))/h;
end
end
