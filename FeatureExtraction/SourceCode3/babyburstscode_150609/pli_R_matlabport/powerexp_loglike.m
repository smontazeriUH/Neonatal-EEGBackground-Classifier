% Calculate log-likelihood under power law with exponential cut-off
% Input: Data vector, lower threshold, scaling exponent, exponential rate
% Output: Real-valued log-likelihood
function out=powerexp_loglike(x,threshold,exponent,rate)
% defaults: threshold=1
x = x(x>=threshold);
L = sum(dpowerexp(x,threshold,exponent,rate,1));
out=L;
