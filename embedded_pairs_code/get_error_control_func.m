function [err_control ] = get_error_control_func(A, b, bt, p, phat)
% File: get_error_control_func.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Compute the Error Control variables for RK(A,b,bt)
% of p and embedded order phat

c = sum(A,2);

% SSP method (error control variables)
% tau_{q+1}
tau_qp1 = order_conditions(p+1, A, b, c);

A1_2 = norm(tau_qp1, 2);
A1_inf = norm(tau_qp1,inf);

% Embedded method (error control variables)
tau_hat_p1 = order_conditions(phat+1, A, bt, c);

%tau_hat_{p+2}
tau_hat_p2 = order_conditions(phat+2, A, bt, c);
tau_p2 = order_conditions(phat+2, A, b, c);

%Goal: minimize A
% equation (2.5)
A_p1_2 = norm(tau_hat_p1,2);
A_p1_inf = norm(tau_hat_p1, inf);

% equation (2.6)
B_p2_2 = norm(tau_hat_p2,2)/norm(tau_hat_p1,2);
B_p2_inf = norm(tau_hat_p2,inf)/norm(tau_hat_p1,inf);

B_con(1) = B_p2_2 - 1;
B_con(2) = B_p2_inf - 1;

% equation (2.7)
C_p2_2 = norm(tau_hat_p2 - tau_p2,2)/norm(tau_hat_p1,2);
C_p2_inf = norm(tau_hat_p2 - tau_p2,inf)/norm(tau_hat_p1,inf);

C_con(1) = C_p2_2 - 1;
C_con(2) = C_p2_inf - 1;

% equation (2.9)
tau_p2 = tau_qp1;
E_p2_2 = norm(tau_p2,2)/norm(tau_hat_p1,2);
E_p2_inf = norm(tau_p2,inf)/norm(tau_hat_p1,inf);


ErroControl_Variable = [A_p1_2(:);
    A_p1_inf(:);
    B_con(:);
    C_con(:)];

err_control = [A1_2 A1_inf A_p1_2 A_p1_inf B_p2_2 B_p2_inf C_p2_2 C_p2_inf];
end
