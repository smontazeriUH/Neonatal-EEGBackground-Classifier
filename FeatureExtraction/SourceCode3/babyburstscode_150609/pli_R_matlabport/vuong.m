% Apply Vuong's test for non-nested models to vector of log-likelihood ratios
% Sample usage:
%%%% vuong(pareto.lnorm.llr(wealth,wealth.pareto,wealth.lnorm))
% The inner function produces a vector, giving the log of the likelihood
% ratio at every point; the outer function then reduces this and calculates
% both the normalized log likelihood ratio and the p-values.
% Input: Vector giving, for each sample point, the log likelihood ratio of
%        the two models under consideration
% Output: List giving total log likelihood ratio, mean per point, standard
%         deviation per point, Vuong's test statistic (normalized pointwise
%	  log likelihood ratio), one-sided and two-sided p-values (based on
%	  asymptotical standard Gaussian distribution)
function out=vuong(x)
n = length(x);
R = sum(x);
m = mean(x);
s = std(x);
v = sqrt(n)*m/s;
p1 = normcdf(v,0,1);
if (p1 < 0.5)
    p2 = 2*p1;
else
    %p2 = 2*(1-p1);
    p2 = erfc(v/sqrt(2));
end
out.loglike_ratio=R;
out.mean_LLR = m;
out.sd_LLR = s;
out.Vuong=v;
out.p_one_sided=p1;
out.p_two_sided=p2;
end


