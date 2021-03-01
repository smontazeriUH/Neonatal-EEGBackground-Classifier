function out=structcat2(s,forcecat)
%  out = structcat2(s,[forcecat])
% Concatenate struct array s into a 1x1 struct with the same fields (i.e.,
% concatenate the contents of each field)
%
% Fields of length 1 are concatenated
% Fields of length>1 are stored as elements of a cell array
%
% Optional arg forcecat to concatenate even if not all lengths are 0

out=s(1);
fnames=fieldnames(s);
fieldlens=zeros(length(s),length(fnames));
for j=1:length(s)
    fieldlens(j,:)=structfun(@numel,s(j));
end

if nargin<2
    forcecat=0;
end

if forcecat
    nocell=true(1,length(fnames)); % if forcing concatenation, not making cell arrays
else
    nocell=all(fieldlens==1,1);
end
needcelli=find(~nocell); % which fields will require cell arrays

for j=1:length(needcelli)
    out.(fnames{needcelli(j)})={out.(fnames{needcelli(j)})};
end

for j=2:length(s)
    for k=1:length(fnames)
        if nocell(k)
            out.(fnames{k})=[out.(fnames{k}) s(j).(fnames{k})];
        else
            out.(fnames{k})=[out.(fnames{k}) {s(j).(fnames{k})}];
        end
    end
end