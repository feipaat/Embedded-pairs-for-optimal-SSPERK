function [numflux] = ScalarLF(u, v, lambda, maxvel, flux)
% function [numflux] = ScalarLF(u, v, lambda, maxvel, flux)

fu = flux(u);
fv = flux(v);
numflux = (fu + fv)/2 - maxvel/2*(v-u);

end
