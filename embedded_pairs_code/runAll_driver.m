function runAll_driver(order, problem,contrl, mthid_n, testAll)
% File: runAll_driver.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: For a selected method, and choice of controller (contrl),
% integrate the problem at range of tolerance level


addpath('methods');

if isequal(order, 2)
    method_fun = str2func('secondOrderMethodToTest');
elseif isequal(order, 3)
    method_fun = str2func('thirdOrderMethodToTest');
elseif isequal(order, 4)
    method_fun = str2func('fourthOrderMethodToTest');
elseif isequal(order, 5)
    method_fun = str2func('bestMethodComparison');
end

[list_of_method, orderPath] = method_fun(testAll);
num_method = numel(list_of_method);
if numel(mthid_n) == 1 && mthid_n > num_method
    return
end

TOL = [1e-2 1e-3 1e-4 1e-5 1e-6 1e-7];
for mthid = mthid_n
    for tolid = 1:length(TOL)
        Driver_efficiency(contrl, order, problem, mthid, tolid, testAll);
    end
    clear Driver_efficiency
end

end
