% Calculate log-likelihood under a Pareto distribution
% Input: Data vector, lower threshold, scaling exponent
% Output: Real-valued log-likelihood
function out=pareto_loglike(x, threshold, exponent)
  L = sum(dpareto(x, threshold, exponent, 1));
  
  out=L;