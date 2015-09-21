function [ corTable ] = calculateCorrelations( rets )
%
% Input:
%   rets      nxm table of returns
%
% Output:
%   corTable   mxm table of correlations between stocks

rets_notintable = rets{:,:};       %returns in a matrix

rets_corr = corrcoef(rets_notintable,'rows','complete'); %correlation matrix

corTable = array2table(rets_corr);
corTable.Properties.VariableNames = rets.Properties.VariableNames;
corTable.Properties.RowNames = rets.Properties.VariableNames;

end

