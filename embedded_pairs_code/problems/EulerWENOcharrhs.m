function [dQ] = EulerWENOcharrhs(Q, k, maxvel, varargin)
% File: EulerWENOcharrhs.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Evaluate right hand side for Euler equation using WENO method on
% the characteristic variables

persistent Crec dw beta x h m gamma
persistent flux
persistent Ql Qp Qr Qm
persistent Rlh Rrh rm mm Em rp mp Ep

if ~isempty(varargin)
    x = varargin{1};
    h = varargin{2};
    m = varargin{3};
    Crec = varargin{4};
    flux = varargin{5};
    dw = varargin{6};
    beta = varargin{7};
    gamma = varargin{8};
    N = length(x);
    Ql = zeros(N,3); Qr = zeros(N,3);
    Qp = zeros(N,3); Qm = zeros(N,3);
    Rlh = zeros(1,3);
    Rrh= zeros(1,3);
    rm = zeros(N+2,1);
    mm = zeros(N+2,1);
    Em = zeros(N+2,1);
    rp = zeros(N+2,1);
    mp = zeros(N+2,1);
    Ep = zeros(N+2,1);
    %dQ = zeros(size(Q));
    return
end

N = length(x);
dQ = zeros(N, 3);
Q = reshape(Q,[], 3);


% Extend data and assign boundary conditions
[xe, re] = extend(x, Q(:,1), h, m, 'D', 1.0, 'D', 0.125);   % rho extended
[xe, me] = extend(x, Q(:,2), h, m, 'D', 0, 'N', 0);         % momentum extended
[xe, Ee] = extend(x, Q(:,3), h, m, 'D', 2.5, 'N', 0);       % Energy extension

% define cell left and right interface values
Qe = [re me Ee]; 

% Compute RHS - change flux here
for i = 1:N+2
    Qloc         = Qe(i:(i+2*(m-1)),:);
    q0           = Qloc(m,:);
    [S, iS, Lam] = EulerChar(q0,gamma);
    Rloc         = (iS*Qloc')';
    [Rlh(1), Rrh(1)] = WENO(xe(i:(i+2*(m-1))), Rloc(:,1),m,Crec,dw,beta); 
    [Rlh(2), Rrh(2)] = WENO(xe(i:(i+2*(m-1))), Rloc(:,2),m,Crec,dw,beta); 
    [Rlh(3), Rrh(3)] = WENO(xe(i:(i+2*(m-1))), Rloc(:,3),m,Crec,dw,beta);
    Qlh   = (S*Rlh')';
    Qrh   = (S*Rrh')';
    rm(i) = Qlh(1);
    mm(i) = Qlh(2);
    Em(i) = Qlh(3);
    rp(i) = Qrh(1);
    mp(i) = Qrh(2);
    Ep(i) = Qrh(3);
end

% Compute rhs - also change numerical flux here
Ql = [rm(2:N+1) mm(2:N+1) Em(2:N+1)];
Qr = [rp(2:N+1) mp(2:N+1) Ep(2:N+1)];
Qp = [rm(3:N+2) mm(3:N+2) Em(3:N+2)];
Qm = [rp(1:N) mp(1:N) Ep(1:N)];
dQ = -(EulerRoe(Qr,Qp,gamma,[],[]) - EulerRoe(Qm,Ql,gamma,[],[]))/h;

dQ =dQ(:);
return
