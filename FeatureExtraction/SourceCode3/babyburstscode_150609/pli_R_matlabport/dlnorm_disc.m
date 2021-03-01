% Discretized probability mass function
% Input: Data vector, meanlog, sdlog, log parameter
% Output: Vector of (log) probabilities
function out = dlnorm_disc(x, meanlog, sdlog, logflag)
% defaults: logflag=false

% When x is very large, plnorm(x, lower.tail=TRUE) gets returned as 1,
% but plnorm(x,lower.tail=FALSE) gets returned as a small but non-zero
% number, so we should get fewer zeroes this way
p = (1-logncdf(x-0.5,meanlog,sdlog)) - (1-logncdf(x+0.5,meanlog,sdlog));
if (logflag)
    out = log(p);
else
    out = p;
end
end

