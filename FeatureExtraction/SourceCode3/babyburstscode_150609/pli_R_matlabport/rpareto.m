% Generate Pareto-distributed random variates
% Input: Integer size, lower threshold, scaling exponent
% Output: Vector of real-valued random variates
function out=rpareto(n, threshold, exponent)
% defaults: threshold=1

% Using the transformation method, because we know the quantile function
% analytically
% Consider replacing with a non-R implementation of transformation method
ru = rand(1,n);
r=qpareto(ru,threshold,exponent);

out=r;