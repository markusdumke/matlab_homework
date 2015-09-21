function [ meanstdTable ] = calculateMeanAndStd( rets )
%
% Input:
%   rets      nxm table of returns
%
% Output:
%   meanstdTable   mx2 table of mean and standard deviation


rets_notintable = rets{:,:};       %returns in a matrix

rets_mean = mean(rets_notintable,'omitnan');  %mean vector
rets_std = std(rets_notintable,'omitnan');  %std vector

meanstdTable = table(rets_mean(:) , rets_std(:));
meanstdTable.Properties.VariableNames = {'mean' 'std'};
meanstdTable.Properties.RowNames = rets.Properties.VariableNames;

end

