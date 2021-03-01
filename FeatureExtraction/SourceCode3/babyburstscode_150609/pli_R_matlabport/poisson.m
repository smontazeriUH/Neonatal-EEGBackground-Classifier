% Poisson distribution for the right/uppper tail, and its estimation

% R by default provides dpois (probability mass function), ppois (cumulative
% probability function), qpois (quantile function) and rpois (random variate
% generation)

%%% Function for fitting:
% pois.tail.fit		Fit Poisson to tail of data by numerically maximizing
%			likelihood
%%% Distributional function, per R standard:
% dpois.tail		Probability mass function, conditional on being in tail
%%% Backstage function, not intended for users:
% pois.tail.loglike	Calcualte log-likelihood

