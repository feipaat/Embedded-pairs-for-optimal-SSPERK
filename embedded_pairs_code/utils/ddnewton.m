function [maxDDN, DDNMat] = ddnewton(x, v)
% function [maxDDN, DDNMat] = ddnewton(x, v)
% Purpose: Create the table of Newtons divided difference based on (x, v)

m = length(x);
DDNMat = zeros(m, m+1);

% Inseting x into the 11st column and f into the 2nd column of table
DDNMat(1:m,1) = x;
DDNMat(1:m,2) = v;

% create divided difference coefficients by recurrence
for j = 1:m-1
    for k = 1:m-j
        DDNMat(k, j+2) = (DDNMat(k+1, j+1) - DDNMat(k, j+1))/(DDNMat(k+j,1) - DDNMat(k,1));
    end
end

% extrct max coefficient
maxDDN = abs(DDNMat(1,m+1));

end
