% Probability mass function for discrete exponential distribution, conditional
% on being in the tail
% Input: Data vector, distributional parameters, log flag
% Output: Vector of (log) probabilities
function out = ddiscexp(x, lambda, threshold, logflag)
% defaults: threshold=0, logflag=false

if (logflag)
    C = log(1-exp(-lambda)) + lambda*threshold;
    f = @(x) C -lambda*x;
else
    C = (1-exp(-lambda))*exp(lambda*threshold);
    f = @(x) C*exp(-lambda*x);
end
x(x<threshold)=NaN;
d=f(x);

out=d;
end

