clear all; close all; clc
% File: printGoodTable.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: create tables for method comparison
% for choice of problem and order


addpath('methods');
warning('off');
problem = 'vdp';
%problem = 'brusselator';
%problem = 'advectionShort';
%problem = 'eulerShort';

%pathMain    = 'finalResults';
pathMain = 'dataSaveNew';
order       = 3;
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

controller = 'PIDController';
tol        = 1e-2;
nRow       = 7;

numb_method = numel(LIST_OF_METHOD);


latexFmt    = '%s  %2d  & %2d  &  %2d  &  %2d  &  %2d  &  %6.4e\\\\\n';
METHOD_NAME = {};
ALL_INFO    = nan(nRow, numb_method);

for mth_id = 1:numb_method

    infoCol = nan(nRow, 1);
    try
        clear('method')
        method = LIST_OF_METHOD{mth_id};

        if isfield(method, 'useName')
            mth_name = method.useName;
        else
            mth_name = method.name;
        end
        METHOD_NAME{end+1} = mth_name;

        dataFile = sprintf('%s/%s/%s/%s/%s-%5.4e.mat',...
            pathMain,lower(controller),orderPath,problem, method.name, tol);

        if ~exist(dataFile, 'file');
            fprintf(1, 'Result missing: %s\n', dataFile);
            continue;
        end

        dataInfo = load(dataFile);

        % name of the method
        %infoCol(1) = mth_name;
        
        % record the number of stage
        infoCol(1) = method.s;

        % record the number of steps taken
        if isfield(dataInfo.stepperInfo, 'Nstep')
            infoCol(2) = dataInfo.stepperInfo.Nstep; 
        end

        % record the number of function evalation (work)
        if isfield(dataInfo.stepperInfo, 'nfcn')
            %infoCol(3) = dataInfo.stepperInfo.nfcn;
            infoCol(3) = infoCol(1)*infoCol(2);
        end

        % record the number of Accepted steps
        if isfield(dataInfo.stepperInfo, 'Naccpt')
            infoCol(4) = dataInfo.stepperInfo.Naccpt;
        end

        % record the number of Rejected steps
        if isfield(dataInfo.stepperInfo, 'Nrejct')
            infoCol(5) = dataInfo.stepperInfo.Nrejct;
        end

        if isfield(dataInfo, 'exactError')
            infoCol(6) = dataInfo.exactError; 
        end
       
        fprintf(1, latexFmt, mth_name,  infoCol);
        
        %ALL_INFO(:,mth_id) = infoCol;
    catch err
        % Something went wrong
        keyboard
    end
end

%ALL_INFO = ALL_INFO';
%fprintf(1, latexFmt, ALL_INFO(:,:).');
