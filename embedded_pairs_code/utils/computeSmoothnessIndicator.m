function beta = computeSmoothnessIndicator(m)
% function beta = computeSmoothnessIndicator(m)
% Purpose: compute smoothness indicator matrices

beta =  zeros(m, m, m);
for r = 0:m-1
    xl = -1/2 + [-r:1:m-r];
    beta(:,:, r+1) = betarcalc(xl, m);
end

end
