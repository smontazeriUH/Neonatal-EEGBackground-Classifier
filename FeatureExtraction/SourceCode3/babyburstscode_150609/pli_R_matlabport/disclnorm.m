% Functions for definition and fitting of discretized log-normal distributions

% Assumes discretization-by-rounding, i.e. the probability that X=k is
% the probability that a continuous log-normal would lie between k-0.5 and
% k+0.5.

% The basic R system provides all the distributional functions for the
% continuous log-normal, which are used freely here.
% Cf. lnorm.R for 'tail-conditional' functions

%%% Function for fitting:
% fit.lnorm.disc		Fit discretized log-normal to data, using
%				numerical likelihood maximization
%%% Backstage function, not intended for users:
% lnorm.tail.disc.loglike	Calculate log-likelihood
%%% Distribution functions (per R standards):
% dlnorm.disc			Probability mass function
% dlnorm.tail.disc		Tail-conditional probability mass function
% plnorm.tail.disc		Tail-conditional cumulative probability function
