function testASI()
% Computes ASI for a set of files defined by folderpath + filenames cell array.
%
% Note: requires BIOSIG toolbox for MATLAB to read .edf files.

filenames = {'157-10K';'308-08K';'930-09K';'982-09K';'982-09K_150s';'ELE10-460';'ELE10-630';...
    '1102-07K';'938-08K';'1090-08';'ELE10-597';'ELE10-907';'ELE10-726';'ELE11-37';'143-08K';'1178-08K_5m';'313-08K';'518-07';...
    '179-07';'804-07K';'1198-08K';'100-09K';'815-08K';'AEDcontr_3-5m';'AEDcontr-2_5m';'AEDcontr-1_210s';'831-08K';'445-08K';...
    '955-08K';'ELE10-471';'ELE10-670';'ELE10-756';'ELE11-16';'31-08K'};

% Ground truth grades of synchrony 
asyncgrades = [3,3,3,3,3,2,2,3,3,2,2,1,1,2,2,2,3,1,3,2];
syncgrades = zeros(1,14);

grades = [asyncgrades syncgrades];

folderpath = '/Users/orasanen/speechdb/EEG/SYNC-ASYNC_data/sync-async-dataset/Async_dataset_edf-converted/';

% Compute overall ASI's
for filnum = 1:length(grades)       
    filename = [folderpath filenames{filnum} '_edf.edf'];        
    A(filnum) = ASI(filename);
end
 
    


