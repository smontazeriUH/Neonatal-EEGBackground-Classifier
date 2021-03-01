% Probability mass function for discrete power law with exponential cut-off,
% conditional on being in the right/upper tail
% Returns NA on data points below cut-off
% Input: Data vector, distributional parameters, lower cut-off, log flag
% Output: Vector of (log) probabilities
function out = ddiscpowerexp(x,exponent,rate,threshold,logflag)
% defaults: rate=0, threshold=1, logflag=false

if (rate==0)
    out=(dzeta(x,threshold,exponent,logflag)) ;
    return
end
C = discpowerexp_norm(threshold,exponent,rate);
if (log)
    f = @(y) discpowerexp_log(y,exponent,rate) - log(C);
else
    f = @(y) discpowerexp_base(y,exponent,rate)/C;
end
x(x<threshold)=NaN;
d=f(x);

out=d;
end

% Un-normalized powerexp probability mass function
% Input: Data vector, distributional parameters
% Output: Vector of numbers, proportional to probabilities of data points
function out = discpowerexp_base(x,exponent,rate)
% defaults: rate=0
out = x.^(-exponent) .* exp(-x*rate);
end

% Log of un-normalized powerexp probability mass function
% Equivalent to applying log to discpowerexp.base, but avoids some finite
% precision arithmetic in taking the log
% Input: Data vector, distributional parameters
% Output: Vector of numbers, equal to log probabilities of data points plus
%	  a proportionality constant
function out = discpowerexp_log(x,exponent,rate)
% defaults: rate=0
out = -exponent*log(x)-x*rate;
end