% Solution to part 2, exercise 3

% get dax prices
dateBeg = '01012000';
dateEnd = '01012015';
tickerSymbs = {'ADS.DE', 'ALV.DE', 'BAS.DE', 'BAYN.DE'...
   'BEI.DE', 'BMW.DE', 'CBK.DE', 'CON.DE', 'DAI.DE', 'DB1.DE' ...
   'DBK.DE', 'DPW.DE', 'DTE.DE', 'EOAN.DE', 'FME.DE', 'FRE.DE'...
   'HEI.DE', 'HEN3.DE', 'IFX.DE', 'LHA.DE', 'LIN.DE', 'LXS.DE'...
   'MRK.DE', 'MUV2.DE', 'RWE.DE', 'SAP.DE', 'SDF.DE', 'SIE.DE'...
   'TKA.DE', 'VOW3.DE'};

dax_prices = getPrices(dateBeg, dateEnd, tickerSymbs);

%% get dax returns
dax_ret = price2discreteretWithHolidays(dax_prices);

%% get dax means and stand.deviations
dax_meanstd = calculateMeanAndStd(dax_ret);

%% get correlations
dax_corr = calculateCorrelations(dax_ret);

%% plot Histogram
corr_vec = getCorrelationTableAsVector(dax_corr);

nbins = 20;
hist(corr_vec, nbins)          %histogram of correlations

%% display ticker Symbols of maximal correlated assets
max_corr_tickSymbs = getTickSymbsofMaxCorrelatedStocks(dax_corr);

%% Plotting
mean_vec = dax_meanstd{:,1};
std_vec = dax_meanstd{:,2};

scatter(std_vec, mean_vec, 'red', 'filled')
title('DAX stocks')
xlabel('Standard Deviations')
ylabel('Expected Returns')
%axis([0 ceil(max(std_vec)) -0.06 0.1])
hold on;

%% Portfolio with DKB and DPW
tickSymbs = {'DBK.DE', 'DPW.DE'};
prices = getPrices(dateBeg, dateEnd, tickSymbs);
returns = price2discreteretWithHolidays(prices);

portfolio_dbkdpw = simulatePortfolio(returns,200);

%% Plotting
scatter(std_vec, mean_vec, 'red', 'filled')
title('DAX stocks')
xlabel('Standard Deviations')
ylabel('Expected Returns')
%axis([0 ceil(max(std_vec)) -0.06 0.1])
hold on;

scatter(portfolio_dbkdpw.Std, portfolio_dbkdpw.Mean, 'blue', 'filled')
hold on;

mean_dbkdbpw = dax_meanstd{{'DBK_DE', 'DPW_DE'},1};
std_dbkdpw = dax_meanstd{{'DBK_DE', 'DPW_DE'},2};

scatter(std_dbkdpw, mean_dbkdbpw, 80, 'green', 'filled')

%% Portfolio with DBK, DPW, TKA, CBK
tickSymbs2 = {'DBK.DE', 'DPW.DE', 'TKA.DE', 'CBK.DE'};
prices_DbkDpwTkaCbk = getPrices(dateBeg, dateEnd, tickSymbs2);
returns_DbkDpwTkaCbk = price2discreteretWithHolidays(prices_DbkDpwTkaCbk);

tic;
portfolio_DbkDpwTkaCbk = simulatePortfolio(returns_DbkDpwTkaCbk,50000);
time = toc %0.93 Sekunden

%no asset is on average taken with lower weights than the rest
%Proof:
tic;
w = simulateWeights(4,50000);
time2 = toc %0.16 Sekunden

mean(w) %all very close to 0.25

%% Plotting
scatter(std_vec, mean_vec, 'red', 'filled')
title('DAX stocks')
xlabel('Standard Deviations')
ylabel('Expected Returns')
%axis([0 ceil(max(std_vec)) -0.06 0.1])
hold on;

scatter(portfolio_DbkDpwTkaCbk.Std, portfolio_DbkDpwTkaCbk.Mean, 'blue', 'filled')
hold on;

mean_dbkdbpw = dax_meanstd{{'DBK_DE', 'DPW_DE', 'TKA_DE', 'CBK_DE'},1};
std_dbkdpw = dax_meanstd{{'DBK_DE', 'DPW_DE', 'TKA_DE', 'CBK_DE'},2};

scatter(std_dbkdpw, mean_dbkdbpw, 50, 'green', 'filled')

%Interpretation: wünschenswerte Ergebnisse sind hohe erwartete Renditen bei
%                niedriger Streuung, also Werte links oben im Plotfenster









