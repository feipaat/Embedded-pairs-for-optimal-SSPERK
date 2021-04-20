function [um, up] = WENO(xloc, uloc, m, Crec, dw, beta)
% function [um, up] = WENO(xloc, uloc, m, Crec, dw, beta)
% Purpose: Compute the left and right cell interface values using a WENO approach based on 2m-1 long vectors uloc with cell

% set WENO parameter
p = 2;
vareps = 1e-8;

% treat special case of m = 1 - no stencil to select

if (m == 1)
    um = uloc(1); up = uloc(1);
else
    alpham = zeros(m,1) ; alphap = zeros(m,1) ;
    upl = zeros(m,1) ; uml = zeros(m,1) ; betar = zeros(m,1) ;

    % compute um and up based on different stencils and smoothness indicators and alpha
    for r = 0:m-1
        ind = m-r+[0:m-1];
        umh = uloc(m-r+[0:m-1]);
        upl(r+1) = Crec(r+2,:)*umh; 
        uml(r+1) = Crec(r+1,:)*umh;
        betar(r+1) = umh'*beta(:,:,r+1)*umh;
    end
    
    % compute alpha weights -- classic WENO
    alphap = dw./(vareps + betar).^p;
    alpham = flipud(dw)./(vareps + betar).^p;

    % compute nonlinear weights and cell interface values
    um = alpham'*uml/sum(alpham);
    up = alphap'*upl/sum(alphap);
end

end

