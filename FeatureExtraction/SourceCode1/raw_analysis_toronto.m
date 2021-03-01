function [ZC1d, ZC2d, V1d, V2d] = raw_analysis_toronto(win)
% edited by Saeed 0n 18.02.20

%%% get vector of 1st derivatives
vec_1d = diff(win);
%%% get vector of second derivatives
vec_2d = diff(vec_1d);
%%% variance of 2nd derivative
V1d = var(vec_1d);
V2d = var(vec_2d);

%%% get zero crossings of 1st derivative
% ZC1d = zero_crossing(vec_1d');
% Zero_crossings=cell(1);
ZC1d = zero_crossing(vec_1d);

%%% get zero crossings of 2nd derivative
% Zero_crossings=cell(1);
ZC2d = zero_crossing(vec_2d);
