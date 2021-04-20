function h_acc = iController(order, nstep, err, dt)
% File: iController.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: I Controller algorithm

k     = 1;
k1    = -k/order;
e1    = max(err, 1e-10);
h_acc = (e1^k1);
end %IControler
