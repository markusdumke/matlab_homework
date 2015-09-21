function [ portfolio_meanstd ] = simulatePortfolio( returns, nsim )
%
% Input:
%   returns   table of stock returns
%
% Output:
%   portfolio_meanstd    nsimx2 table of  
%

nstocks = size(returns(:,:),2);
weights = simulateWeights(nstocks, nsim);

meanstd = calculateMeanAndStd(returns);
portfolio_means =  weights*meanstd{:,1};     %portfolio means

Cov = cov(returns{:,:},'omitrows');    %covariance matrix of the returns
portfolio_var= zeros(nsim,1);

for ii=1:nsim
multiplied_weights = transpose(weights(ii,:))*weights(ii,:);
Z = multiplied_weights .* tril(Cov,0);
portfolio_var(ii) = sum(sum(Z,2));
end

portfolio_std = sqrt(portfolio_var);
portfolio_meanstd = table(portfolio_means,portfolio_std, ...
                    'VariableNames',{'Mean' 'Std'});

end

