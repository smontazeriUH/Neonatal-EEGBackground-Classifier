


[b1,a1] = cheby2(6, 50, 97.35/256); % additional attenuation at 50Hz, 3dB~32Hz

% READ IN DATA / MAY NEED TO APPLY MONTAGE
addpath('C:\QIMRBerghofer_Stevenson\Neonatal_EEG_Data\preterm_Vienna\new_EDFs_full')
[dat, ~, ~, fs, scle, ~]  = read_edf('001_150411_000.edf');

dat = dat(1:8);
N = floor(length(dat{1})/fs(1));
dat1 = zeros(length(dat),N*fs(1));
for jj = 1:length(dat)
    dat1(jj,:) = dat{jj}(1:N*fs).*scle(jj);
end

%FIND ARTEFACTS and ZEROS
env2 = zeros(length(dat),N); 
for jj = 1:length(dat)
    for zz = 1:N
        r1 = (zz-1)*fs+1; r2 = zz*fs;
        dum = dat1(jj,r1:r2);
        env2(jj,zz) = max(abs((dum)));
    end
end

nart = zeros(size(dat1)); % An artefact reference where 1 is the presence of artefact and 0 is clean EEG
for jj = 1:length(dat)
    ref = find(env2(1,:)>400 | env2(1,:)==0);
    for kk = 1:length(ref)
        r1 = (ref(kk)-1)*fs+1; r2=ref(kk)*fs; 
        nart(jj,r1:r2) = 1; 
    end
end

% Might need to add a 50/60Hz filter here
dat2 = zeros(size(dat1));
for jj = 1:length(dat)
    dat2(jj,:) = filter(b1, a1, dat1(jj,:));
end

% SINGLE CHANNEL FEATURES ONLY - does not contain any multi-channel 

% THIS PATH IS WHERE THE BURST MEASURES ANTON HAS SHOULD SIT
addpath(genpath('C:\QIMRBerghofer_Stevenson\Document_and_Code\people\Australia\QIMRB\JamesR\burst_analysis\code\official_burst_analysis'))
addpath(genpath('C:\QIMRBerghofer_Stevenson\Document_and_Code\people\Australia\QIMRB\JamesR\burst_analysis\code\powerlaws_full_v0.0.10-2012-01-17'))

elen = fs(1)*3600; % 1h epochs, change as you see fit
olen = fs(1)*1800; % 50% overlap
block_no = floor(length(dat2)/(elen))-1; feats = cell(block_no,2);
for jj = 1:block_no
    r1 = (jj-1)*olen+1; r2 = r1+elen-1;
    dat3 = dat2(:,r1:r2);
    nart1 = nart(:,r1:r2);    
    for kk = 1:length(dat)
        kk
        if sum(nart1(kk,:))<0.25*length(nart1) % condition that does not process an 1h epoch if it is greater than 25% artefact
           fv1(kk,:) = burst_measures_original(dat3(kk,:), nart1(kk,:)); % burst metrics
           fv2(kk,:) = new_measures_bursts_outcome(dat3(kk,:), fs(1), nart1(kk,:)); % other measures including MSE, rEEG, and suppression curve
           [~, fv3(kk,:)] = amplitude_scaling(dat3(kk,:), nart1(kk,:)); % amplitude scaling 
        end
    end
    feat_out = [fv1 fv2 fv3];
end

%FEATURE LIST
flist{1} = 'Skewness (62.5-125ms)';
flist{2} = 'Skewness (125-250ms)';
flist{3} = 'Skewness (250-500ms)';
flist{4} = 'Skewness (500ms-1s)';
flist{5} = 'Skewness (1s-2s)';
flist{6} = 'Skewness (2s-4s)';
flist{7} = 'Skewness (4s-8s)';
flist{8} = 'Kurtosis (62.5-125ms)';
flist{9} = 'Kurtosis (125-250ms)';
flist{10} = 'Kurtosis (250-500ms)';
flist{11} = 'Kurtosis (500ms-1s)';
flist{12} = 'Kurtosis (1s-2s)';
flist{13} = 'Kurtosis (2s-4s)';
flist{14} = 'Kurtosis (4s-8s)';
flist{15} = 'Burst Number (62.5-125ms)';
flist{16} = 'Burst Number (125-250ms)';
flist{17} = 'Burst Number (250-500ms)';
flist{18} = 'Burst Number (500ms-1s)';
flist{19} = 'Burst Number (1s-2s)';
flist{20} = 'Burst Number (2s-4s)';
flist{21} = 'Burst Number (4s-8s)';
flist{22} = 'Alpha (PLT fit: area)';
flist{23} = 'Lambda (PLT fit: area)';
flist{24} = 'x min (PLT fit: area)';
flist{25} = 'LLR of fit (PLT fit: area)';
flist{26} = 'Alpha (PLT fit: bursts)';
flist{27} = 'Lambda (PLT fit: bursts)';
flist{28} = 'x min (PLT fit: bursts)';
flist{29} = 'LLR of fit (PLT fit: bursts)';
flist{30} = 'Slope area vs durations';
flist{31} = 'Intercept area vs durations';
flist{32} = 'Mean Burst Duration';
flist{33} = 'COV Burst Duration';
flist{34} = 'rEEG (delta)';
flist{35} = 'Suppression Curve';
flist{36} = 'MSE mean';
flist{37} = 'MSE max';
flist{38} = 'MSE (delta)';
flist{35} = 'Amplitude change with Scale - X^2'; % Quadratic fit to the amplitude change with scale from 1s to about 30 minutes
flist{36} = 'Amplitude change with Scale - X';
flist{37} = 'Amplitude change with Scale - C';


