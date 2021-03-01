function [FD]=calc_FD(eeg_seg)
FD = Higuchi1Dn(eeg_seg,length(eeg_seg)/10);
