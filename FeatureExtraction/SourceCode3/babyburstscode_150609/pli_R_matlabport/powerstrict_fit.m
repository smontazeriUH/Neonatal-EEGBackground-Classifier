% Estimate scaling exponent of strictly-truncated power law by maximizing
% likelihood 
% Input: Data vector, lower threshold, upper threshold
% Output: Struct, giving type ('powerstrict'), scaling exponent, lower
% threshold, upper threshold, log-likelihood
function out = powerstrict_fit(data,a,b,method)
% defaults: threshold=1, method='constrOptim', initial_rate=-1
if nargin<4, method='fminsearch'; end

x = data(data>=a & data<=b);
negloglike = @(theta) -powerstrict_loglike(x,a,b,theta);

% Fit a pure power-law distribution
pure_powerlaw = pareto_fit(data,a);

% Use this as a first guess at the exponent
theta_0 = pure_powerlaw.exponent;

switch method  % best matlab alternatives?
    case 'fminsearch'
        % fminsearch performs unconstrained optimization; fmincon performs
        % constrained optimization but requires the Optimization Toolbox
        % 
        % instead, try to impose a constraint with a numerical penalty
        alphapenalty=@(alpha) 10000*(alpha<1); % careful, overly strict
        negloglikewithpenalty=@(theta) negloglike(theta)+alphapenalty(theta(1));
        [est.par,est.value,exitflag,exitoutput]=fminsearch(negloglikewithpenalty,theta_0);
        if exitflag
            alpha = est.par;
            loglike = -est.value;
            if alpha<1
                error('converged to point outside range. alpha=%g lambda=%g',alpha,lambda)
            end
        else
            alpha=NaN;
            loglike=NaN;
        end

    otherwise
        fprintf(1,['Unknown method ' method '\n']);
        alpha=NaN; loglike=NaN;
end
fit.type='powerstrict';
fit.exponent=alpha;
fit.xmin=a;
fit.xmax=b;
fit.loglike=loglike;
fit.N=length(x);
fit.exitflag=exitflag;
fit.exitoutput=exitoutput;

out=fit;

end

% Calculate log-likelihood under a strictly-truncated power-law
% distribution 
% Input: Data vector, lower threshold, upper threshold, scaling exponent
% Output: Real-valued log-likelihood
function loglike=powerstrict_loglike(x,a,b,alpha)
% see Deluca & Corral (2013)
r=a/b;
lng=mean(log(x));
am1=alpha-1;
loglike=log(am1)-log(1-r^am1)+am1*log(a)-alpha*lng; % Eq. (11)

end



