% Probability mass function of the Yule distribution (right-tail-conditional)
% Input: data vector, distributional parameter, lower threshold, log flag
% Output: Vector of (log) probabilities
function out = dyule(x, alpha, xmin, logflag)
% defaults: xmin=1, logflag=false
if xmin==1
    if logflag
        C = 0;
    else
        C = 1;
    end
else
    C = pyule(xmin-1,alpha,1,logflag,false);
end
% g = @(x) log(alpha-1) + lbeta(x,alpha) - C; % unused?!
if logflag
    f = @(x) log(alpha-1) + betaln(x,alpha) - C;
else
    f = @(x) (alpha-1)*beta(x,alpha)/Cend;
end

x(x<xmin)=NaN;
d=f(x);

out = d;
end

