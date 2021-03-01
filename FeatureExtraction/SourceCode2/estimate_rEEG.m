function [reeg,m_med] = estimate_rEEG(eeg_seg, fs2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

epl = fs2*2; N = length(eeg_seg);
block_no = N/epl;
for ii = 1:block_no;
    q1 = (ii-1)*epl+1; q2 = q1+epl-1;
    rEEG_i(ii) = max(eeg_seg(q1:q2))-min(eeg_seg(q1:q2));
end

%Median of rEEG
m_med=median(rEEG_i);

%difference between 90th and 10th percentile
n=length(rEEG_i);
ind_high=n*0.9;
ind_low=n*0.1;
r=sort(rEEG_i);

if mod(ind_high,1)==0%rem(ind_high)==0
    r_high=(r(ind_high)+r(ind_high+1))/2;
else
    ind_high=ceil(ind_high);
    r_high=r(ind_high);
end

if mod(ind_low,1)==0
    r_low=(r(ind_low)+r(ind_low+1))/2;
else
    ind_low=ceil(ind_low);
    r_low=r(ind_low);
end

reeg= r_high-r_low;
end

