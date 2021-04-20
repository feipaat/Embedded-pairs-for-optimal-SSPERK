function [numflux] = MaxwellLF(u, v, ep, mu, lambda, maxvel)
% function [numflux] = MaxwellLF(u, v, epu, epv, muu, muv, ep, mu)
% Purpose: Evaluateglobal Lax Friedrich flux for Maxwell's equation with discontinuous coefficients

fu = [u(: ,2) ./ep u(: ,1) ./mu]; 
fv = [v(: ,2) ./ep v(: ,1) ./mu]; 
numflux = (fu+fv)/2 - maxvel/2*(v-u);

end
