% Fit a discretized log-normal to data, assumed integer-valued, by simple-minded
% likelihood maximization
function out = fit_lnorm_disc(x, threshold)
% defaults: threshold=0

x_log = log(x);
theta_0 = [mean(x_log),std(x_log)];
% Chop off values below threshold
x = x(x>=threshold);
negloglike = @(theta) -lnorm_tail_disc_loglike(x,theta(1),theta(2),threshold);

[est minimum]= fminsearch(negloglike,theta_0);
fit.type='lnorm_disc';
fit.meanlog=est(1);
fit.sdlog=est(2);
fit.loglike=-minimum;
fit.threshold=threshold;
fit.datapoints_over_threshold = length(x);

out=fit;
end

function out = lnorm_tail_disc_loglike(x, meanlog, sdlog, threshold)
n = length(x);
JointProb = sum(dlnorm_disc(x,meanlog,sdlog,1));
ProbOverThreshold = log(1-logncdf(threshold-0.5,meanlog, sdlog));
out = JointProb - n*ProbOverThreshold;
end



