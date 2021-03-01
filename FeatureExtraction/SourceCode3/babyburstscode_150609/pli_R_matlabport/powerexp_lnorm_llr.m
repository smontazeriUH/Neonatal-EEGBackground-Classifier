% Pointwise log-likelihood ratio between continuous power law with cutoff (powerexp) and
% log-normal distributions
% Input: Data vector, fitted Pareto distribution, fitted lognormal distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  Pareto's cut-off
% Requires: pareto.R
% Recommended: lnorm.R
function out=powerexp_lnorm_llr(x,powerexp_d,lnorm_d)

xmin = powerexp_d.xmin;
alpha = powerexp_d.exponent;
rate=powerexp_d.rate;
m = lnorm_d.meanlog;
s = lnorm_d.sdlog;
x = x(x>=xmin);
%out=dpowerexp(x,xmin,alpha,rate,1) - log(lognpdf(x,m,s)) + log(1-logncdf(xmin,m,s));
out=dpowerexp(x,xmin,alpha,rate,1) - log(lognpdf(x,m,s)) + log(logncdf_upper(xmin,m,s));

end