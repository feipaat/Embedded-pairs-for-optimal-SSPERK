% File: workToBeDone.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 04/10/2017
% Purpose: get a list of results already obtained

clear all; close all; clc

addpath('methods');


problem = 'vdp';
%problem = 'brusselator';
%problem = 'advection';
%problem = 'burgers';
%problem = 'burgersShort';
%problem = 'euler';

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
            
            methodPath = sprintf('dataSave/%s/',strrep(groupId, '_','/'));
            fileName = sprintf('utils/results/%s.txt', groupId);
            
            fid = fopen(fileName, 'a');
            
            listOfResults = dir(sprintf('%s/*.mat', methodPath));
            
            if ~isempty(listOfResults)
                
                for ii = 1:length(listOfResults)
                    fileContent = fileread(fileName);
                    nameOfResult = listOfResults(ii).name;
                    
                    %first check if result is already listed in the file name
                    isMissing = isempty(strfind(fileContent, nameOfResult));
                    % if nameOfResult does not already exist in the file,
                    % append it to the list
                    
                    if isMissing
                        %keyboard
                        fprintf(fid, '%s\n',nameOfResult);
                    end
                end
            end
            fclose(fid);
            
        end
    end
end
