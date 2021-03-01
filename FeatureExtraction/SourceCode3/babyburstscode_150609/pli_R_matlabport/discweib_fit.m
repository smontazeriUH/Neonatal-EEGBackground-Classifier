% Fit discrete Weibull distributional, conditional on being in the right/upper
% tail, by numerically maximizing the likelihood
% Input: Data vector, lower threshold
% Output: List giving distribution type ("discweib"), estimate parameters,
%	  information on fit and data set
% Requires: weibull.R (to get starting point for optimization)
function out = discweib_fit(x,threshold) 
% default: threshold=0
  % Start off with a rough-and-ready estimator for continuous data
  theta_0 = weibull_est_shape_inefficient(x);
  % Trim the data set
  x = x(x>=threshold);
  n = length(x);
  % define the likelihood
  negloglike = @(theta) -discweib_loglike(x,theta(1),theta(2),threshold);
  
  % optimize
  %est = nlm(f=negloglike,p=theta_0)
  % matlab version
  [theta,value]=fminsearch(negloglike,theta_0);
  fit.type='discweib';
  fit.shape=theta(1);
  fit.scale=theta(2);
  fit.loglike = -value;
  fit.threshold=threshold;
  fit.samples_over_threshold=n;
  out=fit;
end


% Calculate log likelihood of discrete Weibull, conditional on being in the
% right/upper tail
% Input: Data vector, distributional parameters, lower cut-off
% Output: Log likelihood
function out = discweib_loglike(x,shape,scale,threshold)
% default: threshold=0
out = sum(ddiscweib(x,shape,scale,threshold,1));
end

% below are taken from weibull_fit.m

% Inefficient estimator of the shape parameter of a Weibull, plus scale
% Based on the moments of log of the data
% Input: Data vector, lower threshold
% Output: Real-valued estimates of shape and scale
function out = weibull_est_shape_inefficient(x,threshold)
% defaults: threshold=0
if nargin<2, threshold=0; end
% The follow is not an efficient estimator of the shape, but serves to start
% the approximation process off.  (See Johnson and Katz, ch. 20, section 6.3,
% 'Estimators Based on Distribution of log X'.)
x = x-threshold;
shape = (sqrt(6)/pi)*std(log(x));
scale = weibull_est_scale_from_shape(x,shape);
out=[shape,scale];
end

% Maximum likelihood estimate of a Weibull scale parameter, given shape
% Input: Data vector, shape parameter
% Output: Real-valued scale parameter
function out = weibull_est_scale_from_shape(x,shape)
% Given a value of the shape parameter, return the corresponding
% MLE of the scale parameter
n = length(x);
scale = ((1/n)*sum(x.^shape))^(1/shape);
out=scale;
end


