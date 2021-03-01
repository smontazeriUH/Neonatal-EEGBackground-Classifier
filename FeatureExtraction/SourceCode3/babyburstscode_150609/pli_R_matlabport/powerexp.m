%%%%%%%%%% Functions for power law with exponential cut-off
% Let's call this "powerexp" for short.
% The parameterization is 
%%% f(x) \propto (x/threshold)^exponent exp(-rate*x)
% Really, functions should check that rate is positive, and that
% exponent is negative (otherwise it's just gamma distribution w/ threshold)
% This is not yet implemented

% The normalization constant must be obtained numerically; it is an upper
% incomplete gamma function of negative index.  Unfortuantely, R only includes
% code for upper incomplete gamma functions of _positive_ index.  Sometimes
% the normalizing constant can be expressed in terms of the latter; if so this
% code does so.  In all other cases, the normalizing constant can be expressed
% in terms of the exponential integral function.
% A separate C program invokes the Gnu Scientific Library (GSL) to calculate
% the exponential integral.  This program should be found in an accompanying
% file called exponential-integral.tgz.
% To install it on a Unix system, first make sure GSL is installed.
%%% > tar xzf exponential-integral.tgz
%%% > cd exponential-integral
% At this point, you need to edit the file "Makefile" to give the location of
% the GSL, which on my system is /sw/lib (for the library) and /sw/include
% (for the included files).  Then
%%% > make
%%% > mv exp_int yourexecutablepath
% where "yourexecutablepath" is a directory where you can put executable
% files.  Then edit the variable "exp_int_function_filename" in this file,
% below, to give the full path to the executable program exp_int.
% This is not the world's slickest installation mechanism, no.




%%% R-standard functions for a distribution:
% dpowerexp		Probability density
% ppowerexp		Cumulative distribution function
% qpowerexp		Quantile function
% rpowerexp		Random variate generation
%%% Estimation functions:
% powerexp.fit		Find scaling exponent and exponential rate by maximizing
%			likelihood
% test.powerexp.fit	Test the quality of the powerexp.fit routine
%			by generating data from a pure Pareto and comparing
%			the result log-likelihood ratio to the chi^2
%			distribution (to which it should asymptotically
%			converge) --- mostly included for debugging of the
%			normalizing constant and numerical optimization
%%% Backstage functions, not for users:
% powerexp.loglike	Calculcate log-likelihood, not intended for users
% test.powerexp.fit.1	Inner loop of test.powerexp.fit (one call)
% qpowerexponce		Find one upper quantile via numerical inversion
% uigf			Upper incomplete gamma function
% exp_int		Exponential integral function (vectorized); invokes
%                       either of the two following functions
% exp_int_once.gsl	Exponential integral of one value, calling Gnu
%			Scientific Library (crudely)
% exp_int_once.nr	Exponential integral of one value, re-implementing
%			a numerical recipe in R (not included in this public
%			release for copyright reasons)