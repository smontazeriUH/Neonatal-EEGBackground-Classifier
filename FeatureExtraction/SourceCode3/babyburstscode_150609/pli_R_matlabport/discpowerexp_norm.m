% Calculate normalizing constant for discrete powerexp distribution
% Input: Lower cut-off, distributional parameters
% Output: Numerical value of normalizing constant
% Requires: compiled program 'discpowerexp' in appropriate location
% 	    see accompanying discpowerexp.c for this
function out = discpowerexp_norm(xmin,exponent,rate)
% R code used an external program written in C
% Three possibilities: compile the the code in Windows for use here,
% compile as a mex, or port the C to matlab

%discpowerexp.command = paste(discpowerexp.filename,exponent,rate,xmin)
%as.numeric(system(discpowerexp.command,intern=TRUE))

% % % % %    PORT OF discpowerexp.c    % % % % %
% /* Calculate the normalizing factor for the discrete power law with exponential
%    cut-off by direct summation */
% /* Pr(X=x) \propto x^-a exp(-l*x) */
% /* The constant of proportionality is thus the sum of x^-a exp(-l*x) from
%    xmin to infinity */
% /* This program approximates it very simply by summing from xmin to
%    something very large */
% /* The analogous procedure for the pure power law is not very efficient (cf.
%    zeta_func.c, and the code it calls from the Gnu Scientific Library), but my
%    hope is that the exponential factor will make the sum converge more rapidly
%    and so fancier math will not be necessary */
% /* Only intended to be used with R; not the most elegant integration but it
%    may do for now */
%
% /* Three arguments, the scaling exponent, the exponential rate, and the
%    lower limit of summation */

num_terms=1000000;

%if exponent<=-1, error('need exponent > -1') ,end
%if rate<=0, error('need rate > 0'), end
%if xmin<1, error('need xmin > 1'), end

%norm = 0.0;

% for x=xmin:xmin+num_terms-1;
%     norm = norm + (x.^-exponent .* exp(-x*rate));
% end

x=xmin:xmin+num_terms-1;
norm=sum((x.^-exponent .* exp(-x*rate)));

out=norm;

end



