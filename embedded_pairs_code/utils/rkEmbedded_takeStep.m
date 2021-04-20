function [Q] = rkEmbedded_takeStep(x, Q,  h, k, m, Crec, maxvel, fluxFnc)
% function Q = rkEmbedded_takeStep(x, Q,  h, k, m, Crec, maxvel, fluxFnc)
% Purpose: returns the new solution (Q) and the stage computations

global rk;

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
Q = u0 + k*Fvec*rk.b(:); Q = reshape(Q, [], sysSize);
Qhat = u0 + k*Fvec*rk.bt(:); Qhat = reshape(Qhat, [], sysSize);

% call the stepSizeControl
[dt, stepSizeControlStatus] = stepSizeControl(dt, Q, Qhat);

if ~stepSizeControlStatus
    Q = reshape(u0, [], sysSize)
end

end
