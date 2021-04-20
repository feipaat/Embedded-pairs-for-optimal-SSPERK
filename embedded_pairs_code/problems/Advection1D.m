function [Ef, Hf] = Advection1D(x, Q, ep, mu, h, m, CFL, FinalTime)
% function [Ef, Hf] = Advection1D(x, Q, ep, mu, h, m, CFL, FinalTime)
% Purpose: Integrate 1D Advection equation until FinalTime using a WENO scheme and a 3rd order SSP-RK method

global discretizer;
time = 0;
tstep = 0;

% Initialize reconstrcution weights
Crec = initReconstructionWeights(m);

ef_line = plot(x, Q(:,1), '-r');
hold on
hf_line = plot(x, Q(:,2), '-k');
plt_title = title(sprintf('time = %4.3f, t-step = %d', time, tstep));
pause(0.1);

if strcmpi(discretizer, 'weno')
    % Initialize linear weights
    dw = LinearWeights(m, 0);
    
    % compute smoothness indicator matrices
    beta = computeSmoothnessIndicator(m);
    
    Advectionflux = @( x, Q,  h, k, m, Crec, maxvel) ...
        MaxwellWENOrhs1D(x, Q, ep, mu, h, k, m, Crec, dw, beta);
elseif strcmpi(discretizer, 'eno')
    
    Advectionflux = @( x, Q,  h, k, m, Crec, maxvel) ...
        MaxwellENOrhs1D(x, Q, ep, mu, h, k,m, Crec, maxvel);
end

% Set timestep
cvel = 1./sqrt(ep.*mu); 
k = CFL*h/max(cvel);
maxvel = max(cvel);

% get the optimal starting step-size
%TODO: fix this
% [k, nfcn] = startingStepSize(x, h, k, m, Crec, maxvel, ...
%     Q, Eulerflux, 1e-4, 1e-4, 4);


%integrate scheme
while (time < FinalTime)
    if (time + k > FinalTime)
        k = FinalTime - time;
    end

    % Update solution ( call the stepper )
    Q = rk_takeStep(x, Q,  h, k, m, Crec, maxvel, Advectionflux);

    time = time + k; tstep = tstep + 1;

    set(ef_line, 'ydata', Q(:,1));
    set(hf_line, 'ydata', Q(:,2));
    set(plt_title, 'string', sprintf('time = %4.3f, t-step = %d', time, tstep));
    drawnow;
    pause(0.1);
end

Ef = EM(:,1); Hf = EM(:,2);
return
