function hnew = explicitGustafssonController(order, nstep, err, dt)
% File: ExpGustafssonController.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Explicit Gustafsson controller

persistent k err_old
if isempty(k)
    k       = [0.367; 0.268];
    err_old = 1;
end

if nstep == 1 % on the first step
    k1      = -1/order;
    e1      = max(err, 1e-10);
    h_acc   = (err^k1);
    err_old = err;
else % on the subsequent steps
    k1         = -k(1)/order;
    k2         = k(2)/order;
    scaled_err = (err/err_old);
    e1         = max(err, 1e-10);
    h_acc      = (e1^k1)*(scaled_err^k2);
    err_old    = err;
end

hnew = h_acc;
end
