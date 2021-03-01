% Log likelihood of discrete powerexp, conditional on being in the right/upper
% tail
% Ignores data-points below cut-off
% Input: Data vector, distributional parameters, lower cut-off
% Output: Log likelihood
function out = discpowerexp_loglike(x,exponent,rate,threshold)
% defaults: threshold=1

discpowerexp_log = @(x,exponent,rate) -exponent*log(x)-x*rate;

x = x(x>=threshold);
n = length(x);
JointProb = sum(discpowerexp_log(x,exponent,rate));
ProbOverThreshold = log(discpowerexp_norm(threshold,exponent,rate));
L = JointProb - n*ProbOverThreshold;
out =L;
end

