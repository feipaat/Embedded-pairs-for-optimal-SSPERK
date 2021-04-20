function [ ceq] = order_conditions(p, A, b, c)
% File: order_conditions.m
% Author: Sidafa Conde
% Email: sconde@umassd.edu
% School: UMass Dartmouth
% Date: 
% Purpose: Algebraic order conditions

tau_2  = (c.^2)/factorial(2) - A*c;
tau_3  = (c.^3)/factorial(3) - A*(c.^2)/factorial(2);
tau_4  = (c.^4)/factorial(4) - A*(c.^3)/factorial(3);
tau_5  = (c.^5)/factorial(5) - A*(c.^4)/factorial(4);
tau_6  = (c.^6)/factorial(6) - A*(c.^5)/factorial(5);
tau_7  = (c.^7)/factorial(7) - A*(c.^6)/factorial(6);
tau_8  = (c.^8)/factorial(8) - A*(c.^7)/factorial(7);
tau_9  = (c.^9)/factorial(9) - A*(c.^8)/factorial(8);
tau_10 = (c.^10)/factorial(10) - A*(c.^9)/factorial(9);
tau_11 = (c.^11)/factorial(11) - A*(c.^10)/factorial(10);
C      = diag(c);

ceq(1) = sum(b) - 1;

if p==2
    ceq(2) = b'*c-1/2;
end

if p==3
    ceq(2) = b'*c-1/2;
    ceq(3) = b'*c.^2 - 1/3;
    ceq(4) = b'*tau_2;
end

if p==4
    ceq(1) = b'*c- 1/2;
    ceq(2) = b'*c.^2 - 1/3;
    ceq(3) = b'*tau_2;
    ceq(4) = b'*c.^3-1/4;
    ceq(5) = b'*C*tau_2;
    ceq(6) = b'*A*tau_2;
    ceq(7) = b'*tau_3;
end

