function [ tickSymbs ] = getTickSymbsofMaxCorrelatedStocks( corTable )
%
% Input:
%   corTable   mxm table of correlations between stocks
%
% Output:
%   tickSymbs      1x2 cell array with ticker symbols 
%                   of maximal correlated stocks
%
corr_vec = getCorrelationTableAsVector(corTable);  %correlation vector
max_corr = max(corr_vec);          %find maximum in correlation vector
M = tril(corTable{:,:},-1);      %get the lower triangular matrix
[row, col] = find(M == max_corr);  %find position of maximum in corr matrix

tickSymbs = cell(1,2);        %preallocation
maxTable = corTable(row,col);
tickSymbs{1,1} = maxTable.Properties.RowNames{:,:};
tickSymbs{1,2} = maxTable.Properties.VariableNames{:,:};

end

