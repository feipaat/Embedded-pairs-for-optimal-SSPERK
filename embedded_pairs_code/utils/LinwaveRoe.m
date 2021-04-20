function [ numflux ] = LinwaveRoe(u, v, lambda, maxvel)
% LinwaveLF.m : Definition of Roe numerical flux
% \hat{f}(u, v) for the linear wave equation
% \hat{f}(u,v) = 0.5[ u + v - \alpha(v - u)]

% function [ numflux ] = LinwaveRoe(u, v, lambda, maxvel)
% Purpose: Evaluate Roe numerical flux for wave equation 
% the numerical flux is defined as:
% 

%alpha = (v - u)./(v - u);
alpha = ones(size(u));
numflux = (alpha >= 0).*u + (alpha <0).*v;
%numflux = u;
%keyboard
end
