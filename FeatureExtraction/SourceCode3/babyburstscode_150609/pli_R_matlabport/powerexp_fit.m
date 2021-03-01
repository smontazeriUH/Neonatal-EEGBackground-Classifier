% Estimate scaling exponent and exponential rate of power law with
% exponential cut-off by maximizing likelihood
% Input: Data vector, lower threshold
% Output: List, giving type ("powerexp"), scaling exponent, exponential
%         rate, lower threshold, log-likelihood
function out = powerexp_fit(data,threshold,method,initial_rate)
% defaults: threshold=1, method='constrOptim', initial_rate=-1
if nargin<3, method='fminsearch'; end
if nargin<4, initial_rate=-1; end

x = data(data>=threshold);
negloglike = @(theta) -powerexp_loglike(x,threshold,theta(1),theta(2));

% Fit a pure power-law distribution
pure_powerlaw = pareto_fit(data,threshold);
% possible to use gpfit? maybe tricky because we want to impose a parameter
% constraint.
% In the matlab newsreader I notice: 
% "Given data x, the MLE of the location parameter is theta = min(x), and
% the MLE of the shape parameter is k = sum(log(x./min(x)))/length(x). Some
% references define the shape as the inverse of that, by the way." 

% Use this as a first guess at the exponent
initial_exponent = pure_powerlaw.exponent;
if initial_rate < 0
    %exp_fit_temp=exp_fit(data,threshold);
    %initial_rate = exp_fit_temp.rate;
    % matlab version
    initial_rate=1/expfit(x); % x is thresholded
end
minute_rate = 1e-6;
theta_0 = [initial_exponent initial_rate];
theta_1 = [initial_exponent minute_rate];
switch method  % best matlab alternatives?
    case 'fminsearch'
        % matlab version
        %
        % fminsearch performs unconstrained optimization, but would need
        % the Optimization Toolbox to use fmincon
        % 
        % instead, try to impose a constraint with a numerical penalty
        lambdapenalty=@(lambda) 100000*(lambda<0);
        alphapenalty=@(alpha) 10000*(alpha<-1);
        negloglikewithpenalty=@(theta) negloglike(theta)+lambdapenalty(theta(2))+alphapenalty(theta(1));
        [est.par,est.value,exitflag]=fminsearch(negloglikewithpenalty,theta_0,optimset('Display','off'));
        if exitflag
            alpha = est.par(1);
            lambda = est.par(2);
            loglike = -est.value;
        else
            % failed, try again with different IC (small rate)
%             fprintf(1,'Retrying powerexp fit with different ICs...\n');
            [est.par,est.value,exitflag]=fminsearch(negloglikewithpenalty,theta_1,optimset('Display','off')); 
            if exitflag
                alpha = est.par(1);
                lambda = est.par(2);
                loglike = -est.value;
            else
                alpha=NaN;
                lambda=NaN;
                loglike=NaN;
            end
        end
        if alpha<-1 || lambda<0
            error('converged to point outside range. alpha=%g lambda=%g',alpha,lambda)
        end
    case 'constrOptim'
        % Impose the constraint that rate >= 0
        % and that exponent >= -1
        ui = [1 0;0 1]; %rbind(c(1,0),c(0,1))
        ci = [-1,0];
        % Can't start with values on the boundary of the feasible set so add
        % tiny amounts just in case
        if (theta_0(1) == -1), theta_0(1) = theta_0(1) + minute_rate; end
        if (theta_0(2) == 0), theta_0(2) = theta_0(2) + minute_rate; end
        est = constrOptim(theta_0,negloglike,'NULL',ui,ci);  %%% R built-in
        alpha = est.par(1);
        lambda = est.par(2);
        loglike = -est.value;
    case 'optim'
        est = optim(theta_0,negloglike);  %%% R built-in
        alpha = est.par(1);
        lambda = est.par(2);
        loglike = -est.value;
    case 'nlm'
        est_0 = nlm(negloglike,theta_0); %%% R built-in
        est_1 = nlm(negloglike,theta_1); %%% R built-in
        est = est_0;
        if (-est_1.minimum > -est_0.minimum)
            est = est_1;
            fprintf(1,'NLM had to switch\n');
        end
        alpha = est.estimate(1);
        lambda = est.estimate(2);
        loglike = -est.minimum;
    otherwise
        fprintf(1,['Unknown method ' method '\n']);
        alpha=NaN; lambda=NaN; loglike=NaN;
end
fit.type='powerexp';
fit.exponent=alpha;
fit.rate=lambda;
fit.xmin=threshold;
fit.loglike=loglike;
fit.samples_over_threshold=length(x);

out=fit;
