% Probability density of Pareto distributions
% Gives NA on values below the threshold
% Input: Data vector, lower threshold, scaling exponent, "log" flag
% Output: Vector of (log) probability densities
function out=dpareto(x, threshold, exponent, logflag)
% defaults: threshold=1, logflag=false

% Avoid doing limited-precision arithmetic followed by logs if we want
% the log!
if ~logflag
    prefactor = (exponent-1)/threshold;
    f = @(x) prefactor*(x/threshold).^(-exponent);
else
    prefactor_log = log(exponent-1) - log(threshold);
    f = @(x) prefactor_log - exponent*(log(x) - log(threshold));
end
x(x<threshold)=NaN;
d=f(x);

out=d;
