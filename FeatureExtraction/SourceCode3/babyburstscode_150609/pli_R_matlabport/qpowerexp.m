% Quantiles of power-law with exponential cut-off distributions
% Input: Vector of (log) probabilities, lower threshold, scaling exponent,
%        exponential rate, usual flags
% Output: Vector of quantiles
function out=qpowerexp (p, threshold, exponent, rate, lower_tail, log_p)
% defaults: threshold=1, rate=0, lower_tail=true, log_p=false

% This isn't going to be simple, is it?  However, since ppowerexp is known,
% numerical inversion should be possible
if rate==0
    out=qpareto(p,threshold,exponent,log_p,lower_tail);
    return
end
if (log_p)
    z = exp(p);
else
    z = p;
end
if (lower_tail)
    q = 1-z;
else
    q = z;
end
qs=arrayfun(@(q) qpowerexponce(q,threshold,exponent,rate),q);
out=qs;

end

% Upper quantile of a single value from a power-law with exponential cut-off
% Should only ever be called by qpowerexp
% Input: Probability, lower threshold, scaling exponent, exponential rate
% Output: real-valued quantile
function out=qpowerexponce(q,threshold,exponent,rate)
% Finds a single powerexp (upper) quantile; gets called via sapplied in the
% real qpowerexp
% Handle easy cases first
if q==0
    out=inf;
    return
end

if q==1
    out=threshold;
    return
end
% The basic idea is to solve the equation
% q = ppowerexp(x)
% for x, by invoking the "uniroot" routine for finding zeroes of one-argument
% functions
w = @(x) q - ppowerexp(x,threshold,exponent,rate,0);
% powerexp decays more quickly than a power-law distribution of the same
% exponent and threshold
% Use the quantile of the Pareto as an upper bound
% Use the lower threshold as a lower bound
pareto_x_of_q = qpareto(q,threshold,exponent,0);
upperquant = fzero(w,[threshold,pareto_x_of_q]);
out=upperquant;

end
