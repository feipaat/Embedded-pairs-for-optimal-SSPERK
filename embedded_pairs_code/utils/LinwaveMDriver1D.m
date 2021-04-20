% LinwaveMDriver1D.m : define the driver

% setting the intial conditions and specifuing the computaional domain
% the grid size h,
% and the CFL number and the linear wave equation is integrated in time though LinwaveM1D.m

% Driver script for solving the 1D wave equations using monotone scheme
clear('all'); close('all'); clc;

% set problem parameters
L = 2;
FinalTime = 4.0;
N = 100;
h = 2/(N);
CFL = 1;
test = 3;
xwrap = @(x) x - (ceil((x+1)/2) -1)*2;


if test == 1
    %define wavetest function paramter
    aw = 0.5;
    zw = -0.7;
    deltaw = 0.005;
    alphaw = 10;
    betaw = log(2)/(36*deltaw^2);
    ufunc = @(x) wavetest(xwrap(x), aw, zw, deltaw, alphaw, betaw);
elseif test == 2
    ufunc = @(x) sin(pi*x);
elseif test == 3
    ufunc = @(x) 1*(xwrap(x) >= 0);
end

% Define domain and initial conditions
x = [-1:h:1]';

% Solve Problem
[ u ] = LinwaveM1D(ufunc, x, h, CFL, FinalTime);



