% Quantiles of Pareto distributions
% Input: vector of probabilities, lower threshold, scaling exponent, usual flags
% Output: Vector of quantile values
function out=qpareto(p, threshold, exponent, lower_tail, log_p)
% defaults: threshold=1, lower_tail=true, log_p=false
if nargin<4, lower_tail=1; end
if nargin<5, log_p=0; end

% Quantile function for Pareto distribution
% P(x) = 1 - (x/xmin)^(1-a)
% 1-p = (x(p)/xmin)^(1-a)
% (1-p)^(1/(1-a)) = x(p)/xmin
% xmin*((1-p)^(1/(1-a))) = x(p)
% Upper quantile:
% U(x) = (x/xmin)^(1-a)
% u^(1/(1-a)) = x/xmin
% xmin * u^(1/(1-a)) = x
% log(xmin) + (1/(1-a)) log(u) = log(x)
if (log_p)
    p = exp(p);
end
if (lower_tail)
    p = 1-p;
end
% This works, via the recycling rule
% q=(p^(1/(1-exponent)))*threshold
q_log = log(threshold) + (1/(1-exponent))*log(p);
q = exp(q_log);

out=q;
