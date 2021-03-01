% Tail-conditional cumulative distribution function
% Returns NA on values < threshold
% Input: Data vector, distributional parameters, usual flags
% Output: Vector of (log) cumulative probabilities
% ** BASED ON pweibull_tail
function out = pexp_tail(x,rate,threshold,lower_tail,log_p)
% defaults: threshold=0, lower_tail=true, log_p=false
% use to rewrite more succinctly: 1-expcdf(x,mu)=exp(-x/mu)
%c = 1-expcdf(threshold,1/rate);
c=exp(-threshold*rate);
c_log = log(c);
if ((~lower_tail)&&(~log_p))
    f = @(x) exp(-x*rate)/c;
end
if ((~lower_tail)&&(log_p))
    f = @(x) -x*rate - c_log;
end
if ((lower_tail)&&(~log_p))
    f = @(x) 1 - exp(-x*rate)/c;
end
if ((lower_tail)&&(log_p))
    f = @(x) log(1 - exp(-x*rate)/c);
end
x(x<threshold)=NaN;
p=f(x);
out=p;
end