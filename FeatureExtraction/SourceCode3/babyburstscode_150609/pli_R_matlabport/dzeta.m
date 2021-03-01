% Density (probability mass) of discrete power law
% Returns NA on values < threshold
% Input: Data vector, lower threshold, scaling exponent, log flag
% Output: Vector of (log) densities (probabilities)
function out = dzeta(x, threshold, exponent, logflag)
% defaults: threshold=1; logflag=false

C = zeta_func(exponent,threshold);
if logflag
    f = @(y) -log(C) - exponent*log(y);
else
    f = @(y) (1/C) * (y.^(-exponent));
end
x(x<threshold)=NaN;
d=f(x);

out=d;
end