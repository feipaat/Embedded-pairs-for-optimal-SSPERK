function [numflux] = EulerLF(u, v, gamma, lambda, maxvel)
% function [numflux] = EulerLF(u, v, gamma, lambda, maxvel)
% Purpose: Evaluate global Lax Friedrich numerical flux for Euler's equation

% Compute flux for u
r = u(:, 1);
ru = u(:,2);
E = u(:,3);
pu = (gamma - 1)*(E - 0.5*ru.^2./r);
fu = [ru (ru.^2./r+pu) (E + pu).*ru./r]; % flux exavaluate

% Compute flux for v
r = v(:,1);
ru = v(:,2);
E = v(:,3);
pv = (gamma - 1)*(E - 0.5*ru.^2./r);
fv = [ru (ru.^2./r+pv) (E+pv).*ru./r]; % flux evaluated

% Evaluate numerical flux
numflux = (fu + fv)/2 - maxvel/2*(v-u);
end
