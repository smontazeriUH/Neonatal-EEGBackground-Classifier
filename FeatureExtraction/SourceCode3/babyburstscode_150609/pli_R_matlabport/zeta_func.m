% Compute the Hurwitz zeta function multiple times, with multiple additive
% constants (lower limits of summation)
% First argument is the exponent, second is the limit of summation
% Works by invoking the zeta_func_once.gsl function
% Input: Exponent, vector of thresholds
% Output: Vector of Hurwitz zeta values
function out = zeta_func(s, q) 
% matlab doesn't appear to have Hurwitz zeta, so using Riemann zeta (Paul
% Godfrey one recommended for plfit) and subtracting off the extra terms 
% (q is always an integer here)
addedbit=@(x) sum((1:(x-1)).^-s);
zetas=zeta(s) - arrayfun(addedbit,q);

out=zetas;
end

% Compute the Hurwitz zeta via invoking the GNU scientific library ONCE
% Input: real-valued exponent (s), additive constant (q)
% Output: Real value
% zeta_func_once.gsl = function(q,s) {
%   zeta.command = paste(zeta_function_filename,s,q)
%   zeta = as.numeric(system(zeta.command,intern=TRUE))
%   return(zeta)
% end
