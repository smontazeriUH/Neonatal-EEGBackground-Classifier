% Pointwise log-likelihood ratio between discrete power law (zeta) and discrete
% exponential distributions
% Input: Data vector, fitted zeta distribution, fitted discrete exponential
%	 distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  zeta's cut-off
% Requires: zeta.R, exp.R
function out=zeta_exp_llr(x,zeta_d,exp_d)

xmin = zeta_d.threshold;
alpha = zeta_d.exponent;
lambda = exp_d.lambda;
x = x(x>=xmin);
out=dzeta(x,xmin,alpha,1) - ddiscexp(x,lambda,xmin,1);

end

