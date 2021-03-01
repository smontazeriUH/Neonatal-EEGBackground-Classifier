% Probability mass function, conditional on being in tail
% Outputs 'NA' on data points below cut-off
% Input: Data vector, Poisson rate, lower cut-off, log-flag
% Output: Vector of (log) probabilities
function out = dpois_tail(x, rate, threshold, logflag)
% defaults: threshold=0, logflag=false

if logflag
    C=log(1-poisscdf(threshold-1,rate));
    f = @(x) -C + log(poisspdf(x,rate));
else
    C=1-poisscdf(threshold-1,rate);
    f = @(x) poisspdf(x,rate)/C;
end

x(x<threshold)=NaN;
d=f(x);

out = d;
end

