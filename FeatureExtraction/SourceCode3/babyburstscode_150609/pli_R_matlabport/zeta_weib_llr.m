% Pointwise log-likelihood ratio between discrete power law (zeta) and discrete
% stretched exponential (Weibull) distributions
% Input: Data vector, fitted zeta distribution, fitted discrete Weibull
%	 distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  zeta's cut-off
% Requires: zeta.R, discweib.R
function out = zeta_weib_llr(x,zeta_d,weib_d)

xmin = zeta_d.threshold;
alpha = zeta_d.exponent;
shape = weib_d.shape;
scale = weib_d.scale;
x = x(x>=xmin);
out = dzeta(x,xmin,alpha,1) - ddiscweib(x,shape,scale,xmin,1);

end
