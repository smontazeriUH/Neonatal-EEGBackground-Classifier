% Fit Poisson distribution to right/upper tail of data, by numerically
% maximizing log likelihood
% Input: Data vector, lower cut-off
% Output: List giving distribution type, estimated rate, information about
%	  fit and data
function out = pois_tail_fit(x, threshold)
% default: threshold=0

% Do a simple moment-based fit first on the whole data as a pump-primer
rate_0 = mean(x);
% discard data points below threshold
x = x(x>=threshold);
rate_1 = mean(x);
n = length(x);
negloglike = @(rate) -pois_tail_loglike(x, rate, threshold);
[rate,value] = fminsearch(negloglike, rate_0);

fit.type='pois_tail';
fit.rate=rate;
fit.threshold=threshold;
fit.loglike=-value;
fit.samples_over_threshold=n;
fit.full_mean=rate_0;
fit.mean_over_threshold=rate_1;

out=fit;
end

% Calculate tail-conditional log likelihood
% Input: Data vector, Poisson rate, lower cut-off
% Output: Log likelihood
function out = pois_tail_loglike(x, rate, threshold)
% defaults: threshold=0
n = length(x);
JointProb = sum(log(poisspdf(x,rate)));
ProbOverThreshold = log(1-poisscdf(threshold-1,rate));
out = JointProb - n*ProbOverThreshold;
end