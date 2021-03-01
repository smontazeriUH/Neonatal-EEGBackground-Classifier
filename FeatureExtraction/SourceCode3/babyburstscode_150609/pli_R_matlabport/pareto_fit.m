% Estimate scaling exponent of Pareto distribution
% A wrapper for functions implementing actual methods
% Input: data vector, lower threshold, method (likelihood or regression,
%        defaulting to former)
% Output: List indicating type of distribution ('exponent'), parameters,
%         information about fit (depending on method), OR a warning and NA
%         if method is not recognized
function out=pareto_fit(data, threshold, method)
% defaults: method='ml'
if nargin<3
    method='ml';
end

switch method
    case 'ml'
        out=pareto_fit_ml(data,threshold);
    case 'regression_cdf'
        out=pareto_fit_regression_cdf(data,threshold);
    otherwise
        fprintf(1,'Unknown method\n');
        out=NaN;
end
end

% Estimate scaling exponent of Pareto distribution by maximum likelihood
% Input: Data vector, lower threshold
% Output: List giving distribution type ('pareto'), parameters, log-likelihood
function out=pareto_fit_ml(data, threshold)
data = data(data>=threshold);
n = length(data);
x = data/threshold;
alpha = 1 + n/sum(log(x));
loglike = pareto_loglike(data,threshold,alpha);
fit.type='pareto';
fit.exponent=alpha;
fit.xmin=threshold;
fit.loglike = loglike;
out=fit;
end

