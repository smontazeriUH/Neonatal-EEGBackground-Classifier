function [bsi_index_ref]=estimate_bsi(eeg_seg,fs_new,frange,labels)

for i = 1 : length(labels)
    Index = strfind(labels{i}.', '-');
    lead(i) = str2double(labels{i}(Index-1));
end
lead(isnan(lead)) = [];
right = find(rem(lead,2)==0);
left = find(rem(lead,2)~=0);

% if ismember(patient,[1,2,3,4,5,6,7])
%     left = [1,2,3,4];
%     right = [5,6,7,8];
% else
%     left=[1,2,3,4,5,6,7,8];
%     right=[12,13,14,15,16,17,18,19];
% end

for i=1:length(left)
    l=left(i);
    r=right(i);
    signals=eeg_seg([l,r],:);
    
    bs(i) = bsi(signals(1,:), signals(2,:), fs_new, frange);
end
bsi_index_ref=mean(bs);

end