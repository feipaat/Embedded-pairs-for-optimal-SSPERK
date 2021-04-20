%Sidafa Conde
%example of vanderpol ODE
clear all; close all; clc

addpath('~/Documents/SSPTools', '../methods');

merson45          = literatureMethods('merson45'); % orders(4,3) NOTE: bt only of order 5 for linear equations with constant coefficient
zonneveld43       = literatureMethods('zonneveld43'); % orders(4,3)
fehlberg45        = literatureMethods('fehlberg45'); % order (4,5)
dormandprince54   = literatureMethods('dormandprince54'); %(6, 4)
ceschino24        = literatureMethods('ceschino24'); %(2, 4)
heuneuler21       = literatureMethods('heuneuler21'); % (2, 1)
rkf23             = literatureMethods('rkf23'); % (2, 3)
rkf23b            = literatureMethods('rkf23b'); %(3, 3)
fehlberg12        = literatureMethods('fehlberg12'); %(1, 2)
fehlberg12b       = literatureMethods('fehlberg12b'); %(1.5, 2)
bogackishampine32 = literatureMethods('bogackishampine32'); %(3, 2)
bs5 = literatureMethods('bs5');

%%% second order methods
myRK22Best = loadMyMethods(2, 2, true); % (2, 1)
myRK32Best = loadMyMethods(3, 2, true); %(2, 1)
myRK42Best = loadMyMethods(4, 2, true); %(2,1)
rk_ssperk42_b1 = imre_second_order(4, 2, 'b1'); %(2,1)
rk_ssperk42_b2 = imre_second_order(4, 2, 'b2'); %(2,1)
rk_ssperk62_b1 = imre_second_order(6, 2, 'b1'); %(2,1)
rk_ssperk62_b2 = imre_second_order(6, 2, 'b2'); %(2,1)
rk_ssperk22_b1 = imre_second_order(2, 2, 'b1'); %(2,1)
rk_ssperk22_b2 = imre_second_order(2, 2, 'b2'); % (2,1)
ceschino24  = literatureMethods('ceschino24'); %(2, 4)
heuneuler21 = literatureMethods('heuneuler21'); % (2, 1)
rkf23       = literatureMethods('rkf23'); % (3, 2)
rkf23b      = literatureMethods('rkf23b'); %(3, 3)
fehlberg12  = literatureMethods('fehlberg12'); %(2, 1)
fehlberg12b = literatureMethods('fehlberg12b'); %(1.5, 2)

%%% third order methods
myRK33Best = loadMyMethods(3, 3, true); %(3,2)
myRK43Best = loadMyMethods(4, 3, true); %(3,2)
myRK53Best = loadMyMethods(5, 3, true); %(3,2)
bogackishampine32 = literatureMethods('bogackishampine32'); %(3, 2)

%%% fourth order methods
merson45          = literatureMethods('merson45'); % orders(4,3) NOTE: bt only of order 5 for linear equations with constant coefficient
zonneveld43       = literatureMethods('zonneveld43'); % orders(4,3)
fehlberg45        = literatureMethods('fehlberg45'); % order (5,4)
dormandprince54   = literatureMethods('dormandprince54'); %(5, 4)

rk_ssperk104_b1 = loadSSPERK104(10, 4, 'b1');
rk_ssperk104_b2 = loadSSPERK104(10, 4, 'b2');
rk_ssperk104_b3 = loadSSPERK104(10, 4, 'b3');
rk_ssperk104_b4 = loadSSPERK104(10, 4, 'b4');
rk_ssperk104_b5 = loadSSPERK104(10, 4, 'b5');
rk_ssperk104_b6 = loadSSPERK104(10, 4, 'b6');
rk_ssperk104_b7 = loadSSPERK104(10, 4, 'b7');
rk_ssperk104_b8 = loadSSPERK104(10, 4, 'b8');

% Imre's method
rk_ssperk43_b1 = imre_third_order(4, 3, 'b1');
rk_ssperk43_b2 = imre_third_order(4, 3, 'b2');

dt = 0.01;
Tfinal = 1;
t = 0;

y0 = [2; -0.6654321];

vdp = TestProblems.ODEs.Vanderpol();
%rk = fehlberg45;
rk = merson45;

dudt = SSPTools.Steppers.ERK('A', rk.A, 'b',rk.bt, 's', rk.s,...
                'ODE', vdp, 'y0', y0);

convergence_pro = Tests.Convergence('integrator', dudt,'Tfinal', Tfinal,...
    'DT', Tfinal./[200:20:300]);

convergence_pro.run();
convergence_pro.complete;
convergence_pro.getOrder('l2')
