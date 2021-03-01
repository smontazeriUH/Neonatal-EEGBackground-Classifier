% Cumulative distribution function for discrete Weibull, conditional on being
% in the right/uppper tail
% Input: Data vector, distributional parameters, lower cut-off, usual flags
% Output: Vector of (log) probabilities
function out = pdiscweib(x,shape,scale,threshold,lower_tail,log_p) 
% defaults: threshold=0, lower_tail=true, log_p=false
if nargin<6
    log_p=0;
end

% g(y) here is the probability of being strictly > y
if (threshold == 0)
    C = 1;
else
    C = 1-wblcdf(threshold,scale,shape);
end
C_log = log(C);
g = @(y) (1-wblcdf(y,scale,shape))/C;
g_log = @(y) log(1-wblcdf(y,scale,shape))-C_log;
if (~lower_tail && ~log_p)
    f = @(y) g(y);
end
if (~lower_tail && log_p)
    f = @(y) g_log(y);
end
if (lower_tail && ~log_p)
    f = @(y) 1-g(y);
end
if (lower_tail && log_p)
    f = @(y) log(1-g(y));
end
x(x<threshold)=NaN;
p = f(x);
out = p;
end