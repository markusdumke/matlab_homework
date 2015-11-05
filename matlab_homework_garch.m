% Solution to part 1, exercise 1

% get Deutsche Bank prices
dateBeg = '01012000';
dateEnd = '01012015';
tickerSymbs = {'DBK.DE'};

dbk_prices = getPrices(dateBeg, dateEnd, tickerSymbs);

%% calculate returns
dbk_ret_table = price2retWithHolidays(dbk_prices);
dbk_logrets = 100*dbk_ret_table{:,:};

%% estimate mean parameter
% better, but not required for homework
muHat = mean(dbk_logrets);

%% estimate Garch parameters
dbk_garch = estimate(garch(1,1),dbk_logrets - muHat);

% get conditional standard deviations, not variances
sigmas = sqrt(infer(dbk_garch,dbk_logrets));

%%
Dates = datenum(dbk_ret_table.Properties.RowNames);
plot(Dates, dbk_logrets)
datetick 'x'

plot(Dates,sigmas)
datetick 'x'

%% estimate VaR
quantile = 0.05;

% unrequired due to removal of for loop
vars = zeros(numel(dbk_logrets),1);   % preallocate VaR vector

% - no for loop required
% - dbk_garch.Constant is constant in variance equation, not mean equation
vars = norminv(quantile, muHat, sigmas);

% get exceedances
exceeds = (dbk_logrets <= vars(:, 1));

% plotting
plot(Dates, dbk_logrets, '.b')
hold on;

plot(Dates(exceeds), dbk_logrets(exceeds), '.r', 'MarkerSize', 12)
datetick 'x'
set(gca, 'xLim', [Dates(1) Dates(end)], ...
    'yLim', [floor(min(dbk_logrets))-1 0]);

% include line for VaR estimations
hold on;
plot(Dates, vars(:,1), '-k')

% calculate exceedance frequency
frequ = sum(exceeds)/numel(dbk_logrets);

title(['Exceedance frequency: ' num2str(frequ, 1)...
    ' instead of ' num2str(quantile, 1)])


%%
nsim = 40000;
[Vw,Yw] = simulate(dbk_garch, nsim);

subplot(2,1,1)
plot(Vw)
xlim([0,nsim])
title('Conditional Variances')

subplot(2,1,2)
plot(Yw)
xlim([0,nsim])
title('Innovations')

subplot(2,1,1)
autocorr(Yw.^2)
title('ACF of simulated data')

subplot(2,1,2)
autocorr(dbk_logrets.^2)
title('empirical ACF')

% ACF of simulated data is a bit larger

%%
nsim = length(dbk_logrets);
[Vw,Yw] = simulate(dbk_garch, nsim, 'NumPaths', 3);

h(1) = subplot(4,1,1)
plot(Dates,dbk_logrets)    %plot real data
datetick 'x'

h(2) = subplot(4,1,2)
plot(Dates,Yw(:,1))     %add plots for simulated paths
datetick 'x'

h(3) = subplot(4,1,3)
plot(Dates,Yw(:,2))
datetick 'x'

h(4) = subplot(4,1,4)
plot(Dates,Yw(:,3))
datetick 'x'

linkaxes([h(1),h(2),h(3), h(4)], 'y')

%Yes, because the real historic path has a large volatility
%around 2009, the simulated paths at different time points

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Exercise 2
clf

%Kernel density
ksdensity(dbk_logrets)
xlim([-15,15])
hold on;

%% anonymous function to calculate loglik of normal distribution
nllh = @(params, data)sum(0.5*log(params(2)^2*2*pi)+...
    0.5*(data - params(1)).^2/params(2)^2);

% optimization
params0 = [0 1];

lb = [-inf 0.1];  %set lower & upper bounds
ub = [inf inf];

paramsHat = fmincon(@(params)nllh(params,dbk_logrets),...
    params0, [], [], [], [], lb, ub);

mu = paramsHat(1);
sigma = paramsHat(2);

%% Adding normal density to plot
x=-15:0.1:15;
plot(x,normpdf(x,mu,sigma), '-r')
hold on;

%% simulate a path of length 40000 from dbk_garch
nsim = 40000;
[~,Yn] = simulate(dbk_garch, nsim);   %simulate from GARCH model
[f,xi] = ksdensity(Yn);
plot(xi,f, '-g')
hold on;

%% estimate Garch parameters with underlying t distribution
mod = garch(1,1);
mod.Distribution = 't';
dbk_garch_t = estimate(mod,dbk_logrets);

%% simulate a path of length 40000 from dbk_garch_t
nsim = 40000;
[~,Yt] = simulate(dbk_garch, nsim);   %simulate from GARCH model
[g,xj] = ksdensity(Yt);
plot(xj,g, '-black')

legend('ksdensity','Normal', 'GARCH Normal', 'GARCH t')

% Which model does best replicate the 
%         leptokurtosis of the real world data sample?

% The GARCH models fit better than the Normal distribution
% GARCH with t distributed errors fits a bit better than the GARCH with 
% normal distributed errors








