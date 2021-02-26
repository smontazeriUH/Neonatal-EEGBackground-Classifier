%-------------------------------------------------------------------------------
% getsortedfiles: Get specific type or all files in address and sort them
% in a natural order way
%
% Syntax: [directorynames] = getsortedfiles(address,type)
%
% Inputs: 
%     address   - directory
%     type      - file type in string format
%
% Outputs: 
%     directorynames - filename of finded and sorted files
%
% Example:
%     address='./classifiers'; 
%     type='mat'; 
%
%     [directorynames] = getsortedfiles(address,type);
% 

% Saeed Montazeri M., University of Helsinki
% Started: 10-11-2019
%-------------------------------------------------------------------------------
function [directorynames] = getsortedfiles(address,type)

if nargin < 2 || strcmp(type,'all')==1
    files = dir(address);
    directoryNames = {files.name};
    directoryNames = directoryNames(~ismember(directoryNames,{'.','..','.DS_Store'}));
    [directorynames] = sort_nat(directoryNames);
elseif strcmp(type,'all')~=1
    files = dir([address '*.' type]);
    directoryNames = {files.name};
    directoryNames = directoryNames(~ismember(directoryNames,{'.','..','.DS_Store'}));
    [directorynames] = sort_nat(directoryNames);
end