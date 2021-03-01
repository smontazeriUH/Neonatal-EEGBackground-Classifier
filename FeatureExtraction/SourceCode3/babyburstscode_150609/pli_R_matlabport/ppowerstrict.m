% Cumulative distribution function of the strictly-truncated power-law
% distribution 
% Gives NaN on values outside [a,b]
% Input: Data vector, xmin, xmax, scaling exponent, usual flags
% Output: Vector of (log) probabilities
%
% From Deluca and Corral (2013), based on Eq. (6) but defining r=b/a
% instead of a/b [cf. Eq. (27)]
function out=ppowerstrict(x, a, b, exponent, lower_tail, log_p)
% defaults: threshold=1, lower_tail=true, log_p=false
r=b/a;
am1=exponent-1;
r1ma=r^(-am1);
if ((~lower_tail) && (~log_p))
    f = @(x) ((a./x).^am1-r1ma)./(1-r1ma);
end
if ((lower_tail) && (~log_p))
    f = @(x)  1 - ((a./x).^am1-r1ma)./(1-r1ma);
end
if ((~lower_tail) && (log_p))
    f = @(x) log((a./x).^am1-r1ma)-log(1-r1ma);
end
if ((lower_tail) && (log_p))
    f = @(x) log(1 - ((a./x).^am1-r1ma)./(1-r1ma));
end

x(x<a | x>b)=NaN;
p=f(x);
out=p;