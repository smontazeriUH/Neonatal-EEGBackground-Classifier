% Pointwise log-likelihood ratio between continuous power law (Pareto) and
% exponential distributions
% Input: Data vector, fitted Pareto distribution, fitted exponential
%	 distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  Pareto's cut-off
% Requires: pareto.R
% Recommended: exp.R
function out=pareto_exp_llr(x,pareto_d,exp_d)
	xmin = pareto_d.xmin;
	alpha = pareto_d.exponent;
	lambda = exp_d.rate;
	x = x(x>=xmin);
	out=dpareto(x,xmin,alpha,1) - log(exppdf(x,1/lambda)) + log(1-expcdf(xmin,1/lambda));
end

