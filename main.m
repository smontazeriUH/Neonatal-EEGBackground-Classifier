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
% Adding path of required functions
addpath('./Utils/')
addpath('./Preprocessing/')
addpath(genpath('./FeatureExtraction/'))

% Get patients data
path_patients = 'data/';

% Resampling with new frequency
fs_new = 64;

% Electricity frequency
ElectricFreq = 50; % default: 50Hz

% Get EDF filenames
[directorynames] = getsortedfiles(path_patients);

% Length of epochs for feature calculation
epochs = [60 * 5]; % in second

% Channel rejection threshold
artefactThreshold = 50; % in percent


classes = {'0,1,2' '3' '4' '5' '6'};

% List of features to be extracted and weights of trained classifier
try
    load('featurelist_98.mat','featurelist');
    
    load('classifier_all.mat')
catch ME
    rethrow(ME)
end

% For neonate number #n, where n = 1 : size(directorynames,2)
n = 1;

%% Main loop of preprocessing
tic

understudySubject = directorynames{1,n};
disp(['Preprocessing for ' understudySubject])
patient_folder = [path_patients understudySubject '/'];

% Preprocess data
[data] = init_Preprocessing(patient_folder,fs_new,ElectricFreq);

% Calculate features for each epoch
[FeatureMatrix] = init_featureExtraction(data,epochs,featurelist,understudySubject,artefactThreshold);

% Classifier output
[Tfit,~,~,PosteriorRegion] = predict(classificationSVM, FeatureMatrix(:,1:2));
%     [Tfit,TF0] = filloutliers(Tfit,'previous','movmedian',11);
smoothed1 = movmean(PosteriorRegion(:,1), 5);
smoothed2 = movmean(PosteriorRegion(:,2), 5);
smoothed3 = movmean(PosteriorRegion(:,3), 5);
smoothed4 = movmean(PosteriorRegion(:,4), 5);
smoothed5 = movmean(PosteriorRegion(:,5), 5);
smoothed = [smoothed5 smoothed4 smoothed3 smoothed2 smoothed1];
smoothed = smoothed ./ sum(smoothed, 2);

% plot BT trend
plotbt(smoothed,classes)
toc

% remove added paths
rmpath('./Utils/')
rmpath('./Preprocessing/')
rmpath(genpath('./FeatureExtraction/'))