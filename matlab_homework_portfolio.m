% Solution to part 2, exercise 3

dateBeg = '01012000';
dateEnd = '01012015';
tickerSymbs = {'ADS.DE', 'ALV.DE', 'BAS.DE', 'BAYN.DE'...
   'BEI.DE', 'BMW.DE', 'CBK.DE', 'CON.DE', 'DAI.DE', 'DB1.DE' ...
   'DBK.DE', 'DPW.DE', 'DTE.DE', 'EOAN.DE', 'FME.DE', 'FRE.DE'...
   'HEI.DE', 'HEN3.DE', 'IFX.DE', 'LHA.DE', 'LIN.DE', 'LXS.DE'...
   'MRK.DE', 'MUV2.DE', 'RWE.DE', 'SAP.DE', 'SDF.DE', 'SIE.DE'...
   'TKA.DE', 'VOW3.DE'};

%%
dax_prices = getPrices(dateBeg, dateEnd, tickerSymbs);
dax_prices(1:10,1:5)

dax_ret = price2discreteretWithHolidays(dax_prices);
dax_ret(1:10,1:5)

dax_notintable = dax_ret{:,1};
nans = isnan(dax_notintable);
dax_notintable(nans) = [];
mean(dax_notintable);
std(dax_notintable);

%%
dax_meanstd = calculateMeanAndStd(dax_ret);
dax_meanstd(:,1:5)