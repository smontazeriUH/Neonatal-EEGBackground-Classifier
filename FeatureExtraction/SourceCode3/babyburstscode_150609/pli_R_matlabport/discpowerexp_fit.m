% Fit discrete powerlaw with exponential cut-off to right/upper tail of
% data via numerical likelihood maximization
% Optimization is constrained to make sure that parameters stay in the
% meaningful region
% Input: Data vector, lower threshold
% Output: List giving type of fitted distribution, estimated parameters,
%	  information about the data and fit
function out = discpowerexp_fit(x,threshold)
% defaults: threshold=1

x = x(x>=threshold);
% Apply the MLEs for the exponential and the power-law (approx.) to
% get starting values
zetafit=zeta_fit(x,threshold,'ml_approx');
alpha_0 = zetafit.exponent;
discexpfit=discexp_fit(x,threshold);
lambda_0 = discexpfit.lambda;
theta_0 = [alpha_0,lambda_0];
negloglike = @(theta) -discpowerexp_loglike(x,theta(1),theta(2),threshold);
% R code used constrained optimization
%ui = [1 0;0 1]; %rbind(c(1,0),c(0,1))
%ci = [-1,0];
%est = constrOptim(theta_0,negloglike,'NULL',ui,ci);  %%% R built-in

% here we're 'helping' the unconstrained optimization
lambdapenalty=@(lambda) 10000*(lambda<0);
negloglikewithpenalty=@(theta) negloglike(theta)+lambdapenalty(theta(2));
[est.par est.value]=fminsearch(negloglikewithpenalty,theta_0);
alpha = est.par(1);
lambda = est.par(2);
loglike = -est.value;
if alpha<-1 || lambda<0
    error('converged to point outside range. alpha=%g lambda=%g',alpha,lambda)
end

fit.type='discpowerexp';
fit.exponent=alpha;
fit.rate=lambda;
fit.loglike = loglike;
fit.threshold=threshold;
fit.samples_over_threshold=length(x);

out=fit;
end
