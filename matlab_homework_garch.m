% Solution to part 1, exercise 1

% get Deutsche Bank prices
dateBeg = '01012000';
dateEnd = '01012015';
tickerSymbs = {'DBK.DE'};

dbk_prices = getPrices(dateBeg, dateEnd, tickerSymbs);

%% calculate returns
dbk_ret_table = price2retWithHolidays(dbk_prices);
dbk_logrets = 100*dbk_ret_table{:,:};

%% estimate Garch parameters
dbk_garch = estimate(garch(1,1),dbk_logrets);

%get conditional variances
sigmas = infer(dbk_garch,dbk_logrets);

%%
Dates = datenum(dbk_ret_table.Properties.RowNames);
plot(Dates, dbk_logrets)
datetick 'x'

plot(Dates,sigmas)
datetick 'x'

%% estimate VaR
quantile = 0.05;
vars = zeros(numel(dbk_logrets),1);   % preallocate VaR vector

for ii=1:numel(dbk_logrets)
    curr_sigma = sigmas(ii); % get sigma value
    vars(ii,:) = norminv(quantile, dbk_garch.Constant, curr_sigma);
end

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

title(['Exceedance frequency: ' num2str(frequ, 3)...
    ' instead of ' num2str(quantile, 3)])


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

%%
nsim = length(dbk_logrets);
[Vw,Yw] = simulate(dbk_garch, nsim, 'NumPaths', 3);

h(1) = subplot(4,1,1)
plot(Dates,dbk_logrets)    %plot real data
datetick 'x'

h(2) = subplot(4,1,2)
plot(Dates,Yw(:,1))     %add plots for simulated paths
datetick 'x'
%ylim([-50,50])

h(3) = subplot(4,1,3)
plot(Dates,Yw(:,2))
datetick 'x'
%ylim([-50,50])

h(4) = subplot(4,1,4)
plot(Dates,Yw(:,3))
datetick 'x'
%ylim([-50,50])

linkaxes(h)
ylim([-30 30])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Exercise 2

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

% Which model does best replicate the 
%         leptokurtosis of the real world data sample?

% The GARCH models fit best.








