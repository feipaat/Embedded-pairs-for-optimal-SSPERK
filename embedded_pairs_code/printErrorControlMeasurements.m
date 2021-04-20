% File: printErrorControlMeasurements.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 04/03/2017
% Purpose: compute and print the error control measurements

clear all; close all; clc

addpath('methods');

problem = 'vdp';
problem = 'brusselator';
problem = 'advectionShort';
problem = 'eulerShort';

pathMain    = 'finalResults';
order       = 4;
printFigure = false;
useLogLog   = true;
testAll     = true;

% testChoice = {'ImreVsMine', 'NewVsLiterature', 'allOfThem'};
testChoice = 'NewVsLiterature';

if isequal(order, 2)
    method_fun = str2func('secondOrderMethodToTest');
elseif isequal(order, 3)
    method_fun = str2func('thirdOrderMethodToTest');
elseif isequal(order, 4)
    method_fun = str2func('fourthOrderMethodToTest');
elseif isequal(order, 5)
    method_fun = str2func('bestMethodComparison');
end

[LIST_OF_METHOD, orderPath] = method_fun(testAll, testChoice);
numb_method                 = numel(LIST_OF_METHOD);
names                       = cell(size(LIST_OF_METHOD));
ERR                         = nan(8, numel(LIST_OF_METHOD));

for mth_id = 1:numb_method

        method = LIST_OF_METHOD{mth_id};
        if isfield(method, 'useName')
            mth_name = method.useName;
        else
            mth_name = method.name;
        end
        names{mth_id}  = mth_name;
        [err_control ] = get_error_control_func(method.A, method.b(:), method.bt(:), method.p, method.phat);
        ERR(:,mth_id)  = err_control(:);
end

ERR'
