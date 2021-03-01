%-------------------------------------------------------------------------------
% startPreprocessing: preparation and reading EDF files for one subject, 
%   preprocessing and creating saving files
%
% Syntax: preprocessedData = init_Preprocessing(patient_folder,fs_new,ElectricFreq)
%
% Inputs: 
%     patient_folder   - directory of EDF files
%     fs_new           - resampling frequency
%     ElectricFreq     - electricity frequency
%
% Outputs: 
%     preprocessedData - a cell consist of preprocessed EEG and other
%                           important information
%
% Example:
%     patient_folder='./NOGIN_1101/'; 
%
% Saeed Montazeri M., University of Helsinki
% Started: 10-11-2019
%-------------------------------------------------------------------------------
function [preprocessedData]=init_Preprocessing(patient_folder,fs_new,ElectricFreq)

if(nargin<2 || isempty(fs_new)), fs_new = []; end
if(nargin<3 || isempty(ElectricFreq)), ElectricFreq=50; end

% find .edf files
try
    exam_names = getsortedfiles(patient_folder,'edf');
catch ME
    warning('patient_folder is not valid (should be a valid address, organized as the provided example data)')
    rethrow(ME)
end

preprocessedData = cell(1,5);
for j= 1:size(exam_names,2)
    disp(j)
    try
        % read EEG data
        [dat, hdr, labels, fs, scle, offs, duration, start] = read_edf([patient_folder exam_names{1,j}]);
    catch ME
        rethrow(ME)
    end
    
    if isempty(fs_new)
        fs_new = fs(1);
    end
    
    if ~isempty(dat) && ~isempty(labels) && ~isempty(fs) && ~isempty(scle) && ~isempty(offs) && ~isempty(start)
        fs = fs(1); %sampling frequency
        % preprocessing function
        [eeg_data, ArtifactPercPerCh, channelList] = preprocess(dat,fs,scle,offs,labels,fs_new,ElectricFreq);
        preprocessedData(j,:) = {[eeg_data],[ArtifactPercPerCh],[fs_new],[start j],[channelList]};
    else
        warning(['Error in file' exam_names{1,j}])
    end
    
end

end