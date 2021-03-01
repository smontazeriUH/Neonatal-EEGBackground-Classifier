% Tail-conditional discretized probability mass function
% Returns NA if given values below threshold
% Input: Data vector, distribution parameters, lower threshold, log flag
% Output: Vector of (log) probabilities
function out = dlnorm_tail_disc(x,meanlog,sdlog,threshold,logflag)
% defaults: threshold=0, logflag=false

C = plnorm(threshold-0.5,meanlog,sdlog,0,1);
if (logflag)
    f = @(y) dlnorm_disc(y,meanlog,sdlog,1) - C;
else
    f = @(y) dlnorm_disc(y,meanlog,sdlog,0)/C;
end
x(x<threshold)=NaN;
d=f(x);

out=d;

end