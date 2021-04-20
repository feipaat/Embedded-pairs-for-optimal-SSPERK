function coleahRunAll_driver(order, problem)

addpath('methods');

TOL = [1e-2 1e-3 1e-4 1e-5 1e-6 1e-7];


if isequal(order, 2)
    secondOrderMethodToTest;
elseif isequal(order, 3)
    thirdOrderMethodToTest;
elseif isequal(order, 4)
    fourthOrderMethodToTest;
else
    error('Order choice not recognized!!');
end

for tol_id = 1:6
    for mth_id = 1:numel(LIST_OF_METHOD)
        %Driver_efficiency('IController', order, problem, mth_id, tol_id);
        %Driver_efficiency('PIController', order, problem, mth_id, tol_id);
        %Driver_efficiency('PIDController', order, problem, mth_id, tol_id);
        Driver_efficiency('ExplicitGustafsson', order, problem, mth_id, tol_id);
    end
end

end
