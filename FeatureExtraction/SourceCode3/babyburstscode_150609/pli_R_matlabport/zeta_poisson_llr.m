% Pointwise log-likelihood ratio between discrete power law (zeta) and Poisson
% distributions
% Input: Data vector, fitted zeta distribution, fitted Poisson distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  zeta's cut-off
% Requires: zeta.R, poisson.R
function out=zeta_poisson_llr(x,zeta_d,pois_d) 

xmin = zeta_d.threshold;
alpha = zeta_d.exponent;
rate = pois_d.rate;
x = x(x>=xmin);
out = dzeta(x,xmin,alpha,1) - dpois_tail(x,xmin,rate,log);

end

