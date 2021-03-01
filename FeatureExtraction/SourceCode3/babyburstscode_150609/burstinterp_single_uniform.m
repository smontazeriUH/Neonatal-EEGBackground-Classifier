function [tt,yy]=burstinterp_single_uniform(y,T,rescale,method)
%  [t_int,burst_int]=burstinterp_single_uniform(y,T,rescale,method)
% Interpolate burst y onto uniformly-spaced points from 0 to T (T+1 points
% in total).
%
% First and last points are set to 0 using burstinterp_single_ends (linear
% interpolation). 
%
% Optional flag rescale=1 (default) to use T+1 points from 0 to 1
%               rescale=0 to use T+1 points from 0 to T (integer)
%               rescale=2 to use T+1 points from 0 to original t(end)
%                         (i.e., preserving interpolated duration)

if nargin<3
    rescale=1;
end
if nargin<4
    method='linear';
end

% interpolate ends first, giving nonuniform t axis
[t_endint,y_endint]=burstinterp_single_ends(y);
t_endint=t_endint-t_endint(1); % shift to have t(1)=0

% new (rescaled) time axis
tt=linspace(0,1,T+1);

% interpolate
yy=interp1(t_endint/t_endint(end),y_endint,tt,method);

if rescale==0
    tt=tt*T;  % rescale to have integer T at the upper endpt
elseif rescale==2
    tt=tt*t_endint(end);  % rescale to have the interpolated duration at the upper endpt
end