% Tail-conditional cumulative distribution function
% Returns NA on values < threshold
% Input: Data vector, distributional parameters, usual flags
% Output: Vector of (log) cumulative probabilities
function out = pweibull_tail(x,shape,scale,threshold,lower_tail,log_p)
% defaults: threshold=0, lower_tail=true, log_p=false
% note: matlab wblcdf notation has scale and shape opposite pweibull in R

% USING log(1-wblcdf(x,scale,shape)) == -(x./scale).^shape
%c = 1-wblcdf(threshold,scale,shape);
%c_log = log(c);
c_log = -(threshold./scale).^shape;
c = exp(c_log);
if ((~lower_tail)&&(~log_p))
    %f = @(x) (1-wblcdf(x,scale,shape))/c;
    f = @(x) exp(-(x./scale).^shape)/c; 
end
if ((~lower_tail)&&(log_p))
    %f = @(x) log(1-wblcdf(x,scale,shape)) - c_log;
    f = @(x) -(x./scale).^shape - c_log;
end
if ((lower_tail)&&(~log_p))
    %f = @(x) 1 - (1-wblcdf(x,scale,shape))/c;
    f = @(x) 1 - exp(-(x./scale).^shape)/c;
end
if ((lower_tail)&&(log_p))
    %f = @(x) log(1 - (1-wblcdf(x,scale,shape))/c);
    f = @(x) log(1 - exp(-(x./scale).^shape)/c);
end
x(x<threshold)=NaN;
p=f(x);
out=p;
end