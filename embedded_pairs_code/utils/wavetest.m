function [ u ] = wavetest(x, a, z, delta, alpha, beta)

%close all; clc; clear all;

F = @(x, alpha, a) sqrt( max(1 - alpha*alpha*(x-a).^2, 0) );
G = @(x, beta, z) exp(-beta*(x - z).^2);


%x = linspace(-1, 1, 100)';

%u = zeros(size(x));
N = length(x);
% 
% u1 = (1/6)*(G(x, beta, z-delta) + G(x, beta, z + delta) + 4*G(x, beta,z));
% u2 = ones(size(x));
% u3 = 1 - abs(10*(x - 0.1));
% u4 = (1/6)*(F(x, alpha, a-delta) + F(x, alpha, a+delta) + 4*F(x,alpha,z));

% plot(x, u1, 'rx')
% hold on
% plot(x, u2, 'bx')
% plot(x, u3, 'kx')
% plot(x, u4, '-xc')

for i = 1:N
    if (x(i) >= -0.8) && ( x(i) <= -0.6)
        u(i) = (1/6)*(G(x(i), beta, z-delta) + G(x(i), beta, z + delta) + 4*G(x(i), beta,z));
    elseif (x(i) >= -0.4 ) && ( x(i) <= -0.2)
        u(i) = 1;
    elseif (x(i) >= 0) && ( x(i) <= 0.2)
        u(i) = 1 - abs(10*(x(i) - 0.1));
    elseif (x(i) >= 0.4 ) && ( x(i) <= 0.6 )
        u(i) = (1/2)*(F(x(i), alpha, a-delta) + F(x(i), alpha, a+delta) + 4*F(x(i),alpha,z));
    else
        u(i) = 0;
    end
end


%plot(x, u)
%axis([-1 1 -0.1 1.1])
end
