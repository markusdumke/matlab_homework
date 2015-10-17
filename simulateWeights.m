function [ weights ] = simulateWeights( nstocks, nsim )
%
% Input:
%   nstocks         number of stocks
%   nsim            number of simulated portfolios
%
% Output:
%   weigths      nsim x nstocks matrix with portfolio weights

weights = rand(nsim,nstocks);   %simulate random numbers

rescale_factor = sum(weights, 2);     % sum up weights
rescale_factor = rescale_factor(:,ones(nstocks,1));  % Make size-compatible matrix
weights = weights./rescale_factor;    % Normalize so sum of weights = 1

end

