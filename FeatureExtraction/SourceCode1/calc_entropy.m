function [entropy]=calc_entropy(eeg_seg)
for i=1:size(eeg_seg,1)
    [b,~] = hist(eeg_seg(i,:), sqrt(length(eeg_seg(i,:))));
    x = b./sum(b);
    y=x.*log(x);
    ref = isnan(y);
    val(i)= -1*sum(y(find(ref==0)));
    %val(i) = -sum(p.*log2(p));
    %val(i)=wentropy(eeg_seg(i,:),'shannon');
end
entropy=mean(val);
end
% % % 
% % % 
% % % 
% % % [b,n] = hist(y, sqrt(length(y)));
% % % x = b./sum(b);
% % % N=size(x);
% % % y=x.*log(x);
% % % ref = isnan(y);
% % % se= -1*sum(y(find(ref==0)));