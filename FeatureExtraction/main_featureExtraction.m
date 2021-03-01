%-------------------------------------------------------------------------------
% start extracting features from the preprocessed EEG data, and save in an 
% Xls file
%
% Paramaeters: 
%     path_patients   - directory of preprocessed EEG files stored in folders based on
%                           subjects ID
%     path_save       - directory for saving preprocessed data in folders 
%                           based on subjects ID
%
% Saeed Montazeri M., University of Helsinki
% Started: 10-11-2019
%-------------------------------------------------------------------------------
clc; clearvars; close all;

%% Initialization
% adding path of required functions
addpath('./SourceCode1/')
addpath(genpath('./SourceCode2/'))
addpath(genpath('./SourceCode3/'))

% patients path
path_patients = '../preprocessed/';

% save features to
path_save = '../features/';
mkdir(path_save)

%Get files
try
    [directorynames] = getsortedfiles(path_patients);
catch ME
    warning('path_patients is not valid (should be a valid address, organized as the provided example data)')
    rethrow(ME)
end

% length of epochs for feature calculation
epochs = [60 * 5]; % in second

% channel rejection threshold
artefactThreshold = 50; % in percent

% list of features to be extracted
try
    load('../Utils/featurelist_98.mat','featurelist');
catch ME
    rethrow(ME)
end

%% Main loop of feature extraction
for i = 1 : size(featurelist, 1)
    Headers(1, i) = featurelist(i);
end

tic
for patient = 1:size(directorynames,2) 
    understudySubject = directorynames{1,patient};
    disp(['Calculating features for ' understudySubject])
    patient_folder = [path_patients understudySubject '/'];
    
    % claculate features
    [FeatureMatrix] = init_featureExtraction(patient_folder,epochs,featurelist,understudySubject,artefactThreshold); 
    T = cell2table(num2cell(FeatureMatrix), 'VariableNames', Headers);
    writetable(T, [path_save,understudySubject,'.xls'],'FileType','spreadsheet');
end
toc
