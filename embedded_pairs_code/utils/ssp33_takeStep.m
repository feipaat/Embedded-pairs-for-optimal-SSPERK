function Q = ssp33_takeStep(x, Q,  h, k, m, Crec, dw, beta, gamma, maxvel, fluxFnc)

rhsQ = fluxFnc(x, Q,  h, k, m, Crec, dw, beta, gamma, maxvel); 
Q1 = Q + k*rhsQ;
rhsQ = fluxFnc(x, Q1, h, k, m, Crec, dw, beta, gamma, maxvel); 
Q2 = (3*Q + Q1 + k*rhsQ)/4;
rhsQ = fluxFnc(x, Q2, h, k, m, Crec, dw, beta, gamma, maxvel); 
Q = (Q + 2*Q2 + 2*k*rhsQ)/3;

end
