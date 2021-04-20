function Driver_efficiency(controller, order, problem, mtd_id, tol_id, testAll)
% File: Driver_efficiency.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date:
% Purpose: Run the efficiency test
% for a controller choice and problem at prescribed tolerance
% using the specified method

%FIXME: a lot of explicit clearing. Clean this up Sidafa!!!1

clearvars -except controller order problem mtd_id tol_id testAll

addpath('utils','methods','controllerAlgorithms','problems', 'stepper');

TOL = [1e-2 1e-3 1e-4 1e-5 1e-6 1e-7];
tol = TOL(tol_id);
%dataSavePath = 'dataSaveNew';
dataSavePath    = 'finalResults';

clear('exactSolutionPath', 'exactSolution', 'UEXACT');

% get the reference solution
exactSolutionPath = sprintf('%s/%s_exactSolution.mat',...
    'exactSolution',problem);
exactSolution = load(exactSolutionPath);

if isfield(exactSolution, 'referenceSolution')
    UEXACT = exactSolution.referenceSolution;
else
    UEXACT = exactSolution.Qref;
end

if isequal(order, 2)
    method_fun = str2func('secondOrderMethodToTest');
elseif isequal(order, 3)
    method_fun = str2func('thirdOrderMethodToTest');
elseif isequal(order, 4)
    method_fun = str2func('fourthOrderMethodToTest');
elseif isequal(order, 5)
    method_fun = str2func('bestMethodComparison');
end

[LIST_OF_METHOD, orderPath] = method_fun(testAll);

% just a sanity check.
assert(mtd_id <= numel(LIST_OF_METHOD), ...
    'method index exceeds number of methods to test. Cannot identify the method');

clear('rk');
rk = LIST_OF_METHOD{mtd_id};
name = rk.name;
controllerPath = lower(controller);

% define the name of files for the results to be written to
folderName = sprintf('%s/%s/%s/%s/',dataSavePath, controllerPath,orderPath,problem);
if ~exist(folderName, 'dir'); mkdir(folderName); end

dataFile = sprintf('%s/%s/%s/%s/%s-%5.4e.mat',...
    dataSavePath, controllerPath,orderPath,problem, name, TOL(tol_id));

isMissing = ~exist(dataFile, 'file');
if ~isMissing %& false
    % if this particular run data already exist, there's no need to run it again
    fprintf('File already exists\n'); return;
end

% intialize the problem
prb = initProblem(problem);

clear('stepperFnc', 'Q0');

% setup the integrator
if strcmpi(problem, 'vdp') || strcmpi(problem, 'brusselator')
    stepperFnc = @explicitODEStepper;
    Q0         = prb.odeObj.y0;
    % initalize and step up the RK stepper evaluator
    stepperFnc(Q0, [], [], [], rk, controller,tol, prb);
else
    stepperFnc = @explicitStepper;
    Q0         = prb.Q;
    % initalize and step up the RK stepper evaluator
    stepperFnc([], Q0, [], [], [],[], rk, controller,tol, prb);
end

% Solve Problem
if strcmpi(problem, 'euler') || strcmpi(problem, 'eulerShort')
    [U, T, exactError, stepperInfo] = Euler1D(stepperFnc, order, tol, prb, UEXACT, dataFile);
elseif strcmpi(problem, 'advection') || strcmpi(problem, 'burgers') || strcmpi(problem, 'burgersShort') || strcmpi(problem, 'advectionShort')
    [U, T, exactError, stepperInfo] = Scalar1D(stepperFnc, order, tol, prb, UEXACT, dataFile);
elseif strcmpi(problem, 'vdp') || strcmpi(problem, 'brusselator')
    [U, T, exactError, stepperInfo] = SimpleODE1D(stepperFnc, order, tol, prb, UEXACT, dataFile);
else
    error('problem choice not recognized');
end

clear stepperFnc tol prb UEXACT
end
