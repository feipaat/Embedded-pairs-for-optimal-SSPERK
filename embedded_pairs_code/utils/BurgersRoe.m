function [numflux] = BurgersRoe(u, v, lambda, maxvel)
% function [numflux] = BurgersRoe(u, v, lambda, maxvel)

fu = u.^2;
fv = v.^2;
alpha = u + v;
numflux = (alpha>=0).*fu + (alpha<0).*fv;

end
