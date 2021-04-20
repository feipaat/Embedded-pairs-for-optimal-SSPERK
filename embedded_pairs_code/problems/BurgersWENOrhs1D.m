function [dEH] = BurgersWENOrhs1D(x, u, h, k,m, Crec, dw, beta)
% function [dEH] = BurgersWENOrhs1D(x, EMf, ep, mu, h, k,m, Crec, dw, beta)
% Purpose: Evaluate right hand side for Maxwells equation using ENO method

N = length(x);
du = zeros(N, 1);


% PEC boundary conditions by mirrow principle
[xe, Ee] = extend(x, u, h, m, 'D', 2, 'N', 0);

% define cell left and right interace values
um = zeros(N+2, 1);
up = zeros(N+2, 1);

for i = 1:N+2
    [um(i), up(i) ] = WENO(xe(1:(i+2*(m-1))), ue(i:(i+2*(m-1))), m , Crec, dw, beta);
end

% compute residual
ur = [up(2:N+1)]; ul = [um(2:N+1)];

% exact upwinding
[xe, upe] = extend(x, ur, h, 1, 'D', 2, 'N', 0);
[xe, mue] = extend(x, ul, h, 1, 'D', 0, 'N', 0);

ep0 = epe(2:N+1); epm = ep(1:N); epp = epe(3:N+2);
mu0 = mue(2:N+1); mum = mue(1:N); mup = mue(3:N+2);

dEH = - (MaxwellUpwind(EMr, EMp, ep0, epp, mu0, mup, ep0, mu0) - MaxwellUpwind(EMm, EMl, epm, ep0, mum, mu0, ep0, mu0))/h;
return
