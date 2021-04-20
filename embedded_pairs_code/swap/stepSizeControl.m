function [dt, stepSizeControlStatus] = stepSizeControl(dt, y, yhat)
% Automatic Step Size Control
% Hairer. Solving ODE I. pg. 167

absTol = 1e-4;
relTol = 1e-4;
beta = 0.04;
safe = 0.9;
fac1 = 0.2;
fac2 = 10;
t = 0;
dtMax = 1;
reject = 0;

naccpt = 0;
last = 0;

expo1 = 0.2 - beta*0.75;
facc1 = 1/fac1;
facc2 = 1/fac2;
facold = 1e-4;


sci_fun = @(u0, yhat) absTol + relTol * max(abs(u0), abs(yhat));

h = dt;
lte = abs(y(:) - yhat(:));
obj.lte_ = norm(lte, 2);

sk = sci_fun(y(:), yhat(:));
err = norm(lte./sk,2);


%/* computation of hnew */
fac11 = err.^(expo1);

% /* Lund-stabilization */
fac = fac11/(facold.^(beta));

% /* we require fac1 <= hnew/h <= fac2 */
fac = max(facc2, min(facc1, fac/safe));
hnew = h / fac;

if abs(err) <= 1
    stepSizeControlStatus = true;
    % accept the step
    facold = max(err, 1.0E-4);
    naccpt = naccpt + 1;
    oldT = t;
    t = t + dt;
    
    % /* normal exit */
    if (last)
        nextDt = hnew;
        %obj.t = t;
        idid = 1;
        keyboard
        %break;
    end
    
    if (abs(hnew) > dtMax)
        hnew = posneg * dtMax;
    end
    
    if (reject)
        hnew = posneg * min(abs(hnew), abs(h));
    end
    
    reject = 0;
    
else % reject the solution
    % reject
    stepSizeControlStatus = false;
    
    hnew = h/(min(obj.facc1, obj.fac11/obj.safe));
    reject = 1;
    y = u0;
    t = t;
    
    if (naccpt >= 1)
        nrejct = nrejct + 1;
    end
    last = 0;
    reject = 1;
    nextDt = hnew;
end

lte_ = lte;
dt = hnew;

end