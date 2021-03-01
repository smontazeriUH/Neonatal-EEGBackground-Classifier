%-------------------------------------------------------------------------------
% This script preprocesses EEG data file in EDF format, then extracts
% features from each epoch and visualises classifier's prediction for
% epochs
%
% Paramaeters: 
%     path_patients   - directory of EDF files stored in folders based on
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
addpath('./Utils/')
addpath('./Preprocessing/')
addpath(genpath('./FeatureExtraction/'))

% Get patients data
path_patients = 'data/';

% Resampling with new frequency
fs_new = 64;
% Electricity frequency
ElectricFreq = 50; % default: 50Hz

% get EDF filenames
[directorynames] = getsortedfiles(path_patients);

% length of epochs for feature calculation
epochs = [60 * 5]; % in second

% channel rejection threshold
artefactThreshold = 50; % in percent

% list of features to be extracted
try
    load('featurelist_98.mat','featurelist');
catch ME
    rethrow(ME)
end

%% Main loop of feature extraction
for i = 1 : size(featurelist, 1)
    Headers(1, i) = featurelist(i);
end

%% Main loop of preprocessing
tic
for patient = 1:size(directorynames,2) 
    understudySubject = directorynames{1,patient};
    disp(['Preprocessing for ' understudySubject])
    patient_folder = [path_patients understudySubject '/'];
    % preprocess data
    [data] = init_Preprocessing(patient_folder,fs_new,ElectricFreq); 
    % calculate features for each epoch
    [FeatureMatrix] = init_featureExtraction(data,epochs,featurelist,understudySubject,artefactThreshold); 
    % classifiers output
    
end
toc


% remove added paths
rmpath('./Utils/')
rmpath('./Preprocessing/')
rmpath(genpath('./FeatureExtraction/'))