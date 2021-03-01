function out = extractshapes2(bursts,durbins,prescaleavgs,onlyshapes,indices)
%  out = extractshapes2(bursts,durbins,prescaleavgs,onlyshapes,indices)
% Extract average shapes and associated statistics averaging over bursts
% binned by duration with bin edges durbins. Each bin is an interval [l,r).
% Optional argument indices to restrict to a subset of bursts.

if nargin<2 || isempty(durbins)
    % default duration ranges 
    %durbins = [10 25 50 100 250 500 1000];
    durbins = 50:100:1000;
    %durbins = 10:10:100;
end

if nargin<3
    prescaleavgs=1; % rescale each burst to have unit area and duration before averaging
end
if nargin<4
    onlyshapes=0; % don't calculate durs, areas, amps
end
if exist('indices','var')
    bursts=bursts(indices);
end

nbins=length(durbins)-1;

rawdursi=cellfun('length',bursts);

for j=nbins:-1:1
    dur=durbins(j); % rescaling to left endpt
    whichbursts=rawdursi>=durbins(j)&rawdursi<durbins(j+1);
    shape(j)=extractshapes_singledur(bursts,dur,whichbursts,prescaleavgs,onlyshapes);
end

catshapes=structcat2(shape); % concatenate so that scalars become vectors and vectors become cell arrays of vectors
out=catshapes;
out.durbins=durbins;
