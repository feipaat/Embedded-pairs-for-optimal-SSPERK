function [dQ] = EulerENOrhs1D(x, Q, h, k, m, Crec,gamma, maxvel)
% function [dQ] = EulerENOrhs1D(x, Q, h, k, m, Crec, maxvel)
% Purpose: Evaluate right hand side for Euler equation using ENO method

N = length(x);
dQ = zeros(N, 3);

Ql = zeros(N,3); Qr = zeros(N,3);
Qp = zeros(N,3); Qm = zeros(N,3);

% Extend data and assign boundary conditions
[xe, re] = extend(x, Q(:,1), h, m, 'D', 1.0, 'D', 0.125);   % rho extended
[xe, me] = extend(x, Q(:,2), h, m, 'D', 0, 'N', 0);         % momentum extended
[xe, Ee] = extend(x, Q(:,3), h, m, 'D', 2.5, 'N', 0);       % Energy extension

% define cell left and right interface values
rm = zeros(N+2, 1); mm = zeros(N+2,1); Em = zeros(N+2, 1);
rp = zeros(N+2, 1); mp = zeros(N+2,1); Ep = zeros(N+2, 1);

% Compute RHS - change flux here
for i = 1:N+2
    [rm(i), rp(i)] = ENO(xe(i:(i+2*(m-1))), re(i:(i+2*(m-1))), m, Crec);
    [mm(i), mp(i)] = ENO(xe(i:(i+2*(m-1))), me(i:(i+2*(m-1))), m, Crec);
    [Em(i), Ep(i)] = ENO(xe(i:(i+2*(m-1))), Ee(i:(i+2*(m-1))), m, Crec);
end

% Compute rhs - also change numerical flux here
Ql = [rm(2:N+1) mm(2:N+1) Em(2:N+1)]; Qr = [rp(2:N+1) mp(2:N+1) Ep(2:N+1)];
Qp = [rm(3:N+2) mm(3:N+2) Em(3:N+2)]; Qm = [rp(1:N) mp(1:N) Ep(1:N)];
dQ = -(EulerLF(Qr, Qp, gamma, k/h, maxvel) - EulerLF(Qm, Ql, gamma, k/h, maxvel))/h;

return
