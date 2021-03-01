% Functions for estimation of a stretched exponential or Weibull distribution

% The use of a Weibull distribution to model values above a specified lower
% threshold can be done in one of two ways.  The first is simply to shift the
% the standard Weibull, i.e, to say that x-threshold ~ weibull.
% The other is to say that Pr(X|X>threshold) = weibull(X|X>threshold), i.e.,
% that the right tail follows the same functional form as the right tail of a
% Weibull, without necessarily having the same probability of being in the tail.
% These will be called the 'shift' and 'tail' methods respectively.
% The shift method is, computationally, infinitely easier, but not so suitable
% for our purposes.

% The basic R system provides dweibull (density), pweibull (cumulative
% distribution), qweibull (quantiles) and rweibull (random variate generation)

%%% Function for fitting:
% weibull.fit			Fit Weibull to data with choice of methods
%%% Distributional functions, per R standards:
% dweibull.tail			Tail-conditional probability density
% pweibull.tail			Tail-conditional cumulative distribution
%%% Backstage functions, not for users:
% weibull.fit.tail		Fit by maximizing tail-conditional likelihood
%				(default)
% weibull.fit.eqns		Fit by solving ML estimating equations for
%				shifted Weibull
% weibull.est.shape.inefficient Inefficient estimator of shape for shifted
%				Weibull, used to initialize fit.eqns
% weibull.est.scale.from.shape  MLE of scale given shape for shifted Weibull
% weibull.loglike.shift		Log-likelihood of shifted Weibull
% weibull.loglike.tail		Tail-conditional log-likelihood

