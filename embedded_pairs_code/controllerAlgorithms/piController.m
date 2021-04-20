function h_acc = piController(order, nstep, err, dt)
% File: piControler.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: May 26, 2019
% Purpose: PI Controller algorithm

persistent err_old k
if isempty(err_old)
    err_old = [1; 1];
    k       = [0.8; 0.31];
end

if nstep == 1
    err_old(1) = err;
else
    err_old(2) = err_old(1);
    err_old(1) = err;
end

k1         = -k(1)/order;
k2         = k(2)/order;
e1         = max(err_old(1), 1e-10);
e2         = max(err_old(2), 1e-10);
h_acc      = (e1^k1)*(e2^k2);
err_old(2) = err;
hnew       = h_acc;
end
