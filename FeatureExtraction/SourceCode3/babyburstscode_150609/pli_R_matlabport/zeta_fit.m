% Fit data (assumed discrete) to a discrete power law via maximum likelihood
% Wrapper for two subsidiary methods, direct optimization, and applying
% an approximate formula due to M. E. J. Newman
% Input: Data vector, lower cut-off, method flag
% Output: List giving distribution type, estimated parameter, information
%	  on fitting and data
function out=zeta_fit(x, threshold, method)
% defaults: threshold=1, method='ml_direct'
if nargin<3, method='ml_direct'; end

x = x(x>=threshold);
n = length(x);
switch method
    case 'ml_direct'
        alpha = zeta_fit_direct(x,threshold);
    case 'ml_approx'
        alpha = zeta_fit_approx(x,threshold);
    otherwise
        error(['Unknown method in zeta_fit ' method '\n']);
end

loglike = zeta_loglike(x,threshold,alpha);
fit.type='zeta';
fit.threshold=threshold;
fit.exponent=alpha;
fit.loglike=loglike;
fit.samples_over_threshold=n;
fit.method=method;

out=fit;
end

% Fit data (assumed discrete) to a discrete power law via numerical optimization
% of the likelihood
% 'Primes' the optimization by using the approximate formula
% This function should not be called directly by users, but indirectly via
% zeta.fit, which will do pre-processing and sanity-checking
% Input: Data vector, lower cut-off
% Output: Estimated scaling exponent
function out = zeta_fit_direct(x, threshold)
% Use approximate method to start optimization
alpha_0 = zeta_fit_approx(x,threshold);
negloglike = @(alpha) -zeta_loglike(x,threshold,alpha);
est = fminsearch(negloglike,alpha_0);
% Extract and return the parameter
out=est;
end

% Fit data (assumed discrete) to a discret power law via Mark Newman's
% approximate formula
% Slightly duplicates code in pareto.R --- commented-out line in fact directly
% calls pareto.R
% The approximation appears to work quite well when threshold >= 20, and can
% even be reasonable when >= 3.
% This function should not be called directly by users, but indirectly via
% zeta.fit, which will do pre-processing and sanity-checking
% Input: Data vector, lower cut-off
% Output: Estimated scaling exponent
function out = zeta_fit_approx(x,threshold)
%effective_threshold = threshold - 0.5;
% alpha = pareto.fit(x,effective.threshold,method='ml')$exponent
n = length(x);
sum_of_logs = sum(log(x));
xmin_factor = n*log(threshold-0.5);
alpha = 1 + n/(sum_of_logs - xmin_factor);
out=alpha;
end


