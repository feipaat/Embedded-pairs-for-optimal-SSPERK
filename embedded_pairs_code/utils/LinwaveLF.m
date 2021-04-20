function [ numflux ] = LinwaveLF(u, v, lambda, maxvel)
% LinwaveLF.m : Definition of global Lax-Friedrich numerical flux
% \hat{f}(u, v) for the linear wave equation
% \hat{f}(u,v) = 0.5[ u + v - \alpha(v - u)]

% function [ numflux ] = LinwaveLF(u, v, lambda, maxvel)
% Purpose: Evaluate gloabl Lax Friedrich numerical flux for wave equation 
% the numerical flux is defined as:
% \hat{f}_{j+1/2} = (1/2)[ f(u_j) + f(u_{j+1}) - \alpha(u_{j+1} - u_j)]
% \alpha = max | f'(u) |

numflux = 0.5*( u + v) - maxvel/2*(v-u);
end
