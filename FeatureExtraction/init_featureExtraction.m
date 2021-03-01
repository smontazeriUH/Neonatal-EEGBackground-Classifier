%-------------------------------------------------------------------------------
% startCalculation: preparation and reading preprocessed EEG files for one subject, 
%   and creating features
%
% Syntax: feat_matrices=startCalculation(patientDataorFolder,epochs,features,score_file,patientID)
%
% Inputs: 
%     patientDataorFolder   - directory of MAT EEG files
%     epochs                - epoch length
%     features              - list of features
%     score_file            - directory of scores file
%     patientId             - name/ID of subject
%
% Outputs: 
%     feat_matrices    - feature matrix
%
% Saeed Montazeri M., University of Helsinki
% Started: 10-11-2019
%-------------------------------------------------------------------------------
function [feat_matrices]=init_featureExtraction(patientDataorFolder,epochs,features,patientID,artefactThreshold)

% load Preprocessed EEG data
try
    if isstring(patientDataorFolder)
        load([patientDataorFolder patientID '.mat']);
    else
        data = patientDataorFolder;
    end
catch ME
    rethrow(ME)
end

start_time = cell2mat(data(:,4));
indices = datenum(start_time(:,1:6))+start_time(:,7);
[~,ind_sort] = sort(indices);
  
feat_matrices = [];

for j = 1:length(ind_sort)
    disp(j)
    ch = ind_sort(j);
    eeg_data = data{ch,1};
    ArtifactPercPerCh = data{ch,2};
    fs_new = data{ch,3}; %sampling frequency
    labels = data{ch,5};
    data(ch,:) = {[] [] [] [] []};
    
    % calculating features for all channels at the time
    [feats]=calEpochFeatures(eeg_data,fs_new,epochs,...
        features,ArtifactPercPerCh,labels,artefactThreshold);
    clear eeg_data
    
    % fill in lost features with an interpolated value from neighbours
    f = sum(isnan(feats),2);
    g = find(f==length(features));
    Featuremat = feats;
    if ~isempty(g)
        for iter = 1:length(g)
            if iter == 1 && g(iter) > 2
                Featuremat(g(iter),:) = nanmean([feats(g(iter)-1,:); feats(g(iter)-2,:)]);
            elseif iter ~= 1 && g(iter-1) ~= g(iter) -1 && isempty(find(g == g(iter)-2, 1))
                Featuremat(g(iter),:) = nanmean([feats(g(iter)-1,:); feats(g(iter)-2,:)]);
            elseif g(iter) > 3 && g(iter-1) == g(iter) -1 && isempty(find(g == g(iter)-2, 1)) && isempty(find(g == g(iter)-3, 1))
                Featuremat(g(iter),:) = nanmean([feats(g(iter)-2,:); feats(g(iter)-2,:); feats(g(iter)-3,:)]);
            end
        end
    end
    f = sum(isnan(Featuremat),2);
    g = find(f==length(features));
    if ~isempty(g)
        for iter = length(g):-1:1
            if iter == length(g) && g(iter) < size(Featuremat,1)-1
                Featuremat(g(iter),:) = nanmean([feats(g(iter)+1,:); feats(g(iter)+2,:)]);
            elseif iter ~= length(g) && g(iter+1) ~= g(iter) +1 && isempty(find(g == g(iter)+2, 1))
                Featuremat(g(iter),:) = nanmean([feats(g(iter)+1,:); feats(g(iter)+2,:)]);
            elseif g(iter) < size(Featuremat,1)-2 && g(iter+1) == g(iter) +1 && isempty(find(g == g(iter)+2, 1)) && isempty(find(g == g(iter)+3, 1))
                Featuremat(g(iter),:) = nanmean([feats(g(iter)+2,:); feats(g(iter)+2,:); feats(g(iter)+3,:)]);
            end
        end
    end
    
    feat_matrices=[feat_matrices;Featuremat];
    
end

end