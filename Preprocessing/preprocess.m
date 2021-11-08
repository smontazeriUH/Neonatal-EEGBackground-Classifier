%-------------------------------------------------------------------------------
% preproces: preprocessing EEG signal
%
% Syntax: [eeg_data,ArtifactPercPerCh,channelList] = preproces(dat,fs,scle,offs,labels,fs_new,ElectricFreq)
%
% Inputs: 
%     dat               - Raw EEG data
%     fs                - sampling frequency
%     scle              - scale of signal
%     offs              - offset
%     labels            - label of channels
%     fs_new            - resampling frequency
%     ElectricFreq      - electricity frequency
%
% Outputs: 
%     eeg_data          - preprocessed signal
%     ArtifactPercPerCh - proportion of detected artifacts per channel
%     channelList       - list of channels and couplings
%
% Saeed Montazeri M., University of Helsinki
% Started: 10-11-2019
%-------------------------------------------------------------------------------
function [eeg_data,ArtifactPercPerCh,channelList] = preprocess(dat,fs,scle,offs,labels,fs_new,ElectricFreq)

% Notch filter
[bn, an] = FilterNotch(fs,ElectricFreq);
% BandPass filter
[bb, ab] = FilterBandPass(fs);

% indicate usefull EEG channels and remove mastoid 
last_channel = find(strncmp('EEG P4',labels,6));
channels = 1 : last_channel;
mastoid_A1 = find(strncmp('EEG A1',labels(channels),6));
if ~isempty(mastoid_A1)
    channels = [channels(1 : mastoid_A1-1) channels(mastoid_A1+1 : end)];
end
mastoid_A2 = find(strncmp('EEG A2',labels(channels),6));
if ~isempty(mastoid_A2)
    channels = [channels(1 : mastoid_A2-1) channels(mastoid_A2+1 : end)];
end
channelList = labels(channels);

dat(1,max(channels)+1:end)=cell(1);
%% preprocessing per channel
myCh = 1;
for i = 1:length(channels)
    ch = channels(i);
    raw_data = double(dat{1,ch}).*scle(ch)-offs(ch); %Scaling the signal to microvolts
    
    % first stage artifact removal (thresholding)
    try
        [artifactfree, artifact_data(myCh,:)] = firstStageAR(raw_data,fs);
    catch ME
        warning('Could NOT processs artefact removal.')
        prompt = 'Continue without artefact rejection? Y/N: \n';
        str = input(prompt,'s');
        if isempty(str) || strcmp(str, 'Y') ~= 1
            str = 'N';
        end
        if strcmp(str, 'N') == 1
            rethrow(ME)
        else
            artifactfree = raw_data;
        end
    end
    clear raw_data
        
    if(~all(isnan(artifactfree)))
        
        % filtering
        % replace NaNs
        [artifactfree,inans]=naninterp(artifactfree);
        
        % filtering
        filtered_data = filtfilt(bn,an,artifactfree);
        clear artifactfree
        filtered_data = filtfilt(bb,ab,filtered_data);
        
        % swap back in the NaNs:
        if(~isempty(inans))
            filtered_data(inans) = NaN;
        end
        
        % Resampling with new frequency
        data = resample(filtered_data,fs_new,fs); %New sampling frequency will be fs_new Hz
        clear filtered_data
        eeg_data(myCh,:) = data';
        clear data
    else
        eeg_data = [];
        break
    end
    
    myCh = myCh + 1;
    dat(1,ch)=cell(1);
end
clear dat

% percentage of artifact in each channel
ArtifactPercPerCh = sum(artifact_data,2) ./ length(artifact_data(1,:));

%% to see filtered data
% x = eeg_data(1,:);
% y = fft(x);
% 
% n = length(x);          % number of samples
% f = (0:n-1)*(fs/n);     % frequency range
% power = abs(y).^2/n;    % power of the DFT
% 
% plot(f,power)
% xlabel('Frequency')
% ylabel('Power')

end

