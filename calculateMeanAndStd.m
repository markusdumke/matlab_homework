function [ meanstdTable ] = calculateMeanAndStd( rets )
%
% Input:
%   rets      nxm table of returns
%
% Output:
%   meansdTable   2xm table of mean and standard deviation

rets_notintable = rets{:,:};        %returns in matrix
n_stocks = size(rets_notintable,2);  
mean_vec = zeros(1,n_stocks);        %preallocation
std_vec = zeros(1,n_stocks); 

for ii=1:n_stocks;
    thisstock = rets_notintable(:,ii);  %vector of stock ii
    nans = isnan(thisstock);            %delete all nans
    thisstock(nans) = [];
    mean_vec(1,ii) = mean(thisstock);   %calculate mean and std
    std_vec(1,ii) = std(thisstock);
end

meanstd_mat = [mean_vec ; std_vec];
meanstdTable = array2table(meanstd_mat);
meanstdTable.Properties.VariableNames = rets.Properties.VariableNames;
meanstdTable.Properties.RowNames = {'mean' 'std'};

end

