function [t_int,bursts_int]=burstinterp(rawbursts,type,T,rescale)
%  [t_int,bursts_int]=burstinterp(rawbursts,type)
% Interpolate bursts in cell array rawbursts depending on type:
% type='ends' : just the end points, so that first and last points are at 0
%               and t_int contains nonintegers at the ends for the
%               estimated crossing point

% type='uniform' : put onto a uniform grid
%                  input T is an integer, burst t indices from 0 to T
%                  rescale=0 -> T+1 points from 0 to T
%                  rescale=1 -> T+1 points from 0 to 1
%                  rescale=2 -> T+1 points from 0 to interpdur

% write function to handle just 1 burst? then can build it into code to do
% all end points, or to do all bursts of given durations onto uniform axes,
% etc...

if nargin<2
    type='ends';
end

t_int=cell(size(rawbursts));
bursts_int=cell(size(rawbursts));

switch type
    case 'ends'
        for j=1:length(rawbursts)
            [t_int{j},bursts_int{j}]=burstinterp_single_ends(rawbursts{j});
        end
    case 'uniform'
        for j=1:length(rawbursts)
            [t_int{j},bursts_int{j}]=burstinterp_single_uniform(rawbursts{j},T,rescale);
        end
    otherwise
        error('invalid case')
end