if p==5          %p>=5 tau_2=0
    ceq(2) = b'*c -1/2;
    ceq(3) = b'*c.^2 - 1/3;
    ceq(4) = b'*c.^3 - 1/4;
    ceq(5) = b'*tau_3;
    ceq(6) = b'*c.^4 - 1/5;
    ceq(7) = b'*A*tau_3;
    ceq(8) = b'*tau_4;
    ceq(9) = b'*C*tau_3;
    ceq    = [ceq tau_2'];
end

if p==6
    ceq(2)  = b'*c -1/2;
    ceq(3)  = b'*c.^2 - 1/3;
    ceq(4)  = b'*c.^3 - 1/4;
    ceq(5)  = b'*c.^4 - 1/5;
    ceq(6)  = b'*tau_3;
    ceq(7)  = b'*A*tau_3;
    ceq(8)  = b'*tau_4;
    ceq(9)  = b'*C*tau_3;
    ceq(10) = b'*c.^5 - 1/6;
    ceq(11) = b'*A^2*tau_3;
    ceq(12) = b'*A*tau_4;
    ceq(13) = b'*A*C*tau_3;
    ceq(14) = b'*tau_5;
    ceq(15) = b'*C*A*tau_3;
    ceq(16) = b'*C*tau_4;
    ceq(17) = b'*C^2*tau_3;
    ceq     = [ceq tau_2'];
end

if p==7   %p>=7 tau_2=0 & tau_3=0
    ceq(2)  = b'*c - 1/2;
    ceq(3)  = b'*c.^2 - 1/3;
    ceq(4)  = b'*c.^3 - 1/4;
    ceq(5)  = b'*c.^4 - 1/5;
    ceq(6)  = b'*tau_4;
    ceq(7)  = b'*c.^5 - 1/6;
    ceq(8)  = b'*A*tau_4;
    ceq(9)  = b'*tau_5;
    ceq(10) = b'*C*tau_4;
    ceq(11) = b'*c.^6 - 1/7;
    ceq(12) = b'*A^2*tau_4;
    ceq(13) = b'*A*tau_5;
    ceq(14) = b'*A*C*tau_4;
end

if p==8
    ceq(2)  = b'*c - 1/2;
    ceq(3)  = b'*c.^2 - 1/3;
    ceq(4)  = b'*c.^3 - 1/4;
    ceq(5)  = b'*c.^4 - 1/5;
    ceq(6)  = b'*tau_4;
    ceq(7)  = b'*c.^5 - 1/6;
    ceq(8)  = b'*A*tau_4;
    ceq(9)  = b'*tau_5;
    ceq(10) = b'*C*tau_4;
    ceq(11) = b'*c.^6 - 1/7;
    ceq(12) = b'*A^2*tau_4;
    ceq(13) = b'*A*tau_5;
    ceq(14) = b'*A*C*tau_4;
    ceq(15) = b'*tau_6;
    ceq(16) = b'*C*A*tau_4;
    ceq(17) = b'*C*tau_5;
    ceq(18) = b'*C^2*tau_4;
    ceq(19) = b'*c.^7 - 1/8;
    ceq(21) = b'*A^3*tau_4;
    ceq(22) = b'*A^2*tau_5;
    ceq(23) = b'*A^2*C*tau_4;
    ceq(24) = b'*A*tau_6;
    ceq(25) = b'*A*C*A*tau_4;
    ceq(26) = b'*A*C*tau_5;
    ceq(27) = b'*A*C^2*tau_4;
    ceq(28) = b'*tau_7;
    ceq(29) = b'*C*A^2*tau_4;
    ceq(30) = b'*C*A*tau_5;
    ceq(31) = b'*C*A*C*tau_4;
    ceq(32) = b'*C*tau_6;
    ceq(33) = b'*C^2*A*tau_4;
    ceq(34) = b'*C^2*tau_5;
    ceq(35) = b'*C^3*tau_4;
    
    ceq=[ceq tau_2' tau_3'];
end

if p==9
    ceq(2) = b'*c -1/2;
    ceq(3) =b'*c.^2 -1/3;
    ceq(4) =b'*c.^3 -1/4;
    ceq(5) =b'*c.^4 -1/5;
    ceq(6) =b'*c.^5 -1/6;
    ceq(7) =b'*tau_5;
    ceq(8) =b'*c.^6 -1/7;
    ceq(9) =b'*A*tau_5;
    ceq(10)=b'*tau_6;
    ceq(11) =b'*C*tau_5;
    ceq(12) = b'*c.^7 -1/8;
    ceq(13) = b'*A^2*tau_5;
    ceq(14) = b'*A*tau_6;
    ceq(15) = b'*A*C*tau_5;
    ceq(16) = b'*tau_7;
    ceq(17) = b'*C*A*tau_5;
    ceq(18) = b'*C*tau_6;
    ceq(19) = b'*C^2*tau_5;
    ceq(20) = b'*c.^8 -1/9;
    ceq(21) = b'*C*A^2*tau_5;
    ceq(22) = b'*C*A*tau_6;
    ceq(23) = b'*C*A*C*tau_5;
    ceq(24) = b'*C*tau_7;
    ceq(25) = b'*C^2*A*tau_5;
    ceq(26) = b'*C^2*tau_6;
    ceq(27) = b'*C^3*tau_5;
    ceq(28) = b'*A^2*tau_5;
    ceq(29) = b'*A^3*tau_5;
    ceq(30) = b'*A^2*tau_6;
    ceq(31) = b'*A^2*C*tau_5;
    ceq(32) = b'*A*tau_7;
    ceq(33) = b'*A*C*A*tau_5;
    ceq(34) = b'*A*C*tau_6;
    ceq(35) = b'*A*C^2*tau_5;
    ceq(36) = b'*tau_8;
    
    ceq=[ceq tau_2' tau_3' tau_4'];
end
if p==10 
        ceq(2)  = b'*c -1/2;
        ceq(3)  = b'*c.^2 -1/3;
        ceq(4)  = b'*c.^3 - 1/4;
        ceq(5)  = b'*c.^4 - 1/5;
        ceq(6)  = b'*c.^5 - 1/6;
        ceq(7)  = b'*c.^6 - 1/7;
        ceq(8)  = b'*c.^7 - 1/8;
        ceq(9)  = b'*c.^8 - 1/9;
        ceq(10) = b'*A*tau_5;
        ceq(11) = b'*tau_6;
        ceq(12) = b'*C*tau_5;
        ceq(13) = b'*tau_5;
        ceq(14) = b'*A^2*tau_5;
        ceq(15) = b'*A*tau_6;
        ceq(16) = b'*A*C*tau_5;
        ceq(17) = b'*tau_7;
        ceq(18) = b'*C*A*tau_5;
        ceq(19) = b'*C*tau_6;
        ceq(20) = b'*C^2*tau_5;
        ceq(21) = b'*C*A^2*tau_5;
        ceq(22) = b'*C*A*tau_6;
        ceq(23) = b'*C*A*C*tau_5;
        ceq(24) = b'*C*tau_7;
        ceq(25) = b'*C^2*A*tau_5;
        ceq(26) = b'*C^2*tau_6;
        ceq(27) = b'*C^3*tau_5;
        ceq(28) = b'*A^2*tau_5;
        ceq(29) = b'*A^3*tau_5;
        ceq(30) = b'*A^2*tau_6;
        ceq(31) = b'*A^2*C*tau_5;
        ceq(32) = b'*A*tau_7;
        ceq(33) = b'*A*C*A*tau_5;
        ceq(34) = b'*A*C*tau_6;
        ceq(35) = b'*A*C^2*tau_5;
        ceq(36) = b'*tau_8;

        ceq(37) = b'*c.^9 - 1/10;
        ceq(38) = b'*A^2*tau_5;
        ceq(39) = b'*A*tau_6;
        ceq(40) = b'*A*C*tau_5;
        ceq(41) = b'*A*tau_5;
        ceq(42) = b'*A^3*tau_5;
        ceq(43) = b'*A^2*tau_6;
        ceq(44) = b'*A^2*C*tau_5;
        ceq(45) = b'*A*tau_7;
        ceq(46) = b'*A*C*A*tau_5;
        ceq(47) = b'*A*C*tau_6;
        ceq(48) = b'*A*C^2*tau_5;
        ceq(49) = b'*A*C*A^2*tau_5;
        ceq(50) = b'*A*C*A*tau_6;
        ceq(51) = b'*A*C*A*C*tau_5;
        ceq(52) = b'*A*C*tau_7;
        ceq(53) = b'*A*C^2*A*tau_5;
        ceq(54) = b'*A*C^2*tau_6;
        ceq(55) = b'*A*C^3*tau_5;
        ceq(56) = b'*A^3*tau_5;
        ceq(57) = b'*A^4*tau_5;
        ceq(58) = b'*A^3*tau_6;
        ceq(59) = b'*A^3*C*tau_5;
        ceq(60) = b'*A^2*tau_7;
        ceq(61) = b'*A^2*C*A*tau_5;
        ceq(62) = b'*A^2*C*tau_6;
        ceq(63) = b'*A^3*tau_5;
        ceq(64) = b'*A*tau_8;
        ceq(65) = b'*C*A*tau_5;
        ceq(66) = b'*C*tau_6;
        ceq(67) = b'*C^2*tau_5;
        ceq(68) = b'*C*tau_5;
        ceq(69) = b'*C*A^2*tau_5;
        ceq(70) = b'*C*A*tau_6;
        ceq(71) = b'*C*A*C*tau_5;
        ceq(72) = b'*C*tau_7;
        ceq(73) = b'*C^2*A*tau_5;
        ceq(74) = b'*C^2*tau_6;
        ceq(75) = b'*C^3*tau_5;
        ceq(76) = b'*C^2*A^2*tau_5;
        ceq(77) = b'*C^2*A*tau_6;
        ceq(78) = b'*C^2*A*C*tau_5;
        ceq(79) = b'*C^2*tau_7;
        ceq(80) = b'*C^3*A*tau_5;
        ceq(81) = b'*C^3*tau_6;
        ceq(82) = b'*C^4*tau_5;
        ceq(83) = b'*C*A^2*tau_5;
        ceq(84) = b'*C*A^3*tau_5;
        ceq(85) = b'*C*A^2*tau_6;
        ceq(86) = b'*C*A^2*C*tau_5;
        ceq(87) = b'*C*A*tau_7;
        ceq(88) = b'*C*A*C*A*tau_5;
        ceq(89) = b'*C*A*C*tau_6;
        ceq(90) = b'*C*A*C^2*tau_5;
        ceq(91) = b'*C*tau_8;
        ceq(92) = b'*tau_9;

	    ceq=[ceq tau_2' tau_3' tau_4'];
end

end    % of function
