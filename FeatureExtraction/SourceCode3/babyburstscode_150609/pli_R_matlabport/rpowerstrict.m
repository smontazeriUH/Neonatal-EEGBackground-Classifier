% Generate strictly-truncated power-law-distributed random variates
% Input: Integer size, lower threshold, upper threshold, scaling exponent
% Output: Vector of real-valued random variates
%
% From Deluca and Corral (2013), based on Eq. (6) and defining r=b/a
% instead of a/b [cf. Eq. (32)]
function out=rpowerstrict(n, a, b, exponent)
% defaults: threshold=1

% Using the transformation method, because we know the quantile function
% analytically
% Consider replacing with a non-R implementation of transformation method
ru = rand(1,n);
%rs=a*(1-(1-(a/b)^(exponent-1))*ru).^(1/(1-exponent)); % Eq. (32)
r1ma=(b/a)^(1-exponent);
rs=a*((1-r1ma)*ru+r1ma).^(1/(1-exponent));

out=rs;