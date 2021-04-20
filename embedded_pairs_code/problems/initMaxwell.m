function [x, h, Q, ep, mu] = initMaxwell(ep, mu, L, N)

mul = mu(1); mur = mu(2);
epl = ep(1); epr = ep(2);

% set problem parameters
L = 2;
FinalTime = pi/2;
N = 256;
h = L/N;
CFL = 0.90;

% Define domain, materials and initial conditions
x = [-1:h:1]';

NGQ = 16;
[xGQ, wGQ] = LegendreGQ(NGQ);

Ef = zeros(N+1, 1);
Hf = zeros(N+1, 1);

for i = 1:NGQ + 1
    [Efh, Hfh, ep, mu] = CavityExact(x + xGQ(i)*h/2, epl, epr, mul, mur, 0);
    Ef = Ef + wGQ(i)*Efh;
    EH = Hf + wGQ(i)*Hfh;
end

Ef = Ef/2;
Hf = Hf/2;


[Ef, Hf, ep, mu] = CavityExact(x, epl, epr, mul, mur, 0);



Q = [Ef Hf];

end
