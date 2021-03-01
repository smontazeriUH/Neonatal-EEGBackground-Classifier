% The upper incomplete gamma function, allowing for negative indices
% Part of the normalizing constant in the powerexp family
% Uses the identity (holding for all a != 0)
%%% Gamma(a,x) = (1/a)(Gamma(a+1,x) - e^{-x} x^a)
% and Gamma(0,x) = E_1(x), first-order exponential integral (special) function

% Input: exponent (a), lower cut-off (x),  log flag
% Output: Real value
function out=uigf(a,x,logflag)
if nargin<3, logflag=0; end
% default: logflag=false
Gamma = 0; %added by Saeed

  if (a > 0) 
    % Use gamma-distribution tricks
    Gamma = gamma(a)*(1-gamcdf(x,a,1));
  end
  if (a == 0) 
    % Invoke the exponential integral function
    Gamma = expint(x); % using inbuilt matlab
  end
  if (a < 0) 
    % Recurse
%     Gamma = (1/a) * (uigf(a+1,x) - exp(-x).*(x.^a));
    Gamma = (1/a) * (uigf(a+1,x) - exp(-x+a*log(x)));
  end
  if (logflag) 
    Gamma = log(Gamma);
  end

  out=Gamma;
  
  end

% The exponential integral function
% Used in evaluating the upper incomplete gamma function, when the latter
% has a negative integer argument
% Two choices: invoke the GNU Scientific Library (GSL), via Cosma's
% very clumsy R/C interface
% OR use the series expansion given in Numerical Recipes, translated into
% R without any optimization or permissions
% Both methods don't work well on vector data, so exp_int acts as
% wrapper, with a choice of method, defaulting to the GSL (where my programming
% had less chance to screw it up)

% Compute the first-order exponential integrals of vectors of arguments
% The method "gsl" makes an external call to the GSL
% The method "nr" calls code lifted from Numerical Recipies
% For copyright reasons that method is NOT part of this public release
% Input: Real-valued vector, method flag
% Output: Real-valued vector
%function out=exp_int(x,method)
%default: method='gsl'

% using matlab
%out=expint(x);

%   switch(method,
%     gsl = {ei <- sapply(x,exp_int_once.gsl)},
%     nr = {ei <- sapply(x,exp_int_once.nr)},
%     {cat("Unknown method", method); ei <- NA}
%   )
%   return(ei)
% }

% Compute the exponential integral via invoking the GNU scientific library ONCE
% Input: real-valued argument (x)
% Output: Real value
% exp_int_once.gsl <- function(x) {
%   ei.command <- paste(exp_int_function_filename,x)
%   ei <- as.numeric(system(ei.command,intern=TRUE))
%   return(ei)
% }
%end