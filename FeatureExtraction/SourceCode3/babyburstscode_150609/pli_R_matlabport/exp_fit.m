% Functions for estimation of an exponential distribution

% The use of an exponential to model values above a specified
% lower threshold can be done in one of two ways.  The first is simply to
% shift the standard exponential, i.e, to say that x-threshold ~ exp.
% The other is to say that Pr(X|X>threshold) = exp(X|X>threshold), i.e.,
% that the right tail follows the same functional form as the right tail of an
% exponential, without necessarily having the same probability of being in the
% tail.
% These will be called the 'shift' and 'tail' methods respectively.
% The shift method is, computationally, infinitely easier, but not so suitable
% for our purposes.

% The basic R system provides dexp (density), pexp (cumulative distribution),
% qexp (quantiles) and rexp (random variate generation)

%%% Functions for fitting:
% exp.fit		Fit exponential to data via likelihood maximization,
%			with choice of methods
%%% Backstage functions, not intended for users:
% exp.fit.tail		Fit exponential via 'tail' method (default)
% exp.fit.moment	Fit exponential via 'shift' method, starting with
%                       appropriate moments
% exp.loglike.shift	Calculate log likelihood of shifted exponential
% exp.loglike.tail	Calculate log likelihood of tail-conditional exponential

% Fit exponential distribution to data
% A wrapper for actual methods, defaulting to the 'tail' method
function out=exp_fit(x,threshold,method)
% defaults: threshold=0, method='tail'
if nargin<3, method='tail'; end

switch method
    case 'tail'
        fit = exp_fit_tail(x,threshold);
    case 'shift'
        fit = exp_fit_shift(x,threshold);
    otherwise
        fprintf(1,'Unknown method in exp.fit\n');
        fit = NaN;
end
out=fit;
end

function out=exp_fit_tail(x,threshold)
% defaults: threshold=0

% Start with a global estimate of the parameter
expfitmoment=exp_fit_moment(x,threshold,'tail');
lambda_0 = expfitmoment.rate;
x = x(x>=threshold);
% The function just called ignores values of method other than 'shift'
% but let's not take chances!
negloglike = @(lambda)  -exp_loglike_tail(x,lambda,threshold);
%fit =nlm(negloglike,lambda_0);
% matlab version
[lambda value]=fminsearch(negloglike,lambda_0);
fit.type='exp';
fit.rate=lambda;
fit.loglike=-value;
fit.xmin=threshold;
fit.datapoints_over_threshold=length(x);
out=fit;
end

function out=exp_fit_moment(x, threshold, method)
% defaults: threshold=0, method='shift'

x = x(x>=threshold);
if strcmp(method,'shift')
    x = x-threshold;
end
lambda = 1/mean(x);
loglike = exp_loglike_shift(x, lambda, threshold);
fit.type='exp';
fit.rate=lambda;
fit.loglike=loglike;
fit.datapoints_over_threshold=length(x);
out=fit;
end

function out=exp_loglike_shift(x, lambda, threshold)
% defaults: threshold=0
if nargin<3, threshold=0; end

% Assumes (X-threshold) is exponentially distributed
% See Johnson and Kotz, ch. 18 for more on this form of the distribution
x = x(x>=threshold);
x = x-threshold;
%out=sum(log(exppdf(x,1/lambda))); % note 1/lambda not lambda
out=sum(-x*lambda)+sum(x>0)*log(lambda); % alt version of above
end


function out=exp_loglike_tail(x, lambda, threshold)
% defaults: threshold=0

% We want p(X=x|X>=threshold) = p(X=x)/Pr(X>=threshold)
x = x(x>=threshold);
n = length(x);
Like = exp_loglike_shift(x,lambda);
%ThresholdProb = log(1-expcdf(threshold, 1/lambda)); % note 1/lambda not lambda
ThresholdProb = -threshold*lambda; % simplification of above
out=Like - n*ThresholdProb;
end
