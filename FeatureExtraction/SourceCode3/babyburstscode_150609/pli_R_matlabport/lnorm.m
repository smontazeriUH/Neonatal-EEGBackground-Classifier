% Functions for estimation of lognormal distributions

% The use of a log-normal distribution to model values above a specified
% lower threshold can be done in one of two ways.  The first is simply to
% shift the standard log-normal, i.e, to say that x-threshold ~ lnorm.
% The other is to say that Pr(X|X>threshold) = lnorm(X|X>threshold), i.e.,
% that the right tail follows the same functional form as the right tail of a
% lognormal, without necessarily having the same probability of being in the
% tail.
% These will be called the "shift" and "tail" methods respectively.
% The shift method is, computationally, infinitely easier, but not so suitable
% for our purposes.

% The basic R system provides dlnorm (density), plnorm (cumulative
% distribution), qlnorm (quantiles) and rlnorm (random variate generation)

%%% Function for fitting:
% lnorm.fit		Fit log-normal to data, with choice of methods
%%% Back-stage functions not intended for users:
% lnorm.fit.max		Fit log-normal by maximizing likelihood ("tail")
% lnorm.fit.moments	Fit log-normal by moments of log-data ("shift")
% lnorm.loglike.tail	Tail-conditional log-likelihood of log-normal
% lnorm.loglike.shift	Log-likelihood of shifted log-normal
%%% Tail distribution functions (per R standards):
% dlnorm.tail		Tail-conditional probability density
% plnorm.tail		Tail-conditional cumulative probability


