% Cumulative probability of discrete power law
% Returns NA on values < threshold
% Input: Data vector, lower threshold, scaling exponent, usual flags
% Output: Vector of (log) probabilties
function out = pzeta(x, threshold, exponent, lower_tail, log_p)
% defaults: threshold=1, lower_tail=true, log_p=false

C = zeta_func(exponent,threshold);
h = @(y)  zeta_func(exponent,y)/C ;
if (lower_tail)
    g = @(y)  1-h(y);
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

