function H_shannon = cal_shanon(eeg_seg)

if sum(abs(eeg_seg))==0
    H_shannon=0;
else
    H_shannon=entropy(eeg_seg);
end
