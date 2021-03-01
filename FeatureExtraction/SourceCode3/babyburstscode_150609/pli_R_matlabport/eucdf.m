function [xout,yout]=eucdf(x,plotstring)
% empirical upper cdf, based on code snippet from Clauset's plplot
%
% to compare thresholded fits, need to use:
% fitteduppercdf = fitteduppercdf .* c(find(c(:,1)>=xmin,1,'first'),2);

if nargin<2, plotstring='.'; end

x=x(:);
n = length(x);
c = [sort(x) (n:-1:1)'./n];

if nargout>0
    xout=c(:,1);
    yout=c(:,2);
end
if nargout==0 || nargin>1
    loglog(c(:,1),c(:,2),plotstring)
end
