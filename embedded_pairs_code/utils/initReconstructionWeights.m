function Crec = initReconstructionWeights(m)
% function Crec = initReconstructionWeights(m)
% Purpose: Initialize reconstruction weights

Crec = zeros(m+1, m);

for r = -1:m-1
    Crec(r+2, :) = ReconstructWeights(m, r);
end

end
