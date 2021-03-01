tic
%preproc
P3_P4=Segment_1(1,:)-Segment_1(2,:); %data extract P3-P4 EEG montage, e.g. load('6_1.mat')  
Fs = 256; %sampling rate, Hz
fcut=.2;  %cutoff Hz (high)
Wn = (fcut/(Fs/2));
N=1;
fr= 45;
k=10;
sgfk=[fr k];
nthrs=50; %numthrsbins
% 

%highpass
[B,A] = butter(N,Wn,'high');
eeghp = filtfilt(B,A,P3_P4); %apply highpass
%lowpass
sg=sgolay(k,fr); [h,w]=freqz(sg(ceil(size(sg,1)/2),:));
fcut=w(find(20*log10(abs(h))<-3,1,'first'))/2/pi*Fs;
fmin1=w(find(diff(abs(h))>0,1,'first'))/2/pi*Fs;

%hilber transform, envelope
eegd = abs(hilbert(eeghp));
data = sgolayfilt(eeghp,sgfk(2),sgfk(1))'; %apply lowpass
eegH=sgolayfilt(eegd,sgfk(2),sgfk(1))';
eegP=eegH.^2;

%shapes
thr=nthrstest(eegP,nthrs);
avs=extractbursts(eegP,thr); %bursts
durbins=[52 154 256 512 704 896 1088 1536]; % 200 ms to 6 s
shapes = extractshapes2(avs,durbins);

%slopes, cdfs
durations = horzcat(shapes.rawdurs{:});
areas = horzcat(shapes.rawareas{:});
bins=125;
out= adurplot(areas,durations,Fs,bins);

toc
