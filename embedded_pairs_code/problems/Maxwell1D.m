function [Ef, Hf] = Maxwell1D(x, Q, ep, mu, h, m, CFL, FinalTime)
% function [Ef, Hf] = Maxwell1D(x, Q, ep, mu, h, m, CFL, FinalTime)
% Purpose: Integrate 1D Maxwells equation until FinalTime using a WENO scheme and a 3rd order SSP-RK method

%FIXME: boundary condition for maxwell doesnt appear to be correct

global discretizer;
global rk erk;
time = 0;
tstep = 0;

% Initialize reconstrcution weights
Crec = initReconstructionWeights(m);

[Efh_exat, Hfh_exact, ~, ~] = CavityExact(x , 1.0, 2.25, 1.0, 1.0, time);

figure('Position',[100 100 1200 400]);
ef_line = plot(x, Q(:,1), '-r');
hold on
hf_line = plot(x, Q(:,2), '-k');
ef_exact_line = plot(x, Efh_exat, '-sr'); hold on
hf_exact_line = plot(x, Hfh_exact, '-sk'); hold on

plt_title = title(sprintf('time = %4.3f, t-step = %d', time, tstep));
pause(0.1);


if strcmpi(discretizer, 'weno')
    % Initialize linear weights
    dw = LinearWeights(m, 0);
    
    % compute smoothness indicator matrices
    beta = computeSmoothnessIndicator(m);
    
    Maxwellflux = @( x, Q,  h, k, m, Crec, maxvel) ...
        MaxwellWENOrhs1D(x, Q, ep, mu, h, k, m, Crec, dw, beta);
elseif strcmpi(discretizer, 'eno')
    
    Maxwellflux = @( x, Q,  h, k, m, Crec, maxvel) ...
        MaxwellENOrhs1D(x, Q, ep, mu, h, k,m, Crec, maxvel);
end

% Set timestep
cvel = 1./sqrt(ep.*mu);
k = CFL*h/max(cvel);
maxvel = max(cvel);

% get the optimal starting step-size
%TODO: fix this
[dt, ~] = startingStepSize(x, h, k, m, Crec, maxvel, ...
    Q, Maxwellflux, erk.relTol, erk.absTol, erk.rk.p);

k = min(k, dt);

%integrate scheme
while (time < FinalTime)

    % Update solution ( call the stepper )
    [Q, k, time] = rk_takeStep(x, Q,  h, k, m, Crec, maxvel, Maxwellflux, time,  FinalTime, erk);
    [k time]
    
    % get the exact solution (reference)
    [Efh_exat, Hfh_exact, ~, ~] = CavityExact(x , 1.0, 2.25, 1.0, 1.0, time);
    
    set(ef_line, 'ydata', Q(:,1));
    set(hf_line, 'ydata', Q(:,2));
    set(ef_exact_line, 'ydata', Efh_exat);
    set(hf_exact_line, 'ydata', Hfh_exact);
    set(plt_title, 'string', sprintf('time = %4.3f, t-step = %d', time, tstep));
    drawnow;
    pause(0.1);
end

Ef = Q(:,1); Hf = Q(:,2);
return
