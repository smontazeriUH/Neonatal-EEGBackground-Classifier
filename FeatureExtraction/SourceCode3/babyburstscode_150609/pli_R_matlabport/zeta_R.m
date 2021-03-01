% Functions for the Zipf and generalized Zipf distribution, a.k.a. the
% zeta function distribution

% The distribution is defined by
% Pr(X = k) \propto k^-s
% for s >= q.  The constant of proportionality is the Hurwitz zeta
% function,
% zeta(s,q) = \sum_{k=q}^{\infty}{k^{-s}}
%           = \sum_{k=0}^{\infty}{(k+q)^{-s}}
% the latter being the form given by the Gnu Scientific Library (GSL).  The
% Riemann zeta function is the special case q = 1.

% The normalizing constant is evaluated by a (comparatively crude) call
% to the GSL, embodied in a stand-alone piece of C.  This must be compiled
% and put someplace R can execute it.  It can be found in a file called
% zeta-function.tgz, which should accompanying this code.
% To install it on a Unix system, first make sure GSL is installed.
%%% > tar xzf zeta-function.tgz
%%% > cd zeta-function
% At this point, you need to edit the file 'Makefile' to give the location of
% the GSL, which on my system is /sw/lib (for the library) and /sw/include
% (for the included files).  Then
%%% > make
%%% > mv zeta_func yourexecutablepath
% where 'yourexecutablepath' is a directory where you can put executable
% files.  Then edit the variable 'zeta_function_filename' in this file,
% below, to give the full path to the executable program zeta_func.
% This is not the world's slickest installation mechanism, no.


%%% Function for fitting to data:
% zeta.fit		Fit to tail of data, with choice of methods
%%% Distributional functions, per R standards:
% dzeta			Probability mass function
% pzeta			Cumulative probability function
%%% Backstage functions, not for users:
% zeta.fit.direct	Fit by numerical maximization of likelihood (default)
% zeta.fit.approx	Fit using Mark Newman's analytical approximation
% zeta.loglike		Calculate log-likelihood value
% zeta_func		Calculate zeta function for multiple thresholds
% zeta_func_once.gsl	Calculate zeta function for one point by an external
%			call to the GSL


% The location of the external program calculating the zeta function
% Used by zeta_function_once.gsl
%zeta_function_filename = './zeta_function'
%%% EDIT THIS LOCATION!!! %%%%

