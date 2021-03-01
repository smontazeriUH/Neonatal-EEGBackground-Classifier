% Tail-conditional probability density function
% Returns NA on values < threshold
% Input: Data vector, distributional parameters, log flag
% Output: Vector of (log) probability densities
function out = dweibull_tail(x,shape,scale,threshold,logflag)
% defaults: threshold-0, logflag=false
% note: matlab wblpdf notation has scale and shape opposite dweibull in R
c = log(1-wblpdf(threshold,scale,shape));
if logflag
    f = @(y) log(wblpdf(y,scale,shape)) - c;
else
    f = @(y) wblpdf(y,scale,shape)/c;
end
x(x<threshold)=NaN;
d=f(x);
out=d;

end