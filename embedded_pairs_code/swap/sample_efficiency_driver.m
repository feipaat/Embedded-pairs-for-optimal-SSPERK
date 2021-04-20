clear all; close all; clc

PROB = 'vdp';
%order = 2; numb_method = 8;
order = 3; numb_method = 6;
% order = 4; numb_method = 13;

for mth_id = 1:numb_method
   for tol_id = 1:6
       Driver_efficiency(order, PROB, mth_id, tol_id);
   end
end