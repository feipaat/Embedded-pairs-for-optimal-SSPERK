function isMissing = doesResultExist(controller, orderPath, problem, nameOfResult)
% function isMissing = doesResultExist(controller, orderPath, problem, nameOfResult)

% File: doesResultExist.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 04/10/2017
% Purpose: determine if the result already exists

groupId = sprintf('%s_%s_%s',lower(controller),orderPath,problem);
fileName = sprintf('utils/results/%s.txt', groupId);
fileContent = fileread(fileName);

%first check if result is already listed in the file name
isMissing = isempty(strfind(fileContent, nameOfResult));
end
