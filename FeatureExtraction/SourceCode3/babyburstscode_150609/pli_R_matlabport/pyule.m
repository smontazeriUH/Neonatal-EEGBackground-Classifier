% Cumulative distribution function of the Yule distribution
% (right-tail-conditional)
% If the threshold xmin > 1, then it calls itself recursively, reducing to the
% xmin==1 base case in one step
% Input: data vector, distributional parameter, usual flags
% Output: vector of (log) probabilities
function out = pyule(x, alpha, xmin, log_p, lower_tail)
% defaults: xmin=1, log_p=false, lower_tail=true
if xmin==1
    if log_p
        C = 0;
    else
        C = 1;
    end
else
    C = pyule(xmin,alpha,1,log_p,false);
end
g = @(x) x.*beta(x,alpha)/C;
g_log = @(x) log(x) + betaln(x,alpha)-C;
if (~lower_tail && log_p), f = @(x) g_log(x); end
if (~lower_tail && ~log_p), f = @(x) g(x); end
if (lower_tail && log_p), f=@(x) log(1-g(x)); end
if (lower_tail && ~log_p), f=@(x) 1-g(x); end

x(x<xmin)=NaN;
p=f(x);

out=p;
end
