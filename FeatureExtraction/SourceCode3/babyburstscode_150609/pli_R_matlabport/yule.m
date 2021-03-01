% Functions for the Yule distribution, conditional on  being in the right/upper
% tail, and estimation from data

% Requires zeta.R

%%% Function for fitting to right/upper tail of tail:
% yule_fit		Fit Yule to tail of data by numerical likelihood
%			maximization
%%% Distributional functions, per R standards:
% dyule			Probability mass function
% pyule			Cumulative probability function
%%% Backstage function, not intended for users:
% yule_loglike		Calculate log likelihood

