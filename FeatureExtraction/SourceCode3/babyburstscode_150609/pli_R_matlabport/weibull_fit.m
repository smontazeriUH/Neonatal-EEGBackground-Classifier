% Fit Weibull to data
% Wrapper for functions implementing different ML methods
% Input: Data vector, lower threshold, method flag
% Output: List giving distribution type ('weibull'), parameters, log-likelihood
function out=weibull_fit(x, threshold, method)
% defaults: threshold=0, method='tail'
if nargin<3, method='tail'; end
x = x(x>=threshold);
switch method
    case 'tail'
        % Estimate parameters by direct maxmization of the tail-conditional
        % log-likelihood
        fit = weibull_fit_tail(x,threshold);
    case 'eqns'
        % Estimate parameters by solving the ML estimating equations of a shifted
        % Weibull
        fit = weibull_fit_eqns(x,threshold);
    otherwise
        fprintf(1,'Unknown method\n');
        fit = NaN;
end
out=fit;

end


% Fit Weibull to data by maximizing tail-conditional likelihood
% CONSTRAINTS: The shape and scale parameters must both be positive
% This will not necessarily give a _stretched_ exponential which would be
% a shape < 1
% Input: Data vector, lower threshold
% Output: List giving distribution type ('weibull'), parameters, log-likelihood
function out = weibull_fit_tail(x,threshold)
% defaults: threshold=0
% Use the whole data to produce initial estimates, via the estimating equation
initial_fit = weibull_fit_eqns(x);
theta_0 = [initial_fit.shape, initial_fit.scale];
% Apply constraints: if we're outside the feasible set, default to a
% standardized exponential
if (theta_0(1) < 0), theta_0(1) = 1; end
if (theta_0(2) < 0), theta_0(2) = 1; end
% Now threshold and directly minimize the negative log likelihood
x = x(x>= threshold);
n = length(x);

negloglike = @(theta) -weibull_loglike_tail(x,theta(1),theta(2),threshold);
% matlab version
%
% fminsearch performs unconstrained optimization, but would need
% the Optimization Toolbox to use fmincon
%
% instead, try to impose constraints with a numerical penalty
penalty=@(x) 100000*(x<0);
negloglikewithpenalty=@(theta) negloglike(theta)+penalty(theta(1))+penalty(theta(2));
% diagnostic for plotting
%yy=@(logshape,logscale) -weibull_loglike_tail(x,exp(logshape),exp(logscale),threshold);
%figure, ezsurf(yy,[-10 10 -200 200],400), shading flat
opts=optimset('MaxFunEvals',4000,'MaxIter',2000);
[est.par,est.value]=fminsearch(negloglikewithpenalty,theta_0,opts);
shape = est.par(1);
scale = est.par(2);
% consider fitting in the log-parameter space
%negloglike_logpar = @(logtheta) negloglike(exp(logtheta));
%[est.par,est.value]=fminsearch(negloglike_logpar,log(theta_0),opts);
%shape=exp(est.par(1)); scale=exp(est.par(2));
loglike = -est.value;
if shape<0 || scale<0
    error('converged to point outside range. shape=%g scale=%g',shape,scale)
end
%ui = rbind(c(1,0),c(0,1))
%ci = c(0,0)
%est = constrOptim(theta=theta_0, f=negloglike, grad=NULL, ui=ui, ci=ci)
fit.type='weibull';
fit.shape=shape;
fit.scale=scale;
fit.loglike=loglike;
fit.samples_over_threshold=n;

out=fit;
end

% Fit shifted Weibull to data by solving ML estimating equations
% Input: Data vector, lower threshold
% Output: List giving distribution type ('weibull'), parameters, log-likelihood
function out = weibull_fit_eqns(x, threshold)
% defaults: threshold=0
if nargin<2, threshold=0; end
% ML estimating equations of the shape and scale of the Weibull distribution,
% taken from Johnson and Kotz, ch. 20
% This assumes that x-threshold is Weibull-distributed
x = x(x>threshold); % was >=
x = x-threshold;
x_log = log(x); % This will be needed repeatedly
n=length(x); % So will this
h = sum(x_log)/n; % And this
scale_from_shape = @(shape) weibull_est_scale_from_shape(x,shape);
% Note that the estimation of the shape parameter is only implicit,
% through a transcendental equation.
initial_estimates = weibull_est_shape_inefficient(x);
shape = initial_estimates(1);
%scale = initial_estimates(2); % unused?!
map = @(c) (sum((x.^c) .* x_log)/sum(x.^c) - h).^(-1);
estimating_equation = @(c)  (c - map(c)).^2 + (c<0)*1e7;  % added a penalty to prevent occasional bad cgce
[shape,~]=fminsearch(estimating_equation,shape);
scale = scale_from_shape(shape);
loglike = weibull_loglike_shift(x,shape,scale,threshold);
fit.type='weibull';
fit.shape=shape;
fit.scale=scale;
fit.loglike=loglike;
fit.samples_over_threshold=n;

out=fit;
end

% Log-likelihood of shifted Weibull distribution
% Input: Data vector, parameters, lower threshold
% Output: real-valued log-likelihood
function out = weibull_loglike_shift(x, shape, scale, threshold)
% defaults: threshold=0
if nargin<4, threshold=0; end
% Assumes x - threshold is Weibull-distributed
% See Johnson and Kotz for more; they call the lower threshold xi_0
x = x(x>=threshold);
x = x-threshold;
%L = sum(log(wblpdf(x,scale,shape)));
L = sum((shape-1).*log(x/scale) - (x/scale).^shape + log(shape/scale));
out=L;
end

% Tail-conditional log-likelihood
% Input: Data vector, parameters, lower threshold
% Output: Real-valued log-likelihood
function out = weibull_loglike_tail(x, shape, scale, threshold)
% defaults: threshold=0
% We want p(X=x|X>=threshold) = p(X=x)/Pr(X>=threshold)
x = x(x>=threshold);
n = length(x);
Like = weibull_loglike_shift(x,shape,scale);
%ThresholdProb = log(1-wblcdf(threshold,scale,shape));
ThresholdProb = -(threshold./scale).^shape; % log(1-p), p as in wblcdf
L = Like - n*ThresholdProb;
out=L;
end

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
