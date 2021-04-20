function [du] = ScalarENOrhs1D(x, u, h, k, m, Crec, maxvel, flux)
% function [du] = ScalarENOrhs1D(x, u, h, k, m, Crec, maxvel, flux)
% Purpose: Evaluate the RHS of Burgers equation using ENO reconstruction

N = length(u);
du = zeros(N, 1);


% extend data using boundary condition
%[xe, ue] = extend(x, u, h, m, 'D', 2, 'N', 0);
[xe, ue] = extend(x, u, h, m, 'P', 2, 'P', 0);


% define cell left and right interface values
um = zeros(N+2, 1);
up = zeros(N+2, 1);

for i = 1:N+2
    [um(i), up(i)] = ENO( xe(i:(i+2*(m-1))), ue(i:(i+2*(m-1))), m, Crec);
end

%
du = - (ScalarLF(up(2:N+1), um(3:N+2), 0, maxvel, flux) - ScalarLF(up(1:N), um(2:N+1), 0, maxvel, flux))/h;
end
