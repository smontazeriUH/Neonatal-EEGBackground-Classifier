function fvd = burst_measures_original(dat1, art, Fs)



%Fs = fs; %sampling rate, Hz
%fcut=.2;  %cutoff Hz (high)
%Wn = (fcut/(Fs/2));
%N=1;
fr= 45;
k=10;
sgfk=[fr k];
nthrs=50; 

%fv = zeros(length(ref), 33);
% P3_P4 = dat1;

%highpass (already applied)
%[B,A] = butter(N,Wn,'high');
%eeghp = filtfilt(B,A,P3_P4); %apply highpass
%sg=sgolay(k,fr); %lowpass

%hilber transform, envelope
eegd = abs(hilbert(dat1));
eegH=sgolayfilt(eegd,sgfk(2),sgfk(1))';
eegP=eegH.^2;
eegP(art==1) = 0;

%shapes
thr=nthrstest(eegP,nthrs);
avs=extractbursts(eegP,thr); %bursts

durs=length(unique(cellfun('length',avs)/Fs)); % in s

if size(avs,2) > 2 && durs > 3
    %durbins=[52 154 256 512 704 896 1088 1536]; % 200 ms to 6 s
    durbins=[16 32 64 128 256 512 1024 2048]; % 62.5 to 8s
    shapes = extractshapes2(avs,durbins);
    avstats=extractavstats(avs, Fs, 'raw');
    fvd = [shapes.skewc shapes.kurc shapes.nbursts/sum(shapes.nbursts)];
    fvd = [fvd avstats.raw.areas.fits.powerexp.exponent avstats.raw.areas.fits.powerexp.rate avstats.raw.areas.fits.powerexp.xmin avstats.raw.areas.fits.powerexp.loglike];
    fvd = [fvd avstats.raw.durs.fits.powerexp.exponent avstats.raw.durs.fits.powerexp.rate avstats.raw.durs.fits.powerexp.xmin avstats.raw.durs.fits.powerexp.loglike];
    fvd = [fvd avstats.raw.durs.vs.areas.bydur.fits.meanlinear mean(avstats.raw.durs.x) mean(avstats.raw.durs.x)/std(avstats.raw.durs.x) thr];
else
    fvd = zeros(1, 34);
end







