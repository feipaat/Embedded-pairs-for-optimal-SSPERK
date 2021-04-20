function justFinalSolutionVectorFunc(filename)

load(filename);

if ~isequal(size(U), size(UEXACT))
    
    T = T(end);
    U = U(:, end);
    save(filename);
% else
%     keyboard
%     return
end

assert(isequal(size(U), size(UEXACT)));
end