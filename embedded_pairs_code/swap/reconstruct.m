function [ql,qr] = reconstruct(q,rtype)
%CLAWLAB - A High Resolution Solver for Hyperbolic PDEs implemented in MATLAB
%Author: David Ketcheson
%Latest Revision: version 0.1 - 09/2007
%reconstruct.m - reconstruction high-order accurate limited solution
%from cell averages

%ql(i) is the reconstructed value just to the right of x_i-1/2
%qr(i) is the reconstructed value just to the left  of x_i+1/2

n2=size(q,2);
inner=2:n2-1; plus=2:n2; minus=plus-1;

if (strcmp(rtype,'lin3')) %Linear quadratic reconstruction
  ql=zeros(size(q)); qr=zeros(size(q));
  ql=q; qr=q;
  ql(:,inner) = 5./6.*q(:,inner)-1./6.*q(:,inner+1)+1./3.*q(:,inner-1);
  qr(:,inner) = 5./6.*q(:,inner)+1./3.*q(:,inner+1)-1./6. *q(:,inner-1);
else

dum=zeros(size(q));
dup=zeros(size(q));

if (~strcmp(rtype,'weno5') && ~strcmp(rtype,'cweno3')) % TVD reconstructions


dup(:,minus)=diff(q,1,2);     %dup(:,i)=q(:,i+1)-q(:,i  )
dum(:,plus )=diff(q,1,2);  %dum(:,i)=q(:,i  )-q(:,i-1)

switch rtype
    case 'donor'
          delta=0.*q;
    case 'superbee'
        delta = .5*(sign(dup)+sign(dum))...
         .*max(min(abs(dup),2.*abs(dum)),...
         min(abs(dum),2.*abs(dup)));
    case 'minmod'
          delta = .5*(sign(dup)+sign(dum)).*min(abs(dup),abs(dum));
    case 'koren'
          dstar = .5*(sign(dup)+sign(dum)).*min(2*abs(dup),2*abs(dum));
          delta = .5*(sign(dup)+sign(dum)).*min(1/3*abs(2*dup+dum),abs(dstar));
    case 'gmm'
	  theta=2.0; %Monotonized Centered case; generally 1<theta<2
%          theta=th2;
          dstar = .5*(sign(dup)+sign(dum)).*min(theta*abs(dup),theta*abs(dum));
          delta = .5*(sign(dup)+sign(dum)).*min(0.5*abs(dup+dum),abs(dstar));
    case 'up'
          delta = .5*(dup+dum);
    case 'vanleer'
        delta = (sign(dup)+sign(dum)).*(dup.*dum)./(abs(dup+dum));
    case 'lp'
    case 'eno'
	  delta = (abs(dup)<=abs(dum)).*dup+ (abs(dum)<abs(dup)).*dum;
end

%  delta(:,n2)=0; %Is this necessary?
%  delta(:,1)=0;
%  delta2(:,n2)=0;
%  delta2(:,1)=0;
  
  ql=q-.5*delta;
  qr=q+.5*delta;

elseif (strcmp(rtype,'weno5')) %rtype='WENO5'

inner=3:n2-2; plus=2:n2; minus=plus-1;
epweno = 1.e-76;
%Would probably be faster to calculate shifted versions of dum
%to avoid indexing later
dum(:,plus )=diff(q,1,2);  %dum(:,i)=q(:,i  )-q(:,i-1)
ql=zeros(size(q)); qr=zeros(size(q));

for m1=1:2
  im=round((-1)^(m1+1));
  ione=im;
  inone=-im;
  intwo=-2*im;

  t1=im*(dum(:,inner+intwo) - dum(:,inner+inone));
  t2=im*(dum(:,inner+inone) - dum(:,inner      ));
  t3=im*(dum(:,inner      ) - dum(:,inner+ione ));
    
  tt1=13.*t1.^2 + 3.*(   dum(:,inner+intwo)-3.*dum(:,inner+inone)).^2;
  tt2=13.*t2.^2 + 3.*(   dum(:,inner+inone)+   dum(:,inner      )).^2;
  tt3=13.*t3.^2 + 3.*(3.*dum(:,inner      )-   dum(:,inner+ione )).^2;
    
    
  tt1=(epweno+tt1).^2;
  tt2=(epweno+tt2).^2;
  tt3=(epweno+tt3).^2;
  s1=   tt2.*tt3;
  s2=6.*tt1.*tt3;
  s3=3.*tt1.*tt2;
    
  t0=1./(s1+s2+s3);
  s1=s1.*t0;
  s3=s3.*t0;
    
  switch m1
	    
    case 1
      qr(:,inner-1)=(s1.*(t2-t1)+(0.5*s3-0.25).*(t3-t2))/3....
        +(-q(:,inner-2)+7.*(q(:,inner-1)+q(:,inner))...
        -q(:,inner+1))/12.;
    case 2
      ql(:,inner)=(s1.*(t2-t1)+(0.5*s3-0.25).*(t3-t2))/3....
        +(-q(:,inner-2)+7.*(q(:,inner-1)+q(:,inner))...
        -q(:,inner+1))/12.;
  end
end %WENO5
	    
elseif (strcmp(rtype,'cweno3')) %rtype='cweno3'
  dup(:,minus)=diff(q,1,2);
  dum(:,plus )=diff(q,1,2);  %dum(:,i)=q(:,i  )-q(:,i-1)
  ql=q; qr=q;
  eps=1.e-6; %Adjustable parameter
  p=0.53;       %Adjustable parameter
%          p=0.63;       %Van Leer harmonic-ish
%          p=10.;       %ENO limit
  CL=.25;    %Adjustable parameter
  CR=.25;    %Adjustable parameter
  CC=0.5;     %Adjustable parameter
    
  %Smoothness indicators
  ISL=dum.^2;
  ISR=dup.^2;
  ISC=13./3.*(dup-dum).^2+.25*(dup+dum).^2;
    
  alphaL=CL./(eps+ISL).^p;
  alphaR=CR./(eps+ISR).^p;
  alphaC=CC./(eps+ISC).^p;

  wtot=1./(alphaL+alphaR+alphaC);
  wL=alphaL.*wtot;
  wR=alphaR.*wtot;
  wC=alphaC.*wtot;
%THIS IS WRONG:
  ql = q - 0.5*(wL.*dum + wR.*dup -1./6.*wC.*(dup+5*dum));
  qr = q + 0.5*(wL.*dum + wR.*dup +1./6.*wC.*(5*dup+dum));
	    
end %cweno3

end %nonlinear
