% Tail-conditional density function
% Returns NA if given values below the threshold
% Input: Data vector, distributional parameters, lower threshold, log flag
% Output: Vector of (log) probability densities
function out = dlnorm_tail(x, meanlog, sdlog, threshold,logflag)
% defaults: threshold=0, logflag=false
% Returns NAs at positions where the values in the input are < threshold
if (logflag)
    f = @(x) log(lognpdf(x,meanlog,sdlog)) - log(logncdf(threshold,meanlog,sdlog));
else
    f = @(x) lognpdf(x,meanlog,sdlog)/logncdf(threshold,meanlog,sdlog);
end
x(x<threshold)=NaN;
d=f(x);

out = d;
end