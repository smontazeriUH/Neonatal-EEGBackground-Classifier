function [tt,yy]=burstinterp_single_ends(y)
%  [t_int,burst_int]=burstinterp_single_ends(y)
% Interpolate the end points of burst y, so that first and last points are
% at 0, and tt contains nonintegers at the ends for the estimated crossing
% points 

% orig time axis
t=0:length(y)-1;

if y(1)>0 || y(end)>0
    error('endpt > 0, need both endpts <=0')
end

% new crossings
t(1)=-y(1)/(y(2)-y(1));
t(end)=t(end-1)+y(end-1)/(y(end-1)-y(end));

tt=t;
yy=y;
yy(1)=0;
yy(end)=0;
