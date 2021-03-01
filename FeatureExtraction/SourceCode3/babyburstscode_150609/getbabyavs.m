function avs=getbabyavs(j,sgfk)
%  avs = getbabyavs(j,[sgfk])
% Read in baby time series and output set of avs
%
% Optional input sgfk = [f k] for sgolay(...,k,f)

if nargin<2
    sgfk=[49 10]; % k,f = 10,49 = 18.55 Hz cutoff; 12,27=41 Hz
end

ypowfilt=getbabyypow(j,sgfk);

nthrs=50;
thr=nthrstest(ypowfilt,nthrs);

avs=extractbursts(ypowfilt,thr);
