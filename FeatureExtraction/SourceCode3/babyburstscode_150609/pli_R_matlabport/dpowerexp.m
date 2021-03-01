% Density of power laws with exponential cut-off
% Returns NA on values < threshold
% Input: Data vector, lower threshold, scaling exponent, exponential rate,
%        log flag
% Output: vector of (log) densities
function out=dpowerexp(x, threshold, exponent, rate, logflag) 
% defaults: threshold=1, rate=0, logflag=false;

% If the rate is zero, we've got a pure Pareto
if rate==0
    %out=dpareto(x,threshold,exponent,logflag);
    % using matlab's generalized Pareto distribution
    % K=index, sigma=scale, threshold=theta, where theta=sigma/K for Pareto
    out=gppdf(x,exponent,exponent*threshold,threshold);
    return
end

nondim_thresh=threshold*rate;
if isnan(log(nondim_thresh)) || ~isfinite(log(nondim_thresh))
%     fprintf(1,'Non-dimensionalized threshold, %g, is too small for log\n',nondim_thresh);
end
if isnan(log(rate)) ||~ isfinite(log(rate))
%     fprintf(1,'Rate, %g, is too small for log\n',rate);
end
%uigf=gammainc(nondim_thresh,-exponent+1,'upper'); % matlab gammainc also can't do negative a
uigfval=uigf(-exponent+1,nondim_thresh);
if isnan(log(uigfval))
%     fprintf(1,'UIGF, %g, is too small for log\n',uigf);
end
prefactor = rate/(nondim_thresh^exponent);
C = prefactor/uigfval;
prefactor_log = log(rate) - exponent*log(nondim_thresh);
C_log = prefactor_log - log(uigfval);
if isnan(C_log)
%     fprintf(1,'Normalizing constant, %g, is too small for log\n',C);
end
% If I want the log density, I may as well avoid some finite-precision
% arithmetic first
if(logflag)
    f = @(y) (C_log - exponent*(log(y)-log(threshold)) - rate*y);
else
    f = @(y) (C*(y/threshold).^(-exponent).*exp(-rate*y));
end
x(x<threshold)=NaN;
d=f(x);
% if x<threshold
%     d=NaN;
% else
%     d=f(x);
% end

out=d;
