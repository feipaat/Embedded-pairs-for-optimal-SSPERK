function [goodTime, goodStepSize, badTime, badStepSize] = getEmbeddedStepSize(stepSizeInfo)
% File: getEmbeddedStepSize.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: 


timeVec = stepSizeInfo(:,1);
step_size = stepSizeInfo(:,2);
status_step = logical(stepSizeInfo(:,3));
% get the rejected step-size
ind_badDt = ~step_size;
ind_goodDt = step_size;

%timeVec = erk.t(2:end);
goodTime = timeVec(status_step);
goodStepSize = step_size(status_step);

badTime = timeVec(~status_step);
badStepSize = step_size(~status_step);
end
