function h_acc = pidController(order, nstep, err, dt)
% File: pidControler.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: PID Controller algorithm

persistent k err_old
if isempty(k)
k              = [0.58; 0.21; 0.1];
stepController = @PIDControler;
err_old        = [1; 1; 1];
end


if nstep == 1
    err_old(1) = err;
elseif nstep == 2
    err_old(2) = err_old(1);
    err_old(1) = err;
else
    err_old(3) = err_old(2);
    err_old(2) = err_old(1);
    err_old(1) = err;
end

k1    = -k(1)/order;
k2    = k(2)/order;
k3    = -k(3)/order;
e1    = max(err_old(1), 1e-10);
e2    = max(err_old(2), 1e-10);
e3    = max(err_old(3), 1e-10);
h_acc = (e1^k1)*(e2^k2)*(e3^k3);
hnew  = h_acc;
end %PIDControler
