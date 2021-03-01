% Pointwise log-likelihood ratio between continuous power law (Pareto) and
% log-normal distributions
% Input: Data vector, fitted Pareto distribution, fitted lognormal distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  Pareto's cut-off
% Requires: pareto.R
% Recommended: lnorm.R
function out=pareto_lnorm_llr(x,pareto_d,lnorm_d)

xmin = pareto_d.xmin;
alpha = pareto_d.exponent;
m = lnorm_d.meanlog;
s = lnorm_d.sdlog;
x = x(x>=xmin);
%out=dpareto(x,xmin,alpha,1) - log(lognpdf(x,m,s)) + log(1-logncdf(xmin,m,s));
out=dpareto(x,xmin,alpha,1) - log(lognpdf(x,m,s)) + log(logncdf_upper(xmin,m,s));

end

