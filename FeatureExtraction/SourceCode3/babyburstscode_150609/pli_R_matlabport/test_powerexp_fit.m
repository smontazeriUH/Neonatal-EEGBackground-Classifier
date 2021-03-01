% Test the quality of the fitting by generating Pareto variates and seeing
% whether the log likelihood ratio is \chi^2
% Input: number of replicates, sample size, distributional parameters
% Output: List of 2*LLR values
% Side-effect: Plot of CDF of 2*LLR vs. pchisq(,1)
function out=test_powerexp_fit(reps,n,xmin,alpha) 
% defaults: reps=200, n=200, xmin=1, alpha=2.5
  l=zeros(1,reps);
  for j=1:reps
      l(j)=2*test_powerexp_fit_1(n,xmin,alpha);
  end
  ecdf(l);
  hold on
  h=ezplot(@(x) chi2cdf(x,1),[min(l),max(l)]);
  set(h,'color','red')
  hold off
  out=l;
end

function out=test_powerexp_fit_1(n,xmin,alpha) 
% defaults: n=200, xmin=1, alpha=2.5
  x = rpareto(n,xmin,alpha);
  paretofit=pareto_fit(x,xmin);
  pareto_ll = paretofit.loglike;
  powerexpfit=powerexp_fit(x,xmin,'fminsearch',0);
  powerexp_ll = powerexpfit.loglike;
  out = powerexp_ll - pareto_ll;
end
