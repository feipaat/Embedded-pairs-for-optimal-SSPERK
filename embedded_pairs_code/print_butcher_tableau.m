function print_butcher_tableau(rk)
% clear all; close all;clc
% 
% method_p2 = '~/Dropbox/git/bitbucket/internship_summer15/imex_ssp/imex_op_same_abscissa/Methods/TYPEBC/P4/S5/new_order_positive_r1_00001.0000_r2_00001.3000_tol_-0015.mat';
% 
% rk = load(method_p2);
% A = rk.A;
% b = rk.b;
% c = rk.c;
% p = rk.p;
% s = rk.s;

% might not be working right
try
    fprintf(fid, '\\begin{table}[ht!]\n\n');
    fprintf(fid, '\\centering\n');

    print_method_tableau(fid, rk.A, rk.b, rk.c, rk.s, 'Explicit')
    fprintf(fid, '\n\n\n');
    print_method_tableau(fid, rk.At, rk.bt, rk.ct, rk.s, 'Implicit')

    fprintf('\n\n');
    create_label = sprintf('\\label{tab:%s}\n',label);
    fprintf(fid, '%s', create_label);
    fprintf(fid, '\\end{table}\n\n');
catch err
    error('something went wrong');
    err;
end

end

function print_method_tableau(fid, A, b, c, s, methodType)

A_c = [c A];

a_rep = repmat('c',1,s);

table_header = sprintf('c|%s}\n',a_rep);
hline = sprintf('\\hline\n');
fprintf(fid, '\\caption{%s Method}\n',methodType);
fprintf(fid, '%s%s','\begin{tabular}{',table_header);


for row = 1:s
    temp_row = [sprintf('%6.5f & ', A_c(row, 1:end-1)) sprintf('%6.5f \\\\ \n',A_c(row,end))];
    %fprintf('The number is:  %s\n',strtrim(rats(T)))
    %temp_row = [sprintf('%6.5f & ', strtrim(rats(A_c(row, 1:end-1)))) sprintf('%6.5f \\\\ \n',A_c(row,end))];
    fprintf(fid, '%s', temp_row);
end

fprintf(fid, '%s',hline);
%print b
fprintf(fid, ' & ');
temp_row = [sprintf(' %6.5f &', b(1:end-1)) sprintf('%6.5f \\\\ \n',b(end))];
fprintf(fid, '%s', temp_row);
%fprintf(fid, '%s \n','\hline');
fprintf(fid, '\\end{tabular}\n\n');
end
