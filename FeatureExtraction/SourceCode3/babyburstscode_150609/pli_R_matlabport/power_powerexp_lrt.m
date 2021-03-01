% Test power law distribution vs. a power law with an exponential cut-off
% This is meaningful ONLY if BOTH distributions are continuous or discrete,
% and, of course, both were estimated on the SAME data set, with the SAME
% cut-off
% TODO: Check whether the distributions are comparable!
% Input: fitted power law distribution, fitted powerexp distribution
% Output: List giving log likelihood ratio and chi-squared p-value
% Recommended: pareto.R, powerexp.R, zeta.R, discpowerexp.R
function out=power_powerexp_lrt(power_d,powerexp_d) 
  lr = (power_d.loglike - powerexp_d.loglike);
  %p = pchisq(-2*lr,df=1,lower.tail=FALSE)
  p=1-chi2cdf(-2*lr,1);
  out.log_like_ratio = lr;
  out.p_value = p;
end
