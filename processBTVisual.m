%% processBTVisual.m
% Visualise Background Trend (BT) for EDF files (redocrings for one 
% subject) inside the provided directory
%
%% Inputs:
%   pathToPatient   : EDF files directory
%% Outputs:

%% Example:
%
% patient_folder = 'Data/neonate1/';
% processBTVisual(patient_folder)
%%
% Saeed Montazeri M.
% Jan 23, 2021
% Last update : Feb 14, 2021

function processBTVisual(pathToPatient)
%% Initialization 
% Adding path of required functions
addpath('./Utils/')
addpath('./Preprocessing/')
addpath(genpath('./FeatureExtraction/'))

% Resampling with new frequency
fs_new = 64;

% Electricity frequency
ElectricalFreq = 50; % default: 50Hz

% Length of epochs for feature calculation
epochs = [60 * 5]; % in second

% Channel rejection threshold
artefactThreshold = 50; % in percent

classes = {'6' '5' '4' '3' '0,1,2'};

% List of features to be extracted and weights of trained classifier
try
    load('featurelist_98.mat','featurelist');
    
    load('classifier_all.mat')
catch ME
    rethrow(ME)
end

% Preprocess data
disp(['Preprocessing ...'])
[data] = init_Preprocessing(pathToPatient,fs_new,ElectricalFreq);

% Calculate features for each epoch
disp(['Feature calculation ...'])
[FeatureMatrix] = init_featureExtraction(data,epochs,featurelist,'',artefactThreshold);

% Classifier output
disp(['Initializing BT trend ...'])
standardFeats = (FeatureMatrix - repmat(meanFeats,size(FeatureMatrix,1),1))./repmat(stdFeats,size(FeatureMatrix,1),1);

% Predict
[Tfit,~,~,PosteriorRegion] = predict(CMdl, standardFeats);

% Smooth predicted data
smoothed1 = movmean(PosteriorRegion(:,1), 5);
smoothed2 = movmean(PosteriorRegion(:,2), 5);
smoothed3 = movmean(PosteriorRegion(:,3), 5);
smoothed4 = movmean(PosteriorRegion(:,4), 5);
smoothed5 = movmean(PosteriorRegion(:,5), 5);
smoothed = [smoothed5 smoothed4 smoothed3 smoothed2 smoothed1];
smoothed = smoothed ./ sum(smoothed, 2);

% plot BT trend
plotbt(smoothed,classes)

% Remove path
rmpath('./Utils/')
rmpath('./Preprocessing/')
rmpath(genpath('./FeatureExtraction/'))