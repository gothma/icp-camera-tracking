function [ error ] = error_icp( X, Y, S, weights )
%ERROR_ICP Summary of this function goes here
%   Input:
%       X
%       Y
%  
misc_checkType(X, 'DOUBLE');
misc_checkType(Y, 'DOUBLE');
misc_checkType(S, 'DOUBLE');
if size(S) == [3,3]
   S = [S(1,1), S(2,2), S(3,3)]; 
end

sum_X = sum(abs(X).^2,2);
sum_Y = sum(abs(Y).^2,2);

error = (sum(sum_X + sum_Y) - 2*(S(1) + S(2) + S(3))) / sum(weights);
end

