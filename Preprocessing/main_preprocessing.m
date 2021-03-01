%-------------------------------------------------------------------------------
% starts preprocessing EEG data file in EDF format and saves preprocessed and
% synchronized EEG data in MAT file
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
addpath('../Utils/')
% Get patients data
path_patients = '../data/';
path_save = '../preprocessed/';

% Resampling with new frequency
fs_new = 64;
% Electricity frequency
ElectricFreq = 50; % default: 50Hz

% get EDF filenames
try
    [directorynames] = getsortedfiles(path_patients);
catch ME
    warning('path_patients is not valid (should be a valid address, organized as the provided example data)')
    rethrow(ME)
end

%% Main loop of preprocessing
tic
for patient = 1:size(directorynames,2) 
    understudySubject = directorynames{1,patient};
    disp(['Preprocessing for ' understudySubject])
    patient_folder = [path_patients understudySubject '/'];
    [data] = startPreprocessing(patient_folder,fs_new,ElectricFreq); %Get artifact detection data for each patient
    address = [path_save understudySubject];
    mkdir(address);
    save([address,'/',understudySubject,'.mat'],'data','-v7.3');
end
toc
