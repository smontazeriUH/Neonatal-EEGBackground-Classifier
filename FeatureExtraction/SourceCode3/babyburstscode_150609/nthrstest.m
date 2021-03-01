function varargout = nthrstest(y,nthrs)
% NTHRSTEST takes input power_flucts and estimates a threshold value
% (maximum number of avalanche fluctuations) at a given number of threshold ranges
%
%   Inputs:
%   y = time series of data
%   nthrs = number of thesholds to test
%
% Orig by KI, drawing on testavthresholds.m (orig by JR).
% Modified by JR on 27/11/12 - renamed variables, removed unused variables,
%     same algorithm as original version but some tidying
% Modified by JR on 14/01/13 - split into nthrs quantiles
% Modified by JR on 13/05/13 - using faster extractbursts option

% Possible modifications:
%  - check that max(navs) has been found; if max is at an end the range
%  should probably be widened

%if any(y<0)
%    warning('y is not nonnegative, restricting attention to y>=0')
%    y(y<0)=0;
%end

% old method
%thrs = exp(linspace(min(log(y)),0.5*max(log(y)),nthrs));

% new method - split y into nthrs quantiles
thrs=quantile(y,nthrs);

navs=zeros(1,nthrs);
for k = 1:nthrs
    navs(k)=extractbursts(y,thrs(k),1); % option 1 to give just navs
end

% choose thr that maximizes navs (choosing the lowest if there's a tie)
[navsmax,thri]=max(navs);
thri=min(thri); % in case max is not unique, take lowest
thr=thrs(thri);

%thr=min(thrs(navs==max(navs)));

varargout{1}=thr;
if nargout>1
    varargout{2}=navsmax;
end

end

