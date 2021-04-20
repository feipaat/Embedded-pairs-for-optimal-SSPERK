% for plotting the step-size

figure;

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

clf;
plot(goodTime, goodStepSize, '-s')
hold on
plot(badTime, badStepSize, 'xr');
legend('accepted-dt','rejected-dt')