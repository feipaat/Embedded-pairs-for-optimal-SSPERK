clear all; close all; clc

order = 4;
problem = 'eulerShort';

oldPath = 'dataSaveNew';
newPath = 'finalResults';

controllerChoice = {'IController'; 'PIController'; 'PIDController'; 'ExplicitGustafsson'};
%controllerChoice = {'IController'; };
testAll = true;

if isequal(order, 2)
    method_fun = str2func('secondOrderMethodToTest');
elseif isequal(order, 3)
    method_fun = str2func('thirdOrderMethodToTest');
elseif isequal(order, 4)
    method_fun = str2func('fourthOrderMethodToTest');
end

[LIST_OF_METHOD, orderPath] = method_fun(testAll);

for m = 1:length(controllerChoice)
fullpathName = sprintf('%s/%s/%s', lower(controllerChoice{m}), orderPath, problem);

filesToMove = dir(sprintf('%s/%s/*.mat',oldPath,fullpathName));

for i = 1:length(filesToMove)
   fl = filesToMove(i).name;
   fullname = sprintf('%s/%s/%s',oldPath, fullpathName, fl);
   newfullname = sprintf('%s/%s/%s',newPath, fullpathName, fl);
   if ~exist(sprintf('%s/%s',newPath, fullpathName), 'dir')
       mkdir(sprintf('%s/%s', newPath, fullpathName));
   end
   copyfile(fullname, newfullname);
   %keyboard
end
end
