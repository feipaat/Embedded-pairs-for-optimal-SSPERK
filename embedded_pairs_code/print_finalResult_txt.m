function print_finalResult_txt
% File: print_finalResult_txt
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: print the final work-precision info

clear all; close all; clc
warning('off');

global pathMain orderPath problem
addpath('methods');

problem = 'vdp'; 
%problem = 'brusselator'; 
%problem = 'advectionShort'; 
%problem = 'eulerShort';

pathMain = 'dataSaveNew';
pathMain    = 'finalResults';
order       = 3;
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

TOL         = [1e-2 1e-3 1e-4 1e-5 1e-6 1e-7];
INX         = 1:numel(TOL);
ACCPT       = zeros(size(TOL));
REJCT       = zeros(size(TOL));
STEPS       = zeros(size(TOL));
FNC         = zeros(size(TOL));
ACCURACY    = zeros(size(TOL));
numb_method = numel(LIST_OF_METHOD);
%precision   = nan(numb_method, numTOL);

controllerChoice = {'IController'; 'PIController'; 'PIDController'; 'ExplicitGustafsson'};
ctrl = 'PIDController'; 

%numTOL = numel(TOL);
resultPath = sprintf('../work_precision/%s/%s',problem, orderPath);
mkdir(sprintf('../work_precision/%s',problem));
mkdir(resultPath);

for mth_id = 1:numb_method

    mtd = LIST_OF_METHOD{mth_id};

    if isfield(mtd, 'useName')
        mth_name = mtd.useName;
        mth_name = mtd.name
    else
        mth_name = mtd.name;
    end

    fid = fopen(sprintf('%s/%s-final.log',resultPath,mth_name),'w');
    print_method_result(fid,ctrl, mtd, TOL);
    fclose(fid);
end

end


function print_method_result(fid, ctrl, method, TOL)
global pathMain orderPath problem

fprintf(fid, 'Work-Precision Info:\n\n');
numTOL = numel(TOL);
for tol_id = 1:numTOL

    run_info = -1*ones(1,7);
    run_info(1) = tol_id;

    try
        tol = TOL(tol_id);

        if isfield(method, 'useName')
            mth_name = method.useName;
        else
            mth_name = method.name;
        end

        dataFile = sprintf('%s/%s/%s/%s/%s-%5.4e.mat',...
        pathMain,lower(ctrl),orderPath,problem, method.name, TOL(tol_id));

        if ~exist(dataFile, 'file');
            fprintf(1, 'Result missing: %s\n', dataFile);
            %keyboard
            continue;
        end

        run_info(2) = tol;
        dataInfo = load(dataFile);
        if isfield(dataInfo, 'exactError');
            run_info(7) = dataInfo.exactError;
        end

        if isfield(dataInfo.stepperInfo, 'nfcn')
            run_info(6) = dataInfo.stepperInfo.nfcn;
        end

        if isfield(dataInfo.stepperInfo, 'Nstep')
            run_info(5) = dataInfo.stepperInfo.Nstep;
        end

        if isfield(dataInfo.stepperInfo, 'Nrejct')
            run_info(4) = dataInfo.stepperInfo.Nrejct;
        end

        if isfield(dataInfo.stepperInfo, 'Naccpt')
            run_info(3) = dataInfo.stepperInfo.Naccpt;
        end

        % number of function evaluations (i.e. work)
        run_info(6) = method.s*(run_info(5) + run_info(4)) + 2;
        str = print_single_result(run_info);
        fprintf(fid, '%s\n',str);

        clear('dataFile');
    catch err
        keyboard
    end
end
end % print_method_result

function s = print_single_result(mt)

fmt = '%d %2.1e %4d %3d %3d %6d %8d %10.6e';
s = sprintf(fmt, mt);
end
