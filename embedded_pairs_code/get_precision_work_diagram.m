% File: get_precision_work_diagram.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: create the work-precision figure

clear all; close all; clc

addpath('methods');

problem = 'vdp'; 
%problem = 'brusselator'; 
%problem = 'advectionShort'; 
%problem = 'eulerShort';

%pathMain = 'dataSaveNew';
pathMain    = 'finalResults';
order       = 3;
printFigure = false;
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

TOL = [1e-2 1e-3 1e-4 1e-5 1e-6 1e-7];
numTOL = numel(TOL);

numb_method = numel(LIST_OF_METHOD);
precision = nan(numb_method, numTOL);

MRKS = {'-ks', '-rp', '-b^','-k<', '-mp','-ko','-kx','-bd','-mh',...
    ':sk',':*r',':+b',':xm','-.<r','-.k<'};
LGD = cell(size(LIST_OF_METHOD));

controllerChoice = {'IController'; 'PIController'; 'PIDController'; 'ExplicitGustafsson'};
controllerChoice = {'PIDController'; };

figposition = {[100 100 1200 400]; [100 600 1200 400]; [1400 100 1200 400]; [1400 600 1200 400]};

for ctrl = 1:numel(controllerChoice)
    work = nan(numb_method, numTOL);
    figure('Position',figposition{ctrl}); hold on
    controller = controllerChoice{ctrl};
    clf;

    for mth_id = 1:numb_method
        for tol_id = 1:numTOL

            try
            clear('method')
            tol = TOL(tol_id);
            method = LIST_OF_METHOD{mth_id};

            if isfield(method, 'useName')
                %mth_name = method.useName;
                mth_name = method.name;
            else
                mth_name = method.name;
            end

            dataFile = sprintf('%s/%s/%s/%s/%s-%5.4e.mat',...
                pathMain,lower(controller),orderPath,problem, method.name, TOL(tol_id));

            if ~exist(dataFile, 'file');
                fprintf(1, 'Result missing: %s\n', dataFile);
                continue;
            end

            dataInfo = load(dataFile);
            if isfield(dataInfo, 'exactError')
                precision(mth_id, tol_id) = dataInfo.exactError;
            end

            if isfield(dataInfo.stepperInfo, 'nfcn')
                work(mth_id, tol_id)= dataInfo.stepperInfo.nfcn;
            end

            clear('dataFile');
            end
        end

        LGD{mth_id} = sprintf('%s',mth_name);
        loglog(precision(mth_id,:), work(mth_id,:),  MRKS{mth_id});
        hold on
    end

    legend(LGD, 'location','northeast');
    title(controller);
    xlabel('Error'); ylabel('Function Count');
    set(gca, 'fontsize',14);
    grid on; axis('tight');

    pathName = sprintf('figs/%s', lower(controller));
    if ~exist(pathName, 'dir'); mkdir(pathName); end

    if printFigure
        imagName = sprintf('%s/%s_%s_%s.eps',pathName, testChoice, orderPath,problem);
        print(imagName, '-depsc');
    end

    pause(0.1);
end
