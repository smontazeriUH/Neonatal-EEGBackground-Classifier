function [ASI]=cal_ASI(eeg_seg,fs_new,labels)

for i = 1 : length(labels)
    Index = strfind(labels{i}.', '-');
    lead(i) = str2double(labels{i}(Index-1));
end
lead(isnan(lead)) = [];
right = find(rem(lead,2)==0);
left = find(rem(lead,2)~=0);

% if ismember(patient,[1,2,3,4,5,6,7])
%     left = [1,3,5,7];
%     right = [12,14,16,18];
% else
%     left=[1,2,3,4,5,6,7,8];
%     right=[12,13,14,15,16,17,18,19];
% end

for j=1:length(right)
    l=left(j);
    r=right(j);
    signals=eeg_seg([l,r],:); % 1 and 5 are presenting channels number 1 and 5. ASI is calculated for these channels.

    [ASIval(j),~,~] = getASI(signals',fs_new);
end
ASI=mean(ASIval);

end 