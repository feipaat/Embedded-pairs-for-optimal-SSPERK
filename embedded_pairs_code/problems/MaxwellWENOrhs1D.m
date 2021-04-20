function [dEH] = MaxwellWENOrhs1D(x, EMf, ep, mu, h, k,m, Crec, dw, beta)
% function [dEH] = MaxwellENOrhs1D(x, EMf, ep, mu, h, k,m, Crec, dw, beta)
% Purpose: Evaluate right hand side for Maxwells equation using ENO method

N = length(x);
dEH = zeros(N, 2);
EMl = zeros(N, 2);
EMr = zeros(N, 2);
EMm = zeros(N, 2);
EMp = zeros(N, 2);

% PEC boundary conditions by mirrow principle
[xe, Ee] = extend(x, EMf(:,1), h, m, 'D', 0, 'D', 0);
[xe, He] = extend(x, EMf(:,2), h, m, 'N', 0, 'N', 0);

% define cell left and right interace values
Em = zeros(N+2, 1); Ep = zeros(N+2, 1);
Hm = zeros(N+2, 1); Hp = zeros(N+2, 1);

for i = 1:N+2
    [Em(i), Ep(i) ] = WENO(xe(1:(i+2*(m-1))), Ee(i:(i+2*(m-1))), m , Crec, dw, beta);
    [Hm(i), Hp(i) ] = WENO(xe(1:(i+2*(m-1))), He(i:(i+2*(m-1))), m , Crec, dw, beta);
end

% compute residual
EMr = [Ep(2:N+1) Hp(2:N+1)]; EMl = [Em(2:N+1) Hm(2:N+1)];
EMm = [Ep(2:N+1) Hp(2:N+1)]; EMp = [Em(3:N+2) Hm(3:N+2)];

% exact upwinding
[xe, epe] = extend(x, ep, h, 1, 'N', 0, 'N', 0);
[xe, mue] = extend(x, mu, h, 1, 'N', 0, 'N', 0);

ep0 = epe(2:N+1); epm = ep(1:N); epp = epe(3:N+2);
mu0 = mue(2:N+1); mum = mue(1:N); mup = mue(3:N+2);

dEH = - (MaxwellUpwind(EMr, EMp, ep0, epp, mu0, mup, ep0, mu0) - MaxwellUpwind(EMm, EMl, epm, ep0, mum, mu0, ep0, mu0))/h;
return
