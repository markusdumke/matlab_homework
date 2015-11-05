function [ corTable ] = calculateCorrelations( rets )
%
% Input:
%   rets      nxm table of returns
%
% Output:
%   corTable   mxm table of correlations between stocks

rets_notintable = rets{:,:};       %returns in a matrix

% you should have used the maximum number of observations for pairwise
% correlations
rets_corr = corrcoef(rets_notintable,'rows','pairwise'); %correlation matrix

corTable = array2table(rets_corr);
corTable.Properties.VariableNames = rets.Properties.VariableNames;
corTable.Properties.RowNames = rets.Properties.VariableNames;

end

