function [ numflux ] = LinwaveLW(u, v, lambda, maxvel)
% function [ numflux ] = LinwaveLW(u, v, lambda, maxvel)
% Purpose: Evaluate gloabl Lax Wendroff numerical flux for wave equation

% the numerical flux is defined as:
% \hat{f}_{j+1/2} = (1/2)[ f(u_j) + f(u_{j+1}) - \lambda f'(u_{j+1/2})(u_{j+1} - u_j)]

% here, we assume f'(u_{j + 1/2}) = 1;

numflux = (u+v)/2 - lambda/2*(v-u);
end
