function [x, h, Q] = initEuler(problemType, gamma, L, N)
% File: initEuler.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Initialize Euler problem 

h = L/N;

% Define domain, materials and initial conditions
[r, ru, E] = deal(zeros(N+1, 1));

U   = [r; ru; E];
rr  = U(1:N+1);
rru = U(N+2:2*(N+1));
ee  = U(2*(N+1)+1:3*(N+1));

if strcmpi(problemType , 'sod')
    % Initialize for Sod's problem
    x        = [0:h:1]'; indX = x < 0.5;
    r( indX) = 1;
    r(~indX) = 0.125;
    E( indX) = 1/(gamma - 1);
    E(~indX) = 0.1/(gamma - 1);
    
else
    assert(false);
    % Initialize for shock entropy problem
    % FIX: (NOT working) Vectors must be the same length.
    x = [-5:h:5]';
    x = linspace(-5, 5, N+1)';
    h = x(2) - x(1);
    for i = 1:N+1
        if x(i) < -4
            rh = 2.857143;
            u = 2.2629369;
            p = 10.333333;
        else
            rh = 1 + 0.2*sin(pi*x(i));
            u = 0;
            p = 1;
        end
        r(i) = rh;
        ru(i) = rh*u;
        E(i) = p/(gamma - 1) + 0.5*rh*u^2;
    end
end

Q = [r ru E];
end
