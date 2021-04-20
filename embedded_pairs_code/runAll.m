clear all; close all; clc

addpath('methods');

TOL = [1e-2 1e-3 1e-4 1e-5 1e-6 1e-7];

%problem = 'vdp';
%problem = 'brusselator';
%problem = 'advection';
%problem = 'burgers';
%problem = 'burgersShort';
problem = 'euler';

% Controler Options:
% IController/PIController/PIDController/ExplicitGustafsson
controller = 'IController';

for order = 2%4:-1:2
    
    if isequal(order, 2)
        secondOrderMethodToTest;
    elseif isequal(order, 3)
        thirdOrderMethodToTest;
    elseif isequal(order, 4)
        fourthOrderMethodToTest;
    else
        error('Order choice not recognized!!');
    end
    
    for tol_id = 1:6
        for mth_id = 1:numel(LIST_OF_METHOD)
            Driver_efficiency('IController', order, problem, mth_id, tol_id);
            Driver_efficiency('PIController', order, problem, mth_id, tol_id);
            %Driver_efficiency('PIDController', order, problem, mth_id, tol_id);
            %Driver_efficiency('ExplicitGustafsson', order, problem, mth_id, tol_id);
        end
    end
    
end
