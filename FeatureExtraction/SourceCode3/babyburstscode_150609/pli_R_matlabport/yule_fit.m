% Fit Yule distribution by maximum likelihood
% Numerical minimization of the negative log-likelihood function, using the
% estimator of the zeta distribution to get an initial value for the parameter
% Input: Data vector, lower threshold
% Output: List giving the distribution type ("Yule"), the parameter, and some
%         information about the fit
% Requires: zeta_R
function out = yule_fit(x,xmin)
x = x(x>=xmin);
n = length(x);
negloglike = @(a)  -yule_loglike(x,a,xmin);
% Invoke zeta estimator, in simplified discrete form, to get an initial
% value
initialfit = zeta_fit(x,xmin,'ml_approx');
a0=initialfit.exponent;
[exponent,value] = fminsearch(negloglike,a0);
fit.type='yule';
fit.threshold=xmin;
fit.exponent=exponent;
fit.loglike=-value;
fit.samples_over_threshold=n;
out = fit;
end

% Log-likelihood function of the Yule distribution
% Input: Data vector, distributional parameter, lower threshold
% Output: real-valued log-likelihood
function out = yule_loglike(x, alpha,xmin)
out=sum(dyule(x,alpha,xmin,true));
end