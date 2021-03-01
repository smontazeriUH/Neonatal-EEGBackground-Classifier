% Calculate tail-conditional log-likelihood
% Will give an ERROR if any of the data values < threshold
% Input: Data vector, threshold, exponent
% Output: Log likelihood
function out = zeta_loglike(x,threshold,exponent)
% defaults: threshold=1;

L = sum(dzeta(x,threshold,exponent,1));
out=L;
end

