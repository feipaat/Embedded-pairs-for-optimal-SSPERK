function [xe, ue] = extend(x, u, h, m, BCl, ul, BCr, ur)
% extend(x, Q(:,1), h, 1, 'D', 1.0, 'D', 0.125);
% extend.m : Routine to impose boundary conditions on scalar function by extension
% Purpose : Extend dependent and independent vectors (x, u), by m cells subject to
% appropriate boundary conditions
% BC = 'D' - Dirichlet
% BC = 'N' - Neumann
% BC = 'P' - Periodic

xl = min(x); xr = max(x); N = length(u);
[xe, ue] = deal(zeros(N + 2*m, 1));
q = [1:m]';

% Extend x
xe([m-q+1 N+m+q]) = [xl-q*h xr+q*h];
xe((m+1):(N+m)) = x(1:N);

% Periodic extension of u
if (BCl == 'P') | (BCr == 'P')
    ue(m-q+1) = u(N-q);
    ue(N+m+q) = u(q+1);
    ue((m+1):(N+m)) = u(1:N);
    return;
end

% Left extension
if BCl == 'D'
    ue(m-q+1) = -u(q+1) + 2*ul;
else
    ue(m-q+1) = u(q+1);
end

% Right extension
if BCr == 'D'
    ue(N+m+q) = -u(N-q) + 2*ur;
else
    ue(N+m+q) = u(N-q);
end
ue((m+1):(N+m)) = u(1:N);


end