%-------------------------------------------------------------------------------
% firstStageAR: first stage of artefact detection and rejection in our
% algorithm
%
% Syntax: [artifactfree, artifactDetected] = firstStageAR(rawData, Fs)
%
% Inputs: 
%     rawData          - Raw EEG data
%     Fs               - sampling frequency
%
% Outputs: 
%     artefactfree     - artefact free signal
%     artefactDetected - indicating location of detected artefacts
%
% Saeed Montazeri M., University of Helsinki
% Started: 10-11-2019
%-------------------------------------------------------------------------------
function [artefactfree, artefactDetected] = firstStageAR(rawData, Fs)
%% set parameters
ART_HIGH_VOLT   = 500;   % in mirco Vs
ART_TIME_COLLAR = 1/Fs;  % time collar (in seconds) around high-amplitude artefact

ART_ELEC_CHECK = 1;      % minimum length required for electrode check (in seconds)

N = length(rawData);
artefactfree = rawData;

% 1. electrode-checks (continuous row of zeros)
x_channel=rawData;
x_channel(x_channel~=0)=1;
irem=zeros(1,N);    
[lens,istart,iend]=len_cont_zeros(x_channel,0);
ielec=find(lens>=(ART_ELEC_CHECK*Fs));

for m=ielec
    irun=[istart(m)-1:iend(m)+1];
    irun(irun<1)=1; irun(irun>=N)=N;
    irem(irun)=1;
    artefactfree(irun)=NaN;
end

% 2. high-amplitude artefacts
art_coll=round(ART_TIME_COLLAR*Fs);
irem=zeros(1,N);     

thres_upper=ART_HIGH_VOLT;
ihigh=find(abs(rawData-nanmean(rawData))>thres_upper);
if(~isempty(ihigh))
    for p=1:length(ihigh)
        irun=(ihigh(p)-art_coll):(ihigh(p)+art_coll);
        irun(irun<1)=1;  irun(irun>N)=N;               
        irem(irun)=1;
    end
end
artefactfree(irem==1)=NaN;

artefactDetected = zeros(size(artefactfree,1), size(artefactfree,2));
artefactDetected(isnan(artefactfree)) = 1;
end

function [b, a] = FilterNotch(fsamp,ElectricFreq)
% Notch filter
% low-pass frequency
nf_f_low = ElectricFreq-0.5;
% high-pass frequency
nf_f_high = ElectricFreq+0.5;
% order
order = 6; 
% ripple factor
RippleF = 80;
% Chebyshev II filter used
[b,a]=cheby2(order,RippleF,[nf_f_low nf_f_high]/(fsamp/2),'stop');
end

function [b, a] = FilterBandPass(fsamp)
% bandpass (0.5-35Hz)
% high-pass frequency
bp_f_low = 0.5;
% low-pass frequency
bp_f_high = 35;
% order
order = 5; 
% ripple factor
RippleF = 80;
% Chebyshev II filter used
[b,a]=cheby2(order,RippleF,[bp_f_low bp_f_high]/(fsamp/2),'bandpass');
end

function [X,nans]=naninterp(X,method)
%---------------------------------------------------------------------
% fill 'gaps' in data (marked by NaN) by interpolating
% John M. O' Toole, University College Cork
% Started: 31-10-2013
%---------------------------------------------------------------------
if(nargin<2 || isempty(method)), method='linear'; end
N=length(X);
nans=find(isnan(X));

% replace leading or trailing NaNs with zeros
istart=find(~isnan(X),1,'first');
iend=find(~isnan(X),1,'last');

if(~isempty(istart) && istart>1)
    X(1:istart)=0;
end
if(~isempty(iend) && iend<N)
    X((iend+1):N)=0;
end

iOthernans=find(isnan(X));
if(isempty(iOthernans))
  return;
elseif(length(iOthernans)==1)
  if(iOthernans>1)
    X(iOthernans)=X(iOthernans-1);
  else
    X(iOthernans)=X(iOthernans+1);
  end
else
    try
        X(iOthernans)=interp1(find(~isnan(X)), X(~isnan(X)), iOthernans, method);
    catch
        error('linear interpolation with NaNs');
    end
end
end