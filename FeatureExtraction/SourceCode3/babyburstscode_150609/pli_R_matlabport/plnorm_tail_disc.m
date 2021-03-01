% Tail-conditional discretized cumulative probability function
% Returns NA if given values below threshold
% Input: Data vector, distributional parameters, lower threshold, usual flags
% Output: Vector of (log) probabilities
function out = plnorm_tail_disc(x,meanlog,sdlog,threshold,log_p,lower_tail)
% defaults: threshold=0, log_p=false, lower_tail=true

h = @(y)  plnorm(y+0.5,meanlog,sdlog)/plnorm(threshold-0.5,meanlog,sdlog);
if (lower_tail)
    g = @(y) 1-h(y);
else
    g = @(y) h(y);
end
if (log_p)
    f = @(y) log(g(y));
else
    f = @(y) g(y);
end
x(x<threshold)=NaN;
p=f(x);

out=p;

end