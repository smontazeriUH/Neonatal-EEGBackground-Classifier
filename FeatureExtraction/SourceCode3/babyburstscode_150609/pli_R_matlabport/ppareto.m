% Cumulative distribution function of the Pareto distributions
% Gives NA on values < threshold
% Input: Data vector, lower threshold, scaling exponent, usual flags
% Output: Vector of (log) probabilities
function out=ppareto(x, threshold, exponent, lower_tail, log_p)
% defaults: threshold=1, lower_tail=true, log_p=false
if ((~lower_tail) && (~log_p))
    f = @(x) (x/threshold).^(1-exponent);
end
if ((lower_tail) && (~log_p))
    f = @(x)  1 - (x/threshold).^(1-exponent);
end
if ((~lower_tail) && (log_p))
    f = @(x) (1-exponent)*(log(x) - log(threshold));
end
if ((lower_tail) && (log_p))
    f = @(x) log(1 - (x/threshold).^(1-exponent));
end

x(x<threshold)=NaN;
p=f(x);
out=p;