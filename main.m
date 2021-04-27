%-------------------------------------------------------------------------------
% This script preprocesses EEG data file in EDF format, then extracts
% features from each epoch and visualises classifier's prediction for
% epochs
%
% Paramaeters: 
%     pathToPatient   - directory of EDF files stored in a folder 
%
% Saeed Montazeri M., University of Helsinki
% Started: 10-11-2019
%-------------------------------------------------------------------------------
clc; clearvars; close all;

%% Initialization 

% Get patients data
pathToPatient = 'data/b3/';

%% Process
tic
processBTVisual(pathToPatient)
toc
