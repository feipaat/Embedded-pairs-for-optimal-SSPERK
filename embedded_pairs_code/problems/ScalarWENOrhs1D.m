function [du] = ScalarWENOrhs1D(Q, k, maxvel, varargin)
% function [du] = ScalarENOrhs1D(x, u, h, k, m, Crec, maxvel, flux)
% File: ScalarWENOrhs1D.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Evaluate the RHS of Scalar1d equation using WENO reconstruction

persistent Crec dw beta x h m
persistent flux
persistent um up um_s up_s

if ~isempty(varargin)
    x = varargin{1};
    h = varargin{2};
    m = varargin{3};
    Crec = varargin{4};
    flux = varargin{5};
    dw = varargin{6};
    beta = varargin{7};

    N = length(Q);
    % define cell left and right interface values
    um = zeros(N+2, 1);
    up = zeros(N+2, 1);

    um_s = zeros(N+2, 1);
    up_s = zeros(N+2, 1);
    return
end

N = length(Q);

% extend data using boundary condition
[~, ue] = extend(x, Q, h, m, 'P', 2, 'P', 0);

for i = 1:N+2
    [um(i), up(i)] = WENO([], ue(i:(i+2*(m-1))), m , Crec, dw, beta);
end

du = - (ScalarLF(up(2:N+1), um(3:N+2), 0, maxvel, flux) - ScalarLF(up(1:N), um(2:N+1), 0, maxvel, flux))/h;
end
