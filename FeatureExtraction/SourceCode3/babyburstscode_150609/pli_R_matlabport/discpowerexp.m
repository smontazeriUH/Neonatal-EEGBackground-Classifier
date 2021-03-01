%%% Discrete power-law distribution with exponential cut-off
% Revision history at end of file

% The normalizing constant of this distribution can only be obtained
% numerically.  A separate C program, contained in the file discpowerexp.C,
% which should accompany this code, does so.  This must be compiled, and the
% executable put someplace where R can run it.
% To install on a Unix system, proceed as follows:
%%% > gcc discpowerexp.c -O -o discpowerexp -lm
%%% > mv discpowerexp yourexecutablepath
% where 'yourexecutablepath' is a directory where you can put executable files.
% Then edit the variable 'discpowerexp.filename', below, to give the full
% path to discpowerexp.
% This is not the world's slickest installation mechanism, no.

%%% Function for fitting to data:
% discpowerexp.fit	Fit discrete power law with exponential cut-off to
%			right/upper tail of data (by maximum likelihood)
%%% Distributional functions, per R standards:
% ddiscpowerexp		Probability mass function
%%% Backstage functions, not intended for users:
% discpowerexp.loglike	Calculate log-likelihood
% discpowerexp.norm	Calculate normalizing constant, by invoking outside
%			routine
% discpowerexp.base	Calculate un-normalized probability mass function
% discpowerexp.log	Calculate log of un-normalized probability mass function


% Location of the external program calculating the normalizing constant
%%% EDIT THE FILE LOCATION TO GIVE CORRECT PATH ON YOUR SYSTEM!
% invoked by discpowerexp.norm, below
%discpowerexp.filename = './discpowerexp'



% Revision history:
% v 0.0		2007-06-04	First release
% v 0.0.1	2007-06-29	Fixed compilation instructions to invoke math
%				library explicitly
% v 0.0.2	2007-07-25	Fixed changing EVERY instance of a variable's
%				name in loglike function, thanks to Alejandro
%				Balbin for the bug report