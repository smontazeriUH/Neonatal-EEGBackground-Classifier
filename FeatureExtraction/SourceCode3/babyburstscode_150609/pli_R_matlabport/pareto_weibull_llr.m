% Pointwise log-likelihood ratio between continuous power law (Pareto) and
% stretched exponential (Weibull) distributions
% Input: Data vector, fitted Pareto distribution, fitted Weibull distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  Pareto's cut-off
% Requires: pareto.R
% Recommended: weibull.R
function out = pareto_weibull_llr(x,pareto_d,weibull_d) 

xmin = pareto_d.xmin;
alpha = pareto_d.exponent;
shape = weibull_d.shape;
scale = weibull_d.scale;
x = x(x>=xmin);
%out = dpareto(x,xmin,alpha,1) - log(wblpdf(x,scale,shape)) + log(1-wblcdf(xmin,scale,shape));
out = dpareto(x,xmin,alpha,1) - log(wblpdf(x,scale,shape)) -(xmin./scale).^shape; % log(1-p), p as in wblcdf
end

