% Pointwise log-likelihood ratio between discrete power law (zeta) and discrete
% log-normal distributions
% Input: Data vector, fitted zeta distribution, fitted discrete log-nromal
%	 distribution
% Output: Vector of pointwise log-likelihood ratios, ignoring points below the
% 	  zeta's cut-off
% Requires: zeta.R, disclnorm.R
function out = zeta_lnorm_llr(x,zeta_d,lnorm_d) 

xmin = zeta_d.threshold;
alpha = zeta_d.exponent;
meanlog = lnorm_d.meanlog;
sdlog = lnorm_d.sdlog;
x = x(x>=xmin);
out = dzeta(x,xmin,alpha,1) - dlnorm_tail_disc(x,meanlog,sdlog,xmin,1);

end

