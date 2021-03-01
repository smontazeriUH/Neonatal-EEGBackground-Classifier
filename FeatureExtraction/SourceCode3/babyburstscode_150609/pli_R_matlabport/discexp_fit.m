% Fit discrete exponential to tail of data via numerical likelihood
% maximization
% Input: Data vector, lower cut-off
% Output: List giving fitted parameter values and information on data and
%         fitting process
function out = discexp_fit(x,threshold)
% defaults: threshold=0

x = x(x>=threshold);
n = length(x);
lambda = log(1+n/sum(x-threshold));	% Moment-based estimate to start the optimization off
loglike = discexp_loglike(x,lambda,threshold);
fit.type='discexp';
fit.lambda=lambda;
fit.loglike=loglike;
fit.threshold=threshold;
fit.method='formula';
fit.samples_over_threshold=n;

out = fit;
end

% Log likelihood of tail-conditional discrete exponential
% Input: Data vector, distributional parameters
% Output: Log likelihood
function out = discexp_loglike(x, lambda, threshold)
% defaults: threshold=0
out = sum(ddiscexp(x,lambda,threshold,1));
end