% Functions for definition and fitting of discrete Weibull distributions

% There are several functions which all claim to be the "discrete Weibull"
% distribution, this code uses the Nakagawa-Osaki discretization, see
% http://ljk.imag.fr/membres/Olivier.Gaudoin/ICRSA03Gaudoin.pdf for
% lists of others

% Uses functions embedded in weibull.R, as well as R's built-in functions
% for the Weibull distribution --- run
%%% source("weibull.R")
% first --- you may need to modify the path to make sure R can find the right
% file!

%%% Function for fitting:
% discweib.fit		Fit discrete Weibull to tail of data via numerical
%			likelihood maximization
%%% Distributional functions, per R standards:
% ddiscweib		Probability mass function
% pdiscweib		Cumulative probability function
%%% Backstage function, not intended for users:
% discweib.loglike	Calculate log-likelihood

