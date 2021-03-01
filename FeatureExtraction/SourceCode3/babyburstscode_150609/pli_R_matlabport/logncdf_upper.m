function p = logncdf_upper(x,mu,sigma)
%  p = logncdf_upper(x,mu,sigma)
% More robust log-normal upper CDF
% logncdf uses the complementary error function p=0.5*erfc(-z./sqrt(2))
% rather than .5*(1+erf(z/sqrt(2))) to produce accurate near-zero results
% for large negative x, so use a similar idea here for 1-CDF
%
% code follows logncdf.m but doesn't do confidence intervals

% Return NaN for out of range parameters.
sigma(sigma <= 0) = NaN;

% Negative data would create complex values, which erfc cannot handle.
x(x < 0) = 0;

z = (log(x)-mu) ./ sigma;

% CDF = 0.5*erfc(-z./sqrt(2)) = 0.5*(1+erf(z/sqrt(2)))
% therefore 1-CDF = 0.5*(1-erf(z/sqrt(2))) = 0.5*erfc(z./sqrt(2))
%
% orig comment from logncdf.m:
%Use the complementary error function, rather than .5*(1+erf(z/sqrt(2))),
% to produce accurate near-zero results for large negative x.
p = 0.5 * erfc(z ./ sqrt(2));

end