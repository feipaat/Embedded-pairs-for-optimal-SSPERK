function [p, c, maxvel] = EulerClosure_IdealGas(Q, gamma)
% function [p, c, maxvel] = EulerClosure_IdealGas(Q, gamma)
% Purpose: closure of Euler under the ideal gas law

p = (gamma - 1)*(Q(:,3) - 0.5*Q(:,2).^2./Q(:,1));
c = sqrt(gamma*p./Q(:,1));
maxvel = max(c + abs(Q(:,2)./Q(:,1)));

end
