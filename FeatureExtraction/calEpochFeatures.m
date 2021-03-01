%-------------------------------------------------------------------------------
% get_features: partition EEG file based on epoch length and extract features for each epoch
%
% Syntax: [feat_matrix] = calEpochFeatures(eeg_data,fs,Timing,epochLength,features,ind,shift,DateTime, ArtifactPercPerCh)
%
% Inputs: 
%     eeg_data            - EEG signal
%     fs	              - sampling frequency
%     Timing              - epoch timing
%     epochLength         - epoch length
%     features            - list of features
%     ind                 - indice of synchrony
%     shift               - time shift of synchronization
%     DateTime            - date and time in score file
%     ArtifactPercPerCh   - percentage of detected artefact in each channel
%
% Outputs: 
%     feat_matrix         - features
%
% Saeed Montazeri M., University of Helsinki
% Started: 10-11-2019
%-------------------------------------------------------------------------------
function [feat_matrix] = calEpochFeatures(eeg_data,fs,epochLength,features,ArtifactPercPerCh,labels,artefactThreshold)

%% Initializing 
eeg_length = length(eeg_data); %number of samples in EEG
feat_matrix = NaN(1, length(features)); %features for one epoch length

acceptedChans = ArtifactPercPerCh < 0.25;
if sum(acceptedChans) == 0
    warning('Feature extraction failed: severe artifacts in all the channels')
end

%% Settings for windowing
% number of samples to skip
start_shift = 0 * fs;
t0 = start_shift;
if t0 == 0
    t0 = 1;
end
step = (epochLength * fs) - 1;
t1 = t0 + step;
cnt = 1; %step counter
%% Moving the window through eeg data and calculating features

while (t1 <= eeg_length) %as long as the last sample of the window is not beyond the EEG signal end
    
    eeg_seg = [];
    eeg_seg = eeg_data(acceptedChans,int64(t0):int64(t1));
    feats = extractFeatures(eeg_seg,fs,features,labels,artefactThreshold);
    
    feat_matrix(cnt,:) = feats;
    
    if isempty(feats)
        disp(['Empty feature at epoch: ' num2str(cnt)])
    end
    
    % Update t0 and t1 based on regular epoch length
    t0 = t0 + step + 1;
    t1 = t1 + step + 1;
    
    cnt = cnt + 1; %update step counter
end
end