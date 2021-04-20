clear all; close all; clc

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
            
            listOfMethod = dir(sprintf('%s*.mat', methodPath));
            if ~isempty(listOfMethod)
                for fi = 1:numel(listOfMethod)
                    filename = sprintf('%s%s', methodPath, listOfMethod(fi).name);
                    justFinalSolutionVectorFunc(filename)
                end
            end
        end
    end
end
