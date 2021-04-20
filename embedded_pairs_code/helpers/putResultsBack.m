% File: putResultsBack.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 04/10/2017
% Purpose: move methods from questionable to the dataSave directory for proccessing

clear all; close all; clc

addpath('methods');

problemChoice = {'vdp', 'brusselator', 'advection', 'burgers', 'burgersShort', 'euler'};
controllerChoice = {'IController'; 'PIController'; 'PIDController'; 'ExplicitGustafsson'};

for prb = 1:numel(problemChoice)

    problem = problemChoice{prb};

    for ctrl = 1:numel(controllerChoice)
        controller = controllerChoice{ctrl};

        for order = 4:-1:2
            if isequal(order, 2)
                secondOrderMethodToTest;
            elseif isequal(order, 3)
                thirdOrderMethodToTest;
            elseif isequal(order, 4);
                fourthOrderMethodToTest;
            else
                error('Order choice not recognized!!');
            end

            groupId = sprintf('%s_%s_%s',lower(controller),orderPath,problem);

            methodPath = sprintf('dataSave/questionable/dataSave/%s/',strrep(groupId, '_','/'));
            fileName = sprintf('utils/results/%s.txt', groupId);

            listOfResults = dir(sprintf('%s/*.mat', methodPath));

            if ~isempty(listOfResults)

                for ii = 1:length(listOfResults)
                    fileContent = fileread(fileName);
                    nameOfResult = listOfResults(ii).name;

                    newPath = sprintf('dataSave/%s',...
                    strrep(groupId, '_','/'));

                    if ~exist(newPath, 'dir'); mkdir(newPath); end

                        newName = sprintf('%s/%s', newPath, nameOfResult);
                        oldName = sprintf('%s/%s',methodPath,nameOfResult);

                        movefile(oldName, newName);                        
                        %end
                end
            end

        end
    end
end
