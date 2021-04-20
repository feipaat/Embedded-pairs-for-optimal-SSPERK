function [Q, dt, time, status] = rk_takeStep(x, Q,  h, k, m, Crec, maxvel, fluxFnc, time,  FinalTime, varargin)
% function Q = rk_takeStep(x, Q,  h, k, m, Crec, maxvel, fluxFnc)
% Purpose: returns the new solution (Q) and the stage computations

global rk problem;

if ~isempty(varargin)
    erk = varargin{1};
    isEmbedded = true;
else
    isEmbedded = false;
end

sysSize = size(Q,2);
s = rk.s;
u0 = Q(:);
n = length(u0);
Fvec = zeros(n, s);
rhs = fluxFnc(x, Q,  h, k, m, Crec, maxvel);
Fvec(:,1) = rhs(:);

% intermediate stage value
for i = 2:s
    temp = u0;
    for j = 1:i-1
        temp = temp + k*rk.A(i,j)*Fvec(:, j);
    end
    temp = reshape(temp,[],sysSize);
    rhs = fluxFnc(x, temp,  h, k, m, Crec, maxvel);
    Fvec(:, i) = rhs(:);
end

% combine
Q = u0 + k*Fvec*rk.b(:);

% combine for the embedded solution
Qhat = u0 + k*Fvec*rk.bt(:);

% call the step-control algorithm
if isEmbedded
    [dt, status] = erk.stepSizeControl(time, k, Q, Qhat);
    
    if ~status
        % if rejected, then restart from the previous solution
        Q = u0;
    else
        time = time + k;
        dt = min(abs(FinalTime - time), dt);
        %if (time + k > FinalTime)
        %dt = min(FinalTime - time, dt);
        %end
    end

%    erk.sett(time);
end
Q = reshape(Q, [], sysSize);

end
