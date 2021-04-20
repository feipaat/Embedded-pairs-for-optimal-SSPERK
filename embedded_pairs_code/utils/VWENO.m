function [um, up] = VWENO(xloc, ue, m, Crec, dw, beta)
% function [um, up] = WENO(xloc, uloc, m, Crec, dw, beta)
% Purpose: Compute the left and right cell interface values using a WENO approach based on 2m-1 long vectors uloc with cell

% set WENO parameter
p = 2;
vareps = 1e-8;

% treat special case of m = 1 - no stencil to select
assert(isequal(m,3), 'vectorizing for m = 3 case only');

umhm2 = ue(1:end-4);
umhm1 = ue(2:end-3);
umh0 = ue(3:end-2);
umhp1 = ue(4:end-1);
umhp2 = ue(5:end);

UP0 = [umh0  umhp1 umhp2];
up0 = [umh0  umhp1 umhp2]*Crec(2,:)';
up1 = [umhm1 umh0 umhp1]*Crec(3,:)';
up2 = [umhm2 umhm1 umh0]*Crec(4,:)';

UP = [up0 up1 up2];

um0 = [umh0  umhp1 umhp2]*Crec(1,:)';
um1 = [umhm1 umh0 umhp1]*Crec(2,:)';
um2 = [umhm2 umhm1 umh0]*Crec(3,:)';

UM = [um0 um1 um2];


beta1 = arrayfun(@(i) UP0(i,:)*beta(:,:,1)*UP0(i,:)',1:size(UP0,1))';
beta2 = arrayfun(@(i) UP0(i,:)*beta(:,:,2)*UP0(i,:)',1:size(UP0,1))';
beta3 = arrayfun(@(i) UP0(i,:)*beta(:,:,3)*UP0(i,:)',1:size(UP0,1))';

beta = [beta1 beta2 beta3];

alpha = (vareps + beta).^p;
alphap = arrayfun(@(i) dw'./alpha(i,:),1:size(alpha,1),'UniformOutput',false);
alphap = cell2mat(alphap');
alphap_sum = sum(alphap,2);

alpham = arrayfun(@(i) flipud(dw)'./alpha(i,:), 1:size(alpha,1), 'UniformOutput',false);
alpham = cell2mat(alpham');
alpham_sum = sum(alpham,2);

% alpham = zeros(m,1) ; alphap = zeros(m,1) ;
% upl = zeros(m,1) ; uml = zeros(m,1) ; betar = zeros(m,1) ;
% 
% % compute um and up based on different stencils and smoothness indicators and alpha
% for r = 0:m-1
%     umh = uloc(m-r+[0:m-1]);
%     upl(r+1) = Crec(r+2,:)*umh; 
%     uml(r+1) = Crec(r+1,:)*umh;
%     betar(r+1) = umh'*beta(:,:,r+1)*umh;
% end
% 
% % compute alpha weights -- classic WENO
% alphap = dw./(vareps + betar).^p;
% alpham = flipud(dw)./(vareps + betar).^p;


% % compute nonlinear weights and cell interface values
% um = alpham'*uml/sum(alpham);
% up = alphap'*upl/sum(alphap);
% 

um = arrayfun(@(i) alpham(i,:)*UM(i,:)'/alpham_sum(i),1:size(alpham_sum));
up = arrayfun(@(i) alphap(i,:)*UP(i,:)'/alphap_sum(i),1:size(alphap_sum));

end

