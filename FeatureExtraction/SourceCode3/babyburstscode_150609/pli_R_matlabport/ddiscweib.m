% Probability mass function for discrete Weibull distribution, conditional on
% being in the right/upper tail
% Input: Data vector, distributional parameters, lower cut-off, log flag
% Output: Vector of (log) probabilities
function out = ddiscweib(x,shape,scale,threshold,logflag)
% defaults: threshold=0, logflag=false

% Compute the PMF as the increments of the distribution function
x(x<threshold)=NaN;
if(logflag)
    d = f_log(x);
else
    d = f(x);
end
out = d;

    function out = f(y)
        p1 = pdiscweib(y,shape,scale,threshold,0);
        p2 = pdiscweib(y+1,shape,scale,threshold,0);
        out = (p1-p2);
    end

    function out = f_log(y)
        % Do calculations on a logarithmic scale
        % Let log(b) - log(a) = h = log(b/a), b > a
        % Then b-a = a(b/a - 1)
        % b-a = a(exp(log(b/a)) - 1)
        % b-a = a(exp(h) - 1)
        % log(b-a) = log(a) + log(exp(h) - 1)
        lp1 = pdiscweib(y,shape,scale,threshold,0,1);
        lp2 = pdiscweib(y+1,shape,scale,threshold,0,1);
        out = (lp2 + log(exp(lp1-lp2)-1));
    end

end

