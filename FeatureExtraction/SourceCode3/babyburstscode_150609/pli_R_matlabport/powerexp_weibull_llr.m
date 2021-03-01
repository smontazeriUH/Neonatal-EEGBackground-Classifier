% Pointwise log-likelihood ratio between continuous power law with cutoff (powerexp) and
% Weibull distributions
% Input: Data vector, fitted Pareto distribution, fitted Weibull distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  Pareto's cut-off
% Requires: pareto.R
% Recommended: weibull.R
function out=powerexp_weibull_llr(x,powerexp_d,weibull_d)

xmin = powerexp_d.xmin;
alpha = powerexp_d.exponent;
rate=powerexp_d.rate;
shape = weibull_d.shape;
scale = weibull_d.scale;
x = x(x>=xmin);
%out=dpowerexp(x,xmin,alpha,rate,1) - log(wblpdf(x,scale,shape)) + log(1-wblcdf(xmin,scale,shape));
out=dpowerexp(x,xmin,alpha,rate,1) - log(wblpdf(x,scale,shape)) - (xmin./scale).^shape; % log(1-p), p as in wblcdf
end