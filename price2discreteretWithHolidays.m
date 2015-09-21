function retsTable = price2discreteretWithHolidays(prices)
%
% Input:
%   prices      nxm table of prices
%
% Output:
%   retsTable   (n-1)xm table of discrete returns

missingValues = isnan(prices{:, :});

% prices imputed
Prices = prices{:, :};
pricesImputed = imputeWithLastDay(Prices);

% calculate returns
rets = (pricesImputed(2:end, :) - pricesImputed(1:end-1, :))./...
    pricesImputed(1:end-1, :);

rets(missingValues(2:end, :)) = NaN;

% return log returns as table
retsTable = prices(2:end, :);
retsTable{:, :} = 100*rets;

end


