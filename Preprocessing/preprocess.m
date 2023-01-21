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
% Updated on 13-01-2023 to become compatiable with Tampere dataset
%-------------------------------------------------------------------------------
function [eeg_data,artefact_ratePerCh,channelList] = preprocess(dat,fs,scle,offs,labels,fs_new,ElectricFreq)

% indicate usefull EEG channels and remove mastoids
% based on international 10-20 system
leads = {'Fp1','Fp2','F3','F4','F7','F8','C3','C4','T3',...
    'T4','P3','P4','T5','T6','O1','O2','A1','A2','Fpz','Fz','Cz','Pz'};

% remove "EEG" from the begining of labels
for ich = 1 : length(labels)
    if strncmp(labels{ich},'EEG ',4)
        labels{ich} = labels{ich}(5:end);
    end
end

% Make montages and preprocess
[eeg_data, artefact_ratePerCh, channelList] = make_montages_preprocess(leads, ...
    labels, dat, scle, offs, fs, fs_new, ElectricFreq);

end

function [eeg_data, artefact_ratePerCh, channelList] = make_montages_preprocess(leads, ...
    labels, dat, scle, offs, fs, fs_new, ElectricFreq)
eeg_data = [];
artefact_ratePerCh = [];
channelList = cell(0);
for ich = 1 : length(leads)

    fch = find(strncmp(labels,leads{ich},length(leads{ich})));
    if ~isempty(fch)

        for ifch = 1 : length(fch)

            if contains(labels{fch(ifch)}.','-')

                if ~contains(labels{fch(ifch)}.','REF') && ~contains(labels{fch(ifch)}.','ref') &&...
                        ~contains(labels{fch(ifch)}.','Ref')

                    % bipolar
                    raw_data = double(dat{fch(ifch)}).*scle(fch(ifch))-offs(fch(ifch)); %Scaling the signal to microvolts
                    [eeg_tmp, art_tmp] = preprocess_run(raw_data,fs,fs_new,ElectricFreq,1);
                    eeg_data = [eeg_data; eeg_tmp];
                    artefact_ratePerCh = [artefact_ratePerCh; art_tmp];
                    channelList = [channelList, labels{fch(ifch)}];
                    clear eeg_tmp art_tmp raw_data
                else

                    % monopolar
                    raw_data = double(dat{fch(ifch)}).*scle(fch(ifch))-offs(fch(ifch)); %Scaling the signal to microvolts
                    [eeg_tmp, art_tmp] = preprocess_run(raw_data,fs,fs_new,ElectricFreq,0);
                    eeg_data = [eeg_data; eeg_tmp];
                    artefact_ratePerCh = [artefact_ratePerCh; art_tmp];
                    channelList = [channelList, labels{fch(ifch)}];
                    clear eeg_tmp art_tmp raw_data
                end

            else
                % monopolar
                if ~strncmp('A1',labels{fch(ifch)}.',2) && ~strncmp('A2',labels{fch(ifch)}.',2) && ...
                        ~strncmp('Fpz',labels{fch(ifch)}.',3) && ~strncmp('Fz',labels{fch(ifch)}.',2) &&...
                        ~strncmp('Cz',labels{fch(ifch)}.',2) && ~strncmp('Pz',labels{fch(ifch)}.',2)

                    raw_data = double(dat{fch(ifch)}).*scle(fch(ifch))-offs(fch(ifch)); %Scaling the signal to microvolts
                    [eeg_tmp, art_tmp] = preprocess_run(raw_data,fs,fs_new,ElectricFreq,0);
                    eeg_data = [eeg_data; eeg_tmp];
                    artefact_ratePerCh = [artefact_ratePerCh; art_tmp];
                    channelList = [channelList, labels{fch(ifch)}];
                    clear eeg_tmp art_tmp raw_data
                end
            end
        end
    end
end
end

function [eeg_data, artefact_rate] = preprocess_run(raw_data,fs,fs_new,ElectricFreq,FLGbipolar)
%% preprocessing per channel

% Notch filter
[bn, an] = FilterNotch(fs,ElectricFreq);
% BandPass filter
[bb, ab] = FilterBandPass(fs);

% first stage artifact removal (thresholding)
try
    [artifactfree, artifact_data] = firstStageAR(raw_data,fs,FLGbipolar);
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
    eeg_data = resample(filtered_data,fs_new,fs); %New sampling frequency will be fs_new Hz
    clear filtered_data
else
    eeg_data = [];
end

% Artefact rate
artefact_rate = sum(artifact_data,2) ./ length(artifact_data(1,:));

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
function [artefactfree, artefactDetected] = firstStageAR(rawData, Fs, FLGbipolar)
%% set parameters
if ~FLGbipolar
    ART_HIGH_VOLT   = 500;   % in mirco Vs
else
    ART_HIGH_VOLT   = 250;   % in mirco Vs
end
ART_TIME_COLLAR = 2/Fs;  % time collar (in seconds) around high-amplitude artefact

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
