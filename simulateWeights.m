function [ weights ] = simulateWeights( nstocks, nsim )
%
% Input:
%   nstocks         number of stocks
%   nsim            number of simulated portfolios
%
% Output:
%   weigths      nsim x nstocks matrix with portfolio weights

weights = rand(nsim,nstocks);   %simulate random numbers

%rescale portfolio weights so they add up to 1
for ii=1:nsim
    rescale_factor = 1/sum(weights(ii,:));
    weights(ii,:) = weights(ii,:)*rescale_factor;   
end

end

