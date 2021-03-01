% Pointwise log-likelihood ratio between discrete power law (zeta) and Yule
% distributions
% Input: Data vector, fitted zeta distribution, fitted Yule distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  zeta's cut-off
% Requires: zeta.R, yule.R
function out = zeta_yule_llr(x,zeta_d,yule_d) 

xmin = zeta_d.threshold;
alpha = zeta_d.exponent;
beta = yule_d.exponent;
x = x(x>=xmin);
out = dzeta(x,xmin,alpha,1) - dyule(x,beta,xmin,1);

end
