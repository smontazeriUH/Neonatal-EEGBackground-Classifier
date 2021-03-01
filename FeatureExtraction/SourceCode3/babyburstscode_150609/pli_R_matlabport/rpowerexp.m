% Generate random variates from a power law with exponential cut-off
% Input: Integer size, lower threshold, scaling exponent, exponential rate
% Output: Real vector of random variates
function out=rpowerexp(n,threshold,exponent,rate)
% defaults: threshold=1, rate=0

if rate==0
    out=rpareto(n,threshold,exponent);
    return
end
ru = rand(1,n);
r = qpowerexp(ru,threshold,exponent,rate);
out=r;
