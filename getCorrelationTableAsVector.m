function [ corr_vec ] = getCorrelationTableAsVector( corTable )
%
% Input:
%   corTable   mxm table of correlations between stocks
%
% Output:
%   corr_vec      sum(1:m)x1 vector of correlations
%

M = tril(corTable{:,:},-1);      %get the values below the diagonal
vec = M(:);                      %put the values in a vector
corr_vec = vec(vec > 0);         %get rid of unwanted zeros

end

