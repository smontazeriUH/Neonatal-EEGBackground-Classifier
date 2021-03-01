% Cumulative distribution function for power law with exponential cut-off
% Returns NA on values less than lower threshold
% Input: Data vector, lower threshold, scaling exponent, exponential rate,
%        usual flags
% Output: Vector of (log) probabilities
function out = ppowerexp(x, threshold,exponent,rate,lower_tail,log_p)
% defaults: threshold=1, rate=0, lower_tail=true, log_p=false;

% The complementary distribution, Pr(X > x), is very simple,
% it's just uigf(-exponent+1,rate*x)/uigf(-exponent+1,rate*threshold)
% So, we do that
if rate==0
    %out=ppareto(x,threshold,exponent,log,lower.tail);
    % using matlab's generalized Pareto distribution
    % K=index, sigma=scale, threshold=theta, where theta=sigma/K for Pareto
    out=gpcdf(x,exponent,exponent*threshold,threshold);
    return
end

%C = 1/gammainc(rate*threshold,-exponent+1,'upper');    % matlab gammainc also can't do negative a
%this_uigf = @(x) gammainc(rate*x,-exponent+1,'upper'); %
C = 1./uigf(-exponent+1,rate*threshold);
this_uigf = @(x) uigf(-exponent+1,rate*x);
if ((~lower_tail)&&(~log_p))
    f = @(x) C*this_uigf(x);
end
if ((lower_tail)&&(~log_p))
    f = @(x) 1 - C*this_uigf(x);
end
if ((~lower_tail)&&(log_p))
    f = @(x) log(C) + log(this_uigf(x));
end
if ((lower_tail)&&(log_p))
    f = @(x) log(1 - c*this_uigf(x));
end
x(x<threshold)=NaN;
p=f(x);
% if x<threshold
%     p=NaN;
% else
%     p=f(x);
% end
out=p;
