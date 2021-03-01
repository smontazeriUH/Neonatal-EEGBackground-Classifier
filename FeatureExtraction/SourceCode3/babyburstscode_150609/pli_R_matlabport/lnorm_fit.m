% Fit log-normal to data over threshold
% Wrapper for the shift (log-moment) or tail-conditional (maximizer) functions
% Input: Data vector, lower threshold, method flag
% Output: List giving distribution type ('lnorm'), parameters, log-likelihood
function out = lnorm_fit(x,threshold,method)
% defaults: threshold=0, method='tail'
if nargin<3, method='tail'; end
switch method
    case 'tail'
        if (threshold>0)
            fit = lnorm_fit_max(x,threshold) ;
        else
            fit = lnorm_fit_moments(x) ;
        end
    case 'shift'
        fit = lnorm_fit_moments(x,threshold);
    otherwise
        fprintf(1,'Unknown method\n');
        fit = NaN;
end
out=fit;
end

% Fit log-normal by direct maximization of tail-conditional log-likelihood
% Note that direct maximization of the shifted lnorm IS lnorm.fit.moments, so
% that should be used instead for numerical-accuracy reasons
% Input: Data vector, lower threshold
% Output: List giving distribution type ('lnorm'), parameters, log-likelihood
function out = lnorm_fit_max(x, threshold)
% defaults: threshold=0

% Use moment-based estimator on whole data as starting point
initial_fit = lnorm_fit_moments(x);
theta_0 = [initial_fit.meanlog,initial_fit.sdlog];
x = x(x>=threshold);
negloglike = @(theta) -lnorm_loglike_tail(x,theta(1),theta(2),threshold);
opts=optimset('MaxFunEvals',1000,'MaxIter',1000);
[est,minimum]= fminsearch(negloglike,theta_0,opts);
fit.type='lnorm';
fit.meanlog=est(1);
fit.sdlog=est(2);
fit.datapoints_over_threshold = length(x);
fit.loglike=-minimum;

out=fit;
end

% Fit log-normal via moments of the log data
% This is the maximum likelihood solution for the shifted lnorm
% Input: Data vector, lower threshold
% Output: List giving distribution type ('lnorm'), parameters, log-likelihood
function out = lnorm_fit_moments(x, threshold)
% defaults: threshold=0
if nargin<2, threshold=0; end

x = x(x>=threshold);
x = x-threshold;
LogData = log(x);
M = mean(LogData);
SD = std(LogData);
Lambda = lnorm_loglike_shift(x,M,SD,threshold);
fit.type='lnorm';
fit.meanlog=M;
fit.sdlog=SD;
fit.loglike=Lambda;

out=fit;
end

% Tail-conditional log-likelihood of log-normal
% Input: Data vector, distributional parameters, lower threshold
% Output: Real-valued log-likelihood
function out = lnorm_loglike_tail(x, mlog, sdlog, threshold)
% defaults: threshold=0

% Compute log likelihood of data under assumption that the generating
% distribution is a log-normal with the given parameters, and that we
% are only looking at the tail values, x >= threshold
% We want p(X=x|X>=threshold) = p(X=x)/Pr(X>=threshold)
x = x(x>= threshold);
n = length(x);
Like = lnorm_loglike_shift(x,mlog, sdlog);
%ThresholdProb = log(1-logncdf(threshold, mlog, sdlog)); % orig
ThresholdProb = log(logncdf_upper(threshold,mlog,sdlog));
L = Like - n*ThresholdProb;

out=L;
end

% Loglikelihood of shifted log-normal
% Input: Data vector, distributional parameters, lower threshold
% Output: Real-valued log-likelihood
function out = lnorm_loglike_shift(x, mlog, sdlog, x0)
% defaults: x0=0
if nargin<4, x0=0; end
% Compute log likelihood under assumption that x-x0 is lognromally
% distributed
% This (see Johnson and Kotz) the usual way of combining a lognormal
% distribution with a hard minimum value.  (They call the lower value theta)
x = x(x>=x0);
x = x-x0;
L = sum(log(lognpdf(x,mlog,sdlog)));

out = L;
end


