% Tail-conditional cumulative distribution function
% Returns NA if given values below the threshold
% Input: Data vector, distributional parameters, lower threshold, usual flags
% Output: Vector of (log) probabilities
%
% Modified by JR on 08/04/13 to use logncdf_upper to avoid rounding errors
% in the defn of the CDF - currently only changed for the upper tail terms,
% ok to change for lower_tail too?
function out = plnorm_tail(x,meanlog,sdlog,threshold,lower_tail,log_p)
% defaults: threshold=0, lower_tail=true, log_p=false

%c = 1-logncdf(threshold,meanlog,sdlog);
c=logncdf_upper(threshold,meanlog,sdlog);
c_log = log(c); % consider calculating directly from formula
if ((~lower_tail) && (~log_p))
    %f = @(x) (1-logncdf(x,meanlog,sdlog))/c;
    f = @(x) logncdf_upper(x,meanlog,sdlog)/c;
end
if ((lower_tail) && (~log_p))
    f = @(x) 1 - (1-logncdf(x,meanlog,sdlog))/c;
end
if ((~lower_tail) && (log_p))
    %f = @(x) log((1-logncdf(x,meanlog,sdlog))) - c_log;
    f = @(x) log(logncdf_upper(x,meanlog,sdlog)) - c_log;
end
if ((lower_tail) && (log_p))
    f = @(x) log(1 - (1-logncdf(x,meanlog,sdlog))/c);
end
x(x<threshold)=NaN;
p = f(x);

out=p;
end

