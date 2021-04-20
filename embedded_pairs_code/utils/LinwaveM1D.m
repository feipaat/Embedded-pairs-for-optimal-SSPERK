function [ u_lf ] = LinwaveM1D(ufunc, x, h, CFL, FinalTime)
% LinwaveM1D.m : Integration routine for solving the linear wave equation
% using conservative finite difference method

% function [ u ] = LinwaveM1D(ufunc, x, h, CFL, FinalTime)
% Purpose : Integrate 1D wave equation using a monotone scheme

[u_lf, u_lw, u_roe, u_uw] = deal(ufunc(x));
time = 0; tstep = 0;

% Set timestep
k = CFL*h;

% define plotting/figure size
fig = figure('position',[100 100 850 600]);
ax1 = axes('Position',[0 0 1 1],'Visible','off');
ax2 = axes('Position',[.3 .1 .6 .8]);
clf(fig); hold on;
line_lf = plot(x, u_lf, 'r', 'linewidth', 2);
line_lw = plot(x, u_lw, 'k', 'linewidth', 2);
line_roe = plot(x, u_roe, 'm', 'linewidth', 2);
line_uw = plot(x, u_uw, 'c', 'linewidth', 2);
line_exact = plot(x, ufunc(x - time), 'b','linewidth', 2);
axis([min(x) max(x) min(u_lf)-0.2 max(u_lf)+0.2]);
legend('LF', 'LW', 'Roe', 'UW', 'Exact', 'Location', 'NorthEastOutside');
ts = title(sprintf('step = %02d, time = %5.3f', tstep, time));
descr = {
    sprintf('CFL = %5.3f',CFL);
    sprintf('N = %d', numel(x));
    sprintf('dx = %5.3f',h);
    sprintf('dt = %5.3f',k)};
ds = text(1.05,0.6,descr);
set(ds, 'FontSize', 12);
pause(0.1);


% integrate scheme
while (time < FinalTime)
    if (time+k > FinalTime) k = FinalTime - time; end
    time = time + k; tstep = tstep + 1;
    % Update solution
    
    %Lax-Friendrichs
    temp_lf = LinwaveMrhs1D(x, u_lf, h, k, 1,'LF');
    u_lf = u_lf(:) + k*temp_lf;
    
    %Lax-Wendroff
    temp_lw = LinwaveMrhs1D(x, u_lw, h, k, 1,'LW');
    u_lw = u_lw(:) + k*temp_lw;
    
    %Roe
    temp_roe = LinwaveMrhs1D(x, u_roe, h, k, 1,'Roe');
    u_roe = u_roe(:) + k*temp_roe;
    
    %Upwind
    temp_uw = LinwaveMrhs1D(x, u_uw, h, k, 1,'UW');
    u_uw = u_uw(:) + k*temp_uw;
    
    %update figure
    set(line_lf, 'ydata', u_lf);
    set(line_lw, 'ydata', u_lw);
    set(line_roe, 'ydata', u_roe);
    set(line_uw, 'ydata', u_uw);
    set(line_exact, 'ydata', ufunc(x-time));
    set(ts, 'string', sprintf('step = %02d, time = %5.3f', tstep, time));
    drawnow;
    pause(0.1);
    
    
    
end
return
end
