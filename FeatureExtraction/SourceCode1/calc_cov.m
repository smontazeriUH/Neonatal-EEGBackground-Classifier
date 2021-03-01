function [co]=calc_cov(inst_amp,inst_freq)

d=cov(inst_amp(:),inst_freq(:));
co=d(1,2);