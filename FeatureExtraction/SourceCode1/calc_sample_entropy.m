function [se]=calc_sample_entropy(eeg_seg)

for i=1:size(eeg_seg,1)
    val(i)=sample_entropy(eeg_seg(i,:), 3, 0.2);
end
se=mean(val);
end